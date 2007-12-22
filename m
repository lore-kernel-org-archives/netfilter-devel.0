From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 2/4] [NETFILTER]: xt_MARK target revision 2
Date: Sat, 22 Dec 2007 03:37:00 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0712220336370.8607@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0712220335520.8607@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:58632 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbXLVChB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Dec 2007 21:37:01 -0500
In-Reply-To: <Pine.LNX.4.64.0712220335520.8607@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Introduce the xt_MARK target revision 2. It uses fixed types,
and also uses the more expressive XOR logic.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 include/linux/netfilter/xt_MARK.h |    4 ++
 net/netfilter/xt_MARK.c           |   59 +++++++++++++++++++++++++++-----------
 2 files changed, 47 insertions(+), 16 deletions(-)

Index: linux-2.6_nosov/include/linux/netfilter/xt_MARK.h
===================================================================
--- linux-2.6_nosov.orig/include/linux/netfilter/xt_MARK.h
+++ linux-2.6_nosov/include/linux/netfilter/xt_MARK.h
@@ -18,4 +18,8 @@ struct xt_mark_target_info_v1 {
 	u_int8_t mode;
 };
 
+struct xt_mark_target_info_v2 {
+	u_int32_t mark, mask;
+};
+
 #endif /*_XT_MARK_H_target */
Index: linux-2.6_nosov/net/netfilter/xt_MARK.c
===================================================================
--- linux-2.6_nosov.orig/net/netfilter/xt_MARK.c
+++ linux-2.6_nosov/net/netfilter/xt_MARK.c
@@ -33,9 +33,9 @@ mark_tg_v0(struct sk_buff *skb, const st
 }
 
 static unsigned int
-mark_tg(struct sk_buff *skb, const struct net_device *in,
-        const struct net_device *out, unsigned int hooknum,
-        const struct xt_target *target, const void *targinfo)
+mark_tg_v1(struct sk_buff *skb, const struct net_device *in,
+           const struct net_device *out, unsigned int hooknum,
+           const struct xt_target *target, const void *targinfo)
 {
 	const struct xt_mark_target_info_v1 *markinfo = targinfo;
 	int mark = 0;
@@ -58,6 +58,17 @@ mark_tg(struct sk_buff *skb, const struc
 	return XT_CONTINUE;
 }
 
+static unsigned int
+mark_tg(struct sk_buff *skb, const struct net_device *in,
+        const struct net_device *out, unsigned int hooknum,
+        const struct xt_target *target, const void *targinfo)
+{
+	const struct xt_mark_target_info_v2 *info = targinfo;
+
+	skb->mark = (skb->mark & ~info->mask) ^ info->mark;
+	return XT_CONTINUE;
+}
+
 static bool
 mark_tg_check_v0(const char *tablename, const void *entry,
                  const struct xt_target *target, void *targinfo,
@@ -73,9 +84,9 @@ mark_tg_check_v0(const char *tablename, 
 }
 
 static bool
-mark_tg_check(const char *tablename, const void *entry,
-              const struct xt_target *target, void *targinfo,
-              unsigned int hook_mask)
+mark_tg_check_v1(const char *tablename, const void *entry,
+                 const struct xt_target *target, void *targinfo,
+                 unsigned int hook_mask)
 {
 	const struct xt_mark_target_info_v1 *markinfo = targinfo;
 
@@ -98,7 +109,7 @@ struct compat_xt_mark_target_info {
 	compat_ulong_t	mark;
 };
 
-static void mark_tg_compat_from_user(void *dst, void *src)
+static void mark_tg_compat_from_user_v0(void *dst, void *src)
 {
 	const struct compat_xt_mark_target_info *cm = src;
 	struct xt_mark_target_info m = {
@@ -107,7 +118,7 @@ static void mark_tg_compat_from_user(voi
 	memcpy(dst, &m, sizeof(m));
 }
 
-static int mark_tg_compat_to_user(void __user *dst, void *src)
+static int mark_tg_compat_to_user_v0(void __user *dst, void *src)
 {
 	const struct xt_mark_target_info *m = src;
 	struct compat_xt_mark_target_info cm = {
@@ -154,8 +165,8 @@ static struct xt_target mark_tg_reg[] __
 		.targetsize	= sizeof(struct xt_mark_target_info),
 #ifdef CONFIG_COMPAT
 		.compatsize	= sizeof(struct compat_xt_mark_target_info),
-		.compat_from_user = mark_tg_compat_from_user,
-		.compat_to_user	= mark_tg_compat_to_user,
+		.compat_from_user = mark_tg_compat_from_user_v0,
+		.compat_to_user	= mark_tg_compat_to_user_v0,
 #endif
 		.table		= "mangle",
 		.me		= THIS_MODULE,
@@ -164,8 +175,8 @@ static struct xt_target mark_tg_reg[] __
 		.name		= "MARK",
 		.family		= AF_INET,
 		.revision	= 1,
-		.checkentry	= mark_tg_check,
-		.target		= mark_tg,
+		.checkentry	= mark_tg_check_v1,
+		.target		= mark_tg_v1,
 		.targetsize	= sizeof(struct xt_mark_target_info_v1),
 #ifdef CONFIG_COMPAT
 		.compatsize	= sizeof(struct compat_xt_mark_target_info_v1),
@@ -184,8 +195,8 @@ static struct xt_target mark_tg_reg[] __
 		.targetsize	= sizeof(struct xt_mark_target_info),
 #ifdef CONFIG_COMPAT
 		.compatsize	= sizeof(struct compat_xt_mark_target_info),
-		.compat_from_user = mark_tg_compat_from_user,
-		.compat_to_user	= mark_tg_compat_to_user,
+		.compat_from_user = mark_tg_compat_from_user_v0,
+		.compat_to_user	= mark_tg_compat_to_user_v0,
 #endif
 		.table		= "mangle",
 		.me		= THIS_MODULE,
@@ -194,8 +205,8 @@ static struct xt_target mark_tg_reg[] __
 		.name		= "MARK",
 		.family		= AF_INET6,
 		.revision	= 1,
-		.checkentry	= mark_tg_check,
-		.target		= mark_tg,
+		.checkentry	= mark_tg_check_v1,
+		.target		= mark_tg_v1,
 		.targetsize	= sizeof(struct xt_mark_target_info_v1),
 #ifdef CONFIG_COMPAT
 		.compatsize	= sizeof(struct compat_xt_mark_target_info_v1),
@@ -205,6 +216,22 @@ static struct xt_target mark_tg_reg[] __
 		.table		= "mangle",
 		.me		= THIS_MODULE,
 	},
+	{
+		.name           = "MARK",
+		.revision       = 2,
+		.family         = AF_INET,
+		.target         = mark_tg,
+		.targetsize     = sizeof(struct xt_mark_target_info_v2),
+		.me             = THIS_MODULE,
+	},
+	{
+		.name           = "MARK",
+		.revision       = 2,
+		.family         = AF_INET6,
+		.target         = mark_tg,
+		.targetsize     = sizeof(struct xt_mark_target_info_v2),
+		.me             = THIS_MODULE,
+	},
 };
 
 static int __init mark_tg_init(void)
