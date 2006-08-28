From: "Greg Scott" <GregScott@InfraSupportEtc.com>
Subject: RE: Troubeleshooting  a  PPTP conversation
Date: Mon, 28 Aug 2006 08:30:17 -0500
Message-ID: <925A849792280C4E80C5461017A4B8A206F9D9@mail733.InfraSupportEtc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org,
	Mike McRae <Mike_McRae@schneidermans.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
To: "Patrick McHardy" <kaber@trash.net>
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

Below are all the rules.  NAT table first, then the filter table, then
the mangle table.  Apologies in advance if the text wrapping gets
butchered.  There are lots of rules - just search for "1723" and you
will see the relevant ones. =20

I will try another connection and post /proc/net/ip_conntrack tonight
when I get back later today. =20

10.13.1.22 is a Windows 2000 Microsoft RRAS server behind the firewall.
Win2000 - not Win2003.  I was sniffing the Internet side. Eth0 is the
Internet side, eth1 is the LAN.  eth2 is a future DMZ but right now is
empty.

Here is the big picture:

My LAN----My Firewall <-Internet-> Lakeville FW --Lakeville LAN and RRAS
Server
            66.173.97.0/27     aa.bb.212.154      10.13.1.0/24
10.13.1.22

I have some more data on the problem.  After rebooting both the remote
and local firewalls, the symptoms stayed the same.  After rebooting the
Microsoft RRAS server at 10.13.1.22, I was able to get a PPTP connection
from my place to Lakeville.  After hanging up, I was not able to make
another connection.  The Microsoft PPTP client keeps redialing.  I went
off and did other stuff and let it redial - and then between 5 and 10
minutes later, it connected again.


[root@lakeville-fw gregs]# /usr/local/sbin/iptables -L -v -n -t nat
Chain PREROUTING (policy ACCEPT 87280 packets, 11M bytes)
 pkts bytes target     prot opt in     out     source
destination        =20
    3   376 ACCEPT     esp  --  eth0   *       0.0.0.0/0
0.0.0.0/0          =20
    0     0 ACCEPT     ah   --  eth0   *       0.0.0.0/0
0.0.0.0/0          =20
 4155  894K ACCEPT     all  --  eth0   *       10.0.0.0/8
0.0.0.0/0          =20
    0     0 bogus_ip   all  --  eth0   *       10.0.0.0/8
0.0.0.0/0          =20
    0     0 bogus_ip   all  --  eth0   *       172.16.0.0/12
0.0.0.0/0          =20
    0     0 bogus_ip   all  --  eth0   *       192.168.0.0/16
0.0.0.0/0          =20
    0     0 bogus_ip   all  --  eth0   *       0.0.0.0/0
10.0.0.0/8         =20
    0     0 bogus_ip   all  --  eth0   *       0.0.0.0/0
172.16.0.0/12      =20
    0     0 bogus_ip   all  --  eth0   *       0.0.0.0/0
192.168.0.0/16     =20
    9   432 DNAT       tcp  --  eth0   *       66.173.97.0/27
aa.bb.212.154     tcp dpt:3389 to:10.13.1.22=20
   15   720 DNAT       tcp  --  eth0   *       0.0.0.0/0
aa.bb.212.154     tcp dpt:1723 to:10.13.1.22=20
    0     0 DNAT       47   --  eth0   *       0.0.0.0/0
aa.bb.212.154     to:10.13.1.22=20
  181  8736 DNAT       tcp  --  eth0   *       0.0.0.0/0
aa.bb.212.154     tcp dpt:25 to:10.13.1.22=20
    0     0 DNAT       tcp  --  eth0   *       0.0.0.0/0
aa.bb.212.154     tcp dpt:110 to:10.13.1.22=20
    1    48 DNAT       tcp  --  eth0   *       0.0.0.0/0
aa.bb.212.154     tcp dpt:143 to:10.13.1.22=20
    6   288 DNAT       tcp  --  *      *       0.0.0.0/0
aa.bb.212.154     tcp dpt:80 to:10.13.1.22=20
    0     0 DNAT       tcp  --  eth0   *       12.146.89.101
aa.bb.212.154     tcp dpt:23 to:10.13.1.50=20
    0     0 DNAT       tcp  --  eth0   *       12.146.89.10
aa.bb.212.154     tcp dpt:23 to:10.13.1.50=20
    0     0 DNAT       icmp --  eth0   *       12.146.89.101
aa.bb.212.154     icmp type 8 to:10.13.1.50=20
    0     0 DNAT       icmp --  eth0   *       12.146.89.10
aa.bb.212.154     icmp type 8 to:10.13.1.50=20

Chain POSTROUTING (policy ACCEPT 25898 packets, 7486K bytes)
 pkts bytes target     prot opt in     out     source
destination        =20
  520 27496 RETURN     all  --  *      eth0    0.0.0.0/0
10.0.0.0/8         =20
  522 25056 SNAT       tcp  --  *      eth0    10.13.1.22
0.0.0.0/0           tcp dpt:25 to:aa.bb.212.154=20
    0     0 MASQUERADE  tcp  --  *      eth1    10.13.1.0/24
10.13.1.22          tcp dpt:80=20
    0     0 SNAT       icmp --  *      eth0    10.13.1.50
12.146.89.101       icmp type 0 to:aa.bb.212.154=20
    0     0 SNAT       icmp --  *      eth0    10.13.1.50
12.146.89.10        icmp type 0 to:aa.bb.212.154=20
14032  763K MASQUERADE  all  --  *      eth0    0.0.0.0/0
0.0.0.0/0          =20

Chain OUTPUT (policy ACCEPT 150 packets, 34504 bytes)
 pkts bytes target     prot opt in     out     source
destination        =20

Chain bogus_ip (6 references)
 pkts bytes target     prot opt in     out     source
destination        =20
    0     0 LOG        all  --  *      *       0.0.0.0/0
0.0.0.0/0           LOG flags 0 level 4 prefix `spoofed packet'=20
    0     0 DROP       all  --  *      *       0.0.0.0/0
0.0.0.0/0          =20
[root@lakeville-fw gregs]#=20
[root@lakeville-fw gregs]#=20
[root@lakeville-fw gregs]#=20
[root@lakeville-fw gregs]#=20
[root@lakeville-fw gregs]#=20
[root@lakeville-fw gregs]# /usr/local/sbin/iptables -L -v -n
Chain INPUT (policy DROP 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source
destination        =20
63881   11M ACCEPT     all  --  *      *       0.0.0.0/0
0.0.0.0/0           state RELATED,ESTABLISHED=20
    6   360 ACCEPT     all  --  lo     *       0.0.0.0/0
0.0.0.0/0          =20
    0     0 ACCEPT     all  --  *      *       0.0.0.0/0
127.0.0.1          =20
    0     0 ACCEPT     all  --  *      *       127.0.0.1
0.0.0.0/0          =20
 1509 69414 ACCEPT     all  --  *      *       aa.bb.212.153
0.0.0.0/0          =20
19670 3176K ACCEPT     all  --  eth1   *       0.0.0.0/0
0.0.0.0/0          =20
    0     0 ACCEPT     all  --  eth2   *       0.0.0.0/0
0.0.0.0/0          =20
    3   138 ACCEPT     all  --  eth0   *       66.173.97.0/27
0.0.0.0/0          =20
   63 17464 ACCEPT     udp  --  eth0   *       0.0.0.0/0
0.0.0.0/0           udp spt:500 dpt:500=20
    3   376 ACCEPT     esp  --  eth0   *       0.0.0.0/0
0.0.0.0/0          =20
    0     0 ACCEPT     ah   --  eth0   *       0.0.0.0/0
0.0.0.0/0          =20
    0     0 ACCEPT     all  --  eth0   *       0.0.0.0/0
0.0.0.0/0           MARK match 0x1=20
    0     0 ACCEPT     all  --  eth0   *       0.0.0.0/0
0.0.0.0/0           MARK match 0x32=20
    0     0 allowed    tcp  --  *      *       0.0.0.0/0
10.13.1.22          tcp dpt:1723=20
    0     0 ACCEPT     47   --  *      *       0.0.0.0/0
10.13.1.22         =20
   11 12084 icmp_packets  icmp --  eth0   *       0.0.0.0/0
0.0.0.0/0          =20
  698 71992 tcp_packets  tcp  --  eth0   *       0.0.0.0/0
0.0.0.0/0          =20
  182 89571 udpincoming_packets  udp  --  eth0   *       0.0.0.0/0
0.0.0.0/0          =20
  887  173K LOG        all  --  *      *       0.0.0.0/0
0.0.0.0/0           LOG flags 0 level 4=20
  887  173K DROP       all  --  *      *       0.0.0.0/0
0.0.0.0/0          =20

Chain FORWARD (policy DROP 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source
destination        =20
 512K  196M ACCEPT     all  --  *      *       0.0.0.0/0
0.0.0.0/0           state RELATED,ESTABLISHED=20
    0     0 ACCEPT     all  --  *      *       aa.bb.212.153
0.0.0.0/0          =20
12190  585K LOG        tcp  --  eth1   *      !10.13.1.22
0.0.0.0/0           tcp dpt:25 LOG flags 0 level 4 prefix `Illeg
al outbound email '=20
12190  585K DROP       tcp  --  eth1   *      !10.13.1.22
0.0.0.0/0           tcp dpt:25=20
 160K   42M ACCEPT     all  --  eth1   *       0.0.0.0/0
0.0.0.0/0          =20
    0     0 ACCEPT     all  --  eth2   *       0.0.0.0/0
0.0.0.0/0          =20
   14   672 ACCEPT     all  --  eth0   *       66.173.97.0/27
0.0.0.0/0          =20
 4162  896K ACCEPT     all  --  eth0   *       10.0.0.0/8
0.0.0.0/0          =20
   10   480 allowed    tcp  --  *      *       0.0.0.0/0
10.13.1.22          tcp dpt:1723=20
    0     0 ACCEPT     47   --  *      *       0.0.0.0/0
10.13.1.22         =20
  181  8736 allowed    tcp  --  *      *       0.0.0.0/0
10.13.1.22          tcp dpt:25=20
    0     0 allowed    tcp  --  *      *       0.0.0.0/0
10.13.1.22          tcp dpt:110=20
    1    48 allowed    tcp  --  *      *       0.0.0.0/0
10.13.1.22          tcp dpt:143=20
    6   288 allowed    tcp  --  *      *       0.0.0.0/0
10.13.1.22          tcp dpt:80=20
    0     0 allowed    tcp  --  *      *       12.146.89.101
10.13.1.50          tcp dpt:23=20
    0     0 allowed    tcp  --  *      *       12.146.89.10
10.13.1.50          tcp dpt:23=20
    0     0 LOG        all  --  *      *       0.0.0.0/0
0.0.0.0/0           LOG flags 0 level 4=20
    0     0 DROP       all  --  *      *       0.0.0.0/0
0.0.0.0/0          =20

Chain OUTPUT (policy DROP 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source
destination        =20
46266   13M ACCEPT     all  --  *      eth0    0.0.0.0/0
0.0.0.0/0          =20
30618 5013K ACCEPT     all  --  *      eth1    0.0.0.0/0
0.0.0.0/0          =20
   84  8067 ACCEPT     all  --  *      lo      0.0.0.0/0
0.0.0.0/0          =20
    0     0 ACCEPT     all  --  *      eth2    0.0.0.0/0
0.0.0.0/0          =20
    0     0 ACCEPT     all  --  *      *       127.0.0.1
0.0.0.0/0          =20
    0     0 LOG        all  --  *      *       0.0.0.0/0
0.0.0.0/0           LOG flags 0 level 4=20
    0     0 DROP       all  --  *      *       0.0.0.0/0
0.0.0.0/0          =20

Chain allowed (10 references)
 pkts bytes target     prot opt in     out     source
destination        =20
  198  9552 ACCEPT     tcp  --  *      *       0.0.0.0/0
0.0.0.0/0           tcp flags:0x17/0x02=20
    0     0 LOG        tcp  --  *      *       0.0.0.0/0
0.0.0.0/0           LOG flags 0 level 4 prefix `Malformed packet
! '=20
    0     0 DROP       tcp  --  *      *       0.0.0.0/0
0.0.0.0/0          =20

Chain icmp_packets (1 references)
 pkts bytes target     prot opt in     out     source
destination        =20
    0     0 ACCEPT     icmp --  *      *       12.146.89.101
10.13.1.50          icmp type 8=20
    0     0 ACCEPT     icmp --  *      *       12.146.89.10
10.13.1.50          icmp type 8=20
    0     0 ACCEPT     icmp --  *      *       10.13.1.50
12.146.89.101       icmp type 0=20
    0     0 ACCEPT     icmp --  *      *       10.13.1.50
12.146.89.10        icmp type 0=20

Chain tcp_packets (1 references)
 pkts bytes target     prot opt in     out     source
destination        =20
    0     0 allowed    tcp  --  eth1   *       0.0.0.0/0
0.0.0.0/0           tcp dpt:21=20
    0     0 allowed    tcp  --  eth2   *       0.0.0.0/0
0.0.0.0/0           tcp dpt:21=20
    4   216 LOG        tcp  --  *      *       0.0.0.0/0
0.0.0.0/0           tcp dpt:21 LOG flags 0 level 4 prefix `inbou
nd FTP packet'=20
    4   216 DROP       tcp  --  *      *       0.0.0.0/0
0.0.0.0/0           tcp dpt:21=20

Chain udpincoming_packets (1 references)
 pkts bytes target     prot opt in     out     source
destination        =20
[root@lakeville-fw gregs]#=20
[root@lakeville-fw gregs]#=20
[root@lakeville-fw gregs]# /usr/local/sbin/iptables -L -v -n -t mangle
Chain PREROUTING (policy ACCEPT 809K packets, 256M bytes)
 pkts bytes target     prot opt in     out     source
destination        =20
63105   11M MARK       esp  --  eth0   *       0.0.0.0/0
0.0.0.0/0           MARK set 0x32=20
    0     0 MARK       all  --  eth0   *       0.0.0.0/0
10.13.1.11          MARK set 0x1=20

Chain INPUT (policy ACCEPT 87799 packets, 15M bytes)
 pkts bytes target     prot opt in     out     source
destination        =20

Chain FORWARD (policy ACCEPT 694K packets, 240M bytes)
 pkts bytes target     prot opt in     out     source
destination        =20

Chain OUTPUT (policy ACCEPT 93478 packets, 21M bytes)
 pkts bytes target     prot opt in     out     source
destination        =20

Chain POSTROUTING (policy ACCEPT 760K packets, 257M bytes)
 pkts bytes target     prot opt in     out     source
destination        =20
    0     0 MARK       all  --  *      eth0    10.13.1.11
0.0.0.0/0           MARK set 0x1=20
[root@lakeville-fw gregs]#=20




-----Original Message-----
From: Patrick McHardy [mailto:kaber@trash.net]=20
Sent: Monday, August 28, 2006 4:24 AM
To: Greg Scott
Cc: netfilter-devel@lists.netfilter.org; Mike McRae
Subject: Re: Troubeleshooting a PPTP conversation

Greg Scott wrote:
> Hello -
> =20
> I have a firewall with kernel 2.6.17.1 and iptables 1.3.5.  Behind it=20
> is a Win2000 server with MS RRAS.  I am using ip_nat_pptp and=20
> ip_conntrack_pptp and trying to setup a PPTP VPN connection from my=20
> place to this target server. I have appropriate NAT and filtering=20
> rules set up for tcp 1723 and GRE.  It all works great when I do it=20
> the first time but began failing for some people after multiple=20
> connections or connections from different PCs behind the same remote=20
> NAT gateway.  Now it is behaving badly for me.  I had a PPTP=20
> connection from my place to the target site last night and then it=20
> dropped unexpectedly for some reason.  Today I am not able to=20
> establish it again.  It's almost as if the firewall thinks the old=20
> connnection is still alive and it won't get rid of a leftover bogus
conntrack entry to start a new one.

What does /proc/net/ip_conntrack show?

> Below is some tcpdump output and I am trying to understand what it is=20
> telling me:  I did a little bit of formatting to hopefully make it=20
> readable.  66.173.97.0/27 is my place.  The target site is=20
> aaa.bbb.212.154.

What is 10.13.1.22? Please also show your NAT rules and explain on which
side of the firewall your sniffing.

> 18:42:15.012881 IP (tos 0x0, ttl 126, id 54977, offset 0, flags [DF],
> proto: TCP (6), length: 72) 10.13.1.22.1723 > 66.173.97.2.2903
> : P, cksum 0xaf0c (incorrect (-> 0x4d48), 1787486805:1787486837(32)=20
> ack
> 1914062599 win 65211: pptp Length=3D32 CTRL-MSG Magic-Cookie=3D1 =
a2b3c4d=20
> CTRL_MSGTYPE=3DOCRP CALL_ID(999) PEER_CALL_ID(2903)
> RESULT_CODE(1:Connected) ERR_CODE(0:None) CAUSE_CODE(0)
> CONN_SPEED(1480832
> 5) RECV_WIN(16384) PROC_DELAY(0) PHY_CHAN_ID(0)
