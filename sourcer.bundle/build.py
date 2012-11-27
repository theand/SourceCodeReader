
import cgi
from xml.sax.saxutils import escape

Maps = { \
"index.html": {"lang":"HTML", "prism-type": "markup"}, \
"normalize.css": {"lang":"CSS", "prism-type": "css"}, \
"prism.js": {"lang":"JS", "prism-type": "javascript"}, \
"CoreMatchers.java": {"lang":"Java", "prism-type" : "java"}, \
"mac.sh": {"lang":"Bash", "prism-type" : "bash"}, \
"core_proxy.clj": {"lang":"Clojure", "prism-type" : "clojure"}, \
"class-wp-ajax-response.php": {"lang":"PHP", "prism-type" : "php"}, \
"tokenizer.rb":  {"lang":"Ruby", "prism-type": "ruby"}, \
\
"php_stream_context.h":  {"lang":"C", "prism-type": "generic"}, \
"util.py":  {"lang":"Python", "prism-type": "generic"}\
}

prefix = open("prefix.html", "r").read()
postfix = open("postfix.html", "r").read()

for src in Maps.keys():
	file = open("sample_output/%s.html"%Maps[src]["lang"], "w+")
	total = prefix + escape(open("sample_source/%s"%src).read() ) + postfix
	file.write(total)
	file.close()

