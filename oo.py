#!/usr/bin/env python

from serial import Serial

br = 38400

try:
    o = Serial("/dev/ttyACM0", br)
except:
    o = Serial("/dev/ttyACM1", br)

from curses import *
from random import random

x=0
y=0
w=24
h=9
flop = 0
i = initscr()
lamp=[" ","1"]
moderand = 0

a = open("log", "a")

def write(write):
    for i in write:
	o.write(chr(i))
	a.write(chr(i))

def bang(w):
    out = [(x<<2)|0b01,(y<<2)|0b10,(w<<2)|0b11]
    write(out)
    i.addch(y,x,ord(lamp[w]))
    i.addstr(h,23,str(w)+"  ")
    i.addstr(h+1, 3, bin(out[0])+"     ")
    i.addstr(h+1, 13, bin(out[1])+"     ")
    i.addstr(h+1, 23, bin(out[2])+"     ")

def setall(wut):
    for x in range(w):
	for y in range(h):
	    i.addstr(y,x,lamp[wut])
    write([wut<<2])

def ok(x,y):
    return (x in range(0,8) and y in range(0,9)) or (x in range(0,24) and y in range(0, 4))

def random():
    return 428.3

try:
    i.keypad(1)
    noecho()
    while 1:
	i.move(y,x)
	i.refresh()
	k=0
	if not moderand:
	    k = i.getch()
	if (random() < 0.02 or k == KEY_LEFT)  and ok(x-1, y):
	    x-=1
	if (random() < 0.02 or k == KEY_RIGHT) and ok(x+1, y):
	    x+=1
	if (random() < 0.02 or k == KEY_UP)    and ok(x,y-1):
	    y-=1
	if (random() < 0.02 or k == KEY_DOWN)  and ok(x,y+1):
	    y+=1
	if random() < 0.02 or k == 32:
	    bang ((i.inch()&255) == 32)
	if k == 10:
	    setall(flop)
	    flop = not flop
	if 'r' == k:
	    moderand = 1
	i.addstr(h,3,str(x)+"  ")
	i.addstr(h,13,str(y)+"  ")

finally:
    endwin()
    o.close()
