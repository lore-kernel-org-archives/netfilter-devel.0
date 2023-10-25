Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FE9CC0032E
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Oct 2023 21:26:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbjJYV0P (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Oct 2023 17:26:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230416AbjJYV0L (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Oct 2023 17:26:11 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9CA6A12A;
        Wed, 25 Oct 2023 14:26:09 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, fw@strlen.de
Subject: [PATCH net-next 13/19] netfilter: nf_tables: Carry reset boolean in nft_obj_dump_ctx
Date:   Wed, 25 Oct 2023 23:25:49 +0200
Message-Id: <20231025212555.132775-14-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20231025212555.132775-1-pablo@netfilter.org>
References: <20231025212555.132775-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Phil Sutter <phil@nwl.cc>

Relieve the dump callback from having to inspect nlmsg_type upon each
call, just do it once at start of the dump.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c84e2cc6d3b3..ecb251f6c6a6 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7685,6 +7685,7 @@ struct nft_obj_dump_ctx {
 	unsigned int	s_idx;
 	char		*table;
 	u32		type;
+	bool		reset;
 };
 
 static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
@@ -7698,12 +7699,8 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 	unsigned int entries = 0;
 	struct nft_object *obj;
 	unsigned int idx = 0;
-	bool reset = false;
 	int rc = 0;
 
-	if (NFNL_MSG_TYPE(cb->nlh->nlmsg_type) == NFT_MSG_GETOBJ_RESET)
-		reset = true;
-
 	rcu_read_lock();
 	nft_net = nft_pernet(net);
 	cb->seq = READ_ONCE(nft_net->base_seq);
@@ -7730,7 +7727,7 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 						     NFT_MSG_NEWOBJ,
 						     NLM_F_MULTI | NLM_F_APPEND,
 						     table->family, table,
-						     obj, reset);
+						     obj, ctx->reset);
 			if (rc < 0)
 				break;
 
@@ -7739,7 +7736,7 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 cont:
 			idx++;
 		}
-		if (reset && entries)
+		if (ctx->reset && entries)
 			audit_log_obj_reset(table, nft_net->base_seq, entries);
 		if (rc < 0)
 			break;
@@ -7766,6 +7763,9 @@ static int nf_tables_dump_obj_start(struct netlink_callback *cb)
 	if (nla[NFTA_OBJ_TYPE])
 		ctx->type = ntohl(nla_get_be32(nla[NFTA_OBJ_TYPE]));
 
+	if (NFNL_MSG_TYPE(cb->nlh->nlmsg_type) == NFT_MSG_GETOBJ_RESET)
+		ctx->reset = true;
+
 	return 0;
 }
 
-- 
2.30.2

