From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] segtree: keep element comments in set intervals
Date: Wed,  9 Nov 2016 00:19:45 +0100
Message-ID: <1478647185-25289-1-git-send-email-pablo@netfilter.org>
Cc: netfilter@d9c.eu
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33208 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752269AbcKHXT5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Nov 2016 18:19:57 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EAB7C8D0504
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Nov 2016 00:19:53 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DA9A3DA801
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Nov 2016 00:19:53 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4C317DA801
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Nov 2016 00:19:49 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The conversion from the set element range representation to element
intervals doesn't keep the comment information around.

Fixes: https://bugzilla.netfilter.org/show_bug.cgi?id=1090
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/segtree.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/src/segtree.c b/src/segtree.c
index fa11967adbd2..32e071f6b5e8 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -522,9 +522,13 @@ static void set_insert_interval(struct expr *set, struct seg_tree *tree,
 	mpz_set(expr->value, ei->left);
 	expr = set_elem_expr_alloc(&internal_location, expr);
 
-	if (ei->expr != NULL && ei->expr->ops->type == EXPR_MAPPING)
-		expr = mapping_expr_alloc(&ei->expr->location, expr,
-					  expr_get(ei->expr->right));
+	if (ei->expr != NULL) {
+		if (ei->expr->comment)
+			expr->comment = xstrdup(ei->expr->comment);
+		if (ei->expr->ops->type == EXPR_MAPPING)
+			expr = mapping_expr_alloc(&ei->expr->location, expr,
+						  expr_get(ei->expr->right));
+	}
 
 	if (ei->flags & EI_F_INTERVAL_END)
 		expr->flags |= EXPR_F_INTERVAL_END;
-- 
2.1.4

