import QtQuick 2
import org.kde.plasma.core 2.0 as PlasmaCore

Rectangle {
    id: root
    color: wallpaper.configuration.BGColor

    Canvas {
	id: canvas
	width: root.width
	height: root.height

	property var hours: shuffle([0,1,2,3,4,5,6,7,8,9,10,11])
	property var square: wallpaper.configuration.Layout === 1
	property var continuous: wallpaper.configuration.TickSpeed === 0

	function shuffle(list) {
	    list.sort((a,b) => 0.5 - Math.random());
	    return list;
	}

	function drawLine(ctx, angle, len) {
	    const dx = square ? Math.min(width, height) : width;
	    const dy = square ? Math.min(width, height) : height;

	    ctx.beginPath();
	    ctx.moveTo(width / 2, height / 2);
	    ctx.lineTo((width / 2) + (len * Math.cos(angle) * (dx / 2)),
		       (height / 2) + (len * Math.sin(angle) * (dy / 2)));
	    ctx.stroke();
	}

	function drawNums(ctx) {
	    const dx = square ? Math.min(width, height) : width;
	    const dy = square ? Math.min(width, height) : height;

	    for (let i = 0; i < hours.length; i++) {
		ctx.fillText(hours[i] + 1,
			     (width / 2) + (0.8 * Math.cos(Math.PI * i / 6) * (dx / 2)),
			     (height / 2) + (0.8 * Math.sin(Math.PI * i / 6) * (dy / 2)));
	    }
	}

	onPaint: {
	    const ctx = getContext("2d");
	    
	    ctx.fillStyle = wallpaper.configuration.BGColor;
	    ctx.fillRect(0,0,width,height);
	    
	    ctx.fillStyle = Qt.rgba(0,0,0,1);
	    ctx.strokeStyle = Qt.rgba(0,0,0,1);
	    ctx.lineWidth = 6;
	    ctx.lineCap = "round";
	    
	    ctx.textBaseline = "middle";
	    ctx.textAling = "center";
	    ctx.font = "18pt sans-serif";
	    
	    drawNums(ctx);
	    
	    const time = Date.now() / 1000 / 60;
	    const minute = time % 60;
	    const hour = ((time / 60) - ((new Date()).getTimezoneOffset() / 60)) % 12;
	    const startHour = hours.indexOf(Math.floor(hour + 11) % 12);
	    const endHour = hours.indexOf(Math.floor(hour) % 12);
	    const startMinute = hours.indexOf(Math.floor(minute / 5 + 11) % 12);
	    const endMinute = hours.indexOf(Math.floor((minute / 5)));
	    
	    drawLine(ctx, Math.PI * (startMinute + (((endMinute - startMinute + 12) % 12) * ((minute % 5) / 5))) / 6, 0.7);
	    
	    drawLine(ctx, Math.PI * (startHour + (minute / 60) * ((endHour - startHour + 12) % 12)) / 6, 0.5);

	    if (continuous) {
		requestAnimationFrame(paint);
	    }
	}

	function repaint() {
	    if (!continuous) {
		requestPaint();
	    }
	}

	Timer {
	    running: true
	    repeat: true
	    interval: 1000
	    onTriggered: canvas.repaint()
	}
    }
}
