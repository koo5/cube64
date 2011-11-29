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
flop = 0
i = initscr()
lamp=[" ","1"]

a = open("log", "a")

def write(write):
    for i in write:
	o.write(chr(i))
	a.write(chr(i))

def bang(w):
    out = [(x<<2)|0b01,(y<<2)|0b10,(w<<2)|0b11]
    write(out)
    i.addch(y,x,ord(lamp[w]))
    i.addstr(30,23,str(w)+"  ")
    i.addstr(32, 3, bin(out[0])+"     ")
    i.addstr(32, 13, bin(out[1])+"     ")
    i.addstr(32, 23, bin(out[2])+"     ")

def setall(wut):
    for x in range(w):
	for y in range(h):
	    i.addstr(y,x,lamp[wut])
    write([wut<<2])

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
	i.addstr(30,3,str(x)+"  ")
	i.addstr(30,13,str(y)+"  ")

finally:
    endwin()
    o.close()
