From: "John Ho" <john_ho@sh.askey.com.tw>
Subject: Fw: [PATCH 2.4.22] looseUDP support
Date: Wed, 14 Apr 2004 20:41:29 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <013c01c4221d$cf438080$2901080a@askeysh.com.cn>
Reply-To: "John Ho" <john_ho@sh.askey.com.tw>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_013A_01C42260.DD4C81C0"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
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

This is a multi-part message in MIME format.

------=_NextPart_000_013A_01C42260.DD4C81C0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: base64

SGkNCiAgICAgTWF5IGJlIGhlbHBmdWwuIEkndmUgbWV0IHRoaXMgcHJvYmxlbSBhbmQgY2Fubm90
IGZpbmQgYSBzb2x1dGlvbiBmb3IgbmV0ZmlsdGVyIGZyYW1ld29yayB0byBzdXBwb3J0IGxvb3Nl
VURQIGZlYXR1cmUuDQogICAgIFNvIEkgd3JpdGUgb25lLiBOb3cgd2UgY2FuIGVuYWJsZS9kaXNh
YmxlIHRoaXMgbG9vc2VVRFAgZmVhdHVyZSBieSB0eXBpbmcgb24gY29tbWFuZCBsaW5lOg0KDQog
ICAgICRlY2hvICIxIiA+IC9wcm9jL3N5cy9uZXQvaXB2NC9pcF9tYXNxX3VkcF9kbG9vc2UgIC8q
IEVuYWJsZSBpdCAqLw0KICAgICAkZWNobyAiMCIgPiAvcHJvYy9zeXMvbmV0L2lwdjQvaXBfbWFz
cV91ZHBfZGxvb3NlICAvKiBEaXNhYmxlIGl0ICovDQogDQogUmVnYXJkcw0KMjAwNC00LTE0DQpK
b2huIEhvDQogDQo=

------=_NextPart_000_013A_01C42260.DD4C81C0
Content-Type: application/octet-stream;
	name="patch-2.4.22-looseUDP"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="patch-2.4.22-looseUDP"

diff -Naur linux-2.4.22-orig/include/linux/sysctl.h =
linux-2.4.22/include/linux/sysctl.h=0A=
--- linux-2.4.22-orig/include/linux/sysctl.h	2003-08-25 =
19:44:44.000000000 +0800=0A=
+++ linux-2.4.22/include/linux/sysctl.h	2004-04-15 01:18:54.000000000 =
+0800=0A=
@@ -232,6 +232,9 @@=0A=
 	NET_IPV4_FORWARD=3D8,=0A=
 	NET_IPV4_DYNADDR=3D9,=0A=
 =0A=
+	/* John Ho add for looseUDP support -- 03/17/2004 */=0A=
+	NET_IPV4_MASQ_UDP_DLOOSE=3D10,=0A=
+=0A=
 	NET_IPV4_CONF=3D16,=0A=
 	NET_IPV4_NEIGH=3D17,=0A=
 	NET_IPV4_ROUTE=3D18,=0A=
diff -Naur linux-2.4.22-orig/net/ipv4/netfilter/ip_conntrack_core.c =
linux-2.4.22/net/ipv4/netfilter/ip_conntrack_core.c=0A=
--- linux-2.4.22-orig/net/ipv4/netfilter/ip_conntrack_core.c	2003-08-25 =
19:44:44.000000000 +0800=0A=
+++ linux-2.4.22/net/ipv4/netfilter/ip_conntrack_core.c	2004-04-15 =
01:31:25.000000000 +0800=0A=
@@ -370,12 +370,32 @@=0A=
 		    const struct ip_conntrack *ignored_conntrack)=0A=
 {=0A=
 	struct ip_conntrack_tuple_hash *h;=0A=
+	/* Imported from net/ipv4/sysctl_net_ipv4.c for looseUDP support -- =
03/17/2004 */=0A=
+	extern int sysctl_ip_masq_udp_dloose;=0A=
 =0A=
 	MUST_BE_READ_LOCKED(&ip_conntrack_lock);=0A=
 	h =3D LIST_FIND(&ip_conntrack_hash[hash_conntrack(tuple)],=0A=
 		      conntrack_tuple_cmp,=0A=
 		      struct ip_conntrack_tuple_hash *,=0A=
 		      tuple, ignored_conntrack);=0A=
+=0A=
+	/* John Ho add for looseUDP support -- 03/17/2004 =0A=
+	 * loose the restriction of match condition of REPLY UDP packets and =
try again=0A=
+	 */=0A=
+	if( sysctl_ip_masq_udp_dloose && tuple->dst.protonum =3D=3D =
IPPROTO_UDP && !h ){=0A=
+		struct ip_conntrack_tuple loose_reply =3D *tuple;=0A=
+		/* donot care about the src pair */=0A=
+		loose_reply.src.ip =3D INADDR_BROADCAST;=0A=
+		loose_reply.src.u.udp.port =3D 0xFFFF;=0A=
+		h =3D LIST_FIND(&ip_conntrack_hash[hash_conntrack(&loose_reply)],=0A=
+			      conntrack_udp_dloose_tuple_cmp,=0A=
+			      struct ip_conntrack_tuple_hash *,=0A=
+			      &loose_reply, ignored_conntrack);=0A=
+		if( h )=0A=
+			DEBUGP("loose UDP packet match : [%lx / %x] -> [%lx / %x]\n",=0A=
+				tuple->src.ip, tuple->src.u.udp.port,=0A=
+				tuple->dst.ip, tuple->dst.u.udp.port);=0A=
+	}=0A=
 	return h;=0A=
 }=0A=
 =0A=
diff -Naur linux-2.4.22-orig/net/ipv4/netfilter/ipt_MASQUERADE.c =
linux-2.4.22/net/ipv4/netfilter/ipt_MASQUERADE.c=0A=
--- linux-2.4.22-orig/net/ipv4/netfilter/ipt_MASQUERADE.c	2001-10-01 =
03:26:08.000000000 +0800=0A=
+++ linux-2.4.22/net/ipv4/netfilter/ipt_MASQUERADE.c	2004-04-15 =
01:35:43.000000000 +0800=0A=
@@ -70,6 +70,9 @@=0A=
 	u_int32_t newsrc;=0A=
 	struct rtable *rt;=0A=
 	struct rt_key key;=0A=
+	int ret;=0A=
+	/* Imported from net/ipv4/sysctl_net_ipv4.c for looseUDP support */=0A=
+	extern int sysctl_ip_masq_udp_dloose;=0A=
 =0A=
 	IP_NF_ASSERT(hooknum =3D=3D NF_IP_POST_ROUTING);=0A=
 =0A=
@@ -112,7 +115,19 @@=0A=
 			 mr->range[0].min, mr->range[0].max } } });=0A=
 =0A=
 	/* Hand modified range to generic setup. */=0A=
-	return ip_nat_setup_info(ct, &newrange, hooknum);=0A=
+	ret =3D ip_nat_setup_info(ct, &newrange, hooknum);=0A=
+	/* John Ho modified to support LooseUDP -- 03/19/2004 */=0A=
+	if( sysctl_ip_masq_udp_dloose ){=0A=
+		struct ip_conntrack_tuple loose_reply;=0A=
+		loose_reply =3D ct->tuplehash[IP_CT_DIR_REPLY].tuple;=0A=
+		if( loose_reply.dst.protonum =3D=3D IPPROTO_UDP ){=0A=
+			/* We do not care about the reply's src pair */=0A=
+			loose_reply.src.ip =3D INADDR_BROADCAST;=0A=
+			loose_reply.src.u.udp.port =3D 0xFFFF;=0A=
+			ret =3D ip_conntrack_alter_reply(ct, &loose_reply);=0A=
+		}=0A=
+	}=0A=
+	return ret;=0A=
 }=0A=
 =0A=
 static inline int=0A=
diff -Naur linux-2.4.22-orig/net/ipv4/sysctl_net_ipv4.c =
linux-2.4.22/net/ipv4/sysctl_net_ipv4.c=0A=
--- linux-2.4.22-orig/net/ipv4/sysctl_net_ipv4.c	2003-06-13 =
22:51:39.000000000 +0800=0A=
+++ linux-2.4.22/net/ipv4/sysctl_net_ipv4.c	2004-04-15 =
01:22:43.000000000 +0800=0A=
@@ -15,6 +15,11 @@=0A=
 #include <net/route.h>=0A=
 #include <net/tcp.h>=0A=
 =0A=
+/* Should be defined here, or it may cause linking error when config =
CONNTRACK as a module=0A=
+ * John Ho add for looseUDP support [default =3D off] -- 03/19/2004=0A=
+ */=0A=
+int sysctl_ip_masq_udp_dloose =3D 0;=0A=
+=0A=
 /* From af_inet.c */=0A=
 extern int sysctl_ip_nonlocal_bind;=0A=
 =0A=
@@ -130,6 +135,10 @@=0A=
 	 &sysctl_ipfrag_low_thresh, sizeof(int), 0644, NULL, &proc_dointvec},=0A=
 	{NET_IPV4_DYNADDR, "ip_dynaddr",=0A=
 	 &sysctl_ip_dynaddr, sizeof(int), 0644, NULL, &proc_dointvec},=0A=
+	/* John Ho add to support looseUDP */=0A=
+	{NET_IPV4_MASQ_UDP_DLOOSE, "ip_masq_udp_dloose",=0A=
+	 &sysctl_ip_masq_udp_dloose, sizeof(int), 0644, NULL, &proc_dointvec},=0A=
+	/* End -- 03/17/2004 */=0A=
 	{NET_IPV4_IPFRAG_TIME, "ipfrag_time",=0A=
 	 &sysctl_ipfrag_time, sizeof(int), 0644, NULL, &proc_dointvec_jiffies, =0A=
 	 &sysctl_jiffies},=0A=

------=_NextPart_000_013A_01C42260.DD4C81C0--
