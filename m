Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FE95C0032E
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Oct 2023 17:34:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377895AbjJTRen (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 Oct 2023 13:34:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377710AbjJTRem (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Oct 2023 13:34:42 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52BB113E
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Oct 2023 10:34:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=VGQ6fD9kLVLcgUF/ag+n5F0YTTZqbH1dPE7ly/H3QGs=; b=dI+2BXcuilYe2JyHIml1ckzeTb
        PrDnNHF7DhpkErfhARhaG+as33oKTjaulaLdXsFYDBm3s1Ax9sDwgZuaZDwYCN9Cdx8/uwPymvpFD
        v7hLhFT1UZV+OAJL5FxX/xTKQlToIm0fTAUmLWxYkyUdddPFGLa6Xbip+hczJWMRpgWyAm4HWqlCz
        QUzuTPTZZOCY2baLevKrsJZyAD8JhNZS3IuZltZ8Rt1CiDJTpBRKH1kYTfXoZ16Q5qLfU7cO7mYmk
        2cohasI1U8PlM5kuqyeyzV3Dr0K3XwL47fwXzOdQQE5rAipz9bAkaWXADj1AgoKNmibFYAMQ7a76q
        kDTN5bMQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qttOP-0003kl-Nh; Fri, 20 Oct 2023 19:34:37 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nf-next PATCH 4/6] netfilter: nf_tables: Carry s_idx in nft_obj_dump_ctx
Date:   Fri, 20 Oct 2023 19:34:31 +0200
Message-ID: <20231020173433.4611-5-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231020173433.4611-1-phil@nwl.cc>
References: <20231020173433.4611-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Prep work for moving the context into struct netlink_callback scratch
area.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_tables_api.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 20b49b11938a..a6877544f936 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7690,6 +7690,7 @@ static void audit_log_obj_reset(const struct nft_table *table,
 }
 
 struct nft_obj_dump_ctx {
+	unsigned int	s_idx;
 	char		*table;
 	u32		type;
 };
@@ -7697,14 +7698,14 @@ struct nft_obj_dump_ctx {
 static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	const struct nfgenmsg *nfmsg = nlmsg_data(cb->nlh);
-	const struct nft_table *table;
-	unsigned int idx = 0, s_idx = cb->args[0];
 	struct nft_obj_dump_ctx *ctx = cb->data;
 	struct net *net = sock_net(skb->sk);
 	int family = nfmsg->nfgen_family;
 	struct nftables_pernet *nft_net;
+	const struct nft_table *table;
 	unsigned int entries = 0;
 	struct nft_object *obj;
+	unsigned int idx = 0;
 	bool reset = false;
 	int rc = 0;
 
@@ -7723,7 +7724,7 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 		list_for_each_entry_rcu(obj, &table->objects, list) {
 			if (!nft_is_active(net, obj))
 				goto cont;
-			if (idx < s_idx)
+			if (idx < ctx->s_idx)
 				goto cont;
 			if (ctx->table && strcmp(ctx->table, table->name))
 				goto cont;
@@ -7753,7 +7754,7 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 	}
 	rcu_read_unlock();
 
-	cb->args[0] = idx;
+	ctx->s_idx = idx;
 	return skb->len;
 }
 
-- 
2.41.0

