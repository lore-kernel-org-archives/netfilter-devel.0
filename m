From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 1/4] netfilter: nf_tables: fix set selection when timeouts are requested
Date: Sun,  5 Apr 2015 14:41:05 +0200
Message-ID: <1428237668-31789-2-git-send-email-kaber@trash.net>
References: <1428237668-31789-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57771 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308AbbDEMlL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Apr 2015 08:41:11 -0400
In-Reply-To: <1428237668-31789-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The NFT_SET_TIMEOUT flag is ignore in nft_select_set_ops, which may
lead to selection of a set implementation that doesn't actually
support timeouts.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 3aa92b3..0dab872 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2159,7 +2159,7 @@ nft_select_set_ops(const struct nlattr * const nla[],
 	features = 0;
 	if (nla[NFTA_SET_FLAGS] != NULL) {
 		features = ntohl(nla_get_be32(nla[NFTA_SET_FLAGS]));
-		features &= NFT_SET_INTERVAL | NFT_SET_MAP;
+		features &= NFT_SET_INTERVAL | NFT_SET_MAP | NFT_SET_TIMEOUT;
 	}
 
 	bops	   = NULL;
-- 
2.1.0

