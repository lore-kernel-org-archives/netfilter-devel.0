Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1EADC43334
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 Jun 2022 16:44:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbiF2Qof (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 Jun 2022 12:44:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbiF2Qoe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Jun 2022 12:44:34 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AF4DB2CCAC
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Jun 2022 09:44:32 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] evaluate: report missing interval flag when using prefix/range in concatenation
Date:   Wed, 29 Jun 2022 18:44:28 +0200
Message-Id: <20220629164428.164091-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If set declaration is missing the interval flag, and user specifies an
element with either prefix or range, then bail out.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1592
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c                      | 25 ++++++++++++++++++++-----
 tests/shell/testcases/sets/errors_0 | 16 ++++++++++++++++
 2 files changed, 36 insertions(+), 5 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 073bf8717236..9ae525769bc3 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1431,10 +1431,9 @@ static int __expr_evaluate_set_elem(struct eval_ctx *ctx, struct expr *elem)
 static int expr_evaluate_set_elem(struct eval_ctx *ctx, struct expr **expr)
 {
 	struct expr *elem = *expr;
+	const struct expr *key;
 
 	if (ctx->set) {
-		const struct expr *key;
-
 		if (__expr_evaluate_set_elem(ctx, elem) < 0)
 			return -1;
 
@@ -1451,9 +1450,19 @@ static int expr_evaluate_set_elem(struct eval_ctx *ctx, struct expr **expr)
 		switch (elem->key->etype) {
 		case EXPR_PREFIX:
 		case EXPR_RANGE:
-			return expr_error(ctx->msgs, elem,
-					  "You must add 'flags interval' to your %s declaration if you want to add %s elements",
-					  set_is_map(ctx->set->flags) ? "map" : "set", expr_name(elem->key));
+			key = elem->key;
+			goto err_missing_flag;
+		case EXPR_CONCAT:
+			list_for_each_entry(key, &elem->key->expressions, list) {
+				switch (key->etype) {
+				case EXPR_PREFIX:
+				case EXPR_RANGE:
+					goto err_missing_flag;
+				default:
+					break;
+				}
+			}
+			break;
 		default:
 			break;
 		}
@@ -1462,7 +1471,13 @@ static int expr_evaluate_set_elem(struct eval_ctx *ctx, struct expr **expr)
 	datatype_set(elem, elem->key->dtype);
 	elem->len   = elem->key->len;
 	elem->flags = elem->key->flags;
+
 	return 0;
+
+err_missing_flag:
+	return expr_error(ctx->msgs, key,
+			  "You must add 'flags interval' to your %s declaration if you want to add %s elements",
+			  set_is_map(ctx->set->flags) ? "map" : "set", expr_name(key));
 }
 
 static const struct expr *expr_set_elem(const struct expr *expr)
diff --git a/tests/shell/testcases/sets/errors_0 b/tests/shell/testcases/sets/errors_0
index 569f4ab830cd..f2da43a009b9 100755
--- a/tests/shell/testcases/sets/errors_0
+++ b/tests/shell/testcases/sets/errors_0
@@ -38,4 +38,20 @@ create table inet filter
 set inet filter foo {}
 add element inet filter foo { foobar }"
 
+$NFT -f - <<< $RULESET
+if [ $? -eq 0 ]
+then
+	exit 1
+fi
+
+RULESET="table ip x {
+        map x {
+                type ifname . ipv4_addr : verdict
+                elements = { if2 . 10.0.0.2 : jump chain2,
+                             if2 . 192.168.0.0/24 : jump chain2 }
+        }
+
+        chain chain2 {}
+}"
+
 $NFT -f - <<< $RULESET || exit 0
-- 
2.30.2

