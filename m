Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06516EE14AA
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Sep 2023 00:22:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbjIHAWj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 7 Sep 2023 20:22:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231712AbjIHAWj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 Sep 2023 20:22:39 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1A8C1BD6;
        Thu,  7 Sep 2023 17:22:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=B8UPWVAUsOxHKGzz5IoIPAiukKHDgBS0xJWJd0P3HZk=; b=B917humhATU4HzHCWGuLJI2Xjq
        6GhgqGbA4fXas8hH6buaVPrbzXjDw9ohNf6UgxN24f8YWAqoAuyrzBoyLhkyETQ65mOqOpXaPrBg3
        pbJEjS5xV9G+xG/gGtXn6MFNe57j50ypV0yYik+95jCsp9AewtHUUmWRxu19hpibCwxNZ6JmVLwQk
        WmnZrxh+q03NBAuDzrHoKBLRpL4ThZxsYC7D0TyR+BjX2XOOnHMi+1800+UtNDPFhgrnhZ4vXpeue
        1OhIqSqp+MZicKcYtINQIkr1OfKrkvMSWkoBK8CNhmCY5gi18huUO2c55uXCsiIlX1A2jIwUtiBnM
        TVtdotFQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qePGa-000050-K3; Fri, 08 Sep 2023 02:22:32 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        audit@vger.kernel.org
Subject: [nf PATCH 1/2] netfilter: nf_tables: Fix entries val in rule reset audit log
Date:   Fri,  8 Sep 2023 02:22:28 +0200
Message-ID: <20230908002229.1409-2-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230908002229.1409-1-phil@nwl.cc>
References: <20230908002229.1409-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The value in idx and the number of rules handled in that particular
__nf_tables_dump_rules() call is not identical. The former is a cursor
to pick up from if multiple netlink messages are needed, so its value is
ever increasing. Fixing this is not just a matter of subtracting s_idx
from it, though: When resetting rules in multiple chains,
__nf_tables_dump_rules() is called for each and cb->args[0] is not
adjusted in between.

The audit notification in __nf_tables_dump_rules() had another problem:
If nf_tables_fill_rule_info() failed (e.g. due to buffer exhaustion), no
notification was sent - despite the rules having been reset already.

To catch all the above and return to a single (if possible) notification
per table again, move audit logging back into the caller but into the
table loop instead of past it to avoid the potential null-pointer
deref.

This requires to trigger the notification in two spots. Care has to be
taken in the second case as cb->args[0] is also not updated in between
tables. This requires a helper variable as either it is the first table
(with potential non-zero cb->args[0] cursor) or a consecutive one (with
idx holding the current cursor already).

Fixes: 9b5ba5c9c5109 ("netfilter: nf_tables: Unbreak audit log reset")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_tables_api.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index e429ebba74b3d..d429270676131 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3481,9 +3481,6 @@ static int __nf_tables_dump_rules(struct sk_buff *skb,
 		(*idx)++;
 	}
 
-	if (reset && *idx)
-		audit_log_rule_reset(table, cb->seq, *idx);
-
 	return 0;
 }
 
@@ -3494,11 +3491,12 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
 	const struct nft_rule_dump_ctx *ctx = cb->data;
 	struct nft_table *table;
 	const struct nft_chain *chain;
-	unsigned int idx = 0;
+	unsigned int idx = 0, s_idx;
 	struct net *net = sock_net(skb->sk);
 	int family = nfmsg->nfgen_family;
 	struct nftables_pernet *nft_net;
 	bool reset = false;
+	int ret;
 
 	if (NFNL_MSG_TYPE(cb->nlh->nlmsg_type) == NFT_MSG_GETRULE_RESET)
 		reset = true;
@@ -3529,16 +3527,23 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
 						       cb, table, chain, reset);
 				break;
 			}
+			if (reset && idx > cb->args[0])
+				audit_log_rule_reset(table, cb->seq,
+						     idx - cb->args[0]);
 			goto done;
 		}
 
+		s_idx = max(idx, cb->args[0]);
 		list_for_each_entry_rcu(chain, &table->chains, list) {
-			if (__nf_tables_dump_rules(skb, &idx,
-						   cb, table, chain, reset))
-				goto done;
+			ret = __nf_tables_dump_rules(skb, &idx,
+						     cb, table, chain, reset);
+			if (ret)
+				break;
 		}
+		if (reset && idx > s_idx)
+			audit_log_rule_reset(table, cb->seq, idx - s_idx);
 
-		if (ctx && ctx->table)
+		if ((ctx && ctx->table) || ret)
 			break;
 	}
 done:
-- 
2.41.0

