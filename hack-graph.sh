#!/bin/sh

# Hack Contributions Graph
# author: @acauamontiel

retroactive () {
	file="dates.txt"

	rm -f $file
	touch $file

	git add $file

	for i in `seq 1 $1`
	do
		longdate=`date -j -v-${i}d`
		timestamp=$(date -j -f "%a %b %d %T %Z %Y" "${longdate}" "+%s")

		echo $timestamp >> $file

		git commit -am "commit of the day: ${longdate}" --date=$timestamp
	done
}

mapDates () {
	file="temp-${1}"

	rm -f $file
	touch $file

	git add $file

	while read timestamp
	do
		longdate=`date -r ${timestamp}`

		echo $timestamp >> $file

		git commit -am "commit of the day: ${longdate}" --date=$timestamp
	done <$1

	rm -f $file

	git add --all
	git commit --amend --no-edit
}

n='^[0-9]+$'
if [[ $1 =~ $n ]]
then
	retroactive $1
else
	mapDates $1
fi

echo "Pushing..."

git push -f

echo "Done!"
