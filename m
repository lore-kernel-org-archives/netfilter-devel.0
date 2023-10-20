Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82C0BC19F5C
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Oct 2023 17:34:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377916AbjJTReq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 Oct 2023 13:34:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbjJTRem (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Oct 2023 13:34:42 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 535D2D6A
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Oct 2023 10:34:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=HTIRF1jcoOwsoYMZc+GMgCLoBBidNr91ehUovlDmZwg=; b=aBSEsxsHnpmWEFBZZGADAsj3L3
        bgboB3bMcLA9R+WxSFDFc8TzsWYWmruxpQi7vQ1QEdo/CRzJNGyV+grlP9KmvNjEd5/zsMZtaBi1v
        da+231MCqWLKVB0rcj9fqZR4FgXc16ifNmbaUbVPCPFmqRbrx2X1BX8ccjtdpTTViy1lFlPzrOYQ4
        D7BtP0cmimi8VLHV1KrfaX/26vtDdpmU8si2cnh2haliOsyVEgQEZqFU3D/B4/uEic6mp2gYRM4wL
        63jI0VX9lfiuDpPbJ6rjbW55w3WPBEUR2xplF2RPozhS9Mc7bRr6A+9WdPRcLRQGTirM/3OToluxv
        x9FOKwPw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qttOQ-0003l0-LU; Fri, 20 Oct 2023 19:34:38 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nf-next PATCH 3/6] netfilter: nf_tables: A better name for nft_obj_filter
Date:   Fri, 20 Oct 2023 19:34:30 +0200
Message-ID: <20231020173433.4611-4-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231020173433.4611-1-phil@nwl.cc>
References: <20231020173433.4611-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Name it for what it is supposed to become, a real nft_obj_dump_ctx. No
functional change intended.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_tables_api.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 0dfac634d21f..20b49b11938a 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7689,7 +7689,7 @@ static void audit_log_obj_reset(const struct nft_table *table,
 	kfree(buf);
 }
 
-struct nft_obj_filter {
+struct nft_obj_dump_ctx {
 	char		*table;
 	u32		type;
 };
@@ -7699,7 +7699,7 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 	const struct nfgenmsg *nfmsg = nlmsg_data(cb->nlh);
 	const struct nft_table *table;
 	unsigned int idx = 0, s_idx = cb->args[0];
-	struct nft_obj_filter *filter = cb->data;
+	struct nft_obj_dump_ctx *ctx = cb->data;
 	struct net *net = sock_net(skb->sk);
 	int family = nfmsg->nfgen_family;
 	struct nftables_pernet *nft_net;
@@ -7725,10 +7725,10 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
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
@@ -7760,33 +7760,33 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
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
2.41.0

