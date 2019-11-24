#!/usr/bin/env bash
maxcol=100
maxrow=63
maxtrees=6

echo "How Many Trees? [1-$maxtrees]"
read tree
let "branches=2**$tree"
let "treesize=(2**($maxtrees-$tree)) / 2"
count=0
branchop="+1"
treeflag=0

#setup initial branch positions
leftbranchstart=$(( ($maxcol / 2) - (($branches-1) * ($treesize))  ))
rightbranchend=$(( ($maxcol / 2) + (($branches-1) * ($treesize)) ))
leftbranchend=$(((($maxcol / 2)-$treesize)))
rightbranchstart=$((($maxcol / 2)+$treesize))

for x in $(seq $leftbranchstart $(($treesize*2)) $leftbranchend); do
	branchpositions[$i]=$x
	let i+=1
done

i=0

for x in $(seq $rightbranchstart $(($treesize*2)) $rightbranchend); do
	branchpositions=(${branchpositions[@]} $x)
        let i+=1
done

for row in $(seq 1 1 $maxrow); do

        if [ $treeflag -eq 1 ]; then let count+=1; fi

	if [ $treeflag != 2 ]; then
		i=0
		unset branchpositions

        	for x in $(seq $leftbranchstart $(($treesize*2)) $leftbranchend); do
                	if [ $branchop == "+1" ]; then
                        	let branchpositions[$i]=$(($x+$count))
                        	branchop="-1"
                	else
                        	let branchpositions[$i]=$(($x-$count))
                        	branchop="+1"
                	fi
                	let i+=1
        	done

	        for x in $(seq $rightbranchstart $(($treesize*2)) $rightbranchend); do
        	        if [ $branchop == "+1" ]; then
                	        branchpositions=(${branchpositions[@]} $(($x+$count)))
                        	branchop="-1"
                	else
                        	branchpositions=(${branchpositions[@]} $(($x-$count)))
                        	branchop="+1"
                	fi
        	done
	fi

	for col in $(seq 1 1 $maxcol); do
		if [ $row -ge $((2**($maxtrees-$tree))) ] && [ $row -lt $(((2**($maxtrees-$tree))+$treesize)) ]; then 
			treeflag=1		
			for i in ${branchpositions[@]}; do
				if [ $col -eq $i ]; then
					printchar="1"
				elif [ "$printchar" != "1" ]; then
					printchar="_"
				fi
				lastI=$(($i))
			done
			
			printf $printchar	
			printchar="_"

		elif [ $row -ge $(((2**($maxtrees-$tree)+$treesize))) ] && [ $row -lt $(( (2**($maxtrees-$tree))+$treesize*2 )) ]; then
			treeflag=2
			count=0
			for i in ${branchpositions[@]}; do
				if [ $col -eq $i ]; then
					printchar='1'
				elif [ "$printchar" != "1" ]; then
					printchar='_'
				fi
			done

			printf $printchar
			printchar="_"

		elif [ $row -lt $((2**($maxtrees-$tree))) ]; then
			printf '_'
			treeflag=0
		else	
			if [ $tree -lt 1 ]; then
				exit 0
			fi
			let tree-=1
			let "branches=2**$tree"
			let "treesize=(2**($maxtrees-$tree)) / 2"	
			treeflag=0

			unset branchpositions
			leftbranchstart=$(( ($maxcol / 2) - (($branches-1) * ($treesize))  ))
			rightbranchend=$(( ($maxcol / 2) + (($branches-1) * ($treesize)) ))
			leftbranchend=$(((($maxcol / 2)-$treesize)))
			rightbranchstart=$((($maxcol /2)+$treesize))

			i=0

			for x in $(seq $leftbranchstart $(($treesize*2)) $leftbranchend); do
        			branchpositions[$i]=$x
        			let i+=1
			done

			for x in $(seq $rightbranchstart $(($treesize*2)) $rightbranchend); do
        			branchpositions=(${branchpositions[@]} $x)
			done
			
			printf '_'
		fi	
	done	

	echo

done
