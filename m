Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA75FC433EF
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Nov 2021 15:04:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2049603E8
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Nov 2021 15:04:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233352AbhKEPHW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 5 Nov 2021 11:07:22 -0400
Received: from mail.netfilter.org ([217.70.188.207]:40128 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233305AbhKEPHV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 Nov 2021 11:07:21 -0400
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 114BD605C5
        for <netfilter-devel@vger.kernel.org>; Fri,  5 Nov 2021 16:02:45 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/2] evaluate: clone variable expression if there is more than one reference
Date:   Fri,  5 Nov 2021 16:04:34 +0100
Message-Id: <20211105150435.466838-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Clone the expression that defines the variable value if there are
multiple reference to it in the ruleset. This saves us heap consumption
specifically in case the variable defines a set with a huge number of
elements.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c                                | 11 ++++++++++-
 .../testcases/nft-f/0030variable_reuse_0      | 19 +++++++++++++++++++
 .../nft-f/dumps/0030variable_reuse_0.nft      | 11 +++++++++++
 3 files changed, 40 insertions(+), 1 deletion(-)
 create mode 100755 tests/shell/testcases/nft-f/0030variable_reuse_0
 create mode 100644 tests/shell/testcases/nft-f/dumps/0030variable_reuse_0.nft

diff --git a/src/evaluate.c b/src/evaluate.c
index a268b3cb9ee2..fd7818da1116 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2187,7 +2187,16 @@ static int expr_evaluate_osf(struct eval_ctx *ctx, struct expr **expr)
 
 static int expr_evaluate_variable(struct eval_ctx *ctx, struct expr **exprp)
 {
-	struct expr *new = expr_clone((*exprp)->sym->expr);
+	struct symbol *sym = (*exprp)->sym;
+	struct expr *new;
+
+	/* If variable is reused from different locations in the ruleset, then
+	 * clone expression.
+	 */
+	if (sym->refcnt > 2)
+		new = expr_clone(sym->expr);
+	else
+		new = expr_get(sym->expr);
 
 	if (expr_evaluate(ctx, &new) < 0) {
 		expr_free(new);
diff --git a/tests/shell/testcases/nft-f/0030variable_reuse_0 b/tests/shell/testcases/nft-f/0030variable_reuse_0
new file mode 100755
index 000000000000..8afc54aa0c10
--- /dev/null
+++ b/tests/shell/testcases/nft-f/0030variable_reuse_0
@@ -0,0 +1,19 @@
+#!/bin/bash
+
+set -e
+
+RULESET="define test = { 1.1.1.1 }
+
+table ip x {
+        set y {
+                type ipv4_addr
+                elements = { 2.2.2.2, \$test }
+        }
+
+        set z {
+                type ipv4_addr
+                elements = { 3.3.3.3, \$test }
+        }
+}"
+
+$NFT -f - <<< "$RULESET"
diff --git a/tests/shell/testcases/nft-f/dumps/0030variable_reuse_0.nft b/tests/shell/testcases/nft-f/dumps/0030variable_reuse_0.nft
new file mode 100644
index 000000000000..d895539bbfa5
--- /dev/null
+++ b/tests/shell/testcases/nft-f/dumps/0030variable_reuse_0.nft
@@ -0,0 +1,11 @@
+table ip x {
+        set y {
+                type ipv4_addr
+                elements = { 1.1.1.1, 2.2.2.2 }
+        }
+
+        set z {
+                type ipv4_addr
+                elements = { 1.1.1.1, 3.3.3.3 }
+        }
+}
-- 
2.30.2

