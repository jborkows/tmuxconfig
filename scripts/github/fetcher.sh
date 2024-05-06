DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source "${DIR}/common.sh"
export FZF_DEFAULT_OPTS="--preview 'batcat -n --color=always {}' --bind 'f1:toggle-preview' --preview-window=right:70% --multi --ansi --reverse"
echo "${repo}" | xargs -I {} gh run list --repo {} --json  databaseId,name,url,status,createdAt,conclusion --limit 100 |\
	jq -r '.[] | "\(.createdAt) -> \(.name) \(.databaseId) \(.conclusion);\(.| @base64)"' | fzf --delimiter=';' \
        --header='f2 to delete, enter to open' \
	--preview='echo {2} | base64 --decode | jq -r '\''"Name \(.name) \(.databaseId) \(.conclusion) \nCreated At \(.createdAt)\nStatus \(.status)\n\(.url)"'\'''  \
	--bind="f2:abort+execute:for item in {+}; do id=\$(echo \${item}|cut -f2 -d';'|base64 --decode|jq -r '.databaseId'); echo \${id}; gh api -X DELETE /repos/${repo}/actions/runs/\${id};done;" \
	| cut -d';' -f2  | sed 's/\t/ /' | base64 --decode| jq -r '.url' |   xargs -I {} firefox {} ;



