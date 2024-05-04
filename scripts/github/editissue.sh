DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source "${DIR}/common.sh"
id=$(echo "${1}" |cut -d$'\t' -f2|base64 --decode|jq -r '.id')
gh issue edit ${id} --repo "${repo}" 
