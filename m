From: "zze-Proxy_Corveller ball001 exterieur FTRD" <proxycorveller.ball001@rd.francetelecom.com>
Subject: Again a VLAN problem at with DNAT
Date: Wed, 30 Apr 2003 18:47:37 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <8C19E3FBB6467846AFF97E366D34CB6055A024@lanmhs20.rd.francetelecom.fr>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C30F38.348546A8"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
content-class: urn:content-classes:message
To: "Netfilter-Devel (E-mail)" <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C30F38.348546A8
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi,

A few days ago, i wrote a mail on the list concerning a DNAT problem on =
packets that come from VLANs on my machine.
I've put some trace messages in netfilter files, i noted some difference =
in the processing of packets in ip_conntrack_core :

A normal packet:
...
Apr 30 16:48:45 raqare kernel: ---- ip_conntrack_core : __find_proto, 17 =
proto found --> udp
Apr 30 16:48:45 raqare kernel: ---- ip_conntrack_core : =
resolve_normal_ct in
Apr 30 16:48:45 raqare kernel: ---- ip_conntrack_core : get_tuple return =
iph proto : 17, dst : 10.10.10.161(2701789706), src : =
10.10.10.111(1862928906)
Apr 30 16:48:45 raqare kernel: ---- ip_conntrack_proto_udp : =
udp_pkt_to_tuple : src port 1024 and port dst : 1719
Apr 30 16:48:45 raqare kernel: ---- ip_conntrack_core : =
ip_conntrack_find_get
Apr 30 16:48:45 raqare kernel: ---- ip_conntrack_core : =
__ip_conntrack_find
Apr 30 16:48:45 raqare kernel: ---- ip_conntrack_core : return NULL, =
must init_conntrack
Apr 30 16:48:45 raqare kernel: ---- ip_conntrack_core : init_conntrack
Apr 30 16:48:45 raqare kernel: ---- ip_conntrack_core : invert_tuple =
tuple old proto : 17, dst : 10.10.10.161(2701789706), src : =
10.10.10.111(1862928906)
Apr 30 16:48:45 raqare kernel: ---- ip_conntrack_proto_udp : =
udp_invert_tuple : old src port 1024 and old port dst : 1719
Apr 30 16:48:45 raqare kernel: ---- ip_conntrack_core : =
resolve_normal_ct continue
Apr 30 16:48:45 raqare kernel: ---- ip_conntrack_core : return conntrack
...
Apr 30 16:48:46 raqare kernel: ---- ip_nat_standalone : ip_nat_fn out =
with do_bindings=20
Apr 30 16:48:46 raqare kernel: ---- ip_nat_core.c : do_bindingsn nb of =
manip : 2
Apr 30 16:48:46 raqare kernel: ---- ip_nat_core.c : do_bindings loop in=20
Apr 30 16:48:46 raqare kernel: ---- ip_nat_core.c : do_bindings loop =
continue=20
Apr 30 16:48:46 raqare kernel: ---- ip_nat_core.c : do_bindings need =
Mangling DST
Apr 30 16:48:46 raqare kernel: ---- ip_nat_core.c : do_bindings loop in=20
Apr 30 16:48:46 raqare kernel: ---- ip_nat_core.c : do_bindings loop =
continue=20
Apr 30 16:48:46 raqare kernel: ---- ip_nat_core.c : do_bindings loop out =

Apr 30 16:48:46 raqare kernel: ---- netfilter.c : nf_iterate skblen :  =
return NF_ACCEPT
...


A packet coming from VLANs :
...
Apr 30 16:35:08 raqare kernel: ---- ip_conntrack_core : __find_proto, 17 =
proto found --> udp
Apr 30 16:35:08 raqare kernel: ---- ip_conntrack_core : =
resolve_normal_ct in
Apr 30 16:35:08 raqare kernel: ---- ip_conntrack_core : get_tuple return =
iph proto : 17, dst : 10.10.10.161(2701789706), src : =
10.10.10.111(1862928906)
Apr 30 16:35:08 raqare kernel: ---- ip_conntrack_proto_udp : =
udp_pkt_to_tuple : src port 1024 and port dst : 1719
Apr 30 16:35:08 raqare kernel: ---- ip_conntrack_core : =
ip_conntrack_find_get
Apr 30 16:35:08 raqare kernel: ---- ip_conntrack_core : =
__ip_conntrack_find
Apr 30 16:35:08 raqare kernel: ---- ip_conntrack_tuple.h : =
ip_ct_tuple_dst_equal ip_t1 : 10.10.10.161(2701789706), ip_t2 : =
10.10.10.161(2701789706), all_t1 : 46854, all_t2 : 46854, p_t1 : 17, =
p_t2 : 17=20
Apr 30 16:35:08 raqare kernel: ---- ip_conntrack_core : =
resolve_normal_ct continue
Apr 30 16:35:08 raqare kernel: ---- ip_conntrack_core : return conntrack
...
Apr 30 16:35:08 raqare kernel: ---- ip_nat_standalone : ip_nat_fn out =
with do_bindings=20
Apr 30 16:35:08 raqare kernel: ---- ip_nat_core.c : do_bindingsn nb of =
manip : 0
Apr 30 16:35:08 raqare kernel: ---- ip_nat_core.c : do_bindings loop out =

Apr 30 16:35:08 raqare kernel: ---- netfilter.c : nf_iterate skblen :  =
return NF_ACCEPT
...

Any idea about my problem ?




Here are the complete traces and my configuration :
Configuration without VLAN :
ifconfig:

eth0      Lien encap:Ethernet  HWaddr 00:08:9B:02:6B:BF =20
          inet adr:10.194.67.102  Bcast:10.194.67.127  =
Masque:255.255.255.192
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:3261 errors:0 dropped:0 overruns:0 frame:5
          TX packets:152 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 lg file transmission:100=20
          RX bytes:295275 (288.3 Kb)  TX bytes:15479 (15.1 Kb)
          Interruption:10 Adresse de base:0xa000=20

eth1      Lien encap:Ethernet  HWaddr 00:08:9B:02:6B:C0 =20
          inet adr:172.20.14.75  Bcast:172.20.14.127  =
Masque:255.255.255.128
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:4405 errors:0 dropped:0 overruns:0 frame:15
          TX packets:1551 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 lg file transmission:100=20
          RX bytes:369447 (360.7 Kb)  TX bytes:255682 (249.6 Kb)
          Interruption:9 Adresse de base:0xc000=20

eth2      Lien encap:Ethernet  HWaddr 00:07:E9:09:00:E4 =20
          inet adr:10.10.10.161  Bcast:10.255.255.255  =
Masque:255.255.255.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:20 errors:0 dropped:0 overruns:0 frame:0
          TX packets:86 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 lg file transmission:100=20
          RX bytes:3242 (3.1 Kb)  TX bytes:12491 (12.1 Kb)
          Interruption:10 Adresse de base:0xc000 M=E9moire:e7a00000-0=20

lo        Lien encap:Boucle locale =20
          inet adr:127.0.0.1  Masque:255.0.0.0
          UP LOOPBACK RUNNING  MTU:16436  Metric:1
          RX packets:495 errors:0 dropped:0 overruns:0 frame:0
          TX packets:495 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 lg file transmission:0=20
          RX bytes:32458 (31.6 Kb)  TX bytes:32458 (31.6 Kb)

iptables -t nat -L -n -v :

Chain PREROUTING (policy ACCEPT 870 packets, 123K bytes)
 pkts bytes target     prot opt in     out     source               =
destination        =20
    3   432 DNAT       all  --  eth2   *       0.0.0.0/0            =
10.10.10.161       to:20.20.0.10=20

Chain POSTROUTING (policy ACCEPT 313 packets, 27612 bytes)
 pkts bytes target     prot opt in     out     source               =
destination        =20

Chain OUTPUT (policy ACCEPT 313 packets, 27612 bytes)
 pkts bytes target     prot opt in     out     source               =
destination  =20

Traces without VLAN :
Apr 30 16:48:45 raqare kernel: ---- netfilter.c : nf_iterate protocol : =
8, skblen : 144, in_dev : eth2, our_dev : <NULL>
Apr 30 16:48:45 raqare kernel: ---- netfilter.c : nf_iterate protocol : =
8, skblen : 144, in_dev : eth2, our_dev : <NULL>
Apr 30 16:48:45 raqare kernel: ---- ip_conntrack_core : ip_conntrack_in
Apr 30 16:48:45 raqare kernel: ---- ip_conntrack_core : find_proto 17
Apr 30 16:48:45 raqare kernel: ---- ip_conntrack_core : proto_cmpfn, =
proto =3D 17, curr->proto =3D 6
Apr 30 16:48:45 raqare kernel: ---- ip_conntrack_core : proto_cmpfn, =
proto =3D 17, curr->proto =3D 17
Apr 30 16:48:45 raqare kernel: ---- ip_conntrack_core : __find_proto, 17 =
proto found --> udp
Apr 30 16:48:45 raqare kernel: ---- ip_conntrack_core : =
resolve_normal_ct in
Apr 30 16:48:45 raqare kernel: ---- ip_conntrack_core : get_tuple return =
iph proto : 17, dst : 10.10.10.161(2701789706), src : =
10.10.10.111(1862928906)
Apr 30 16:48:45 raqare kernel: ---- ip_conntrack_proto_udp : =
udp_pkt_to_tuple : src port 1024 and port dst : 1719
Apr 30 16:48:45 raqare kernel: ---- ip_conntrack_core : =
ip_conntrack_find_get
Apr 30 16:48:45 raqare kernel: ---- ip_conntrack_core : =
__ip_conntrack_find
Apr 30 16:48:45 raqare kernel: ---- ip_conntrack_core : h NULL, must =
init_conntrack
Apr 30 16:48:45 raqare kernel: ---- ip_conntrack_core : init_conntrack
Apr 30 16:48:45 raqare kernel: ---- ip_conntrack_core : invert_tuple =
tuple old proto : 17, dst : 10.10.10.161(2701789706), src : =
10.10.10.111(1862928906)
Apr 30 16:48:45 raqare kernel: ---- ip_conntrack_proto_udp : =
udp_invert_tuple : old src port 1024 and old port dst : 1719
Apr 30 16:48:45 raqare kernel: ---- ip_conntrack_core : =
resolve_normal_ct continue
Apr 30 16:48:45 raqare kernel: ---- ip_conntrack_core : return conntrack
Apr 30 16:48:45 raqare kernel: ---- ip_conntrack_core : ip_conntrack_in =
now proto packet
Apr 30 16:48:45 raqare kernel: ---- ip_conntrack_core : ip_conntrack_in =
out normaly
Apr 30 16:48:45 raqare kernel: ---- netfilter.c : nf_iterate protocol : =
8, skblen : 144, in_dev : eth2, our_dev : <NULL>
Apr 30 16:48:46 raqare kernel: ---- iptable_mangle : ipt_route_hook
Apr 30 16:48:46 raqare kernel: ---- iptable_mangle : ipt_route_hook =
return with ipt_do_table
Apr 30 16:48:46 raqare kernel: ---- netfilter.c : nf_iterate protocol : =
8, skblen : 144, in_dev : eth2, our_dev : <NULL>
Apr 30 16:48:46 raqare kernel: ---- ip_nat_standalone : ip_nat_fn in=20
Apr 30 16:48:46 raqare kernel: ---- ip_conntrack_core : =
__ip_conntrack_get
Apr 30 16:48:46 raqare kernel: ---- ip_nat_standalone : ip_nat_fn =
continue
Apr 30 16:48:46 raqare kernel: ---- ip_nat_standalone : ip_nat_fn =
IP_CT_NEW
Apr 30 16:48:46 raqare kernel: ---- ip_conntrack_core : =
__ip_conntrack_get
Apr 30 16:48:46 raqare kernel: ---- ip_conntrack_core : find_proto 17
Apr 30 16:48:46 raqare kernel: ---- ip_conntrack_core : proto_cmpfn, =
proto =3D 17, curr->proto =3D 6
Apr 30 16:48:46 raqare kernel: ---- ip_conntrack_core : proto_cmpfn, =
proto =3D 17, curr->proto =3D 17
Apr 30 16:48:46 raqare kernel: ---- ip_conntrack_core : __find_proto, 17 =
proto found --> udp
Apr 30 16:48:46 raqare kernel: ---- ip_conntrack_core : invert_tuple =
tuple old proto : 17, dst : 10.10.10.111(1862928906), src : =
10.10.10.161(2701789706)
Apr 30 16:48:46 raqare kernel: ---- ip_conntrack_proto_udp : =
udp_invert_tuple : old src port 1719 and old port dst : 1024
Apr 30 16:48:46 raqare kernel: ---- ip_nat_core.c : =
find_best_ips_proto_fast assign tuple dst : 2701789706, src : 1862928906
Apr 30 16:48:46 raqare kernel: ---- ip_conntrack_core : find_proto 17
Apr 30 16:48:46 raqare kernel: ---- ip_conntrack_core : proto_cmpfn, =
proto =3D 17, curr->proto =3D 6
Apr 30 16:48:46 raqare kernel: ---- ip_conntrack_core : proto_cmpfn, =
proto =3D 17, curr->proto =3D 17
Apr 30 16:48:46 raqare kernel: ---- ip_conntrack_core : __find_proto, 17 =
proto found --> udp
Apr 30 16:48:46 raqare kernel: ---- ip_conntrack_core : invert_tuple =
tuple old proto : 17, dst : 20.20.0.10(167777300), src : =
10.10.10.111(1862928906)
Apr 30 16:48:46 raqare kernel: ---- ip_conntrack_proto_udp : =
udp_invert_tuple : old src port 1024 and old port dst : 1719
Apr 30 16:48:46 raqare kernel: ---- ip_conntrack_core : =
__ip_conntrack_find
Apr 30 16:48:46 raqare kernel: ---- ip_conntrack_core : =
ip_conntrack_tuple_taken, NOT found
Apr 30 16:48:46 raqare kernel: ---- ip_conntrack_core : find_proto 17
Apr 30 16:48:46 raqare kernel: ---- ip_conntrack_core : proto_cmpfn, =
proto =3D 17, curr->proto =3D 6
Apr 30 16:48:46 raqare kernel: ---- ip_conntrack_core : proto_cmpfn, =
proto =3D 17, curr->proto =3D 17
Apr 30 16:48:46 raqare kernel: ---- ip_conntrack_core : __find_proto, 17 =
proto found --> udp
Apr 30 16:48:46 raqare kernel: ---- ip_conntrack_core : invert_tuple =
tuple old proto : 17, dst : 20.20.0.10(167777300), src : =
10.10.10.111(1862928906)
Apr 30 16:48:46 raqare kernel: ---- ip_conntrack_proto_udp : =
udp_invert_tuple : old src port 1024 and old port dst : 1719
Apr 30 16:48:46 raqare kernel: ---- ip_conntrack_core : =
__ip_conntrack_find
Apr 30 16:48:46 raqare kernel: ---- ip_conntrack_core : find_proto 17
Apr 30 16:48:46 raqare kernel: ---- ip_conntrack_core : proto_cmpfn, =
proto =3D 17, curr->proto =3D 6
Apr 30 16:48:46 raqare kernel: ---- ip_conntrack_core : proto_cmpfn, =
proto =3D 17, curr->proto =3D 17
Apr 30 16:48:46 raqare kernel: ---- ip_conntrack_core : __find_proto, 17 =
proto found --> udp
Apr 30 16:48:46 raqare kernel: ---- ip_conntrack_core : invert_tuple =
tuple old proto : 17, dst : 10.10.10.161(2701789706), src : =
10.10.10.111(1862928906)
Apr 30 16:48:46 raqare kernel: ---- ip_conntrack_proto_udp : =
udp_invert_tuple : old src port 1024 and old port dst : 1719
Apr 30 16:48:46 raqare kernel: ---- ip_nat_core.c :  ip_nat_setup_info =
do some checks
Apr 30 16:48:46 raqare kernel: ---- ip_conntrack_tuple.h : =
ip_ct_tuple_dst_equal ip_t1 : 20.20.0.10(167777300), ip_t2 : =
10.10.10.161(2701789706), all_t1 : 46854, all_t2 : 46854, p_t1 : 17, =
p_t2 : 17=20
Apr 30 16:48:46 raqare kernel: ---- ip_nat_core.c :  ip_nat_setup_info =
dst_equal
Apr 30 16:48:46 raqare kernel: ---- ip_nat_standalone : ip_nat_fn out =
with do_bindings=20
Apr 30 16:48:46 raqare kernel: ---- ip_nat_core.c : do_bindingsn nb of =
manip : 2
Apr 30 16:48:46 raqare kernel: ---- ip_nat_core.c : do_bindings loop in=20
Apr 30 16:48:46 raqare kernel: ---- ip_nat_core.c : do_bindings loop =
continue=20
Apr 30 16:48:46 raqare kernel: ---- ip_nat_core.c : do_bindings need =
Mangling DST
Apr 30 16:48:46 raqare kernel: ---- ip_nat_core.c : do_bindings loop in=20
Apr 30 16:48:46 raqare kernel: ---- ip_nat_core.c : do_bindings loop =
continue=20
Apr 30 16:48:46 raqare kernel: ---- ip_nat_core.c : do_bindings loop out =

Apr 30 16:48:46 raqare kernel: ---- netfilter.c : nf_iterate skblen :  =
return NF_ACCEPT

Configuration with VLAN :
ifconfig
eth0      Lien encap:Ethernet  HWaddr 00:08:9B:02:6B:BF =20
          inet adr:10.194.67.102  Bcast:10.194.67.127  =
Masque:255.255.255.192
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:3391 errors:0 dropped:0 overruns:0 frame:5
          TX packets:155 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 lg file transmission:100=20
          RX bytes:306377 (299.1 Kb)  TX bytes:15737 (15.3 Kb)
          Interruption:10 Adresse de base:0xa000=20

eth1      Lien encap:Ethernet  HWaddr 00:08:9B:02:6B:C0 =20
          inet adr:172.20.14.75  Bcast:172.20.14.127  =
Masque:255.255.255.128
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:4646 errors:0 dropped:0 overruns:0 frame:16
          TX packets:1676 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 lg file transmission:100=20
          RX bytes:387898 (378.8 Kb)  TX bytes:278811 (272.2 Kb)
          Interruption:9 Adresse de base:0xc000=20

eth2      Lien encap:Ethernet  HWaddr 00:07:E9:09:00:E4 =20
          inet adr:10.10.10.161  Bcast:10.255.255.255  =
Masque:255.255.255.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:25 errors:0 dropped:0 overruns:0 frame:0
          TX packets:90 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 lg file transmission:100=20
          RX bytes:3958 (3.8 Kb)  TX bytes:13201 (12.8 Kb)
          Interruption:10 Adresse de base:0xc000 M=E9moire:e7a00000-0=20

lo        Lien encap:Boucle locale =20
          inet adr:127.0.0.1  Masque:255.0.0.0
          UP LOOPBACK RUNNING  MTU:16436  Metric:1
          RX packets:495 errors:0 dropped:0 overruns:0 frame:0
          TX packets:495 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 lg file transmission:0=20
          RX bytes:32458 (31.6 Kb)  TX bytes:32458 (31.6 Kb)

vlan0010  Lien encap:Ethernet  HWaddr 00:07:E9:09:00:E4 =20
          inet adr:20.20.0.10  Bcast:20.255.255.255  =
Masque:255.255.255.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 lg file transmission:0=20
          RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)

vlan0020  Lien encap:Ethernet  HWaddr 00:07:E9:09:00:E4 =20
          inet adr:20.20.0.20  Bcast:20.255.255.255  =
Masque:255.255.255.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 lg file transmission:0=20
          RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)

iptables -t nat -L -n -v :
Chain PREROUTING (policy ACCEPT 899 packets, 127K bytes)
 pkts bytes target     prot opt in     out     source               =
destination        =20
    0     0 DNAT       all  --  vlan0010 *       0.0.0.0/0            =
10.10.10.161       to:20.20.0.10=20

Chain POSTROUTING (policy ACCEPT 324 packets, 28980 bytes)
 pkts bytes target     prot opt in     out     source               =
destination        =20

Chain OUTPUT (policy ACCEPT 324 packets, 28980 bytes)
 pkts bytes target     prot opt in     out     source               =
destination =20

Traces with VLAN :
Apr 30 16:35:08 raqare kernel: ---- netfilter.c : nf_iterate protocol : =
8, skblen : 144, in_dev : vlan0010, our_dev : <NULL>
Apr 30 16:35:08 raqare kernel: ---- netfilter.c : nf_iterate protocol : =
8, skblen : 144, in_dev : vlan0010, our_dev : <NULL>
Apr 30 16:35:08 raqare kernel: ---- ip_conntrack_core : ip_conntrack_in
Apr 30 16:35:08 raqare kernel: ---- ip_conntrack_core : find_proto 17
Apr 30 16:35:08 raqare kernel: ---- ip_conntrack_core : proto_cmpfn, =
proto =3D 17, curr->proto =3D 6
Apr 30 16:35:08 raqare kernel: ---- ip_conntrack_core : proto_cmpfn, =
proto =3D 17, curr->proto =3D 17
Apr 30 16:35:08 raqare kernel: ---- ip_conntrack_core : __find_proto, 17 =
proto found --> udp
Apr 30 16:35:08 raqare kernel: ---- ip_conntrack_core : =
resolve_normal_ct in
Apr 30 16:35:08 raqare kernel: ---- ip_conntrack_core : get_tuple return =
iph proto : 17, dst : 10.10.10.161(2701789706), src : =
10.10.10.111(1862928906)
Apr 30 16:35:08 raqare kernel: ---- ip_conntrack_proto_udp : =
udp_pkt_to_tuple : src port 1024 and port dst : 1719
Apr 30 16:35:08 raqare kernel: ---- ip_conntrack_core : =
ip_conntrack_find_get
Apr 30 16:35:08 raqare kernel: ---- ip_conntrack_core : =
__ip_conntrack_find
Apr 30 16:35:08 raqare kernel: ---- ip_conntrack_tuple.h : =
ip_ct_tuple_dst_equal ip_t1 : 10.10.10.161(2701789706), ip_t2 : =
10.10.10.161(2701789706), all_t1 : 46854, all_t2 : 46854, p_t1 : 17, =
p_t2 : 17=20
Apr 30 16:35:08 raqare kernel: ---- ip_conntrack_core : =
resolve_normal_ct continue
Apr 30 16:35:08 raqare kernel: ---- ip_conntrack_core : return conntrack
Apr 30 16:35:08 raqare kernel: ---- ip_conntrack_core : ip_conntrack_in =
now proto packet
Apr 30 16:35:08 raqare kernel: ---- ip_conntrack_core : ip_conntrack_in =
out normaly
Apr 30 16:35:08 raqare kernel: ---- netfilter.c : nf_iterate protocol : =
8, skblen : 144, in_dev : vlan0010, our_dev : <NULL>
Apr 30 16:35:08 raqare kernel: ---- iptable_mangle : ipt_route_hook
Apr 30 16:35:08 raqare kernel: ---- iptable_mangle : ipt_route_hook =
return with ipt_do_table
Apr 30 16:35:08 raqare kernel: ---- netfilter.c : nf_iterate protocol : =
8, skblen : 144, in_dev : vlan0010, our_dev : <NULL>
Apr 30 16:35:08 raqare kernel: ---- ip_nat_standalone : ip_nat_fn in=20
Apr 30 16:35:08 raqare kernel: ---- ip_conntrack_core : =
__ip_conntrack_get
Apr 30 16:35:08 raqare kernel: ---- ip_nat_standalone : ip_nat_fn =
continue
Apr 30 16:35:08 raqare kernel: ---- ip_nat_standalone : ip_nat_fn =
IP_CT_NEW
Apr 30 16:35:08 raqare kernel: ---- ip_nat_standalone : ip_nat_fn out =
with do_bindings=20
Apr 30 16:35:08 raqare kernel: ---- ip_nat_core.c : do_bindingsn nb of =
manip : 0
Apr 30 16:35:08 raqare kernel: ---- ip_nat_core.c : do_bindings loop out =

Apr 30 16:35:08 raqare kernel: ---- netfilter.c : nf_iterate skblen :  =
return NF_ACCEPT
Apr 30 16:35:08 raqare kernel: ---- netfilter.c : nf_iterate protocol : =
8, skblen : 144, in_dev : vlan0010, our_dev : <NULL>
Apr 30 16:35:08 raqare kernel: ---- iptable_mangle : ipt_local_hook
Apr 30 16:35:08 raqare kernel: ---- iptable_mangle : ipt_lcoal_hook out
Apr 30 16:35:08 raqare kernel: ---- netfilter.c : nf_iterate protocol : =
8, skblen : 144, in_dev : vlan0010, our_dev : <NULL>
Apr 30 16:35:08 raqare kernel: ---- iptable_filter : ipt_hook
Apr 30 16:35:08 raqare kernel: ---- iptable_filter : ipt_hook return =
with ipt_do_table
Apr 30 16:35:08 raqare kernel: ---- netfilter.c : nf_iterate protocol : =
8, skblen : 144, in_dev : vlan0010, our_dev : <NULL>
Apr 30 16:35:08 raqare kernel: ---- ip_conntrack_standalone : ip_confirm =
return with ip_conntrack_confirm
Apr 30 16:35:08 raqare kernel: ---- netfilter.c : nf_iterate skblen :  =
return NF_ACCEPT

------_=_NextPart_001_01C30F38.348546A8
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">
<HTML>
<HEAD>
<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; =
charset=3Diso-8859-1">
<META NAME=3D"Generator" CONTENT=3D"MS Exchange Server version =
6.0.6389.0">
<TITLE>Again a VLAN problem at with DNAT</TITLE>
</HEAD>
<BODY>
<!-- Converted from text/rtf format -->

<P><FONT SIZE=3D2 FACE=3D"Courier New">Hi,</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">A few days ago, i wrote a mail on =
the list concerning a DNAT problem on packets that come from VLANs on my =
machine.</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">I've put some trace messages in =
netfilter files, i noted some difference in the processing of packets in =
ip_conntrack_core :</FONT></P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">A normal packet:</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">...</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:45 raqare kernel: =
---- ip_conntrack_core : __find_proto, 17 proto found --&gt; udp</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:45 raqare kernel: =
---- ip_conntrack_core : resolve_normal_ct in</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:45 raqare kernel: =
---- ip_conntrack_core : get_tuple return iph proto : 17, dst : =
10.10.10.161(2701789706), src : 10.10.10.111(1862928906)</FONT></P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:45 raqare kernel: =
---- ip_conntrack_proto_udp : udp_pkt_to_tuple : src port 1024 and port =
dst : 1719</FONT>

<BR><B><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:45 raqare =
kernel: ---- ip_conntrack_core : ip_conntrack_find_get</FONT></B>

<BR><B><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:45 raqare =
kernel: ---- ip_conntrack_core : __ip_conntrack_find</FONT></B>

<BR><B><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:45 raqare =
kernel: ---- ip_conntrack_core : return NULL, must =
init_conntrack</FONT></B>

<BR><B><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:45 raqare =
kernel: ---- ip_conntrack_core : init_conntrack</FONT></B>

<BR><B><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:45 raqare =
kernel: ---- ip_conntrack_core : invert_tuple tuple old proto : 17, dst =
: 10.10.10.161(2701789706), src : =
10.10.10.111(1862928906)</FONT></B></P>

<P><B><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:45 raqare kernel: =
---- ip_conntrack_proto_udp : udp_invert_tuple : old src port 1024 and =
old port dst : 1719</FONT></B></P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:45 raqare kernel: =
---- ip_conntrack_core : resolve_normal_ct continue</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:45 raqare kernel: =
---- ip_conntrack_core : return conntrack</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">...</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:46 raqare kernel: =
---- ip_nat_standalone : ip_nat_fn out with do_bindings </FONT>

<BR><B><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:46 raqare =
kernel: ---- ip_nat_core.c : do_bindingsn nb of manip : 2</FONT></B>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:46 raqare kernel: =
---- ip_nat_core.c : do_bindings loop in </FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:46 raqare kernel: =
---- ip_nat_core.c : do_bindings loop continue </FONT>

<BR><B><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:46 raqare =
kernel: ---- ip_nat_core.c : do_bindings need Mangling DST</FONT></B>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:46 raqare kernel: =
---- ip_nat_core.c : do_bindings loop in </FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:46 raqare kernel: =
---- ip_nat_core.c : do_bindings loop continue </FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:46 raqare kernel: =
---- ip_nat_core.c : do_bindings loop out </FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:46 raqare kernel: =
---- netfilter.c : nf_iterate skblen :&nbsp; return NF_ACCEPT</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">...</FONT>
</P>
<BR>

<P><FONT SIZE=3D2 FACE=3D"Courier New">A packet coming from VLANs =
:</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">...</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:35:08 raqare kernel: =
---- ip_conntrack_core : __find_proto, 17 proto found --&gt; udp</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:35:08 raqare kernel: =
---- ip_conntrack_core : resolve_normal_ct in</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:35:08 raqare kernel: =
---- ip_conntrack_core : get_tuple return iph proto : 17, dst : =
10.10.10.161(2701789706), src : 10.10.10.111(1862928906)</FONT></P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:35:08 raqare kernel: =
---- ip_conntrack_proto_udp : udp_pkt_to_tuple : src port 1024 and port =
dst : 1719</FONT>

<BR><B><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:35:08 raqare =
kernel: ---- ip_conntrack_core : ip_conntrack_find_get</FONT></B>

<BR><B><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:35:08 raqare =
kernel: ---- ip_conntrack_core : __ip_conntrack_find</FONT></B>

<BR><B><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:35:08 raqare =
kernel: ---- ip_conntrack_tuple.h : ip_ct_tuple_dst_equal ip_t1 : =
10.10.10.161(2701789706), ip_t2 : 10.10.10.161(2701789706), all_t1 : =
46854, all_t2 : 46854, p_t1 : 17, p_t2 : 17</FONT></B> </P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:35:08 raqare kernel: =
---- ip_conntrack_core : resolve_normal_ct continue</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:35:08 raqare kernel: =
---- ip_conntrack_core : return conntrack</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">...</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:35:08 raqare kernel: =
---- ip_nat_standalone : ip_nat_fn out with do_bindings </FONT>

<BR><B><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:35:08 raqare =
kernel: ---- ip_nat_core.c : do_bindingsn nb of manip : 0</FONT></B>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:35:08 raqare kernel: =
---- ip_nat_core.c : do_bindings loop out </FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:35:08 raqare kernel: =
---- netfilter.c : nf_iterate skblen :&nbsp; return NF_ACCEPT</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">...</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">Any idea about my problem =
?</FONT>
</P>
<BR>
<BR>
<BR>

<P><FONT SIZE=3D2 FACE=3D"Courier New">Here are the complete traces and =
my configuration :</FONT>

<BR><U><FONT SIZE=3D2 FACE=3D"Courier New">Configuration without VLAN =
:</FONT></U>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">ifconfig:</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Courier =
New">eth0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Lien encap:Ethernet&nbsp; HWaddr =
00:08:9B:02:6B:BF&nbsp; </FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; inet =
adr:10.194.67.102&nbsp; Bcast:10.194.67.127&nbsp; =
Masque:255.255.255.192</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; UP BROADCAST =
RUNNING MULTICAST&nbsp; MTU:1500&nbsp; Metric:1</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; RX =
packets:3261 errors:0 dropped:0 overruns:0 frame:5</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; TX =
packets:152 errors:0 dropped:0 overruns:0 carrier:0</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; collisions:0 =
lg file transmission:100 </FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; RX =
bytes:295275 (288.3 Kb)&nbsp; TX bytes:15479 (15.1 Kb)</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
Interruption:10 Adresse de base:0xa000 </FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Courier =
New">eth1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Lien encap:Ethernet&nbsp; HWaddr =
00:08:9B:02:6B:C0&nbsp; </FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; inet =
adr:172.20.14.75&nbsp; Bcast:172.20.14.127&nbsp; =
Masque:255.255.255.128</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; UP BROADCAST =
RUNNING MULTICAST&nbsp; MTU:1500&nbsp; Metric:1</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; RX =
packets:4405 errors:0 dropped:0 overruns:0 frame:15</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; TX =
packets:1551 errors:0 dropped:0 overruns:0 carrier:0</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; collisions:0 =
lg file transmission:100 </FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; RX =
bytes:369447 (360.7 Kb)&nbsp; TX bytes:255682 (249.6 Kb)</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
Interruption:9 Adresse de base:0xc000 </FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Courier =
New">eth2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Lien encap:Ethernet&nbsp; HWaddr =
00:07:E9:09:00:E4&nbsp; </FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; inet =
adr:10.10.10.161&nbsp; Bcast:10.255.255.255&nbsp; =
Masque:255.255.255.0</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; UP BROADCAST =
RUNNING MULTICAST&nbsp; MTU:1500&nbsp; Metric:1</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; RX =
packets:20 errors:0 dropped:0 overruns:0 frame:0</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; TX =
packets:86 errors:0 dropped:0 overruns:0 carrier:0</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; collisions:0 =
lg file transmission:100 </FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; RX =
bytes:3242 (3.1 Kb)&nbsp; TX bytes:12491 (12.1 Kb)</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
Interruption:10 Adresse de base:0xc000 M=E9moire:e7a00000-0 </FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Courier =
New">lo&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Lien encap:Boucle =
locale&nbsp; </FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; inet =
adr:127.0.0.1&nbsp; Masque:255.0.0.0</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; UP LOOPBACK =
RUNNING&nbsp; MTU:16436&nbsp; Metric:1</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; RX =
packets:495 errors:0 dropped:0 overruns:0 frame:0</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; TX =
packets:495 errors:0 dropped:0 overruns:0 carrier:0</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; collisions:0 =
lg file transmission:0 </FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; RX =
bytes:32458 (31.6 Kb)&nbsp; TX bytes:32458 (31.6 Kb)</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">iptables -t nat -L -n -v :</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">Chain PREROUTING (policy ACCEPT =
870 packets, 123K bytes)</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">&nbsp;pkts bytes =
target&nbsp;&nbsp;&nbsp;&nbsp; prot opt in&nbsp;&nbsp;&nbsp;&nbsp; =
out&nbsp;&nbsp;&nbsp;&nbsp; =
source&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp; =
destination&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">&nbsp;&nbsp;&nbsp; 3&nbsp;&nbsp; =
432 DNAT&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; all&nbsp; --&nbsp; =
eth2&nbsp;&nbsp; *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
0.0.0.0/0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; 10.10.10.161&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; to:20.20.0.10 =
</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">Chain POSTROUTING (policy ACCEPT =
313 packets, 27612 bytes)</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">&nbsp;pkts bytes =
target&nbsp;&nbsp;&nbsp;&nbsp; prot opt in&nbsp;&nbsp;&nbsp;&nbsp; =
out&nbsp;&nbsp;&nbsp;&nbsp; =
source&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp; =
destination&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">Chain OUTPUT (policy ACCEPT 313 =
packets, 27612 bytes)</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">&nbsp;pkts bytes =
target&nbsp;&nbsp;&nbsp;&nbsp; prot opt in&nbsp;&nbsp;&nbsp;&nbsp; =
out&nbsp;&nbsp;&nbsp;&nbsp; =
source&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp; destination&nbsp;&nbsp; </FONT>
</P>

<P><U><FONT SIZE=3D2 FACE=3D"Courier New">Traces without VLAN =
:</FONT></U>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:45 raqare kernel: =
---- netfilter.c : nf_iterate protocol : 8, skblen : 144, in_dev : eth2, =
our_dev : &lt;NULL&gt;</FONT></P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:45 raqare kernel: =
---- netfilter.c : nf_iterate protocol : 8, skblen : 144, in_dev : eth2, =
our_dev : &lt;NULL&gt;</FONT></P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:45 raqare kernel: =
---- ip_conntrack_core : ip_conntrack_in</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:45 raqare kernel: =
---- ip_conntrack_core : find_proto 17</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:45 raqare kernel: =
---- ip_conntrack_core : proto_cmpfn, proto =3D 17, curr-&gt;proto =3D =
6</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:45 raqare kernel: =
---- ip_conntrack_core : proto_cmpfn, proto =3D 17, curr-&gt;proto =3D =
17</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:45 raqare kernel: =
---- ip_conntrack_core : __find_proto, 17 proto found --&gt; udp</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:45 raqare kernel: =
---- ip_conntrack_core : resolve_normal_ct in</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:45 raqare kernel: =
---- ip_conntrack_core : get_tuple return iph proto : 17, dst : =
10.10.10.161(2701789706), src : 10.10.10.111(1862928906)</FONT></P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:45 raqare kernel: =
---- ip_conntrack_proto_udp : udp_pkt_to_tuple : src port 1024 and port =
dst : 1719</FONT>

<BR><B><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:45 raqare =
kernel: ---- ip_conntrack_core : ip_conntrack_find_get</FONT></B>

<BR><B><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:45 raqare =
kernel: ---- ip_conntrack_core : __ip_conntrack_find</FONT></B>

<BR><B><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:45 raqare =
kernel: ---- ip_conntrack_core : h NULL, must init_conntrack</FONT></B>

<BR><B><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:45 raqare =
kernel: ---- ip_conntrack_core : init_conntrack</FONT></B>

<BR><B><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:45 raqare =
kernel: ---- ip_conntrack_core : invert_tuple tuple old proto : 17, dst =
: 10.10.10.161(2701789706), src : =
10.10.10.111(1862928906)</FONT></B></P>

<P><B><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:45 raqare kernel: =
---- ip_conntrack_proto_udp : udp_invert_tuple : old src port 1024 and =
old port dst : 1719</FONT></B></P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:45 raqare kernel: =
---- ip_conntrack_core : resolve_normal_ct continue</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:45 raqare kernel: =
---- ip_conntrack_core : return conntrack</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:45 raqare kernel: =
---- ip_conntrack_core : ip_conntrack_in now proto packet</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:45 raqare kernel: =
---- ip_conntrack_core : ip_conntrack_in out normaly</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:45 raqare kernel: =
---- netfilter.c : nf_iterate protocol : 8, skblen : 144, in_dev : eth2, =
our_dev : &lt;NULL&gt;</FONT></P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:46 raqare kernel: =
---- iptable_mangle : ipt_route_hook</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:46 raqare kernel: =
---- iptable_mangle : ipt_route_hook return with ipt_do_table</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:46 raqare kernel: =
---- netfilter.c : nf_iterate protocol : 8, skblen : 144, in_dev : eth2, =
our_dev : &lt;NULL&gt;</FONT></P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:46 raqare kernel: =
---- ip_nat_standalone : ip_nat_fn in </FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:46 raqare kernel: =
---- ip_conntrack_core : __ip_conntrack_get</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:46 raqare kernel: =
---- ip_nat_standalone : ip_nat_fn continue</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:46 raqare kernel: =
---- ip_nat_standalone : ip_nat_fn IP_CT_NEW</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:46 raqare kernel: =
---- ip_conntrack_core : __ip_conntrack_get</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:46 raqare kernel: =
---- ip_conntrack_core : find_proto 17</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:46 raqare kernel: =
---- ip_conntrack_core : proto_cmpfn, proto =3D 17, curr-&gt;proto =3D =
6</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:46 raqare kernel: =
---- ip_conntrack_core : proto_cmpfn, proto =3D 17, curr-&gt;proto =3D =
17</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:46 raqare kernel: =
---- ip_conntrack_core : __find_proto, 17 proto found --&gt; udp</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:46 raqare kernel: =
---- ip_conntrack_core : invert_tuple tuple old proto : 17, dst : =
10.10.10.111(1862928906), src : 10.10.10.161(2701789706)</FONT></P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:46 raqare kernel: =
---- ip_conntrack_proto_udp : udp_invert_tuple : old src port 1719 and =
old port dst : 1024</FONT></P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:46 raqare kernel: =
---- ip_nat_core.c : find_best_ips_proto_fast assign tuple dst : =
2701789706, src : 1862928906</FONT></P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:46 raqare kernel: =
---- ip_conntrack_core : find_proto 17</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:46 raqare kernel: =
---- ip_conntrack_core : proto_cmpfn, proto =3D 17, curr-&gt;proto =3D =
6</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:46 raqare kernel: =
---- ip_conntrack_core : proto_cmpfn, proto =3D 17, curr-&gt;proto =3D =
17</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:46 raqare kernel: =
---- ip_conntrack_core : __find_proto, 17 proto found --&gt; udp</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:46 raqare kernel: =
---- ip_conntrack_core : invert_tuple tuple old proto : 17, dst : =
20.20.0.10(167777300), src : 10.10.10.111(1862928906)</FONT></P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:46 raqare kernel: =
---- ip_conntrack_proto_udp : udp_invert_tuple : old src port 1024 and =
old port dst : 1719</FONT></P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:46 raqare kernel: =
---- ip_conntrack_core : __ip_conntrack_find</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:46 raqare kernel: =
---- ip_conntrack_core : ip_conntrack_tuple_taken, NOT found</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:46 raqare kernel: =
---- ip_conntrack_core : find_proto 17</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:46 raqare kernel: =
---- ip_conntrack_core : proto_cmpfn, proto =3D 17, curr-&gt;proto =3D =
6</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:46 raqare kernel: =
---- ip_conntrack_core : proto_cmpfn, proto =3D 17, curr-&gt;proto =3D =
17</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:46 raqare kernel: =
---- ip_conntrack_core : __find_proto, 17 proto found --&gt; udp</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:46 raqare kernel: =
---- ip_conntrack_core : invert_tuple tuple old proto : 17, dst : =
20.20.0.10(167777300), src : 10.10.10.111(1862928906)</FONT></P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:46 raqare kernel: =
---- ip_conntrack_proto_udp : udp_invert_tuple : old src port 1024 and =
old port dst : 1719</FONT></P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:46 raqare kernel: =
---- ip_conntrack_core : __ip_conntrack_find</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:46 raqare kernel: =
---- ip_conntrack_core : find_proto 17</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:46 raqare kernel: =
---- ip_conntrack_core : proto_cmpfn, proto =3D 17, curr-&gt;proto =3D =
6</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:46 raqare kernel: =
---- ip_conntrack_core : proto_cmpfn, proto =3D 17, curr-&gt;proto =3D =
17</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:46 raqare kernel: =
---- ip_conntrack_core : __find_proto, 17 proto found --&gt; udp</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:46 raqare kernel: =
---- ip_conntrack_core : invert_tuple tuple old proto : 17, dst : =
10.10.10.161(2701789706), src : 10.10.10.111(1862928906)</FONT></P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:46 raqare kernel: =
---- ip_conntrack_proto_udp : udp_invert_tuple : old src port 1024 and =
old port dst : 1719</FONT></P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:46 raqare kernel: =
---- ip_nat_core.c :&nbsp; ip_nat_setup_info do some checks</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:46 raqare kernel: =
---- ip_conntrack_tuple.h : ip_ct_tuple_dst_equal ip_t1 : =
20.20.0.10(167777300), ip_t2 : 10.10.10.161(2701789706), all_t1 : 46854, =
all_t2 : 46854, p_t1 : 17, p_t2 : 17 </FONT></P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:46 raqare kernel: =
---- ip_nat_core.c :&nbsp; ip_nat_setup_info dst_equal</FONT>

<BR><B><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:46 raqare =
kernel: ---- ip_nat_standalone : ip_nat_fn out with do_bindings =
</FONT></B>

<BR><B><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:46 raqare =
kernel: ---- ip_nat_core.c : do_bindingsn nb of manip : 2</FONT></B>

<BR><B><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:46 raqare =
kernel: ---- ip_nat_core.c : do_bindings loop in </FONT></B>

<BR><B><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:46 raqare =
kernel: ---- ip_nat_core.c : do_bindings loop continue </FONT></B>

<BR><B><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:46 raqare =
kernel: ---- ip_nat_core.c : do_bindings need Mangling DST</FONT></B>

<BR><B><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:46 raqare =
kernel: ---- ip_nat_core.c : do_bindings loop in </FONT></B>

<BR><B><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:46 raqare =
kernel: ---- ip_nat_core.c : do_bindings loop continue </FONT></B>

<BR><B><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:46 raqare =
kernel: ---- ip_nat_core.c : do_bindings loop out </FONT></B>

<BR><B><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:48:46 raqare =
kernel: ---- netfilter.c : nf_iterate skblen :&nbsp; return =
NF_ACCEPT</FONT></B>
</P>

<P><U><FONT SIZE=3D2 FACE=3D"Courier New">Configuration with VLAN =
:</FONT></U>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">ifconfig</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">eth0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Lien encap:Ethernet&nbsp; HWaddr =
00:08:9B:02:6B:BF&nbsp; </FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; inet =
adr:10.194.67.102&nbsp; Bcast:10.194.67.127&nbsp; =
Masque:255.255.255.192</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; UP BROADCAST =
RUNNING MULTICAST&nbsp; MTU:1500&nbsp; Metric:1</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; RX =
packets:3391 errors:0 dropped:0 overruns:0 frame:5</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; TX =
packets:155 errors:0 dropped:0 overruns:0 carrier:0</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; collisions:0 =
lg file transmission:100 </FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; RX =
bytes:306377 (299.1 Kb)&nbsp; TX bytes:15737 (15.3 Kb)</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
Interruption:10 Adresse de base:0xa000 </FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Courier =
New">eth1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Lien encap:Ethernet&nbsp; HWaddr =
00:08:9B:02:6B:C0&nbsp; </FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; inet =
adr:172.20.14.75&nbsp; Bcast:172.20.14.127&nbsp; =
Masque:255.255.255.128</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; UP BROADCAST =
RUNNING MULTICAST&nbsp; MTU:1500&nbsp; Metric:1</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; RX =
packets:4646 errors:0 dropped:0 overruns:0 frame:16</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; TX =
packets:1676 errors:0 dropped:0 overruns:0 carrier:0</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; collisions:0 =
lg file transmission:100 </FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; RX =
bytes:387898 (378.8 Kb)&nbsp; TX bytes:278811 (272.2 Kb)</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
Interruption:9 Adresse de base:0xc000 </FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Courier =
New">eth2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Lien encap:Ethernet&nbsp; HWaddr =
00:07:E9:09:00:E4&nbsp; </FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; inet =
adr:10.10.10.161&nbsp; Bcast:10.255.255.255&nbsp; =
Masque:255.255.255.0</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; UP BROADCAST =
RUNNING MULTICAST&nbsp; MTU:1500&nbsp; Metric:1</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; RX =
packets:25 errors:0 dropped:0 overruns:0 frame:0</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; TX =
packets:90 errors:0 dropped:0 overruns:0 carrier:0</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; collisions:0 =
lg file transmission:100 </FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; RX =
bytes:3958 (3.8 Kb)&nbsp; TX bytes:13201 (12.8 Kb)</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
Interruption:10 Adresse de base:0xc000 M=E9moire:e7a00000-0 </FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Courier =
New">lo&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Lien encap:Boucle =
locale&nbsp; </FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; inet =
adr:127.0.0.1&nbsp; Masque:255.0.0.0</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; UP LOOPBACK =
RUNNING&nbsp; MTU:16436&nbsp; Metric:1</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; RX =
packets:495 errors:0 dropped:0 overruns:0 frame:0</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; TX =
packets:495 errors:0 dropped:0 overruns:0 carrier:0</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; collisions:0 =
lg file transmission:0 </FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; RX =
bytes:32458 (31.6 Kb)&nbsp; TX bytes:32458 (31.6 Kb)</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">vlan0010&nbsp; Lien =
encap:Ethernet&nbsp; HWaddr 00:07:E9:09:00:E4&nbsp; </FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; inet =
adr:20.20.0.10&nbsp; Bcast:20.255.255.255&nbsp; =
Masque:255.255.255.0</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; UP BROADCAST =
RUNNING MULTICAST&nbsp; MTU:1500&nbsp; Metric:1</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; RX packets:0 =
errors:0 dropped:0 overruns:0 frame:0</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; TX packets:0 =
errors:0 dropped:0 overruns:0 carrier:0</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; collisions:0 =
lg file transmission:0 </FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; RX bytes:0 =
(0.0 b)&nbsp; TX bytes:0 (0.0 b)</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">vlan0020&nbsp; Lien =
encap:Ethernet&nbsp; HWaddr 00:07:E9:09:00:E4&nbsp; </FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; inet =
adr:20.20.0.20&nbsp; Bcast:20.255.255.255&nbsp; =
Masque:255.255.255.0</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; UP BROADCAST =
RUNNING MULTICAST&nbsp; MTU:1500&nbsp; Metric:1</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; RX packets:0 =
errors:0 dropped:0 overruns:0 frame:0</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; TX packets:0 =
errors:0 dropped:0 overruns:0 carrier:0</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; collisions:0 =
lg file transmission:0 </FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; RX bytes:0 =
(0.0 b)&nbsp; TX bytes:0 (0.0 b)</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">iptables -t nat -L -n -v :</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Chain PREROUTING (policy ACCEPT =
899 packets, 127K bytes)</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">&nbsp;pkts bytes =
target&nbsp;&nbsp;&nbsp;&nbsp; prot opt in&nbsp;&nbsp;&nbsp;&nbsp; =
out&nbsp;&nbsp;&nbsp;&nbsp; =
source&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp; =
destination&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">&nbsp;&nbsp;&nbsp; =
0&nbsp;&nbsp;&nbsp;&nbsp; 0 DNAT&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
all&nbsp; --&nbsp; vlan0010 *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
0.0.0.0/0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; 10.10.10.161&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; to:20.20.0.10 =
</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">Chain POSTROUTING (policy ACCEPT =
324 packets, 28980 bytes)</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">&nbsp;pkts bytes =
target&nbsp;&nbsp;&nbsp;&nbsp; prot opt in&nbsp;&nbsp;&nbsp;&nbsp; =
out&nbsp;&nbsp;&nbsp;&nbsp; =
source&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp; =
destination&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">Chain OUTPUT (policy ACCEPT 324 =
packets, 28980 bytes)</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">&nbsp;pkts bytes =
target&nbsp;&nbsp;&nbsp;&nbsp; prot opt in&nbsp;&nbsp;&nbsp;&nbsp; =
out&nbsp;&nbsp;&nbsp;&nbsp; =
source&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp; destination&nbsp; </FONT>
</P>

<P><U><FONT SIZE=3D2 FACE=3D"Courier New">Traces with VLAN :</FONT></U>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:35:08 raqare kernel: =
---- netfilter.c : nf_iterate protocol : 8, skblen : 144, in_dev : =
vlan0010, our_dev : &lt;NULL&gt;</FONT></P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:35:08 raqare kernel: =
---- netfilter.c : nf_iterate protocol : 8, skblen : 144, in_dev : =
vlan0010, our_dev : &lt;NULL&gt;</FONT></P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:35:08 raqare kernel: =
---- ip_conntrack_core : ip_conntrack_in</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:35:08 raqare kernel: =
---- ip_conntrack_core : find_proto 17</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:35:08 raqare kernel: =
---- ip_conntrack_core : proto_cmpfn, proto =3D 17, curr-&gt;proto =3D =
6</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:35:08 raqare kernel: =
---- ip_conntrack_core : proto_cmpfn, proto =3D 17, curr-&gt;proto =3D =
17</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:35:08 raqare kernel: =
---- ip_conntrack_core : __find_proto, 17 proto found --&gt; udp</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:35:08 raqare kernel: =
---- ip_conntrack_core : resolve_normal_ct in</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:35:08 raqare kernel: =
---- ip_conntrack_core : get_tuple return iph proto : 17, dst : =
10.10.10.161(2701789706), src : 10.10.10.111(1862928906)</FONT></P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:35:08 raqare kernel: =
---- ip_conntrack_proto_udp : udp_pkt_to_tuple : src port 1024 and port =
dst : 1719</FONT>

<BR><B><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:35:08 raqare =
kernel: ---- ip_conntrack_core : ip_conntrack_find_get</FONT></B>

<BR><B><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:35:08 raqare =
kernel: ---- ip_conntrack_core : __ip_conntrack_find</FONT></B>

<BR><B><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:35:08 raqare =
kernel: ---- ip_conntrack_tuple.h : ip_ct_tuple_dst_equal ip_t1 : =
10.10.10.161(2701789706), ip_t2 : 10.10.10.161(2701789706), all_t1 : =
46854, all_t2 : 46854, p_t1 : 17, p_t2 : 17</FONT></B> </P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:35:08 raqare kernel: =
---- ip_conntrack_core : resolve_normal_ct continue</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:35:08 raqare kernel: =
---- ip_conntrack_core : return conntrack</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:35:08 raqare kernel: =
---- ip_conntrack_core : ip_conntrack_in now proto packet</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:35:08 raqare kernel: =
---- ip_conntrack_core : ip_conntrack_in out normaly</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:35:08 raqare kernel: =
---- netfilter.c : nf_iterate protocol : 8, skblen : 144, in_dev : =
vlan0010, our_dev : &lt;NULL&gt;</FONT></P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:35:08 raqare kernel: =
---- iptable_mangle : ipt_route_hook</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:35:08 raqare kernel: =
---- iptable_mangle : ipt_route_hook return with ipt_do_table</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:35:08 raqare kernel: =
---- netfilter.c : nf_iterate protocol : 8, skblen : 144, in_dev : =
vlan0010, our_dev : &lt;NULL&gt;</FONT></P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:35:08 raqare kernel: =
---- ip_nat_standalone : ip_nat_fn in </FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:35:08 raqare kernel: =
---- ip_conntrack_core : __ip_conntrack_get</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:35:08 raqare kernel: =
---- ip_nat_standalone : ip_nat_fn continue</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:35:08 raqare kernel: =
---- ip_nat_standalone : ip_nat_fn IP_CT_NEW</FONT>

<BR><B><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:35:08 raqare =
kernel: ---- ip_nat_standalone : ip_nat_fn out with do_bindings =
</FONT></B>

<BR><B><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:35:08 raqare =
kernel: ---- ip_nat_core.c : do_bindingsn nb of manip : 0</FONT></B>

<BR><B><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:35:08 raqare =
kernel: ---- ip_nat_core.c : do_bindings loop out </FONT></B>

<BR><B><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:35:08 raqare =
kernel: ---- netfilter.c : nf_iterate skblen :&nbsp; return =
NF_ACCEPT</FONT></B>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:35:08 raqare kernel: =
---- netfilter.c : nf_iterate protocol : 8, skblen : 144, in_dev : =
vlan0010, our_dev : &lt;NULL&gt;</FONT></P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:35:08 raqare kernel: =
---- iptable_mangle : ipt_local_hook</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:35:08 raqare kernel: =
---- iptable_mangle : ipt_lcoal_hook out</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:35:08 raqare kernel: =
---- netfilter.c : nf_iterate protocol : 8, skblen : 144, in_dev : =
vlan0010, our_dev : &lt;NULL&gt;</FONT></P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:35:08 raqare kernel: =
---- iptable_filter : ipt_hook</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:35:08 raqare kernel: =
---- iptable_filter : ipt_hook return with ipt_do_table</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:35:08 raqare kernel: =
---- netfilter.c : nf_iterate protocol : 8, skblen : 144, in_dev : =
vlan0010, our_dev : &lt;NULL&gt;</FONT></P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:35:08 raqare kernel: =
---- ip_conntrack_standalone : ip_confirm return with =
ip_conntrack_confirm</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Apr 30 16:35:08 raqare kernel: =
---- netfilter.c : nf_iterate skblen :&nbsp; return NF_ACCEPT</FONT>
</P>

</BODY>
</HTML>
------_=_NextPart_001_01C30F38.348546A8--
