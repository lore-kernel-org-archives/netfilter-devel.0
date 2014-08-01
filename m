From: Thomas Graf <tgraf@suug.ch>
Subject: [PATCH] nftables: Avoid duplicate call to nft_data_uninit() for same key
Date: Fri,  1 Aug 2014 17:25:38 +0200
Message-ID: <b7a5a0e246bbe94de1f14594586e1ce75dc311bb.1406906631.git.tgraf@suug.ch>
Cc: kaber@trash.net, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:53242 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140AbaHAPZk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Aug 2014 11:25:40 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nft_del_setelem() currently calls nft_data_uninit() twice on the same
key. Once to release the key which is guaranteed to be NFT_DATA_VALUE
and a second time in the error path to which it falls through.

The second call has been harmless so far though because the type
passed is always NFT_DATA_VALUE which is currently a no-op.

Signed-off-by: Thomas Graf <tgraf@suug.ch>
---
 net/netfilter/nf_tables_api.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 8746ff9..b35ba83 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3218,6 +3218,7 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 	if (set->flags & NFT_SET_MAP)
 		nft_data_uninit(&elem.data, set->dtype);
 
+	return 0;
 err2:
 	nft_data_uninit(&elem.key, desc.type);
 err1:
-- 
1.9.3

