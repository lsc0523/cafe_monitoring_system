#include"Arduino.h"
#include"login.h"

const char* login::getid()
{
    return ssid;
}
const char* login::getpw()
{
    return password;
}
String login::getapi()
{
    return apiKey;
}
const char* login::gethost()
{
    return host;
}
