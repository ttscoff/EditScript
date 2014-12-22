# EditScript

Proof of concept using Fuzzy File Finder to locate a script to edit
Searches a set of predefined locations for a fuzzy string
e.g. "mwp" matches both "myweatherprogram" and "mowthelawnplease"
         on "(m)y(w)eather(p)rogram" and "(m)o(w)thelawn(p)lease"

Results are ranked and a menu is displayed with the most likely
match at the top. Editor to be launched and directories to search
specified in CONFIG below.

EditScript is designed to work with a shallow set of configured search paths. I tend to keep most of my work in ~/scripts, ~/bin, and a couple of project folders. Search paths can be defined in your shell environment with $EDITSCRIPT\_PATH. You can also set default file extension constraints with $EDITSCRIPT\_TYPES. The file finder that EditScript uses will choke on results with upwards of about 5000 matches. It's not designed for deep traversal or handling large repositories.

### Author

Brett Terpstra

### Copyright

Copyright (c) 2011 Brett Terpstra. Licensed under the MIT License

### License

	The MIT License

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


