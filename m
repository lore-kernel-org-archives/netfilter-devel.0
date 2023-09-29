Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD1F1E728CF
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Sep 2023 19:19:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233512AbjI2TTc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 Sep 2023 15:19:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233357AbjI2TTc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Sep 2023 15:19:32 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA5DE113
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Sep 2023 12:19:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=adSnTKNx1m8EDigYcBXGyi53zAp7EXdlieiKZUrpRHc=; b=f6W6ehqI2YoQc55NfurUp3CWBw
        RzZh1aaA02BpA+1FlU+ACgruE2DDXg/+PkukIdGPueSTHHPdTKLGWfvDTfwqzxBDBMZiTIWDRFLfs
        Hlmys5gTWob++SMVxzEXeUIIultwn9wOtvQbUeYxNslsNR79AK51MIvCsibzbhTUI4RqalO7PwYrL
        MCqHayBVEaVlWoSKOKbb3UKPe700YPBRpRvWiQ+joML/zoMDsL1irRUTBHSswfwtFkvc+lqLlQov5
        89yy2hZLyryQhM4S29IB0qZCr3iksUHyFraJ14pmc9V07fJfTFqDgj2klYoPOhN91xZrdn0FrIrzo
        1UoAVXqQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qmJ1K-0005ED-QE; Fri, 29 Sep 2023 21:19:26 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: [nf-next PATCH 1/5] netfilter: nf_tables: Always allocate nft_rule_dump_ctx
Date:   Fri, 29 Sep 2023 21:19:18 +0200
Message-ID: <20230929191922.6230-2-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230929191922.6230-1-phil@nwl.cc>
References: <20230929191922.6230-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

It will move into struct netlink_callback's scratch area later, just put
nf_tables_dump_rules_start in shape to reduce churn later.

Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_tables_api.c | 48 +++++++++++++++--------------------
 1 file changed, 21 insertions(+), 27 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 4356189360fb8..c033671baa7e7 100644
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

