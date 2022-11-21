Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BDC6C4332F
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Nov 2022 11:24:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230371AbiKULYz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Nov 2022 06:24:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231126AbiKULYR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Nov 2022 06:24:17 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97922BE84C
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Nov 2022 03:19:52 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ox4q7-0002Pu-4F; Mon, 21 Nov 2022 12:19:51 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [iptables-nft RFC 2/5] iptables-nft: do not refuse to decode table with unsupported expressions
Date:   Mon, 21 Nov 2022 12:19:29 +0100
Message-Id: <20221121111932.18222-3-fw@strlen.de>
X-Mailer: git-send-email 2.37.4
In-Reply-To: <20221121111932.18222-1-fw@strlen.de>
References: <20221121111932.18222-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Plan is to continue and print as much as possible, with a clear
indication/error message when something cannot be decoded.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 iptables/nft.c          | 66 ++---------------------------------------
 iptables/nft.h          |  2 --
 iptables/xtables-save.c |  6 +---
 3 files changed, 3 insertions(+), 71 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 4c0110bb8040..d33591a73616 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -3771,66 +3771,6 @@ uint32_t nft_invflags2cmp(uint32_t invflags, uint32_t flag)
 	return NFT_CMP_EQ;
 }
 
-static const char *supported_exprs[] = {
-	"match",
-	"target",
-	"payload",
-	"meta",
-	"cmp",
-	"bitwise",
-	"counter",
-	"immediate",
-	"lookup",
-	"range",
-};
-
-
-static int nft_is_expr_compatible(struct nftnl_expr *expr, void *data)
-{
-	const char *name = nftnl_expr_get_str(expr, NFTNL_EXPR_NAME);
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(supported_exprs); i++) {
-		if (strcmp(supported_exprs[i], name) == 0)
-			return 0;
-	}
-
-	if (!strcmp(name, "limit") &&
-	    nftnl_expr_get_u32(expr, NFTNL_EXPR_LIMIT_TYPE) == NFT_LIMIT_PKTS &&
-	    nftnl_expr_get_u32(expr, NFTNL_EXPR_LIMIT_FLAGS) == 0)
-		return 0;
-
-	if (!strcmp(name, "log") &&
-	    nftnl_expr_is_set(expr, NFTNL_EXPR_LOG_GROUP))
-		return 0;
-
-	return -1;
-}
-
-static int nft_is_rule_compatible(struct nftnl_rule *rule, void *data)
-{
-	return nftnl_expr_foreach(rule, nft_is_expr_compatible, NULL);
-}
-
-static int nft_is_chain_compatible(struct nft_chain *nc, void *data)
-{
-	struct nftnl_chain *c = nc->nftnl;
-
-	return nftnl_rule_foreach(c, nft_is_rule_compatible, NULL);
-}
-
-bool nft_is_table_compatible(struct nft_handle *h,
-			     const char *table, const char *chain)
-{
-	if (chain) {
-		struct nft_chain *c = nft_chain_find(h, table, chain);
-
-		return c && !nft_is_chain_compatible(c, h);
-	}
-
-	return !nft_chain_foreach(h, table, nft_is_chain_compatible, h);
-}
-
 bool nft_is_table_tainted(struct nft_handle *h, const char *table)
 {
 	const struct builtin_table *t = nft_table_builtin_find(h, table);
@@ -3843,10 +3783,8 @@ void nft_assert_table_compatible(struct nft_handle *h,
 {
 	const char *pfx = "", *sfx = "";
 
-	if (nft_is_table_compatible(h, table, chain)) {
-		if (nft_is_table_tainted(h, table))
-			printf("# Table `%s' contains incompatible base-chains, use 'nft' tool to list them.\n",
-			       table);
+	if (nft_is_table_tainted(h, table)) {
+		printf("# Table `%s' contains incompatible base-chains, use 'nft' tool to list them.\n", table);
 		return;
 	}
 
diff --git a/iptables/nft.h b/iptables/nft.h
index 68b0910c8e18..4f742dbaf180 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -263,8 +263,6 @@ int nft_arp_rule_insert(struct nft_handle *h, const char *chain,
 
 void nft_rule_to_arpt_entry(struct nftnl_rule *r, struct arpt_entry *fw);
 
-bool nft_is_table_compatible(struct nft_handle *h,
-			     const char *table, const char *chain);
 bool nft_is_table_tainted(struct nft_handle *h, const char *table);
 void nft_assert_table_compatible(struct nft_handle *h,
 				 const char *table, const char *chain);
diff --git a/iptables/xtables-save.c b/iptables/xtables-save.c
index 5a82cac5dd7c..c9f87322834b 100644
--- a/iptables/xtables-save.c
+++ b/iptables/xtables-save.c
@@ -74,11 +74,7 @@ __do_output(struct nft_handle *h, const char *tablename, void *data)
 	if (!nft_table_builtin_find(h, tablename))
 		return 0;
 
-	if (!nft_is_table_compatible(h, tablename, NULL)) {
-		printf("# Table `%s' is incompatible, use 'nft' tool.\n",
-		       tablename);
-		return 0;
-	} else if (nft_is_table_tainted(h, tablename)) {
+	if (nft_is_table_tainted(h, tablename)) {
 		printf("# Table `%s' contains incompatible base-chains, use 'nft' tool to list them.\n",
 		       tablename);
 	}
-- 
2.37.4

