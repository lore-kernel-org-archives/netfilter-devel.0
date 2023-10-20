Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 579B4CDB474
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Oct 2023 17:34:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377713AbjJTRen (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 Oct 2023 13:34:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbjJTRem (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Oct 2023 13:34:42 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00EA1124
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Oct 2023 10:34:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=nPV+1d9+022I5pI4xBpGZrHULcgVwXOZQfzoVnvE1mQ=; b=mz/u68W4u2r/6fsQxHMdyEGqcR
        CzRmLu0RdlCJxoaK0vsjO4gKQaosZksTYNtx1AoSHEH9POtXcpAudG5S4b/oyFSSC13kr9bRJKyJp
        LbC10Wk/thWvFBg4kCXHrAKkIs4MDz1VSWRB+UAaPwx2Be7gRUTJ7rRcP2FobzzuCI8bZw1z0Pf0s
        BjNZEVcImGfkEAdDcV4SRzZuA351UD0jDZUFO18TpXRkch9N5uS0TBqSvR23D9uxlBvYwV+bzbIxQ
        YdSRJA5aU6utRtpE3VXW6mUyBXAM7EbkB8+MnteSkw8JWH20878bvfdxGV2S967VODDyaZkK/zlhi
        kC7qi9VA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qttOO-0003kV-MS; Fri, 20 Oct 2023 19:34:36 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nf-next PATCH 5/6] netfilter: nf_tables: nft_obj_filter fits into cb->ctx
Date:   Fri, 20 Oct 2023 19:34:32 +0200
Message-ID: <20231020173433.4611-6-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231020173433.4611-1-phil@nwl.cc>
References: <20231020173433.4611-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

No need to allocate it if one may just use struct netlink_callback's
scratch area for it.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_tables_api.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a6877544f936..9523f1f3a598 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7698,7 +7698,7 @@ struct nft_obj_dump_ctx {
 static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	const struct nfgenmsg *nfmsg = nlmsg_data(cb->nlh);
-	struct nft_obj_dump_ctx *ctx = cb->data;
+	struct nft_obj_dump_ctx *ctx = (void *)cb->ctx;
 	struct net *net = sock_net(skb->sk);
 	int family = nfmsg->nfgen_family;
 	struct nftables_pernet *nft_net;
@@ -7760,34 +7760,28 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 
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
2.41.0

