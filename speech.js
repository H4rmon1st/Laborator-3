document.addEventListener("touchstart",on_touch);
document.addEventListener("mousedown",on_touch);
var recognition = new webkitSpeechRecognition();
recognition.lang = 'en-US';
function on_touch()
{
	if(recognition.start)
	{
		recognition.start();
		recognition_started=true;
	}
}
function onend()
{
	recognition.stop();
	recognition_started=true;
}
recognition.onend=onend;
recognition.onsoundend=onend;
recognition.onspeechend=onend;
recognition.onresult=on_result;

function on_results(e)
{
	document.getElementById("text").innerHtml+="Ati rostit cuvantul: "+ e.results[0][0].transcript + ", acuratete: " +e.results[0][0].confidence + "<br>"
	
}