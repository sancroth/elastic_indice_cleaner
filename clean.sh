#!/bin/bash
add_date=0
add_date_err=0
expected_output="{\"acknowledged\":true}"
num_ind_del=$(ls /data/siemonster/nodes/0/indices/ | grep $(python /opt/indice_cleaner.py) | wc -l)

if [ $num_ind_del -gt 0 ];then

ls /data/siemonster/nodes/0/indices/ | grep $(python /opt/indice_cleaner.py) | while read line;
do
	output=$(curl -XDELETE "http://localhost:9200/$line")
	echo $output
	if [ ! -f /var/log/indice_cleaner.log ];then
		if [ $output == $expected_output ];then
			if [ $add_date -eq 0 ];then
				echo "Automated Indice Deletion of : $(date). Indices to Delete : $(python /opt/indice_cleaner.py)" > /var/log/indice_cleaner.log
				echo "">> /var/log/indice_cleaner.log
				add_date=$(($add_date+1))
			fi
			echo "$line was succesfully deleted with output $expected_output" >> /var/log/indice_cleaner.log
		else
			if [ $add_date_err -eq 0 ];then
                                echo "Automated Indice Deletion of : $(date). Indices to Delete : $(python /opt/indice_cleaner.py)" > /var/log/indice_cleaner.log
                                echo "">> /var/log/indice_cleaner.log
                                add_date_err=$(($add_date_err+1))
                        fi
			echo "$line deletion encountered some error. --Try ls /data/siemonster/nodes/0/indices/ | grep $line -- to check for existance." >> /var/log/indice_cleaner.err
		fi
	else
	        if [ $output == $expected_output ];then
                        if [ $add_date -eq 0 ];then
                                echo "Automated Indice Deletion of : $(date). Indices to Delete : $(python /opt/indice_cleaner.py)" >> /var/log/indice_cleaner.log
                                echo "">> /var/log/indice_cleaner.log
                                add_date=$(($add_date+1))
                        fi
                        echo "$line was succesfully deleted with output $expected_output" >> /var/log/indice_cleaner.log
                else
                        if [ $add_date_err -eq 0 ];then
                                echo "Automated Indice Deletion of : $(date). Indices to Delete : $(python /opt/indice_cleaner.py)" >> /var/log/indice_cleaner.log
                                echo "">> /var/log/indice_cleaner.log
                                add_date_err=$(($add_date_err+1))
                        fi
                        echo "$line deletion encountered some error. --Try ls /data/siemonster/nodes/0/indices/ | grep $line -- to check for existance." >> /var/log/indice_cleaner.err
                fi
	fi
done

else
        if [ ! -f /var/log/indice_cleaner.log ];then
		echo "Automated Indice Deletion of : $(date). Indices to Delete : $(python /opt/indice_cleaner.py)" > /var/log/indice_cleaner.log
		echo "No indices found matching the expected date.They might already be deleted of have never been created." >> /var/log/indice_cleaner.log
	else
		echo "Automated Indice Deletion of : $(date). Indices to Delete : $(python /opt/indice_cleaner.py)" >> /var/log/indice_cleaner.log
                echo "No indices found matching the expected date.They might already be deleted of have never been created." >> /var/log/indice_cleaner.log
	fi
fi
