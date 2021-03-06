= editscript

== Synopsis

Proof of concept using Fuzzy File Finder to locate a script to edit
Searches a set of predefined locations for a fuzzy string
e.g. "mwp" matches both "myweatherprogram" and "mowthelawnplease"
         on "(m)y(w)eather(p)rogram" and "(m)o(w)thelawn(p)lease"

Results are ranked and a menu is displayed with the most likely
match at the top. Editor to be launched and directories to search
specified in CONFIG below.

== Examples

Search through configured directories for "mwp"
editscript mwp

== Usage

editscript [options] "search string"

For help use: editscript -h

== Options

-s, --show         Show results without executing
-n, --no-menu      No menu interaction. Executes the highest ranked result
                 or, with '-s', returns a plain list of results
-1, --open_single   Don't show the menu if there's only one result
-a, --show-all     Show all results, otherwise limited to top 10
  --scores       Show match scoring with results
-d, --debug        Verbose debugging
-h, --help         help

== Author

Brett Terpstra

== License:

(The MIT License)

Copyright (c) Ryan Davis, seattle.rb

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
