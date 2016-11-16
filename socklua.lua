
-- Socket Service for sending data


-- Your access point's SSID and password
local SSID = ""
local SSID_PASSWORD = ""
local HOST = "192.168.0.7"
local pin = 0


-- configure ESP as a station
wifi.setmode(wifi.STATION)
wifi.sta.config(SSID,SSID_PASSWORD)
wifi.sta.autoconnect(1)

local cu = net.createConnection(net.TCP)

-- sending alarm
function send()
    cu:on("receive",display)
    cu:connect(8124,HOST)
    cu:send("data from sock lua...") 
end

-- appready, listening changes in the gpio inputs and send alarm with the socket
function appready()
    tmr.alarm(1,9000,1,function() 
       gpio.mode(pin,gpio.INPUT)
       --print(gpio.read(pin))
       if wifi.sta.status() == 5 then
           if gpio.read(pin) == 1 then
              send()
              tmr.stop(1)
           end
       else
           print(wifi.sta.status())
       end
    end)
end

appready()


