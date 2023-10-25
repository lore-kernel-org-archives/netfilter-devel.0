Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82363C25B6E
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Oct 2023 21:26:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230522AbjJYV0O (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Oct 2023 17:26:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230397AbjJYV0K (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Oct 2023 17:26:10 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 70CB8185;
        Wed, 25 Oct 2023 14:26:08 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, fw@strlen.de
Subject: [PATCH net-next 11/19] netfilter: nf_tables: Carry s_idx in nft_obj_dump_ctx
Date:   Wed, 25 Oct 2023 23:25:47 +0200
Message-Id: <20231025212555.132775-12-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20231025212555.132775-1-pablo@netfilter.org>
References: <20231025212555.132775-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Phil Sutter <phil@nwl.cc>

Prep work for moving the context into struct netlink_callback scratch
area.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 2b81069ea3f6..3585ddd99ef8 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7682,6 +7682,7 @@ static void audit_log_obj_reset(const struct nft_table *table,
 }
 
 struct nft_obj_dump_ctx {
+	unsigned int	s_idx;
 	char		*table;
 	u32		type;
 };
@@ -7689,14 +7690,14 @@ struct nft_obj_dump_ctx {
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
 
@@ -7715,7 +7716,7 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 		list_for_each_entry_rcu(obj, &table->objects, list) {
 			if (!nft_is_active(net, obj))
 				goto cont;
-			if (idx < s_idx)
+			if (idx < ctx->s_idx)
 				goto cont;
 			if (ctx->table && strcmp(ctx->table, table->name))
 				goto cont;
@@ -7745,7 +7746,7 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 	}
 	rcu_read_unlock();
 
-	cb->args[0] = idx;
+	ctx->s_idx = idx;
 	return skb->len;
 }
 
-- 
2.30.2

