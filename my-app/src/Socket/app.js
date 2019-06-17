var app = require('express')();
var http = require('http').Server(app);
var io = require('socket.io')(http);

app.get('/', function(req, res) {
   res.sendfile('index.html');
});

users = [];//เก็บข้อมูลของ user ที่เชื่อมต่อ
io.on('connection', function(socket) {
   console.log('Connected');
   //setUSername -> Group
   socket.on('setUsername', function(data) {
     //indexof ค้นหาชื่อใน array user ถ้าเจอก็ return เป็น index
      if(users.indexOf(data) > -1) {
          socket.emit('userExists', data + 'มีผู้ใช้ชื่อนี้แล้ว กรุณาใส่ชื่อใหม่');
      }else{
          users.push(data);
          socket.emit('userSet',{username: data});
      }
   })
   socket.on('msg', function(data) {
     //ส่งข้อความหาเพื่อนและกระจายข้อความกระจายข้อความให้ทุกคน
      io.sockets.emit('newmsg', data);
      //newmsg -> จัดการการแสดงผล ->
   })
});
http.listen(3000, function() {
   console.log('start server on port :3000');
});
