From: Evan Harris <eharris@puremagic.com>
Subject: Re: Bug/Problem with DNAT on OUTPUT chain (-t nat -A OUTPUT) that
 breaks routing? (fwd)
Date: Thu, 23 Oct 2003 13:25:59 -0500 (CDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0310231249480.29188-100000@kinison.puremagic.com>
References: <3F980CE7.2050909@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@lists.netfilter.org, <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <3F980CE7.2050909@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Debian kernel-image-2.4.22 built from source from 2.4.22-3.

# ifconfig
eth0      Link encap:Ethernet  HWaddr 00:D0:C9:17:65:93
          inet addr:10.1.16.2  Bcast:10.1.16.255  Mask:255.255.255.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:100
          RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)
          Interrupt:10

lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          UP LOOPBACK RUNNING  MTU:16436  Metric:1
          RX packets:5 errors:0 dropped:0 overruns:0 frame:0
          TX packets:5 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:1060 (1.0 KiB)  TX bytes:1060 (1.0 KiB)

tun0      Link encap:Point-to-Point Protocol
          inet addr:172.31.255.16  P-t-P:172.31.255.1  Mask:255.255.255.255
          UP POINTOPOINT RUNNING NOARP MULTICAST  MTU:1255  Metric:1
          RX packets:282 errors:0 dropped:0 overruns:0 frame:0
          TX packets:172 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:10
          RX bytes:14982 (14.6 KiB)  TX bytes:12326 (12.0 KiB)

wlan0     Link encap:Ethernet  HWaddr 00:02:6F:03:AE:8C
          inet addr:172.31.100.10  Bcast:172.31.100.255  Mask:255.255.255.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:1742 errors:0 dropped:0 overruns:0 frame:0
          TX packets:2368 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:100
          RX bytes:204216 (199.4 KiB)  TX bytes:169780 (165.8 KiB)
          Interrupt:3 Base address:0x100

# route -n
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
10.100.100.101  172.31.100.1    255.255.255.255 UGH   0      0        0 wlan0
172.31.255.1    0.0.0.0         255.255.255.255 UH    0      0        0 tun0
172.31.100.0    0.0.0.0         255.255.255.0   U     0      0        0 wlan0
10.1.16.0       0.0.0.0         255.255.255.0   U     0      0        0 eth0
0.0.0.0         172.31.255.1    0.0.0.0         UG    0      0        0 tun0

# iptables -V
iptables v1.2.8

# iptables -t nat -L -v -n
Chain PREROUTING (policy ACCEPT 4 packets, 770 bytes)
 pkts bytes target     prot opt in     out     source               destination

Chain POSTROUTING (policy ACCEPT 1 packets, 88 bytes)
 pkts bytes target     prot opt in     out     source               destination

Chain OUTPUT (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination
    1    88 ACCEPT     udp  --  *      *       0.0.0.0/0            10.100.100.101     udp spt:49900 dpts:49900:49999
    6   398 DNAT       udp  --  *      *       0.0.0.0/0            10.100.100.101     to:172.31.255.1
    0     0 DNAT       tcp  --  *      *       0.0.0.0/0            10.100.100.101     to:172.31.255.1

# iptables -L OUTPUT -v
Chain OUTPUT (policy ACCEPT 191 packets, 13084 bytes)
 pkts bytes target     prot opt in     out     source               destination
  203 26024 ACCEPT     udp  --  any    wlan0   anywhere             anywhere           udp spt:49900
    0     0 ACCEPT     udp  --  any    wlan0   anywhere             anywhere           udp spt:bootpc dpt:bootps
    0     0 ACCEPT     icmp --  any    wlan0   anywhere             anywhere
    6   398 LOG        all  --  any    wlan0   anywhere             anywhere           LOG level warning
    6   398 DROP       all  --  any    wlan0   anywhere             anywhere

Attempting an nslookup to the nameserver on 10.100.100.101, which is
DNAT'ed to 172.31.255.1 produces these from the wlan0 LOG rule:

IN= OUT=wlan0 SRC=172.31.255.16 DST=172.31.255.1 LEN=65 TOS=0x00 PREC=0x00 TTL=64 ID=31034 DF PROTO=UDP SPT=1024 DPT=53 LEN=45
IN= OUT=wlan0 SRC=172.31.255.16 DST=172.31.255.1 LEN=65 TOS=0x00 PREC=0x00 TTL=64 ID=31034 DF PROTO=UDP SPT=1024 DPT=53 LEN=45
...

Networking and Netfilter sections from kernel config:

#
# Networking options
#
CONFIG_PACKET=y
# CONFIG_PACKET_MMAP is not set
CONFIG_NETLINK_DEV=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_FILTER=y
CONFIG_UNIX=y
# CONFIG_NET_KEY is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_IP_MULTIPLE_TABLES=y
# CONFIG_IP_ROUTE_FWMARK is not set
CONFIG_IP_ROUTE_NAT=y
# CONFIG_IP_ROUTE_MULTIPATH is not set
# CONFIG_IP_ROUTE_TOS is not set
# CONFIG_IP_ROUTE_VERBOSE is not set
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE is not set
# CONFIG_IP_MROUTE is not set
# CONFIG_ARPD is not set
# CONFIG_INET_ECN is not set
# CONFIG_SYN_COOKIES is not set
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set

#
#   IP: Netfilter Configuration
#
CONFIG_IP_NF_CONNTRACK=y
CONFIG_IP_NF_FTP=y
# CONFIG_IP_NF_AMANDA is not set
# CONFIG_IP_NF_TFTP is not set
# CONFIG_IP_NF_IRC is not set
# CONFIG_IP_NF_QUEUE is not set
CONFIG_IP_NF_IPTABLES=y
# CONFIG_IP_NF_MATCH_LIMIT is not set
# CONFIG_IP_NF_MATCH_MAC is not set
# CONFIG_IP_NF_MATCH_PKTTYPE is not set
# CONFIG_IP_NF_MATCH_MARK is not set
# CONFIG_IP_NF_MATCH_MULTIPORT is not set
# CONFIG_IP_NF_MATCH_TOS is not set
# CONFIG_IP_NF_MATCH_RECENT is not set
# CONFIG_IP_NF_MATCH_ECN is not set
# CONFIG_IP_NF_MATCH_DSCP is not set
# CONFIG_IP_NF_MATCH_AH_ESP is not set
# CONFIG_IP_NF_MATCH_LENGTH is not set
# CONFIG_IP_NF_MATCH_TTL is not set
# CONFIG_IP_NF_MATCH_TCPMSS is not set
CONFIG_IP_NF_MATCH_HELPER=y
CONFIG_IP_NF_MATCH_STATE=y
CONFIG_IP_NF_MATCH_CONNTRACK=y
# CONFIG_IP_NF_MATCH_UNCLEAN is not set
# CONFIG_IP_NF_MATCH_OWNER is not set
CONFIG_IP_NF_FILTER=y
CONFIG_IP_NF_TARGET_REJECT=y
# CONFIG_IP_NF_TARGET_MIRROR is not set
CONFIG_IP_NF_NAT=y
CONFIG_IP_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_MASQUERADE=y
CONFIG_IP_NF_TARGET_REDIRECT=y
CONFIG_IP_NF_NAT_LOCAL=y
# CONFIG_IP_NF_NAT_SNMP_BASIC is not set
CONFIG_IP_NF_NAT_FTP=y
# CONFIG_IP_NF_MANGLE is not set
CONFIG_IP_NF_TARGET_LOG=y
CONFIG_IP_NF_TARGET_ULOG=m
CONFIG_IP_NF_TARGET_TCPMSS=y
# CONFIG_IP_NF_ARPTABLES is not set
# CONFIG_IPV6 is not set
CONFIG_XFRM=y
# CONFIG_XFRM_USER is not set
# CONFIG_KHTTPD is not set
# CONFIG_ATM is not set
# CONFIG_VLAN_8021Q is not set


Evan


On Thu, 23 Oct 2003, Patrick McHardy wrote:

> I tried 2.4 and 2.6 with DNAT to 127.0.0.1. The packets were sent on the
> loopback device as expected. Please send some more information about
> your specific setup.
>
> Best regards,
> Patrick
>
> Evan Harris wrote:
>
> >Ok, I've upgraded to kernel 2.4.22, and the same behaviour is being
> >exhibited.
> >
> >To recap the problem:
> >
> >Packets being nat'd on the OUTPUT chain of a machine are still being sent on
> >the same interface they would have without the nat, and ignoring the route
> >that aims them to the right iface for that dest addr.
> >
> >Evan
> >
> >
> >
> >
>
