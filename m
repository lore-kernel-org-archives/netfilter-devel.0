From: "Bala Pitchandi" <bs@utstar.com>
Subject: Segmenation fault in netfilter/iptables code in 2.4.18 upon
	receiving a TFTP broadcast
Date: Tue, 16 Aug 2005 18:45:50 -0400
Message-ID: <00e001c5a2b4$431c0550$352310ac@nj.us.utstar.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_00E1_01C5A292.BC0A6550"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.

------=_NextPart_000_00E1_01C5A292.BC0A6550
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hello,

I am using a 2.4.18 TimeSys kernel in a PPC device. Please see the
attachment for the iptables rules that I have installed in my device. =
Newly
installed Cisco routers send out TFTP broadcasts asking for =
configuration
files (network-confg, cisconet.cfg etc) to get the hostname to IP =
address
mapping. Upon receiving such a broadcast there was a SIGSEGV exception
caused in the kernel. The call backtrace is given below:

init_conntrack
ip_conntrack_in
----------------------------------------
nf_iterate
nf_hook_slow
ip_rcv=20
process_pkt
do_net_rx_action
net_rx_action
ksoftirqd
----------------------------------------
seq_read

It looks like that the netfilter code is causing a segmentation fault =
upon
receiving the TFTP broadcast packet (although not every time). It got
processed by ip_rcv and ip_rcv called nf_hook_slow. nf_hook_slow called
nf_iterate to find out whether to accept/drop this packet and that's =
where
the segmentation fault happened. I dunno why the PC is pointing to
init_conntrack.

I found discussions regarding similar segmentation fault in the =
netfilter
code but couldn't get much information from it:

https://lists.netfilter.org/pipermail/netfilter-devel/2004-February/01406=
4.h
tml

If any of you have some thoughts on this problem or a similar issues, =
please
let me know what the cause could be (or if a patch is available).

Thanks,
Bala

------=_NextPart_000_00E1_01C5A292.BC0A6550
Content-Type: text/plain;
	name="iptables.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="iptables.txt"

bash-2.05# iptables -t nat -L
Chain PREROUTING (policy ACCEPT)
target     prot opt source               destination
DNAT       udp  --  anywhere             anywhere           udp =
dpt:10014 to:192.168.100.16:69
DNAT       udp  --  anywhere             anywhere           udp =
dpt:10015 to:192.168.100.17:69

Chain POSTROUTING (policy ACCEPT)
target     prot opt source               destination

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination

bash-2.05# iptables -L
Chain INPUT (policy DROP)
target     prot opt source               destination
input_chain  all  --  anywhere             anywhere
DROP       icmp --  anywhere             anywhere           icmp =
source-quench
DROP       icmp --  anywhere             anywhere           icmp =
redirect
DROP       icmp --  anywhere             anywhere           icmp =
timestamp-request
DROP       icmp --  anywhere             anywhere           icmp =
timestamp-reply

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination
ACCEPT     all  --  anywhere             anywhere
ACCEPT     all  --  anywhere             anywhere           state =
RELATED,ESTABLISHED
ACCEPT     all  --  anywhere             anywhere           limit: avg =
100/sec burst 5
ACCEPT     all  --  anywhere             anywhere           limit: avg =
100/sec burst 5
ACCEPT     tcp  --  anywhere             anywhere           tcp dpt:4004
ACCEPT     udp  --  anywhere             anywhere           state NEW =
udp dpt:tftp
ACCEPT     udp  --  anywhere             anywhere           udp =
dpt:17185
ACCEPT     all  --  anywhere             anywhere           state =
RELATED,ESTABLISHED

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination

Chain allowed_ping (0 references)
target     prot opt source               destination
ACCEPT     icmp --  anywhere             anywhere           icmp =
echo-request limit: avg 3/sec burst 5
ACCEPT     icmp --  anywhere             anywhere           icmp =
echo-reply

Chain allowed_protocols (1 references)
target     prot opt source               destination
ACCEPT     igmp --  anywhere             anywhere
ACCEPT     igmp --  anywhere             anywhere
ACCEPT     ospf --  anywhere             anywhere
ACCEPT     pim  --  anywhere             anywhere
ACCEPT     all  --  anywhere             224.0.0.0/4        limit: avg =
1/sec burst 5

Chain allowed_tcp (6 references)
target     prot opt source               destination
ACCEPT     tcp  --  anywhere             anywhere           limit: avg =
100/sec burst 5 tcp flags:SYN,RST,ACK/SYN
ACCEPT     tcp  --  anywhere             anywhere           state =
RELATED,ESTABLISHED
DROP       tcp  --  anywhere             anywhere

Chain icmp_packets (1 references)
target     prot opt source               destination
ACCEPT     icmp --  anywhere             anywhere           icmp =
echo-request limit: avg 3/sec burst 5
ACCEPT     icmp --  anywhere             anywhere           icmp =
echo-reply
ACCEPT     icmp --  anywhere             anywhere           icmp =
port-unreachable
ACCEPT     icmp --  anywhere             anywhere           icmp =
time-exceeded

Chain input_chain (1 references)
target     prot opt source               destination
ACCEPT     all  --  anywhere             anywhere
ACCEPT     all  --  anywhere             anywhere
ACCEPT     all  --  anywhere             anywhere
ACCEPT     all  --  anywhere             anywhere
tcp_packets  tcp  --  anywhere             anywhere
tcp_packets1  tcp  --  anywhere             anywhere
udp_packets  udp  --  anywhere             anywhere
icmp_packets  icmp --  anywhere             anywhere
allowed_protocols  all  --  anywhere             anywhere

Chain tcp_packets (1 references)
target     prot opt source               destination
allowed_tcp  tcp  --  anywhere             anywhere           tcp =
dpt:telnet

Chain tcp_packets1 (1 references)
target     prot opt source               destination
allowed_tcp  tcp  --  anywhere             anywhere           tcp =
dpt:zebra
allowed_tcp  tcp  --  anywhere             anywhere           tcp =
dpt:ripd
allowed_tcp  tcp  --  anywhere             anywhere           tcp =
dpt:ospfd
allowed_tcp  tcp  --  anywhere             anywhere           tcp =
dpt:2610
allowed_tcp  tcp  --  anywhere             anywhere           tcp =
dpt:8700

Chain udp_packets (1 references)
target     prot opt source               destination
ACCEPT     udp  --  anywhere             anywhere           udp =
spt:domain
ACCEPT     udp  --  anywhere             anywhere           udp dpt:snmp
ACCEPT     udp  --  anywhere             anywhere           udp =
dpt:syslog
ACCEPT     udp  --  anywhere             anywhere           udp spt:ntp
ACCEPT     udp  --  anywhere             anywhere           udp spt:2049
ACCEPT     udp  --  anywhere             anywhere           udp =
dpts:33434:33523
ACCEPT     udp  --  anywhere             anywhere           udp dpt:tftp
ACCEPT     udp  --  anywhere             anywhere           udp dpt:route
------=_NextPart_000_00E1_01C5A292.BC0A6550--
