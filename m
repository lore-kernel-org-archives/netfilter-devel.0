From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 15/19] [NETFILTER]: Implement AF_UNSPEC as a wildcard for
 extensions
Date: Tue, 4 Mar 2008 17:37:18 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0803041736170.7660@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0803040519150.7660@fbirervta.pbzchgretzou.qr>
 <47CD6296.90303@trash.net> <Pine.LNX.4.64.0803041630440.7660@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:47334 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932230AbYCDQhU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Mar 2008 11:37:20 -0500
In-Reply-To: <Pine.LNX.4.64.0803041630440.7660@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 008144757b4423aad7e548132f1967b44ff6a60f
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Thu Feb 14 03:21:32 2008 +0100

    [NETFILTER]: Implement AF_UNSPEC as a wildcard for extensions
    
    When a match or target is looked up using xt_find_{match,target},
    Xtables will also search the AF_UNSPEC module list. This allows for
    extensions to be reused from other components (e.g. arptables,
    ebtables).
    
    Extensions that take different codepaths depending on match->family
    or target->family of course cannot use AF_UNSPEC within the
    registration structure (e.g. xt_pkttype).
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
---
 net/netfilter/x_tables.c     |   11 +++++++++
 net/netfilter/xt_CLASSIFY.c  |   38 ++++++++++----------------------
 net/netfilter/xt_MARK.c      |   10 +-------
 net/netfilter/xt_RATEEST.c   |   33 +++++++++------------------
 net/netfilter/xt_SECMARK.c   |   35 ++++++++++-------------------
 net/netfilter/xt_TRACE.c     |   27 ++++++++--------------
 net/netfilter/xt_limit.c     |   40 +++++++++++-----------------------
 net/netfilter/xt_mark.c      |   26 +--------------------
 net/netfilter/xt_quota.c     |   29 ++++++++----------------
 net/netfilter/xt_rateest.c   |   33 +++++++++------------------
 net/netfilter/xt_statistic.c |   31 ++++++++-----------------
 net/netfilter/xt_string.c    |   32 +++++++++-----------------
 net/netfilter/xt_time.c      |   28 +++++++----------------
 net/netfilter/xt_u32.c       |   26 +++++++--------------
 14 files changed, 132 insertions(+), 267 deletions(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 8bbc4ac..065103e 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -59,6 +59,7 @@ static struct xt_af *xt;
 #endif
 
 static const char *const xt_prefix[NPROTO] = {
+	[AF_UNSPEC]	= "x",
 	[AF_INET]	= "ip",
 	[AF_INET6]	= "ip6",
 	[AF_ARP]	= "arp",
@@ -207,6 +208,11 @@ struct xt_match *xt_find_match(unsigned int af, const char *name, u8 revision)
 		}
 	}
 	mutex_unlock(&xt[af].mutex);
+
+	if (af != AF_UNSPEC)
+		/* Try searching again in the family-independent list */
+		return xt_find_match(AF_UNSPEC, name, revision);
+
 	return ERR_PTR(err);
 }
 EXPORT_SYMBOL(xt_find_match);
@@ -232,6 +238,11 @@ struct xt_target *xt_find_target(unsigned int af, const char *name, u8 revision)
 		}
 	}
 	mutex_unlock(&xt[af].mutex);
+
+	if (af != AF_UNSPEC)
+		/* Try searching again in the family-independent list */
+		return xt_find_target(AF_UNSPEC, name, revision);
+
 	return ERR_PTR(err);
 }
 EXPORT_SYMBOL(xt_find_target);
diff --git a/net/netfilter/xt_CLASSIFY.c b/net/netfilter/xt_CLASSIFY.c
index 77a52bf..268fb28 100644
--- a/net/netfilter/xt_CLASSIFY.c
+++ b/net/netfilter/xt_CLASSIFY.c
@@ -37,40 +37,26 @@ classify_tg(struct sk_buff *skb, const struct net_device *in,
 	return XT_CONTINUE;
 }
 
-static struct xt_target classify_tg_reg[] __read_mostly = {
-	{
-		.family		= AF_INET,
-		.name 		= "CLASSIFY",
-		.target 	= classify_tg,
-		.targetsize	= sizeof(struct xt_classify_target_info),
-		.table		= "mangle",
-		.hooks		= (1 << NF_INET_LOCAL_OUT) |
-				  (1 << NF_INET_FORWARD) |
-				  (1 << NF_INET_POST_ROUTING),
-		.me 		= THIS_MODULE,
-	},
-	{
-		.name 		= "CLASSIFY",
-		.family		= AF_INET6,
-		.target 	= classify_tg,
-		.targetsize	= sizeof(struct xt_classify_target_info),
-		.table		= "mangle",
-		.hooks		= (1 << NF_INET_LOCAL_OUT) |
-				  (1 << NF_INET_FORWARD) |
-				  (1 << NF_INET_POST_ROUTING),
-		.me 		= THIS_MODULE,
-	},
+static struct xt_target classify_tg_reg __read_mostly = {
+	.name       = "CLASSIFY",
+	.revision   = 0,
+	.family     = AF_UNSPEC,
+	.table      = "mangle",
+	.hooks      = (1 << NF_INET_LOCAL_OUT) | (1 << NF_INET_FORWARD) |
+	              (1 << NF_INET_POST_ROUTING),
+	.target     = classify_tg,
+	.targetsize = sizeof(struct xt_classify_target_info),
+	.me         = THIS_MODULE,
 };
 
 static int __init classify_tg_init(void)
 {
-	return xt_register_targets(classify_tg_reg,
-	       ARRAY_SIZE(classify_tg_reg));
+	return xt_register_target(&classify_tg_reg);
 }
 
 static void __exit classify_tg_exit(void)
 {
-	xt_unregister_targets(classify_tg_reg, ARRAY_SIZE(classify_tg_reg));
+	xt_unregister_target(&classify_tg_reg);
 }
 
 module_init(classify_tg_init);
diff --git a/net/netfilter/xt_MARK.c b/net/netfilter/xt_MARK.c
index f9ce20b..f2498f9 100644
--- a/net/netfilter/xt_MARK.c
+++ b/net/netfilter/xt_MARK.c
@@ -222,15 +222,7 @@ static struct xt_target mark_tg_reg[] __read_mostly = {
 	{
 		.name           = "MARK",
 		.revision       = 2,
-		.family         = AF_INET,
-		.target         = mark_tg,
-		.targetsize     = sizeof(struct xt_mark_tginfo2),
-		.me             = THIS_MODULE,
-	},
-	{
-		.name           = "MARK",
-		.revision       = 2,
-		.family         = AF_INET6,
+		.family         = AF_UNSPEC,
 		.target         = mark_tg,
 		.targetsize     = sizeof(struct xt_mark_tginfo2),
 		.me             = THIS_MODULE,
diff --git a/net/netfilter/xt_RATEEST.c b/net/netfilter/xt_RATEEST.c
index 64d6ad3..2014f2a 100644
--- a/net/netfilter/xt_RATEEST.c
+++ b/net/netfilter/xt_RATEEST.c
@@ -157,25 +157,15 @@ static void xt_rateest_tg_destroy(const struct xt_target *target,
 	xt_rateest_put(info->est);
 }
 
-static struct xt_target xt_rateest_target[] __read_mostly = {
-	{
-		.family		= AF_INET,
-		.name		= "RATEEST",
-		.target		= xt_rateest_tg,
-		.checkentry	= xt_rateest_tg_checkentry,
-		.destroy	= xt_rateest_tg_destroy,
-		.targetsize	= sizeof(struct xt_rateest_target_info),
-		.me		= THIS_MODULE,
-	},
-	{
-		.family		= AF_INET6,
-		.name		= "RATEEST",
-		.target		= xt_rateest_tg,
-		.checkentry	= xt_rateest_tg_checkentry,
-		.destroy	= xt_rateest_tg_destroy,
-		.targetsize	= sizeof(struct xt_rateest_target_info),
-		.me		= THIS_MODULE,
-	},
+static struct xt_target xt_rateest_tg_reg __read_mostly = {
+	.name       = "RATEEST",
+	.revision   = 0,
+	.family     = AF_UNSPEC,
+	.target     = xt_rateest_tg,
+	.checkentry = xt_rateest_tg_checkentry,
+	.destroy    = xt_rateest_tg_destroy,
+	.targetsize = sizeof(struct xt_rateest_target_info),
+	.me         = THIS_MODULE,
 };
 
 static int __init xt_rateest_tg_init(void)
@@ -186,13 +176,12 @@ static int __init xt_rateest_tg_init(void)
 		INIT_HLIST_HEAD(&rateest_hash[i]);
 
 	get_random_bytes(&jhash_rnd, sizeof(jhash_rnd));
-	return xt_register_targets(xt_rateest_target,
-				   ARRAY_SIZE(xt_rateest_target));
+	return xt_register_target(&xt_rateest_tg_reg);
 }
 
 static void __exit xt_rateest_tg_fini(void)
 {
-	xt_unregister_targets(xt_rateest_target, ARRAY_SIZE(xt_rateest_target));
+	xt_unregister_target(&xt_rateest_tg_reg);
 }
 
 
diff --git a/net/netfilter/xt_SECMARK.c b/net/netfilter/xt_SECMARK.c
index c028485..23baaa3 100644
--- a/net/netfilter/xt_SECMARK.c
+++ b/net/netfilter/xt_SECMARK.c
@@ -119,37 +119,26 @@ static void secmark_tg_destroy(const struct xt_target *target, void *targinfo)
 	}
 }
 
-static struct xt_target secmark_tg_reg[] __read_mostly = {
-	{
-		.name		= "SECMARK",
-		.family		= AF_INET,
-		.checkentry	= secmark_tg_check,
-		.destroy	= secmark_tg_destroy,
-		.target		= secmark_tg,
-		.targetsize	= sizeof(struct xt_secmark_target_info),
-		.table		= "mangle",
-		.me		= THIS_MODULE,
-	},
-	{
-		.name		= "SECMARK",
-		.family		= AF_INET6,
-		.checkentry	= secmark_tg_check,
-		.destroy	= secmark_tg_destroy,
-		.target		= secmark_tg,
-		.targetsize	= sizeof(struct xt_secmark_target_info),
-		.table		= "mangle",
-		.me		= THIS_MODULE,
-	},
+static struct xt_target secmark_tg_reg __read_mostly = {
+	.name       = "SECMARK",
+	.revision   = 0,
+	.family     = AF_UNSPEC,
+	.table      = "mangle",
+	.target     = secmark_tg,
+	.checkentry = secmark_tg_check,
+	.destroy    = secmark_tg_destroy,
+	.targetsize = sizeof(struct xt_secmark_target_info),
+	.me         = THIS_MODULE,
 };
 
 static int __init secmark_tg_init(void)
 {
-	return xt_register_targets(secmark_tg_reg, ARRAY_SIZE(secmark_tg_reg));
+	return xt_register_target(&secmark_tg_reg);
 }
 
 static void __exit secmark_tg_exit(void)
 {
-	xt_unregister_targets(secmark_tg_reg, ARRAY_SIZE(secmark_tg_reg));
+	xt_unregister_target(&secmark_tg_reg);
 }
 
 module_init(secmark_tg_init);
diff --git a/net/netfilter/xt_TRACE.c b/net/netfilter/xt_TRACE.c
index 30dab79..d50f689 100644
--- a/net/netfilter/xt_TRACE.c
+++ b/net/netfilter/xt_TRACE.c
@@ -19,31 +19,24 @@ trace_tg(struct sk_buff *skb, const struct net_device *in,
 	return XT_CONTINUE;
 }
 
-static struct xt_target trace_tg_reg[] __read_mostly = {
-	{
-		.name		= "TRACE",
-		.family		= AF_INET,
-		.target		= trace_tg,
-		.table		= "raw",
-		.me		= THIS_MODULE,
-	},
-	{
-		.name		= "TRACE",
-		.family		= AF_INET6,
-		.target		= trace_tg,
-		.table		= "raw",
-		.me		= THIS_MODULE,
-	},
+static struct xt_target trace_tg_reg __read_mostly = {
+	.name       = "TRACE",
+	.revision   = 0,
+	.family     = AF_UNSPEC,
+	.table      = "raw",
+	.target     = trace_tg,
+	.targetsize = XT_ALIGN(0),
+	.me         = THIS_MODULE,
 };
 
 static int __init trace_tg_init(void)
 {
-	return xt_register_targets(trace_tg_reg, ARRAY_SIZE(trace_tg_reg));
+	return xt_register_target(&trace_tg_reg);
 }
 
 static void __exit trace_tg_exit(void)
 {
-	xt_unregister_targets(trace_tg_reg, ARRAY_SIZE(trace_tg_reg));
+	xt_unregister_target(&trace_tg_reg);
 }
 
 module_init(trace_tg_init);
diff --git a/net/netfilter/xt_limit.c b/net/netfilter/xt_limit.c
index aad9ab8..88be2cc 100644
--- a/net/netfilter/xt_limit.c
+++ b/net/netfilter/xt_limit.c
@@ -167,43 +167,29 @@ static int limit_mt_compat_to_user(void __user *dst, void *src)
 }
 #endif /* CONFIG_COMPAT */
 
-static struct xt_match limit_mt_reg[] __read_mostly = {
-	{
-		.name		= "limit",
-		.family		= AF_INET,
-		.checkentry	= limit_mt_check,
-		.match		= limit_mt,
-		.matchsize	= sizeof(struct xt_rateinfo),
+static struct xt_match limit_mt_reg __read_mostly = {
+	.name             = "limit",
+	.revision         = 0,
+	.family           = AF_UNSPEC,
+	.match            = limit_mt,
+	.checkentry       = limit_mt_check,
+	.matchsize        = sizeof(struct xt_rateinfo),
 #ifdef CONFIG_COMPAT
-		.compatsize	= sizeof(struct compat_xt_rateinfo),
-		.compat_from_user = limit_mt_compat_from_user,
-		.compat_to_user	= limit_mt_compat_to_user,
+	.compatsize       = sizeof(struct compat_xt_rateinfo),
+	.compat_from_user = limit_mt_compat_from_user,
+	.compat_to_user   = limit_mt_compat_to_user,
 #endif
-		.me		= THIS_MODULE,
-	},
-	{
-		.name		= "limit",
-		.family		= AF_INET6,
-		.checkentry	= limit_mt_check,
-		.match		= limit_mt,
-		.matchsize	= sizeof(struct xt_rateinfo),
-#ifdef CONFIG_COMPAT
-		.compatsize	= sizeof(struct compat_xt_rateinfo),
-		.compat_from_user = limit_mt_compat_from_user,
-		.compat_to_user	= limit_mt_compat_to_user,
-#endif
-		.me		= THIS_MODULE,
-	},
+	.me               = THIS_MODULE,
 };
 
 static int __init limit_mt_init(void)
 {
-	return xt_register_matches(limit_mt_reg, ARRAY_SIZE(limit_mt_reg));
+	return xt_register_match(&limit_mt_reg);
 }
 
 static void __exit limit_mt_exit(void)
 {
-	xt_unregister_matches(limit_mt_reg, ARRAY_SIZE(limit_mt_reg));
+	xt_unregister_match(&limit_mt_reg);
 }
 
 module_init(limit_mt_init);
diff --git a/net/netfilter/xt_mark.c b/net/netfilter/xt_mark.c
index 9f78f61..1697ba9 100644
--- a/net/netfilter/xt_mark.c
+++ b/net/netfilter/xt_mark.c
@@ -92,7 +92,7 @@ static struct xt_match mark_mt_reg[] __read_mostly = {
 	{
 		.name		= "mark",
 		.revision	= 0,
-		.family		= AF_INET,
+		.family		= AF_UNSPEC,
 		.checkentry	= mark_mt_check_v0,
 		.match		= mark_mt_v0,
 		.matchsize	= sizeof(struct xt_mark_info),
@@ -104,31 +104,9 @@ static struct xt_match mark_mt_reg[] __read_mostly = {
 		.me		= THIS_MODULE,
 	},
 	{
-		.name		= "mark",
-		.revision	= 0,
-		.family		= AF_INET6,
-		.checkentry	= mark_mt_check_v0,
-		.match		= mark_mt_v0,
-		.matchsize	= sizeof(struct xt_mark_info),
-#ifdef CONFIG_COMPAT
-		.compatsize	= sizeof(struct compat_xt_mark_info),
-		.compat_from_user = mark_mt_compat_from_user_v0,
-		.compat_to_user	= mark_mt_compat_to_user_v0,
-#endif
-		.me		= THIS_MODULE,
-	},
-	{
-		.name           = "mark",
-		.revision       = 1,
-		.family         = AF_INET,
-		.match          = mark_mt,
-		.matchsize      = sizeof(struct xt_mark_mtinfo1),
-		.me             = THIS_MODULE,
-	},
-	{
 		.name           = "mark",
 		.revision       = 1,
-		.family         = AF_INET6,
+		.family         = AF_UNSPEC,
 		.match          = mark_mt,
 		.matchsize      = sizeof(struct xt_mark_mtinfo1),
 		.me             = THIS_MODULE,
diff --git a/net/netfilter/xt_quota.c b/net/netfilter/xt_quota.c
index 3b021d0..60be101 100644
--- a/net/netfilter/xt_quota.c
+++ b/net/netfilter/xt_quota.c
@@ -54,33 +54,24 @@ quota_mt_check(const char *tablename, const void *entry,
 	return true;
 }
 
-static struct xt_match quota_mt_reg[] __read_mostly = {
-	{
-		.name		= "quota",
-		.family		= AF_INET,
-		.checkentry	= quota_mt_check,
-		.match		= quota_mt,
-		.matchsize	= sizeof(struct xt_quota_info),
-		.me		= THIS_MODULE
-	},
-	{
-		.name		= "quota",
-		.family		= AF_INET6,
-		.checkentry	= quota_mt_check,
-		.match		= quota_mt,
-		.matchsize	= sizeof(struct xt_quota_info),
-		.me		= THIS_MODULE
-	},
+static struct xt_match quota_mt_reg __read_mostly = {
+	.name       = "quota",
+	.revision   = 0,
+	.family     = AF_UNSPEC,
+	.match      = quota_mt,
+	.checkentry = quota_mt_check,
+	.matchsize  = sizeof(struct xt_quota_info),
+	.me         = THIS_MODULE,
 };
 
 static int __init quota_mt_init(void)
 {
-	return xt_register_matches(quota_mt_reg, ARRAY_SIZE(quota_mt_reg));
+	return xt_register_match(&quota_mt_reg);
 }
 
 static void __exit quota_mt_exit(void)
 {
-	xt_unregister_matches(quota_mt_reg, ARRAY_SIZE(quota_mt_reg));
+	xt_unregister_match(&quota_mt_reg);
 }
 
 module_init(quota_mt_init);
diff --git a/net/netfilter/xt_rateest.c b/net/netfilter/xt_rateest.c
index ebd84f1..917fe41 100644
--- a/net/netfilter/xt_rateest.c
+++ b/net/netfilter/xt_rateest.c
@@ -137,36 +137,25 @@ static void xt_rateest_mt_destroy(const struct xt_match *match,
 		xt_rateest_put(info->est2);
 }
 
-static struct xt_match xt_rateest_match[] __read_mostly = {
-	{
-		.family		= AF_INET,
-		.name		= "rateest",
-		.match		= xt_rateest_mt,
-		.checkentry	= xt_rateest_mt_checkentry,
-		.destroy	= xt_rateest_mt_destroy,
-		.matchsize	= sizeof(struct xt_rateest_match_info),
-		.me		= THIS_MODULE,
-	},
-	{
-		.family		= AF_INET6,
-		.name		= "rateest",
-		.match		= xt_rateest_mt,
-		.checkentry	= xt_rateest_mt_checkentry,
-		.destroy	= xt_rateest_mt_destroy,
-		.matchsize	= sizeof(struct xt_rateest_match_info),
-		.me		= THIS_MODULE,
-	},
+static struct xt_match xt_rateest_mt_reg __read_mostly = {
+	.name       = "rateest",
+	.revision   = 0,
+	.family     = AF_UNSPEC,
+	.match      = xt_rateest_mt,
+	.checkentry = xt_rateest_mt_checkentry,
+	.destroy    = xt_rateest_mt_destroy,
+	.matchsize  = sizeof(struct xt_rateest_match_info),
+	.me         = THIS_MODULE,
 };
 
 static int __init xt_rateest_mt_init(void)
 {
-	return xt_register_matches(xt_rateest_match,
-				   ARRAY_SIZE(xt_rateest_match));
+	return xt_register_match(&xt_rateest_mt_reg);
 }
 
 static void __exit xt_rateest_mt_fini(void)
 {
-	xt_unregister_matches(xt_rateest_match, ARRAY_SIZE(xt_rateest_match));
+	xt_unregister_match(&xt_rateest_mt_reg);
 }
 
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
diff --git a/net/netfilter/xt_statistic.c b/net/netfilter/xt_statistic.c
index 4313308..422090c 100644
--- a/net/netfilter/xt_statistic.c
+++ b/net/netfilter/xt_statistic.c
@@ -66,35 +66,24 @@ statistic_mt_check(const char *tablename, const void *entry,
 	return true;
 }
 
-static struct xt_match statistic_mt_reg[] __read_mostly = {
-	{
-		.name		= "statistic",
-		.family		= AF_INET,
-		.checkentry	= statistic_mt_check,
-		.match		= statistic_mt,
-		.matchsize	= sizeof(struct xt_statistic_info),
-		.me		= THIS_MODULE,
-	},
-	{
-		.name		= "statistic",
-		.family		= AF_INET6,
-		.checkentry	= statistic_mt_check,
-		.match		= statistic_mt,
-		.matchsize	= sizeof(struct xt_statistic_info),
-		.me		= THIS_MODULE,
-	},
+static struct xt_match xt_statistic_mt_reg __read_mostly = {
+	.name       = "statistic",
+	.revision   = 0,
+	.family     = AF_UNSPEC,
+	.match      = statistic_mt,
+	.checkentry = statistic_mt_check,
+	.matchsize  = sizeof(struct xt_statistic_info),
+	.me         = THIS_MODULE,
 };
 
 static int __init statistic_mt_init(void)
 {
-	return xt_register_matches(statistic_mt_reg,
-	       ARRAY_SIZE(statistic_mt_reg));
+	return xt_register_match(&xt_statistic_mt_reg);
 }
 
 static void __exit statistic_mt_exit(void)
 {
-	xt_unregister_matches(statistic_mt_reg,
-	                      ARRAY_SIZE(statistic_mt_reg));
+	xt_unregister_match(&xt_statistic_mt_reg);
 }
 
 module_init(statistic_mt_init);
diff --git a/net/netfilter/xt_string.c b/net/netfilter/xt_string.c
index 72f694d..e7fb2de 100644
--- a/net/netfilter/xt_string.c
+++ b/net/netfilter/xt_string.c
@@ -69,35 +69,25 @@ static void string_mt_destroy(const struct xt_match *match, void *matchinfo)
 	textsearch_destroy(STRING_TEXT_PRIV(matchinfo)->config);
 }
 
-static struct xt_match string_mt_reg[] __read_mostly = {
-	{
-		.name 		= "string",
-		.family		= AF_INET,
-		.checkentry	= string_mt_check,
-		.match 		= string_mt,
-		.destroy 	= string_mt_destroy,
-		.matchsize	= sizeof(struct xt_string_info),
-		.me 		= THIS_MODULE
-	},
-	{
-		.name 		= "string",
-		.family		= AF_INET6,
-		.checkentry	= string_mt_check,
-		.match 		= string_mt,
-		.destroy 	= string_mt_destroy,
-		.matchsize	= sizeof(struct xt_string_info),
-		.me 		= THIS_MODULE
-	},
+static struct xt_match xt_string_mt_reg __read_mostly = {
+	.name       = "string",
+	.revision   = 0,
+	.family     = AF_UNSPEC,
+	.match      = string_mt,
+	.checkentry = string_mt_check,
+	.destroy    = string_mt_destroy,
+	.matchsize  = sizeof(struct xt_string_info),
+	.me         = THIS_MODULE,
 };
 
 static int __init string_mt_init(void)
 {
-	return xt_register_matches(string_mt_reg, ARRAY_SIZE(string_mt_reg));
+	return xt_register_match(&xt_string_mt_reg);
 }
 
 static void __exit string_mt_exit(void)
 {
-	xt_unregister_matches(string_mt_reg, ARRAY_SIZE(string_mt_reg));
+	xt_unregister_match(&xt_string_mt_reg);
 }
 
 module_init(string_mt_init);
diff --git a/net/netfilter/xt_time.c b/net/netfilter/xt_time.c
index 41297d0..997761d 100644
--- a/net/netfilter/xt_time.c
+++ b/net/netfilter/xt_time.c
@@ -232,33 +232,23 @@ time_mt_check(const char *tablename, const void *ip,
 	return true;
 }
 
-static struct xt_match time_mt_reg[] __read_mostly = {
-	{
-		.name       = "time",
-		.family     = AF_INET,
-		.match      = time_mt,
-		.matchsize  = sizeof(struct xt_time_info),
-		.checkentry = time_mt_check,
-		.me         = THIS_MODULE,
-	},
-	{
-		.name       = "time",
-		.family     = AF_INET6,
-		.match      = time_mt,
-		.matchsize  = sizeof(struct xt_time_info),
-		.checkentry = time_mt_check,
-		.me         = THIS_MODULE,
-	},
+static struct xt_match xt_time_mt_reg __read_mostly = {
+	.name       = "time",
+	.family     = AF_UNSPEC,
+	.match      = time_mt,
+	.checkentry = time_mt_check,
+	.matchsize  = sizeof(struct xt_time_info),
+	.me         = THIS_MODULE,
 };
 
 static int __init time_mt_init(void)
 {
-	return xt_register_matches(time_mt_reg, ARRAY_SIZE(time_mt_reg));
+	return xt_register_match(&xt_time_mt_reg);
 }
 
 static void __exit time_mt_exit(void)
 {
-	xt_unregister_matches(time_mt_reg, ARRAY_SIZE(time_mt_reg));
+	xt_unregister_match(&xt_time_mt_reg);
 }
 
 module_init(time_mt_init);
diff --git a/net/netfilter/xt_u32.c b/net/netfilter/xt_u32.c
index 627e0f3..343b8d1 100644
--- a/net/netfilter/xt_u32.c
+++ b/net/netfilter/xt_u32.c
@@ -99,31 +99,23 @@ u32_mt(const struct sk_buff *skb, const struct net_device *in,
 	return ret ^ data->invert;
 }
 
-static struct xt_match u32_mt_reg[] __read_mostly = {
-	{
-		.name       = "u32",
-		.family     = AF_INET,
-		.match      = u32_mt,
-		.matchsize  = sizeof(struct xt_u32),
-		.me         = THIS_MODULE,
-	},
-	{
-		.name       = "u32",
-		.family     = AF_INET6,
-		.match      = u32_mt,
-		.matchsize  = sizeof(struct xt_u32),
-		.me         = THIS_MODULE,
-	},
+static struct xt_match xt_u32_mt_reg __read_mostly = {
+	.name       = "u32",
+	.revision   = 0,
+	.family     = AF_UNSPEC,
+	.match      = u32_mt,
+	.matchsize  = sizeof(struct xt_u32),
+	.me         = THIS_MODULE,
 };
 
 static int __init u32_mt_init(void)
 {
-	return xt_register_matches(u32_mt_reg, ARRAY_SIZE(u32_mt_reg));
+	return xt_register_match(&xt_u32_mt_reg);
 }
 
 static void __exit u32_mt_exit(void)
 {
-	xt_unregister_matches(u32_mt_reg, ARRAY_SIZE(u32_mt_reg));
+	xt_unregister_match(&xt_u32_mt_reg);
 }
 
 module_init(u32_mt_init);
