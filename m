From: Cedric de Launois <delaunois@info.ucl.ac.be>
Subject: [PATCH] Update for ROUTE target in Netfilter-Extension-HOWTO [En]
Date: Tue, 18 May 2004 16:53:55 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1084892035.8170.6.camel@descartes.info.ucl.ac.be>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-Q96S3F6KsiTbEGRvott4"
Cc: fabrice@netfilter.org
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


--=-Q96S3F6KsiTbEGRvott4
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi,

Here is a patch that updates the documentation about the ROUTE target in
the netfilter-extension-HOWTO.

The patch also adds an example from Bill Rugolsky.

The patch is against the sgml master.

Cedric


--=-Q96S3F6KsiTbEGRvott4
Content-Disposition: attachment; filename=ipt_ROUTE-netfilter-extensions-HOWTO-update.patch
Content-Type: text/x-patch; name=ipt_ROUTE-netfilter-extensions-HOWTO-update.patch; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by info.ucl.ac.be id i4IErPXt020988

--- documentation/HOWTO/netfilter-extensions-HOWTO.sgml.orig	2004-05-18 1=
6:38:09.000000000 +0200
+++ documentation/HOWTO/netfilter-extensions-HOWTO.sgml	2004-05-18 16:39:=
30.000000000 +0200
@@ -1644,18 +1644,18 @@
 <tag>--to address[/mask]</> -&gt; Network address to map to.
 </descrip>
=20
+
 <sect1>ROUTE patch
+
 <p>
 This patch by C=E9dric de Launois &lt;delaunois@info.ucl.ac.be&gt; adds =
a new=20
-target which allows you to setup unusual routes not supported by the=20
-standard kernel routing table. The ROUTE target lets you route=20
-a received packet through an interface or towards a host, even if the=20
-regular destination of the packet is the router itself. The ROUTE target=
 is=20
-also able to change the incoming interface of a packet. Packets are
-directly put on the wire and do not traverse any other table.
+target which enables you to setup unusual routes. For example, the ROUTE
+target lets you route a received packet through an interface or towards =
a
+host, even if the  regular destination of the packet is the router itsel=
f.
+The ROUTE target is also able to change the incoming interface of a pack=
et.
=20
 <p>
-This target does not modify the packets and is a final target.
+The target does not modify the packets, and can be or not a final target.
 It has to be used inside the mangle table.
=20
 <p>
@@ -1678,9 +1678,15 @@
 Change the packet's incoming interface to `ifname'.
 <tag>--gw ip</>
 Route the packet via this gateway. The packet is routed as if
-its destination IP address was this ip.
+its destination IP address was `ip'.
+<tag>--continue</>
+Route the packet and continue traversing the rules.
 </descrip>
=20
+<p>
+Note that --iif and --continue options can't be used together.
+
+<sect3>Example for --oif option
=20
 <p>
 For example, assume that you want to redirect ssh packets towards a=20
@@ -1718,8 +1724,10 @@
 ROUTE      all  --  anywhere             anywhere           ROUTE oif et=
h0
 </verb></tscreen>
=20
+<sect3>Example for --gw option
+
 <p>
-Another example : if you want to quickly and easily balance the load bet=
ween two=20
+If you want to quickly and easily balance the load between two=20
 gateways 10.0.0.1 and 10.0.0.2, then you can do as follows :
=20
 <tscreen><verb>
@@ -1733,6 +1741,57 @@
 ROUTE      all  --  anywhere             anywhere           ROUTE gw 10.=
0.0.2
 </verb></tscreen>
=20
+<sect3>Example for --iif option
+
+<p>
+The teql per-packet round-robin scheduler is used to aggregate
+the sending bandwidth on several slave interfaces; see the top of
+linux/net/sched/sch_teql.c for usage and caveats.
+[For Ethernet, the bonding driver is preferred.]
+
+<p>
+Per-packet scheduling is most useful when a single flow might exceed
+the bandwidth of the individual interfaces, as is commonly the case with
+T1 links.
+
+<p>
+Using WAN interfaces hdlc[0-3] on a 4 T1/E1 WAN card, one might do
+the following:
+
+<tscreen><verb>
+modprobe sch_teql
+for i in 0 1 2 3
+        ip link set dev hdlc${i} up
+        sysctl -w net.ipv4.conf.hdlc${i}.rp_filter=3D0
+        tc qdisc add dev hdlc${i} root teql0
+done
+ip link set dev teql0 up
+sysctl -w net.ipv4.conf.teql0.rp_filter=3D0
+ip address add $IPADDR peer $REMIP dev teql0
+ip route add default via $REMIP dev teql0
+</verb></tscreen>
+
+<p>
+Since teql0 is a send-only interface, incoming packets appear on the sla=
ve
+hdlc* interfaces, and the usual caveats regarding asymmetric routing app=
ly.
+E.g., Quagga OSPF implements its own reverse-path filtering neighbor log=
ic;
+replies from peers that are received on the wrong interface are dropped.
+
+<p>
+The following rule causes all incoming packets on the hdlc* interfaces t=
o appear
+to have been received on teql0:
+
+<tscreen><verb>
+iptables -t mangle -A PREROUTING -i hdlc\+ -j TTL --ttl-inc 1
+iptables -t mangle -A PREROUTING -i hdlc\+ -j ROUTE --iif teql0
+</verb></tscreen>
+
+<p>
+The TTL increment is required to avoid dropping packets, as multicast
+and broadcast packets are typically sent with TTL =3D 1.  In this exampl=
e,
+Quagga also sets TTL =3D 1 on packets that it sends to its peers.
+
+
 <sect1>SAME patch
 <p>
 This patch by Martin Josefsson &lt;gandalf@wlug.westbo.se&gt; adds a new=
 target

--=-Q96S3F6KsiTbEGRvott4--
