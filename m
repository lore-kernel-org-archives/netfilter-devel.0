From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 08/13] [NETFILTER]: Implement NFPROTO_UNSPEC as a wildcard for extensions
Date: Wed, 16 Apr 2008 17:31:00 +0200
Message-ID: <bf3843a985c114eacad10116632869a7e51ab632.1208359825.git.jengelh@computergmbh.de>
References: <1208359865-3022-1-git-send-email-jengelh@computergmbh.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38087 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761056AbYDPPbJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Apr 2008 11:31:09 -0400
In-Reply-To: <1208359865-3022-1-git-send-email-jengelh@computergmbh.de>
In-Reply-To: <540dfb29c6c573830cbde9bf579ddef33657ed20.1208359825.git.jengelh@computergmbh.de>
References: <540dfb29c6c573830cbde9bf579ddef33657ed20.1208359825.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When a match or target is looked up using xt_find_{match,target},
Xtables will also search the NFPROTO_UNSPEC module list. This allows
for protocol-independent extensions (like xt_time) to be reused from
other components (e.g. arptables, ebtables).

Extensions that take different codepaths depending on match->family
or target->family of course cannot use NFPROTO_UNSPEC within the
registration structure (e.g. xt_pkttype).

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
---
 net/netfilter/x_tables.c     |   10 ++++++++
 net/netfilter/xt_CLASSIFY.c  |   38 ++++++++++----------------------
 net/netfilter/xt_MARK.c      |   10 +-------
 net/netfilter/xt_RATEEST.c   |   33 +++++++++------------------
 net/netfilter/xt_SECMARK.c   |   35 ++++++++++-------------------
 net/netfilter/xt_TRACE.c     |   26 +++++++--------------
 net/netfilter/xt_limit.c     |   40 +++++++++++-----------------------
 net/netfilter/xt_mark.c      |   26 +--------------------
 net/netfilter/xt_quota.c     |   29 ++++++++----------------
 net/netfilter/xt_rateest.c   |   33 +++++++++------------------
 net/netfilter/xt_statistic.c |   31 ++++++++-----------------
 net/netfilter/xt_string.c    |   32 +++++++++-----------------
 net/netfilter/xt_time.c      |   28 +++++++----------------
 net/netfilter/xt_u32.c       |   26 +++++++--------------
 14 files changed, 130 insertions(+), 267 deletions(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index f44bcc3..5053e19 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -209,6 +209,11 @@ struct xt_match *xt_find_match(u_int8_t af, const char *name, u8 revision)
 		}
 	}
 	mutex_unlock(&xt[af].mutex);
+
+	if (af != NFPROTO_UNSPEC)
+		/* Try searching again in the family-independent list */
+		return xt_find_match(NFPROTO_UNSPEC, name, revision);
+
 	return ERR_PTR(err);
 }
 EXPORT_SYMBOL(xt_find_match);
@@ -234,6 +239,11 @@ struct xt_target *xt_find_target(u_int8_t af, const char *name, u8 revision)
 		}
 	}
 	mutex_unlock(&xt[af].mutex);
+
+	if (af != NFPROTO_UNSPEC)
+		/* Try searching again in the family-independent list */
+		return xt_find_target(NFPROTO_UNSPEC, name, revision);
+
 	return ERR_PTR(err);
 }
 EXPORT_SYMBOL(xt_find_target);
diff --git a/net/netfilter/xt_CLASSIFY.c b/net/netfilter/xt_CLASSIFY.c
index 9d68da1..8cffa29 100644
--- a/net/netfilter/xt_CLASSIFY.c
+++ b/net/netfilter/xt_CLASSIFY.c
@@ -37,40 +37,26 @@ classify_tg(struct sk_buff *skb, const struct net_device *in,
 	return XT_CONTINUE;
 }
 
-static struct xt_target classify_tg_reg[] __read_mostly = {
-	{
-		.family		= NFPROTO_IPV4,
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
-		.family		= NFPROTO_IPV6,
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
+	.family     = NFPROTO_UNSPEC,
+	.table      = "mangle",
+	.hooks      = (1 << NF_INET_LOCAL_OUT) | (1 << NF_INET_FORWARD) |
+		      (1 << NF_INET_POST_ROUTING),
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
index 55ef079..c8ea7a8 100644
--- a/net/netfilter/xt_MARK.c
+++ b/net/netfilter/xt_MARK.c
@@ -222,15 +222,7 @@ static struct xt_target mark_tg_reg[] __read_mostly = {
 	{
 		.name           = "MARK",
 		.revision       = 2,
-		.family         = NFPROTO_IPV4,
-		.target         = mark_tg,
-		.targetsize     = sizeof(struct xt_mark_tginfo2),
-		.me             = THIS_MODULE,
-	},
-	{
-		.name           = "MARK",
-		.revision       = 2,
-		.family         = NFPROTO_IPV6,
+		.family         = NFPROTO_UNSPEC,
 		.target         = mark_tg,
 		.targetsize     = sizeof(struct xt_mark_tginfo2),
 		.me             = THIS_MODULE,
diff --git a/net/netfilter/xt_RATEEST.c b/net/netfilter/xt_RATEEST.c
index f7114fc..da7946e 100644
--- a/net/netfilter/xt_RATEEST.c
+++ b/net/netfilter/xt_RATEEST.c
@@ -157,25 +157,15 @@ static void xt_rateest_tg_destroy(const struct xt_target *target,
 	xt_rateest_put(info->est);
 }
 
-static struct xt_target xt_rateest_target[] __read_mostly = {
-	{
-		.family		= NFPROTO_IPV4,
-		.name		= "RATEEST",
-		.target		= xt_rateest_tg,
-		.checkentry	= xt_rateest_tg_checkentry,
-		.destroy	= xt_rateest_tg_destroy,
-		.targetsize	= sizeof(struct xt_rateest_target_info),
-		.me		= THIS_MODULE,
-	},
-	{
-		.family		= NFPROTO_IPV6,
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
+	.family     = NFPROTO_UNSPEC,
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
index 9995380..650f469 100644
--- a/net/netfilter/xt_SECMARK.c
+++ b/net/netfilter/xt_SECMARK.c
@@ -119,37 +119,26 @@ static void secmark_tg_destroy(const struct xt_target *target, void *targinfo)
 	}
 }
 
-static struct xt_target secmark_tg_reg[] __read_mostly = {
-	{
-		.name		= "SECMARK",
-		.family		= NFPROTO_IPV4,
-		.checkentry	= secmark_tg_check,
-		.destroy	= secmark_tg_destroy,
-		.target		= secmark_tg,
-		.targetsize	= sizeof(struct xt_secmark_target_info),
-		.table		= "mangle",
-		.me		= THIS_MODULE,
-	},
-	{
-		.name		= "SECMARK",
-		.family		= NFPROTO_IPV6,
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
+	.family     = NFPROTO_UNSPEC,
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
index e1bcad5..da35f9f 100644
--- a/net/netfilter/xt_TRACE.c
+++ b/net/netfilter/xt_TRACE.c
@@ -19,31 +19,23 @@ trace_tg(struct sk_buff *skb, const struct net_device *in,
 	return XT_CONTINUE;
 }
 
-static struct xt_target trace_tg_reg[] __read_mostly = {
-	{
-		.name		= "TRACE",
-		.family		= NFPROTO_IPV4,
-		.target		= trace_tg,
-		.table		= "raw",
-		.me		= THIS_MODULE,
-	},
-	{
-		.name		= "TRACE",
-		.family		= NFPROTO_IPV6,
-		.target		= trace_tg,
-		.table		= "raw",
-		.me		= THIS_MODULE,
-	},
+static struct xt_target trace_tg_reg __read_mostly = {
+	.name       = "TRACE",
+	.revision   = 0,
+	.family     = NFPROTO_UNSPEC,
+	.table      = "raw",
+	.target     = trace_tg,
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
index 584d668..00247bd 100644
--- a/net/netfilter/xt_limit.c
+++ b/net/netfilter/xt_limit.c
@@ -167,43 +167,29 @@ static int limit_mt_compat_to_user(void __user *dst, void *src)
 }
 #endif /* CONFIG_COMPAT */
 
-static struct xt_match limit_mt_reg[] __read_mostly = {
-	{
-		.name		= "limit",
-		.family		= NFPROTO_IPV4,
-		.checkentry	= limit_mt_check,
-		.match		= limit_mt,
-		.matchsize	= sizeof(struct xt_rateinfo),
+static struct xt_match limit_mt_reg __read_mostly = {
+	.name             = "limit",
+	.revision         = 0,
+	.family           = NFPROTO_UNSPEC,
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
-		.family		= NFPROTO_IPV6,
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
index c66affd..96dd2b6 100644
--- a/net/netfilter/xt_mark.c
+++ b/net/netfilter/xt_mark.c
@@ -92,7 +92,7 @@ static struct xt_match mark_mt_reg[] __read_mostly = {
 	{
 		.name		= "mark",
 		.revision	= 0,
-		.family		= NFPROTO_IPV4,
+		.family		= NFPROTO_UNSPEC,
 		.checkentry	= mark_mt_check_v0,
 		.match		= mark_mt_v0,
 		.matchsize	= sizeof(struct xt_mark_info),
@@ -104,31 +104,9 @@ static struct xt_match mark_mt_reg[] __read_mostly = {
 		.me		= THIS_MODULE,
 	},
 	{
-		.name		= "mark",
-		.revision	= 0,
-		.family		= NFPROTO_IPV6,
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
-		.family         = NFPROTO_IPV4,
-		.match          = mark_mt,
-		.matchsize      = sizeof(struct xt_mark_mtinfo1),
-		.me             = THIS_MODULE,
-	},
-	{
 		.name           = "mark",
 		.revision       = 1,
-		.family         = NFPROTO_IPV6,
+		.family         = NFPROTO_UNSPEC,
 		.match          = mark_mt,
 		.matchsize      = sizeof(struct xt_mark_mtinfo1),
 		.me             = THIS_MODULE,
diff --git a/net/netfilter/xt_quota.c b/net/netfilter/xt_quota.c
index 59f61e3..a3c8798 100644
--- a/net/netfilter/xt_quota.c
+++ b/net/netfilter/xt_quota.c
@@ -54,33 +54,24 @@ quota_mt_check(const char *tablename, const void *entry,
 	return true;
 }
 
-static struct xt_match quota_mt_reg[] __read_mostly = {
-	{
-		.name		= "quota",
-		.family		= NFPROTO_IPV4,
-		.checkentry	= quota_mt_check,
-		.match		= quota_mt,
-		.matchsize	= sizeof(struct xt_quota_info),
-		.me		= THIS_MODULE
-	},
-	{
-		.name		= "quota",
-		.family		= NFPROTO_IPV6,
-		.checkentry	= quota_mt_check,
-		.match		= quota_mt,
-		.matchsize	= sizeof(struct xt_quota_info),
-		.me		= THIS_MODULE
-	},
+static struct xt_match quota_mt_reg __read_mostly = {
+	.name       = "quota",
+	.revision   = 0,
+	.family     = NFPROTO_UNSPEC,
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
index ba1cb57..4dcfd73 100644
--- a/net/netfilter/xt_rateest.c
+++ b/net/netfilter/xt_rateest.c
@@ -137,36 +137,25 @@ static void xt_rateest_mt_destroy(const struct xt_match *match,
 		xt_rateest_put(info->est2);
 }
 
-static struct xt_match xt_rateest_match[] __read_mostly = {
-	{
-		.family		= NFPROTO_IPV4,
-		.name		= "rateest",
-		.match		= xt_rateest_mt,
-		.checkentry	= xt_rateest_mt_checkentry,
-		.destroy	= xt_rateest_mt_destroy,
-		.matchsize	= sizeof(struct xt_rateest_match_info),
-		.me		= THIS_MODULE,
-	},
-	{
-		.family		= NFPROTO_IPV6,
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
+	.family     = NFPROTO_UNSPEC,
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
index fd3bb14..f41a923 100644
--- a/net/netfilter/xt_statistic.c
+++ b/net/netfilter/xt_statistic.c
@@ -66,35 +66,24 @@ statistic_mt_check(const char *tablename, const void *entry,
 	return true;
 }
 
-static struct xt_match statistic_mt_reg[] __read_mostly = {
-	{
-		.name		= "statistic",
-		.family		= NFPROTO_IPV4,
-		.checkentry	= statistic_mt_check,
-		.match		= statistic_mt,
-		.matchsize	= sizeof(struct xt_statistic_info),
-		.me		= THIS_MODULE,
-	},
-	{
-		.name		= "statistic",
-		.family		= NFPROTO_IPV6,
-		.checkentry	= statistic_mt_check,
-		.match		= statistic_mt,
-		.matchsize	= sizeof(struct xt_statistic_info),
-		.me		= THIS_MODULE,
-	},
+static struct xt_match xt_statistic_mt_reg __read_mostly = {
+	.name       = "statistic",
+	.revision   = 0,
+	.family     = NFPROTO_UNSPEC,
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
index ccab407..9b92b01 100644
--- a/net/netfilter/xt_string.c
+++ b/net/netfilter/xt_string.c
@@ -69,35 +69,25 @@ static void string_mt_destroy(const struct xt_match *match, void *matchinfo)
 	textsearch_destroy(STRING_TEXT_PRIV(matchinfo)->config);
 }
 
-static struct xt_match string_mt_reg[] __read_mostly = {
-	{
-		.name 		= "string",
-		.family		= NFPROTO_IPV4,
-		.checkentry	= string_mt_check,
-		.match 		= string_mt,
-		.destroy 	= string_mt_destroy,
-		.matchsize	= sizeof(struct xt_string_info),
-		.me 		= THIS_MODULE
-	},
-	{
-		.name 		= "string",
-		.family		= NFPROTO_IPV6,
-		.checkentry	= string_mt_check,
-		.match 		= string_mt,
-		.destroy 	= string_mt_destroy,
-		.matchsize	= sizeof(struct xt_string_info),
-		.me 		= THIS_MODULE
-	},
+static struct xt_match xt_string_mt_reg __read_mostly = {
+	.name       = "string",
+	.revision   = 0,
+	.family     = NFPROTO_UNSPEC,
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
index 008f2b2..26648a1 100644
--- a/net/netfilter/xt_time.c
+++ b/net/netfilter/xt_time.c
@@ -235,33 +235,23 @@ time_mt_check(const char *tablename, const void *ip,
 	return true;
 }
 
-static struct xt_match time_mt_reg[] __read_mostly = {
-	{
-		.name       = "time",
-		.family     = NFPROTO_IPV4,
-		.match      = time_mt,
-		.matchsize  = sizeof(struct xt_time_info),
-		.checkentry = time_mt_check,
-		.me         = THIS_MODULE,
-	},
-	{
-		.name       = "time",
-		.family     = NFPROTO_IPV6,
-		.match      = time_mt,
-		.matchsize  = sizeof(struct xt_time_info),
-		.checkentry = time_mt_check,
-		.me         = THIS_MODULE,
-	},
+static struct xt_match xt_time_mt_reg __read_mostly = {
+	.name       = "time",
+	.family     = NFPROTO_UNSPEC,
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
index ed9f834..a6b971d 100644
--- a/net/netfilter/xt_u32.c
+++ b/net/netfilter/xt_u32.c
@@ -99,31 +99,23 @@ u32_mt(const struct sk_buff *skb, const struct net_device *in,
 	return ret ^ data->invert;
 }
 
-static struct xt_match u32_mt_reg[] __read_mostly = {
-	{
-		.name       = "u32",
-		.family     = NFPROTO_IPV4,
-		.match      = u32_mt,
-		.matchsize  = sizeof(struct xt_u32),
-		.me         = THIS_MODULE,
-	},
-	{
-		.name       = "u32",
-		.family     = NFPROTO_IPV6,
-		.match      = u32_mt,
-		.matchsize  = sizeof(struct xt_u32),
-		.me         = THIS_MODULE,
-	},
+static struct xt_match xt_u32_mt_reg __read_mostly = {
+	.name       = "u32",
+	.revision   = 0,
+	.family     = NFPROTO_UNSPEC,
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
-- 
1.5.5

