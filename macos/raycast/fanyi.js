#!CURRENT_NODE_PATH

// Raycast Script Command Template
// https://github.com/raycast/script-commands
//
// Required parameters:
// @raycast.schemaVersion 1
// @raycast.title fanyi
// @raycast.mode fullOutput
//
// Optional parameters:
// @raycast.icon 📖
// @raycast.packageName fy
// @raycast.argument1 { "type": "text", "placeholder": "请输入要翻译的单词", "optional": true }

const execa = require('execa');
const axios = require('axios');

let [word = ''] = process.argv.slice(2);

if (!word) {
  const { stdout } = execa.sync('pbpaste');
  word = stdout;
}

const isEnglish = new RegExp('[A-Za-z]+');

/**
 * ZH_CN2EN 中文　»　英语
 * EN2ZH_CN 英语　»　中文
 */
const YOUDAO_EN2ZH_CN =
  'http://fanyi.youdao.com/translate?&doctype=json&type=EN2ZH_CN&i=';

const YOUDAO_ZH_CN2EN =
  'http://fanyi.youdao.com/translate?&doctype=json&type=ZH_CN2EN&i=';

const YOUDAO_API =
  'http://fanyi.youdao.com/openapi.do?keyfrom=imgxqb&key=1185055258&type=data&doctype=json&version=1.1&q=';

const GOOGLE_API =
  'http://translate.google.cn/translate_a/single?client=gtx&dt=t&dj=1&ie=UTF-8&sl=auto&tl=zh_ch&q=';

const GOOGLE_API_CH2EN =
  'http://translate.google.cn/translate_a/single?client=gtx&dt=t&dj=1&ie=UTF-8&sl=zh_ch&tl=en&q=';

const errorList = [];

Promise.all([
  translateWithYoudao(),
  translateWithNewYoudao(),
  translateWithGoogle(),
])
  .then((values) => {
    const data = values.find((value) => value.success);
    console.log(`
翻译结果：${data.result.map((str) => `\n    - ${str}`)}

${
  data.explains
    ? `单词解释：${data.explains.map((str) => `\n    - ${str}`)}`
    : ''
}`);
  })
  .catch(() => {
    console.log(errorList.map((e) => `\n${e}`).join(''));
  });

function translateWithYoudao() {
  return axios
    .get(`${YOUDAO_API}${encodeURIComponent(word)}`)
    .then(function (response) {
      const { data } = response;
      return {
        success: true,
        name: '有道翻译',
        result: data.translation.map((tr) => tr),
        explains: data.basic.explains.map((tr) => tr),
      };
    })
    .catch(function (error) {
      errorList.push(`使用有道 API 翻译失败！报错信息如下：
        ${error.message}`);
      return { success: false };
    });
}

function translateWithNewYoudao() {
  let api = YOUDAO_EN2ZH_CN;
  if (!isEnglish.test(word)) {
    api = YOUDAO_ZH_CN2EN;
  }

  return axios
    .get(`${api}${encodeURIComponent(word)}`)
    .then(function (response) {
      const { data } = response;
      return {
        success: true,
        name: '有道翻译 v2',
        result: data.translateResult.map((tr) => tr[0].tgt),
      };
    })
    .catch(function (error) {
      errorList.push(`使用有道 NEWAPI 翻译失败！报错信息如下：
        ${error.message}`);
      return { success: false };
    });
}

function translateWithGoogle() {
  let api = GOOGLE_API;
  if (!isEnglish.test(word)) {
    api = GOOGLE_API_CH2EN;
  }

  return axios
    .get(`${api}${encodeURIComponent(word)}`)
    .then(function (response) {
      const { data } = response;
      return {
        success: true,
        name: '谷歌翻译',
        result: data.sentences.map((tr) => tr.trans),
      };
    })
    .catch(function (error) {
      errorList.push(`使用 Google API 翻译失败！报错信息如下：
        ${error.message}`);
      return { success: false };
    });
}
