#!CURRENT_NODE_PATH

// Raycast Script Command Template
// https://github.com/raycast/script-commands
//
// Required parameters:
// @raycast.schemaVersion 1
// @raycast.title cdn
// @raycast.mode fullOutput
//
// Optional parameters:
// @raycast.icon ✈️
// @raycast.packageName cdn
// @raycast.argument1 { "type": "text", "placeholder": "输入 github 地址", "optional": true }

const execa = require('execa');

const REG = /.*\/gh\/([^\/]+)\/([^\/]+)\/([^\/]+).*/;

let [link = ''] = process.argv.slice(2);

if (!link) {
  const { stdout } = execa.sync('pbpaste');
  link = stdout;
}

console.log(`${fnGetCDNUrl(link)}`);

// https://github.com/lhie1/Rules/blob/master/Clash/Provider/Media/Disney%20Plus.yaml
// https://raw.githubusercontent.com/lhie1/Rules/master/Clash/Provider/Media/Disney%20Plus.yaml

// https://cdn.jsdelivr.net/gh/lhie1/Rules@master/Clash/Provider/Media/Disney%20Plus.yaml

function fnGetCDNUrl(url) {
  const arrMap = [
    ['https://github.com/', 'https://cdn.jsdelivr.net/gh/'],
    ['https://raw.githubusercontent.com/', 'https://cdn.jsdelivr.net/gh/'],
    ['/blob', ''],
  ];
  let cdnUrl = url;
  arrMap.forEach((line) => {
    cdnUrl = cdnUrl.replace(line[0], line[1]);
  });

  const [_, githubName, projectName, br] = REG.exec(cdnUrl);
  return cdnUrl.replace(
    `${githubName}/${projectName}/${br}`,
    `${githubName}/${projectName}@${br}`,
  );
}
