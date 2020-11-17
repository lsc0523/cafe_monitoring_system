var express = require('express');
var app = express();

mysql = require('mysql');
var connection = mysql.createConnection({
    host: 'localhost',
    user: 'me',
    password: 'mypassword',
    database: 'mydb'
})
connection.connect();

function insert_sensor(person_count,total_seat,temper,dust_value) {
  obj = {};
  obj.person_count=person_count;
  obj.total_seat=total_seat;
  obj.temper=temper;
  obj.dust_value=dust_value;

  var query = connection.query('insert into sensors set ?', obj, function(err, rows, cols) {
    if (err) throw err;
    console.log("database insertion ok= %j", obj);
  });
}

/* make change */

/*
app.get('/', function(req, res) {
        res.json({content:100,content2:500})
});*/

app.get('/log', function(req, res) {
  r = req.query;
  console.log("GET %j", r);

  insert_sensor(r.person_count,r.total_seat,r.temper,r.dust_value,req.connection.remoteAddress);




  res.end('OK:' + JSON.stringify(req.query));
});

app.get('/req', function(req,res){

  var sql = 'SELECT * FROM sensors';
  connection.query(sql, function(err,rows,fields){
        if (err) console.log(err);
        //console.log('rows',rows);
        //console.log('fields',fields);
         /*for( var i =0;i<rows.length;i++){
                console.log(rows[i].person_count + " / " +rows[i].total_seat);
        }*/
        //for (var i = rows.length-1; ;i--){
        var i = rows.length-1;
        var j = i;
        /*while(1){
            if(rows[j].person_num != 0) break;
            else j--;
        }*/
            
        rows[0].dust_value=parseInt(rows[i].dust_value);
          res.json({connect:100 ,person_num:rows[i].person_count , total_seat:rows[i].total_seat , gas:rows[i].dust_value})

  });


});

var server = app.listen(9000, function () {
  var host = server.address().address
  var port = server.address().port
  console.log('listening at http://%s:%s', host, port)
});
