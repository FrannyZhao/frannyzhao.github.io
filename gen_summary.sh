#!/bin/bash
summaryFile=summary.txt
rm -rf $summaryFile
tree Algorithms Android Basic_Knowledge CodeManagement Others | while read line
do
    #echo $line
    if [ "${line: 0-3}" == "pic" -o "${line: 0-3}" == "png" -o "${line: 0-3}" == "jpg" -o "${line: 0-3}" == "bmp" -o "${line: 0-3}" == "JPG" -o "${line: 0-4}" == "webp" ]; then
      continue
    fi
    if [ "$line" == "" ]; then
      break
    fi

    if [ "${line: 0:1}" == "│" -o "${line: 0:1}" == "└" -o "${line: 0:1}" == "├" ]; then
      if [ "${line: 0-2}" == "md" ]; then
        echo $line" is sub file"
        filename=`echo "$line" | awk -F " " '{printf($NF)}'`
        name1=`echo $filename | sed -e "s/.md//g"`
        name2=`echo $name1 | sed -e "s/\./ /g"`
        fileSummary=""
        i=0
        for name in `echo $name2`; do
          if [ $i == 0 ]; then
            fileSummary=$fileSummary"${name^}"
          else
            fileSummary=$fileSummary" ${name^}"
          fi
          let 'i+=1'
        done
        fileSummary=$fileSummary"]("$path"/"$filename")"
        echo "    * ["$fileSummary >> $summaryFile
      else
        echo $line" is sub dir"
        dirname=`echo "$line" | awk -F " " '{printf($NF)}'`
        path=$head"/"$dirname
        echo "  * "$dirname >> $summaryFile
      fi
    else
      echo $line" is head"
      head=$line
      path=$line
      echo "* "$line >> $summaryFile
    fi
done

echo ""
echo "summary:"
cat $summaryFile
