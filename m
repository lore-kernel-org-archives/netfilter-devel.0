From: Tim Gardner <timg@tpi.com>
Subject: 2.4 SNAT fails randomly
Date: Sat, 15 Nov 2003 11:03:47 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200311151103.47454.timg@tpi.com>
Reply-To: timg@tpi.com
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I think I have a case where SNAT is sometimes failing. I have a specific =
case=20
where UDP SNAT fails repeatedly. However, I have SPOOF log entries on som=
e of=20
our servers that indicate TCP is also failing SNAT once in awhile.

In particular, I (as an ISP) have a client that repeatably demonstrates t=
he=20
problem. This client is behind our embedded Linux 2.4.19 StrongARM NAT=20
firewall using P-O-M from CVS as of 11/14/2003. I have applied the follow=
ing=20
P-O-M patches:

submitted/02_2.4.20.patch
submitted/03_2.4.21.patch
submitted/04_2.4.22.patch
base/mport.patch"
base/iprange.patch"
base/psd.patch"
base/connlimit.patch"
base/u32.patch"
extra/h323-conntrack-nat.patch"
extra/pptp-conntrack-nat.patch"

This client has a NetGear router connected to our firewall. The NetGear r=
outer=20
has a well known bug wherein it attempts to get time/date via UDP/NTP fro=
m a=20
hardcoded destination (caesar.cs.wisc.edu). This is the UDP packet that i=
s=20
not being SNAT'd. The packet in question is thus:

tcpdump  -vvv -t -i eth1 -p -x -X -e 'port 123'
tcpdump: listening on eth1
0:2:6f:3:60:5c 0:90:27:90:49:e7 ip 90: 192.168.10.2.23457 >=20
caesar.cs.wisc.edu.ntp:  v1 client strat 0 poll 0 prec 0 dist 0.000000 di=
sp=20
0.000000 ref (unspec)@0.000000000 [|ntp] (ttl 253, id 63424, len 76)
0x0000   4500 004c f7c0 0000 fd11 53c1 c0a8 0a02        E..L......S.....
0x0010   8069 270b 5ba1 007b 0038 2643 0b00 0000        .i'.[..{.8&C....
0x0020   0000 0000 0000 0000 0000 0000 0000 0000        ................
0x0030   0000 0000 0000

I have verfied that this really is the packet that is being emitted on et=
h1=20
and is not an artifact of tcpdump. As you can see from the Chain POSTROUT=
ING=20
output below, some packets are clearly getting SNAT'd. Why not all of the=
m?

The iptables rules are straightforward.=20
---------------------------------------

IPTABLES=3D${IPTABLES:-/bin/iptables}
EXTIF=3Deth1
INTIF=3Deth0
${IPTABLES} -P INPUT ACCEPT
${IPTABLES} -F INPUT
${IPTABLES} -P OUTPUT ACCEPT
${IPTABLES} -F OUTPUT
${IPTABLES} -P FORWARD DROP
${IPTABLES} -F FORWARD
${IPTABLES} -t nat -F
#
# Established or NAT helper streams get out of jail free.
#
${IPTABLES} -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
#
# Block client hosting of well known services as well as SMB noise.
#
${IPTABLES} -A FORWARD -s 192.168.10.2/32 -p tcp -m mport --sports=20
21,23,25,80,110,137:139 -j DROP
${IPTABLES} -A FORWARD -s 192.168.10.2/32 -p udp -m mport --sports=20
137:139,201:206,396 -j DROP
${IPTABLES} -A FORWARD -d 192.168.10.2/32 -p tcp -m mport --dports=20
137:139,201:206,396 -j DROP
${IPTABLES} -A FORWARD -d 192.168.10.2/32 -p udp -m mport --dports=20
137:139,201:206,396 -j DROP
#
# Estable SNAT/DNAT mapping.
#
${IPTABLES} -t nat -A POSTROUTING -s 192.168.10.2 -j SNAT --to-source=20
216.166.171.155
${IPTABLES} -t nat -A PREROUTING -d 216.166.171.155 -j DNAT --to 192.168.=
10.2
#
# Allow ARP broadcasts from client.
#
${IPTABLES} -A FORWARD -s 192.168.10.0/24 -d 255.255.255.255 -j ACCEPT
#
# Block multicast from client.
#
${IPTABLES} -A FORWARD -s 192.168.10.0/24 -d 224.0.0.0/3 -j DROP
#
# Allow icmp echo-request to client, but block pings from client.
#
${IPTABLES} -A FORWARD -d 192.168.10.0/24 -p icmp --icmp-type echo-reques=
t -j=20
ACCEPT
${IPTABLES} -A FORWARD -s 192.168.10.0/24 -p icmp --icmp-type echo-reques=
t -j=20
DROP
#
# Allow inbound non-TCP traffic, e.g., IPSEC and UDP.
#
${IPTABLES} -A FORWARD -i ${EXTIF} -o ${INTIF} ! -p tcp -m iprange --dst-=
range=20
192.168.10.2-192.168.10.2 -j ACCEPT
#
# Allow inbound new TCP connections.
#
${IPTABLES} -A FORWARD -i ${EXTIF} -o ${INTIF} -d 192.168.10.0/24 -m stat=
e=20
--state NEW -j ACCEPT
#
# Allow client outbound packets from known source addresses. These packet=
s=20
should all go to
# the POSTROUTING rule.
#=20
${IPTABLES} -A FORWARD -i ${INTIF} -o ${EXTIF} -m iprange --src-range=20
192.168.10.2-192.168.10.2 -j ACCEPT

This is what the iptables dump shows:
-------------------------------------

Chain INPUT (policy ACCEPT 786 packets, 67921 bytes)
 pkts bytes target     prot opt in     out     source              =20
destination

Chain FORWARD (policy DROP 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source              =20
destination
   31  2608 ACCEPT     all  --  *      *       0.0.0.0/0            0.0.0=
=2E0/0          =20
state RELATED,ESTABLISHED
    0     0 DROP       tcp  --  *      *       192.168.10.2         0.0.0=
=2E0/0          =20
mport sports 21,23,25,80,110,137:139
    0     0 DROP       udp  --  *      *       192.168.10.2         0.0.0=
=2E0/0          =20
mport sports 137:139,201:206,396
    0     0 DROP       tcp  --  *      *       0.0.0.0/0           =20
192.168.10.2        mport dports 137:139,201:206,396
    0     0 DROP       udp  --  *      *       0.0.0.0/0           =20
192.168.10.2        mport dports 137:139,201:206,396
    0     0 ACCEPT     all  --  *      *       192.168.10.0/24     =20
255.255.255.255
    0     0 DROP       all  --  *      *       192.168.10.0/24     =20
224.0.0.0/3
    1    92 ACCEPT     icmp --  *      *       0.0.0.0/0           =20
192.168.10.0/24     icmp type 8
    0     0 DROP       icmp --  *      *       192.168.10.0/24      0.0.0=
=2E0/0          =20
icmp type 8
    1   404 ACCEPT    !tcp  --  eth1   eth0    0.0.0.0/0            0.0.0=
=2E0/0          =20
destination IP range 192.168.10.2-192.168.10.2
    2   120 ACCEPT     all  --  eth1   eth0    0.0.0.0/0           =20
192.168.10.0/24     state NEW
 2348  179K ACCEPT     all  --  eth0   eth1    0.0.0.0/0            0.0.0=
=2E0/0          =20
source IP range 192.168.10.2-192.168.10.2

Chain OUTPUT (policy ACCEPT 527 packets, 74202 bytes)
 pkts bytes target     prot opt in     out     source              =20
destination

Chain PREROUTING (policy ACCEPT 811 packets, 71641 bytes)
 pkts bytes target     prot opt in     out     source              =20
destination
    3   556 DNAT       all  --  *      *       0.0.0.0/0           =20
216.166.171.155     to:192.168.10.2

Chain POSTROUTING (policy ACCEPT 53 packets, 4657 bytes)
 pkts bytes target     prot opt in     out     source              =20
destination
    6   572 SNAT       all  --  *      *       192.168.10.2         0.0.0=
=2E0/0          =20
to:216.166.171.155

Chain OUTPUT (policy ACCEPT 49 packets, 4025 bytes)
 pkts bytes target     prot opt in     out     source              =20
destination


Here are my interface definitions:
----------------------------------

eth0      Link encap:Ethernet  HWaddr 00:D0:CA:F1:20:A4 =20
          UP BROADCAST RUNNING  MTU:1500  Metric:1
          RX packets:414 errors:0 dropped:0 overruns:0 frame:0
          TX packets:3 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:100=20
          RX bytes:31413 (30.6 kb)  TX bytes:228 (228.0 b)
          Interrupt:47 Base address:0x300=20

eth0:10   Link encap:Ethernet  HWaddr 00:D0:CA:F1:20:A4 =20
          inet addr:192.168.10.1  Bcast:192.168.10.255  Mask:255.255.255.=
0
          UP BROADCAST RUNNING  MTU:1500  Metric:1
          Interrupt:47 Base address:0x300=20

eth1      Link encap:Ethernet  HWaddr 00:02:6F:03:60:5C =20
          inet addr:172.16.233.252  Bcast:172.16.239.255  Mask:255.255.24=
8.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:4072 errors:0 dropped:0 overruns:0 frame:0
          TX packets:645 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:100=20
          RX bytes:310754 (303.4 kb)  TX bytes:86412 (84.3 kb)

eth1:10-2 Link encap:Ethernet  HWaddr 00:02:6F:03:60:5C =20
          inet addr:216.166.171.155  Bcast:216.166.171.255  Mask:255.255.=
255.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1

lo        Link encap:Local Loopback =20
          inet addr:127.0.0.1  Mask:255.0.0.0
          UP LOOPBACK RUNNING  MTU:16436  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0=20
          RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)

rf0       Link encap:Ethernet  HWaddr 00:02:6F:03:60:5C =20
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:16964 errors:0 dropped:0 overruns:0 frame:0
          TX packets:691 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:100=20
          RX bytes:765858 (747.9 kb)  TX bytes:71316 (69.6 kb)
          Interrupt:43=20


--=20
Tim Gardner - timg@tpi.com 406-443-5357
TriplePoint, Inc. - http://www.tpi.com
PGP: http://www.tpi.com/PGP/Tim.txt
