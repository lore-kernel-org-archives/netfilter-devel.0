From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nftables 7/9] ct: refactor print function so it can be re-used for ct statement
Date: Fri,  3 Feb 2017 13:35:54 +0100
Message-ID: <20170203123556.17357-8-fw@strlen.de>
References: <20170203123556.17357-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:41980 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752700AbdBCMgC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Feb 2017 07:36:02 -0500
In-Reply-To: <20170203123556.17357-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Once directional zone support is added we also need to print the
direction of the statement, so factor the common code to re-use
this helper from the statement print function.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/ct.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/src/ct.c b/src/ct.c
index dffa0e5fa44a..7e09c5b246b2 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -238,22 +238,27 @@ static const struct ct_template ct_templates[] = {
 					      BYTEORDER_HOST_ENDIAN, 16),
 };
 
-static void ct_expr_print(const struct expr *expr)
+static void ct_print(enum nft_ct_keys key, int8_t dir)
 {
 	const struct symbolic_constant *s;
 
 	printf("ct ");
-	if (expr->ct.direction < 0)
+	if (dir < 0)
 		goto done;
 
 	for (s = ct_dir_tbl.symbols; s->identifier != NULL; s++) {
-		if (expr->ct.direction == (int) s->value) {
+		if (dir == (int)s->value) {
 			printf("%s ", s->identifier);
 			break;
 		}
 	}
  done:
-	printf("%s", ct_templates[expr->ct.key].token);
+	printf("%s", ct_templates[key].token);
+}
+
+static void ct_expr_print(const struct expr *expr)
+{
+	ct_print(expr->ct.key, expr->ct.direction);
 }
 
 static bool ct_expr_cmp(const struct expr *e1, const struct expr *e2)
-- 
2.10.2

