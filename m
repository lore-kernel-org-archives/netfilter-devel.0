From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: RFC: net/netfilter reorganization
Date: Sun, 5 Oct 2008 16:48:13 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0810051641220.32566@fbirervta.pbzchgretzou.qr>
References: <48E8E984.8090807@trash.net> <alpine.LNX.1.10.0810051221560.21891@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0810052101090.17356@blackhole.kfki.hu> <20081005.132850.34376215.davem@davemloft.net>
 <alpine.LNX.1.10.0810051632400.32566@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: kadlec@blackhole.kfki.hu, kaber@trash.net,
	netfilter-devel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:41194 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754523AbYJEUsQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Oct 2008 16:48:16 -0400
In-Reply-To: <alpine.LNX.1.10.0810051632400.32566@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2008-10-05 16:33, Jan Engelhardt wrote:
>On Sunday 2008-10-05 16:28, David Miller wrote:
>>> On Sun, 5 Oct 2008, Jan Engelhardt wrote:
>>>=20
>>> > I'd like to go for $(always lowercase extension name)_{mt,tg}.c i=
f=20
>>> > noone objects.
>>> > Or, when obvious extensions get combined maybe (like xt_mark and =
xt_MARK),
>>> > just mark.c and the issue is all gone.
>>>=20
>>> I think match/target combined in one file is the best way to go. As=
 they=20
>>> cover the same realm (match some quantity of something and change i=
t),=20
>>> they do fit together.
>>
>>This also makes sense to me.
>
>Before I start moving code, would we may want to combine more modules
>into one file at this point besides xt_FOO and xt_foo only?
(Probably not.)

=46unny thing is, only when you try you see more problems a-coming.
Like, Kconfig option names. Keep/Lose
NETFILTER_XT_{MATCH,TARGET}_CONNMARK, and query users for a new one?
Dunno. Sample patch below.

As for memory saving, the combined module weighs in at 4928 bytes,
whereas previously it took 5632 (2496+3136). Solid win of 12.50000%!


commit 1143a39a1f76331bf47bee6b63fded9fb5227e4b
parent 13992bcb338f0044010a1809f24d2198b5bd91c8
parenturl git://dev.medozas.de/linux master
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Sun Oct 5 16:46:52 2008 -0400

    netfilter: xtables: combine xt_connmark target and match
   =20
    Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/netfilter/Kconfig       |   40 ++-----
 net/netfilter/Makefile      |    3 +-
 net/netfilter/xt_CONNMARK.c |  225 -----------------------------------
 net/netfilter/xt_connmark.c |  206 +++++++++++++++++++++++++++++++-
 4 files changed, 212 insertions(+), 262 deletions(-)
 delete mode 100644 net/netfilter/xt_CONNMARK.c

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 899e780..bc65b31 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -302,6 +302,18 @@ config NETFILTER_XTABLES
=20
 if NETFILTER_XTABLES
=20
+# alphabetically ordered list of match/target combos
+
+config NETFILTER_XT_CONNMARK
+	tristate '"CONNMARK" extensions'
+	depends on NF_CONNTRACK
+	depends on NETFILTER_ADVANCED
+	select NF_CONNTRACK_MARK
+	---help---
+	This option adds support for manipulating and matching the
+	connection mark value. It is similar to the packet mark, but
+	is per-connection.
+
 # alphabetically ordered list of targets
=20
 config NETFILTER_XT_TARGET_CLASSIFY
@@ -316,21 +328,6 @@ config NETFILTER_XT_TARGET_CLASSIFY
=20
 	  To compile it as a module, choose M here.  If unsure, say N.
=20
-config NETFILTER_XT_TARGET_CONNMARK
-	tristate  '"CONNMARK" target support'
-	depends on IP_NF_MANGLE || IP6_NF_MANGLE
-	depends on NF_CONNTRACK
-	depends on NETFILTER_ADVANCED
-	select NF_CONNTRACK_MARK
-	help
-	  This option adds a `CONNMARK' target, which allows one to manipulat=
e
-	  the connection mark value.  Similar to the MARK target, but
-	  affects the connection mark value rather than the packet mark value=
=2E
-
-	  If you want to compile it as a module, say M here and read
-	  <file:Documentation/kbuild/modules.txt>.  The module will be called
-	  ipt_CONNMARK.ko.  If unsure, say `N'.
-
 config NETFILTER_XT_TARGET_CONNSECMARK
 	tristate '"CONNSECMARK" target support'
 	depends on NF_CONNTRACK && NF_CONNTRACK_SECMARK
@@ -521,19 +518,6 @@ config NETFILTER_XT_MATCH_CONNLIMIT
 	  This match allows you to match against the number of parallel
 	  connections to a server per client IP address (or address block).
=20
-config NETFILTER_XT_MATCH_CONNMARK
-	tristate  '"connmark" connection mark match support'
-	depends on NF_CONNTRACK
-	depends on NETFILTER_ADVANCED
-	select NF_CONNTRACK_MARK
-	help
-	  This option adds a `connmark' match, which allows you to match the
-	  connection mark value previously set for the session by `CONNMARK'.=
=20
-
-	  If you want to compile it as a module, say M here and read
-	  <file:Documentation/kbuild/modules.txt>.  The module will be called
-	  ipt_connmark.ko.  If unsure, say `N'.
-
 config NETFILTER_XT_MATCH_CONNTRACK
 	tristate '"conntrack" connection tracking match support'
 	depends on NF_CONNTRACK
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 8ce6766..62f48df 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -39,10 +39,10 @@ obj-$(CONFIG_NETFILTER_TPROXY) +=3D nf_tproxy_core.=
o
=20
 # generic X tables=20
 obj-$(CONFIG_NETFILTER_XTABLES) +=3D x_tables.o xt_tcpudp.o
+obj-$(CONFIG_NETFILTER_XT_CONNMARK) +=3D xt_connmark.o
=20
 # targets
 obj-$(CONFIG_NETFILTER_XT_TARGET_CLASSIFY) +=3D xt_CLASSIFY.o
-obj-$(CONFIG_NETFILTER_XT_TARGET_CONNMARK) +=3D xt_CONNMARK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_CONNSECMARK) +=3D xt_CONNSECMARK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_DSCP) +=3D xt_DSCP.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_MARK) +=3D xt_MARK.o
@@ -60,7 +60,6 @@ obj-$(CONFIG_NETFILTER_XT_TARGET_TRACE) +=3D xt_TRACE=
=2Eo
 obj-$(CONFIG_NETFILTER_XT_MATCH_COMMENT) +=3D xt_comment.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_CONNBYTES) +=3D xt_connbytes.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_CONNLIMIT) +=3D xt_connlimit.o
-obj-$(CONFIG_NETFILTER_XT_MATCH_CONNMARK) +=3D xt_connmark.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_CONNTRACK) +=3D xt_conntrack.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_DCCP) +=3D xt_dccp.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_DSCP) +=3D xt_dscp.o
diff --git a/net/netfilter/xt_CONNMARK.c b/net/netfilter/xt_CONNMARK.c
deleted file mode 100644
index d6e5ab4..0000000
--- a/net/netfilter/xt_CONNMARK.c
+++ /dev/null
@@ -1,225 +0,0 @@
-/*
- *	xt_CONNMARK - Netfilter module to modify the connection mark values
- *
- *	Copyright (C) 2002,2004 MARA Systems AB <http://www.marasystems.com=
>
- *	by Henrik Nordstrom <hno@marasystems.com>
- *	Copyright =C2=A9 CC Computer Consultants GmbH, 2007 - 2008
- *	Jan Engelhardt <jengelh@computergmbh.de>
- *
- * This program is free software; you can redistribute it and/or modif=
y
- * it under the terms of the GNU General Public License as published b=
y
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-130=
7  USA
- */
-#include <linux/module.h>
-#include <linux/skbuff.h>
-#include <linux/ip.h>
-#include <net/checksum.h>
-
-MODULE_AUTHOR("Henrik Nordstrom <hno@marasystems.com>");
-MODULE_DESCRIPTION("Xtables: connection mark modification");
-MODULE_LICENSE("GPL");
-MODULE_ALIAS("ipt_CONNMARK");
-MODULE_ALIAS("ip6t_CONNMARK");
-
-#include <linux/netfilter/x_tables.h>
-#include <linux/netfilter/xt_CONNMARK.h>
-#include <net/netfilter/nf_conntrack_ecache.h>
-
-static unsigned int
-connmark_tg_v0(struct sk_buff *skb, const struct xt_target_param *par)
-{
-	const struct xt_connmark_target_info *markinfo =3D par->targinfo;
-	struct nf_conn *ct;
-	enum ip_conntrack_info ctinfo;
-	u_int32_t diff;
-	u_int32_t mark;
-	u_int32_t newmark;
-
-	ct =3D nf_ct_get(skb, &ctinfo);
-	if (ct) {
-		switch(markinfo->mode) {
-		case XT_CONNMARK_SET:
-			newmark =3D (ct->mark & ~markinfo->mask) | markinfo->mark;
-			if (newmark !=3D ct->mark) {
-				ct->mark =3D newmark;
-				nf_conntrack_event_cache(IPCT_MARK, ct);
-			}
-			break;
-		case XT_CONNMARK_SAVE:
-			newmark =3D (ct->mark & ~markinfo->mask) |
-				  (skb->mark & markinfo->mask);
-			if (ct->mark !=3D newmark) {
-				ct->mark =3D newmark;
-				nf_conntrack_event_cache(IPCT_MARK, ct);
-			}
-			break;
-		case XT_CONNMARK_RESTORE:
-			mark =3D skb->mark;
-			diff =3D (ct->mark ^ mark) & markinfo->mask;
-			skb->mark =3D mark ^ diff;
-			break;
-		}
-	}
-
-	return XT_CONTINUE;
-}
-
-static unsigned int
-connmark_tg(struct sk_buff *skb, const struct xt_target_param *par)
-{
-	const struct xt_connmark_tginfo1 *info =3D par->targinfo;
-	enum ip_conntrack_info ctinfo;
-	struct nf_conn *ct;
-	u_int32_t newmark;
-
-	ct =3D nf_ct_get(skb, &ctinfo);
-	if (ct =3D=3D NULL)
-		return XT_CONTINUE;
-
-	switch (info->mode) {
-	case XT_CONNMARK_SET:
-		newmark =3D (ct->mark & ~info->ctmask) ^ info->ctmark;
-		if (ct->mark !=3D newmark) {
-			ct->mark =3D newmark;
-			nf_conntrack_event_cache(IPCT_MARK, ct);
-		}
-		break;
-	case XT_CONNMARK_SAVE:
-		newmark =3D (ct->mark & ~info->ctmask) ^
-		          (skb->mark & info->nfmask);
-		if (ct->mark !=3D newmark) {
-			ct->mark =3D newmark;
-			nf_conntrack_event_cache(IPCT_MARK, ct);
-		}
-		break;
-	case XT_CONNMARK_RESTORE:
-		newmark =3D (skb->mark & ~info->nfmask) ^
-		          (ct->mark & info->ctmask);
-		skb->mark =3D newmark;
-		break;
-	}
-
-	return XT_CONTINUE;
-}
-
-static bool connmark_tg_check_v0(const struct xt_tgchk_param *par)
-{
-	const struct xt_connmark_target_info *matchinfo =3D par->targinfo;
-
-	if (matchinfo->mode =3D=3D XT_CONNMARK_RESTORE) {
-		if (strcmp(par->table, "mangle") !=3D 0) {
-			printk(KERN_WARNING "CONNMARK: restore can only be "
-			       "called from \"mangle\" table, not \"%s\"\n",
-			       par->table);
-			return false;
-		}
-	}
-	if (matchinfo->mark > 0xffffffff || matchinfo->mask > 0xffffffff) {
-		printk(KERN_WARNING "CONNMARK: Only supports 32bit mark\n");
-		return false;
-	}
-	if (nf_ct_l3proto_try_module_get(par->family) < 0) {
-		printk(KERN_WARNING "can't load conntrack support for "
-				    "proto=3D%u\n", par->family);
-		return false;
-	}
-	return true;
-}
-
-static bool connmark_tg_check(const struct xt_tgchk_param *par)
-{
-	if (nf_ct_l3proto_try_module_get(par->family) < 0) {
-		printk(KERN_WARNING "cannot load conntrack support for "
-		       "proto=3D%u\n", par->family);
-		return false;
-	}
-	return true;
-}
-
-static void connmark_tg_destroy(const struct xt_tgdtor_param *par)
-{
-	nf_ct_l3proto_module_put(par->family);
-}
-
-#ifdef CONFIG_COMPAT
-struct compat_xt_connmark_target_info {
-	compat_ulong_t	mark, mask;
-	u_int8_t	mode;
-	u_int8_t	__pad1;
-	u_int16_t	__pad2;
-};
-
-static void connmark_tg_compat_from_user_v0(void *dst, void *src)
-{
-	const struct compat_xt_connmark_target_info *cm =3D src;
-	struct xt_connmark_target_info m =3D {
-		.mark	=3D cm->mark,
-		.mask	=3D cm->mask,
-		.mode	=3D cm->mode,
-	};
-	memcpy(dst, &m, sizeof(m));
-}
-
-static int connmark_tg_compat_to_user_v0(void __user *dst, void *src)
-{
-	const struct xt_connmark_target_info *m =3D src;
-	struct compat_xt_connmark_target_info cm =3D {
-		.mark	=3D m->mark,
-		.mask	=3D m->mask,
-		.mode	=3D m->mode,
-	};
-	return copy_to_user(dst, &cm, sizeof(cm)) ? -EFAULT : 0;
-}
-#endif /* CONFIG_COMPAT */
-
-static struct xt_target connmark_tg_reg[] __read_mostly =3D {
-	{
-		.name		=3D "CONNMARK",
-		.revision	=3D 0,
-		.family		=3D NFPROTO_UNSPEC,
-		.checkentry	=3D connmark_tg_check_v0,
-		.destroy	=3D connmark_tg_destroy,
-		.target		=3D connmark_tg_v0,
-		.targetsize	=3D sizeof(struct xt_connmark_target_info),
-#ifdef CONFIG_COMPAT
-		.compatsize	=3D sizeof(struct compat_xt_connmark_target_info),
-		.compat_from_user =3D connmark_tg_compat_from_user_v0,
-		.compat_to_user	=3D connmark_tg_compat_to_user_v0,
-#endif
-		.me		=3D THIS_MODULE
-	},
-	{
-		.name           =3D "CONNMARK",
-		.revision       =3D 1,
-		.family         =3D NFPROTO_UNSPEC,
-		.checkentry     =3D connmark_tg_check,
-		.target         =3D connmark_tg,
-		.targetsize     =3D sizeof(struct xt_connmark_tginfo1),
-		.destroy        =3D connmark_tg_destroy,
-		.me             =3D THIS_MODULE,
-	},
-};
-
-static int __init connmark_tg_init(void)
-{
-	return xt_register_targets(connmark_tg_reg,
-	       ARRAY_SIZE(connmark_tg_reg));
-}
-
-static void __exit connmark_tg_exit(void)
-{
-	xt_unregister_targets(connmark_tg_reg, ARRAY_SIZE(connmark_tg_reg));
-}
-
-module_init(connmark_tg_init);
-module_exit(connmark_tg_exit);
diff --git a/net/netfilter/xt_connmark.c b/net/netfilter/xt_connmark.c
index 86cacab..bcfad86 100644
--- a/net/netfilter/xt_connmark.c
+++ b/net/netfilter/xt_connmark.c
@@ -26,12 +26,16 @@
 #include <net/netfilter/nf_conntrack.h>
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_connmark.h>
+#include <linux/netfilter/xt_CONNMARK.h>
+#include <net/netfilter/nf_conntrack_ecache.h>
=20
 MODULE_AUTHOR("Henrik Nordstrom <hno@marasystems.com>");
-MODULE_DESCRIPTION("Xtables: connection mark match");
+MODULE_DESCRIPTION("Xtables: connection mark match and modification");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_connmark");
 MODULE_ALIAS("ip6t_connmark");
+MODULE_ALIAS("ipt_CONNMARK");
+MODULE_ALIAS("ip6t_CONNMARK");
=20
 static bool
 connmark_mt(const struct sk_buff *skb, const struct xt_match_param *pa=
r)
@@ -92,6 +96,122 @@ static void connmark_mt_destroy(const struct xt_mtd=
tor_param *par)
 	nf_ct_l3proto_module_put(par->family);
 }
=20
+static unsigned int
+connmark_tg_v0(struct sk_buff *skb, const struct xt_target_param *par)
+{
+	const struct xt_connmark_target_info *markinfo =3D par->targinfo;
+	struct nf_conn *ct;
+	enum ip_conntrack_info ctinfo;
+	u_int32_t diff;
+	u_int32_t mark;
+	u_int32_t newmark;
+
+	ct =3D nf_ct_get(skb, &ctinfo);
+	if (ct) {
+		switch(markinfo->mode) {
+		case XT_CONNMARK_SET:
+			newmark =3D (ct->mark & ~markinfo->mask) | markinfo->mark;
+			if (newmark !=3D ct->mark) {
+				ct->mark =3D newmark;
+				nf_conntrack_event_cache(IPCT_MARK, ct);
+			}
+			break;
+		case XT_CONNMARK_SAVE:
+			newmark =3D (ct->mark & ~markinfo->mask) |
+				  (skb->mark & markinfo->mask);
+			if (ct->mark !=3D newmark) {
+				ct->mark =3D newmark;
+				nf_conntrack_event_cache(IPCT_MARK, ct);
+			}
+			break;
+		case XT_CONNMARK_RESTORE:
+			mark =3D skb->mark;
+			diff =3D (ct->mark ^ mark) & markinfo->mask;
+			skb->mark =3D mark ^ diff;
+			break;
+		}
+	}
+
+	return XT_CONTINUE;
+}
+
+static unsigned int
+connmark_tg(struct sk_buff *skb, const struct xt_target_param *par)
+{
+	const struct xt_connmark_tginfo1 *info =3D par->targinfo;
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn *ct;
+	u_int32_t newmark;
+
+	ct =3D nf_ct_get(skb, &ctinfo);
+	if (ct =3D=3D NULL)
+		return XT_CONTINUE;
+
+	switch (info->mode) {
+	case XT_CONNMARK_SET:
+		newmark =3D (ct->mark & ~info->ctmask) ^ info->ctmark;
+		if (ct->mark !=3D newmark) {
+			ct->mark =3D newmark;
+			nf_conntrack_event_cache(IPCT_MARK, ct);
+		}
+		break;
+	case XT_CONNMARK_SAVE:
+		newmark =3D (ct->mark & ~info->ctmask) ^
+		          (skb->mark & info->nfmask);
+		if (ct->mark !=3D newmark) {
+			ct->mark =3D newmark;
+			nf_conntrack_event_cache(IPCT_MARK, ct);
+		}
+		break;
+	case XT_CONNMARK_RESTORE:
+		newmark =3D (skb->mark & ~info->nfmask) ^
+		          (ct->mark & info->ctmask);
+		skb->mark =3D newmark;
+		break;
+	}
+
+	return XT_CONTINUE;
+}
+
+static bool connmark_tg_check_v0(const struct xt_tgchk_param *par)
+{
+	const struct xt_connmark_target_info *matchinfo =3D par->targinfo;
+
+	if (matchinfo->mode =3D=3D XT_CONNMARK_RESTORE) {
+		if (strcmp(par->table, "mangle") !=3D 0) {
+			printk(KERN_WARNING "CONNMARK: restore can only be "
+			       "called from \"mangle\" table, not \"%s\"\n",
+			       par->table);
+			return false;
+		}
+	}
+	if (matchinfo->mark > 0xffffffff || matchinfo->mask > 0xffffffff) {
+		printk(KERN_WARNING "CONNMARK: Only supports 32bit mark\n");
+		return false;
+	}
+	if (nf_ct_l3proto_try_module_get(par->family) < 0) {
+		printk(KERN_WARNING "can't load conntrack support for "
+				    "proto=3D%u\n", par->family);
+		return false;
+	}
+	return true;
+}
+
+static bool connmark_tg_check(const struct xt_tgchk_param *par)
+{
+	if (nf_ct_l3proto_try_module_get(par->family) < 0) {
+		printk(KERN_WARNING "cannot load conntrack support for "
+		       "proto=3D%u\n", par->family);
+		return false;
+	}
+	return true;
+}
+
+static void connmark_tg_destroy(const struct xt_tgdtor_param *par)
+{
+	nf_ct_l3proto_module_put(par->family);
+}
+
 #ifdef CONFIG_COMPAT
 struct compat_xt_connmark_info {
 	compat_ulong_t	mark, mask;
@@ -100,6 +220,13 @@ struct compat_xt_connmark_info {
 	u_int16_t	__pad2;
 };
=20
+struct compat_xt_connmark_target_info {
+	compat_ulong_t	mark, mask;
+	u_int8_t	mode;
+	u_int8_t	__pad1;
+	u_int16_t	__pad2;
+};
+
 static void connmark_mt_compat_from_user_v0(void *dst, void *src)
 {
 	const struct compat_xt_connmark_info *cm =3D src;
@@ -121,6 +248,28 @@ static int connmark_mt_compat_to_user_v0(void __us=
er *dst, void *src)
 	};
 	return copy_to_user(dst, &cm, sizeof(cm)) ? -EFAULT : 0;
 }
+
+static void connmark_tg_compat_from_user_v0(void *dst, void *src)
+{
+	const struct compat_xt_connmark_target_info *cm =3D src;
+	struct xt_connmark_target_info m =3D {
+		.mark	=3D cm->mark,
+		.mask	=3D cm->mask,
+		.mode	=3D cm->mode,
+	};
+	memcpy(dst, &m, sizeof(m));
+}
+
+static int connmark_tg_compat_to_user_v0(void __user *dst, void *src)
+{
+	const struct xt_connmark_target_info *m =3D src;
+	struct compat_xt_connmark_target_info cm =3D {
+		.mark	=3D m->mark,
+		.mask	=3D m->mask,
+		.mode	=3D m->mode,
+	};
+	return copy_to_user(dst, &cm, sizeof(cm)) ? -EFAULT : 0;
+}
 #endif /* CONFIG_COMPAT */
=20
 static struct xt_match connmark_mt_reg[] __read_mostly =3D {
@@ -151,16 +300,59 @@ static struct xt_match connmark_mt_reg[] __read_m=
ostly =3D {
 	},
 };
=20
-static int __init connmark_mt_init(void)
+static struct xt_target connmark_tg_reg[] __read_mostly =3D {
+	{
+		.name		=3D "CONNMARK",
+		.revision	=3D 0,
+		.family		=3D NFPROTO_UNSPEC,
+		.checkentry	=3D connmark_tg_check_v0,
+		.destroy	=3D connmark_tg_destroy,
+		.target		=3D connmark_tg_v0,
+		.targetsize	=3D sizeof(struct xt_connmark_target_info),
+#ifdef CONFIG_COMPAT
+		.compatsize	=3D sizeof(struct compat_xt_connmark_target_info),
+		.compat_from_user =3D connmark_tg_compat_from_user_v0,
+		.compat_to_user	=3D connmark_tg_compat_to_user_v0,
+#endif
+		.me		=3D THIS_MODULE
+	},
+	{
+		.name           =3D "CONNMARK",
+		.revision       =3D 1,
+		.family         =3D NFPROTO_UNSPEC,
+		.checkentry     =3D connmark_tg_check,
+		.target         =3D connmark_tg,
+		.targetsize     =3D sizeof(struct xt_connmark_tginfo1),
+		.destroy        =3D connmark_tg_destroy,
+		.me             =3D THIS_MODULE,
+	},
+};
+
+static int __init xt_connmark_init(void)
 {
-	return xt_register_matches(connmark_mt_reg,
-	       ARRAY_SIZE(connmark_mt_reg));
+	int ret;
+
+	ret =3D xt_register_matches(connmark_mt_reg,
+	      ARRAY_SIZE(connmark_mt_reg));
+	if (ret < 0)
+		return ret;
+
+	ret =3D xt_register_targets(connmark_tg_reg,
+	      ARRAY_SIZE(connmark_tg_reg));
+	if (ret < 0) {
+		xt_unregister_matches(connmark_mt_reg,
+				      ARRAY_SIZE(connmark_mt_reg));
+		return ret;
+	}
+
+	return 0;
 }
=20
-static void __exit connmark_mt_exit(void)
+static void __exit xt_connmark_exit(void)
 {
 	xt_unregister_matches(connmark_mt_reg, ARRAY_SIZE(connmark_mt_reg));
+	xt_unregister_targets(connmark_tg_reg, ARRAY_SIZE(connmark_tg_reg));
 }
=20
-module_init(connmark_mt_init);
-module_exit(connmark_mt_exit);
+module_init(xt_connmark_init);
+module_exit(xt_connmark_exit);
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
