Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9A3CC001DC
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Jul 2023 15:25:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234093AbjGZPZq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 26 Jul 2023 11:25:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233909AbjGZPZp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Jul 2023 11:25:45 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26D7394;
        Wed, 26 Jul 2023 08:25:45 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qOgOS-0001Hn-H8; Wed, 26 Jul 2023 17:25:40 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Kevin Rich <kevinrich1337@gmail.com>
Subject: [PATCH net 3/3] netfilter: nf_tables: disallow rule addition to bound chain via NFTA_RULE_CHAIN_ID
Date:   Wed, 26 Jul 2023 17:23:49 +0200
Message-ID: <20230726152524.26268-4-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230726152524.26268-1-fw@strlen.de>
References: <20230726152524.26268-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

Bail out with EOPNOTSUPP when adding rule to bound chain via
NFTA_RULE_CHAIN_ID. The following warning splat is shown when
adding a rule to a deleted bound chain:

 WARNING: CPU: 2 PID: 13692 at net/netfilter/nf_tables_api.c:2013 nf_tables_chain_destroy+0x1f7/0x210 [nf_tables]
 CPU: 2 PID: 13692 Comm: chain-bound-rul Not tainted 6.1.39 #1
 RIP: 0010:nf_tables_chain_destroy+0x1f7/0x210 [nf_tables]

Fixes: d0e2c7de92c7 ("netfilter: nf_tables: add NFT_CHAIN_BINDING")
Reported-by: Kevin Rich <kevinrich1337@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index b9a4d3fd1d34..d3c6ecd1f5a6 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3811,8 +3811,6 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
 			NL_SET_BAD_ATTR(extack, nla[NFTA_RULE_CHAIN]);
 			return PTR_ERR(chain);
 		}
-		if (nft_chain_is_bound(chain))
-			return -EOPNOTSUPP;
 
 	} else if (nla[NFTA_RULE_CHAIN_ID]) {
 		chain = nft_chain_lookup_byid(net, table, nla[NFTA_RULE_CHAIN_ID],
@@ -3825,6 +3823,9 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
 		return -EINVAL;
 	}
 
+	if (nft_chain_is_bound(chain))
+		return -EOPNOTSUPP;
+
 	if (nla[NFTA_RULE_HANDLE]) {
 		handle = be64_to_cpu(nla_get_be64(nla[NFTA_RULE_HANDLE]));
 		rule = __nft_rule_lookup(chain, handle);
-- 
2.41.0

