From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 1/4] [NETFILTER]: xt_CONNMARK target revision 1
Date: Sat, 22 Dec 2007 03:37:31 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0712220337200.8607@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0712220335520.8607@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:58638 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbXLVChd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Dec 2007 21:37:33 -0500
In-Reply-To: <Pine.LNX.4.64.0712220335520.8607@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Introduce the xt_CONNMARK target revision 1. It uses fixed types, and
also uses the more expressive XOR logic. Futhermore, it allows to
selectively pick bits from both the ctmark and the nfmark in the SAVE
and RESTORE operations.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 include/linux/netfilter/xt_CONNMARK.h |    5 +
 net/netfilter/xt_CONNMARK.c           |  107 ++++++++++++++++++++++++++++------
 2 files changed, 96 insertions(+), 16 deletions(-)

Index: linux-2.6_nosov/include/linux/netfilter/xt_CONNMARK.h
===================================================================
--- linux-2.6_nosov.orig/include/linux/netfilter/xt_CONNMARK.h
+++ linux-2.6_nosov/include/linux/netfilter/xt_CONNMARK.h
@@ -22,4 +22,9 @@ struct xt_connmark_target_info {
 	u_int8_t mode;
 };
 
+struct xt_connmark_target_info_v1 {
+	u_int32_t ctmark, ctmask, nfmask;
+	u_int8_t mode;
+};
+
 #endif /*_XT_CONNMARK_H_target*/
Index: linux-2.6_nosov/net/netfilter/xt_CONNMARK.c
===================================================================
--- linux-2.6_nosov.orig/net/netfilter/xt_CONNMARK.c
+++ linux-2.6_nosov/net/netfilter/xt_CONNMARK.c
@@ -34,9 +34,9 @@ MODULE_ALIAS("ip6t_CONNMARK");
 #include <net/netfilter/nf_conntrack_ecache.h>
 
 static unsigned int
-connmark_tg(struct sk_buff *skb, const struct net_device *in,
-            const struct net_device *out, unsigned int hooknum,
-            const struct xt_target *target, const void *targinfo)
+connmark_tg_v0(struct sk_buff *skb, const struct net_device *in,
+               const struct net_device *out, unsigned int hooknum,
+               const struct xt_target *target, const void *targinfo)
 {
 	const struct xt_connmark_target_info *markinfo = targinfo;
 	struct nf_conn *ct;
@@ -74,10 +74,50 @@ connmark_tg(struct sk_buff *skb, const s
 	return XT_CONTINUE;
 }
 
+static unsigned int
+connmark_tg(struct sk_buff *skb, const struct net_device *in,
+            const struct net_device *out, unsigned int hooknum,
+            const struct xt_target *target, const void *targinfo)
+{
+	const struct xt_connmark_target_info_v1 *info = targinfo;
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn *ct;
+	u_int32_t newmark;
+
+	ct = nf_ct_get(skb, &ctinfo);
+	if (ct == NULL)
+		return XT_CONTINUE;
+
+	switch (info->mode) {
+		case XT_CONNMARK_SET:
+			newmark = (ct->mark & ~info->ctmask) ^ info->ctmark;
+			if (ct->mark != newmark) {
+				ct->mark = newmark;
+				nf_conntrack_event_cache(IPCT_MARK, skb);
+			}
+			break;
+		case XT_CONNMARK_SAVE:
+			newmark = (ct->mark & ~info->ctmask) ^
+			          (skb->mark & info->nfmask);
+			if (ct->mark != newmark) {
+				ct->mark = newmark;
+				nf_conntrack_event_cache(IPCT_MARK, skb);
+			}
+			break;
+		case XT_CONNMARK_RESTORE:
+			newmark = (skb->mark & ~info->nfmask) ^
+			          (ct->mark & info->ctmask);
+			skb->mark = newmark;
+			break;
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
 	const struct xt_connmark_target_info *matchinfo = targinfo;
 
@@ -101,6 +141,19 @@ connmark_tg_check(const char *tablename,
 	return true;
 }
 
+static bool
+connmark_tg_check(const char *tablename, const void *entry,
+                  const struct xt_target *target, void *targinfo,
+                  unsigned int hook_mask)
+{
+	if (nf_ct_l3proto_try_module_get(target->family) < 0) {
+		printk(KERN_WARNING "cannot load conntrack support for "
+		       "proto=%u\n", target->family);
+		return false;
+	}
+	return true;
+}
+
 static void
 connmark_tg_destroy(const struct xt_target *target, void *targinfo)
 {
@@ -115,7 +168,7 @@ struct compat_xt_connmark_target_info {
 	u_int16_t	__pad2;
 };
 
-static void connmark_tg_compat_from_user(void *dst, void *src)
+static void connmark_tg_compat_from_user_v0(void *dst, void *src)
 {
 	const struct compat_xt_connmark_target_info *cm = src;
 	struct xt_connmark_target_info m = {
@@ -126,7 +179,7 @@ static void connmark_tg_compat_from_user
 	memcpy(dst, &m, sizeof(m));
 }
 
-static int connmark_tg_compat_to_user(void __user *dst, void *src)
+static int connmark_tg_compat_to_user_v0(void __user *dst, void *src)
 {
 	const struct xt_connmark_target_info *m = src;
 	struct compat_xt_connmark_target_info cm = {
@@ -141,32 +194,54 @@ static int connmark_tg_compat_to_user(vo
 static struct xt_target connmark_tg_reg[] __read_mostly = {
 	{
 		.name		= "CONNMARK",
+		.revision	= 0,
 		.family		= AF_INET,
-		.checkentry	= connmark_tg_check,
+		.checkentry	= connmark_tg_check_v0,
 		.destroy	= connmark_tg_destroy,
-		.target		= connmark_tg,
+		.target		= connmark_tg_v0,
 		.targetsize	= sizeof(struct xt_connmark_target_info),
 #ifdef CONFIG_COMPAT
 		.compatsize	= sizeof(struct compat_xt_connmark_target_info),
-		.compat_from_user = connmark_tg_compat_from_user,
-		.compat_to_user	= connmark_tg_compat_to_user,
+		.compat_from_user = connmark_tg_compat_from_user_v0,
+		.compat_to_user	= connmark_tg_compat_to_user_v0,
 #endif
 		.me		= THIS_MODULE
 	},
 	{
 		.name		= "CONNMARK",
+		.revision	= 0,
 		.family		= AF_INET6,
-		.checkentry	= connmark_tg_check,
+		.checkentry	= connmark_tg_check_v0,
 		.destroy	= connmark_tg_destroy,
-		.target		= connmark_tg,
+		.target		= connmark_tg_v0,
 		.targetsize	= sizeof(struct xt_connmark_target_info),
 #ifdef CONFIG_COMPAT
 		.compatsize	= sizeof(struct compat_xt_connmark_target_info),
-		.compat_from_user = connmark_tg_compat_from_user,
-		.compat_to_user	= connmark_tg_compat_to_user,
+		.compat_from_user = connmark_tg_compat_from_user_v0,
+		.compat_to_user	= connmark_tg_compat_to_user_v0,
 #endif
 		.me		= THIS_MODULE
 	},
+	{
+		.name           = "CONNMARK",
+		.revision       = 1,
+		.family         = AF_INET,
+		.checkentry     = connmark_tg_check,
+		.target         = connmark_tg,
+		.targetsize     = sizeof(struct xt_connmark_target_info_v1),
+		.destroy        = connmark_tg_destroy,
+		.me             = THIS_MODULE,
+	},
+	{
+		.name           = "CONNMARK",
+		.revision       = 1,
+		.family         = AF_INET6,
+		.checkentry     = connmark_tg_check,
+		.target         = connmark_tg,
+		.targetsize     = sizeof(struct xt_connmark_target_info_v1),
+		.destroy        = connmark_tg_destroy,
+		.me             = THIS_MODULE,
+	},
 };
 
 static int __init connmark_tg_init(void)
