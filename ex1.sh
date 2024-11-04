inputFile=$1
outputFile=$2
typ=$(sed -n '2p' $inputFile)
if [[ $typ == *"<students>"* ]]; then
	echo "student_name,student_id,student_email,programme,year,address,contact,module_id,module_name,module_leader,lecturer1,lecturer2,faculty,building,room,exam_mark,coursework1,coursework2,coursework3" > $2
	cat $inputFile | while read line; do
		case $line in
			*"</student>"*)
				echo "" >> $2
				continue
				;;
			*"xml"* | *"<students>"* | *"<student>"* )
				continue
				;;
			*"/students"*)
				break
				continue
				;;
			*)
				var="${line%"</"*}"
				tmp="${var#*">"}"
				printf "\"$tmp\"," >> $2
				;;


		esac
	done
elif [[ $typ == *"<faculties>"* ]]; then
	echo "faculty,building,room,capacity" > $2
	cat $inputFile | while read line; do
		case $line in
			**"<faculty>"*"</faculty>"*)
				var="${line%"</"*}"
				tmp="${var#*">"}"
				printf "\"$tmp\"," >> $2
				continue
				;;
			*"<faculties>"* | *"xml"* | *"<faculty>"*)
				continue
				;;
			*"</faculty"*)
				echo "" >> $2
			*"</faculties>"*)
				break
				;;
			*)
				var="${line%"</"*}"
				tmp="${var#*">"}"
				printf "\"$tmp\"," >> $2

		esac
	done
fi
