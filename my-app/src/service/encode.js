const encode = (data) => {
  return reverse(btoa(unescape(encodeURIComponent(JSON.stringify(data))))) + randomString(5)
}
function reverse (s) {
  return s.split('').reverse().join('')
}

function randomString (num) {
  var text = ''
  var possible = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
  for (var i = 0; i < num; i++) {
    text += possible.charAt(Math.floor(Math.random() * possible.length))
  }
  return text
}

export default {
  encode
}
