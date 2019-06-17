#ifndef login_h
#define login_h
#include "Arduino.h"
class login
{
    public:
        const char* ssid = "lol";
        const char* password = "adminadmin";
        String apiKey = "GPPV54XJUVXF4EL7";
        const char* host = "34.83.1.186";
        const char* getid();
        const char* getpw();
        String getapi();
        const char* gethost();
};

#endif
