Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA89BC433F5
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Dec 2021 15:03:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232043AbhLAPHD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 Dec 2021 10:07:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234653AbhLAPGm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Dec 2021 10:06:42 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83689C061748
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Dec 2021 07:03:14 -0800 (PST)
Received: from localhost ([::1]:35142 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1msR8a-00067i-OR; Wed, 01 Dec 2021 16:03:12 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 2/5] cache: Filter rule list on kernel side
Date:   Wed,  1 Dec 2021 16:02:55 +0100
Message-Id: <20211201150258.18436-3-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211201150258.18436-1-phil@nwl.cc>
References: <20211201150258.18436-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Instead of fetching all existing rules in kernel's ruleset and filtering
in user space, add payload to the dump request specifying the table and
chain to filter for.

Since list_rule_cb() no longer needs the filter, pass only netlink_ctx
to the callback and drop struct rule_cache_dump_ctx.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/mnl.h |  4 ++--
 src/cache.c   | 23 +++--------------------
 src/mnl.c     | 21 +++++++++++++++++++--
 3 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/include/mnl.h b/include/mnl.h
index 344030f306940..19faa651fdb91 100644
--- a/include/mnl.h
+++ b/include/mnl.h
@@ -33,8 +33,8 @@ int mnl_nft_rule_add(struct netlink_ctx *ctx, struct cmd *cmd,
 int mnl_nft_rule_del(struct netlink_ctx *ctx, struct cmd *cmd);
 int mnl_nft_rule_replace(struct netlink_ctx *ctx, struct cmd *cmd);
 
-struct nftnl_rule_list *mnl_nft_rule_dump(struct netlink_ctx *ctx,
-					  int family);
+struct nftnl_rule_list *mnl_nft_rule_dump(struct netlink_ctx *ctx, int family,
+					  const struct nft_cache_filter *filter);
 
 int mnl_nft_chain_add(struct netlink_ctx *ctx, struct cmd *cmd,
 		      unsigned int flags);
diff --git a/src/cache.c b/src/cache.c
index 66da2b3475732..484efdb93862b 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -441,16 +441,9 @@ struct chain *chain_cache_find(const struct table *table, const char *name)
 	return NULL;
 }
 
-struct rule_cache_dump_ctx {
-	struct netlink_ctx	*nlctx;
-	const struct nft_cache_filter *filter;
-};
-
 static int list_rule_cb(struct nftnl_rule *nlr, void *data)
 {
-	struct rule_cache_dump_ctx *rule_ctx = data;
-	const struct nft_cache_filter *filter = rule_ctx->filter;
-	struct netlink_ctx *ctx = rule_ctx->nlctx;
+	struct netlink_ctx *ctx = data;
 	const struct handle *h = ctx->data;
 	const char *table, *chain;
 	struct rule *rule;
@@ -465,12 +458,6 @@ static int list_rule_cb(struct nftnl_rule *nlr, void *data)
 	    (h->chain.name && strcmp(chain, h->chain.name) != 0))
 		return 0;
 
-	if (filter && filter->list.table && filter->list.chain &&
-	    (filter->list.family != family ||
-	     strcmp(filter->list.table, table) ||
-	     strcmp(filter->list.chain, chain)))
-		return 0;
-
 	netlink_dump_rule(nlr, ctx);
 	rule = netlink_delinearize_rule(ctx, nlr);
 	list_add_tail(&rule->list, &ctx->list);
@@ -481,13 +468,9 @@ static int list_rule_cb(struct nftnl_rule *nlr, void *data)
 static int rule_cache_init(struct netlink_ctx *ctx, const struct handle *h,
 			   const struct nft_cache_filter *filter)
 {
-	struct rule_cache_dump_ctx rule_ctx = {
-		.nlctx = ctx,
-		.filter = filter,
-	};
 	struct nftnl_rule_list *rule_cache;
 
-	rule_cache = mnl_nft_rule_dump(ctx, h->family);
+	rule_cache = mnl_nft_rule_dump(ctx, h->family, filter);
 	if (rule_cache == NULL) {
 		if (errno == EINTR)
 			return -1;
@@ -496,7 +479,7 @@ static int rule_cache_init(struct netlink_ctx *ctx, const struct handle *h,
 	}
 
 	ctx->data = h;
-	nftnl_rule_list_foreach(rule_cache, list_rule_cb, &rule_ctx);
+	nftnl_rule_list_foreach(rule_cache, list_rule_cb, ctx);
 	nftnl_rule_list_free(rule_cache);
 	return 0;
 }
diff --git a/src/mnl.c b/src/mnl.c
index edd951186d3a7..35fff92a180c7 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -653,20 +653,37 @@ err_free:
 	return MNL_CB_OK;
 }
 
-struct nftnl_rule_list *mnl_nft_rule_dump(struct netlink_ctx *ctx,
-					  int family)
+struct nftnl_rule_list *mnl_nft_rule_dump(struct netlink_ctx *ctx, int family,
+					  const struct nft_cache_filter *filter)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nftnl_rule_list *nlr_list;
+	struct nftnl_rule *nlr = NULL;
 	struct nlmsghdr *nlh;
 	int ret;
 
+	if (filter && filter->list.table) {
+		nlr = nftnl_rule_alloc();
+		if (!nlr)
+			memory_allocation_error();
+
+		nftnl_rule_set_str(nlr, NFTNL_RULE_TABLE,
+				   filter->list.table);
+		if (filter->list.chain)
+			nftnl_rule_set_str(nlr, NFTNL_RULE_CHAIN,
+					   filter->list.chain);
+	}
+
 	nlr_list = nftnl_rule_list_alloc();
 	if (nlr_list == NULL)
 		memory_allocation_error();
 
 	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETRULE, family,
 				    NLM_F_DUMP, ctx->seqnum);
+	if (nlr) {
+		nftnl_rule_nlmsg_build_payload(nlh, nlr);
+		nftnl_rule_free(nlr);
+	}
 
 	ret = nft_mnl_talk(ctx, nlh, nlh->nlmsg_len, rule_cb, nlr_list);
 	if (ret < 0)
-- 
2.33.0

