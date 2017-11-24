From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 1/2] parser_bison: dismiss anonymous meters
Date: Fri, 24 Nov 2017 14:28:59 +0100
Message-ID: <20171124132900.28301-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39164 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752619AbdKXN3L (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Nov 2017 08:29:11 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id F244D392E02
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Nov 2017 14:29:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E1D86DA863
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Nov 2017 14:29:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F35E9DA78E
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Nov 2017 14:29:03 +0100 (CET)
Received: from salvia.here (40.red-212-170-55.staticip.rima-tde.net [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id D977C403DF98
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Nov 2017 14:29:03 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The former 'flow table' syntax allows flow tables with no name:

 # nft add rule x y flow { ip saddr counter }

However, when listing, it leaks the name that it is autoallocating.

 # nft list ruleset
 table ip x {
        chain y {
                flow table __mt0 { ip saddr counter}
        }
 }

Which is odd since then restoring will use such a name.

Remove anonymous flow table/meters, so everyone needs to specify a name.

There is no way to fix this, given anonymous flag tells us that the set
behind this meter is bound to a rule, hence, released once the rule is
going - the term "anonymous" was not good choice as a flag in first
place. Only possibility is to strcmp for __ft to identify this is a
nameless meter, which is a hack.

Moreover, having no name means you cannot flush the set behind this
meter, which criples this feature for no reason.

On top of it, the wiki only documents named meters, and we have a record
of users complaining on this behaviour.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c     |  3 +--
 src/expression.c   | 10 +++-------
 src/parser_bison.y |  7 -------
 3 files changed, 4 insertions(+), 16 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index f30543f822e0..b0ce9f63e6c0 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2042,8 +2042,7 @@ static int stmt_evaluate_meter(struct eval_ctx *ctx, struct stmt *stmt)
 	if (key->timeout)
 		set->set_flags |= NFT_SET_TIMEOUT;
 
-	setref = implicit_set_declaration(ctx, stmt->meter.name ?: "__mt%d",
-					  key, set);
+	setref = implicit_set_declaration(ctx, stmt->meter.name, key, set);
 
 	stmt->meter.set = setref;
 
diff --git a/src/expression.c b/src/expression.c
index 273038e62d2e..dae475921476 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -930,14 +930,10 @@ struct expr *map_expr_alloc(const struct location *loc, struct expr *arg,
 
 static void set_ref_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
-	if (expr->set->flags & NFT_SET_ANONYMOUS) {
-		if (expr->set->flags & NFT_SET_EVAL)
-			nft_print(octx, "%s", expr->set->handle.set);
-		else
-			expr_print(expr->set->init, octx);
-	} else {
+	if (expr->set->flags & NFT_SET_ANONYMOUS)
+		expr_print(expr->set->init, octx);
+	else
 		nft_print(octx, "@%s", expr->set->handle.set);
-	}
 }
 
 static void set_ref_expr_clone(struct expr *new, const struct expr *expr)
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 6610b9dccc3c..d2673173bd27 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -2489,13 +2489,6 @@ meter_stmt		:	meter_stmt_alloc		meter_stmt_opts	'{' meter_key_expr stmt '}'
 				$$->location  = @$;
 				$$ = $1;
 			}
-			|	meter_stmt_alloc		'{' meter_key_expr stmt '}'
-			{
-				$1->meter.key  = $3;
-				$1->meter.stmt = $4;
-				$$->location  = @$;
-				$$ = $1;
-			}
 			;
 
 meter_stmt_alloc	:	FLOW
-- 
2.11.0

