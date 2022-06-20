Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B171AC43334
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Jun 2022 08:32:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239442AbiFTIcd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Jun 2022 04:32:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239644AbiFTIc3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Jun 2022 04:32:29 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7C27012A9C
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Jun 2022 01:32:26 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 05/18] optimize: fix reject statement
Date:   Mon, 20 Jun 2022 10:32:02 +0200
Message-Id: <20220620083215.1021238-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220620083215.1021238-1-pablo@netfilter.org>
References: <20220620083215.1021238-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add missing code to the statement collection routine. Compare reject
expressions when available. Add tests/shell.

Fixes: fb298877ece2 ("src: add ruleset optimization infrastructure")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/optimize.c                                | 19 ++++++++++++++++---
 .../optimizations/dumps/merge_reject.nft      |  7 +++++++
 .../testcases/optimizations/merge_reject      | 15 +++++++++++++++
 3 files changed, 38 insertions(+), 3 deletions(-)
 create mode 100644 tests/shell/testcases/optimizations/dumps/merge_reject.nft
 create mode 100755 tests/shell/testcases/optimizations/merge_reject

diff --git a/src/optimize.c b/src/optimize.c
index 94242ee5f490..427625846484 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -178,13 +178,19 @@ static bool __stmt_type_eq(const struct stmt *stmt_a, const struct stmt *stmt_b,
 			return false;
 		break;
 	case STMT_REJECT:
-		if (stmt_a->reject.expr || stmt_b->reject.expr)
-			return false;
-
 		if (stmt_a->reject.family != stmt_b->reject.family ||
 		    stmt_a->reject.type != stmt_b->reject.type ||
 		    stmt_a->reject.icmp_code != stmt_b->reject.icmp_code)
 			return false;
+
+		if (!!stmt_a->reject.expr ^ !!stmt_b->reject.expr)
+			return false;
+
+		if (!stmt_a->reject.expr)
+			return true;
+
+		if (__expr_cmp(stmt_a->reject.expr, stmt_b->reject.expr))
+			return false;
 		break;
 	case STMT_NAT:
 		if (stmt_a->nat.type != stmt_b->nat.type ||
@@ -304,6 +310,13 @@ static int rule_collect_stmts(struct optimize_ctx *ctx, struct rule *rule)
 			clone->nat.flags = stmt->nat.flags;
 			clone->nat.type_flags = stmt->nat.type_flags;
 			break;
+		case STMT_REJECT:
+			if (stmt->reject.expr)
+				clone->reject.expr = expr_get(stmt->reject.expr);
+			clone->reject.type = stmt->reject.type;
+			clone->reject.icmp_code = stmt->reject.icmp_code;
+			clone->reject.family = stmt->reject.family;
+			break;
 		default:
 			xfree(clone);
 			continue;
diff --git a/tests/shell/testcases/optimizations/dumps/merge_reject.nft b/tests/shell/testcases/optimizations/dumps/merge_reject.nft
new file mode 100644
index 000000000000..9a13e2b96faa
--- /dev/null
+++ b/tests/shell/testcases/optimizations/dumps/merge_reject.nft
@@ -0,0 +1,7 @@
+table ip x {
+	chain y {
+		ip daddr 172.30.33.70 tcp dport 3306 counter packets 0 bytes 0 drop
+		meta l4proto . ip daddr . tcp dport { tcp . 172.30.238.117 . 8080, tcp . 172.30.33.71 . 3306, tcp . 172.30.254.251 . 3306 } counter packets 0 bytes 0 reject
+		ip daddr 172.30.254.252 tcp dport 3306 counter packets 0 bytes 0 reject with tcp reset
+	}
+}
diff --git a/tests/shell/testcases/optimizations/merge_reject b/tests/shell/testcases/optimizations/merge_reject
new file mode 100755
index 000000000000..497e8f64dc5d
--- /dev/null
+++ b/tests/shell/testcases/optimizations/merge_reject
@@ -0,0 +1,15 @@
+#!/bin/bash
+
+set -e
+
+RULESET="table ip x {
+	chain y {
+		meta l4proto tcp ip daddr 172.30.33.70 tcp dport 3306 counter packets 0 bytes 0 drop
+		meta l4proto tcp ip daddr 172.30.33.71 tcp dport 3306 counter packets 0 bytes 0 reject
+		meta l4proto tcp ip daddr 172.30.238.117 tcp dport 8080 counter packets 0 bytes 0 reject
+		meta l4proto tcp ip daddr 172.30.254.251 tcp dport 3306 counter packets 0 bytes 0 reject
+		meta l4proto tcp ip daddr 172.30.254.252 tcp dport 3306 counter packets 0 bytes 0 reject with tcp reset
+	}
+}"
+
+$NFT -o -f - <<< $RULESET
-- 
2.30.2

