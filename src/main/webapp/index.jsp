<!DOCTYPE html>
<head>
    <title>UCM - Get Data Accelerations with Phone</title>
    <meta name="viewport" content="width=device-width,user-scalable=yes"/>
    <script src="js/teechart.js"></script>
    <style>
        body {
            font-family: helvetica, arial, sans serif;
        }

        #sphere {
            position: absolute;
            width: 30px;
            height: 30px;
            border-radius: 25px;
            -webkit-radius: 25px;
            background-color: red;
        }

        span {
            color: red;
        }

        ul {
            list-style: none;
        }

        #content { padding: 1em 2em;
            margin: 1em 2%;
        }

        h1 {
            text-align: center;
        }
    </style>
</head>
    <body onload="graficar();">
        <div id="content" >
            <div style="border:1px solid #efefef;">
                <h1>Datos del Aceler&oacute;metro</h1>
                <div id="sphere"></div>
                <ul>
                    <li>Axis X: <span id="accel-X"></span>g</li>
                    <li>Axis Y: <span id="accel-Y"></span>g</li>
                    <li>Axis Z: <span id="accel-Z"></span>g</li>
                </ul>
                <ul>
                    <li><label for="series">Axis:</label><select id="series"  onchange="addSeries(); Chart1.draw();">
                            <option value="1">1</option>
                            <option value="2">2</option>
                            <option value="3" selected>3</option>
                        </select>
                        &nbsp;  <label for="points">Puntos:</label><select id="points"  onchange="addSeries(); Chart1.draw();">
                            <option value="100">100</option>
                            <option value="200">200</option>
                            <option value="500" selected>500</option>
                            <option value="1000">1000</option>
                            <option value="2000">2000</option>
                            <option value="5000">5000</option>
                            <option value="10000">10000</option>
                            <option value="20000">20000</option>
                            <option value="50000">50000</option>
                        </select>
                    </li>
                </ul>
            </div>
            <div style="border:1px solid #efefef;">
                <canvas id="accelerometer-canvas" width="800" height="400">
                    Este navegador NO soporta Canvas para HTML5.
                </canvas>
            </div>
            <div style="border:1px solid #efefef;">
                <h1>Datos de Giroscopio</h1>
                <ul>
                    <li>Rotation Alpha: <span id="rotAlpha"></span> degree</li>
                    <li>Rotation Beta: <span id="rotBeta"></span> degree</li>
                    <li>Rotation Gamma: <span id="rotGamma"></span> degree</li>
                </ul>
            </div>
        </div>
        <script type="text/javascript">

            var x = 0, y = 0,
                    vx = 0, vy = 0,
                    ax = 0, ay = 0, accel_x=0, accel_y=0, accel_z=0;

            var sphere = document.getElementById("sphere");

            if (window.DeviceMotionEvent != undefined) {
                window.ondevicemotion = function (event) {
                    ax = event.accelerationIncludingGravity.x * 5;
                    ay = event.accelerationIncludingGravity.y * 5;
                    accel_x = parseFloat(event.accelerationIncludingGravity.x);
                    accel_y = parseFloat(event.accelerationIncludingGravity.y);
                    accel_z = parseFloat(event.accelerationIncludingGravity.z);
                    document.getElementById("accel-X").innerHTML = accel_x.toFixed(6);
                    document.getElementById("accel-Y").innerHTML = accel_y.toFixed(6);
                    document.getElementById("accel-Z").innerHTML = accel_z.toFixed(6);

                    if (event.rotationRate) {
                        var alpha = parseFloat(event.rotationRate.alpha);
                        var beta = parseFloat(event.rotationRate.beta);
                        var gamma = parseFloat(event.rotationRate.gamma);
                        document.getElementById("rotAlpha").innerHTML = alpha.toFixed(6);
                        document.getElementById("rotBeta").innerHTML = beta.toFixed(6);
                        document.getElementById("rotGamma").innerHTML = gamma.toFixed(6);
                    }
                }

                setInterval(function () {
                    var landscapeOrientation = window.innerWidth / window.innerHeight > 1;
                    if (landscapeOrientation) {
                        vx = vx + ay;
                        vy = vy + ax;
                    } else {
                        vy = vy - ay;
                        vx = vx + ax;
                    }
                    vx = vx * 0.98;
                    vy = vy * 0.98;
                    y = parseInt(y + vy / 50);
                    x = parseInt(x + vx / 50);

                    moverPuntero();

                    sphere.style.top = y + "px";
                    sphere.style.left = x + "px";

                }, 25);
            }


            function moverPuntero() {
                if (x < 0) {
                    x = 0;
                    vx = -vx;
                }
                if (y < 0) {
                    y = 0;
                    vy = -vy;
                }
                if (x > document.documentElement.clientWidth - 20) {
                    x = document.documentElement.clientWidth - 20;
                    vx = -vx;
                }
                if (y > document.documentElement.clientHeight - 20) {
                    y = document.documentElement.clientHeight - 20;
                    vy = -vy;
                }

            }

        </script>
        <script>
            var Chart1, size_buffer=1;

            function graficar() {
                Chart1 = new Tee.Chart("accelerometer-canvas");

                addSeries(3);
                setTransp(true);

                Chart1.legend.visible=false;
                Chart1.panel.format.gradient.visible=false;
                Chart1.panel.format.shadow.visible=false;

                Chart1.axes.left.title.text="Axis";
                Chart1.title.text="Accelerometer";

                Chart1.axes.left.grid.visible=false;
                Chart1.axes.top.grid.visible=false;
                Chart1.axes.right.grid.visible=false;
                Chart1.axes.bottom.grid.visible=false;

                var showCounter=new Tee.Annotation(Chart1);
                Chart1.tools.add(showCounter);

                Chart1.aspect.clip=false;

                var old= new Date().getTime(), oldx = 0;

                requestAnimFrame(newData, Chart1, 1);

                function newData(now) {

                    var dx = Chart1.series.items[0].data.values;
                    var xx = Chart1.series.items[0].data.x;
                    var tx;
                    var lx = dx.length;

                    for (tx=0; tx<size_buffer; tx++) {
                        dx[lx]= accel_x;
                        xx[lx]= xx[lx-1] + 0.001;
                        dx.shift();
                        xx.shift();
                    }

                    var dy = Chart1.series.items[1].data.values;
                    var yy = Chart1.series.items[1].data.x;
                    var ty;
                    var ly = dy.length;

                    for (ty=0; ty<size_buffer; ty++) {
                        dy[ly]= accel_y;
                        yy[ly]= yy[ly-1] + 0.001;
                        dy.shift();
                        yy.shift();
                    }

                    var dz = Chart1.series.items[2].data.values;
                    var zz = Chart1.series.items[2].data.x;
                    var tz;
                    var lz = dz.length;

                    for (tz=0; tz<size_buffer; tz++) {
                        dz[lz]= accel_z;
                        zz[lz]= zz[lz-1] + 0.001;
                        dz.shift();
                        zz.shift();
                    }

                    Chart1.draw();

                    if (!now) now=new Date().getTime();

                    if (showCounter.visible && ((now-old)>1000) ) {
                        var x=Chart1.series.items[0].data.x, last=x[x.length-1];
                        showCounter.text=((last-oldx)).toFixed(0)+" points/sec.";
                        old=now;
                        oldx=last;
                    }

                    requestAnimFrame(newData,Chart1,1);
                }
            }

            function addSeries() {

                var num=document.getElementById('series').value;
                var points=parseInt(document.getElementById('points').value);

                Chart1.series.items=[];

                for(var t=0; t<num; t++)
                    Chart1.addSeries(new Tee.Line()).format.shadow.visible=false;

                Chart1.series.each(function(series) {
                    series.addRandom(points,1);  // Add random points, with range 0..1000
                    series.data.x = new Array(points);
                    for(var t=0; t < points; t++){
                        series.data.x[t] = 0;
                    }
                });

            }

            function setTransp(value) {
                Chart1.panel.transparent = value;
                Chart1.walls.back.visible = !value;
            }
        </script>
    </body>
</html>
