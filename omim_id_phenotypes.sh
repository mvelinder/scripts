MIM=$1

echo "https://omim.org/entry/"$MIM
curl -s "https://api.omim.org/api/entry?mimNumber="$MIM"&include=text:clinicalFeatures,clinicalSynopsis&apiKey=e4euRWpfS--wPOX4Y6iSNQ" | grep -w "preferredTitle" | sed 's/<preferredTitle>//g' | sed 's/<\/preferredTitle>//g'

curl -s "https://api.omim.org/api/entry?mimNumber="$MIM"&include=text:clinicalFeatures,clinicalSynopsis&apiKey=e4euRWpfS--wPOX4Y6iSNQ" | grep -A 10000 "<clinicalSynopsis>" | grep -B 10000 "</clinicalSynopsis>" | grep -v "clinicalSynopsis" | sed 's/</\n/g' | sed 's/>/\n/g' | grep -v "^/"
