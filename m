Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 464F7CD8C9D
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Oct 2023 14:54:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232818AbjJJOyL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 10 Oct 2023 10:54:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232586AbjJJOyK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 10 Oct 2023 10:54:10 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F06FAC;
        Tue, 10 Oct 2023 07:54:09 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qqE7X-0001Og-UT; Tue, 10 Oct 2023 16:54:03 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>, Phil Sutter <phil@nwl.cc>
Subject: [PATCH net-next 4/8] netfilter: nf_tables: Carry s_idx in nft_rule_dump_ctx
Date:   Tue, 10 Oct 2023 16:53:34 +0200
Message-ID: <20231010145343.12551-5-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231010145343.12551-1-fw@strlen.de>
References: <20231010145343.12551-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Phil Sutter <phil@nwl.cc>

In order to move the context into struct netlink_callback's scratch
area, the latter must be unused first.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 567c414351da..a2e6c826bd08 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3441,6 +3441,7 @@ static void audit_log_rule_reset(const struct nft_table *table,
 }
 
 struct nft_rule_dump_ctx {
+	unsigned int s_idx;
 	char *table;
 	char *chain;
 	bool reset;
@@ -3455,7 +3456,6 @@ static int __nf_tables_dump_rules(struct sk_buff *skb,
 	struct nft_rule_dump_ctx *ctx = cb->data;
 	struct net *net = sock_net(skb->sk);
 	const struct nft_rule *rule, *prule;
-	unsigned int s_idx = cb->args[0];
 	unsigned int entries = 0;
 	int ret = 0;
 	u64 handle;
@@ -3464,7 +3464,7 @@ static int __nf_tables_dump_rules(struct sk_buff *skb,
 	list_for_each_entry_rcu(rule, &chain->rules, list) {
 		if (!nft_is_active(net, rule))
 			goto cont_skip;
-		if (*idx < s_idx)
+		if (*idx < ctx->s_idx)
 			goto cont;
 		if (prule)
 			handle = prule->handle;
@@ -3498,7 +3498,7 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
 				struct netlink_callback *cb)
 {
 	const struct nfgenmsg *nfmsg = nlmsg_data(cb->nlh);
-	const struct nft_rule_dump_ctx *ctx = cb->data;
+	struct nft_rule_dump_ctx *ctx = cb->data;
 	struct nft_table *table;
 	const struct nft_chain *chain;
 	unsigned int idx = 0;
@@ -3547,7 +3547,7 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
 done:
 	rcu_read_unlock();
 
-	cb->args[0] = idx;
+	ctx->s_idx = idx;
 	return skb->len;
 }
 
-- 
2.41.0

