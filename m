Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47052C4332F
	for <netfilter-devel@archiver.kernel.org>; Wed, 12 Jan 2022 00:34:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236299AbiALAeO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 11 Jan 2022 19:34:14 -0500
Received: from mail.netfilter.org ([217.70.188.207]:47920 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343931AbiALAeO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 11 Jan 2022 19:34:14 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 830386468F
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Jan 2022 01:31:22 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 3/4] cache: add helper function to fill up the rule cache
Date:   Wed, 12 Jan 2022 01:34:00 +0100
Message-Id: <20220112003401.332999-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220112003401.332999-1-pablo@netfilter.org>
References: <20220112003401.332999-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add a helper function to dump the rules and add them to the
corresponding chain.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/cache.c | 41 +++++++++++++++++++++++++----------------
 1 file changed, 25 insertions(+), 16 deletions(-)

diff --git a/src/cache.c b/src/cache.c
index 0e9e7fe5381d..14957f2de3a9 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -474,7 +474,7 @@ static int list_rule_cb(struct nftnl_rule *nlr, void *data)
 	return 0;
 }
 
-static int rule_cache_init(struct netlink_ctx *ctx, const struct handle *h,
+static int rule_cache_dump(struct netlink_ctx *ctx, const struct handle *h,
 			   const struct nft_cache_filter *filter)
 {
 	struct nftnl_rule_list *rule_cache;
@@ -811,6 +811,29 @@ static int cache_init_tables(struct netlink_ctx *ctx, struct handle *h,
 	return 0;
 }
 
+static int rule_init_cache(struct netlink_ctx *ctx, struct table *table,
+			   const struct nft_cache_filter *filter)
+{
+	struct rule *rule, *nrule;
+	struct chain *chain;
+	int ret;
+
+	ret = rule_cache_dump(ctx, &table->handle, filter);
+
+	list_for_each_entry_safe(rule, nrule, &ctx->list, list) {
+		chain = chain_cache_find(table, rule->handle.chain.name);
+		if (!chain)
+			chain = chain_binding_lookup(table,
+						     rule->handle.chain.name);
+		if (!chain)
+			return -1;
+
+		list_move_tail(&rule->list, &chain->rules);
+	}
+
+	return ret;
+}
+
 static int cache_init_objects(struct netlink_ctx *ctx, unsigned int flags,
 			      const struct nft_cache_filter *filter)
 {
@@ -818,9 +841,7 @@ static int cache_init_objects(struct netlink_ctx *ctx, unsigned int flags,
 	struct nftnl_chain_list *chain_list = NULL;
 	struct nftnl_set_list *set_list = NULL;
 	struct nftnl_obj_list *obj_list;
-	struct rule *rule, *nrule;
 	struct table *table;
-	struct chain *chain;
 	struct set *set;
 	int ret = 0;
 
@@ -902,19 +923,7 @@ static int cache_init_objects(struct netlink_ctx *ctx, unsigned int flags,
 		}
 
 		if (flags & NFT_CACHE_RULE_BIT) {
-			ret = rule_cache_init(ctx, &table->handle, filter);
-			list_for_each_entry_safe(rule, nrule, &ctx->list, list) {
-				chain = chain_cache_find(table, rule->handle.chain.name);
-				if (!chain)
-					chain = chain_binding_lookup(table,
-							rule->handle.chain.name);
-				if (!chain) {
-					ret = -1;
-					goto cache_fails;
-				}
-
-				list_move_tail(&rule->list, &chain->rules);
-			}
+			ret = rule_init_cache(ctx, table, filter);
 			if (ret < 0)
 				goto cache_fails;
 		}
-- 
2.30.2

