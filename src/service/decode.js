const decode = (data) => {
  return decodeURIComponent(escape(atob(reverse(data.slice(0, -5)))))
}
function reverse (s) {
  return s.split('').reverse().join('')
}
export default {
  decode
}
