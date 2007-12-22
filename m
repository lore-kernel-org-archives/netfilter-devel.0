From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 1/4] [NETFILTER]: xt_mark rev. 1
Date: Sat, 22 Dec 2007 03:36:35 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0712220335520.8607@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:58627 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbXLVCgg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Dec 2007 21:36:36 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Introduce the xt_mark match revision 1. It uses fixed types,
eventually obsoleting revision 0 some day (uses nonfixed types).

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 Documentation/feature-removal-schedule.txt |    5 ++
 include/linux/netfilter/xt_mark.h          |    5 ++
 net/netfilter/xt_mark.c                    |   49 +++++++++++++++++++++++------
 3 files changed, 49 insertions(+), 10 deletions(-)

Index: linux-2.6/include/linux/netfilter/xt_mark.h
===================================================================
--- linux-2.6.orig/include/linux/netfilter/xt_mark.h
+++ linux-2.6/include/linux/netfilter/xt_mark.h
@@ -6,4 +6,9 @@ struct xt_mark_info {
     u_int8_t invert;
 };
 
+struct xt_mark_match_info {
+	u_int32_t mark, mask;
+	u_int8_t invert;
+};
+
 #endif /*_XT_MARK_H*/
Index: linux-2.6/net/netfilter/xt_mark.c
===================================================================
--- linux-2.6.orig/net/netfilter/xt_mark.c
+++ linux-2.6/net/netfilter/xt_mark.c
@@ -20,19 +20,30 @@ MODULE_ALIAS("ipt_mark");
 MODULE_ALIAS("ip6t_mark");
 
 static bool
+mark_mt_v0(const struct sk_buff *skb, const struct net_device *in,
+           const struct net_device *out, const struct xt_match *match,
+           const void *matchinfo, int offset, unsigned int protoff,
+           bool *hotdrop)
+{
+	const struct xt_mark_info *info = matchinfo;
+
+	return ((skb->mark & info->mask) == info->mark) ^ info->invert;
+}
+
+static bool
 mark_mt(const struct sk_buff *skb, const struct net_device *in,
         const struct net_device *out, const struct xt_match *match,
         const void *matchinfo, int offset, unsigned int protoff, bool *hotdrop)
 {
-	const struct xt_mark_info *info = matchinfo;
+	const struct xt_mark_match_info *info = matchinfo;
 
 	return ((skb->mark & info->mask) == info->mark) ^ info->invert;
 }
 
 static bool
-mark_mt_check(const char *tablename, const void *entry,
-              const struct xt_match *match, void *matchinfo,
-              unsigned int hook_mask)
+mark_mt_check_v0(const char *tablename, const void *entry,
+                 const struct xt_match *match, void *matchinfo,
+                 unsigned int hook_mask)
 {
 	const struct xt_mark_info *minfo = matchinfo;
 
@@ -51,7 +62,7 @@ struct compat_xt_mark_info {
 	u_int16_t	__pad2;
 };
 
-static void mark_mt_compat_from_user(void *dst, void *src)
+static void mark_mt_compat_from_user_v0(void *dst, void *src)
 {
 	const struct compat_xt_mark_info *cm = src;
 	struct xt_mark_info m = {
@@ -62,7 +73,7 @@ static void mark_mt_compat_from_user(voi
 	memcpy(dst, &m, sizeof(m));
 }
 
-static int mark_mt_compat_to_user(void __user *dst, void *src)
+static int mark_mt_compat_to_user_v0(void __user *dst, void *src)
 {
 	const struct xt_mark_info *m = src;
 	struct compat_xt_mark_info cm = {
@@ -77,9 +88,10 @@ static int mark_mt_compat_to_user(void _
 static struct xt_match mark_mt_reg[] __read_mostly = {
 	{
 		.name		= "mark",
+		.revision	= 0,
 		.family		= AF_INET,
-		.checkentry	= mark_mt_check,
-		.match		= mark_mt,
+		.checkentry	= mark_mt_check_v0,
+		.match		= mark_mt_v0,
 		.matchsize	= sizeof(struct xt_mark_info),
 #ifdef CONFIG_COMPAT
 		.compatsize	= sizeof(struct compat_xt_mark_info),
@@ -90,9 +102,10 @@ static struct xt_match mark_mt_reg[] __r
 	},
 	{
 		.name		= "mark",
+		.revision	= 0,
 		.family		= AF_INET6,
-		.checkentry	= mark_mt_check,
-		.match		= mark_mt,
+		.checkentry	= mark_mt_check_v0,
+		.match		= mark_mt_v0,
 		.matchsize	= sizeof(struct xt_mark_info),
 #ifdef CONFIG_COMPAT
 		.compatsize	= sizeof(struct compat_xt_mark_info),
@@ -101,6 +114,22 @@ static struct xt_match mark_mt_reg[] __r
 #endif
 		.me		= THIS_MODULE,
 	},
+	{
+		.name           = "mark",
+		.revision       = 1,
+		.family         = AF_INET,
+		.match          = mark_mt,
+		.matchsize      = sizeof(struct xt_mark_match_info),
+		.me             = THIS_MODULE,
+	},
+	{
+		.name           = "mark",
+		.revision       = 1,
+		.family         = AF_INET6,
+		.match          = mark_mt,
+		.matchsize      = sizeof(struct xt_mark_match_info),
+		.me             = THIS_MODULE,
+	},
 };
 
 static int __init mark_mt_init(void)

