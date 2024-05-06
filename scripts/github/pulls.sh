DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source "${DIR}/common.sh"
export FZF_DEFAULT_OPTS="--preview 'batcat -n --color=always {}' --bind 'f1:toggle-preview' --preview-window=right:70% --ansi --reverse"

echo "${repo}" | xargs -I {} gh pr list --json number,state,title,author,id,labels,isDraft,comments,createdAt,updatedAt,url,mergeable --repo {} --limit 100 |
	jq -r '.[] | "\(.updatedAt) -> \(.title) \(.author) \(.mergeable)\t\(.| @base64)"' | fzf --delimiter='\t' \
        --header='enter to open' \
	--preview='echo {2} | base64 --decode | jq -r '\''"
Name \(.title) \(.number) Draft \(.isDraft)
Created At \(.createdAt) Updated \(.updatedAt)
Author \(.author.login)
\(.url)
Comments 
  \(if .comments | length > 0 then (.comments[] | "\(.author.login) \(.body)") else "No comments" end)"   '\'''  \
        | cut -f2 -d$'\t'  |  sed 's/\s+//' | base64 --decode| jq -r '.url' |   xargs -I {} firefox {} ;

