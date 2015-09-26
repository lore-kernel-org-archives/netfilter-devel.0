From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 2/2] rule: don't reorder protocol payload expressions when merging
Date: Sat, 26 Sep 2015 05:14:03 +0200
Message-ID: <1443237243-4571-2-git-send-email-fw@strlen.de>
References: <1443237243-4571-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:34196 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932310AbbIZDOU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Sep 2015 23:14:20 -0400
In-Reply-To: <1443237243-4571-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

An instruction like

 bridge filter input ip saddr 1.2.3.4 ether saddr a:b:c:d:e:f

is displayed as

unknown unknown 0x1020304 [invalid type] ether saddr 00:0f:54:0c:11:04 ether type ip

.. because the (implicit) 'ether type ip' that is injected before the
network header match gets merged into the ether saddr instruction.

This inverts the merge in case the merge candidate contains
a next header protocol field.

After this change, the rule will be displayed as

bridge filter input ether saddr a:b:c:d:e:f ip saddr 1.2.3.4

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/rule.c | 49 ++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 42 insertions(+), 7 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index 92b83f0..3c526cc 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1179,30 +1179,65 @@ static int payload_match_stmt_cmp(const void *p1, const void *p2)
 
 static void payload_do_merge(struct stmt *sa[], unsigned int n)
 {
-	struct expr *last, *this, *expr;
+	struct expr *last, *this, *expr1, *expr2;
 	struct stmt *stmt;
-	unsigned int i;
+	unsigned int i, j;
 
 	qsort(sa, n, sizeof(sa[0]), payload_match_stmt_cmp);
 
 	last = sa[0]->expr;
-	for (i = 1; i < n; i++) {
+	for (j = 0, i = 1; i < n; i++) {
 		stmt = sa[i];
 		this = stmt->expr;
 
 		if (!payload_is_adjacent(last->left, this->left) ||
 		    last->op != this->op) {
 			last = this;
+			j = i;
 			continue;
 		}
 
-		expr = payload_expr_join(last->left, this->left);
+		expr1 = payload_expr_join(last->left, this->left);
+		expr2 = constant_expr_join(last->right, this->right);
+
+		/* We can merge last into this, but we can't replace
+		 * the statement associated with this if it does contain
+		 * a higher level protocol.
+		 *
+		 * ether type ip ip saddr X ether saddr Y
+		 * ... can be changed to
+		 * ether type ip ether saddr Y ip saddr X
+		 * ... but not
+		 * ip saddr X ether type ip ether saddr Y
+		 *
+		 * The latter form means we perform ip saddr test before
+		 * ensuring ip dependency, plus it makes decoding harder
+		 * since we don't know the type of the network header
+		 * right away.
+		 *
+		 * So, if we're about to replace a statement
+		 * containing a protocol identifier, just swap this and last
+		 * and replace the other one (i.e., replace 'load ether type ip'
+		 * with the combined 'load both ether type and saddr') and not
+		 * the other way around.
+		 */
+		if (this->left->flags & EXPR_F_PROTOCOL) {
+			struct expr *tmp = last;
+
+			last = this;
+			this = tmp;
+
+			expr1->flags |= EXPR_F_PROTOCOL;
+			stmt = sa[j];
+			assert(stmt->expr == this);
+			j = i;
+		}
+
 		expr_free(last->left);
-		last->left = expr;
+		last->left = expr1;
 
-		expr = constant_expr_join(last->right, this->right);
 		expr_free(last->right);
-		last->right = expr;
+		last->right = expr2;
 
 		list_del(&stmt->list);
 		stmt_free(stmt);
-- 
2.0.5

