function _complete_editscript()
{
	local word=${COMP_WORDS[COMP_CWORD]}
	if [[ -n $word ]]; then
		COMPREPLY=( $(editscript -s --nocolor $word | xargs basename | sed -e 's/ /\ /') )
	else
		COMPREPLY=()
	fi
}


complete -o bashdefault -o filenames -o default -o nospace -F _complete_editscript eds editscript  2>/dev/null || \
complete -o default -o filenames -o nospace -F _complete_editscript eds editscript
