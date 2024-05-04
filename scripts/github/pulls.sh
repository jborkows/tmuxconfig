
export FZF_DEFAULT_OPTS="--preview 'batcat -n --color=always {}' --bind 'f1:toggle-preview' --preview-window=right:70% --ansi --reverse"

repo=$(git remote -v |grep origin| sed "s/:/ /" | sed "s/\s/ /" |cut -d" " -f3 |sed "s/\s*//"|sed "s/\.git//" | uniq )
echo "${repo}" | xargs -I {} gh pr list --json number,state,title,author,id,labels,isDraft,comments,createdAt,updatedAt,url,mergeable --repo {} --limit 100 |
	jq -r '.[] | "\(.updatedAt) -> \(.title) \(.author) \(.mergeable)\t\(.| @base64)"' | fzf --delimiter='\t' \
        --header='enter to open' \
	--preview='echo {2} | base64 --decode | jq -r '\''"Name \(.title) \(.id) \(.isDraft) \nCreated At \(.createdAt) Updated \(.updatedAt)\nStatus \(.status)\n\(.url)\n Comments \(.comments)"'\'''  \
        | sed 's/\s+/ /' | sed 's/\t/ /' | cut -f4 -d ' ' |base64 --decode| jq -r '.url' |   xargs -I {} firefox {} ;

