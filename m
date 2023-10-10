Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A673CD8C9D
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Oct 2023 14:54:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233205AbjJJOyI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 10 Oct 2023 10:54:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233161AbjJJOyG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 10 Oct 2023 10:54:06 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9922CAC;
        Tue, 10 Oct 2023 07:54:05 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qqE7L-0001Np-Nk; Tue, 10 Oct 2023 16:53:51 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>, Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH net-next 1/8] netfilter: nf_tables: Always allocate nft_rule_dump_ctx
Date:   Tue, 10 Oct 2023 16:53:31 +0200
Message-ID: <20231010145343.12551-2-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231010145343.12551-1-fw@strlen.de>
References: <20231010145343.12551-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Phil Sutter <phil@nwl.cc>

It will move into struct netlink_callback's scratch area later, just put
nf_tables_dump_rules_start in shape to reduce churn later.

Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 48 +++++++++++++++--------------------
 1 file changed, 21 insertions(+), 27 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index b4405db710b0..ea30bee41a6e 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3521,10 +3521,10 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
 		if (family != NFPROTO_UNSPEC && family != table->family)
 			continue;
 
-		if (ctx && ctx->table && strcmp(ctx->table, table->name) != 0)
+		if (ctx->table && strcmp(ctx->table, table->name) != 0)
 			continue;
 
-		if (ctx && ctx->table && ctx->chain) {
+		if (ctx->table && ctx->chain) {
 			struct rhlist_head *list, *tmp;
 
 			list = rhltable_lookup(&table->chains_ht, ctx->chain,
@@ -3548,7 +3548,7 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
 				goto done;
 		}
 
-		if (ctx && ctx->table)
+		if (ctx->table)
 			break;
 	}
 done:
@@ -3563,27 +3563,23 @@ static int nf_tables_dump_rules_start(struct netlink_callback *cb)
 	const struct nlattr * const *nla = cb->data;
 	struct nft_rule_dump_ctx *ctx = NULL;
 
-	if (nla[NFTA_RULE_TABLE] || nla[NFTA_RULE_CHAIN]) {
-		ctx = kzalloc(sizeof(*ctx), GFP_ATOMIC);
-		if (!ctx)
-			return -ENOMEM;
+	ctx = kzalloc(sizeof(*ctx), GFP_ATOMIC);
+	if (!ctx)
+		return -ENOMEM;
 
-		if (nla[NFTA_RULE_TABLE]) {
-			ctx->table = nla_strdup(nla[NFTA_RULE_TABLE],
-							GFP_ATOMIC);
-			if (!ctx->table) {
-				kfree(ctx);
-				return -ENOMEM;
-			}
+	if (nla[NFTA_RULE_TABLE]) {
+		ctx->table = nla_strdup(nla[NFTA_RULE_TABLE], GFP_ATOMIC);
+		if (!ctx->table) {
+			kfree(ctx);
+			return -ENOMEM;
 		}
-		if (nla[NFTA_RULE_CHAIN]) {
-			ctx->chain = nla_strdup(nla[NFTA_RULE_CHAIN],
-						GFP_ATOMIC);
-			if (!ctx->chain) {
-				kfree(ctx->table);
-				kfree(ctx);
-				return -ENOMEM;
-			}
+	}
+	if (nla[NFTA_RULE_CHAIN]) {
+		ctx->chain = nla_strdup(nla[NFTA_RULE_CHAIN], GFP_ATOMIC);
+		if (!ctx->chain) {
+			kfree(ctx->table);
+			kfree(ctx);
+			return -ENOMEM;
 		}
 	}
 
@@ -3595,11 +3591,9 @@ static int nf_tables_dump_rules_done(struct netlink_callback *cb)
 {
 	struct nft_rule_dump_ctx *ctx = cb->data;
 
-	if (ctx) {
-		kfree(ctx->table);
-		kfree(ctx->chain);
-		kfree(ctx);
-	}
+	kfree(ctx->table);
+	kfree(ctx->chain);
+	kfree(ctx);
 	return 0;
 }
 
-- 
2.41.0

