DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source "${DIR}/common.sh"
export FZF_DEFAULT_OPTS="--preview 'batcat -n --color=always {}' --bind 'f1:toggle-preview' --preview-window=right:70% --ansi --reverse"

echo "${repo}" | xargs -I {} gh pr list --json number,state,title,author,id,labels,isDraft,comments,createdAt,updatedAt,url,mergeable --repo {} --limit 100 |
	jq -r '.[] | "\(.updatedAt) -> \(.title) \(.author) \(.mergeable)\t\(.| @base64)"' | fzf --delimiter='\t' \
        --header='enter to open' \
	--preview='echo {2} | base64 --decode | jq -r '\''"Name \(.title) \(.id) \(.isDraft) \nCreated At \(.createdAt) Updated \(.updatedAt)\nStatus \(.status)\n\(.url)\n Comments \(.comments)"'\'''  \
        | sed 's/\s+/ /' | sed 's/\t/ /' | cut -f4 -d ' ' |base64 --decode| jq -r '.url' |   xargs -I {} firefox {} ;

