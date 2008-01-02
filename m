From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 8/27] xt_connmark match, revision 1
Date: Wed, 2 Jan 2008 21:27:50 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801022127380.14900@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:60581 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbYABU1w (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Jan 2008 15:27:52 -0500
In-Reply-To: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 375972a6ff3579f150bf916621b6fe752d29f25a
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Wed Jan 2 17:52:04 2008 +0100

    [NETFILTER]: xt_connmark match, revision 1
   =20
    Introduces the xt_connmark match revision 1. It uses fixed types,
    eventually obsoleting revision 0 some day (uses nonfixed types).
    (Unfixed types like "unsigned long" do not play well with mixed
    user-/kernelspace "bitness", e.g. 32/64, as is common on SPARC64,
    and need extra compat code.)
   =20
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

 include/linux/netfilter/xt_connmark.h |    5 ++
 net/netfilter/xt_connmark.c           |   84 ++++++++++++++++++++-----
 2 files changed, 74 insertions(+), 15 deletions(-)

diff --git a/include/linux/netfilter/xt_connmark.h b/include/linux/netf=
ilter/xt_connmark.h
index c592f6a..359ef86 100644
--- a/include/linux/netfilter/xt_connmark.h
+++ b/include/linux/netfilter/xt_connmark.h
@@ -15,4 +15,9 @@ struct xt_connmark_info {
 	u_int8_t invert;
 };
=20
+struct xt_connmark_mtinfo1 {
+	u_int32_t mark, mask;
+	u_int8_t invert;
+};
+
 #endif /*_XT_CONNMARK_H*/
diff --git a/net/netfilter/xt_connmark.c b/net/netfilter/xt_connmark.c
index 8ad875b..60d9605 100644
--- a/net/netfilter/xt_connmark.c
+++ b/net/netfilter/xt_connmark.c
@@ -1,8 +1,10 @@
-/* This kernel module matches connection mark values set by the
- * CONNMARK target
+/*
+ *	xt_connmark - Netfilter module to match connection mark values
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
@@ -37,6 +39,23 @@ connmark_mt(const struct sk_buff *skb, const struct =
net_device *in,
             const void *matchinfo, int offset, unsigned int protoff,
             bool *hotdrop)
 {
+	const struct xt_connmark_mtinfo1 *info =3D matchinfo;
+	enum ip_conntrack_info ctinfo;
+	const struct nf_conn *ct;
+
+	ct =3D nf_ct_get(skb, &ctinfo);
+	if (ct =3D=3D NULL)
+		return false;
+
+	return ((ct->mark & info->mask) =3D=3D info->mark) ^ info->invert;
+}
+
+static bool
+connmark_mt_v0(const struct sk_buff *skb, const struct net_device *in,
+               const struct net_device *out, const struct xt_match *ma=
tch,
+               const void *matchinfo, int offset, unsigned int protoff=
,
+               bool *hotdrop)
+{
 	const struct xt_connmark_info *info =3D matchinfo;
 	const struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
@@ -49,9 +68,9 @@ connmark_mt(const struct sk_buff *skb, const struct n=
et_device *in,
 }
=20
 static bool
-connmark_mt_check(const char *tablename, const void *ip,
-                  const struct xt_match *match, void *matchinfo,
-                  unsigned int hook_mask)
+connmark_mt_check_v0(const char *tablename, const void *ip,
+                     const struct xt_match *match, void *matchinfo,
+                     unsigned int hook_mask)
 {
 	const struct xt_connmark_info *cm =3D matchinfo;
=20
@@ -67,6 +86,19 @@ connmark_mt_check(const char *tablename, const void =
*ip,
 	return true;
 }
=20
+static bool
+connmark_mt_check(const char *tablename, const void *ip,
+                  const struct xt_match *match, void *matchinfo,
+                  unsigned int hook_mask)
+{
+	if (nf_ct_l3proto_try_module_get(match->family) < 0) {
+		printk(KERN_WARNING "cannot load conntrack support for "
+		       "proto=3D%u\n", match->family);
+		return false;
+	}
+	return true;
+}
+
 static void
 connmark_mt_destroy(const struct xt_match *match, void *matchinfo)
 {
@@ -81,7 +113,7 @@ struct compat_xt_connmark_info {
 	u_int16_t	__pad2;
 };
=20
-static void connmark_mt_compat_from_user(void *dst, void *src)
+static void connmark_mt_compat_from_user_v0(void *dst, void *src)
 {
 	const struct compat_xt_connmark_info *cm =3D src;
 	struct xt_connmark_info m =3D {
@@ -92,7 +124,7 @@ static void connmark_mt_compat_from_user(void *dst, =
void *src)
 	memcpy(dst, &m, sizeof(m));
 }
=20
-static int connmark_mt_compat_to_user(void __user *dst, void *src)
+static int connmark_mt_compat_to_user_v0(void __user *dst, void *src)
 {
 	const struct xt_connmark_info *m =3D src;
 	struct compat_xt_connmark_info cm =3D {
@@ -107,23 +139,25 @@ static int connmark_mt_compat_to_user(void __user=
 *dst, void *src)
 static struct xt_match connmark_mt_reg[] __read_mostly =3D {
 	{
 		.name		=3D "connmark",
+		.revision	=3D 0,
 		.family		=3D AF_INET,
-		.checkentry	=3D connmark_mt_check,
-		.match		=3D connmark_mt,
+		.checkentry	=3D connmark_mt_check_v0,
+		.match		=3D connmark_mt_v0,
 		.destroy	=3D connmark_mt_destroy,
 		.matchsize	=3D sizeof(struct xt_connmark_info),
 #ifdef CONFIG_COMPAT
 		.compatsize	=3D sizeof(struct compat_xt_connmark_info),
-		.compat_from_user =3D connmark_mt_compat_from_user,
-		.compat_to_user	=3D connmark_mt_compat_to_user,
+		.compat_from_user =3D connmark_mt_compat_from_user_v0,
+		.compat_to_user	=3D connmark_mt_compat_to_user_v0,
 #endif
 		.me		=3D THIS_MODULE
 	},
 	{
 		.name		=3D "connmark",
+		.revision	=3D 0,
 		.family		=3D AF_INET6,
-		.checkentry	=3D connmark_mt_check,
-		.match		=3D connmark_mt,
+		.checkentry	=3D connmark_mt_check_v0,
+		.match		=3D connmark_mt_v0,
 		.destroy	=3D connmark_mt_destroy,
 		.matchsize	=3D sizeof(struct xt_connmark_info),
 #ifdef CONFIG_COMPAT
@@ -133,6 +167,26 @@ static struct xt_match connmark_mt_reg[] __read_mo=
stly =3D {
 #endif
 		.me		=3D THIS_MODULE
 	},
+	{
+		.name           =3D "connmark",
+		.revision       =3D 1,
+		.family         =3D AF_INET,
+		.checkentry     =3D connmark_mt_check,
+		.match          =3D connmark_mt,
+		.matchsize      =3D sizeof(struct xt_connmark_mtinfo1),
+		.destroy        =3D connmark_mt_destroy,
+		.me             =3D THIS_MODULE,
+	},
+	{
+		.name           =3D "connmark",
+		.revision       =3D 1,
+		.family         =3D AF_INET6,
+		.checkentry     =3D connmark_mt_check,
+		.match          =3D connmark_mt,
+		.matchsize      =3D sizeof(struct xt_connmark_mtinfo1),
+		.destroy        =3D connmark_mt_destroy,
+		.me             =3D THIS_MODULE,
+	},
 };
=20
 static int __init connmark_mt_init(void)
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
