Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA1A2C7EE2C
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 May 2023 15:16:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232108AbjEPPQS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 16 May 2023 11:16:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233910AbjEPPQQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 May 2023 11:16:16 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 24BB05FC2;
        Tue, 16 May 2023 08:16:15 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, sashal@kernel.org,
        stable@vger.kernel.org
Subject: [PATCH -stable,4.14 7/8] netfilter: nf_tables: do not allow RULE_ID to refer to another chain
Date:   Tue, 16 May 2023 17:16:05 +0200
Message-Id: <20230516151606.4892-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230516151606.4892-1-pablo@netfilter.org>
References: <20230516151606.4892-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

[ 36d5b2913219ac853908b0f1c664345e04313856 ]

When doing lookups for rules on the same batch by using its ID, a rule from
a different chain can be used. If a rule is added to a chain but tries to
be positioned next to a rule from a different chain, it will be linked to
chain2, but the use counter on chain1 would be the one to be incremented.

When looking for rules by ID, use the chain that was used for the lookup by
name. The chain used in the context copied to the transaction needs to
match that same chain. That way, struct nft_rule does not need to get
enlarged with another member.

Fixes: 1a94e38d254b ("netfilter: nf_tables: add NFTA_RULE_ID attribute")
Fixes: 75dd48e2e420 ("netfilter: nf_tables: Support RULE_ID reference in new rule")
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 9caaac459ca9..86913d53eead 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2475,6 +2475,7 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
 }
 
 static struct nft_rule *nft_rule_lookup_byid(const struct net *net,
+					     const struct nft_chain *chain,
 					     const struct nlattr *nla)
 {
 	u32 id = ntohl(nla_get_be32(nla));
@@ -2484,6 +2485,7 @@ static struct nft_rule *nft_rule_lookup_byid(const struct net *net,
 		struct nft_rule *rule = nft_trans_rule(trans);
 
 		if (trans->msg_type == NFT_MSG_NEWRULE &&
+		    trans->ctx.chain == chain &&
 		    id == nft_trans_rule_id(trans))
 			return rule;
 	}
@@ -2530,7 +2532,7 @@ static int nf_tables_delrule(struct net *net, struct sock *nlsk,
 
 			err = nft_delrule(&ctx, rule);
 		} else if (nla[NFTA_RULE_ID]) {
-			rule = nft_rule_lookup_byid(net, nla[NFTA_RULE_ID]);
+			rule = nft_rule_lookup_byid(net, chain, nla[NFTA_RULE_ID]);
 			if (IS_ERR(rule))
 				return PTR_ERR(rule);
 
-- 
2.30.2

