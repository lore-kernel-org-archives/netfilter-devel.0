From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 1/7] segtree: perform stricter expression type validation from expr_value()
Date: Mon, 18 Apr 2016 20:14:29 +0200
Message-ID: <1461003275-2330-2-git-send-email-pablo@netfilter.org>
References: <1461003275-2330-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35452 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751563AbcDRSO4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Apr 2016 14:14:56 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 7C182C1089
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Apr 2016 20:14:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 68B759D0EF
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Apr 2016 20:14:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id DA0D89D0FA
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Apr 2016 20:14:49 +0200 (CEST)
In-Reply-To: <1461003275-2330-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This helper function returns a expression value type that represents the
set element key. This functions currently expects two kind of
expressions: set elements and mappings.

Bail out otherwise, if we see anything else, we have to fix our code.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/segtree.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/src/segtree.c b/src/segtree.c
index 060951c..5b69ffb 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -473,10 +473,14 @@ extern void interval_map_decompose(struct expr *set);
 
 static struct expr *expr_value(struct expr *expr)
 {
-	if (expr->ops->type == EXPR_MAPPING)
+	switch (expr->ops->type) {
+	case EXPR_MAPPING:
 		return expr->left->key;
-	else
+	case EXPR_SET_ELEM:
 		return expr->key;
+	default:
+		BUG("invalid expression type %s\n", expr->ops->name);
+	}
 }
 
 static int expr_value_cmp(const void *p1, const void *p2)
-- 
2.1.4

