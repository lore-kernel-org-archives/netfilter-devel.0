From: sverre <sverre@gmx.net>
Subject: bug in 2.4.18 netfilter ?
Date: Fri, 5 Jul 2002 02:02:10 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020705000210.GA2038@gmx.net>
Reply-To: sverre@gmx.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Greetings,
first of all Im sorry if this issue has been reported/fixed already, as
Im not subscribed to netfilter-devel or any other netfilter list.

There seems to be a problem flushing the chains when using network
devices with dynamically assigned IP adresses and a large number of
rules.
For example when I use ppp to connect to a remote host for the first
time, Im assigned say 195.168.62.1, I run my firewall script (with
some >700 rules). At the end of my "session" I flush all the chains, set
the default policies to ACCEPT and I disconnect. But when I connect
again and get another IP adress (for example 195.168.62.2), I can not
recieve anything from the network - even when all the chains are
flushed and the default policies are set to ACCEPT. I can send packets,
probably because of the default policy set to ACCEPT in the previous
"session", but the kernel can not recieve any packets coming from the ppp
device.

Here is the firewall script that I used - Its quite big & ugly, but
there should be no problem with this script. The -j SNAT has been fixed
to -j MASQUERADE as appointed by Rusty Russell, but this has none
effect on the fact that this script causes the netfilter to drop all the
incoming packets from the ppp0 interface the next time I connect to a
remote host via ppp0 (after I properly flush the chains).
Please CC any replies to me as Im not subscribed to this mailing list.


#! /bin/bash

if [ ! -x /usr/sbin/iptables ];then
	exit 1
fi

EXTERNAL_INTFS="ppp0"
LOCAL_INTFS="eth0"
LOOPBACK_INTFS="lo"
IPADDR=`/sbin/ifconfig |grep -A 4 ppp0 |awk '/inet/ { print $2 }' |sed -e s/addr://`
MY_ISP=`/sbin/ifconfig |grep -A 4 ppp0 |awk '/P-t-P/ { print $3 }' |sed -e s/P-t-P:// |cut -d "." -f 1-3`.0/24

LOCALNET="192.168.1.0/24"
NAMESERVER_1="195.168.1.4"
NAMESERVER_2="195.168.1.2"
NAMESERVER_3="212.47.0.4"
ANYWHERE="any/0"

PRIVPORTS="0:1023"
UNPRIVPORTS="1024:65535"
SSH_PORTS="1022:1023"
TRACEROUTE_SRC_PORTS="32769:65535"
TRACEROUTE_DEST_PORTS="33434:33523"
IRCPORTS="6665,6666,6667,6668,6669,7000"

RESERVED="0.0.0.0/8 1.0.0.0/8 2.0.0.0/8 5.0.0.0/8 7.0.0.0/8 10.0.0.0/8 14.0.0.0/8 \
	23.0.0.0/8 27.0.0.0/8 31.0.0.0/8 36.0.0.0/8 37.0.0.0/8 39.0.0.0/8 \
	41.0.0.0/8 42.0.0.0/8 49.0.0.0/8 50.0.0.0/8 58.0.0.0/8 59.0.0.0/8 \
	60.0.0.0/8 69.0.0.0/8 70.0.0.0/8 71.0.0.0/8 72.0.0.0/8 73.0.0.0/8 \
	74.0.0.0/8 75.0.0.0/8 76.0.0.0/8 77.0.0.0/8 78.0.0.0/8 79.0.0.0/8 \
	82.0.0.0/8 83.0.0.0/8 84.0.0.0/8 85.0.0.0/8 86.0.0.0/8 87.0.0.0/8 \
	88.0.0.0/8 89.0.0.0/8 90.0.0.0/8 91.0.0.0/8 92.0.0.0/8 93.0.0.0/8 \
	94.0.0.0/8 95.0.0.0/8 96.0.0.0/8 97.0.0.0/8 98.0.0.0/8 99.0.0.0/8 \
	100.0.0.0/8 101.0.0.0/8 102.0.0.0/8 103.0.0.0/8 104.0.0.0/8 105.0.0.0/8 \
	106.0.0.0/8 107.0.0.0/8 108.0.0.0/8 109.0.0.0/8 110.0.0.0/8 111.0.0.0/8 \
	112.0.0.0/8 113.0.0.0/8 114.0.0.0/8 115.0.0.0/8 116.0.0.0/8 117.0.0.0/8 \
	118.0.0.0/8 119.0.0.0/8 120.0.0.0/8 121.0.0.0/8 122.0.0.0/8 123.0.0.0/8 \
	124.0.0.0/8 125.0.0.0/8 126.0.0.0/8 127.0.0.0/8 197.0.0.0/8 201.0.0.0/8 \
	221.0.0.0/8 222.0.0.0/8 223.0.0.0/8 224.0.0.0/8 225.0.0.0/8 226.0.0.0/8 \
	227.0.0.0/8 228.0.0.0/8 229.0.0.0/8 230.0.0.0/8 231.0.0.0/8 232.0.0.0/8 \
	233.0.0.0/8 234.0.0.0/8 235.0.0.0/8 236.0.0.0/8 237.0.0.0/8 238.0.0.0/8 \
	239.0.0.0/8 240.0.0.0/8 241.0.0.0/8 242.0.0.0/8 243.0.0.0/8 244.0.0.0/8 \
	245.0.0.0/8 246.0.0.0/8 247.0.0.0/8 248.0.0.0/8 249.0.0.0/8 250.0.0.0/8 \
	251.0.0.0/8 252.0.0.0/8 253.0.0.0/8 254.0.0.0/8 255.0.0.0/8"

case "$1" in
  start)
	if [ -f /var/lock/subsys/firewall ]; then
		echo "Firewall already activated"
		echo
		exit 1
	fi
	echo -n "Starting the firewalling... "

modprobe ip_conntrack
modprobe ip_conntrack_ftp
modprobe ip_conntrack_irc ports=$IRCPORTS
modprobe ip_nat_ftp
modprobe ip_nat_irc ports=$IRCPORTS

# ----------------------------------------------------------------------------
# Remove all existing rules belonging to this filter
iptables -F

# Clearing all current rules and user defined chains
iptables -X

# Set the default policy of the filter to drop
iptables -P INPUT DROP		# in fact its REJECT for icmp & tcp
iptables -P OUTPUT ACCEPT
iptables -P FORWARD DROP

# ----------------------------------------------------------------------------
# in_tcp
#

iptables -N in_tcp

for ADDR in $RESERVED; do
	iptables -A in_tcp -p TCP -s $ADDR -j REJECT --reject-with tcp-reset
	iptables -A in_tcp -p TCP -d $ADDR -j REJECT --reject-with tcp-reset
done

iptables -A in_tcp -p TCP ! --syn -m state --state NEW -j LOG \
	--log-prefix "New not SYN: "
iptables -A in_tcp -p TCP ! --syn -m state --state NEW -j REJECT --reject-with tcp-reset

iptables -A in_tcp -p TCP -i $EXTERNAL_INTFS -s $IPADDR -j LOG \
	--log-prefix "Spoofed packet: "
iptables -A in_tcp -p TCP -i $EXTERNAL_INTFS -s $IPADDR -j DROP

# limiting incoming RSTs
iptables -A in_tcp -p TCP --tcp-flags ALL RST -m limit --limit 3/second -j ACCEPT

# allowed TCP packets
iptables -N allowed_in_tcp
iptables -A allowed_in_tcp -p TCP --syn -m limit --limit 1/second -j ACCEPT
iptables -A allowed_in_tcp -p TCP -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A allowed_in_tcp -p TCP -j REJECT --reject-with tcp-reset

# POP server
#iptables -A in_tcp -p TCP -s $ANYWHERE --sport $UNPRIVPORTS -d $IPADDR --dport 110 -j allowed_in_tcp

# SMTP server
iptables -A in_tcp -p TCP -s $ANYWHERE --sport $UNPRIVPORTS -d $IPADDR --dport 25 -j allowed_in_tcp

# SSH server
iptables -A in_tcp -p TCP -s $ANYWHERE --sport $UNPRIVPORTS -d $IPADDR --dport 22 -j allowed_in_tcp
iptables -A in_tcp -p TCP -s $ANYWHERE --sport $SSH_PORTS -d $IPADDR --dport 22 -j allowed_in_tcp

# FTP data channel
iptables -A in_tcp -p TCP -s $ANYWHERE --sport 20 -d $IPADDR --dport $UNPRIVPORTS -m state --state RELATED -j ACCEPT

# LOG and REJECT everything else
iptables -A in_tcp -p TCP -m limit --limit 1/second --limit-burst 2 -j LOG \
	--log-level WARN --log-prefix "REJECT IN TCP: "
iptables -A in_tcp -p TCP -j REJECT --reject-with tcp-reset


# ----------------------------------------------------------------------------
# in_udp
#

iptables -N in_udp

for ADDR in $RESERVED; do
        iptables -A in_udp -s $ADDR -j REJECT --reject-with icmp-port-unreachable
        iptables -A in_udp -d $ADDR -j REJECT --reject-with icmp-port-unreachable
done

#Traceroutes depend on finding a rejected port.  DROP the ones it uses
iptables -A in_udp -p udp --dport $TRACEROUTE_DEST_PORTS -j DROP

# TIME client
iptables -A in_udp -p UDP -s $ANYWHERE --sport 37 -d $IPADDR --dport $UNPRIVPORTS -j ACCEPT

# DNS server
iptables -A in_udp -p UDP -s $ANYWHERE --sport $UNPRIVPORTS -d $IPADDR --dport 53 -j ACCEPT

# DNS client
iptables -A in_udp -p UDP -s $ANYWHERE --sport 53 -d $IPADDR --dport $UNPRIVPORTS -j ACCEPT

# ICQ client
iptables -A in_udp -p UDP -s $ANYWHERE --sport 5190 -d $IPADDR --dport $UNPRIVPORTS -j ACCEPT
iptables -A in_udp -p UDP -s $ANYWHERE --sport $UNPRIVPORTS -d $IPADDR --dport 6970:6999 -j ACCEPT

# LOG and REJECT everything else
iptables -A in_udp -p UDP -m limit --limit 1/second --limit-burst 2 -j LOG \
        --log-level WARN --log-prefix "REJECT IN UDP: "
iptables -A in_udp -p UDP -j REJECT --reject-with icmp-port-unreachable

# ----------------------------------------------------------------------------
# in_icmp
#

iptables -N in_icmp

for ADDR in $RESERVED; do
        iptables -A in_icmp -s $ADDR -j DROP
        iptables -A in_icmp -d $ADDR -j DROP
done

# type 0 (echo reply)
iptables -A in_icmp -p ICMP -s $ANYWHERE --icmp-type 0 -d $IPADDR -j ACCEPT

# type 3 (dest unreachable)
iptables -A in_icmp -p ICMP -s $ANYWHERE --icmp-type 3 -d $IPADDR -j ACCEPT

# type 11 (TTL exceeded)
iptables -A in_icmp -p ICMP -s $ANYWHERE --icmp-type 11 -d $IPADDR -j ACCEPT

# type 12 (parameter problem)
iptables -A in_icmp -p ICMP -s $ANYWHERE --icmp-type 12 -d $IPADDR -j ACCEPT

# LOG everything else (it gets DROPped in the INPUT chain)
iptables -A in_icmp -p ICMP -m limit --limit 1/second --limit-burst 2 -j LOG \
        --log-level WARN --log-prefix "DROP IN ICMP: "

# ----------------------------------------------------------------------------
# out_icmp
#

iptables -N out_icmp
iptables -A out_icmp -m state -p icmp --state INVALID -j DROP

# type 3 (dest unreachable)
iptables -A out_icmp -p ICMP -s $IPADDR --icmp-type 3 -d $ANYWHERE -j ACCEPT

# type 8 (echo request)
iptables -A out_icmp -p ICMP -s $IPADDR --icmp-type 8 -d $ANYWHERE -j ACCEPT

# LOG and DROP everything else
iptables -A out_icmp -p ICMP -m limit --limit 1/second --limit-burst 2 -j LOG \
        --log-level WARN --log-prefix "DROP OUT ICMP: "
iptables -A out_icmp -p ICMP -j DROP

# ----------------------------------------------------------------------------
# IP Forwarding and Network Address Translation
iptables -t nat -A POSTROUTING -o $EXTERNAL_INTFS -j SNAT --to-source $IPADDR
iptables -A FORWARD -i $LOCAL_INTFS -j ACCEPT
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -m limit --limit 3/minute --limit-burst 3 -j LOG \
	--log-level WARN --log-prefix "IPT FORWARD packet died: "

# ----------------------------------------------------------------------------
# INPUT chain

# unlimited traffic on the loopback interface, and local network
iptables -A INPUT -i $EXTERNAL_INTFS -d $LOCALNET -j DROP
iptables -A INPUT -i $LOCAL_INTFS -s $LOCALNET -j ACCEPT
iptables -A INPUT -i $LOOPBACK_INTFS -j ACCEPT

# accept packets for established connctions
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

iptables -A INPUT -p TCP -i $EXTERNAL_INTFS -j in_tcp
iptables -A INPUT -p UDP -i $EXTERNAL_INTFS -j in_udp
iptables -A INPUT -p ICMP -i $EXTERNAL_INTFS -j in_icmp

# ----------------------------------------------------------------------------
# OUTPUT chain

# unlimited traffic on the loopback interface, and local network
iptables -A OUTPUT -o $EXTERNAL_INTFS -s $LOCALNET -j DROP
iptables -A OUTPUT -o $LOOPBACK_INTFS -j ACCEPT
iptables -A OUTPUT -o $LOCAL_INTFS -d $LOCALNET -j ACCEPT

iptables -A OUTPUT -p ICMP -j out_icmp

	touch /var/lock/subsys/firewall
	echo "     done"
	echo
	;;
  stop)
	if [ -f /var/lock/subsys/firewall ];then
		echo -n "Shutting down the firewall... "
		# Remove all existing rules belonging to this filter
		iptables -F INPUT
		iptables -F OUTPUT
		iptables -F FORWARD
		iptables -F in_tcp
		iptables -F allowed_in_tcp
		iptables -F in_udp
		iptables -F in_icmp
		iptables -F out_icmp

		# Delete all user-defined chain to this filter
		iptables -X 

		# Reset the default policy of the filter to accept.
		iptables -P INPUT  ACCEPT
		iptables -P OUTPUT ACCEPT
		iptables -P FORWARD ACCEPT

		rm -f /var/lock/subsys/firewall
		echo "     done"
		echo
	else
		echo "Firewall is already shut down !"
		echo
		exit 1
	fi
        ;;
  restart|reload)
	$0 stop
	$0 start
	;;
  status)
	if [ -f /var/lock/subsys/firewall ];then
		echo "activated"
		echo
	else	echo "shutdown"
		echo
	fi
	;;
  *)
	echo "Usage: $0 {start|stop|status|restart|reload}"
	exit 1
esac
exit 0


best regards,

-- 


			sverre	<sverreQgmx.net>
