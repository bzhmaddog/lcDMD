var SerialPort = require("serialport");
var fs = require('fs');
var keypress = require('keypress');

// make `process.stdin` begin emitting "keypress" events 
keypress(process.stdin);

process.stdin.setRawMode(true);
process.stdin.resume();


var port = new SerialPort(
				"COM6",
				{
					baudRate: 115200,
				},
				function() {
	
					port.on("data", function (data) {
						console.log(data[0]);
					});
				 
					// listen for the "keypress" event 
					process.stdin.on('keypress', function (ch, key) {
					  console.log('got "keypress"', key.name);
					  if (key && key.ctrl && key.name == 'c') {
						process.exit();
					  }
					  
						if (key.name == 'return') {
							port.write(189);
						}
					});

				}
			);
 
	
	

	//var data = fs.readFileSync('test3.bin');
	
	//port.write(new Buffer(data));
	//setInterval( function() {
	//port.write(' ');
	//},100);

//	var cnt= 0;
	

	
/*fs.open('test3.bin', 'r', function(err, fd) {
  if (err)
    throw err;
  var buffer = new Buffer(1);
  while (true)
  {   
    var num = fs.readSync(fd, buffer, 0, 1, null);
    if (num === 0)
      break;
    port.write(buffer[0]);
	cnt++;
  }
  
  console.log(cnt);
});	*/




