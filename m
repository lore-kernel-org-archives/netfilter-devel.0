From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf] netfilter: nf_tables: allow to change chain policy without hook if it exists
Date: Tue, 17 Mar 2015 13:45:41 +0100
Message-ID: <1426596341-3533-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49270 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206AbbCQMmC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Mar 2015 08:42:02 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If there's an existing base chain, we have to allow changing the default
policy without indicating the hook information.

However, if the chain exists, we have to enforce the presence of the
hook attribute.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
This allows this syntax:

 nft add chain filter input { policy drop\; }

for an existing input base chain.

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

