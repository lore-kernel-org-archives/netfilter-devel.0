Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E6ECEC8742
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 Sep 2023 17:52:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237129AbjIGRw7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 7 Sep 2023 13:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbjIGRw4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 Sep 2023 13:52:56 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BAB22CF
        for <netfilter-devel@vger.kernel.org>; Thu,  7 Sep 2023 10:52:34 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: nf_tables: disallow rule removal from chain binding
Date:   Thu,  7 Sep 2023 09:42:12 +0200
Message-Id: <20230907074212.105544-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Chain binding only requires the rule addition/insertion command within
the same transaction. Removal of rules from chain bindings within the
same transaction makes no sense, userspace does not utilize this
feature. Replace nft_chain_is_bound() check to nft_chain_binding() in
rule deletion commands.

Rule flush command can also safely rely on this nft_chain_binding()
check because unbound chains are not allowed since 62e1e94b246e
("netfilter: nf_tables: reject unbound chain set before commit phase").

Fixes: d0e2c7de92c7 ("netfilter: nf_tables: add NFT_CHAIN_BINDING")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Supersedes:
https://patchwork.ozlabs.org/project/netfilter-devel/patch/20230906221219.1378-1-pablo@netfilter.org/

 net/netfilter/nf_tables_api.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 4696be5615d3..4d75d9174885 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1432,7 +1432,7 @@ static int nft_flush_table(struct nft_ctx *ctx)
 		if (!nft_is_active_next(ctx->net, chain))
 			continue;
 
-		if (nft_chain_is_bound(chain))
+		if (nft_chain_binding(chain))
 			continue;
 
 		ctx->chain = chain;
@@ -1477,7 +1477,7 @@ static int nft_flush_table(struct nft_ctx *ctx)
 		if (!nft_is_active_next(ctx->net, chain))
 			continue;
 
-		if (nft_chain_is_bound(chain))
+		if (nft_chain_binding(chain))
 			continue;
 
 		ctx->chain = chain;
@@ -2910,6 +2910,9 @@ static int nf_tables_delchain(struct sk_buff *skb, const struct nfnl_info *info,
 		return PTR_ERR(chain);
 	}
 
+	if (nft_chain_binding(chain))
+		return -EOPNOTSUPP;
+
 	nft_ctx_init(&ctx, net, skb, info->nlh, family, table, chain, nla);
 
 	if (nla[NFTA_CHAIN_HOOK]) {
@@ -4078,7 +4081,7 @@ static int nf_tables_delrule(struct sk_buff *skb, const struct nfnl_info *info,
 			NL_SET_BAD_ATTR(extack, nla[NFTA_RULE_CHAIN]);
 			return PTR_ERR(chain);
 		}
-		if (nft_chain_is_bound(chain))
+		if (nft_chain_binding(chain))
 			return -EOPNOTSUPP;
 	}
 
@@ -4112,7 +4115,7 @@ static int nf_tables_delrule(struct sk_buff *skb, const struct nfnl_info *info,
 		list_for_each_entry(chain, &table->chains, list) {
 			if (!nft_is_active_next(net, chain))
 				continue;
-			if (nft_chain_is_bound(chain))
+			if (nft_chain_binding(chain))
 				continue;
 
 			ctx.chain = chain;
@@ -11070,7 +11073,7 @@ static void __nft_release_table(struct net *net, struct nft_table *table)
 	ctx.family = table->family;
 	ctx.table = table;
 	list_for_each_entry(chain, &table->chains, list) {
-		if (nft_chain_is_bound(chain))
+		if (nft_chain_binding(chain))
 			continue;
 
 		ctx.chain = chain;
-- 
2.30.2

