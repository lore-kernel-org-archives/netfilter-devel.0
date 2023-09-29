Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE0DDE728DA
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Sep 2023 19:19:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233505AbjI2TTe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 Sep 2023 15:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233357AbjI2TTd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Sep 2023 15:19:33 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB5121B4
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Sep 2023 12:19:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ZQzPt8dSuuEN4w3nUL52ysjAHEpqfAg/E1VRvQ5ux7k=; b=FZI9vULi+OtqBf94R8KUKlqmqV
        diIWcpjlJB+9KnvxwOi99iFihwH52RGn3t7IXutJJ8vTpvAlp3U50vIqmmF3Zk8xNpcK5vko6nAjL
        imR5xmD9L9XrY88PcHUlNw64fSCZbjAB9oE78hEGpX/PWvIc3twJkA3ScveXVdSaV3jeQXnMrdtBA
        qQJvPv2Z10tICz2z6oojXDCVqHuUMXfBKvxdfUGGi89Rz6bcFApEuDsCF9+0BBYXKbcxt3TRcdFzg
        hTKylyeOcD09Ngat7VhovEXZ12CCoERaoKAwC4WHT3/9vQuwrho8hTpGX04uv6o5Sb40M9KwQJVO1
        GcA1z3iA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qmJ1M-0005EZ-2P; Fri, 29 Sep 2023 21:19:28 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: [nf-next PATCH 5/5] netfilter: nf_tables: Don't allocate nft_rule_dump_ctx
Date:   Fri, 29 Sep 2023 21:19:22 +0200
Message-ID: <20230929191922.6230-6-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230929191922.6230-1-phil@nwl.cc>
References: <20230929191922.6230-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Since struct netlink_callback::args is not used by rule dumpers anymore,
use it to hold nft_rule_dump_ctx. Add a build-time check to make sure it
won't ever exceed the available space.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_tables_api.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a8c8d9d116d56..ad54df5e0f99a 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3453,7 +3453,7 @@ static int __nf_tables_dump_rules(struct sk_buff *skb,
 				  const struct nft_table *table,
 				  const struct nft_chain *chain)
 {
-	struct nft_rule_dump_ctx *ctx = cb->data;
+	struct nft_rule_dump_ctx *ctx = (void *)cb->ctx;
 	struct net *net = sock_net(skb->sk);
 	const struct nft_rule *rule, *prule;
 	unsigned int entries = 0;
@@ -3498,7 +3498,7 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
 				struct netlink_callback *cb)
 {
 	const struct nfgenmsg *nfmsg = nlmsg_data(cb->nlh);
-	struct nft_rule_dump_ctx *ctx = cb->data;
+	struct nft_rule_dump_ctx *ctx = (void *)cb->ctx;
 	struct nft_table *table;
 	const struct nft_chain *chain;
 	unsigned int idx = 0;
@@ -3553,42 +3553,35 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
 
 static int nf_tables_dump_rules_start(struct netlink_callback *cb)
 {
+	struct nft_rule_dump_ctx *ctx = (void *)cb->ctx;
 	const struct nlattr * const *nla = cb->data;
-	struct nft_rule_dump_ctx *ctx = NULL;
 
-	ctx = kzalloc(sizeof(*ctx), GFP_ATOMIC);
-	if (!ctx)
-		return -ENOMEM;
+	BUILD_BUG_ON(sizeof(*ctx) > sizeof(cb->ctx));
 
 	if (nla[NFTA_RULE_TABLE]) {
 		ctx->table = nla_strdup(nla[NFTA_RULE_TABLE], GFP_ATOMIC);
-		if (!ctx->table) {
-			kfree(ctx);
+		if (!ctx->table)
 			return -ENOMEM;
-		}
 	}
 	if (nla[NFTA_RULE_CHAIN]) {
 		ctx->chain = nla_strdup(nla[NFTA_RULE_CHAIN], GFP_ATOMIC);
 		if (!ctx->chain) {
 			kfree(ctx->table);
-			kfree(ctx);
 			return -ENOMEM;
 		}
 	}
 	if (NFNL_MSG_TYPE(cb->nlh->nlmsg_type) == NFT_MSG_GETRULE_RESET)
 		ctx->reset = true;
 
-	cb->data = ctx;
 	return 0;
 }
 
 static int nf_tables_dump_rules_done(struct netlink_callback *cb)
 {
-	struct nft_rule_dump_ctx *ctx = cb->data;
+	struct nft_rule_dump_ctx *ctx = (void *)cb->ctx;
 
 	kfree(ctx->table);
 	kfree(ctx->chain);
-	kfree(ctx);
 	return 0;
 }
 
-- 
2.41.0

