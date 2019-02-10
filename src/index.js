import './main.css';
import './editor.css';
import { Elm } from './Main.elm';
import registerServiceWorker from './registerServiceWorker';
import { writeFile, readFile, getSavedFiles } from './Ports/impl.ts';

var app = Elm.Main.init({
  node: document.getElementById('root')
});

app.ports.letToLoadFile.subscribe(function(filename) {
    readFile(filename).then(function(data) {
        app.ports.loadFileFromIDB.send(data);
    });
});

app.ports.saveFileToIDB.subscribe(function(file) {
    writeFile(file.name, file.content);
});

app.ports.requestStoredFiles.subscribe(function(_) {
    getSavedFiles().then(function(data) {
        app.ports.getStoredFiles.send(data);
    })
});

window.addEventListener('keydown', function(ev) {
    var ignore_events = [
        {key: 'a', shift: false, ctrl: true, alt: false, meta: false},
        {key: 'c', shift: false, ctrl: true, alt: false, meta: false},
        {key: 'x', shift: false, ctrl: true, alt: false, meta: false}
    ].map(JSON.stringify);

    var data = {
        key: ev.key,
        shift: ev.shiftKey,
        ctrl: ev.ctrlKey,
        alt: ev.altKey,
        meta: ev.metaKey
    };
    console.log(data);
    if(!(ev.ctrlKey || ev.altKey || ev.metaKey))
        return;
    if(ignore_events.includes(JSON.stringify(data)))
        return;
    app.ports.onKeyDownPosted.send(data);
    ev.preventDefault();
});

registerServiceWorker();
