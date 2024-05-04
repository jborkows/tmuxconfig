DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source "${DIR}/common.sh"
if [ "$1" = "runs" ]; then
	bash "${DIR}/fetcher.sh"
fi

if [ "$1" = "pulls" ]; then
	bash "${DIR}/pulls.sh"
fi

if [ "$1" = "create issue" ]; then
	bash "${DIR}/createissue.sh"
fi
if [ "$1" = "issues" ]; then
	id=$(bash  "${DIR}/issues.sh")

	if [ -n "$id" ]; then

		if [[ $id == edit* ]]; then
			gh issue edit $(echo ${id}|sed "s/edit //") --repo ${repo} 
		elif [[ $id == comment* ]]; then
			gh issue comment $(echo ${id}|sed "s/comment //") --repo ${repo} 
		elif [[ $id == close* ]]; then
			gh issue close $(echo ${id}|sed "s/close //") --repo ${repo} 
		fi
	fi
fi
