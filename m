From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/2] netfilter: nf_tables: do not allow NFT_SET_ELEM_INTERVAL_END flag and data
Date: Fri,  7 Feb 2014 14:15:46 +0100
Message-ID: <1391778947-8957-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45590 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752885AbaBGNP4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Feb 2014 08:15:56 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This combination is not allowed since end interval elements cannot
contain data.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Let's just make sure that userspace don't feed us with things that
we don't allow.

 net/netfilter/nf_tables_api.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 3a2e480..d0c790e3e 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2741,6 +2741,9 @@ static int nft_add_set_elem(const struct nft_ctx *ctx, struct nft_set *set,
 		if (nla[NFTA_SET_ELEM_DATA] == NULL &&
 		    !(elem.flags & NFT_SET_ELEM_INTERVAL_END))
 			return -EINVAL;
+		if (nla[NFTA_SET_ELEM_DATA] != NULL &&
+		    elem.flags & NFT_SET_ELEM_INTERVAL_END)
+			return -EINVAL;
 	} else {
 		if (nla[NFTA_SET_ELEM_DATA] != NULL)
 			return -EINVAL;
-- 
1.7.10.4

