DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source "${DIR}/common.sh"
export FZF_DEFAULT_OPTS="--preview 'batcat -n --color=always {}' --bind 'f1:toggle-preview' --preview-window=right:40% --ansi --reverse"

echo "${repo}" | xargs -I {}  gh issue list --json id,labels,state,url,milestone,createdAt,updatedAt,assignees,author,title,number --repo {} --limit 100 |
        jq -r '.[] | "\(.updatedAt) -> \(.title) \(.author.login) \(.labels)\t\(.| @base64)"' | fzf --delimiter='\t' \
        --header='enter to open;ctrl+a to self assign;ctrl+e to edit' \
        --preview='echo {2} | base64 --decode | jq -r '\''"Name \(.title) \(.number) \nCreated At \(.createdAt) Updated \(.updatedAt)\nState \(.state)\n\(.url)\nlabels \(.labels)\nassignees \(.assignees)"'\'''  \
	--bind="ctrl-a:execute:echo {}|cut -d$'\t' -f2|base64 --decode|jq -r '.number'|xargs -I % gh issue edit --repo ${repo} --add-assignee \"@me\" %" \
	--bind="ctrl-e:abort+become:echo {}|cut -d$'\t' -f2|base64 --decode|jq -r '.number' " \
        --bind="enter:abort+become:echo {}|cut -d$'\t' -f2 |base64 --decode| jq -r '.url' | xargs -I % firefox % ";

