Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EA66C77B7A
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 May 2023 13:24:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbjEXNYK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 May 2023 09:24:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232887AbjEXNXt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 May 2023 09:23:49 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 208E1B6
        for <netfilter-devel@vger.kernel.org>; Wed, 24 May 2023 06:23:47 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1q1oSu-0004Jj-Qj; Wed, 24 May 2023 15:23:44 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] src: permit use of constant values in set lookup keys
Date:   Wed, 24 May 2023 15:23:38 +0200
Message-Id: <20230524132338.28046-1-fw@strlen.de>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <ZG3Bqcz3Dru4xOBS@calendula>
References: <ZG3Bqcz3Dru4xOBS@calendula>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Given:

set s { type ipv4_addr . ipv4_addr . inet_service .. } rule like

   add rule ip saddr . 1.2.3.4 . 80 @s goto c1

fails with: "Error: Can't parse symbolic invalid expressions".

This fails because the relational expression first evaluates
the left hand side, so when concat evaluation sees '1.2.3.4'
no key context is available.

Check if the RHS is a set reference, and, if so, evaluate
the right hand side.

This sets a pointer to the set key in the evaluation context
structure which then makes the concat evaluation step parse
1.2.3.4 and 80 as ipv4 address and 16bit port number.

On delinearization, extend relop postprocessing to
copy the datatype from the rhs (set reference, has
proper datatype according to set->key) to the lhs (concat
expression).

Note that even with this change following isn't supported:
set s { type inet_service ...
add rule 80 @s

Because of '!expr_is_constant()' check. I decided to leave
that in place for now because I don't see the use-case for
a fixed-value lookup from the packet path.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c                                   |  6 ++++++
 src/netlink_delinearize.c                        |  9 +++++++++
 .../testcases/sets/dumps/type_set_symbol.nft     | 16 ++++++++++++++++
 tests/shell/testcases/sets/type_set_symbol       |  6 ++++++
 4 files changed, 37 insertions(+)
 create mode 100644 tests/shell/testcases/sets/dumps/type_set_symbol.nft
 create mode 100755 tests/shell/testcases/sets/type_set_symbol

diff --git a/src/evaluate.c b/src/evaluate.c
index 17a437bd6530..50f1496c7821 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2336,6 +2336,12 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
 	struct expr *range;
 	int ret;
 
+	right = rel->right;
+	if (right->etype == EXPR_SYMBOL &&
+	    right->symtype == SYMBOL_SET &&
+	    expr_evaluate(ctx, &rel->right) < 0)
+		return -1;
+
 	if (expr_evaluate(ctx, &rel->left) < 0)
 		return -1;
 	left = rel->left;
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 935a6667a1c7..9241f46622ff 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2839,6 +2839,15 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 		case EXPR_PAYLOAD:
 			payload_match_postprocess(ctx, expr, expr->left);
 			return;
+		case EXPR_CONCAT:
+			if (expr->right->etype == EXPR_SET_REF) {
+				assert(expr->left->dtype == &invalid_type);
+				assert(expr->right->dtype != &invalid_type);
+
+				datatype_set(expr->left, expr->right->dtype);
+			}
+			expr_postprocess(ctx, &expr->left);
+			break;
 		default:
 			expr_postprocess(ctx, &expr->left);
 			break;
diff --git a/tests/shell/testcases/sets/dumps/type_set_symbol.nft b/tests/shell/testcases/sets/dumps/type_set_symbol.nft
new file mode 100644
index 000000000000..21209f6d8b19
--- /dev/null
+++ b/tests/shell/testcases/sets/dumps/type_set_symbol.nft
@@ -0,0 +1,16 @@
+table ip t {
+	set s1 {
+		type ipv4_addr . ipv4_addr . inet_service
+		size 65535
+		flags dynamic,timeout
+		timeout 3h
+	}
+
+	chain c1 {
+		update @s1 { ip saddr . 10.180.0.4 . 80 }
+	}
+
+	chain c2 {
+		ip saddr . 1.2.3.4 . 80 @s1 goto c1
+	}
+}
diff --git a/tests/shell/testcases/sets/type_set_symbol b/tests/shell/testcases/sets/type_set_symbol
new file mode 100755
index 000000000000..07820b7c4fdd
--- /dev/null
+++ b/tests/shell/testcases/sets/type_set_symbol
@@ -0,0 +1,6 @@
+#!/bin/bash
+
+set -e
+dumpfile=$(dirname $0)/dumps/$(basename $0).nft
+
+$NFT -f "$dumpfile"
-- 
2.39.3

