Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64209EE020F
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Sep 2023 21:58:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232897AbjIMV6Z (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 Sep 2023 17:58:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232883AbjIMV6Z (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Sep 2023 17:58:25 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3140F1739;
        Wed, 13 Sep 2023 14:58:21 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 8/9] netfilter: nf_tables: Fix entries val in rule reset audit log
Date:   Wed, 13 Sep 2023 23:57:59 +0200
Message-Id: <20230913215800.107269-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230913215800.107269-1-pablo@netfilter.org>
References: <20230913215800.107269-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Phil Sutter <phil@nwl.cc>

The value in idx and the number of rules handled in that particular
__nf_tables_dump_rules() call is not identical. The former is a cursor
to pick up from if multiple netlink messages are needed, so its value is
ever increasing. Fixing this is not just a matter of subtracting s_idx
from it, though: When resetting rules in multiple chains,
__nf_tables_dump_rules() is called for each and cb->args[0] is not
adjusted in between. Introduce a dedicated counter to record the number
of rules reset in this call in a less confusing way.

While being at it, prevent the direct return upon buffer exhaustion: Any
rules previously dumped into that skb would evade audit logging
otherwise.

Fixes: 9b5ba5c9c5109 ("netfilter: nf_tables: Unbreak audit log reset")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c1e485aee763..d819b4d42962 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3451,6 +3451,8 @@ static int __nf_tables_dump_rules(struct sk_buff *skb,
 	struct net *net = sock_net(skb->sk);
 	const struct nft_rule *rule, *prule;
 	unsigned int s_idx = cb->args[0];
+	unsigned int entries = 0;
+	int ret = 0;
 	u64 handle;
 
 	prule = NULL;
@@ -3473,9 +3475,11 @@ static int __nf_tables_dump_rules(struct sk_buff *skb,
 					NFT_MSG_NEWRULE,
 					NLM_F_MULTI | NLM_F_APPEND,
 					table->family,
-					table, chain, rule, handle, reset) < 0)
-			return 1;
-
+					table, chain, rule, handle, reset) < 0) {
+			ret = 1;
+			break;
+		}
+		entries++;
 		nl_dump_check_consistent(cb, nlmsg_hdr(skb));
 cont:
 		prule = rule;
@@ -3483,10 +3487,10 @@ static int __nf_tables_dump_rules(struct sk_buff *skb,
 		(*idx)++;
 	}
 
-	if (reset && *idx)
-		audit_log_rule_reset(table, cb->seq, *idx);
+	if (reset && entries)
+		audit_log_rule_reset(table, cb->seq, entries);
 
-	return 0;
+	return ret;
 }
 
 static int nf_tables_dump_rules(struct sk_buff *skb,
-- 
2.30.2

