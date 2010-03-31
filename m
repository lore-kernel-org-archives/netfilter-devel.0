From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 4/4] netfilter: xtables: merge registration structure to NFPROTO_UNSPEC
Date: Wed, 31 Mar 2010 10:03:48 +0200
Message-ID: <1270022629-2494-5-git-send-email-jengelh@medozas.de>
References: <1270022629-2494-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:40392 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757323Ab0CaID5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Mar 2010 04:03:57 -0400
In-Reply-To: <1270022629-2494-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/netfilter/xt_state.c |   31 ++++++++++---------------------
 1 files changed, 10 insertions(+), 21 deletions(-)

diff --git a/net/netfilter/xt_state.c b/net/netfilter/xt_state.c
index be00d7b..bb12718 100644
--- a/net/netfilter/xt_state.c
+++ b/net/netfilter/xt_state.c
@@ -53,35 +53,24 @@ static void state_mt_destroy(const struct xt_mtdtor_param *par)
 	nf_ct_l3proto_module_put(par->family);
 }
 
-static struct xt_match state_mt_reg[] __read_mostly = {
-	{
-		.name		= "state",
-		.family		= NFPROTO_IPV4,
-		.checkentry	= state_mt_check,
-		.match		= state_mt,
-		.destroy	= state_mt_destroy,
-		.matchsize	= sizeof(struct xt_state_info),
-		.me		= THIS_MODULE,
-	},
-	{
-		.name		= "state",
-		.family		= NFPROTO_IPV6,
-		.checkentry	= state_mt_check,
-		.match		= state_mt,
-		.destroy	= state_mt_destroy,
-		.matchsize	= sizeof(struct xt_state_info),
-		.me		= THIS_MODULE,
-	},
+static struct xt_match state_mt_reg __read_mostly = {
+	.name       = "state",
+	.family     = NFPROTO_UNSPEC,
+	.checkentry = state_mt_check,
+	.match      = state_mt,
+	.destroy    = state_mt_destroy,
+	.matchsize  = sizeof(struct xt_state_info),
+	.me         = THIS_MODULE,
 };
 
 static int __init state_mt_init(void)
 {
-	return xt_register_matches(state_mt_reg, ARRAY_SIZE(state_mt_reg));
+	return xt_register_match(&state_mt_reg);
 }
 
 static void __exit state_mt_exit(void)
 {
-	xt_unregister_matches(state_mt_reg, ARRAY_SIZE(state_mt_reg));
+	xt_unregister_match(&state_mt_reg);
 }
 
 module_init(state_mt_init);
-- 
1.7.0.2

