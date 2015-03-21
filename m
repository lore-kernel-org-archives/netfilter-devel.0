From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 3/5] netfilter: nf_tables: reject NFT_SET_ELEM_INTERVAL_END flag for non-interval sets
Date: Sat, 21 Mar 2015 15:19:16 +0000
Message-ID: <1426951158-18168-4-git-send-email-kaber@trash.net>
References: <1426951158-18168-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46424 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbbCUPTX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 21 Mar 2015 11:19:23 -0400
In-Reply-To: <1426951158-18168-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 net/netfilter/nf_tables_api.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 334bf9c..820f645 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3136,6 +3136,9 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		elem.flags = ntohl(nla_get_be32(nla[NFTA_SET_ELEM_FLAGS]));
 		if (elem.flags & ~NFT_SET_ELEM_INTERVAL_END)
 			return -EINVAL;
+		if (!(set->flags & NFT_SET_INTERVAL) &&
+		    elem.flags & NFT_SET_ELEM_INTERVAL_END)
+			return -EINVAL;
 	}
 
 	if (set->flags & NFT_SET_MAP) {
-- 
2.1.0

