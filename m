Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44572C83F19
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Aug 2023 18:39:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236992AbjH3Siv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Aug 2023 14:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245423AbjH3PMr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Aug 2023 11:12:47 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A3A0C1A2
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Aug 2023 08:12:43 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/2] src: simplify chain_alloc()
Date:   Wed, 30 Aug 2023 17:12:38 +0200
Message-Id: <20230830151239.448463-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Remove parameter to set the chain name which is only used from netlink
path.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/rule.h     | 2 +-
 src/evaluate.c     | 2 +-
 src/netlink.c      | 4 +++-
 src/parser_bison.y | 2 +-
 src/parser_json.c  | 4 ++--
 src/rule.c         | 4 +---
 6 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index 8e876d0a42ed..5ceb3ae62288 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -260,7 +260,7 @@ struct chain {
 extern int std_prio_lookup(const char *std_prio_name, int family, int hook);
 extern const char *chain_type_name_lookup(const char *name);
 extern const char *chain_hookname_lookup(const char *name);
-extern struct chain *chain_alloc(const char *name);
+extern struct chain *chain_alloc(void);
 extern struct chain *chain_get(struct chain *chain);
 extern void chain_free(struct chain *chain);
 extern struct chain *chain_lookup_fuzzy(const struct handle *h,
diff --git a/src/evaluate.c b/src/evaluate.c
index b5326d7df4ba..4c23bba3fdb3 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -5005,7 +5005,7 @@ static int chain_evaluate(struct eval_ctx *ctx, struct chain *chain)
 
 	if (chain == NULL) {
 		if (!chain_cache_find(table, ctx->cmd->handle.chain.name)) {
-			chain = chain_alloc(NULL);
+			chain = chain_alloc();
 			handle_merge(&chain->handle, &ctx->cmd->handle);
 			chain_cache_add(chain, table);
 		}
diff --git a/src/netlink.c b/src/netlink.c
index 1afe162ec79b..af6fd427bd57 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -626,11 +626,13 @@ struct chain *netlink_delinearize_chain(struct netlink_ctx *ctx,
 	const char *udata;
 	uint32_t ulen;
 
-	chain = chain_alloc(nftnl_chain_get_str(nlc, NFTNL_CHAIN_NAME));
+	chain = chain_alloc();
 	chain->handle.family =
 		nftnl_chain_get_u32(nlc, NFTNL_CHAIN_FAMILY);
 	chain->handle.table.name  =
 		xstrdup(nftnl_chain_get_str(nlc, NFTNL_CHAIN_TABLE));
+	chain->handle.chain.name =
+		xstrdup(nftnl_chain_get_str(nlc, NFTNL_CHAIN_NAME));
 	chain->handle.handle.id =
 		nftnl_chain_get_u64(nlc, NFTNL_CHAIN_HANDLE);
 	if (nftnl_chain_is_set(nlc, NFTNL_CHAIN_FLAGS))
diff --git a/src/parser_bison.y b/src/parser_bison.y
index a248b335b01d..4a0c09a2912a 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -2029,7 +2029,7 @@ table_block		:	/* empty */	{ $$ = $<table>-1; }
 
 chain_block_alloc	:	/* empty */
 			{
-				$$ = chain_alloc(NULL);
+				$$ = chain_alloc();
 				if (open_scope(state, &$$->scope) < 0) {
 					erec_queue(error(&@$, "too many levels of nesting"),
 						   state->msgs);
diff --git a/src/parser_json.c b/src/parser_json.c
index 4ea5b4326a90..81497d1034b7 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -2965,7 +2965,7 @@ static struct cmd *json_parse_cmd_add_chain(struct json_ctx *ctx, json_t *root,
 		h.chain.name = xstrdup(h.chain.name);
 
 	if (comment) {
-		chain = chain_alloc(NULL);
+		chain = chain_alloc();
 		handle_merge(&chain->handle, &h);
 		chain->comment = xstrdup(comment);
 	}
@@ -2978,7 +2978,7 @@ static struct cmd *json_parse_cmd_add_chain(struct json_ctx *ctx, json_t *root,
 		return cmd_alloc(op, obj, &h, int_loc, chain);
 
 	if (!chain)
-		chain = chain_alloc(NULL);
+		chain = chain_alloc();
 
 	chain->flags |= CHAIN_F_BASECHAIN;
 	chain->type.str = xstrdup(type);
diff --git a/src/rule.c b/src/rule.c
index 35f6d8f28aee..fa4c72adab06 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -700,7 +700,7 @@ const char *chain_hookname_lookup(const char *name)
 /* internal ID to uniquely identify a set in the batch */
 static uint32_t chain_id;
 
-struct chain *chain_alloc(const char *name)
+struct chain *chain_alloc(void)
 {
 	struct chain *chain;
 
@@ -709,8 +709,6 @@ struct chain *chain_alloc(const char *name)
 	chain->handle.chain_id = ++chain_id;
 	init_list_head(&chain->rules);
 	init_list_head(&chain->scope.symbols);
-	if (name != NULL)
-		chain->handle.chain.name = xstrdup(name);
 
 	chain->policy = NULL;
 	return chain;
-- 
2.30.2

