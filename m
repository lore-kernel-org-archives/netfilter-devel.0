From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/2 v2] netfilter: nf_tables: fix loop checking with end interval elements
Date: Fri,  7 Feb 2014 17:29:57 +0100
Message-ID: <1391790598-5390-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59191 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750787AbaBGQaL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Feb 2014 11:30:11 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fix access to uninitialized data for end interval elements. The
element data part is uninitialized in interval end elements.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: don't remove inline from nft_chain_stats.

 net/netfilter/nf_tables_api.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index d0c790e3e..adce01e 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2998,6 +2998,9 @@ static int nf_tables_loop_check_setelem(const struct nft_ctx *ctx,
 					const struct nft_set_iter *iter,
 					const struct nft_set_elem *elem)
 {
+	if (elem->flags & NFT_SET_ELEM_INTERVAL_END)
+		return 0;
+
 	switch (elem->data.verdict) {
 	case NFT_JUMP:
 	case NFT_GOTO:
-- 
1.7.10.4

