From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] netfilter: nf_tables: fix wrong datatype in nft_validate_data_load()
Date: Sat, 28 Dec 2013 00:59:38 +0100
Message-ID: <1388188778-7590-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50899 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754924Ab3L0X7s (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Dec 2013 18:59:48 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch fixes dictionary mappings, eg.

 add rule ip filter input meta mark set tcp dport map { 22 => 1, 23 => 2, }

The kernel was returning -EINVAL in nft_validate_data_load() since
the type of the set element data that is passed was the real userspace
datatype instead of NFT_DATA_VALUE.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index b2624ed..d80480e 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2434,7 +2434,9 @@ static int nf_tables_bind_check_setelem(const struct nft_ctx *ctx,
 	enum nft_registers dreg;
 
 	dreg = nft_type_to_reg(set->dtype);
-	return nft_validate_data_load(ctx, dreg, &elem->data, set->dtype);
+	return nft_validate_data_load(ctx, dreg, &elem->data,
+				      set->dtype == NFT_DATA_VERDICT ?
+				      NFT_DATA_VERDICT : NFT_DATA_VALUE);
 }
 
 int nf_tables_bind_set(const struct nft_ctx *ctx, struct nft_set *set,
-- 
1.7.10.4

