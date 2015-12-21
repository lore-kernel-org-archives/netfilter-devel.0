From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/2] netfilter: prepare xt_cgroup for multi revisions
Date: Mon, 21 Dec 2015 16:53:02 -0500
Message-ID: <20151221215302.GT4026@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yk0-f180.google.com ([209.85.160.180]:34905 "EHLO
	mail-yk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbbLUVxF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Dec 2015 16:53:05 -0500
Received: by mail-yk0-f180.google.com with SMTP id v6so144522888ykc.2
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Dec 2015 13:53:04 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

xt_cgroup will grow cgroup2 path based match.  Postfix existing
symbols with _v0 and prepare for multi revision registration.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Daniel Wagner <daniel.wagner@bmw-carit.de>
CC: Neil Horman <nhorman@tuxdriver.com>
Cc: Jan Engelhardt <jengelh@inai.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
---
Hello,

This is the userspace part of cgroup2 support in xt_cgroup.

 http://lkml.kernel.org/g/1449527935-27056-1-git-send-email-tj@kernel.org

Thanks.

 include/uapi/linux/netfilter/xt_cgroup.h |    2 -
 net/netfilter/xt_cgroup.c                |   36 ++++++++++++++++---------------
 2 files changed, 20 insertions(+), 18 deletions(-)

--- a/include/uapi/linux/netfilter/xt_cgroup.h
+++ b/include/uapi/linux/netfilter/xt_cgroup.h
@@ -3,7 +3,7 @@
 
 #include <linux/types.h>
 
-struct xt_cgroup_info {
+struct xt_cgroup_info_v0 {
 	__u32 id;
 	__u32 invert;
 };
--- a/net/netfilter/xt_cgroup.c
+++ b/net/netfilter/xt_cgroup.c
@@ -24,9 +24,9 @@ MODULE_DESCRIPTION("Xtables: process con
 MODULE_ALIAS("ipt_cgroup");
 MODULE_ALIAS("ip6t_cgroup");
 
-static int cgroup_mt_check(const struct xt_mtchk_param *par)
+static int cgroup_mt_check_v0(const struct xt_mtchk_param *par)
 {
-	struct xt_cgroup_info *info = par->matchinfo;
+	struct xt_cgroup_info_v0 *info = par->matchinfo;
 
 	if (info->invert & ~1)
 		return -EINVAL;
@@ -35,9 +35,9 @@ static int cgroup_mt_check(const struct
 }
 
 static bool
-cgroup_mt(const struct sk_buff *skb, struct xt_action_param *par)
+cgroup_mt_v0(const struct sk_buff *skb, struct xt_action_param *par)
 {
-	const struct xt_cgroup_info *info = par->matchinfo;
+	const struct xt_cgroup_info_v0 *info = par->matchinfo;
 
 	if (skb->sk == NULL || !sk_fullsock(skb->sk))
 		return false;
@@ -46,27 +46,29 @@ cgroup_mt(const struct sk_buff *skb, str
 		info->invert;
 }
 
-static struct xt_match cgroup_mt_reg __read_mostly = {
-	.name       = "cgroup",
-	.revision   = 0,
-	.family     = NFPROTO_UNSPEC,
-	.checkentry = cgroup_mt_check,
-	.match      = cgroup_mt,
-	.matchsize  = sizeof(struct xt_cgroup_info),
-	.me         = THIS_MODULE,
-	.hooks      = (1 << NF_INET_LOCAL_OUT) |
-		      (1 << NF_INET_POST_ROUTING) |
-		      (1 << NF_INET_LOCAL_IN),
+static struct xt_match cgroup_mt_reg[] __read_mostly = {
+	{
+		.name		= "cgroup",
+		.revision	= 0,
+		.family		= NFPROTO_UNSPEC,
+		.checkentry	= cgroup_mt_check_v0,
+		.match		= cgroup_mt_v0,
+		.matchsize	= sizeof(struct xt_cgroup_info_v0),
+		.me		= THIS_MODULE,
+		.hooks		= (1 << NF_INET_LOCAL_OUT) |
+				  (1 << NF_INET_POST_ROUTING) |
+				  (1 << NF_INET_LOCAL_IN),
+	},
 };
 
 static int __init cgroup_mt_init(void)
 {
-	return xt_register_match(&cgroup_mt_reg);
+	return xt_register_matches(cgroup_mt_reg, ARRAY_SIZE(cgroup_mt_reg));
 }
 
 static void __exit cgroup_mt_exit(void)
 {
-	xt_unregister_match(&cgroup_mt_reg);
+	xt_unregister_matches(cgroup_mt_reg, ARRAY_SIZE(cgroup_mt_reg));
 }
 
 module_init(cgroup_mt_init);
