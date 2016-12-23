From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 07/10] parser_bison: allow RESET token from rhs
Date: Fri, 23 Dec 2016 15:26:52 +0100
Message-ID: <1482503215-25422-7-git-send-email-pablo@netfilter.org>
References: <1482503215-25422-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40176 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S941185AbcLWO1P (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 23 Dec 2016 09:27:15 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 557252519A0
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Dec 2016 15:27:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4777F8E670
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Dec 2016 15:27:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1006D8E671
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Dec 2016 15:27:12 +0100 (CET)
In-Reply-To: <1482503215-25422-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Stateful objects have introduced a RESET token in the parser. This breaks the
use of RESET from the rhs, to fix this:

1) I added a new rule to catch this case, thus, dccp doesn't break.
2) Update reject_opts so reject with tcp reset still works.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index b571fbbed5f3..5b829a243128 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1897,15 +1897,9 @@ reject_opts		:       /* empty */
 							  $4);
 				$<stmt>0->reject.expr->dtype = &icmpx_code_type;
 			}
-			|	WITH	TCP	STRING
+			|	WITH	TCP	RESET
 			{
-				if (strcmp($3, "reset") == 0) {
-					$<stmt>0->reject.type = NFT_REJECT_TCP_RST;
-				} else {
-					erec_queue(error(&@2, "unsupported reject type", $3),
-						   state->msgs);
-					YYERROR;
-				}
+				$<stmt>0->reject.type = NFT_REJECT_TCP_RST;
 			}
 			;
 
@@ -2721,6 +2715,12 @@ primary_rhs_expr	:	symbol_expr		{ $$ = $1; }
 						       current_scope(state),
 						       "ecn");
 			}
+			|	RESET
+			{
+				$$ = symbol_expr_alloc(&@$, SYMBOL_VALUE,
+						       current_scope(state),
+						       "reset");
+			}
 			;
 
 relational_op		:	EQ		{ $$ = OP_EQ; }
-- 
2.1.4

