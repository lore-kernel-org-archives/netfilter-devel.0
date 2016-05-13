From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 1/2] parser_bison: update flow table syntax
Date: Fri, 13 May 2016 20:08:28 +0200
Message-ID: <1463162909-23139-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35284 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751573AbcEMSIn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 May 2016 14:08:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 9BE9F1EFDA3
	for <netfilter-devel@vger.kernel.org>; Fri, 13 May 2016 20:08:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8C1CACA100
	for <netfilter-devel@vger.kernel.org>; Fri, 13 May 2016 20:08:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C37722687C1
	for <netfilter-devel@vger.kernel.org>; Fri, 13 May 2016 20:08:37 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Before we release next nft version, update the syntax to wrap the flow
table definition between brackets, eg.

 # nft add rule filter input tcp dport 22 ct state new \
	flow table ssh { ip saddr limit rate 10/second }

 # nft add rule filter input \
        flow table acct { iif . ip saddr timeout 60s counter }

When playing around with this in your initial patchset I found very
confusing that it may not look obvious to users that they can only use
one single statement.

For example:

 # nft add rule filter input \
        flow table acct iif . ip saddr timeout 60s counter limit rate 10/second
                                                           ~~~~~~~~~~~~~~~~~~~~

Note that this limit rate applies globally, so this patch resolves this
ambiguity.

This may cause us problems in the future too if we extend this to
support more than one single statement per flowtable entry (Not
telling we need this now, but if someone comes up with a useful
usecase, we should be capable of extending this).

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y | 12 ++++++------
 src/statement.c    |  2 ++
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 8a7785b..76cf65c 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1765,17 +1765,17 @@ set_stmt_op		:	ADD	{ $$ = NFT_DYNSET_OP_ADD; }
 			|	UPDATE	{ $$ = NFT_DYNSET_OP_UPDATE; }
 			;
 
-flow_stmt		:	flow_stmt_alloc		flow_stmt_opts	flow_key_expr	stmt
+flow_stmt		:	flow_stmt_alloc		flow_stmt_opts	'{' flow_key_expr stmt '}'
 			{
-				$1->flow.key  = $3;
-				$1->flow.stmt = $4;
+				$1->flow.key  = $4;
+				$1->flow.stmt = $5;
 				$$->location  = @$;
 				$$ = $1;
 			}
-			|	flow_stmt_alloc		flow_key_expr	stmt
+			|	flow_stmt_alloc		'{' flow_key_expr stmt '}'
 			{
-				$1->flow.key  = $2;
-				$1->flow.stmt = $3;
+				$1->flow.key  = $3;
+				$1->flow.stmt = $4;
 				$$->location  = @$;
 				$$ = $1;
 			}
diff --git a/src/statement.c b/src/statement.c
index 988cfeb..76f528b 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -112,9 +112,11 @@ static void flow_stmt_print(const struct stmt *stmt)
 		expr_print(stmt->flow.set);
 		printf(" ");
 	}
+	printf("{ ");
 	expr_print(stmt->flow.key);
 	printf(" ");
 	stmt_print(stmt->flow.stmt);
+	printf("} ");
 }
 
 static void flow_stmt_destroy(struct stmt *stmt)
-- 
2.1.4

