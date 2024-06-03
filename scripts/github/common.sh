export repo=$(git remote -v |grep origin| sed "s/:/ /" | sed "s/\s/ /" |cut -d" " -f3 |sed "s/\s*//"|sed "s/\.git//" | uniq | sed 's|^/||')
