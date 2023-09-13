Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB2D2EDEC56
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Sep 2023 13:51:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241059AbjIMNvw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 Sep 2023 09:51:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233325AbjIMNvu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Sep 2023 09:51:50 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57B2919BB;
        Wed, 13 Sep 2023 06:51:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=NxchRr/tSz2sRpAUepCCTtuCewkwhPOcQe1pHUMIc0c=; b=EA/ilEeHQZWIzzqsJS4gQy1VL0
        17htWgXjWd2W+251EKOe4yoJ+enCsHZ/Jg8W2CobDvp9MvAUDuy9XOAtBn8OBRIRY6oqbDb1AOzzB
        mh662kuZmdu8wDGPpNCF6S5bahC3zoJWvKR7pFQDLy5lAls3tqwk7q9IpU2NIgYtvw4gQYVCbmENB
        nE8bdeI3WCpQuSFKNM7M3FgDeo6rL7mWBS789wO+EELUkUWDaAT24MiEjXIlqZhzypBdPH5MyunU8
        HvzZc85T6IVt6Il6etHnklFvG813ngnVp1f+ujoU2CXryAs3SQyckvfCRhqpXLhWRtOHm+SuVzNOS
        4Y4iV4gA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qgQHN-0007E0-2K; Wed, 13 Sep 2023 15:51:41 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        audit@vger.kernel.org, paul@paul-moore.com, rgb@redhat.com
Subject: [nf PATCH v3 1/2] netfilter: nf_tables: Fix entries val in rule reset audit log
Date:   Wed, 13 Sep 2023 15:51:36 +0200
Message-ID: <20230913135137.15154-2-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230913135137.15154-1-phil@nwl.cc>
References: <20230913135137.15154-1-phil@nwl.cc>
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
adjusted in between. Introduce a dedicated counter to record the number
of rules reset in this call in a less confusing way.

While being at it, prevent the direct return upon buffer exhaustion: Any
rules previously dumped into that skb would evade audit logging
otherwise.

Fixes: 9b5ba5c9c5109 ("netfilter: nf_tables: Unbreak audit log reset")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v2:
- Restore per-chain logging as requested.

Changes since v1:
- Use max_t() to eliminate the kernel warning
---
 net/netfilter/nf_tables_api.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index e429ebba74b3d..446e1882428e6 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3449,6 +3449,8 @@ static int __nf_tables_dump_rules(struct sk_buff *skb,
 	struct net *net = sock_net(skb->sk);
 	const struct nft_rule *rule, *prule;
 	unsigned int s_idx = cb->args[0];
+	unsigned int entries = 0;
+	int ret = 0;
 	u64 handle;
 
 	prule = NULL;
@@ -3471,9 +3473,11 @@ static int __nf_tables_dump_rules(struct sk_buff *skb,
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
@@ -3481,10 +3485,10 @@ static int __nf_tables_dump_rules(struct sk_buff *skb,
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
2.41.0

