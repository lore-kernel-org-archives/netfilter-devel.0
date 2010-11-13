From: Frederic Leroy <fredo@starox.org>
Subject: Re: [arptables] rfc: add classify target
Date: Sat, 13 Nov 2010 16:29:34 +0100
Message-ID: <20101113162934.768e4a3c@caresse>
References: <20101107152636.56f62235@caresse>
	<alpine.LNX.2.01.1011071616150.21289@obet.zrqbmnf.qr>
	<4CD959D6.1090705@trash.net>
	<20101109161047.GB25549@sd-11162.dedibox.fr>
	<4CD98746.4050100@pandora.be>
	<20101109211834.4da8e412@caresse>
	<alpine.LNX.2.01.1011092121210.10710@obet.zrqbmnf.qr>
	<20101109215126.502a155e@caresse>
	<4CDBC7B1.2020101@trash.net>
	<20101111124505.345643a3@caresse>
	<4CDCF1A7.2050402@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/7d1/HhAcHGpGVTb=W/GoXFs"
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Bart De Schuymer <bdschuym@pandora.be>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sd-11162.dedibox.fr ([88.191.70.230]:57412 "EHLO
	sd-11162.dedibox.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702Ab0KMO3j (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 13 Nov 2010 09:29:39 -0500
In-Reply-To: <4CDCF1A7.2050402@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--MP_/7d1/HhAcHGpGVTb=W/GoXFs
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Le Fri, 12 Nov 2010 08:49:59 +0100,
Patrick McHardy <kaber@trash.net> a =C3=A9crit :

> On 11.11.2010 12:45, Frederic Leroy wrote:
> > Le Thu, 11 Nov 2010 11:38:41 +0100,
> > Patrick McHardy <kaber@trash.net> a =C3=A9crit :
>=20
> You can't change the numerical values, that would break compatibility.
> That basically leaves the option of using NF_INET_PRE_ROUTING instead
> of NF_ARP_IN etc, which would make things highly confusing :)

There is no much use of NF_ARP_* in the google codesearch world, but I
understand the need to not break compatibility.

So I joined my last patches to xt_CLASSIFY and arptables.=20

I checked that :
- modules are autoloaded
- it works as intended for marking cos on vlan interface.

--=20
Fr=C3=A9d=C3=A9ric Leroy

--MP_/7d1/HhAcHGpGVTb=W/GoXFs
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename=userspace_arptables_CLASSIFY_20101113.patch

diff -r e7c5081f9739 arptables.8
--- a/arptables.8	Sat Nov 06 23:20:16 2010 +0100
+++ b/arptables.8	Sat Nov 13 16:12:30 2010 +0100
@@ -297,6 +297,10 @@
 .BR "--mangle-target target "
 Target of ARP mangle operation
 .BR "" ( DROP ", " CONTINUE " or " ACCEPT " -- default is " ACCEPT ).
+.SS CLASSIFY
+.TP
+.BR "--set-class-mac major:minor"
+Classifies arp packet
 
 .SH MAILINGLISTS
 .BR "" "See " http://netfilter.org/mailinglists.html
diff -r e7c5081f9739 extensions/Makefile
--- a/extensions/Makefile	Sat Nov 06 23:20:16 2010 +0100
+++ b/extensions/Makefile	Sat Nov 13 16:12:30 2010 +0100
@@ -1,6 +1,6 @@
 #! /usr/bin/make
 
-EXT_FUNC+=standard mangle
+EXT_FUNC+=standard mangle CLASSIFY
 EXT_OBJS+=$(foreach T,$(EXT_FUNC), extensions/arpt_$(T).o)
 
 extensions/ebt_%.o: extensions/arpt_%.c include/arptables.h include/arptables_common.h
diff -r e7c5081f9739 extensions/arpt_CLASSIFY.c
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/extensions/arpt_CLASSIFY.c	Sat Nov 13 16:12:30 2010 +0100
@@ -0,0 +1,112 @@
+/*
+ * (C) 2010 by Frederic Leroy <fredo@starox.org>
+ *
+ * arpt_classify.c -- arptables extension to classify arp packet
+ *
+ *	This program is free software; you can redistribute it and/or modify
+ *	it under the terms of the GNU General Public License as published by
+ *	the Free Software Foundation; either version 2 of the License, or
+ *	(at your option) any later version.
+ *
+ *	This program is distributed in the hope that it will be useful,
+ *	but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *	GNU General Public License for more details.
+ *
+ *	You should have received a copy of the GNU General Public License
+ *	along with this program; if not, write to the Free Software
+ *	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <stdio.h>
+#include <getopt.h>
+#include <arptables.h>
+#include <linux/netfilter/xt_CLASSIFY.h>
+
+#define TC_H_MAJ_MASK (0xFFFF0000U)
+#define TC_H_MIN_MASK (0x0000FFFFU)
+#define TC_H_MAJ(h) ((h)&TC_H_MAJ_MASK)
+#define TC_H_MIN(h) ((h)&TC_H_MIN_MASK)
+#define TC_H_MAKE(maj,min) (((maj)&TC_H_MAJ_MASK)|((min)&TC_H_MIN_MASK))
+
+static void
+help(void)
+{
+	printf(
+"CLASSIFY target v%s options:\n"
+"--set-class major:minor : set the major and minor class value\n",
+	ARPTABLES_VERSION);
+}
+
+#define CLASSIFY_OPT 1
+
+static struct option opts[] = {
+	{ "set-class"   , required_argument, 0, CLASSIFY_OPT },
+	{0}
+};
+
+static void
+init(struct arpt_entry_target *t)
+{
+	struct xt_classify_target_info *classify = (struct xt_classify_target_info *) t->data;
+	classify->priority = 0;
+}
+
+static int
+parse(int c, char **argv, int invert, unsigned int *flags,
+	const struct arpt_entry *e,
+	struct arpt_entry_target **t)
+{
+	struct xt_classify_target_info *classify = (struct xt_classify_target_info *)(*t)->data;
+	int i,j;
+
+	switch (c) {
+		case CLASSIFY_OPT:
+			if (sscanf(argv[optind-1], "%x:%x", &i, &j) != 2)
+				return 0;
+			classify->priority = TC_H_MAKE(i<<16, j);
+			break;
+		default:
+			return 0;
+	}
+	return 1;
+}
+
+static void final_check(unsigned int flags)
+{
+}
+
+static void print(const struct arpt_arp *ip,
+	const struct arpt_entry_target *target, int numeric)
+{
+	struct xt_classify_target_info *t = (struct xt_classify_target_info *)(target->data);
+
+	printf("--set-class %x:%x ", TC_H_MAJ(t->priority)>>16, TC_H_MIN(t->priority));
+}
+
+static void
+save(const struct arpt_arp *ip, const struct arpt_entry_target *target)
+{
+}
+
+static
+struct arptables_target classify
+= { NULL,
+	"CLASSIFY",
+	ARPTABLES_VERSION,
+	ARPT_ALIGN(sizeof(struct xt_classify_target_info)),
+	ARPT_ALIGN(sizeof(struct xt_classify_target_info)),
+	&help,
+	&init,
+	&parse,
+	&final_check,
+	&print,
+	&save,
+	opts
+};
+
+static void _init(void) __attribute__ ((constructor));
+static void _init(void)
+{
+	register_target(&classify);
+}

--MP_/7d1/HhAcHGpGVTb=W/GoXFs
Content-Type: text/x-patch
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename=kernelspace_arptables_CLASSIFY_20101113.patch

commit 80e6be1186004e7f325482c0f151ab9c9fad155f
Author: Fr=C3=A9d=C3=A9ric Leroy <fredo@starox.org>
Date:   Sat Nov 13 16:16:43 2010 +0100

    netfilter: xtables: add arp support, allow CLASSIFY target on any table

diff --git a/net/netfilter/xt_CLASSIFY.c b/net/netfilter/xt_CLASSIFY.c
index c2c0e4a..af9c4da 100644
--- a/net/netfilter/xt_CLASSIFY.c
+++ b/net/netfilter/xt_CLASSIFY.c
@@ -19,12 +19,14 @@
 #include <linux/netfilter_ipv6.h>
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_CLASSIFY.h>
+#include <linux/netfilter_arp.h>
=20
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Xtables: Qdisc classification");
 MODULE_ALIAS("ipt_CLASSIFY");
 MODULE_ALIAS("ip6t_CLASSIFY");
+MODULE_ALIAS("arpt_CLASSIFY");
=20
 static unsigned int
 classify_tg(struct sk_buff *skb, const struct xt_action_param *par)
@@ -35,26 +37,36 @@ classify_tg(struct sk_buff *skb, const struct xt_action=
_param *par)
 	return XT_CONTINUE;
 }
=20
-static struct xt_target classify_tg_reg __read_mostly =3D {
-	.name       =3D "CLASSIFY",
-	.revision   =3D 0,
-	.family     =3D NFPROTO_UNSPEC,
-	.table      =3D "mangle",
-	.hooks      =3D (1 << NF_INET_LOCAL_OUT) | (1 << NF_INET_FORWARD) |
-		      (1 << NF_INET_POST_ROUTING),
-	.target     =3D classify_tg,
-	.targetsize =3D sizeof(struct xt_classify_target_info),
-	.me         =3D THIS_MODULE,
+static struct xt_target classify_tg_reg[] __read_mostly =3D {
+	{
+		.name       =3D "CLASSIFY",
+		.revision   =3D 0,
+		.family     =3D NFPROTO_UNSPEC,
+		.hooks      =3D (1 << NF_INET_LOCAL_OUT) | (1 << NF_INET_FORWARD) |
+		              (1 << NF_INET_POST_ROUTING),
+		.target     =3D classify_tg,
+		.targetsize =3D sizeof(struct xt_classify_target_info),
+		.me         =3D THIS_MODULE,
+	},
+	{
+		.name       =3D "CLASSIFY",
+		.revision   =3D 0,
+		.family     =3D NFPROTO_ARP,
+		.hooks      =3D (1 << NF_ARP_OUT) | (1 << NF_ARP_FORWARD),
+		.target     =3D classify_tg,
+		.targetsize =3D sizeof(struct xt_classify_target_info),
+		.me         =3D THIS_MODULE,
+	},
 };
=20
 static int __init classify_tg_init(void)
 {
-	return xt_register_target(&classify_tg_reg);
+	return xt_register_targets(classify_tg_reg, ARRAY_SIZE(classify_tg_reg));
 }
=20
 static void __exit classify_tg_exit(void)
 {
-	xt_unregister_target(&classify_tg_reg);
+	xt_unregister_targets(classify_tg_reg, ARRAY_SIZE(classify_tg_reg));
 }
=20
 module_init(classify_tg_init);

--MP_/7d1/HhAcHGpGVTb=W/GoXFs--
