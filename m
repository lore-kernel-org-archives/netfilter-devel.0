From: Elise Lennion <elise.lennion@gmail.com>
Subject: [PATCH nft v2 2/2] src: Always print range expressions numerically
Date: Thu, 2 Feb 2017 10:31:56 -0200
Message-ID: <20170202123156.GA17914@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:35405 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751540AbdBBMcD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Feb 2017 07:32:03 -0500
Received: by mail-qt0-f194.google.com with SMTP id s58so3597861qtc.2
        for <netfilter-devel@vger.kernel.org>; Thu, 02 Feb 2017 04:32:03 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Because the rules are more legible this way. Also, the parser doesn't
accept strings on ranges, so, printing ranges numerically better match
the rules definition.

Fixes(Bug 1046 - mobility header with range gives illegible rule).

Signed-off-by: Elise Lennion <elise.lennion@gmail.com>
---

 v2: Replace ternary operator with if statements.
     Remove the new NUMERIC_CONSTANT, now uses a value bigger than
     NUMERIC_ALL to print symbolic constants as numbers, this case
     is only met during expr_range_print.

 src/datatype.c   | 8 +++++++-
 src/expression.c | 2 ++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/src/datatype.c b/src/datatype.c
index 1518606..d697a07 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -175,9 +175,15 @@ void symbolic_constant_print(const struct symbol_table *tbl,
 		return expr_basetype(expr)->print(expr);
 
 	if (quotes)
-		printf("\"%s\"", s->identifier);
+		printf("\"");
+
+	if (numeric_output > NUMERIC_ALL)
+		printf("%lu", val);
 	else
 		printf("%s", s->identifier);
+
+	if (quotes)
+		printf("\"");
 }
 
 static void switch_byteorder(void *data, unsigned int len)
diff --git a/src/expression.c b/src/expression.c
index 1567870..da94b79 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -597,9 +597,11 @@ struct expr *relational_expr_alloc(const struct location *loc, enum ops op,
 
 static void range_expr_print(const struct expr *expr)
 {
+	numeric_output += NUMERIC_ALL + 1;
 	expr_print(expr->left);
 	printf("-");
 	expr_print(expr->right);
+	numeric_output -= NUMERIC_ALL + 1;
 }
 
 static void range_expr_clone(struct expr *new, const struct expr *expr)
-- 
2.7.4

