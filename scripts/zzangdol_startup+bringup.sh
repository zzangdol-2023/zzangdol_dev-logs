#!/usr/bin/env bash

NORMAL_SLEEP=15
ERROR_SLEEP=2

bringup() {
	echo -n "usb_config arg : "
	read usb_config_arg
		nohup roslaunch zzangdol_bringup zzangdol_bring_all.launch usb_config:=$usb_config_arg record:=true 1>/dev/null 2>zzangdol_bringup_error.log &
	echo "Bringup Launch..."
	sleep $NORMAL_SLEEP
}
if [ -f "zzangdol_bringup_error.log" ];then
	rm zzangdol_bringup_error.log #remove error log file
fi
bringup
while read line || [ -n "$line" ];do
	echo "Bringup Failed..."
	killall roslaunch
	sleep $ERROR_SLEEP
	rm zzangdol_bringup_error.log
	bringup
done < zzangdol_bringup_error.log
echo "Bringup Completed"

echo "Launch zzangdol_cartographer localiza  tion load_state_file=2F_bag_2round_ver2 rviz=false"
nohup roslaunch zzangdol_cartographer carto_localization.launch  load_state_filename:=2F_bag_2round_ver2 rviz:=false 1>/dev/null 2>zzangdol_localization_error.log &
sleep $NORMAL_SLEEP

echo "Press any key to continue..."
read

roslaunch zzangdol_navigation move_base_test.launch rviz:=false 1>/dev/null 2>zzangdol_move_base_error.log
echo "Launch zzangdol_navigation move_base"
sleep $NORMAL_SLEEP

echo "Press any key to continue..."
read
# rosrun zzangdol_navigation current_pose_publisher.py
# nohup rosrun zzangdol_navigation current_pose_publisher.py 1>/dev/null 2>&1 &
# sleep $NORMAL_SLEEP
# rosrun zzangdol_navigation goal_publisher_actionlib.py
