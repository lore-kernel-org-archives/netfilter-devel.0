From: pablo@netfilter.org
Subject: [PATCH 1/7] netfilter: nf_tables: nft_compat: release cached matches/targets
Date: Thu, 10 Jan 2013 16:28:35 +0100
Message-ID: <1357831721-10182-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, tomasz.bursztyka@linux.intel.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37131 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753679Ab3AJP24 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Jan 2013 10:28:56 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

Release existing targets/matches that are cached in our lists.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_compat.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 328abf1..416c89e 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -517,6 +517,14 @@ nft_match_select_ops(const struct nft_ctx *ctx,
 	return &nft_match->ops;
 }
 
+static void nft_match_release(void)
+{
+	struct nft_xt *nft_match;
+
+	list_for_each_entry(nft_match, &nft_match_list, head)
+		kfree(nft_match);
+}
+
 static struct nft_expr_type nft_match_type __read_mostly = {
 	.name		= "match",
 	.select_ops	= nft_match_select_ops,
@@ -579,6 +587,14 @@ nft_target_select_ops(const struct nft_ctx *ctx,
 	return &nft_target->ops;
 }
 
+static void nft_target_release(void)
+{
+	struct nft_xt *nft_target;
+
+	list_for_each_entry(nft_target, &nft_target_list, head)
+		kfree(nft_target);
+}
+
 static struct nft_expr_type nft_target_type __read_mostly = {
 	.name		= "target",
 	.select_ops	= nft_target_select_ops,
@@ -621,6 +637,8 @@ void nft_compat_module_exit(void)
 	nfnetlink_subsys_unregister(&nfnl_compat_subsys);
 	nft_unregister_expr(&nft_target_type);
 	nft_unregister_expr(&nft_match_type);
+	nft_match_release();
+	nft_target_release();
 }
 
 MODULE_ALIAS_NFNL_SUBSYS(NFNL_SUBSYS_NFTA_COMPAT);
-- 
1.7.10.4

