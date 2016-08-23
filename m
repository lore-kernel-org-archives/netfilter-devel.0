From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] dynset prefix support
Date: Tue, 23 Aug 2016 17:11:17 +0200
Message-ID: <1471965079-1036-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58676 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750927AbcHWPLe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Aug 2016 11:11:34 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0336FC0B39
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Aug 2016 17:11:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EA887DA7FC
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Aug 2016 17:11:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E1CC3100A68
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Aug 2016 17:11:26 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

table ip filter {
        chain input {
                type filter hook input priority 0;

                flow table xyz { ip saddr & 255.255.255.0 counter packets 0 bytes 0}
        }
}

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c     | 14 +++++++++-----
 src/parser_bison.y |  6 ++++++
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 8116735..d9984e5 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -656,12 +656,16 @@ static int expr_evaluate_prefix(struct eval_ctx *ctx, struct expr **expr)
 	if (expr_evaluate(ctx, &prefix->prefix) < 0)
 		return -1;
 	base = prefix->prefix;
-	assert(expr_is_constant(base));
 
-	prefix->dtype	  = base->dtype;
-	prefix->byteorder = base->byteorder;
-	prefix->len	  = base->len;
-	prefix->flags	 |= EXPR_F_CONSTANT;
+	if (expr_is_constant(base)) {
+		prefix->dtype	  = base->dtype;
+		prefix->byteorder = base->byteorder;
+		prefix->len	  = base->len;
+		prefix->flags	 |= EXPR_F_CONSTANT;
+	} else {
+		*expr = base;
+	}
+
 	return 0;
 }
 
diff --git a/src/parser_bison.y b/src/parser_bison.y
index e16b8a3..f06df6f 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1950,6 +1950,12 @@ concat_expr		:	basic_expr
 				}
 				compound_expr_add($$, $3);
 			}
+			|	basic_expr	SLASH	NUM
+			{
+				$$ = prefix_expr_alloc(&@$, $1, $3);
+			}
+			;
+
 			;
 
 prefix_rhs_expr		:	basic_rhs_expr	SLASH	NUM
-- 
2.1.4

