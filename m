From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 002/103] netfilter: xtables: remove xt_CONNMARK v0
Date: Tue,  4 Aug 2009 09:24:46 +0200
Message-ID: <1249370787-17583-3-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50615 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932515AbZHDH0g (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:26:36 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Superseded by xt_CONNMARK v1 (v2.6.24-2917-g0dc8c76).

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Documentation/feature-removal-schedule.txt |    3 -
 include/linux/netfilter/xt_CONNMARK.h      |    6 --
 net/netfilter/xt_CONNMARK.c                |  134 +++-------------------------
 3 files changed, 11 insertions(+), 132 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 3aa4a77..7eccf94 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -238,9 +238,6 @@ What (Why):
 	- "forwarding" header files like ipt_mac.h in
 	  include/linux/netfilter_ipv4/ and include/linux/netfilter_ipv6/
 
-	- xt_CONNMARK match revision 0
-	  (superseded by xt_CONNMARK match revision 1)
-
 	- xt_MARK target revisions 0 and 1
 	  (superseded by xt_MARK match revision 2)
 
diff --git a/include/linux/netfilter/xt_CONNMARK.h b/include/linux/netfilter/xt_CONNMARK.h
index 7635c8f..0a85458 100644
--- a/include/linux/netfilter/xt_CONNMARK.h
+++ b/include/linux/netfilter/xt_CONNMARK.h
@@ -18,12 +18,6 @@ enum {
 	XT_CONNMARK_RESTORE
 };
 
-struct xt_connmark_target_info {
-	unsigned long mark;
-	unsigned long mask;
-	__u8 mode;
-};
-
 struct xt_connmark_tginfo1 {
 	__u32 ctmark, ctmask, nfmask;
 	__u8 mode;
diff --git a/net/netfilter/xt_CONNMARK.c b/net/netfilter/xt_CONNMARK.c
index d6e5ab4..5934570 100644
--- a/net/netfilter/xt_CONNMARK.c
+++ b/net/netfilter/xt_CONNMARK.c
@@ -36,45 +36,6 @@ MODULE_ALIAS("ip6t_CONNMARK");
 #include <net/netfilter/nf_conntrack_ecache.h>
 
 static unsigned int
-connmark_tg_v0(struct sk_buff *skb, const struct xt_target_param *par)
-{
-	const struct xt_connmark_target_info *markinfo = par->targinfo;
-	struct nf_conn *ct;
-	enum ip_conntrack_info ctinfo;
-	u_int32_t diff;
-	u_int32_t mark;
-	u_int32_t newmark;
-
-	ct = nf_ct_get(skb, &ctinfo);
-	if (ct) {
-		switch(markinfo->mode) {
-		case XT_CONNMARK_SET:
-			newmark = (ct->mark & ~markinfo->mask) | markinfo->mark;
-			if (newmark != ct->mark) {
-				ct->mark = newmark;
-				nf_conntrack_event_cache(IPCT_MARK, ct);
-			}
-			break;
-		case XT_CONNMARK_SAVE:
-			newmark = (ct->mark & ~markinfo->mask) |
-				  (skb->mark & markinfo->mask);
-			if (ct->mark != newmark) {
-				ct->mark = newmark;
-				nf_conntrack_event_cache(IPCT_MARK, ct);
-			}
-			break;
-		case XT_CONNMARK_RESTORE:
-			mark = skb->mark;
-			diff = (ct->mark ^ mark) & markinfo->mask;
-			skb->mark = mark ^ diff;
-			break;
-		}
-	}
-
-	return XT_CONTINUE;
-}
-
-static unsigned int
 connmark_tg(struct sk_buff *skb, const struct xt_target_param *par)
 {
 	const struct xt_connmark_tginfo1 *info = par->targinfo;
@@ -112,30 +73,6 @@ connmark_tg(struct sk_buff *skb, const struct xt_target_param *par)
 	return XT_CONTINUE;
 }
 
-static bool connmark_tg_check_v0(const struct xt_tgchk_param *par)
-{
-	const struct xt_connmark_target_info *matchinfo = par->targinfo;
-
-	if (matchinfo->mode == XT_CONNMARK_RESTORE) {
-		if (strcmp(par->table, "mangle") != 0) {
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
-				    "proto=%u\n", par->family);
-		return false;
-	}
-	return true;
-}
-
 static bool connmark_tg_check(const struct xt_tgchk_param *par)
 {
 	if (nf_ct_l3proto_try_module_get(par->family) < 0) {
@@ -151,74 +88,25 @@ static void connmark_tg_destroy(const struct xt_tgdtor_param *par)
 	nf_ct_l3proto_module_put(par->family);
 }
 
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
-	const struct compat_xt_connmark_target_info *cm = src;
-	struct xt_connmark_target_info m = {
-		.mark	= cm->mark,
-		.mask	= cm->mask,
-		.mode	= cm->mode,
-	};
-	memcpy(dst, &m, sizeof(m));
-}
-
-static int connmark_tg_compat_to_user_v0(void __user *dst, void *src)
-{
-	const struct xt_connmark_target_info *m = src;
-	struct compat_xt_connmark_target_info cm = {
-		.mark	= m->mark,
-		.mask	= m->mask,
-		.mode	= m->mode,
-	};
-	return copy_to_user(dst, &cm, sizeof(cm)) ? -EFAULT : 0;
-}
-#endif /* CONFIG_COMPAT */
-
-static struct xt_target connmark_tg_reg[] __read_mostly = {
-	{
-		.name		= "CONNMARK",
-		.revision	= 0,
-		.family		= NFPROTO_UNSPEC,
-		.checkentry	= connmark_tg_check_v0,
-		.destroy	= connmark_tg_destroy,
-		.target		= connmark_tg_v0,
-		.targetsize	= sizeof(struct xt_connmark_target_info),
-#ifdef CONFIG_COMPAT
-		.compatsize	= sizeof(struct compat_xt_connmark_target_info),
-		.compat_from_user = connmark_tg_compat_from_user_v0,
-		.compat_to_user	= connmark_tg_compat_to_user_v0,
-#endif
-		.me		= THIS_MODULE
-	},
-	{
-		.name           = "CONNMARK",
-		.revision       = 1,
-		.family         = NFPROTO_UNSPEC,
-		.checkentry     = connmark_tg_check,
-		.target         = connmark_tg,
-		.targetsize     = sizeof(struct xt_connmark_tginfo1),
-		.destroy        = connmark_tg_destroy,
-		.me             = THIS_MODULE,
-	},
+static struct xt_target connmark_tg_reg __read_mostly = {
+	.name           = "CONNMARK",
+	.revision       = 1,
+	.family         = NFPROTO_UNSPEC,
+	.checkentry     = connmark_tg_check,
+	.target         = connmark_tg,
+	.targetsize     = sizeof(struct xt_connmark_tginfo1),
+	.destroy        = connmark_tg_destroy,
+	.me             = THIS_MODULE,
 };
 
 static int __init connmark_tg_init(void)
 {
-	return xt_register_targets(connmark_tg_reg,
-	       ARRAY_SIZE(connmark_tg_reg));
+	return xt_register_target(&connmark_tg_reg);
 }
 
 static void __exit connmark_tg_exit(void)
 {
-	xt_unregister_targets(connmark_tg_reg, ARRAY_SIZE(connmark_tg_reg));
+	xt_unregister_target(&connmark_tg_reg);
 }
 
 module_init(connmark_tg_init);
-- 
1.6.3.3

