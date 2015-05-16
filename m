From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH -stable] netfilter: nf_tables: allow to change chain policy without hook if it exists
Date: Sat, 16 May 2015 20:50:50 +0200
Message-ID: <1431802251-4781-6-git-send-email-pablo@netfilter.org>
References: <1431802251-4781-1-git-send-email-pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
To: stable@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43092 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751974AbbEPSqN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 May 2015 14:46:13 -0400
In-Reply-To: <1431802251-4781-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[ upstream commit d6b6cb1d3e6f78d55c2d4043d77d0d8def3f3b99 ]

If there's an existing base chain, we have to allow to change the
default policy without indicating the hook information.

However, if the chain doesn't exists, we have to enforce the presence of
the hook attribute.

Cc: <stable@vger.kernel.org> # 3.14.x
Cc: <stable@vger.kernel.org> # 3.18.x
Cc: <stable@vger.kernel.org> # 3.19.x
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 6ab7779..ac1a952 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1225,7 +1225,10 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 
 	if (nla[NFTA_CHAIN_POLICY]) {
 		if ((chain != NULL &&
-		    !(chain->flags & NFT_BASE_CHAIN)) ||
+		    !(chain->flags & NFT_BASE_CHAIN)))
+			return -EOPNOTSUPP;
+
+		if (chain == NULL &&
 		    nla[NFTA_CHAIN_HOOK] == NULL)
 			return -EOPNOTSUPP;
 
-- 
1.7.10.4

