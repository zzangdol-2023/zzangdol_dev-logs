#!/usr/bin/env bash

NORMAL_SLEEP=15

ps -C roslaunch 1>/dev/null 2>&1 #confirm bringup
if [ $? -eq 0 ];then
	echo "Confirm Bringup"
	nohup roslaunch zzangdol_cartographer carto_localization.launch 1>/dev/null 2>&1 &
	echo "Launch zzangdol_cartographer localization"
	echo "Press any key to continue..."
	read

	nohup roslaunch zzangdol_navigation move_base_test.launch 1>/dev/null 2>&1 &
	echo "Launch zzangdol_navigation move_base"
	sleep $NORMAL_SLEEP

	echo "Press any key to publish goals..."
	read
	python3 goal_publisher_actionlib.py
else
	echo "Bringup Failed..."
fi
