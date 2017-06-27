#!/bin/sh
#
# PROVIDE: cbsdrctl
# REQUIRE: LOGIN FILESYSTEMS sshd
# KEYWORD: shutdown
#
# cbsd_rctl_enable="YES"
#

. /etc/rc.subr

name=cbsdrctl
rcvar=cbsdrctl_enable
load_rc_config $name

start_cmd=${name}_start
stop_cmd=${name}_stop
status_cmd="${name}_status"
restart_cmd=${name}_restart
extra_commands="restart"

# Set defaults
: ${cbsdrctl_enable:="NO"}
: ${cbsdrctl_interval:="15"}
: ${cbsdrctl_root:="/tmp/metrics/rctl"}

cbsdrctl_start()
{
	if [ -r ${pidfile} ]; then
		echo "Already running: `cat ${pidfile}`"
		exit 0
	fi
	/usr/sbin/daemon -f -p ${pidfile} /root/bin/cbsdrctl -r ${cbsdrctl_root} -i ${cbsdrctl_interval}
	echo "STARTED: -r ${cbsdrctl_root} -i ${cbsdrctl_interval}"
}

cbsdrctl_status()
{
	if [ -f "${pidfile}" ]; then
		pids=$( pgrep -F ${pidfile} 2>&1 )
		_err=$?
		if [ ${_err} -eq  0 ]; then
			echo "Running"
		else
			echo "Not running"
		fi
	else
		echo "Not running"
	fi
}

cbsdrctl_restart()
{
	cbsdrctl_stop
	cbsdrctl_start
}

cbsdrctl_stop()
{
	if [ -f "${pidfile}" ]; then
		pids=$( pgrep -F ${pidfile} 2>&1 )
		_err=$?
		if [ ${_err} -eq  0 ]; then
			kill -9 ${pids} && /bin/rm -f ${pidfile}
		else
			echo "pgrep: ${pids}"
			return ${_err}
		fi
	fi
}

pidfile=/var/run/$name.pid
run_rc_command "$1"
