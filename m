From: "Sverker Abrahamsson" <sverker@abrahamsson.com>
Subject: Patch for ip_nat_rtsp.c
Date: Sun, 9 Oct 2005 14:59:44 +0200
Message-ID: <02e201c5ccd1$5235dce0$3c01010a@Fiona>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_02DE_01C5CCE2.15678C30"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>,
	<tmarshall@real.com>
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

------=_NextPart_000_02DE_01C5CCE2.15678C30
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi
I was trying to get the RTSP nat module to work by applying the patches =
in patch-o-matic but ip_nat_rtsp.c continued to give compiler errors. I =
patched as far as I could but got stuck in help_out where it uses seq =
field of struct ip_conntrack_expect, which I believe was removed in =
2.6.11. I haven't been able to figure out the exact functionality and I =
see on other nat modules that they were simplified a lot after the =
2.6.11 API change.

Maybe someone on the list can understand the functionality better, or =
can hint me on what should be changed.
/Sverker

------=_NextPart_000_02DE_01C5CCE2.15678C30
Content-Type: application/octet-stream;
	name="ip_nat_rtsp.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="ip_nat_rtsp.patch"

--- linux-2.6.13.3.orig/include/linux/netfilter_ipv4/ip_conntrack_rtsp.h	=
2005-10-09 14:46:59.000000000 +0200=0A=
+++ linux-2.6.13.3/include/linux/netfilter_ipv4/ip_conntrack_rtsp.h	=
2005-10-08 20:47:26.000000000 +0200=0A=
@@ -47,6 +47,13 @@=0A=
 #endif=0A=
 };=0A=
 =0A=
+/* For NAT to hook in when we find a packet which describes what other=0A=
+ * connection we should expect. */=0A=
+extern unsigned int (*ip_nat_rtsp_hook)(struct sk_buff **pskb,=0A=
+				 enum ip_conntrack_info ctinfo,=0A=
+				 struct ip_ct_rtsp_expect *expinfo,=0A=
+				 struct ip_conntrack_expect *exp);=0A=
+=0A=
 #ifdef __KERNEL__=0A=
 =0A=
 #define RTSP_PORT   554=0A=
--- linux-2.6.13.3.orig/net/ipv4/netfilter/ip_nat_rtsp.c	2005-10-09 =
14:43:50.000000000 +0200=0A=
+++ linux-2.6.13.3/net/ipv4/netfilter/ip_nat_rtsp.c	2005-10-08 =
19:52:05.000000000 +0200=0A=
@@ -69,6 +69,7 @@=0A=
 static int       num_ports =3D 0;=0A=
 static u_int32_t extip =3D 0;=0A=
 static int       dstact =3D 0;=0A=
+static DEFINE_SPINLOCK(ip_rtsp_lock);=0A=
 =0A=
 MODULE_AUTHOR("Tom Marshall <tmarshall@real.com>");=0A=
 MODULE_DESCRIPTION("RTSP network address translation module");=0A=
@@ -163,8 +164,8 @@=0A=
     case pb_single:=0A=
         for (loport =3D prtspexp->loport; loport !=3D 0; loport++) /* =
XXX: improper wrap? */=0A=
         {=0A=
-            t.dst.u.udp.port =3D htons(loport);=0A=
-            if (ip_conntrack_change_expect(exp, &t) =3D=3D 0)=0A=
+            exp->tuple.dst.u.udp.port =3D htons(loport);=0A=
+            if (ip_conntrack_expect_related(exp) =3D=3D 0)=0A=
             {=0A=
                 DEBUGP("using port %hu\n", loport);=0A=
                 break;=0A=
@@ -179,8 +180,8 @@=0A=
     case pb_range:=0A=
         for (loport =3D prtspexp->loport; loport !=3D 0; loport +=3D 2) =
/* XXX: improper wrap? */=0A=
         {=0A=
-            t.dst.u.udp.port =3D htons(loport);=0A=
-            if (ip_conntrack_change_expect(exp, &t) =3D=3D 0)=0A=
+            exp->tuple.dst.u.udp.port =3D htons(loport);=0A=
+            if (ip_conntrack_expect_related(exp) =3D=3D 0)=0A=
             {=0A=
                 hiport =3D loport + ~exp->mask.dst.u.udp.port;=0A=
                 DEBUGP("using ports %hu-%hu\n", loport, hiport);=0A=
@@ -196,8 +197,8 @@=0A=
     case pb_discon:=0A=
         for (loport =3D prtspexp->loport; loport !=3D 0; loport++) /* =
XXX: improper wrap? */=0A=
         {=0A=
-            t.dst.u.udp.port =3D htons(loport);=0A=
-            if (ip_conntrack_change_expect(exp, &t) =3D=3D 0)=0A=
+            exp->tuple.dst.u.udp.port =3D htons(loport);=0A=
+            if (ip_conntrack_expect_related(exp) =3D=3D 0)=0A=
             {=0A=
                 DEBUGP("using port %hu (1 of 2)\n", loport);=0A=
                 break;=0A=
@@ -205,8 +206,8 @@=0A=
         }=0A=
         for (hiport =3D prtspexp->hiport; hiport !=3D 0; hiport++) /* =
XXX: improper wrap? */=0A=
         {=0A=
-            t.dst.u.udp.port =3D htons(hiport);=0A=
-            if (ip_conntrack_change_expect(exp, &t) =3D=3D 0)=0A=
+            exp->tuple.dst.u.udp.port =3D htons(hiport);=0A=
+            if (ip_conntrack_expect_related(exp) =3D=3D 0)=0A=
             {=0A=
                 DEBUGP("using port %hu (2 of 2)\n", hiport);=0A=
                 break;=0A=
@@ -365,7 +366,7 @@=0A=
 static unsigned int=0A=
 expected(struct sk_buff **pskb, uint hooknum, struct ip_conntrack* ct, =
struct ip_nat_info* info)=0A=
 {=0A=
-    struct ip_nat_multi_range mr;=0A=
+    struct ip_nat_range mr;=0A=
     u_int32_t newdstip, newsrcip, newip;=0A=
 =0A=
     struct ip_conntrack *master =3D master_ct(ct);=0A=
@@ -382,10 +383,9 @@=0A=
     DEBUGP("newsrcip=3D%u.%u.%u.%u, newdstip=3D%u.%u.%u.%u, =
newip=3D%u.%u.%u.%u\n",=0A=
            NIPQUAD(newsrcip), NIPQUAD(newdstip), NIPQUAD(newip));=0A=
 =0A=
-    mr.rangesize =3D 1;=0A=
     /* We don't want to manip the per-protocol, just the IPs. */=0A=
-    mr.range[0].flags =3D IP_NAT_RANGE_MAP_IPS;=0A=
-    mr.range[0].min_ip =3D mr.range[0].max_ip =3D newip;=0A=
+    mr.flags =3D IP_NAT_RANGE_MAP_IPS;=0A=
+    mr.min_ip =3D mr.max_ip =3D newip;=0A=
 =0A=
     return ip_nat_setup_info(ct, &mr, hooknum);=0A=
 }=0A=
@@ -428,7 +428,7 @@=0A=
         if (nf_strncasecmp(ptcp+lineoff, "Transport:", 10) =3D=3D 0)=0A=
         {=0A=
             uint oldtcplen =3D tcplen;=0A=
-            if (!rtsp_mangle_tran(ct, ctinfo, exp, prtspexp, pskb, =
lineoff, linelen))=0A=
+            if (!rtsp_mangle_tran(ctinfo, exp, prtspexp, pskb, lineoff, =
linelen))=0A=
             {=0A=
                 break;=0A=
             }=0A=
@@ -445,9 +445,9 @@=0A=
 }=0A=
 =0A=
 static int=0A=
-help(struct sk_buff **pskb=0A=
+help(struct sk_buff **pskb,=0A=
      enum ip_conntrack_info ctinfo,=0A=
-     struct ip_ct_rtsp_expect *ct_rtsp_info;=0A=
+     struct ip_ct_rtsp_expect *ct_rtsp_info,=0A=
      struct ip_conntrack_expect* exp)=0A=
 {=0A=
     struct iphdr*  iph  =3D (struct iphdr*)(*pskb)->nh.iph;=0A=
@@ -456,17 +456,18 @@=0A=
     int dir =3D CTINFO2DIR(ctinfo);=0A=
     int rc =3D NF_ACCEPT;=0A=
 =0A=
+    spin_lock_bh(&ip_rtsp_lock);=0A=
     switch (dir)=0A=
     {=0A=
     case IP_CT_DIR_ORIGINAL:=0A=
-        rc =3D help_out(pskb, ctinfo, ct_rtsp_info, exp, pskb);=0A=
+        rc =3D help_out(pskb, ctinfo, ct_rtsp_info, exp);=0A=
         break;=0A=
     case IP_CT_DIR_REPLY:=0A=
     	/* XXX: unmangle */=0A=
 	rc =3D NF_ACCEPT;=0A=
         break;=0A=
     }=0A=
-    UNLOCK_BH(&ip_rtsp_lock);=0A=
+    spin_unlock_bh(&ip_rtsp_lock);=0A=
 =0A=
     return rc;=0A=
 }=0A=

------=_NextPart_000_02DE_01C5CCE2.15678C30--
