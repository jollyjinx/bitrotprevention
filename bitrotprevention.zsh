#!/bin/zsh
#
# author: Patrick Stein aka jolly
#
# start this script from the command line every month to read the data on all connected disks despite their
# partitioning
#

disks=(`find /dev -name 'rdisk*' -name '*s[0-9]'  -user root |perl -ne 'print $1."\n" if m#/dev/rdisk(\d+)s#;'|sort -u`) 2>/dev/null

sudo echo "access granted" || exit;

for disknumber in $disks
do
	if [ -e /dev/rdisk$disknumber ]
	then
		echo Starting readout of disk: $disknumber
		sudo dd if=/dev/rdisk$disknumber of=/dev/null bs=262144 &
fi
done

wait

ioreg -lw 0| grep Statistics |perl -ne 'while(/\"(?:retries|errors)\s*\(\S+\)\"=(\d+)/igm ){print "Disk has problem:".$&."\n" if $1!=0;}'                                                                                                                                                          

echo finished check.


