From: <staenker@rhcs.de>
Subject: iptables bug using dhcpd3 on debian sarge 2.6.8
Date: Mon,  7 Mar 2005 15:44:04 +0100
Message-ID: <6642317$1110205335422c6397f21926.15822394@config8.schlund.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
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


hello,
at first nice weekend! and now to to my problem.
i tried to set up a firewall on my dsl gate. i want to use policy drop
for input and output chain. so, if i was right, i have to write some
rules for the dhcpd3 server, ssh, dns,... ok, i wrote the rules for
sshd using port 64385. works fine. if i don't use this rules, sshd is
not reachable. also fine. but i realised that my dhcp server works fine
even though that i do not iplement any accept rules for dhcp. i know
that sounds strange, thatswhy i put a date between the iptables calls
that it looks a bit like i was not lying. and i wish i where - but
wishes are wishes and reality is hard to accept. so pleasy believe me,
that i was not lying! ok, here the output:
-----
Antifreeze:~# date;iptables -L;date;iptables -t nat -L;date;iptables -t
mangle -L;date;tcpdump -i eth0 udp
Mon Mar  7 14:50:57 CET 2005
Chain INPUT (policy DROP)
target     prot opt source               destination
ACCEPT     tcp  --  anywhere             anywhere            tcp
dpt:64385 state NEW,ESTABLISHED

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination

Chain OUTPUT (policy DROP)
target     prot opt source               destination
ACCEPT     tcp  --  anywhere             anywhere            tcp
spt:64385 state ESTABLISHED
Mon Mar  7 14:50:57 CET 2005
Chain PREROUTING (policy ACCEPT)
target     prot opt source               destination

Chain POSTROUTING (policy ACCEPT)
target     prot opt source               destination

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination
Mon Mar  7 14:50:57 CET 2005
Chain PREROUTING (policy ACCEPT)
target     prot opt source               destination

Chain INPUT (policy ACCEPT)
target     prot opt source               destination

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination

Chain POSTROUTING (policy ACCEPT)
target     prot opt source               destination
Mon Mar  7 14:50:57 CET 2005
tcpdump: verbose output suppressed, use -v or -vv for full protocol
decode
listening on eth0, link-type EN10MB (Ethernet), capture size 96 bytes
14:51:01.030148 IP 192.168.0.4.3365 > 193.174.103.1.domain:  53003+ A?
download.windowsupdate.com. (44)
14:51:02.029715 IP 192.168.0.4.3365 > 193.174.103.1.domain:  53003+ A?
download.windowsupdate.com. (44)
14:51:03.030160 IP 192.168.0.4.3365 > 193.174.103.1.domain:  53003+ A?
download.windowsupdate.com. (44)
14:51:05.030290 IP 192.168.0.4.3365 > 193.174.103.1.domain:  53003+ A?
download.windowsupdate.com. (44)
14:51:09.031182 IP 192.168.0.4.3365 > 193.174.103.1.domain:  53003+ A?
download.windowsupdate.com. (44)
14:51:10.965603 IP 0.0.0.0.bootpc > 255.255.255.255.bootps: BOOTP/DHCP,
Request from 00:0f:cb:ad:75:a8, length: 300
14:51:10.966600 IP Antifreeze.lan.bootps > 192.168.0.19.bootpc:
BOOTP/DHCP, Reply, length: 300
14:51:10.975221 IP 0.0.0.0.bootpc > 255.255.255.255.bootps: BOOTP/DHCP,
Request from 00:0f:cb:ad:75:a8, length: 322
14:51:10.978049 IP Antifreeze.lan.bootps > 192.168.0.19.bootpc:
BOOTP/DHCP, Reply, length: 300
14:51:16.039898 IP 192.168.0.4.3365 > 193.174.103.1.domain:  40968+ A?
download.windowsupdate.com. (44)
14:51:17.039462 IP 192.168.0.4.3365 > 193.174.103.1.domain:  40968+ A?
download.windowsupdate.com. (44)
14:51:18.039531 IP 192.168.0.4.3365 > 193.174.103.1.domain:  40968+ A?
download.windowsupdate.com. (44)
14:51:20.039913 IP 192.168.0.4.3365 > 193.174.103.1.domain:  40968+ A?
download.windowsupdate.com. (44)
14:51:24.040680 IP 192.168.0.4.3365 > 193.174.103.1.domain:  40968+ A?
download.windowsupdate.com. (44)

14 packets captured
14 packets received by filter
0 packets dropped by kernel
Antifreeze:~# date
Mon Mar  7 14:51:35 CET 2005
Antifreeze:~#
----

so please show me my fault. i was teting since about 4 houres and could
not understand why this dhcpd is working.

thanks for your attention
richard hauswald
