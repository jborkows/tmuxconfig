export FZF_DEFAULT_OPTS="--preview 'batcat -n --color=always {}' --bind 'f1:toggle-preview' --preview-window=right:70% --multi --ansi --reverse"
repo=$(git remote -v |grep origin| sed "s/:/ /" | sed "s/\s/ /" |cut -d" " -f3 |sed "s/\s*//"|sed "s/\.git//" | uniq )
echo "${repo}" | xargs -I {} gh run list --repo {} --json  databaseId,name,url,status,createdAt,conclusion --limit 100 |\
	jq -r '.[] | "\(.createdAt) -> \(.name) \(.databaseId) \(.conclusion)\t\(.| @base64)"' | fzf --delimiter='\t' \
        --header='f2 to delete, enter to open' \
	--preview='echo {2} | base64 --decode | jq -r '\''"Name \(.name) \(.databaseId) \(.conclusion) \nCreated At \(.createdAt)\nStatus \(.status)\n\(.url)"'\'''  \
	--bind="f2:abort+execute:for item in {+}; do id=\$(echo \${item}|sed 's/\s+/ /'|cut -f4 -d' '); echo \${id}; gh api -X DELETE /repos/${repo}/actions/runs/\${id}; done;" \
        | sed 's/\s+/ /' | sed 's/\t/ /' | cut -f6 -d ' ' |base64 --decode| jq -r '.url' |   xargs -I {} firefox {} ;



