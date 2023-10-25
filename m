Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DEBCC25B72
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Oct 2023 21:26:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbjJYV0N (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Oct 2023 17:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbjJYV0J (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Oct 2023 17:26:09 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D7BDE183;
        Wed, 25 Oct 2023 14:26:07 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, fw@strlen.de
Subject: [PATCH net-next 10/19] netfilter: nf_tables: A better name for nft_obj_filter
Date:   Wed, 25 Oct 2023 23:25:46 +0200
Message-Id: <20231025212555.132775-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20231025212555.132775-1-pablo@netfilter.org>
References: <20231025212555.132775-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Phil Sutter <phil@nwl.cc>

Name it for what it is supposed to become, a real nft_obj_dump_ctx. No
functional change intended.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index e2e0586307f5..2b81069ea3f6 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7681,7 +7681,7 @@ static void audit_log_obj_reset(const struct nft_table *table,
 	kfree(buf);
 }
 
-struct nft_obj_filter {
+struct nft_obj_dump_ctx {
 	char		*table;
 	u32		type;
 };
@@ -7691,7 +7691,7 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 	const struct nfgenmsg *nfmsg = nlmsg_data(cb->nlh);
 	const struct nft_table *table;
 	unsigned int idx = 0, s_idx = cb->args[0];
-	struct nft_obj_filter *filter = cb->data;
+	struct nft_obj_dump_ctx *ctx = cb->data;
 	struct net *net = sock_net(skb->sk);
 	int family = nfmsg->nfgen_family;
 	struct nftables_pernet *nft_net;
@@ -7717,10 +7717,10 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 				goto cont;
 			if (idx < s_idx)
 				goto cont;
-			if (filter->table && strcmp(filter->table, table->name))
+			if (ctx->table && strcmp(ctx->table, table->name))
 				goto cont;
-			if (filter->type != NFT_OBJECT_UNSPEC &&
-			    obj->ops->type->type != filter->type)
+			if (ctx->type != NFT_OBJECT_UNSPEC &&
+			    obj->ops->type->type != ctx->type)
 				goto cont;
 
 			rc = nf_tables_fill_obj_info(skb, net,
@@ -7752,33 +7752,33 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 static int nf_tables_dump_obj_start(struct netlink_callback *cb)
 {
 	const struct nlattr * const *nla = cb->data;
-	struct nft_obj_filter *filter = NULL;
+	struct nft_obj_dump_ctx *ctx = NULL;
 
-	filter = kzalloc(sizeof(*filter), GFP_ATOMIC);
-	if (!filter)
+	ctx = kzalloc(sizeof(*ctx), GFP_ATOMIC);
+	if (!ctx)
 		return -ENOMEM;
 
 	if (nla[NFTA_OBJ_TABLE]) {
-		filter->table = nla_strdup(nla[NFTA_OBJ_TABLE], GFP_ATOMIC);
-		if (!filter->table) {
-			kfree(filter);
+		ctx->table = nla_strdup(nla[NFTA_OBJ_TABLE], GFP_ATOMIC);
+		if (!ctx->table) {
+			kfree(ctx);
 			return -ENOMEM;
 		}
 	}
 
 	if (nla[NFTA_OBJ_TYPE])
-		filter->type = ntohl(nla_get_be32(nla[NFTA_OBJ_TYPE]));
+		ctx->type = ntohl(nla_get_be32(nla[NFTA_OBJ_TYPE]));
 
-	cb->data = filter;
+	cb->data = ctx;
 	return 0;
 }
 
 static int nf_tables_dump_obj_done(struct netlink_callback *cb)
 {
-	struct nft_obj_filter *filter = cb->data;
+	struct nft_obj_dump_ctx *ctx = cb->data;
 
-	kfree(filter->table);
-	kfree(filter);
+	kfree(ctx->table);
+	kfree(ctx);
 
 	return 0;
 }
-- 
2.30.2

