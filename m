From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 2/4] ct: refactor print function so it can be re-used for ct statement
Date: Tue, 28 Feb 2017 01:03:46 +0100
Message-ID: <1488240228-1536-2-git-send-email-pablo@netfilter.org>
References: <1488240228-1536-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36444 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751468AbdB1CAn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Feb 2017 21:00:43 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B9406E62C
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Feb 2017 01:04:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A99E4DA793
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Feb 2017 01:04:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 643C6DA807
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Feb 2017 01:03:53 +0100 (CET)
In-Reply-To: <1488240228-1536-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Florian Westphal <fw@strlen.de>

Once directional zone support is added we also need to print the
direction of the statement, so factor the common code to re-use
this helper from the statement print function.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Just a rebase on top of series to store byteorder for set data in
NFTA_SET_USERDATA.

 src/ct.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/src/ct.c b/src/ct.c
index 99f450a77c67..3a6a4e574d69 100644
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
2.1.4

