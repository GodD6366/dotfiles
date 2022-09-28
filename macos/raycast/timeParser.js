#!CURRENT_NODE_PATH

// Raycast Script Command Template
// https://github.com/raycast/script-commands
//
// Required parameters:
// @raycast.schemaVersion 1
// @raycast.title timeParser
// @raycast.mode fullOutput
//
// Optional parameters:
// @raycast.icon ⌚️
// @raycast.packageName time
// @raycast.argument1 { "type": "text", "placeholder": "时间戳" }

const dayjs = require('dayjs');
let [dateStr = ''] = process.argv.slice(2);

console.log(
  `当前时间：${dayjs(Number(dateStr)).format('YYYY-MM-DD HH:mm:ss')}`
);
