Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8717AC433FE
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 May 2022 18:04:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230522AbiERSEp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 May 2022 14:04:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231660AbiERSEo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 May 2022 14:04:44 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 741941A8E1E
        for <netfilter-devel@vger.kernel.org>; Wed, 18 May 2022 11:04:41 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 3/3] mnl: store netlink error location for set elements
Date:   Wed, 18 May 2022 20:04:35 +0200
Message-Id: <20220518180435.298462-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220518180435.298462-1-pablo@netfilter.org>
References: <20220518180435.298462-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Store set element location in the per-command netlink error location
array.  This allows for fine grain error reporting when adding and
deleting elements.

 # nft -f test.nft
 test.nft:5:4-20: Error: Could not process rule: File exists
                        00:01:45:09:0b:26 : drop,
                        ^^^^^^^^^^^^^^^^^

test.nft contains a large map with one redundant entry.

Thus, users do not have to find the needle in the stack.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/mnl.h |  9 +++++----
 src/mnl.c     | 28 +++++++++++++++++-----------
 src/rule.c    | 12 ++++++------
 3 files changed, 28 insertions(+), 21 deletions(-)

diff --git a/include/mnl.h b/include/mnl.h
index 4c701d4ee6dc..8e0a7e3fccab 100644
--- a/include/mnl.h
+++ b/include/mnl.h
@@ -60,10 +60,11 @@ int mnl_nft_set_del(struct netlink_ctx *ctx, struct cmd *cmd);
 struct nftnl_set_list *mnl_nft_set_dump(struct netlink_ctx *ctx, int family,
 					const char *table, const char *set);
 
-int mnl_nft_setelem_add(struct netlink_ctx *ctx, const struct set *set,
-			const struct expr *expr, unsigned int flags);
-int mnl_nft_setelem_del(struct netlink_ctx *ctx, const struct handle *h,
-			const struct expr *init);
+int mnl_nft_setelem_add(struct netlink_ctx *ctx, struct cmd *cmd,
+			const struct set *set, const struct expr *expr,
+			unsigned int flags);
+int mnl_nft_setelem_del(struct netlink_ctx *ctx, struct cmd *cmd,
+			const struct handle *h, const struct expr *init);
 int mnl_nft_setelem_flush(struct netlink_ctx *ctx, const struct cmd *cmd);
 int mnl_nft_setelem_get(struct netlink_ctx *ctx, struct nftnl_set *nls);
 struct nftnl_set *mnl_nft_setelem_get_one(struct netlink_ctx *ctx,
diff --git a/src/mnl.c b/src/mnl.c
index 7dd77be1bec0..e87b033870b0 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -1609,9 +1609,9 @@ static void netlink_dump_setelem_done(struct netlink_ctx *ctx)
 	fprintf(fp, "\n");
 }
 
-static int mnl_nft_setelem_batch(const struct nftnl_set *nls,
+static int mnl_nft_setelem_batch(const struct nftnl_set *nls, struct cmd *cmd,
 				 struct nftnl_batch *batch,
-				 enum nf_tables_msg_types cmd,
+				 enum nf_tables_msg_types msg_type,
 				 unsigned int flags, uint32_t seqnum,
 				 const struct expr *set,
 				 struct netlink_ctx *ctx)
@@ -1622,14 +1622,14 @@ static int mnl_nft_setelem_batch(const struct nftnl_set *nls,
 	struct expr *expr = NULL;
 	int i = 0;
 
-	if (cmd == NFT_MSG_NEWSETELEM)
+	if (msg_type == NFT_MSG_NEWSETELEM)
 		flags |= NLM_F_CREATE;
 
 	if (set)
 		expr = list_first_entry(&set->expressions, struct expr, list);
 
 next:
-	nlh = nftnl_nlmsg_build_hdr(nftnl_batch_buffer(batch), cmd,
+	nlh = nftnl_nlmsg_build_hdr(nftnl_batch_buffer(batch), msg_type,
 				    nftnl_set_get_u32(nls, NFTNL_SET_FAMILY),
 				    flags, seqnum);
 
@@ -1653,7 +1653,12 @@ next:
 	nest1 = mnl_attr_nest_start(nlh, NFTA_SET_ELEM_LIST_ELEMENTS);
 	list_for_each_entry_from(expr, &set->expressions, list) {
 		nlse = alloc_nftnl_setelem(set, expr);
-		nest2 = nftnl_set_elem_nlmsg_build(nlh, nlse, ++i);
+
+		cmd_add_loc(cmd, nlh->nlmsg_len, &expr->location);
+		nest2 = mnl_attr_nest_start(nlh, ++i);
+		nftnl_set_elem_nlmsg_build_payload(nlh, nlse);
+		mnl_attr_nest_end(nlh, nest2);
+
 		netlink_dump_setelem(nlse, ctx);
 		nftnl_set_elem_free(nlse);
 		if (mnl_nft_attr_nest_overflow(nlh, nest1, nest2)) {
@@ -1669,8 +1674,9 @@ next:
 	return 0;
 }
 
-int mnl_nft_setelem_add(struct netlink_ctx *ctx, const struct set *set,
-			const struct expr *expr, unsigned int flags)
+int mnl_nft_setelem_add(struct netlink_ctx *ctx, struct cmd *cmd,
+			const struct set *set, const struct expr *expr,
+			unsigned int flags)
 {
 	const struct handle *h = &set->handle;
 	struct nftnl_set *nls;
@@ -1691,7 +1697,7 @@ int mnl_nft_setelem_add(struct netlink_ctx *ctx, const struct set *set,
 
 	netlink_dump_set(nls, ctx);
 
-	err = mnl_nft_setelem_batch(nls, ctx->batch, NFT_MSG_NEWSETELEM,
+	err = mnl_nft_setelem_batch(nls, cmd, ctx->batch, NFT_MSG_NEWSETELEM,
 				    flags, ctx->seqnum, expr, ctx);
 	nftnl_set_free(nls);
 
@@ -1728,8 +1734,8 @@ int mnl_nft_setelem_flush(struct netlink_ctx *ctx, const struct cmd *cmd)
 	return 0;
 }
 
-int mnl_nft_setelem_del(struct netlink_ctx *ctx, const struct handle *h,
-			const struct expr *init)
+int mnl_nft_setelem_del(struct netlink_ctx *ctx, struct cmd *cmd,
+			const struct handle *h, const struct expr *init)
 {
 	struct nftnl_set *nls;
 	int err;
@@ -1747,7 +1753,7 @@ int mnl_nft_setelem_del(struct netlink_ctx *ctx, const struct handle *h,
 
 	netlink_dump_set(nls, ctx);
 
-	err = mnl_nft_setelem_batch(nls, ctx->batch, NFT_MSG_DELSETELEM, 0,
+	err = mnl_nft_setelem_batch(nls, cmd, ctx->batch, NFT_MSG_DELSETELEM, 0,
 				    ctx->seqnum, init, ctx);
 	nftnl_set_free(nls);
 
diff --git a/src/rule.c b/src/rule.c
index 78f47300d0fc..d809225cdf7f 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1475,11 +1475,11 @@ void cmd_free(struct cmd *cmd)
 #include <netlink.h>
 #include <mnl.h>
 
-static int __do_add_elements(struct netlink_ctx *ctx, struct set *set,
-			     struct expr *expr, uint32_t flags)
+static int __do_add_elements(struct netlink_ctx *ctx, struct cmd *cmd,
+			     struct set *set, struct expr *expr, uint32_t flags)
 {
 	expr->set_flags |= set->flags;
-	if (mnl_nft_setelem_add(ctx, set, expr, flags) < 0)
+	if (mnl_nft_setelem_add(ctx, cmd, set, expr, flags) < 0)
 		return -1;
 
 	return 0;
@@ -1495,7 +1495,7 @@ static int do_add_elements(struct netlink_ctx *ctx, struct cmd *cmd,
 	    set_to_intervals(set, init, true) < 0)
 		return -1;
 
-	return __do_add_elements(ctx, set, init, flags);
+	return __do_add_elements(ctx, cmd, set, init, flags);
 }
 
 static int do_add_setelems(struct netlink_ctx *ctx, struct cmd *cmd,
@@ -1503,7 +1503,7 @@ static int do_add_setelems(struct netlink_ctx *ctx, struct cmd *cmd,
 {
 	struct set *set = cmd->set;
 
-	return __do_add_elements(ctx, set, set->init, flags);
+	return __do_add_elements(ctx, cmd, set, set->init, flags);
 }
 
 static int do_add_set(struct netlink_ctx *ctx, struct cmd *cmd,
@@ -1597,7 +1597,7 @@ static int do_delete_setelems(struct netlink_ctx *ctx, struct cmd *cmd)
 	    set_to_intervals(set, expr, false) < 0)
 		return -1;
 
-	if (mnl_nft_setelem_del(ctx, &cmd->handle, cmd->elem.expr) < 0)
+	if (mnl_nft_setelem_del(ctx, cmd, &cmd->handle, cmd->elem.expr) < 0)
 		return -1;
 
 	return 0;
-- 
2.30.2

