From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 07/38]: xt_CONNMARK target, revision 1
Date: Tue, 15 Jan 2008 07:19:21 +0100 (MET)
Message-ID: <20080115061916.3184.89159.sendpatchset@localhost.localdomain>
References: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62175 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbYAOGTW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jan 2008 01:19:22 -0500
In-Reply-To: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: xt_CONNMARK target, revision 1

Introduces the xt_CONNMARK target revision 1. It uses fixed types, and
also uses the more expressive XOR logic. Futhermore, it allows to
selectively pick bits from both the ctmark and the nfmark in the SAVE
and RESTORE operations.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 49f994a1775f0f3284375f00d10b2251c0070528
tree 901d577d25ce2dcf63d3b8639f59bbd9f013c637
parent cf9efd38322201c52e424d16a304ce9970697f8f
author Jan Engelhardt <jengelh@computergmbh.de> Mon, 14 Jan 2008 06:51:=
25 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 15 Jan 2008 06:23:24 +=
0100

 include/linux/netfilter/xt_CONNMARK.h |    5 +
 net/netfilter/xt_CONNMARK.c           |  117 +++++++++++++++++++++++++=
++------
 2 files changed, 102 insertions(+), 20 deletions(-)

diff --git a/include/linux/netfilter/xt_CONNMARK.h b/include/linux/netf=
ilter/xt_CONNMARK.h
index 9f74468..4e58ba4 100644
--- a/include/linux/netfilter/xt_CONNMARK.h
+++ b/include/linux/netfilter/xt_CONNMARK.h
@@ -22,4 +22,9 @@ struct xt_connmark_target_info {
 	u_int8_t mode;
 };
=20
+struct xt_connmark_tginfo1 {
+	u_int32_t ctmark, ctmask, nfmask;
+	u_int8_t mode;
+};
+
 #endif /*_XT_CONNMARK_H_target*/
diff --git a/net/netfilter/xt_CONNMARK.c b/net/netfilter/xt_CONNMARK.c
index ec2eb34..b9bd772 100644
--- a/net/netfilter/xt_CONNMARK.c
+++ b/net/netfilter/xt_CONNMARK.c
@@ -1,8 +1,10 @@
-/* This kernel module is used to modify the connection mark values, or
- * to optionally restore the skb nfmark from the connection mark
+/*
+ *	xt_CONNMARK - Netfilter module to modify the connection mark values
  *
- * Copyright (C) 2002,2004 MARA Systems AB <http://www.marasystems.com=
>
- * by Henrik Nordstrom <hno@marasystems.com>
+ *	Copyright (C) 2002,2004 MARA Systems AB <http://www.marasystems.com=
>
+ *	by Henrik Nordstrom <hno@marasystems.com>
+ *	Copyright =C2=A9 CC Computer Consultants GmbH, 2007 - 2008
+ *	Jan Engelhardt <jengelh@computergmbh.de>
  *
  * This program is free software; you can redistribute it and/or modif=
y
  * it under the terms of the GNU General Public License as published b=
y
@@ -34,9 +36,9 @@ MODULE_ALIAS("ip6t_CONNMARK");
 #include <net/netfilter/nf_conntrack_ecache.h>
=20
 static unsigned int
-connmark_tg(struct sk_buff *skb, const struct net_device *in,
-            const struct net_device *out, unsigned int hooknum,
-            const struct xt_target *target, const void *targinfo)
+connmark_tg_v0(struct sk_buff *skb, const struct net_device *in,
+               const struct net_device *out, unsigned int hooknum,
+               const struct xt_target *target, const void *targinfo)
 {
 	const struct xt_connmark_target_info *markinfo =3D targinfo;
 	struct nf_conn *ct;
@@ -74,10 +76,50 @@ connmark_tg(struct sk_buff *skb, const struct net_d=
evice *in,
 	return XT_CONTINUE;
 }
=20
+static unsigned int
+connmark_tg(struct sk_buff *skb, const struct net_device *in,
+            const struct net_device *out, unsigned int hooknum,
+            const struct xt_target *target, const void *targinfo)
+{
+	const struct xt_connmark_tginfo1 *info =3D targinfo;
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
+			nf_conntrack_event_cache(IPCT_MARK, skb);
+		}
+		break;
+	case XT_CONNMARK_SAVE:
+		newmark =3D (ct->mark & ~info->ctmask) ^
+		          (skb->mark & info->nfmask);
+		if (ct->mark !=3D newmark) {
+			ct->mark =3D newmark;
+			nf_conntrack_event_cache(IPCT_MARK, skb);
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
 static bool
-connmark_tg_check(const char *tablename, const void *entry,
-                  const struct xt_target *target, void *targinfo,
-                  unsigned int hook_mask)
+connmark_tg_check_v0(const char *tablename, const void *entry,
+                     const struct xt_target *target, void *targinfo,
+                     unsigned int hook_mask)
 {
 	const struct xt_connmark_target_info *matchinfo =3D targinfo;
=20
@@ -101,6 +143,19 @@ connmark_tg_check(const char *tablename, const voi=
d *entry,
 	return true;
 }
=20
+static bool
+connmark_tg_check(const char *tablename, const void *entry,
+                  const struct xt_target *target, void *targinfo,
+                  unsigned int hook_mask)
+{
+	if (nf_ct_l3proto_try_module_get(target->family) < 0) {
+		printk(KERN_WARNING "cannot load conntrack support for "
+		       "proto=3D%u\n", target->family);
+		return false;
+	}
+	return true;
+}
+
 static void
 connmark_tg_destroy(const struct xt_target *target, void *targinfo)
 {
@@ -115,7 +170,7 @@ struct compat_xt_connmark_target_info {
 	u_int16_t	__pad2;
 };
=20
-static void connmark_tg_compat_from_user(void *dst, void *src)
+static void connmark_tg_compat_from_user_v0(void *dst, void *src)
 {
 	const struct compat_xt_connmark_target_info *cm =3D src;
 	struct xt_connmark_target_info m =3D {
@@ -126,7 +181,7 @@ static void connmark_tg_compat_from_user(void *dst,=
 void *src)
 	memcpy(dst, &m, sizeof(m));
 }
=20
-static int connmark_tg_compat_to_user(void __user *dst, void *src)
+static int connmark_tg_compat_to_user_v0(void __user *dst, void *src)
 {
 	const struct xt_connmark_target_info *m =3D src;
 	struct compat_xt_connmark_target_info cm =3D {
@@ -141,32 +196,54 @@ static int connmark_tg_compat_to_user(void __user=
 *dst, void *src)
 static struct xt_target connmark_tg_reg[] __read_mostly =3D {
 	{
 		.name		=3D "CONNMARK",
+		.revision	=3D 0,
 		.family		=3D AF_INET,
-		.checkentry	=3D connmark_tg_check,
+		.checkentry	=3D connmark_tg_check_v0,
 		.destroy	=3D connmark_tg_destroy,
-		.target		=3D connmark_tg,
+		.target		=3D connmark_tg_v0,
 		.targetsize	=3D sizeof(struct xt_connmark_target_info),
 #ifdef CONFIG_COMPAT
 		.compatsize	=3D sizeof(struct compat_xt_connmark_target_info),
-		.compat_from_user =3D connmark_tg_compat_from_user,
-		.compat_to_user	=3D connmark_tg_compat_to_user,
+		.compat_from_user =3D connmark_tg_compat_from_user_v0,
+		.compat_to_user	=3D connmark_tg_compat_to_user_v0,
 #endif
 		.me		=3D THIS_MODULE
 	},
 	{
 		.name		=3D "CONNMARK",
+		.revision	=3D 0,
 		.family		=3D AF_INET6,
-		.checkentry	=3D connmark_tg_check,
+		.checkentry	=3D connmark_tg_check_v0,
 		.destroy	=3D connmark_tg_destroy,
-		.target		=3D connmark_tg,
+		.target		=3D connmark_tg_v0,
 		.targetsize	=3D sizeof(struct xt_connmark_target_info),
 #ifdef CONFIG_COMPAT
 		.compatsize	=3D sizeof(struct compat_xt_connmark_target_info),
-		.compat_from_user =3D connmark_tg_compat_from_user,
-		.compat_to_user	=3D connmark_tg_compat_to_user,
+		.compat_from_user =3D connmark_tg_compat_from_user_v0,
+		.compat_to_user	=3D connmark_tg_compat_to_user_v0,
 #endif
 		.me		=3D THIS_MODULE
 	},
+	{
+		.name           =3D "CONNMARK",
+		.revision       =3D 1,
+		.family         =3D AF_INET,
+		.checkentry     =3D connmark_tg_check,
+		.target         =3D connmark_tg,
+		.targetsize     =3D sizeof(struct xt_connmark_tginfo1),
+		.destroy        =3D connmark_tg_destroy,
+		.me             =3D THIS_MODULE,
+	},
+	{
+		.name           =3D "CONNMARK",
+		.revision       =3D 1,
+		.family         =3D AF_INET6,
+		.checkentry     =3D connmark_tg_check,
+		.target         =3D connmark_tg,
+		.targetsize     =3D sizeof(struct xt_connmark_tginfo1),
+		.destroy        =3D connmark_tg_destroy,
+		.me             =3D THIS_MODULE,
+	},
 };
=20
 static int __init connmark_tg_init(void)
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
