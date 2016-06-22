From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] segtree: don't check for overlaps if set definition is empty
Date: Wed, 22 Jun 2016 13:07:02 +0200
Message-ID: <1466593622-22159-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41914 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390AbcFVLHU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Jun 2016 07:07:20 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id A163E49224C
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2016 13:07:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 91F0564496
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2016 13:07:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 2833264480
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2016 13:07:15 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If the set comes without definition (ie. no elements) then skip check
for overlaps since set->init is NULL.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/segtree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/segtree.c b/src/segtree.c
index 74f0fb3..fa11967 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -377,7 +377,7 @@ static int set_to_segtree(struct list_head *msgs, struct set *set,
 	/* We are updating an existing set with new elements, check if the new
 	 * interval overlaps with any of the existing ones.
 	 */
-	if (add && set->init != init) {
+	if (add && set->init && set->init != init) {
 		err = set_overlap(msgs, set, init, tree->keylen);
 		if (err < 0)
 			return err;
-- 
2.1.4

