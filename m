From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 08/38]: xt_MARK target, revision 2
Date: Tue, 15 Jan 2008 07:19:23 +0100 (MET)
Message-ID: <20080115061918.3184.70364.sendpatchset@localhost.localdomain>
References: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62179 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbYAOGTY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jan 2008 01:19:24 -0500
In-Reply-To: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: xt_MARK target, revision 2

Introduces the xt_MARK target revision 2. It uses fixed types, and
also uses the more expressive XOR logic.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 158847483305cdda53fa8c786a41a9cbfa692528
tree f42c759081ada7a5b0a99b5b8e5fd244dc3b9c54
parent 49f994a1775f0f3284375f00d10b2251c0070528
author Jan Engelhardt <jengelh@computergmbh.de> Mon, 14 Jan 2008 06:51:=
27 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 15 Jan 2008 06:23:25 +=
0100

 include/linux/netfilter/xt_MARK.h |    4 ++
 net/netfilter/xt_MARK.c           |   74 ++++++++++++++++++++++++++---=
--------
 2 files changed, 56 insertions(+), 22 deletions(-)

diff --git a/include/linux/netfilter/xt_MARK.h b/include/linux/netfilte=
r/xt_MARK.h
index b021e93..778b278 100644
--- a/include/linux/netfilter/xt_MARK.h
+++ b/include/linux/netfilter/xt_MARK.h
@@ -18,4 +18,8 @@ struct xt_mark_target_info_v1 {
 	u_int8_t mode;
 };
=20
+struct xt_mark_tginfo2 {
+	u_int32_t mark, mask;
+};
+
 #endif /*_XT_MARK_H_target */
diff --git a/net/netfilter/xt_MARK.c b/net/netfilter/xt_MARK.c
index 57c6d55..1c3fb75 100644
--- a/net/netfilter/xt_MARK.c
+++ b/net/netfilter/xt_MARK.c
@@ -1,10 +1,13 @@
-/* This is a module which is used for setting the NFMARK field of an s=
kb. */
-
-/* (C) 1999-2001 Marc Boucher <marc@mbsi.ca>
+/*
+ *	xt_MARK - Netfilter module to modify the NFMARK field of an skb
+ *
+ *	(C) 1999-2001 Marc Boucher <marc@mbsi.ca>
+ *	Copyright =C2=A9 CC Computer Consultants GmbH, 2007 - 2008
+ *	Jan Engelhardt <jengelh@computergmbh.de>
  *
- * This program is free software; you can redistribute it and/or modif=
y
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
+ *	This program is free software; you can redistribute it and/or modif=
y
+ *	it under the terms of the GNU General Public License version 2 as
+ *	published by the Free Software Foundation.
  */
=20
 #include <linux/module.h>
@@ -33,9 +36,9 @@ mark_tg_v0(struct sk_buff *skb, const struct net_devi=
ce *in,
 }
=20
 static unsigned int
-mark_tg(struct sk_buff *skb, const struct net_device *in,
-        const struct net_device *out, unsigned int hooknum,
-        const struct xt_target *target, const void *targinfo)
+mark_tg_v1(struct sk_buff *skb, const struct net_device *in,
+           const struct net_device *out, unsigned int hooknum,
+           const struct xt_target *target, const void *targinfo)
 {
 	const struct xt_mark_target_info_v1 *markinfo =3D targinfo;
 	int mark =3D 0;
@@ -58,6 +61,17 @@ mark_tg(struct sk_buff *skb, const struct net_device=
 *in,
 	return XT_CONTINUE;
 }
=20
+static unsigned int
+mark_tg(struct sk_buff *skb, const struct net_device *in,
+        const struct net_device *out, unsigned int hooknum,
+        const struct xt_target *target, const void *targinfo)
+{
+	const struct xt_mark_tginfo2 *info =3D targinfo;
+
+	skb->mark =3D (skb->mark & ~info->mask) ^ info->mark;
+	return XT_CONTINUE;
+}
+
 static bool
 mark_tg_check_v0(const char *tablename, const void *entry,
                  const struct xt_target *target, void *targinfo,
@@ -73,9 +87,9 @@ mark_tg_check_v0(const char *tablename, const void *e=
ntry,
 }
=20
 static bool
-mark_tg_check(const char *tablename, const void *entry,
-              const struct xt_target *target, void *targinfo,
-              unsigned int hook_mask)
+mark_tg_check_v1(const char *tablename, const void *entry,
+                 const struct xt_target *target, void *targinfo,
+                 unsigned int hook_mask)
 {
 	const struct xt_mark_target_info_v1 *markinfo =3D targinfo;
=20
@@ -98,7 +112,7 @@ struct compat_xt_mark_target_info {
 	compat_ulong_t	mark;
 };
=20
-static void mark_tg_compat_from_user(void *dst, void *src)
+static void mark_tg_compat_from_user_v0(void *dst, void *src)
 {
 	const struct compat_xt_mark_target_info *cm =3D src;
 	struct xt_mark_target_info m =3D {
@@ -107,7 +121,7 @@ static void mark_tg_compat_from_user(void *dst, voi=
d *src)
 	memcpy(dst, &m, sizeof(m));
 }
=20
-static int mark_tg_compat_to_user(void __user *dst, void *src)
+static int mark_tg_compat_to_user_v0(void __user *dst, void *src)
 {
 	const struct xt_mark_target_info *m =3D src;
 	struct compat_xt_mark_target_info cm =3D {
@@ -154,8 +168,8 @@ static struct xt_target mark_tg_reg[] __read_mostly=
 =3D {
 		.targetsize	=3D sizeof(struct xt_mark_target_info),
 #ifdef CONFIG_COMPAT
 		.compatsize	=3D sizeof(struct compat_xt_mark_target_info),
-		.compat_from_user =3D mark_tg_compat_from_user,
-		.compat_to_user	=3D mark_tg_compat_to_user,
+		.compat_from_user =3D mark_tg_compat_from_user_v0,
+		.compat_to_user	=3D mark_tg_compat_to_user_v0,
 #endif
 		.table		=3D "mangle",
 		.me		=3D THIS_MODULE,
@@ -164,8 +178,8 @@ static struct xt_target mark_tg_reg[] __read_mostly=
 =3D {
 		.name		=3D "MARK",
 		.family		=3D AF_INET,
 		.revision	=3D 1,
-		.checkentry	=3D mark_tg_check,
-		.target		=3D mark_tg,
+		.checkentry	=3D mark_tg_check_v1,
+		.target		=3D mark_tg_v1,
 		.targetsize	=3D sizeof(struct xt_mark_target_info_v1),
 #ifdef CONFIG_COMPAT
 		.compatsize	=3D sizeof(struct compat_xt_mark_target_info_v1),
@@ -184,8 +198,8 @@ static struct xt_target mark_tg_reg[] __read_mostly=
 =3D {
 		.targetsize	=3D sizeof(struct xt_mark_target_info),
 #ifdef CONFIG_COMPAT
 		.compatsize	=3D sizeof(struct compat_xt_mark_target_info),
-		.compat_from_user =3D mark_tg_compat_from_user,
-		.compat_to_user	=3D mark_tg_compat_to_user,
+		.compat_from_user =3D mark_tg_compat_from_user_v0,
+		.compat_to_user	=3D mark_tg_compat_to_user_v0,
 #endif
 		.table		=3D "mangle",
 		.me		=3D THIS_MODULE,
@@ -194,8 +208,8 @@ static struct xt_target mark_tg_reg[] __read_mostly=
 =3D {
 		.name		=3D "MARK",
 		.family		=3D AF_INET6,
 		.revision	=3D 1,
-		.checkentry	=3D mark_tg_check,
-		.target		=3D mark_tg,
+		.checkentry	=3D mark_tg_check_v1,
+		.target		=3D mark_tg_v1,
 		.targetsize	=3D sizeof(struct xt_mark_target_info_v1),
 #ifdef CONFIG_COMPAT
 		.compatsize	=3D sizeof(struct compat_xt_mark_target_info_v1),
@@ -205,6 +219,22 @@ static struct xt_target mark_tg_reg[] __read_mostl=
y =3D {
 		.table		=3D "mangle",
 		.me		=3D THIS_MODULE,
 	},
+	{
+		.name           =3D "MARK",
+		.revision       =3D 2,
+		.family         =3D AF_INET,
+		.target         =3D mark_tg,
+		.targetsize     =3D sizeof(struct xt_mark_tginfo2),
+		.me             =3D THIS_MODULE,
+	},
+	{
+		.name           =3D "MARK",
+		.revision       =3D 2,
+		.family         =3D AF_INET6,
+		.target         =3D mark_tg,
+		.targetsize     =3D sizeof(struct xt_mark_tginfo2),
+		.me             =3D THIS_MODULE,
+	},
 };
=20
 static int __init mark_tg_init(void)
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
