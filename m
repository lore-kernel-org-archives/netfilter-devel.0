Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 549A7E728DB
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Sep 2023 19:19:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233421AbjI2TTe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 Sep 2023 15:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233505AbjI2TTc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Sep 2023 15:19:32 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB8681B1
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Sep 2023 12:19:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/1PYn0y7IZYVOwSrTP2Mik0JOhQTsSNk7oTFOWSmogE=; b=UROuHo72vDbKJEY1hbWKJtQuGn
        /YxT5+09FojsP1Cu05Y9tp+mw8ffmnWBlEFtNxZBpECMN9kfrAwtMoQ+bzJ9E8DuqIiFw5Q2z9GLD
        MornmmFJ6MBAJEdovX3hnFoIDfAmvL89JPK58XF1cR80wxdww3BrYNHvGVmY/1uL87OzTaH7Jx4LP
        D16sluWgTwVGgf2TTR3hW4qDCR1ywd9SdXLeeox7cZWj1iTRvseYC+haG58SX2Wgzn6MAhNgmz/Ci
        OJVbWI3mzSO8lZmANjnm3V7tujj9ONSIWrPhL/raC8Vhhh7PPV1wbhDvtd7c7z1mrBzv+UcPLvkLg
        qeWRWADw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qmJ1L-0005EK-4l; Fri, 29 Sep 2023 21:19:27 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: [nf-next PATCH 3/5] netfilter: nf_tables: Carry reset flag in nft_rule_dump_ctx
Date:   Fri, 29 Sep 2023 21:19:20 +0200
Message-ID: <20230929191922.6230-4-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230929191922.6230-1-phil@nwl.cc>
References: <20230929191922.6230-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This relieves the dump callback from having to check nlmsg_type upon
each call and instead performs the check once in .start callback.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_tables_api.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 8ae87a32753b2..21dd6a27ca598 100644
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

