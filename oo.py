#!/usr/bin/env python

from serial import Serial

br = 9600

try:
    o = Serial("/dev/ttyACM0", br)
except:
    o = Serial("/dev/ttyACM1", br)

from curses import *

x=0
y=15
w=24
h=16
lamp=[" ","1"]
i = initscr()

def write(write):
    o.write(chr(write[0]))
    o.write(chr(write[1]))
    o.write(chr(write[2]))
    i.addstr(32, 3, bin(write[0])+"     ")
    i.addstr(32, 13, bin(write[1])+"     ")
    i.addstr(32, 23, bin(write[2])+"     ")

def bang(w):
    i.addch(y,x,ord(lamp[w]))
    write([(x<<2)|0b01,(y<<2)|0b10,(w<<2)|0b11])
    i.addstr(30,3,str(x)+"  ")
    i.addstr(30,13,str(y)+"  ")
    i.addstr(30,23,str(w)+"  ")

def setall(wut):
    for x in range(w):
	for y in range(h):
	    i.addstr(y,x,lamp[wut])
    o.write(chr(wut<<2))

flop = 0

try:
    i.keypad(1)
    noecho()
    while 1:
	i.move(y,x)
	i.refresh()
	k = i.getch()
	if k == KEY_LEFT and x>0:
	    x-=1
	if k == KEY_RIGHT and x<w-1:
	    x+=1
	if k == KEY_UP and y>0:
	    y-=1
	if k == KEY_DOWN and y<h-1:
	    y+=1
	if k == 32:
	    bang ((i.inch()&255) == 32)
	if k == 10:
	    setall(flop)
	    flop = not flop
finally:
    endwin()

