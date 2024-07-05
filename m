Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31A7E14A62E
	for <netfilter-devel@vger.kernel.org>; Fri,  5 Jul 2024 14:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720188756; cv=none; b=eLbCeRQojARreN6NreI1ip/tbWLbQkfkHblt5nqu9AolxiMJPAwaYJ4/rM0j+xLMDYkOvKQ0196Y1tDVTfOb3l5U905ttXTbK3P1N+61iRfG7GH/gVUG0s7Nenvia4EOdgM5FYwI2VSXD13prN8s+i7754EzV9jawTBx4zyZpUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720188756; c=relaxed/simple;
	bh=w3+WZ4iELVv4caLUiX5dfAk/pe2eyobUZ0fwVETX4D4=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=quIN4xnjlXcxaz2bPQ5a54lPdYQWgK8ZJwCL6Er1+JwfW9cgax56j9JDcC/92I9lTgi8AR1toFbqfXzYdwKG7qAW4bzgUGsvKRQPDF1s+BXkfZeqQC+IHCIzejm0EVrXeM993urXlH2A5rKRJ5ztEENYQSLjjqdwHQL1RffX3MU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] optimize: clone counter before insertion into set element
Date: Fri,  5 Jul 2024 16:12:20 +0200
Message-Id: <20240705141220.316215-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The counter statement that is zapped from the rule needs to be cloned
before inserting it into each set element.

Fixes: 686ab8b6996e ("optimize: do not remove counter in verdict maps")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/optimize.c                                | 24 +++++++++++++------
 .../optimizations/dumps/merge_counter.nft     |  8 +++++++
 .../testcases/optimizations/merge_counter     | 20 ++++++++++++++++
 3 files changed, 45 insertions(+), 7 deletions(-)
 create mode 100644 tests/shell/testcases/optimizations/dumps/merge_counter.nft
 create mode 100755 tests/shell/testcases/optimizations/merge_counter

diff --git a/src/optimize.c b/src/optimize.c
index 1dd08586f326..62dd9082a587 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -692,29 +692,36 @@ static void build_verdict_map(struct expr *expr, struct stmt *verdict,
 			      struct expr *set, struct stmt *counter)
 {
 	struct expr *item, *elem, *mapping;
+	struct stmt *counter_elem;
 
 	switch (expr->etype) {
 	case EXPR_LIST:
 		list_for_each_entry(item, &expr->expressions, list) {
 			elem = set_elem_expr_alloc(&internal_location, expr_get(item));
-			if (counter)
-				list_add_tail(&counter->list, &elem->stmt_list);
+			if (counter) {
+				counter_elem = counter_stmt_alloc(&counter->location);
+				list_add_tail(&counter_elem->list, &elem->stmt_list);
+			}
 
 			mapping = mapping_expr_alloc(&internal_location, elem,
 						     expr_get(verdict->expr));
 			compound_expr_add(set, mapping);
 		}
+		stmt_free(counter);
 		break;
 	case EXPR_SET:
 		list_for_each_entry(item, &expr->expressions, list) {
 			elem = set_elem_expr_alloc(&internal_location, expr_get(item->key));
-			if (counter)
-				list_add_tail(&counter->list, &elem->stmt_list);
+			if (counter) {
+				counter_elem = counter_stmt_alloc(&counter->location);
+				list_add_tail(&counter_elem->list, &elem->stmt_list);
+			}
 
 			mapping = mapping_expr_alloc(&internal_location, elem,
 						     expr_get(verdict->expr));
 			compound_expr_add(set, mapping);
 		}
+		stmt_free(counter);
 		break;
 	case EXPR_PREFIX:
 	case EXPR_RANGE:
@@ -819,8 +826,8 @@ static void __merge_concat_stmts_vmap(const struct optimize_ctx *ctx,
 				      struct expr *set, struct stmt *verdict)
 {
 	struct expr *concat, *next, *elem, *mapping;
+	struct stmt *counter, *counter_elem;
 	LIST_HEAD(concat_list);
-	struct stmt *counter;
 
 	counter = zap_counter(ctx, i);
 	__merge_concat(ctx, i, merge, &concat_list);
@@ -828,13 +835,16 @@ static void __merge_concat_stmts_vmap(const struct optimize_ctx *ctx,
 	list_for_each_entry_safe(concat, next, &concat_list, list) {
 		list_del(&concat->list);
 		elem = set_elem_expr_alloc(&internal_location, concat);
-		if (counter)
-			list_add_tail(&counter->list, &elem->stmt_list);
+		if (counter) {
+			counter_elem = counter_stmt_alloc(&counter->location);
+			list_add_tail(&counter_elem->list, &elem->stmt_list);
+		}
 
 		mapping = mapping_expr_alloc(&internal_location, elem,
 					     expr_get(verdict->expr));
 		compound_expr_add(set, mapping);
 	}
+	stmt_free(counter);
 }
 
 static void merge_concat_stmts_vmap(const struct optimize_ctx *ctx,
diff --git a/tests/shell/testcases/optimizations/dumps/merge_counter.nft b/tests/shell/testcases/optimizations/dumps/merge_counter.nft
new file mode 100644
index 000000000000..72eed5d0f148
--- /dev/null
+++ b/tests/shell/testcases/optimizations/dumps/merge_counter.nft
@@ -0,0 +1,8 @@
+table ip x {
+	chain y {
+		type filter hook input priority filter; policy drop;
+		ct state vmap { invalid counter packets 0 bytes 0 : drop, established counter packets 0 bytes 0 : accept, related counter packets 0 bytes 0 : accept }
+		tcp dport { 80, 123 } counter packets 0 bytes 0 accept
+		ip saddr . ip daddr vmap { 1.1.1.1 . 2.2.2.2 counter packets 0 bytes 0 : accept, 1.1.1.2 . 3.3.3.3 counter packets 0 bytes 0 : drop }
+	}
+}
diff --git a/tests/shell/testcases/optimizations/merge_counter b/tests/shell/testcases/optimizations/merge_counter
new file mode 100755
index 000000000000..3b8bbadd6126
--- /dev/null
+++ b/tests/shell/testcases/optimizations/merge_counter
@@ -0,0 +1,20 @@
+#!/bin/bash
+
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_set_expr)
+
+set -e
+
+RULESET="table ip x {
+        chain y {
+                type filter hook input priority 0; policy drop;
+
+                ct state invalid counter drop
+                ct state established,related counter accept
+                tcp dport 80 counter accept
+                tcp dport 123 counter accept
+                ip saddr 1.1.1.1 ip daddr 2.2.2.2 counter accept
+                ip saddr 1.1.1.2 ip daddr 3.3.3.3 counter drop
+        }
+}"
+
+$NFT -o -f - <<< $RULESET
-- 
2.30.2

