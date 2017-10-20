#!/bin/zsh
start=$SECONDS

echo 'Gathering functions'
grep -rRh 'func [[:alnum:]]*' **/*.swift > raw_functions.txt
cat raw_functions.txt | grep -v '@IBAction' | grep -v ' override ' | grep -v 'func test' > filtered_functions.txt

cat filtered_functions.txt | grep -rRoh 'func [[:alnum:]]*' | sort | uniq | grep -o '[[:alnum:]]*$' > unique_functions.txt

FUNCTIONS_COUNT=`cat unique_functions.txt | wc -l`
echo "There are ${FUNCTIONS_COUNT} potential functions found"

echo "Gathering usage information"
cat unique_functions.txt | while read line
do
	FOUND_ITEMS=`grep -r "$line" **/*.swift | wc -l`
	if [ "1" -eq "$FOUND_ITEMS" ]; then
		echo "$line $FOUND_ITEMS"
	fi    
done > usage.txt

FUNCTIONS_WIT_LOW_USAGE=`cat usage.txt | wc -l`
echo "There are ${FUNCTIONS_WIT_LOW_USAGE} potential functions to be deleted found"

cat usage.txt | sort -nk2 > sorted_usage.txt

echo "Gathering usage per each of them"
cat sorted_usage.txt | while read line
do
	NAME=`echo $line | grep -o '[[:alnum:]]*'`
	USAGES=`grep -rR -C 3 "$NAME" **/*.swift`
	echo "---- $NAME ----"
	echo "$USAGES"
  echo ""
done > delete_me.txt

echo "It took $((SECONDS-start)) seconds."