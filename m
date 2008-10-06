From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 22/23] netfilter: xtables: use NFPROTO_UNSPEC in more extensions
Date: Mon,  6 Oct 2008 08:15:25 -0400
Message-ID: <13992bcb338f0044010a1809f24d2198b5bd91c8.1223294924.git.jengelh@medozas.de>
References: <1223295326-10890-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:57115 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086AbYJFMPd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Oct 2008 08:15:33 -0400
In-Reply-To: <1223295326-10890-1-git-send-email-jengelh@medozas.de>
In-Reply-To: <0a71cdb22ae4ae9ad9c49cab82cc41ccdd5653a1.1223294924.git.jengelh@medozas.de>
References: <0a71cdb22ae4ae9ad9c49cab82cc41ccdd5653a1.1223294924.git.jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Lots of extensions are completely family-independent, so squash some code.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/netfilter/xt_MARK.c    |   34 ++--------------------------------
 net/netfilter/xt_NOTRACK.c |   26 +++++++++-----------------
 net/netfilter/xt_comment.c |   26 +++++++++-----------------
 net/netfilter/xt_mac.c     |   34 +++++++++++-----------------------
 net/netfilter/xt_owner.c   |   12 +-----------
 net/netfilter/xt_physdev.c |   29 ++++++++++-------------------
 net/netfilter/xt_realm.c   |    2 +-
 7 files changed, 43 insertions(+), 120 deletions(-)

diff --git a/net/netfilter/xt_MARK.c b/net/netfilter/xt_MARK.c
index 123ee0b..67574bc 100644
--- a/net/netfilter/xt_MARK.c
+++ b/net/netfilter/xt_MARK.c
@@ -149,7 +149,7 @@ static int mark_tg_compat_to_user_v1(void __user *dst, void *src)
 static struct xt_target mark_tg_reg[] __read_mostly = {
 	{
 		.name		= "MARK",
-		.family		= NFPROTO_IPV4,
+		.family		= NFPROTO_UNSPEC,
 		.revision	= 0,
 		.checkentry	= mark_tg_check_v0,
 		.target		= mark_tg_v0,
@@ -164,37 +164,7 @@ static struct xt_target mark_tg_reg[] __read_mostly = {
 	},
 	{
 		.name		= "MARK",
-		.family		= NFPROTO_IPV4,
-		.revision	= 1,
-		.checkentry	= mark_tg_check_v1,
-		.target		= mark_tg_v1,
-		.targetsize	= sizeof(struct xt_mark_target_info_v1),
-#ifdef CONFIG_COMPAT
-		.compatsize	= sizeof(struct compat_xt_mark_target_info_v1),
-		.compat_from_user = mark_tg_compat_from_user_v1,
-		.compat_to_user	= mark_tg_compat_to_user_v1,
-#endif
-		.table		= "mangle",
-		.me		= THIS_MODULE,
-	},
-	{
-		.name		= "MARK",
-		.family		= NFPROTO_IPV6,
-		.revision	= 0,
-		.checkentry	= mark_tg_check_v0,
-		.target		= mark_tg_v0,
-		.targetsize	= sizeof(struct xt_mark_target_info),
-#ifdef CONFIG_COMPAT
-		.compatsize	= sizeof(struct compat_xt_mark_target_info),
-		.compat_from_user = mark_tg_compat_from_user_v0,
-		.compat_to_user	= mark_tg_compat_to_user_v0,
-#endif
-		.table		= "mangle",
-		.me		= THIS_MODULE,
-	},
-	{
-		.name		= "MARK",
-		.family		= NFPROTO_IPV6,
+		.family		= NFPROTO_UNSPEC,
 		.revision	= 1,
 		.checkentry	= mark_tg_check_v1,
 		.target		= mark_tg_v1,
diff --git a/net/netfilter/xt_NOTRACK.c b/net/netfilter/xt_NOTRACK.c
index cc50295..e7a0a54 100644
--- a/net/netfilter/xt_NOTRACK.c
+++ b/net/netfilter/xt_NOTRACK.c
@@ -30,31 +30,23 @@ notrack_tg(struct sk_buff *skb, const struct xt_target_param *par)
 	return XT_CONTINUE;
 }
 
-static struct xt_target notrack_tg_reg[] __read_mostly = {
-	{
-		.name		= "NOTRACK",
-		.family		= NFPROTO_IPV4,
-		.target		= notrack_tg,
-		.table		= "raw",
-		.me		= THIS_MODULE,
-	},
-	{
-		.name		= "NOTRACK",
-		.family		= NFPROTO_IPV6,
-		.target		= notrack_tg,
-		.table		= "raw",
-		.me		= THIS_MODULE,
-	},
+static struct xt_target notrack_tg_reg __read_mostly = {
+	.name     = "NOTRACK",
+	.revision = 0,
+	.family   = NFPROTO_UNSPEC,
+	.target   = notrack_tg,
+	.table    = "raw",
+	.me       = THIS_MODULE,
 };
 
 static int __init notrack_tg_init(void)
 {
-	return xt_register_targets(notrack_tg_reg, ARRAY_SIZE(notrack_tg_reg));
+	return xt_register_target(&notrack_tg_reg);
 }
 
 static void __exit notrack_tg_exit(void)
 {
-	xt_unregister_targets(notrack_tg_reg, ARRAY_SIZE(notrack_tg_reg));
+	xt_unregister_target(&notrack_tg_reg);
 }
 
 module_init(notrack_tg_init);
diff --git a/net/netfilter/xt_comment.c b/net/netfilter/xt_comment.c
index bd7aa57..e821798 100644
--- a/net/netfilter/xt_comment.c
+++ b/net/netfilter/xt_comment.c
@@ -22,31 +22,23 @@ comment_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	return true;
 }
 
-static struct xt_match comment_mt_reg[] __read_mostly = {
-	{
-		.name		= "comment",
-		.family		= NFPROTO_IPV4,
-		.match		= comment_mt,
-		.matchsize	= sizeof(struct xt_comment_info),
-		.me		= THIS_MODULE
-	},
-	{
-		.name		= "comment",
-		.family		= NFPROTO_IPV6,
-		.match		= comment_mt,
-		.matchsize	= sizeof(struct xt_comment_info),
-		.me		= THIS_MODULE
-	},
+static struct xt_match comment_mt_reg __read_mostly = {
+	.name      = "comment",
+	.revision  = 0,
+	.family    = NFPROTO_UNSPEC,
+	.match     = comment_mt,
+	.matchsize = sizeof(struct xt_comment_info),
+	.me        = THIS_MODULE,
 };
 
 static int __init comment_mt_init(void)
 {
-	return xt_register_matches(comment_mt_reg, ARRAY_SIZE(comment_mt_reg));
+	return xt_register_match(&comment_mt_reg);
 }
 
 static void __exit comment_mt_exit(void)
 {
-	xt_unregister_matches(comment_mt_reg, ARRAY_SIZE(comment_mt_reg));
+	xt_unregister_match(&comment_mt_reg);
 }
 
 module_init(comment_mt_init);
diff --git a/net/netfilter/xt_mac.c b/net/netfilter/xt_mac.c
index 269f9d8..c200711 100644
--- a/net/netfilter/xt_mac.c
+++ b/net/netfilter/xt_mac.c
@@ -36,37 +36,25 @@ static bool mac_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 		^ info->invert);
 }
 
-static struct xt_match mac_mt_reg[] __read_mostly = {
-	{
-		.name		= "mac",
-		.family		= NFPROTO_IPV4,
-		.match		= mac_mt,
-		.matchsize	= sizeof(struct xt_mac_info),
-		.hooks		= (1 << NF_INET_PRE_ROUTING) |
-				  (1 << NF_INET_LOCAL_IN) |
-				  (1 << NF_INET_FORWARD),
-		.me		= THIS_MODULE,
-	},
-	{
-		.name		= "mac",
-		.family		= NFPROTO_IPV6,
-		.match		= mac_mt,
-		.matchsize	= sizeof(struct xt_mac_info),
-		.hooks		= (1 << NF_INET_PRE_ROUTING) |
-				  (1 << NF_INET_LOCAL_IN) |
-				  (1 << NF_INET_FORWARD),
-		.me		= THIS_MODULE,
-	},
+static struct xt_match mac_mt_reg __read_mostly = {
+	.name      = "mac",
+	.revision  = 0,
+	.family    = NFPROTO_UNSPEC,
+	.match     = mac_mt,
+	.matchsize = sizeof(struct xt_mac_info),
+	.hooks     = (1 << NF_INET_PRE_ROUTING) | (1 << NF_INET_LOCAL_IN) |
+	             (1 << NF_INET_FORWARD),
+	.me        = THIS_MODULE,
 };
 
 static int __init mac_mt_init(void)
 {
-	return xt_register_matches(mac_mt_reg, ARRAY_SIZE(mac_mt_reg));
+	return xt_register_match(&mac_mt_reg);
 }
 
 static void __exit mac_mt_exit(void)
 {
-	xt_unregister_matches(mac_mt_reg, ARRAY_SIZE(mac_mt_reg));
+	xt_unregister_match(&mac_mt_reg);
 }
 
 module_init(mac_mt_init);
diff --git a/net/netfilter/xt_owner.c b/net/netfilter/xt_owner.c
index 32f84e8..f19ebd9 100644
--- a/net/netfilter/xt_owner.c
+++ b/net/netfilter/xt_owner.c
@@ -160,17 +160,7 @@ static struct xt_match owner_mt_reg[] __read_mostly = {
 	{
 		.name       = "owner",
 		.revision   = 1,
-		.family     = NFPROTO_IPV4,
-		.match      = owner_mt,
-		.matchsize  = sizeof(struct xt_owner_match_info),
-		.hooks      = (1 << NF_INET_LOCAL_OUT) |
-		              (1 << NF_INET_POST_ROUTING),
-		.me         = THIS_MODULE,
-	},
-	{
-		.name       = "owner",
-		.revision   = 1,
-		.family     = NFPROTO_IPV6,
+		.family     = NFPROTO_UNSPEC,
 		.match      = owner_mt,
 		.matchsize  = sizeof(struct xt_owner_match_info),
 		.hooks      = (1 << NF_INET_LOCAL_OUT) |
diff --git a/net/netfilter/xt_physdev.c b/net/netfilter/xt_physdev.c
index b01786d..1bcdfc1 100644
--- a/net/netfilter/xt_physdev.c
+++ b/net/netfilter/xt_physdev.c
@@ -112,33 +112,24 @@ static bool physdev_mt_check(const struct xt_mtchk_param *par)
 	return true;
 }
 
-static struct xt_match physdev_mt_reg[] __read_mostly = {
-	{
-		.name		= "physdev",
-		.family		= NFPROTO_IPV4,
-		.checkentry	= physdev_mt_check,
-		.match		= physdev_mt,
-		.matchsize	= sizeof(struct xt_physdev_info),
-		.me		= THIS_MODULE,
-	},
-	{
-		.name		= "physdev",
-		.family		= NFPROTO_IPV6,
-		.checkentry	= physdev_mt_check,
-		.match		= physdev_mt,
-		.matchsize	= sizeof(struct xt_physdev_info),
-		.me		= THIS_MODULE,
-	},
+static struct xt_match physdev_mt_reg __read_mostly = {
+	.name       = "physdev",
+	.revision   = 0,
+	.family     = NFPROTO_UNSPEC,
+	.checkentry = physdev_mt_check,
+	.match      = physdev_mt,
+	.matchsize  = sizeof(struct xt_physdev_info),
+	.me         = THIS_MODULE,
 };
 
 static int __init physdev_mt_init(void)
 {
-	return xt_register_matches(physdev_mt_reg, ARRAY_SIZE(physdev_mt_reg));
+	return xt_register_match(&physdev_mt_reg);
 }
 
 static void __exit physdev_mt_exit(void)
 {
-	xt_unregister_matches(physdev_mt_reg, ARRAY_SIZE(physdev_mt_reg));
+	xt_unregister_match(&physdev_mt_reg);
 }
 
 module_init(physdev_mt_init);
diff --git a/net/netfilter/xt_realm.c b/net/netfilter/xt_realm.c
index b259421..6741928 100644
--- a/net/netfilter/xt_realm.c
+++ b/net/netfilter/xt_realm.c
@@ -36,7 +36,7 @@ static struct xt_match realm_mt_reg __read_mostly = {
 	.matchsize	= sizeof(struct xt_realm_info),
 	.hooks		= (1 << NF_INET_POST_ROUTING) | (1 << NF_INET_FORWARD) |
 			  (1 << NF_INET_LOCAL_OUT) | (1 << NF_INET_LOCAL_IN),
-	.family		= NFPROTO_IPV4,
+	.family		= NFPROTO_UNSPEC,
 	.me		= THIS_MODULE
 };
 
-- 
1.6.0.1

