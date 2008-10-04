From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 16/16] [NETFILTER]: Use NFPROTO_UNSPEC in more extensions
Date: Sat,  4 Oct 2008 15:41:30 -0400
Message-ID: <9bbaaef073c73a41cd50ac0bd88344f87e412685.1223149287.git.jengelh@medozas.de>
References: <67e1140a1db2e8aa9a4b6c80289039487c5445cb.1223149287.git.jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:34314 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505AbYJDTlh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 4 Oct 2008 15:41:37 -0400
In-Reply-To: <67e1140a1db2e8aa9a4b6c80289039487c5445cb.1223149287.git.jengelh@medozas.de>
In-Reply-To: <67e1140a1db2e8aa9a4b6c80289039487c5445cb.1223149287.git.jengelh@medozas.de>
References: <67e1140a1db2e8aa9a4b6c80289039487c5445cb.1223149287.git.jengelh@medozas.de>
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
index 3af5b86..0af27eb 100644
--- a/net/netfilter/xt_MARK.c
+++ b/net/netfilter/xt_MARK.c
@@ -148,7 +148,7 @@ static int mark_tg_compat_to_user_v1(void __user *dst, void *src)
 static struct xt_target mark_tg_reg[] __read_mostly = {
 	{
 		.name		= "MARK",
-		.family		= NFPROTO_IPV4,
+		.family		= NFPROTO_UNSPEC,
 		.revision	= 0,
 		.checkentry	= mark_tg_check_v0,
 		.target		= mark_tg_v0,
@@ -163,37 +163,7 @@ static struct xt_target mark_tg_reg[] __read_mostly = {
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
index c126917..3a8caa5 100644
--- a/net/netfilter/xt_NOTRACK.c
+++ b/net/netfilter/xt_NOTRACK.c
@@ -30,31 +30,23 @@ notrack_tg(struct sk_buff *skb, struct xt_target_param *par)
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
index 0de1207..8cc924b 100644
--- a/net/netfilter/xt_comment.c
+++ b/net/netfilter/xt_comment.c
@@ -21,31 +21,23 @@ static bool comment_mt(const struct sk_buff *skb, struct xt_match_param *par)
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
index 045e0f4..91daf9b 100644
--- a/net/netfilter/xt_mac.c
+++ b/net/netfilter/xt_mac.c
@@ -36,37 +36,25 @@ static bool mac_mt(const struct sk_buff *skb, struct xt_match_param *par)
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
index 3e40d77..daed915 100644
--- a/net/netfilter/xt_owner.c
+++ b/net/netfilter/xt_owner.c
@@ -157,17 +157,7 @@ static struct xt_match owner_mt_reg[] __read_mostly = {
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
index 072e8fd..60ccc43 100644
--- a/net/netfilter/xt_physdev.c
+++ b/net/netfilter/xt_physdev.c
@@ -111,33 +111,24 @@ static bool physdev_mt_check(struct xt_mtchk_param *par)
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
index ad0f15a..6fe1bec 100644
--- a/net/netfilter/xt_realm.c
+++ b/net/netfilter/xt_realm.c
@@ -35,7 +35,7 @@ static struct xt_match realm_mt_reg __read_mostly = {
 	.matchsize	= sizeof(struct xt_realm_info),
 	.hooks		= (1 << NF_INET_POST_ROUTING) | (1 << NF_INET_FORWARD) |
 			  (1 << NF_INET_LOCAL_OUT) | (1 << NF_INET_LOCAL_IN),
-	.family		= NFPROTO_IPV4,
+	.family		= NFPROTO_UNSPEC,
 	.me		= THIS_MODULE
 };
 
-- 
1.6.0.1

