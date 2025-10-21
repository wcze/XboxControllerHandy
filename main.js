const fs = require('fs');
const path = require('path');

const ahkDir = path.join(__dirname, 'ahk');
const outputDir = path.join(__dirname, 'output');
if (!fs.existsSync(outputDir)) fs.mkdirSync(outputDir);

const modulesOrder = [
    'header.ahk',
    'config.ahk',
    'xinputLoad.ahk',
    'mainLoopStart.ahk',
    'mouseControl.ahk',
    'scrollControl.ahk',
    'triggers.ahk',
    'tabSwitch.ahk',
    'dpadControl.ahk',
    'mouseButtons.ahk',
    'mainLoopEnd.ahk'
];

let content = modulesOrder.map(file => fs.readFileSync(path.join(ahkDir, file), 'utf-8')).join('\n\n');

fs.writeFileSync(path.join(outputDir, 'XboxControllerHandy.ahk'), content, 'utf-8');
console.log('output/XboxControllerHandy.ahk 创建完成');
