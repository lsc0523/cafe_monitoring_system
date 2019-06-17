#include <login.h>

#include <ESP8266WiFi.h>
#include <OneWire.h>
#include <DallasTemperature.h>
#include <WiFiClientSecure.h>

#include <Wire.h>
#include "iAQcore.h"

OneWire ourWire(D5);
DallasTemperature sensor(&ourWire);
login login1;
const char* host = "34.83.1.186";
String url = "/sensors?";
const int httpPort = 3000;
const char* ssid = "lol";   // Your own ssid here
const char* password = "adminadmin"; // Your own password here

iAQcore iaqcore;
int SOUND_SENSOR = D3;
int threshold = 25; //감도조절
int Sensor_value; 

String working() { 
  /********* Temperature Sensor **********/
  sensor.requestTemperatures();
  float temper = sensor.getTempCByIndex(0);
  Serial.print("temper: ");
  Serial.println(temper);
  
  /******* Air Quality Sensor ********/
  uint16_t eco2;
  uint16_t stat;
  uint32_t resist;
  uint16_t etvoc;
  
  iaqcore.read(&eco2,&stat,&resist,&etvoc);

  Serial.print("iAQcore: ");
  Serial.print("eco2=");   Serial.print(eco2);     Serial.print(" ppm,  ");
  Serial.print("stat=0x"); Serial.print(stat,HEX); Serial.print(",  ");
  Serial.print("resist="); Serial.print(resist);   Serial.print(" ohm,  ");
  Serial.print("tvoc=");   Serial.print(etvoc);    Serial.print(" ppb");
  Serial.println();
  
  /****** Volume Sensor ******/
  Sensor_value = analogRead(D3);   // Analog PIN D8에서 입력값을 읽어와서 Sensor_value에 저장
  Serial.print("volume value: ");
  Serial.println(Sensor_value);   // 시리얼모니터에 감도표시
  Serial.println("");

  return(String("temper=") + String(temper)+ "&" 
          + String("eco2_value=")+String(eco2)+"&"
          + String("tvoc_value=")+String(etvoc)+"&"
          +String("noise_value=")+String(Sensor_value));
}

void delivering(String payload) { 
  WiFiClient client;
  Serial.print("connecting to ");
  Serial.println(host);
  if (!client.connect(host, httpPort)) {
    Serial.print("connection failed: ");
    client.print("failed!\n");
    Serial.println(payload);
  }
  
  /* send to database 'mydb' through my ubuntu server*/
  String getheader = "GET "+ String(url) +"&"+ String(payload) +" HTTP/1.1";
  client.println(getheader);
  client.println("User-Agent: ESP8266 ChanYang Sim");  
  client.println("Host: " + String(host));  
  client.println("Connection: close");  
  client.println();
    

  //Serial.println(getheader);
  /*while(!!!client.available()){
      Serial.print("not available\n");
   }*/
  while (client.connected()) {
    String line = client.readStringUntil('\n');
    Serial.println(line);
  }
  Serial.println("Done cycle.");
}

void connect_wifi() {
  Serial.println();
  Serial.print("connecting to ");
  Serial.println(ssid);
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.print("\n Got WiFi, IP address: ");
  Serial.println(WiFi.localIP());  
}

void setup() {
  /* Serial setup */
  Serial.begin(115200);
  
  /* sound */
  Serial.println("Set up....");
  pinMode(SOUND_SENSOR, INPUT); 
  /* AQ setup */
  Wire.begin(/*SDA*/D2,/*SCL*/D1); 
  Wire.setClockStretchLimit(1000); // Default is 230us, see line78 of https://github.com/esp8266/Arduino/blob/master/cores/esp8266/core_esp8266_si2c.c
  // Enable iAQ-Core
  iaqcore.begin();
  
  connect_wifi();
  
}


void loop() {
     //connect_wifi();
     String payload = working();
     delivering(payload);
     
     delay(10000);

}
