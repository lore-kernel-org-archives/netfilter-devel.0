From: "Maciej Soltysiak" <solt@dns.toxicfilms.tv>
Subject: [PATCH] Re: HOPLIMIT
Date: Fri, 20 Feb 2004 11:55:41 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <003301c3f7a0$14fd04a0$0e25fe96@pysiak>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0030_01C3F7A8.76A272F0"
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

------=_NextPart_000_0030_01C3F7A8.76A272F0
Content-Type: text/plain;
	charset="iso-8859-2"
Content-Transfer-Encoding: 7bit

> >  I would like to take care of this, but I would like to have a clear
> > decision. Let's decide whether we stay with HL or switch to HOPLIMIT.
> > I am in favor of HL.

> Thanks, please submit a patch.
I did, but here it is again.
It changes HOPLIMIT to HL in files so that it comiles, and corrects
the naming.
It does not change the name of the directory in CVS from HOPLIMIT
to HL. Please change the dir in cvs to reflect the current name.

Regards,
Maciej

------=_NextPart_000_0030_01C3F7A8.76A272F0
Content-Type: application/octet-stream;
	name="HL.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="HL.patch"

Index: HOPLIMIT/help=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
RCS file: /cvspublic/patch-o-matic-ng/HOPLIMIT/help,v=0A=
retrieving revision 1.1=0A=
diff -u -r1.1 help=0A=
--- HOPLIMIT/help	20 Dec 2003 16:26:42 -0000	1.1=0A=
+++ HOPLIMIT/help	17 Feb 2004 18:09:02 -0000=0A=
@@ -2,6 +2,6 @@=0A=
 to increment or decrement it by a given value.=0A=
 =0A=
 Example:=0A=
-# ip6tables -t mangle -A OUTPUT -j HOPLIMIT --hl-inc 1=0A=
-# ip6tables -t mangle -A INPUT -j HOPLIMIT --hl-eq 64=0A=
-# ip6tables -t mangle -A OUTPUT -j HOPLIMIT --hl-dec 2=0A=
+# ip6tables -t mangle -A OUTPUT -j HL --hl-inc 1=0A=
+# ip6tables -t mangle -A INPUT -j HL --hl-eq 64=0A=
+# ip6tables -t mangle -A OUTPUT -j HL --hl-dec 2=0A=
Index: HOPLIMIT/info=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
RCS file: /cvspublic/patch-o-matic-ng/HOPLIMIT/info,v=0A=
retrieving revision 1.1=0A=
diff -u -r1.1 info=0A=
--- HOPLIMIT/info	20 Dec 2003 16:26:42 -0000	1.1=0A=
+++ HOPLIMIT/info	17 Feb 2004 18:09:02 -0000=0A=
@@ -1,4 +1,4 @@=0A=
-Title: ip6tables HOPLIMIT target=0A=
+Title: ip6tables HL target=0A=
 Author: Maciej Soltysiak <solt@dns.toxicfilms.tv>=0A=
 Status: Works for me.=0A=
 Repository: base=0A=
Index: HOPLIMIT/linux/include/linux/netfilter_ipv6/ip6t_HL.h=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
RCS file: =
/cvspublic/patch-o-matic-ng/HOPLIMIT/linux/include/linux/netfilter_ipv6/i=
p6t_HL.h,v=0A=
retrieving revision 1.1=0A=
diff -u -r1.1 ip6t_HL.h=0A=
--- HOPLIMIT/linux/include/linux/netfilter_ipv6/ip6t_HL.h	20 Dec 2003 =
16:26:42 -0000	1.1=0A=
+++ HOPLIMIT/linux/include/linux/netfilter_ipv6/ip6t_HL.h	17 Feb 2004 =
18:09:02 -0000=0A=
@@ -2,18 +2,18 @@=0A=
  * Maciej Soltysiak <solt@dns.toxicfilms.tv>=0A=
  * Based on HW's TTL module */=0A=
 =0A=
-#ifndef _IP6T_HOPLIMIT_H=0A=
-#define _IP6T_HOPLIMIT_H=0A=
+#ifndef _IP6T_HL_H=0A=
+#define _IP6T_HL_H=0A=
 =0A=
 enum {=0A=
-	IP6T_HOPLIMIT_SET =3D 0,=0A=
-	IP6T_HOPLIMIT_INC,=0A=
-	IP6T_HOPLIMIT_DEC=0A=
+	IP6T_HL_SET =3D 0,=0A=
+	IP6T_HL_INC,=0A=
+	IP6T_HL_DEC=0A=
 };=0A=
 =0A=
-#define IP6T_HOPLIMIT_MAXMODE	IP6T_HOPLIMIT_DEC=0A=
+#define IP6T_HL_MAXMODE	IP6T_HL_DEC=0A=
 =0A=
-struct ip6t_HOPLIMIT_info {=0A=
+struct ip6t_HL_info {=0A=
 	u_int8_t	mode;=0A=
 	u_int8_t	hop_limit;=0A=
 };=0A=
Index: HOPLIMIT/linux/net/ipv6/netfilter/Config.in.ladd=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
RCS file: =
/cvspublic/patch-o-matic-ng/HOPLIMIT/linux/net/ipv6/netfilter/Config.in.l=
add,v=0A=
retrieving revision 1.1=0A=
diff -u -r1.1 Config.in.ladd=0A=
--- HOPLIMIT/linux/net/ipv6/netfilter/Config.in.ladd	20 Dec 2003 =
16:26:42 -0000	1.1=0A=
+++ HOPLIMIT/linux/net/ipv6/netfilter/Config.in.ladd	17 Feb 2004 =
18:09:02 -0000=0A=
@@ -1,4 +1,4 @@=0A=
   dep_tristate '  Packet filtering' CONFIG_IP6_NF_FILTER =
$CONFIG_IP6_NF_IPTABLES =0A=
   if [ "$CONFIG_IP6_NF_FILTER" !=3D "n" ]; then=0A=
-    dep_tristate '    HOPLIMIT target support' =
CONFIG_IP6_NF_TARGET_HOPLIMIT $CONFIG_IP6_NF_FILTER=0A=
+    dep_tristate '    HL target support' CONFIG_IP6_NF_TARGET_HL =
$CONFIG_IP6_NF_FILTER=0A=
   fi=0A=
Index: HOPLIMIT/linux/net/ipv6/netfilter/Kconfig.ladd=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
RCS file: =
/cvspublic/patch-o-matic-ng/HOPLIMIT/linux/net/ipv6/netfilter/Kconfig.lad=
d,v=0A=
retrieving revision 1.1=0A=
diff -u -r1.1 Kconfig.ladd=0A=
--- HOPLIMIT/linux/net/ipv6/netfilter/Kconfig.ladd	21 Dec 2003 20:09:27 =
-0000	1.1=0A=
+++ HOPLIMIT/linux/net/ipv6/netfilter/Kconfig.ladd	17 Feb 2004 18:09:02 =
-0000=0A=
@@ -1,3 +1,3 @@=0A=
-config IP6_NF_TARGET_HOPLIMIT=0A=
-	tristate  'HOPLIMIT target support'=0A=
+config IP6_NF_TARGET_HL=0A=
+	tristate  'HL target support'=0A=
 	depends on IP6_NF_MANGLE=0A=
Index: HOPLIMIT/linux/net/ipv6/netfilter/Makefile.ladd=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
RCS file: =
/cvspublic/patch-o-matic-ng/HOPLIMIT/linux/net/ipv6/netfilter/Makefile.la=
dd,v=0A=
retrieving revision 1.1=0A=
diff -u -r1.1 Makefile.ladd=0A=
--- HOPLIMIT/linux/net/ipv6/netfilter/Makefile.ladd	20 Dec 2003 16:26:42 =
-0000	1.1=0A=
+++ HOPLIMIT/linux/net/ipv6/netfilter/Makefile.ladd	17 Feb 2004 18:09:02 =
-0000=0A=
@@ -1,2 +1,2 @@=0A=
 obj-$(CONFIG_IP6_NF_TARGET_LOG) +=3D ip6t_LOG.o=0A=
-obj-$(CONFIG_IP6_NF_TARGET_HOPLIMIT) +=3D ip6t_HOPLIMIT.o=0A=
+obj-$(CONFIG_IP6_NF_TARGET_HL) +=3D ip6t_HL.o=0A=
Index: HOPLIMIT/linux/net/ipv6/netfilter/ip6t_HL.c=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
RCS file: =
/cvspublic/patch-o-matic-ng/HOPLIMIT/linux/net/ipv6/netfilter/ip6t_HL.c,v=0A=
retrieving revision 1.1=0A=
diff -u -r1.1 ip6t_HL.c=0A=
--- HOPLIMIT/linux/net/ipv6/netfilter/ip6t_HL.c	20 Dec 2003 16:26:42 =
-0000	1.1=0A=
+++ HOPLIMIT/linux/net/ipv6/netfilter/ip6t_HL.c	17 Feb 2004 18:09:02 =
-0000=0A=
@@ -11,7 +11,7 @@=0A=
 #include <linux/ip.h>=0A=
 =0A=
 #include <linux/netfilter_ipv6/ip6_tables.h>=0A=
-#include <linux/netfilter_ipv6/ip6t_HOPLIMIT.h>=0A=
+#include <linux/netfilter_ipv6/ip6t_HL.h>=0A=
 =0A=
 MODULE_AUTHOR("Maciej Soltysiak <solt@dns.toxicfilms.tv>");=0A=
 MODULE_DESCRIPTION("IP tables Hop Limit modification module");=0A=
@@ -22,20 +22,20 @@=0A=
 		const void *targinfo, void *userinfo)=0A=
 {=0A=
 	struct ipv6hdr *ip6h =3D (*pskb)->nh.ipv6h;=0A=
-	const struct ip6t_HOPLIMIT_info *info =3D targinfo;=0A=
+	const struct ip6t_HL_info *info =3D targinfo;=0A=
 	u_int16_t diffs[2];=0A=
 	int new_hl;=0A=
 			 =0A=
 	switch (info->mode) {=0A=
-		case IP6T_HOPLIMIT_SET:=0A=
+		case IP6T_HL_SET:=0A=
 			new_hl =3D info->hop_limit;=0A=
 			break;=0A=
-		case IP6T_HOPLIMIT_INC:=0A=
+		case IP6T_HL_INC:=0A=
 			new_hl =3D ip6h->hop_limit + info->hop_limit;=0A=
 			if (new_hl > 255)=0A=
 				new_hl =3D 255;=0A=
 			break;=0A=
-		case IP6T_HOPLIMIT_DEC:=0A=
+		case IP6T_HL_DEC:=0A=
 			new_hl =3D ip6h->hop_limit + info->hop_limit;=0A=
 			if (new_hl < 0)=0A=
 				new_hl =3D 0;=0A=
@@ -60,45 +60,45 @@=0A=
 		unsigned int targinfosize,=0A=
 		unsigned int hook_mask)=0A=
 {=0A=
-	struct ip6t_HOPLIMIT_info *info =3D targinfo;=0A=
+	struct ip6t_HL_info *info =3D targinfo;=0A=
 =0A=
-	if (targinfosize !=3D IP6T_ALIGN(sizeof(struct ip6t_HOPLIMIT_info))) {=0A=
-		printk(KERN_WARNING "HOPLIMIT: targinfosize %u !=3D %Zu\n",=0A=
+	if (targinfosize !=3D IP6T_ALIGN(sizeof(struct ip6t_HL_info))) {=0A=
+		printk(KERN_WARNING "HL: targinfosize %u !=3D %Zu\n",=0A=
 				targinfosize,=0A=
-				IP6T_ALIGN(sizeof(struct ip6t_HOPLIMIT_info)));=0A=
+				IP6T_ALIGN(sizeof(struct ip6t_HL_info)));=0A=
 		return 0;	=0A=
 	}	=0A=
 =0A=
 	if (strcmp(tablename, "mangle")) {=0A=
-		printk(KERN_WARNING "HOPLIMIT: can only be called from \"mangle\" =
table, not \"%s\"\n", tablename);=0A=
+		printk(KERN_WARNING "HL: can only be called from \"mangle\" table, =
not \"%s\"\n", tablename);=0A=
 		return 0;=0A=
 	}=0A=
 =0A=
-	if (info->mode > IP6T_HOPLIMIT_MAXMODE) {=0A=
-		printk(KERN_WARNING "HOPLIMIT: invalid or unknown Mode %u\n", =0A=
+	if (info->mode > IP6T_HL_MAXMODE) {=0A=
+		printk(KERN_WARNING "HL: invalid or unknown Mode %u\n", =0A=
 			info->mode);=0A=
 		return 0;=0A=
 	}=0A=
 =0A=
-	if ((info->mode !=3D IP6T_HOPLIMIT_SET) && (info->hop_limit =3D=3D 0)) =
{=0A=
-		printk(KERN_WARNING "HOPLIMIT: increment/decrement doesn't make sense =
with value 0\n");=0A=
+	if ((info->mode !=3D IP6T_HL_SET) && (info->hop_limit =3D=3D 0)) {=0A=
+		printk(KERN_WARNING "HL: increment/decrement doesn't make sense with =
value 0\n");=0A=
 		return 0;=0A=
 	}=0A=
 	=0A=
 	return 1;=0A=
 }=0A=
 =0A=
-static struct ip6t_target ip6t_HOPLIMIT =3D { { NULL, NULL }, =
"HOPLIMIT", =0A=
+static struct ip6t_target ip6t_HL =3D { { NULL, NULL }, "HL", =0A=
 	ip6t_hl_target, ip6t_hl_checkentry, NULL, THIS_MODULE };=0A=
 =0A=
 static int __init init(void)=0A=
 {=0A=
-	return ip6t_register_target(&ip6t_HOPLIMIT);=0A=
+	return ip6t_register_target(&ip6t_HL);=0A=
 }=0A=
 =0A=
 static void __exit fini(void)=0A=
 {=0A=
-	ip6t_unregister_target(&ip6t_HOPLIMIT);=0A=
+	ip6t_unregister_target(&ip6t_HL);=0A=
 }=0A=
 =0A=
 module_init(init);=0A=

------=_NextPart_000_0030_01C3F7A8.76A272F0--
