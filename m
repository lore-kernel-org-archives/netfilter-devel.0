Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1FC7C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Sep 2021 23:09:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A04F860F46
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Sep 2021 23:09:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235587AbhINXLL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 19:11:11 -0400
Received: from mail.netfilter.org ([217.70.188.207]:55456 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235884AbhINXLH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 19:11:07 -0400
Received: from localhost.localdomain (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id D034B6000C;
        Wed, 15 Sep 2021 01:08:35 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de
Subject: [PATCH nft] src: revert hashtable for expression handlers
Date:   Wed, 15 Sep 2021 01:09:43 +0200
Message-Id: <20210914230943.31354-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Partially revert 913979f882d1 ("src: add expression handler hashtable")
which is causing a crash with two instances of the nftables handler.

$ sudo python
[sudo] password for echerkashin:
Python 3.9.7 (default, Sep  3 2021, 06:18:44)
[GCC 11.2.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> from nftables import Nftables
>>> n1=Nftables()
>>> n2=Nftables()
>>> <Ctrl-D>
double free or corruption (top)
Aborted

Reported-by: Eugene Crosser <crosser@average.org>
Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/netlink.h         |  3 ---
 src/libnftables.c         |  2 --
 src/netlink_delinearize.c | 40 ++++++++++-----------------------------
 3 files changed, 10 insertions(+), 35 deletions(-)

diff --git a/include/netlink.h b/include/netlink.h
index 0c8655ca19cf..2467ff82a520 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -215,9 +215,6 @@ int netlink_events_trace_cb(const struct nlmsghdr *nlh, int type,
 
 enum nft_data_types dtype_map_to_kernel(const struct datatype *dtype);
 
-void expr_handler_init(void);
-void expr_handler_exit(void);
-
 void netlink_linearize_init(struct netlink_linearize_ctx *lctx,
 			    struct nftnl_rule *nlr);
 void netlink_linearize_fini(struct netlink_linearize_ctx *lctx);
diff --git a/src/libnftables.c b/src/libnftables.c
index aa6493aae119..fc52fbc35d21 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -106,13 +106,11 @@ static void nft_init(struct nft_ctx *ctx)
 	realm_table_rt_init(ctx);
 	devgroup_table_init(ctx);
 	ct_label_table_init(ctx);
-	expr_handler_init();
 }
 
 static void nft_exit(struct nft_ctx *ctx)
 {
 	cache_free(&ctx->cache.table_cache);
-	expr_handler_exit();
 	ct_label_table_exit(ctx);
 	realm_table_rt_exit(ctx);
 	devgroup_table_exit(ctx);
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index f2207ea1d43e..bd75ad5cbe1e 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1750,46 +1750,26 @@ static const struct expr_handler netlink_parsers[] = {
 	{ .name = "synproxy",	.parse = netlink_parse_synproxy },
 };
 
-static const struct expr_handler **expr_handle_ht;
-
-#define NFT_EXPR_HSIZE	4096
-
-void expr_handler_init(void)
-{
-	unsigned int i;
-	uint32_t hash;
-
-	expr_handle_ht = xzalloc_array(NFT_EXPR_HSIZE,
-				       sizeof(expr_handle_ht[0]));
-
-	for (i = 0; i < array_size(netlink_parsers); i++) {
-		hash = djb_hash(netlink_parsers[i].name) % NFT_EXPR_HSIZE;
-		assert(expr_handle_ht[hash] == NULL);
-		expr_handle_ht[hash] = &netlink_parsers[i];
-	}
-}
-
-void expr_handler_exit(void)
-{
-	xfree(expr_handle_ht);
-}
-
 static int netlink_parse_expr(const struct nftnl_expr *nle,
 			      struct netlink_parse_ctx *ctx)
 {
 	const char *type = nftnl_expr_get_str(nle, NFTNL_EXPR_NAME);
 	struct location loc;
-	uint32_t hash;
+	unsigned int i;
 
 	memset(&loc, 0, sizeof(loc));
 	loc.indesc = &indesc_netlink;
 	loc.nle = nle;
 
-	hash = djb_hash(type) % NFT_EXPR_HSIZE;
-	if (expr_handle_ht[hash])
-		expr_handle_ht[hash]->parse(ctx, &loc, nle);
-	else
-		netlink_error(ctx, &loc, "unknown expression type '%s'", type);
+	for (i = 0; i < array_size(netlink_parsers); i++) {
+		if (strcmp(type, netlink_parsers[i].name))
+			continue;
+
+		netlink_parsers[i].parse(ctx, &loc, nle);
+
+		return 0;
+	}
+	netlink_error(ctx, &loc, "unknown expression type '%s'", type);
 
 	return 0;
 }
-- 
2.20.1

