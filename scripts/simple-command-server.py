#!/usr/bin/env python
"""
Very simple HTTP server in python.

Usage::
   simple-command-server.py  [<port>]

Send a GET request::
    curl http://localhost

Send a HEAD request::
    curl -I http://localhost

Send a POST request::
    curl -d "foo=bar&bin=baz" http://localhost

"""
from BaseHTTPServer import BaseHTTPRequestHandler, HTTPServer
import SocketServer
import os
import re
import sys

class S(BaseHTTPRequestHandler):
    def _set_headers(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/html')
        self.end_headers()

    def do_GET(self):
        self._set_headers()
        self.wfile.write("<html><body><h1>hi!</h1></body></html>")

    def do_HEAD(self):
        self._set_headers()
        
    def do_POST(self):
        content_length = int(self.headers['Content-Length']) # <--- Gets the size of data.
        post_data = self.rfile.read(content_length) # <--- Gets the data itself.
        self._set_headers()
        self.wfile.write("<html><body><h1>POST!</h1></body></html>")
        # Code in this function below this line has been added. The
        # posted data is expected to be a command of one of a few
        # specific types: e.g. to play a stream from tvheadend or to
        # insert text using xdotool. Buffer overflows and exploits
        # aside, this code does not execute generic commands.
        cmd = 'eval "' + post_data + '"' 
        if  re.match('/usr/local/bin/mpv http://shevek',post_data) is not None:
            os.system('killall mpv')
            os.system(cmd.replace('%20',' ').replace('%3f','?'))
        elif re.match('xdotool type',post_data) is not None:
            os.system(cmd.replace('%20',' ').replace('%3f','?'))
        elif re.match('i3',post_data) is not None:
            os.system(cmd.replace('%20',' ').replace('%3f','?'))
        else:
            sys.exit( "->" + post_data + "<-") # <--- Command rejected.
        
def run(server_class=HTTPServer, handler_class=S, port=8888):
    server_address = ('', port)
    httpd = server_class(server_address, handler_class)
    print 'Starting httpd...'
    httpd.serve_forever()

if __name__ == "__main__":
    from sys import argv

    if len(argv) == 2:
        run(port=int(argv[1]))
    else:
        run()
