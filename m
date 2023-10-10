Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86987CD8C99
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Oct 2023 14:54:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231386AbjJJOyK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 10 Oct 2023 10:54:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232586AbjJJOyJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 10 Oct 2023 10:54:09 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FA0E99;
        Tue, 10 Oct 2023 07:54:08 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qqE7T-0001OL-SP; Tue, 10 Oct 2023 16:53:59 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>, Phil Sutter <phil@nwl.cc>
Subject: [PATCH net-next 3/8] netfilter: nf_tables: Carry reset flag in nft_rule_dump_ctx
Date:   Tue, 10 Oct 2023 16:53:33 +0200
Message-ID: <20231010145343.12551-4-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231010145343.12551-1-fw@strlen.de>
References: <20231010145343.12551-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Phil Sutter <phil@nwl.cc>

This relieves the dump callback from having to check nlmsg_type upon
each call and instead performs the check once in .start callback.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index cd3c7dd15530..567c414351da 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3443,15 +3443,16 @@ static void audit_log_rule_reset(const struct nft_table *table,
 struct nft_rule_dump_ctx {
 	char *table;
 	char *chain;
+	bool reset;
 };
 
 static int __nf_tables_dump_rules(struct sk_buff *skb,
 				  unsigned int *idx,
 				  struct netlink_callback *cb,
 				  const struct nft_table *table,
-				  const struct nft_chain *chain,
-				  bool reset)
+				  const struct nft_chain *chain)
 {
+	struct nft_rule_dump_ctx *ctx = cb->data;
 	struct net *net = sock_net(skb->sk);
 	const struct nft_rule *rule, *prule;
 	unsigned int s_idx = cb->args[0];
@@ -3475,7 +3476,7 @@ static int __nf_tables_dump_rules(struct sk_buff *skb,
 					NFT_MSG_NEWRULE,
 					NLM_F_MULTI | NLM_F_APPEND,
 					table->family,
-					table, chain, rule, handle, reset) < 0) {
+					table, chain, rule, handle, ctx->reset) < 0) {
 			ret = 1;
 			break;
 		}
@@ -3487,7 +3488,7 @@ static int __nf_tables_dump_rules(struct sk_buff *skb,
 		(*idx)++;
 	}
 
-	if (reset && entries)
+	if (ctx->reset && entries)
 		audit_log_rule_reset(table, cb->seq, entries);
 
 	return ret;
@@ -3504,10 +3505,6 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
 	struct net *net = sock_net(skb->sk);
 	int family = nfmsg->nfgen_family;
 	struct nftables_pernet *nft_net;
-	bool reset = false;
-
-	if (NFNL_MSG_TYPE(cb->nlh->nlmsg_type) == NFT_MSG_GETRULE_RESET)
-		reset = true;
 
 	rcu_read_lock();
 	nft_net = nft_pernet(net);
@@ -3532,7 +3529,7 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
 				if (!nft_is_active(net, chain))
 					continue;
 				__nf_tables_dump_rules(skb, &idx,
-						       cb, table, chain, reset);
+						       cb, table, chain);
 				break;
 			}
 			goto done;
@@ -3540,7 +3537,7 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
 
 		list_for_each_entry_rcu(chain, &table->chains, list) {
 			if (__nf_tables_dump_rules(skb, &idx,
-						   cb, table, chain, reset))
+						   cb, table, chain))
 				goto done;
 		}
 
@@ -3578,6 +3575,8 @@ static int nf_tables_dump_rules_start(struct netlink_callback *cb)
 			return -ENOMEM;
 		}
 	}
+	if (NFNL_MSG_TYPE(cb->nlh->nlmsg_type) == NFT_MSG_GETRULE_RESET)
+		ctx->reset = true;
 
 	cb->data = ctx;
 	return 0;
-- 
2.41.0

