import sys
from sense_hat import SenseHat
# from sense_emu import SenseHat
red = (255,0,0)
sense=SenseHat()
sense.show_message(str(sys.argv[1]),scroll_speed=0.1,text_colour=red)


