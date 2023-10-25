Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E545C25B6B
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Oct 2023 21:26:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230397AbjJYV0O (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Oct 2023 17:26:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230400AbjJYV0K (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Oct 2023 17:26:10 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 125DE137;
        Wed, 25 Oct 2023 14:26:09 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, fw@strlen.de
Subject: [PATCH net-next 12/19] netfilter: nf_tables: nft_obj_filter fits into cb->ctx
Date:   Wed, 25 Oct 2023 23:25:48 +0200
Message-Id: <20231025212555.132775-13-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20231025212555.132775-1-pablo@netfilter.org>
References: <20231025212555.132775-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Phil Sutter <phil@nwl.cc>

No need to allocate it if one may just use struct netlink_callback's
scratch area for it.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 3585ddd99ef8..c84e2cc6d3b3 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7690,7 +7690,7 @@ struct nft_obj_dump_ctx {
 static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	const struct nfgenmsg *nfmsg = nlmsg_data(cb->nlh);
-	struct nft_obj_dump_ctx *ctx = cb->data;
+	struct nft_obj_dump_ctx *ctx = (void *)cb->ctx;
 	struct net *net = sock_net(skb->sk);
 	int family = nfmsg->nfgen_family;
 	struct nftables_pernet *nft_net;
@@ -7752,34 +7752,28 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 
 static int nf_tables_dump_obj_start(struct netlink_callback *cb)
 {
+	struct nft_obj_dump_ctx *ctx = (void *)cb->ctx;
 	const struct nlattr * const *nla = cb->data;
-	struct nft_obj_dump_ctx *ctx = NULL;
 
-	ctx = kzalloc(sizeof(*ctx), GFP_ATOMIC);
-	if (!ctx)
-		return -ENOMEM;
+	BUILD_BUG_ON(sizeof(*ctx) > sizeof(cb->ctx));
 
 	if (nla[NFTA_OBJ_TABLE]) {
 		ctx->table = nla_strdup(nla[NFTA_OBJ_TABLE], GFP_ATOMIC);
-		if (!ctx->table) {
-			kfree(ctx);
+		if (!ctx->table)
 			return -ENOMEM;
-		}
 	}
 
 	if (nla[NFTA_OBJ_TYPE])
 		ctx->type = ntohl(nla_get_be32(nla[NFTA_OBJ_TYPE]));
 
-	cb->data = ctx;
 	return 0;
 }
 
 static int nf_tables_dump_obj_done(struct netlink_callback *cb)
 {
-	struct nft_obj_dump_ctx *ctx = cb->data;
+	struct nft_obj_dump_ctx *ctx = (void *)cb->ctx;
 
 	kfree(ctx->table);
-	kfree(ctx);
 
 	return 0;
 }
-- 
2.30.2

