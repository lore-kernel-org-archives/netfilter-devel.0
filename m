From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] netfilter: nf_tables: fix loop checking with set element data
Date: Fri,  7 Feb 2014 16:23:51 +0100
Message-ID: <1391786631-4070-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, --confirm=always@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46976 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620AbaBGPYA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Feb 2014 10:24:00 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch fixes two bugs:

* Restrict the validation to verdict maps only, since struct nft_data
  is declared as a union, data[0] may contain the values -3 or -4 which
  match with NFT_JUMP and NFT_GOTO. I think this will result in crash
  while performing the chain loop validation.

* Access to uninitialized data for end interval elements. The element
  data part is uninitialized in interval end elements.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index d0c790e3e..522becb 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2998,6 +2998,11 @@ static int nf_tables_loop_check_setelem(const struct nft_ctx *ctx,
 					const struct nft_set_iter *iter,
 					const struct nft_set_elem *elem)
 {
+	if (!(set->flags & NFT_SET_MAP) ||
+	    set->dtype != NFT_DATA_VERDICT ||
+	    elem->flags & NFT_SET_ELEM_INTERVAL_END)
+		return 0;
+
 	switch (elem->data.verdict) {
 	case NFT_JUMP:
 	case NFT_GOTO:
-- 
1.7.10.4

