From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 3/4] segtree: rename set expression set_to_segtree()
Date: Sat, 23 Apr 2016 18:08:39 +0200
Message-ID: <1461427720-4939-4-git-send-email-pablo@netfilter.org>
References: <1461427720-4939-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33750 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826AbcDWQIy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 Apr 2016 12:08:54 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id E8467114814
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Apr 2016 18:08:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D9350CE164
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Apr 2016 18:08:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C1D1CCE164
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Apr 2016 18:08:50 +0200 (CEST)
In-Reply-To: <1461427720-4939-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This function is modified by a follow up patch to take the set object,
so rename it to init.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/segtree.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/src/segtree.c b/src/segtree.c
index c8d63b8..879264b 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -327,16 +327,16 @@ static unsigned int expr_to_intervals(const struct expr *set,
 	return n;
 }
 
-static int set_to_segtree(struct list_head *msgs, struct expr *set,
+static int set_to_segtree(struct list_head *msgs, struct expr *init,
 			  struct seg_tree *tree)
 {
-	struct elementary_interval *intervals[set->size];
+	struct elementary_interval *intervals[init->size];
 	struct expr *i, *next;
 	unsigned int n;
 
-	n = expr_to_intervals(set, tree->keylen, intervals);
+	n = expr_to_intervals(init, tree->keylen, intervals);
 
-	list_for_each_entry_safe(i, next, &set->expressions, list) {
+	list_for_each_entry_safe(i, next, &init->expressions, list) {
 		list_del(&i->list);
 		expr_free(i);
 	}
@@ -349,9 +349,9 @@ static int set_to_segtree(struct list_head *msgs, struct expr *set,
 	/*
 	 * Insert elements into tree
 	 */
-	for (n = 0; n < set->size; n++) {
-		if (set->set_flags & SET_F_MAP &&
-		    n < set->size - 1 &&
+	for (n = 0; n < init->size; n++) {
+		if (init->set_flags & SET_F_MAP &&
+		    n < init->size - 1 &&
 		    interval_conflict(intervals[n], intervals[n+1]))
 			return expr_binary_error(msgs,
 					intervals[n]->expr,
-- 
2.1.4

