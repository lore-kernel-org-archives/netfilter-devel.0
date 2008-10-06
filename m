From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 21/23] netfilter: xtables: cut down on static data for family-independent extensions
Date: Mon,  6 Oct 2008 08:15:24 -0400
Message-ID: <5f5447e4a742a69c6222caced36ba693b4c335df.1223294924.git.jengelh@medozas.de>
References: <1223295326-10890-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:57105 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076AbYJFMPd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Oct 2008 08:15:33 -0400
In-Reply-To: <1223295326-10890-1-git-send-email-jengelh@medozas.de>
In-Reply-To: <0a71cdb22ae4ae9ad9c49cab82cc41ccdd5653a1.1223294924.git.jengelh@medozas.de>
References: <0a71cdb22ae4ae9ad9c49cab82cc41ccdd5653a1.1223294924.git.jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Using ->family in struct xt_*_param, multiple struct xt_{match,target}
can be squashed together.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/netfilter/xt_CONNMARK.c    |   39 ++++++---------------------------
 net/netfilter/xt_CONNSECMARK.c |   40 ++++++++++++----------------------
 net/netfilter/xt_NFLOG.c       |   31 +++++++++-----------------
 net/netfilter/xt_connbytes.c   |   39 ++++++++++++---------------------
 net/netfilter/xt_connlimit.c   |   47 +++++++++++++++------------------------
 net/netfilter/xt_connmark.c    |   39 ++++++---------------------------
 net/netfilter/xt_conntrack.c   |   26 ++++++---------------
 net/netfilter/xt_helper.c      |   38 ++++++++++++--------------------
 net/netfilter/xt_pkttype.c     |   30 +++++++++----------------
 9 files changed, 104 insertions(+), 225 deletions(-)

diff --git a/net/netfilter/xt_CONNMARK.c b/net/netfilter/xt_CONNMARK.c
index c5a5072..d6e5ab4 100644
--- a/net/netfilter/xt_CONNMARK.c
+++ b/net/netfilter/xt_CONNMARK.c
@@ -128,9 +128,9 @@ static bool connmark_tg_check_v0(const struct xt_tgchk_param *par)
 		printk(KERN_WARNING "CONNMARK: Only supports 32bit mark\n");
 		return false;
 	}
-	if (nf_ct_l3proto_try_module_get(par->target->family) < 0) {
+	if (nf_ct_l3proto_try_module_get(par->family) < 0) {
 		printk(KERN_WARNING "can't load conntrack support for "
-				    "proto=%u\n", par->target->family);
+				    "proto=%u\n", par->family);
 		return false;
 	}
 	return true;
@@ -138,9 +138,9 @@ static bool connmark_tg_check_v0(const struct xt_tgchk_param *par)
 
 static bool connmark_tg_check(const struct xt_tgchk_param *par)
 {
-	if (nf_ct_l3proto_try_module_get(par->target->family) < 0) {
+	if (nf_ct_l3proto_try_module_get(par->family) < 0) {
 		printk(KERN_WARNING "cannot load conntrack support for "
-		       "proto=%u\n", par->target->family);
+		       "proto=%u\n", par->family);
 		return false;
 	}
 	return true;
@@ -148,7 +148,7 @@ static bool connmark_tg_check(const struct xt_tgchk_param *par)
 
 static void connmark_tg_destroy(const struct xt_tgdtor_param *par)
 {
-	nf_ct_l3proto_module_put(par->target->family);
+	nf_ct_l3proto_module_put(par->family);
 }
 
 #ifdef CONFIG_COMPAT
@@ -186,7 +186,7 @@ static struct xt_target connmark_tg_reg[] __read_mostly = {
 	{
 		.name		= "CONNMARK",
 		.revision	= 0,
-		.family		= NFPROTO_IPV4,
+		.family		= NFPROTO_UNSPEC,
 		.checkentry	= connmark_tg_check_v0,
 		.destroy	= connmark_tg_destroy,
 		.target		= connmark_tg_v0,
@@ -199,34 +199,9 @@ static struct xt_target connmark_tg_reg[] __read_mostly = {
 		.me		= THIS_MODULE
 	},
 	{
-		.name		= "CONNMARK",
-		.revision	= 0,
-		.family		= NFPROTO_IPV6,
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
-		.family         = NFPROTO_IPV4,
-		.checkentry     = connmark_tg_check,
-		.target         = connmark_tg,
-		.targetsize     = sizeof(struct xt_connmark_tginfo1),
-		.destroy        = connmark_tg_destroy,
-		.me             = THIS_MODULE,
-	},
-	{
 		.name           = "CONNMARK",
 		.revision       = 1,
-		.family         = NFPROTO_IPV6,
+		.family         = NFPROTO_UNSPEC,
 		.checkentry     = connmark_tg_check,
 		.target         = connmark_tg,
 		.targetsize     = sizeof(struct xt_connmark_tginfo1),
diff --git a/net/netfilter/xt_CONNSECMARK.c b/net/netfilter/xt_CONNSECMARK.c
index b6e3f3f..b54c375 100644
--- a/net/netfilter/xt_CONNSECMARK.c
+++ b/net/netfilter/xt_CONNSECMARK.c
@@ -106,9 +106,9 @@ static bool connsecmark_tg_check(const struct xt_tgchk_param *par)
 		return false;
 	}
 
-	if (nf_ct_l3proto_try_module_get(par->target->family) < 0) {
+	if (nf_ct_l3proto_try_module_get(par->family) < 0) {
 		printk(KERN_WARNING "can't load conntrack support for "
-				    "proto=%u\n", par->target->family);
+				    "proto=%u\n", par->family);
 		return false;
 	}
 	return true;
@@ -116,40 +116,28 @@ static bool connsecmark_tg_check(const struct xt_tgchk_param *par)
 
 static void connsecmark_tg_destroy(const struct xt_tgdtor_param *par)
 {
-	nf_ct_l3proto_module_put(par->target->family);
+	nf_ct_l3proto_module_put(par->family);
 }
 
-static struct xt_target connsecmark_tg_reg[] __read_mostly = {
-	{
-		.name		= "CONNSECMARK",
-		.family		= NFPROTO_IPV4,
-		.checkentry	= connsecmark_tg_check,
-		.destroy	= connsecmark_tg_destroy,
-		.target		= connsecmark_tg,
-		.targetsize	= sizeof(struct xt_connsecmark_target_info),
-		.me		= THIS_MODULE,
-	},
-	{
-		.name		= "CONNSECMARK",
-		.family		= NFPROTO_IPV6,
-		.checkentry	= connsecmark_tg_check,
-		.destroy	= connsecmark_tg_destroy,
-		.target		= connsecmark_tg,
-		.targetsize	= sizeof(struct xt_connsecmark_target_info),
-		.me		= THIS_MODULE,
-	},
+static struct xt_target connsecmark_tg_reg __read_mostly = {
+	.name       = "CONNSECMARK",
+	.revision   = 0,
+	.family     = NFPROTO_UNSPEC,
+	.checkentry = connsecmark_tg_check,
+	.destroy    = connsecmark_tg_destroy,
+	.target     = connsecmark_tg,
+	.targetsize = sizeof(struct xt_connsecmark_target_info),
+	.me         = THIS_MODULE,
 };
 
 static int __init connsecmark_tg_init(void)
 {
-	return xt_register_targets(connsecmark_tg_reg,
-	       ARRAY_SIZE(connsecmark_tg_reg));
+	return xt_register_target(&connsecmark_tg_reg);
 }
 
 static void __exit connsecmark_tg_exit(void)
 {
-	xt_unregister_targets(connsecmark_tg_reg,
-	                      ARRAY_SIZE(connsecmark_tg_reg));
+	xt_unregister_target(&connsecmark_tg_reg);
 }
 
 module_init(connsecmark_tg_init);
diff --git a/net/netfilter/xt_NFLOG.c b/net/netfilter/xt_NFLOG.c
index 56ee4f1..50e3a52 100644
--- a/net/netfilter/xt_NFLOG.c
+++ b/net/netfilter/xt_NFLOG.c
@@ -31,7 +31,7 @@ nflog_tg(struct sk_buff *skb, const struct xt_target_param *par)
 	li.u.ulog.group	     = info->group;
 	li.u.ulog.qthreshold = info->threshold;
 
-	nf_log_packet(par->target->family, par->hooknum, skb, par->in,
+	nf_log_packet(par->family, par->hooknum, skb, par->in,
 	              par->out, &li, "%s", info->prefix);
 	return XT_CONTINUE;
 }
@@ -47,33 +47,24 @@ static bool nflog_tg_check(const struct xt_tgchk_param *par)
 	return true;
 }
 
-static struct xt_target nflog_tg_reg[] __read_mostly = {
-	{
-		.name		= "NFLOG",
-		.family		= NFPROTO_IPV4,
-		.checkentry	= nflog_tg_check,
-		.target		= nflog_tg,
-		.targetsize	= sizeof(struct xt_nflog_info),
-		.me		= THIS_MODULE,
-	},
-	{
-		.name		= "NFLOG",
-		.family		= NFPROTO_IPV6,
-		.checkentry	= nflog_tg_check,
-		.target		= nflog_tg,
-		.targetsize	= sizeof(struct xt_nflog_info),
-		.me		= THIS_MODULE,
-	},
+static struct xt_target nflog_tg_reg __read_mostly = {
+	.name       = "NFLOG",
+	.revision   = 0,
+	.family     = NFPROTO_UNSPEC,
+	.checkentry = nflog_tg_check,
+	.target     = nflog_tg,
+	.targetsize = sizeof(struct xt_nflog_info),
+	.me         = THIS_MODULE,
 };
 
 static int __init nflog_tg_init(void)
 {
-	return xt_register_targets(nflog_tg_reg, ARRAY_SIZE(nflog_tg_reg));
+	return xt_register_target(&nflog_tg_reg);
 }
 
 static void __exit nflog_tg_exit(void)
 {
-	xt_unregister_targets(nflog_tg_reg, ARRAY_SIZE(nflog_tg_reg));
+	xt_unregister_target(&nflog_tg_reg);
 }
 
 module_init(nflog_tg_init);
diff --git a/net/netfilter/xt_connbytes.c b/net/netfilter/xt_connbytes.c
index 5bf4aa0..955e659 100644
--- a/net/netfilter/xt_connbytes.c
+++ b/net/netfilter/xt_connbytes.c
@@ -106,9 +106,9 @@ static bool connbytes_mt_check(const struct xt_mtchk_param *par)
 	    sinfo->direction != XT_CONNBYTES_DIR_BOTH)
 		return false;
 
-	if (nf_ct_l3proto_try_module_get(par->match->family) < 0) {
+	if (nf_ct_l3proto_try_module_get(par->family) < 0) {
 		printk(KERN_WARNING "can't load conntrack support for "
-				    "proto=%u\n", par->match->family);
+				    "proto=%u\n", par->family);
 		return false;
 	}
 
@@ -117,39 +117,28 @@ static bool connbytes_mt_check(const struct xt_mtchk_param *par)
 
 static void connbytes_mt_destroy(const struct xt_mtdtor_param *par)
 {
-	nf_ct_l3proto_module_put(par->match->family);
+	nf_ct_l3proto_module_put(par->family);
 }
 
-static struct xt_match connbytes_mt_reg[] __read_mostly = {
-	{
-		.name		= "connbytes",
-		.family		= NFPROTO_IPV4,
-		.checkentry	= connbytes_mt_check,
-		.match		= connbytes_mt,
-		.destroy	= connbytes_mt_destroy,
-		.matchsize	= sizeof(struct xt_connbytes_info),
-		.me		= THIS_MODULE
-	},
-	{
-		.name		= "connbytes",
-		.family		= NFPROTO_IPV6,
-		.checkentry	= connbytes_mt_check,
-		.match		= connbytes_mt,
-		.destroy	= connbytes_mt_destroy,
-		.matchsize	= sizeof(struct xt_connbytes_info),
-		.me		= THIS_MODULE
-	},
+static struct xt_match connbytes_mt_reg __read_mostly = {
+	.name       = "connbytes",
+	.revision   = 0,
+	.family     = NFPROTO_UNSPEC,
+	.checkentry = connbytes_mt_check,
+	.match      = connbytes_mt,
+	.destroy    = connbytes_mt_destroy,
+	.matchsize  = sizeof(struct xt_connbytes_info),
+	.me         = THIS_MODULE,
 };
 
 static int __init connbytes_mt_init(void)
 {
-	return xt_register_matches(connbytes_mt_reg,
-	       ARRAY_SIZE(connbytes_mt_reg));
+	return xt_register_match(&connbytes_mt_reg);
 }
 
 static void __exit connbytes_mt_exit(void)
 {
-	xt_unregister_matches(connbytes_mt_reg, ARRAY_SIZE(connbytes_mt_reg));
+	xt_unregister_match(&connbytes_mt_reg);
 }
 
 module_init(connbytes_mt_init);
diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
index bfb3ee6..7f404cc 100644
--- a/net/netfilter/xt_connlimit.c
+++ b/net/netfilter/xt_connlimit.c
@@ -192,10 +192,10 @@ connlimit_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	if (ct != NULL)
 		tuple_ptr = &ct->tuplehash[0].tuple;
 	else if (!nf_ct_get_tuplepr(skb, skb_network_offset(skb),
-				    par->match->family, &tuple))
+				    par->family, &tuple))
 		goto hotdrop;
 
-	if (par->match->family == NFPROTO_IPV6) {
+	if (par->family == NFPROTO_IPV6) {
 		const struct ipv6hdr *iph = ipv6_hdr(skb);
 		memcpy(&addr.ip6, &iph->saddr, sizeof(iph->saddr));
 	} else {
@@ -226,16 +226,16 @@ static bool connlimit_mt_check(const struct xt_mtchk_param *par)
 	struct xt_connlimit_info *info = par->matchinfo;
 	unsigned int i;
 
-	if (nf_ct_l3proto_try_module_get(par->match->family) < 0) {
+	if (nf_ct_l3proto_try_module_get(par->family) < 0) {
 		printk(KERN_WARNING "cannot load conntrack support for "
-		       "address family %u\n", par->match->family);
+		       "address family %u\n", par->family);
 		return false;
 	}
 
 	/* init private data */
 	info->data = kmalloc(sizeof(struct xt_connlimit_data), GFP_KERNEL);
 	if (info->data == NULL) {
-		nf_ct_l3proto_module_put(par->match->family);
+		nf_ct_l3proto_module_put(par->family);
 		return false;
 	}
 
@@ -254,7 +254,7 @@ static void connlimit_mt_destroy(const struct xt_mtdtor_param *par)
 	struct list_head *hash = info->data->iphash;
 	unsigned int i;
 
-	nf_ct_l3proto_module_put(par->match->family);
+	nf_ct_l3proto_module_put(par->family);
 
 	for (i = 0; i < ARRAY_SIZE(info->data->iphash); ++i) {
 		list_for_each_entry_safe(conn, tmp, &hash[i], list) {
@@ -266,41 +266,30 @@ static void connlimit_mt_destroy(const struct xt_mtdtor_param *par)
 	kfree(info->data);
 }
 
-static struct xt_match connlimit_mt_reg[] __read_mostly = {
-	{
-		.name       = "connlimit",
-		.family     = NFPROTO_IPV4,
-		.checkentry = connlimit_mt_check,
-		.match      = connlimit_mt,
-		.matchsize  = sizeof(struct xt_connlimit_info),
-		.destroy    = connlimit_mt_destroy,
-		.me         = THIS_MODULE,
-	},
-	{
-		.name       = "connlimit",
-		.family     = NFPROTO_IPV6,
-		.checkentry = connlimit_mt_check,
-		.match      = connlimit_mt,
-		.matchsize  = sizeof(struct xt_connlimit_info),
-		.destroy    = connlimit_mt_destroy,
-		.me         = THIS_MODULE,
-	},
+static struct xt_match connlimit_mt_reg __read_mostly = {
+	.name       = "connlimit",
+	.revision   = 0,
+	.family     = NFPROTO_UNSPEC,
+	.checkentry = connlimit_mt_check,
+	.match      = connlimit_mt,
+	.matchsize  = sizeof(struct xt_connlimit_info),
+	.destroy    = connlimit_mt_destroy,
+	.me         = THIS_MODULE,
 };
 
 static int __init connlimit_mt_init(void)
 {
-	return xt_register_matches(connlimit_mt_reg,
-	       ARRAY_SIZE(connlimit_mt_reg));
+	return xt_register_match(&connlimit_mt_reg);
 }
 
 static void __exit connlimit_mt_exit(void)
 {
-	xt_unregister_matches(connlimit_mt_reg, ARRAY_SIZE(connlimit_mt_reg));
+	xt_unregister_match(&connlimit_mt_reg);
 }
 
 module_init(connlimit_mt_init);
 module_exit(connlimit_mt_exit);
-MODULE_AUTHOR("Jan Engelhardt <jengelh@computergmbh.de>");
+MODULE_AUTHOR("Jan Engelhardt <jengelh@medozas.de>");
 MODULE_DESCRIPTION("Xtables: Number of connections matching");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_connlimit");
diff --git a/net/netfilter/xt_connmark.c b/net/netfilter/xt_connmark.c
index c708577..86cacab 100644
--- a/net/netfilter/xt_connmark.c
+++ b/net/netfilter/xt_connmark.c
@@ -69,9 +69,9 @@ static bool connmark_mt_check_v0(const struct xt_mtchk_param *par)
 		printk(KERN_WARNING "connmark: only support 32bit mark\n");
 		return false;
 	}
-	if (nf_ct_l3proto_try_module_get(par->match->family) < 0) {
+	if (nf_ct_l3proto_try_module_get(par->family) < 0) {
 		printk(KERN_WARNING "can't load conntrack support for "
-				    "proto=%u\n", par->match->family);
+				    "proto=%u\n", par->family);
 		return false;
 	}
 	return true;
@@ -79,9 +79,9 @@ static bool connmark_mt_check_v0(const struct xt_mtchk_param *par)
 
 static bool connmark_mt_check(const struct xt_mtchk_param *par)
 {
-	if (nf_ct_l3proto_try_module_get(par->match->family) < 0) {
+	if (nf_ct_l3proto_try_module_get(par->family) < 0) {
 		printk(KERN_WARNING "cannot load conntrack support for "
-		       "proto=%u\n", par->match->family);
+		       "proto=%u\n", par->family);
 		return false;
 	}
 	return true;
@@ -89,7 +89,7 @@ static bool connmark_mt_check(const struct xt_mtchk_param *par)
 
 static void connmark_mt_destroy(const struct xt_mtdtor_param *par)
 {
-	nf_ct_l3proto_module_put(par->match->family);
+	nf_ct_l3proto_module_put(par->family);
 }
 
 #ifdef CONFIG_COMPAT
@@ -127,7 +127,7 @@ static struct xt_match connmark_mt_reg[] __read_mostly = {
 	{
 		.name		= "connmark",
 		.revision	= 0,
-		.family		= NFPROTO_IPV4,
+		.family		= NFPROTO_UNSPEC,
 		.checkentry	= connmark_mt_check_v0,
 		.match		= connmark_mt_v0,
 		.destroy	= connmark_mt_destroy,
@@ -140,34 +140,9 @@ static struct xt_match connmark_mt_reg[] __read_mostly = {
 		.me		= THIS_MODULE
 	},
 	{
-		.name		= "connmark",
-		.revision	= 0,
-		.family		= NFPROTO_IPV6,
-		.checkentry	= connmark_mt_check_v0,
-		.match		= connmark_mt_v0,
-		.destroy	= connmark_mt_destroy,
-		.matchsize	= sizeof(struct xt_connmark_info),
-#ifdef CONFIG_COMPAT
-		.compatsize	= sizeof(struct compat_xt_connmark_info),
-		.compat_from_user = connmark_mt_compat_from_user_v0,
-		.compat_to_user	= connmark_mt_compat_to_user_v0,
-#endif
-		.me		= THIS_MODULE
-	},
-	{
-		.name           = "connmark",
-		.revision       = 1,
-		.family         = NFPROTO_IPV4,
-		.checkentry     = connmark_mt_check,
-		.match          = connmark_mt,
-		.matchsize      = sizeof(struct xt_connmark_mtinfo1),
-		.destroy        = connmark_mt_destroy,
-		.me             = THIS_MODULE,
-	},
-	{
 		.name           = "connmark",
 		.revision       = 1,
-		.family         = NFPROTO_IPV6,
+		.family         = NFPROTO_UNSPEC,
 		.checkentry     = connmark_mt_check,
 		.match          = connmark_mt,
 		.matchsize      = sizeof(struct xt_connmark_mtinfo1),
diff --git a/net/netfilter/xt_conntrack.c b/net/netfilter/xt_conntrack.c
index 5cd58d7..0b7139f 100644
--- a/net/netfilter/xt_conntrack.c
+++ b/net/netfilter/xt_conntrack.c
@@ -238,22 +238,22 @@ conntrack_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 		return false;
 
 	if (info->match_flags & XT_CONNTRACK_ORIGSRC)
-		if (conntrack_mt_origsrc(ct, info, par->match->family) ^
+		if (conntrack_mt_origsrc(ct, info, par->family) ^
 		    !(info->invert_flags & XT_CONNTRACK_ORIGSRC))
 			return false;
 
 	if (info->match_flags & XT_CONNTRACK_ORIGDST)
-		if (conntrack_mt_origdst(ct, info, par->match->family) ^
+		if (conntrack_mt_origdst(ct, info, par->family) ^
 		    !(info->invert_flags & XT_CONNTRACK_ORIGDST))
 			return false;
 
 	if (info->match_flags & XT_CONNTRACK_REPLSRC)
-		if (conntrack_mt_replsrc(ct, info, par->match->family) ^
+		if (conntrack_mt_replsrc(ct, info, par->family) ^
 		    !(info->invert_flags & XT_CONNTRACK_REPLSRC))
 			return false;
 
 	if (info->match_flags & XT_CONNTRACK_REPLDST)
-		if (conntrack_mt_repldst(ct, info, par->match->family) ^
+		if (conntrack_mt_repldst(ct, info, par->family) ^
 		    !(info->invert_flags & XT_CONNTRACK_REPLDST))
 			return false;
 
@@ -280,9 +280,9 @@ conntrack_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 
 static bool conntrack_mt_check(const struct xt_mtchk_param *par)
 {
-	if (nf_ct_l3proto_try_module_get(par->match->family) < 0) {
+	if (nf_ct_l3proto_try_module_get(par->family) < 0) {
 		printk(KERN_WARNING "can't load conntrack support for "
-				    "proto=%u\n", par->match->family);
+				    "proto=%u\n", par->family);
 		return false;
 	}
 	return true;
@@ -290,7 +290,7 @@ static bool conntrack_mt_check(const struct xt_mtchk_param *par)
 
 static void conntrack_mt_destroy(const struct xt_mtdtor_param *par)
 {
-	nf_ct_l3proto_module_put(par->match->family);
+	nf_ct_l3proto_module_put(par->family);
 }
 
 #ifdef CONFIG_COMPAT
@@ -361,17 +361,7 @@ static struct xt_match conntrack_mt_reg[] __read_mostly = {
 	{
 		.name       = "conntrack",
 		.revision   = 1,
-		.family     = NFPROTO_IPV4,
-		.matchsize  = sizeof(struct xt_conntrack_mtinfo1),
-		.match      = conntrack_mt,
-		.checkentry = conntrack_mt_check,
-		.destroy    = conntrack_mt_destroy,
-		.me         = THIS_MODULE,
-	},
-	{
-		.name       = "conntrack",
-		.revision   = 1,
-		.family     = NFPROTO_IPV6,
+		.family     = NFPROTO_UNSPEC,
 		.matchsize  = sizeof(struct xt_conntrack_mtinfo1),
 		.match      = conntrack_mt,
 		.checkentry = conntrack_mt_check,
diff --git a/net/netfilter/xt_helper.c b/net/netfilter/xt_helper.c
index 280c984..64fc7f2 100644
--- a/net/netfilter/xt_helper.c
+++ b/net/netfilter/xt_helper.c
@@ -58,9 +58,9 @@ static bool helper_mt_check(const struct xt_mtchk_param *par)
 {
 	struct xt_helper_info *info = par->matchinfo;
 
-	if (nf_ct_l3proto_try_module_get(par->match->family) < 0) {
+	if (nf_ct_l3proto_try_module_get(par->family) < 0) {
 		printk(KERN_WARNING "can't load conntrack support for "
-				    "proto=%u\n", par->match->family);
+				    "proto=%u\n", par->family);
 		return false;
 	}
 	info->name[29] = '\0';
@@ -69,38 +69,28 @@ static bool helper_mt_check(const struct xt_mtchk_param *par)
 
 static void helper_mt_destroy(const struct xt_mtdtor_param *par)
 {
-	nf_ct_l3proto_module_put(par->match->family);
+	nf_ct_l3proto_module_put(par->family);
 }
 
-static struct xt_match helper_mt_reg[] __read_mostly = {
-	{
-		.name		= "helper",
-		.family		= NFPROTO_IPV4,
-		.checkentry	= helper_mt_check,
-		.match		= helper_mt,
-		.destroy	= helper_mt_destroy,
-		.matchsize	= sizeof(struct xt_helper_info),
-		.me		= THIS_MODULE,
-	},
-	{
-		.name		= "helper",
-		.family		= NFPROTO_IPV6,
-		.checkentry	= helper_mt_check,
-		.match		= helper_mt,
-		.destroy	= helper_mt_destroy,
-		.matchsize	= sizeof(struct xt_helper_info),
-		.me		= THIS_MODULE,
-	},
+static struct xt_match helper_mt_reg __read_mostly = {
+	.name       = "helper",
+	.revision   = 0,
+	.family     = NFPROTO_UNSPEC,
+	.checkentry = helper_mt_check,
+	.match      = helper_mt,
+	.destroy    = helper_mt_destroy,
+	.matchsize  = sizeof(struct xt_helper_info),
+	.me         = THIS_MODULE,
 };
 
 static int __init helper_mt_init(void)
 {
-	return xt_register_matches(helper_mt_reg, ARRAY_SIZE(helper_mt_reg));
+	return xt_register_match(&helper_mt_reg);
 }
 
 static void __exit helper_mt_exit(void)
 {
-	xt_unregister_matches(helper_mt_reg, ARRAY_SIZE(helper_mt_reg));
+	xt_unregister_match(&helper_mt_reg);
 }
 
 module_init(helper_mt_init);
diff --git a/net/netfilter/xt_pkttype.c b/net/netfilter/xt_pkttype.c
index 37753a3..69da1d3 100644
--- a/net/netfilter/xt_pkttype.c
+++ b/net/netfilter/xt_pkttype.c
@@ -30,10 +30,10 @@ pkttype_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 
 	if (skb->pkt_type != PACKET_LOOPBACK)
 		type = skb->pkt_type;
-	else if (par->match->family == NFPROTO_IPV4 &&
+	else if (par->family == NFPROTO_IPV4 &&
 	    ipv4_is_multicast(ip_hdr(skb)->daddr))
 		type = PACKET_MULTICAST;
-	else if (par->match->family == NFPROTO_IPV6 &&
+	else if (par->family == NFPROTO_IPV6 &&
 	    ipv6_hdr(skb)->daddr.s6_addr[0] == 0xFF)
 		type = PACKET_MULTICAST;
 	else
@@ -42,31 +42,23 @@ pkttype_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	return (type == info->pkttype) ^ info->invert;
 }
 
-static struct xt_match pkttype_mt_reg[] __read_mostly = {
-	{
-		.name		= "pkttype",
-		.family		= NFPROTO_IPV4,
-		.match		= pkttype_mt,
-		.matchsize	= sizeof(struct xt_pkttype_info),
-		.me		= THIS_MODULE,
-	},
-	{
-		.name		= "pkttype",
-		.family		= NFPROTO_IPV6,
-		.match		= pkttype_mt,
-		.matchsize	= sizeof(struct xt_pkttype_info),
-		.me		= THIS_MODULE,
-	},
+static struct xt_match pkttype_mt_reg __read_mostly = {
+	.name      = "pkttype",
+	.revision  = 0,
+	.family    = NFPROTO_UNSPEC,
+	.match     = pkttype_mt,
+	.matchsize = sizeof(struct xt_pkttype_info),
+	.me        = THIS_MODULE,
 };
 
 static int __init pkttype_mt_init(void)
 {
-	return xt_register_matches(pkttype_mt_reg, ARRAY_SIZE(pkttype_mt_reg));
+	return xt_register_match(&pkttype_mt_reg);
 }
 
 static void __exit pkttype_mt_exit(void)
 {
-	xt_unregister_matches(pkttype_mt_reg, ARRAY_SIZE(pkttype_mt_reg));
+	xt_unregister_match(&pkttype_mt_reg);
 }
 
 module_init(pkttype_mt_init);
-- 
1.6.0.1

