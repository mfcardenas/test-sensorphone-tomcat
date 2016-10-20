## Aplicación Web para Capturar Datos de Aceleración y Giroscopio

Embebida en Tomcat 8 para instanciar de forma rápida en máquina local.

#### Prerequisitos

- Maven 3.x (superior)
- Java JDK 8 (jdk_oracle)

#### Instrucciones

- Descargue el proyecto en su máquina
```
git clone https://github.com/mfcardenas/test-sensorphone-tomcat.git
```
- Ubiquese en el directorio base
```
cd test-sensorphone-tomcat
```

- Compile el pro
```
mvn package
```

- Recuerde, si modifica los fuentes del proyecto limpie y compile el proyecto nuevamente
```
mvn clean
mvn compile
```

- Desplegue el servidor web con la siguiente instrucción
```
sh target/bin/webapp
```

- Si utiliza Windows (recomiendo Linux), ejecute la siguiente instrucción:
```
C:/> target/bin/webapp.bat
```

Por defecto el servidor web publica por el puerto 8081.
Usando su router y desde su dispositivo movil consulte la siguiente dirección:
```
http://localhost:8081 (Desde su máquina local)
http://su-ip-local:8081 (Desde el dispositivo móvil)
```




