From: "Michael Glaum" <mglaum@kvh.com>
Subject: mangle MSS via tcp_manip_pkt() in ip_nat_proto_tcp.c [patch]
Date: Fri, 18 Jul 2003 10:57:05 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <BE229ADC976AC343830DFF9BC159FAEB011E46AA@KUEXCHANGE.kvhinternal.kvhi>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
Content-Class: urn:content-classes:message
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


I just patched ip_nat_proto_tcp.c, below, for a specific application and
are looking for criticism.

We have 2.4.18-3 box whose route onto the internet is via satellite. =
There
is a cisco box in this route that inelegantly blocks packets larger than
1470. I don't have control over this route.

This 2.4.18-3 box is running iptables in masquerade mode. The private
network machines behind it are windohs boxes. I can't control the MTU
on these boxes so when they surf to www.freebsd.org they hang due to
the 1470 problem above.

I tried several things, e.g. pathMTU, etc but in view of severe time
constraints I decided to HACK tcp_manip_pkt() in ip_nat_proto_tcp.c
so that when it does source and destination address translation it also
drops the MSS on outgoing and incoming packets to be below 1360. This
appears to work. I didn't even bother to check if the packets had
tcphdr->syn =3D=3D1 set.

Please advise if there is a more elegant way to do this!

								Michael Glaum
								KVH Industries


cd /usr/src/linux/net/ipv4/netfilter
diff -u ip_nat_proto_tcp.old ip_nat_proto_tcp.c
--- ip_nat_proto_tcp.old	Tue Aug  7 11:30:50 2001
+++ ip_nat_proto_tcp.c	Fri Jul 18 03:57:56 2003
@@ -9,6 +9,8 @@
 #include <linux/netfilter_ipv4/ip_nat_rule.h>
 #include <linux/netfilter_ipv4/ip_nat_protocol.h>
=20
+#include <net/tcp.h>
+
 static int
 tcp_in_range(const struct ip_conntrack_tuple *tuple,
 	     enum ip_nat_manip_type maniptype,
@@ -74,6 +76,56 @@
 	return 0;
 }
=20
+static u_int16_t
+cheat_check(u_int32_t oldvalinv, u_int32_t newval, u_int16_t oldcheck)
+{
+u_int32_t diffs[] =3D { oldvalinv, newval };
+
+	return csum_fold(csum_partial((char *)diffs, sizeof(diffs),
+                         oldcheck^0xFFFF));
+}
+
+static u_int8_t * locate_mss( struct tcphdr * tcp ) {
+u_int8_t *opt;
+int	   i;
+
+    opt =3D (u_int8_t *)tcp;
+    for (i =3D sizeof(struct tcphdr); i < tcp->doff * 4; ) {
+        if ((opt[i] =3D=3D TCPOPT_MSS)
+            && ((tcp->doff * 4 - i) >=3D TCPOLEN_MSS)
+            && (opt[i+1] =3D=3D TCPOLEN_MSS)) {
+                return &opt[i+2];
+        } /* if opt=3D=3DTCPOPT_MSS */
+
+        if (opt[i] < 2) {
+            i++;
+        } else {
+            i +=3D opt[i+1]?:1;
+        }
+    } /* for */
+
+    return NULL;
+} /* locate_mss() */
+
+static void mangle_mss( struct tcphdr * tcp ) {
+u_int8_t * pmss;
+u_int16_t oldmss;
+u_int16_t newmss;
+
+	pmss =3D locate_mss( tcp );
+	if( pmss =3D=3D NULL ) {
+		return;
+	}
+	oldmss=3D  (pmss[0] << 8 ) | pmss[1];
+	if( oldmss > 1360 ) {
+		newmss =3D 1360;
+		pmss[0] =3D 5;
+		pmss[1] =3D 0x50;
+		tcp->check =3D cheat_check( htons(oldmss)^0xffff,
+				htons(newmss), tcp->check );
+	}
+} /* mangle_mss() */
+
 static void
 tcp_manip_pkt(struct iphdr *iph, size_t len,
 	      const struct ip_conntrack_manip *manip,
@@ -101,6 +153,7 @@
 					ip_nat_cheat_check(*portptr ^ 0xFFFF,
 							   manip->u.tcp.port,
 							   hdr->check));
+		mangle_mss( hdr );
 	}
=20
 	*portptr =3D manip->u.tcp.port;
