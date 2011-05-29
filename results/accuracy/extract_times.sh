#!/bin/bash
for y in blas cuda
do
	rm -f ${y}times
	touch ${y}times
	for x in 32 48 64 80 96 128
	do
		cat size${x}x${x}/no_perturb/${y}_recognition_output_keepers_20.txt | cut -d' ' -f8 > temptimes;
		paste -d' ' ${y}times temptimes > temptimes2
		mv temptimes2 ${y}times
	done
done

mfile=recognition_times.m
rm -f $mfile
echo "res=[32 48 64 80 96 128];" >> $mfile
for y in blas cuda
do
	echo "${y}times=[" >> $mfile
	cat ${y}times >> $mfile
	echo "];">> $mfile 
	echo "${y}times = mean(${y}times,1);" >> $mfile
done

rm -f temptimes cudatimes blastimes
