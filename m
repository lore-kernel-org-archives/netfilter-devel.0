Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CA43CCA47E
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Jun 2022 08:32:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239448AbiFTIc2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Jun 2022 04:32:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239515AbiFTIcZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Jun 2022 04:32:25 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8FC2E12A95
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Jun 2022 01:32:23 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 02/18] optimize: do not merge rules with set reference in rhs
Date:   Mon, 20 Jun 2022 10:31:59 +0200
Message-Id: <20220620083215.1021238-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220620083215.1021238-1-pablo@netfilter.org>
References: <20220620083215.1021238-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Otherwise set reference ends up included in an anonymous set, as an
element, which is not supported.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/optimize.c                                | 10 ++++++
 .../optimizations/dumps/skip_merge.nft        | 23 +++++++++++++
 .../shell/testcases/optimizations/skip_merge  | 34 +++++++++++++++++++
 3 files changed, 67 insertions(+)
 create mode 100644 tests/shell/testcases/optimizations/dumps/skip_merge.nft
 create mode 100755 tests/shell/testcases/optimizations/skip_merge

diff --git a/src/optimize.c b/src/optimize.c
index a2a4e587e125..543d3ca5a9c7 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -105,6 +105,12 @@ static bool stmt_expr_supported(const struct expr *expr)
 	return false;
 }
 
+static bool expr_symbol_set(const struct expr *expr)
+{
+	return expr->right->etype == EXPR_SYMBOL &&
+	       expr->right->symtype == SYMBOL_SET;
+}
+
 static bool __stmt_type_eq(const struct stmt *stmt_a, const struct stmt *stmt_b,
 			   bool fully_compare)
 {
@@ -122,6 +128,10 @@ static bool __stmt_type_eq(const struct stmt *stmt_a, const struct stmt *stmt_b,
 			if (!stmt_expr_supported(expr_a) ||
 			    !stmt_expr_supported(expr_b))
 				return false;
+
+			if (expr_symbol_set(expr_a) ||
+			    expr_symbol_set(expr_b))
+				return false;
 		}
 
 		return __expr_cmp(expr_a->left, expr_b->left);
diff --git a/tests/shell/testcases/optimizations/dumps/skip_merge.nft b/tests/shell/testcases/optimizations/dumps/skip_merge.nft
new file mode 100644
index 000000000000..9c10b74b4be2
--- /dev/null
+++ b/tests/shell/testcases/optimizations/dumps/skip_merge.nft
@@ -0,0 +1,23 @@
+table inet filter {
+	set udp_accepted {
+		type inet_service
+		elements = { 500, 4500 }
+	}
+
+	set tcp_accepted {
+		type inet_service
+		elements = { 80, 443 }
+	}
+
+	chain udp_input {
+		udp dport 1-128 accept
+		udp dport @udp_accepted accept
+		udp dport 53 accept
+	}
+
+	chain tcp_input {
+		tcp dport { 1-128, 8888-9999 } accept
+		tcp dport @tcp_accepted accept
+		tcp dport 1024-65535 accept
+	}
+}
diff --git a/tests/shell/testcases/optimizations/skip_merge b/tests/shell/testcases/optimizations/skip_merge
new file mode 100755
index 000000000000..8af976cac56d
--- /dev/null
+++ b/tests/shell/testcases/optimizations/skip_merge
@@ -0,0 +1,34 @@
+#!/bin/bash
+
+set -e
+
+RULESET="table inet filter {
+    set udp_accepted {
+        type inet_service;
+        elements = {
+            isakmp, ipsec-nat-t
+        }
+    }
+
+    set tcp_accepted {
+        type inet_service;
+        elements = {
+            http, https
+        }
+    }
+
+    chain udp_input {
+        udp dport 1-128 accept
+        udp dport @udp_accepted accept
+        udp dport domain accept
+    }
+
+    chain tcp_input {
+        tcp dport 1-128 accept
+        tcp dport 8888-9999 accept
+        tcp dport @tcp_accepted accept
+        tcp dport 1024-65535 accept
+    }
+}"
+
+$NFT -o -f - <<< $RULESET
-- 
2.30.2

