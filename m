From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 6/7] xt_connmark rev 1
Date: Fri, 7 Dec 2007 03:42:24 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0712070341520.1262@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0712070335240.1262@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:39543 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674AbXLGCmZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 6 Dec 2007 21:42:25 -0500
In-Reply-To: <Pine.LNX.4.64.0712070335240.1262@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Introduce the xt_connmark match revision 1. It uses fixed types,
with the goal of obsoleting revision 0 some day (uses nonfixed types).

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 include/linux/netfilter/xt_connmark.h |    5 ++
 net/netfilter/xt_connmark.c           |   74 ++++++++++++++++++++++++++++------
 2 files changed, 68 insertions(+), 11 deletions(-)

Index: linux-2.6/include/linux/netfilter/xt_connmark.h
===================================================================
--- linux-2.6.orig/include/linux/netfilter/xt_connmark.h
+++ linux-2.6/include/linux/netfilter/xt_connmark.h
@@ -15,4 +15,9 @@ struct xt_connmark_info {
 	u_int8_t invert;
 };
 
+struct xt_connmark_match_info {
+	u_int32_t mark, mask;
+	u_int8_t invert;
+};
+
 #endif /*_XT_CONNMARK_H*/
Index: linux-2.6/net/netfilter/xt_connmark.c
===================================================================
--- linux-2.6.orig/net/netfilter/xt_connmark.c
+++ linux-2.6/net/netfilter/xt_connmark.c
@@ -37,6 +37,23 @@ connmark_mt(const struct sk_buff *skb, c
             const void *matchinfo, int offset, unsigned int protoff,
             bool *hotdrop)
 {
+	const struct xt_connmark_match_info *info = matchinfo;
+	enum ip_conntrack_info ctinfo;
+	const struct nf_conn *ct;
+
+	ct = nf_ct_get(skb, &ctinfo);
+	if (ct == NULL)
+		return false;
+
+	return ((ct->mark & info->mask) == info->mark) ^ info->invert;
+}
+
+static bool
+connmark_mt_v0(const struct sk_buff *skb, const struct net_device *in,
+               const struct net_device *out, const struct xt_match *match,
+               const void *matchinfo, int offset, unsigned int protoff,
+               bool *hotdrop)
+{
 	const struct xt_connmark_info *info = matchinfo;
 	const struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
@@ -49,9 +66,9 @@ connmark_mt(const struct sk_buff *skb, c
 }
 
 static bool
-connmark_mt_check(const char *tablename, const void *ip,
-                  const struct xt_match *match, void *matchinfo,
-                  unsigned int hook_mask)
+connmark_mt_check_v0(const char *tablename, const void *ip,
+                     const struct xt_match *match, void *matchinfo,
+                     unsigned int hook_mask)
 {
 	const struct xt_connmark_info *cm = matchinfo;
 
@@ -67,6 +84,19 @@ connmark_mt_check(const char *tablename,
 	return true;
 }
 
+static bool
+connmark_mt_check(const char *tablename, const void *ip,
+                  const struct xt_match *match, void *matchinfo,
+                  unsigned int hook_mask)
+{
+	if (nf_ct_l3proto_try_module_get(match->family) < 0) {
+		printk(KERN_WARNING "cannot load conntrack support for "
+		       "proto=%u\n", match->family);
+		return false;
+	}
+	return true;
+}
+
 static void
 connmark_mt_destroy(const struct xt_match *match, void *matchinfo)
 {
@@ -81,7 +111,7 @@ struct compat_xt_connmark_info {
 	u_int16_t	__pad2;
 };
 
-static void connmark_mt_compat_from_user(void *dst, void *src)
+static void connmark_mt_compat_from_user_v0(void *dst, void *src)
 {
 	const struct compat_xt_connmark_info *cm = src;
 	struct xt_connmark_info m = {
@@ -92,7 +122,7 @@ static void connmark_mt_compat_from_user
 	memcpy(dst, &m, sizeof(m));
 }
 
-static int connmark_mt_compat_to_user(void __user *dst, void *src)
+static int connmark_mt_compat_to_user_v0(void __user *dst, void *src)
 {
 	const struct xt_connmark_info *m = src;
 	struct compat_xt_connmark_info cm = {
@@ -107,27 +137,49 @@ static int connmark_mt_compat_to_user(vo
 static struct xt_match connmark_mt_reg[] __read_mostly = {
 	{
 		.name		= "connmark",
+		.revision	= 0,
 		.family		= AF_INET,
-		.checkentry	= connmark_mt_check,
-		.match		= connmark_mt,
+		.checkentry	= connmark_mt_check_v0,
+		.match		= connmark_mt_v0,
 		.destroy	= connmark_mt_destroy,
 		.matchsize	= sizeof(struct xt_connmark_info),
 #ifdef CONFIG_COMPAT
 		.compatsize	= sizeof(struct compat_xt_connmark_info),
-		.compat_from_user = connmark_mt_compat_from_user,
-		.compat_to_user	= connmark_mt_compat_to_user,
+		.compat_from_user = connmark_mt_compat_from_user_v0,
+		.compat_to_user	= connmark_mt_compat_to_user_v0,
 #endif
 		.me		= THIS_MODULE
 	},
 	{
 		.name		= "connmark",
+		.revision	= 0,
 		.family		= AF_INET6,
-		.checkentry	= connmark_mt_check,
-		.match		= connmark_mt,
+		.checkentry	= connmark_mt_check_v0,
+		.match		= connmark_mt_v0,
 		.destroy	= connmark_mt_destroy,
 		.matchsize	= sizeof(struct xt_connmark_info),
 		.me		= THIS_MODULE
 	},
+	{
+		.name       = "connmark",
+		.revision   = 1,
+		.family     = AF_INET,
+		.checkentry = connmark_mt_check,
+		.match      = connmark_mt,
+		.matchsize  = sizeof(struct xt_connmark_match_info),
+		.destroy    = connmark_mt_destroy,
+		.me         = THIS_MODULE,
+	},
+	{
+		.name       = "connmark",
+		.revision   = 1,
+		.family     = AF_INET6,
+		.checkentry = connmark_mt_check,
+		.match      = connmark_mt,
+		.matchsize  = sizeof(struct xt_connmark_match_info),
+		.destroy    = connmark_mt_destroy,
+		.me         = THIS_MODULE,
+	},
 };
 
 static int __init connmark_mt_init(void)
