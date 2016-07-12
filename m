From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 1/2] parser_bison: restore parsing of dynamic set element updates
Date: Tue, 12 Jul 2016 17:10:59 +0200
Message-ID: <1468336260-1766-1-git-send-email-pablo@netfilter.org>
Cc: akp@akp.dk
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36729 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754483AbcGLPLT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Jul 2016 11:11:19 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 89AE3392E0E
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Jul 2016 17:11:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 7B8CCAD81
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Jul 2016 17:11:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D4274FAB52
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Jul 2016 17:11:07 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add a new set_elem_expr_stmt production to handle dynamic set element
updates from rules.

Quickly tested this here through:

 # nft add table filter
 # nft add chain filter input { type filter hook input priority 0\; }
 # nft add set filter myset { type inet_service\; flags timeout\; }
 # nft add rule filter input set add tcp sport timeout 60s @myset
 # nft list ruleset
 table ip filter {
        set myset {
                type inet_service
                flags timeout
                elements = { http expires 9s}
        }

        chain input {
                type filter hook input priority 0; policy accept;
                set add tcp dport timeout 1m @myset
        }
 }

Fixes: a3e60492a684 ("parser: restrict relational rhs expression recursion")
Reported-by: Anders K. Pedersen <akp@akp.dk>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index d7cba23..d946e0e 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -523,6 +523,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %destructor { expr_free($$); }	set_expr set_list_expr set_list_member_expr
 %type <expr>			set_elem_expr set_elem_expr_alloc set_lhs_expr set_rhs_expr
 %destructor { expr_free($$); }	set_elem_expr set_elem_expr_alloc set_lhs_expr set_rhs_expr
+%type <expr>			set_elem_expr_stmt set_elem_expr_stmt_alloc
+%destructor { expr_free($$); }	set_elem_expr_stmt set_elem_expr_stmt_alloc
 
 %type <expr>			flow_key_expr flow_key_expr_alloc
 %destructor { expr_free($$); }	flow_key_expr flow_key_expr_alloc
@@ -1781,7 +1783,17 @@ queue_stmt_flag		:	BYPASS	{ $$ = NFT_QUEUE_FLAG_BYPASS; }
 			|	FANOUT	{ $$ = NFT_QUEUE_FLAG_CPU_FANOUT; }
 			;
 
-set_stmt		:	SET	set_stmt_op	set_elem_expr	symbol_expr
+set_elem_expr_stmt	:	set_elem_expr_stmt_alloc
+			|	set_elem_expr_stmt_alloc	set_elem_options
+			;
+
+set_elem_expr_stmt_alloc:	concat_expr
+			{
+				$$ = set_elem_expr_alloc(&@1, $1);
+			}
+			;
+
+set_stmt		:	SET	set_stmt_op	set_elem_expr_stmt	symbol_expr
 			{
 				$$ = set_stmt_alloc(&@$);
 				$$->set.op  = $2;
-- 
2.1.4

