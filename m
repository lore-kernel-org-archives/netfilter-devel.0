From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 12/38]: xt_mark match, revision 1
Date: Tue, 15 Jan 2008 07:19:28 +0100 (MET)
Message-ID: <20080115061923.3184.79287.sendpatchset@localhost.localdomain>
References: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62191 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229AbYAOGT3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jan 2008 01:19:29 -0500
In-Reply-To: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: xt_mark match, revision 1

Introduces the xt_mark match revision 1. It uses fixed types,
eventually obsoleting revision 0 some day (uses nonfixed types).

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 72c54af2cbc724b17aa0b4e58718311dd70617df
tree 7ec4ce8476efa20d77432f6581faececef7a2689
parent b222e77b3dc12bb1765559d1aec2bc2701d5e913
author Jan Engelhardt <jengelh@computergmbh.de> Mon, 14 Jan 2008 06:51:=
34 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 15 Jan 2008 06:53:17 +=
0100

 include/linux/netfilter/xt_mark.h |    5 +++
 net/netfilter/xt_mark.c           |   72 +++++++++++++++++++++++++++--=
--------
 2 files changed, 57 insertions(+), 20 deletions(-)

diff --git a/include/linux/netfilter/xt_mark.h b/include/linux/netfilte=
r/xt_mark.h
index 802dd48..fae74bc 100644
--- a/include/linux/netfilter/xt_mark.h
+++ b/include/linux/netfilter/xt_mark.h
@@ -6,4 +6,9 @@ struct xt_mark_info {
     u_int8_t invert;
 };
=20
+struct xt_mark_mtinfo1 {
+	u_int32_t mark, mask;
+	u_int8_t invert;
+};
+
 #endif /*_XT_MARK_H*/
diff --git a/net/netfilter/xt_mark.c b/net/netfilter/xt_mark.c
index ce8735e..5cc8cc5 100644
--- a/net/netfilter/xt_mark.c
+++ b/net/netfilter/xt_mark.c
@@ -1,10 +1,13 @@
-/* Kernel module to match NFMARK values. */
-
-/* (C) 1999-2001 Marc Boucher <marc@mbsi.ca>
+/*
+ *	xt_mark - Netfilter module to match NFMARK value
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
@@ -20,19 +23,30 @@ MODULE_ALIAS("ipt_mark");
 MODULE_ALIAS("ip6t_mark");
=20
 static bool
+mark_mt_v0(const struct sk_buff *skb, const struct net_device *in,
+           const struct net_device *out, const struct xt_match *match,
+           const void *matchinfo, int offset, unsigned int protoff,
+           bool *hotdrop)
+{
+	const struct xt_mark_info *info =3D matchinfo;
+
+	return ((skb->mark & info->mask) =3D=3D info->mark) ^ info->invert;
+}
+
+static bool
 mark_mt(const struct sk_buff *skb, const struct net_device *in,
         const struct net_device *out, const struct xt_match *match,
         const void *matchinfo, int offset, unsigned int protoff, bool =
*hotdrop)
 {
-	const struct xt_mark_info *info =3D matchinfo;
+	const struct xt_mark_mtinfo1 *info =3D matchinfo;
=20
 	return ((skb->mark & info->mask) =3D=3D info->mark) ^ info->invert;
 }
=20
 static bool
-mark_mt_check(const char *tablename, const void *entry,
-              const struct xt_match *match, void *matchinfo,
-              unsigned int hook_mask)
+mark_mt_check_v0(const char *tablename, const void *entry,
+                 const struct xt_match *match, void *matchinfo,
+                 unsigned int hook_mask)
 {
 	const struct xt_mark_info *minfo =3D matchinfo;
=20
@@ -51,7 +65,7 @@ struct compat_xt_mark_info {
 	u_int16_t	__pad2;
 };
=20
-static void mark_mt_compat_from_user(void *dst, void *src)
+static void mark_mt_compat_from_user_v0(void *dst, void *src)
 {
 	const struct compat_xt_mark_info *cm =3D src;
 	struct xt_mark_info m =3D {
@@ -62,7 +76,7 @@ static void mark_mt_compat_from_user(void *dst, void =
*src)
 	memcpy(dst, &m, sizeof(m));
 }
=20
-static int mark_mt_compat_to_user(void __user *dst, void *src)
+static int mark_mt_compat_to_user_v0(void __user *dst, void *src)
 {
 	const struct xt_mark_info *m =3D src;
 	struct compat_xt_mark_info cm =3D {
@@ -77,30 +91,48 @@ static int mark_mt_compat_to_user(void __user *dst,=
 void *src)
 static struct xt_match mark_mt_reg[] __read_mostly =3D {
 	{
 		.name		=3D "mark",
+		.revision	=3D 0,
 		.family		=3D AF_INET,
-		.checkentry	=3D mark_mt_check,
-		.match		=3D mark_mt,
+		.checkentry	=3D mark_mt_check_v0,
+		.match		=3D mark_mt_v0,
 		.matchsize	=3D sizeof(struct xt_mark_info),
 #ifdef CONFIG_COMPAT
 		.compatsize	=3D sizeof(struct compat_xt_mark_info),
-		.compat_from_user =3D mark_mt_compat_from_user,
-		.compat_to_user	=3D mark_mt_compat_to_user,
+		.compat_from_user =3D mark_mt_compat_from_user_v0,
+		.compat_to_user	=3D mark_mt_compat_to_user_v0,
 #endif
 		.me		=3D THIS_MODULE,
 	},
 	{
 		.name		=3D "mark",
+		.revision	=3D 0,
 		.family		=3D AF_INET6,
-		.checkentry	=3D mark_mt_check,
-		.match		=3D mark_mt,
+		.checkentry	=3D mark_mt_check_v0,
+		.match		=3D mark_mt_v0,
 		.matchsize	=3D sizeof(struct xt_mark_info),
 #ifdef CONFIG_COMPAT
 		.compatsize	=3D sizeof(struct compat_xt_mark_info),
-		.compat_from_user =3D mark_mt_compat_from_user,
-		.compat_to_user	=3D mark_mt_compat_to_user,
+		.compat_from_user =3D mark_mt_compat_from_user_v0,
+		.compat_to_user	=3D mark_mt_compat_to_user_v0,
 #endif
 		.me		=3D THIS_MODULE,
 	},
+	{
+		.name           =3D "mark",
+		.revision       =3D 1,
+		.family         =3D AF_INET,
+		.match          =3D mark_mt,
+		.matchsize      =3D sizeof(struct xt_mark_mtinfo1),
+		.me             =3D THIS_MODULE,
+	},
+	{
+		.name           =3D "mark",
+		.revision       =3D 1,
+		.family         =3D AF_INET6,
+		.match          =3D mark_mt,
+		.matchsize      =3D sizeof(struct xt_mark_mtinfo1),
+		.me             =3D THIS_MODULE,
+	},
 };
=20
 static int __init mark_mt_init(void)
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
