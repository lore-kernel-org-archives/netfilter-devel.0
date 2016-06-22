From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 6/6] netfilter: nft_hash: support deletion of inactive elements
Date: Wed, 22 Jun 2016 13:14:32 +0200
Message-ID: <1466594072-24043-6-git-send-email-pablo@netfilter.org>
References: <1466594072-24043-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44266 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175AbcFVLQV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Jun 2016 07:16:21 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 29F4D492243
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2016 13:14:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 18EB29EBA5
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2016 13:14:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 58A5C9EBA5
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2016 13:14:41 +0200 (CEST)
In-Reply-To: <1466594072-24043-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

New elements are inactive in the preparation phase, and its
NFT_SET_ELEM_BUSY_MASK flag is set on.

This busy flag doesn't allow us to delete it from the same transaction,
following a sequence like:

	begin transaction
	add element X
	delete element X
	end transaction

This sequence is valid and may be triggered by robots. To resolve this
problem, allow deactivating elements that are active in the current
generation (ie. those that has been just added in this batch).

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_hash.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
index f39c53a..ea92481 100644
--- a/net/netfilter/nft_hash.c
+++ b/net/netfilter/nft_hash.c
@@ -153,9 +153,10 @@ static void *nft_hash_deactivate(const struct nft_set *set,
 				 const struct nft_set_elem *elem)
 {
 	struct nft_hash *priv = nft_set_priv(set);
+	struct net *net = read_pnet(&set->pnet);
 	struct nft_hash_elem *he;
 	struct nft_hash_cmp_arg arg = {
-		.genmask = nft_genmask_next(read_pnet(&set->pnet)),
+		.genmask = nft_genmask_next(net),
 		.set	 = set,
 		.key	 = elem->key.val.data,
 	};
@@ -163,7 +164,8 @@ static void *nft_hash_deactivate(const struct nft_set *set,
 	rcu_read_lock();
 	he = rhashtable_lookup_fast(&priv->ht, &arg, nft_hash_params);
 	if (he != NULL) {
-		if (!nft_set_elem_mark_busy(&he->ext))
+		if (!nft_set_elem_mark_busy(&he->ext) ||
+		    !nft_is_active(net, &he->ext))
 			nft_set_elem_change_active(set, &he->ext);
 		else
 			he = NULL;
-- 
2.1.4

