From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH 1/3] evaluate: check for NULL datatype in rhs in lookup
 expr
Date: Wed, 11 May 2016 13:30:02 +0200
Message-ID: <146296620273.3706.17267671338035433056.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:37895 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751551AbcEKLaM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 May 2016 07:30:12 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id 046C751F227
	for <netfilter-devel@vger.kernel.org>; Wed, 11 May 2016 11:30:09 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9hPmE6qS8-Hv for <netfilter-devel@vger.kernel.org>;
	Wed, 11 May 2016 13:30:04 +0200 (CEST)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
	(Authenticated sender: servers@cica.es)
	by smtp.cica.es (Postfix) with ESMTP id 153A251F21E
	for <netfilter-devel@vger.kernel.org>; Wed, 11 May 2016 13:30:03 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If we are evaluating an EXPR_SET_REF, check if right->dtype is not NULL.
We can hit SEGFAULT if for whatever reason the referenced object does not
exists.

Using this testfile (note the invalid set syntax):

% cat test.nft
flush ruleset
add table t
add chain t c
add set t s {type ipv4_addr\;}
add rule t c ip saddr @s

Without this patch:

% nft -f test.nft
Segmentation fault

With this patch:

% nft -f test.nft
t.nft:4:28-28: Error: syntax error, unexpected junk, expecting newline or semicolon
add set t s {type ipv4_addr\;}
                           ^
t.nft:4:13-29: Error: set definition does not specify key data type
add set t s {type ipv4_addr\;}
            ^^^^^^^^^^^^^^^^^
t.nft:5:23-24: Error: the referenced object does not exists
add rule t c ip saddr @s
             ~~~~~~~~ ^^

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/evaluate.c |   35 ++++++++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 9 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 7444d09..6840790 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1210,16 +1210,33 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
 
 	switch (rel->op) {
 	case OP_LOOKUP:
-		/* A literal set expression implicitly declares the set */
-		if (right->ops->type == EXPR_SET)
+		switch (right->ops->type) {
+		case EXPR_SET:
+			/* A literal set expression implicitly declares
+			 * the set
+			 */
 			right = rel->right =
-				implicit_set_declaration(ctx, left->dtype, left->len, right);
-		else if (!datatype_equal(left->dtype, right->dtype))
-			return expr_binary_error(ctx->msgs, right, left,
-						 "datatype mismatch, expected %s, "
-						 "set has type %s",
-						 left->dtype->desc,
-						 right->dtype->desc);
+				implicit_set_declaration(ctx, left->dtype,
+							 left->len, right);
+			break;
+		case EXPR_SET_REF:
+			if (right->dtype == NULL)
+				return expr_binary_error(ctx->msgs, right,
+							 left, "the referenced"
+							 " object does not "
+							 "exists");
+			if (!datatype_equal(left->dtype, right->dtype))
+				return expr_binary_error(ctx->msgs, right,
+							 left, "datatype "
+							 "mismatch, expected "
+							 "%s, set has type %s",
+							 left->dtype->desc,
+							 right->dtype->desc);
+			break;
+		default:
+			BUG("unhandled right expression type %u\n",
+			    right->ops->type);
+		}
 
 		/* Data for range lookups needs to be in big endian order */
 		if (right->set->flags & SET_F_INTERVAL &&

