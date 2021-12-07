Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81C1CC433EF
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Dec 2021 15:17:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234807AbhLGPUx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Dec 2021 10:20:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230473AbhLGPUx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Dec 2021 10:20:53 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0427C061574
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Dec 2021 07:17:22 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mucDZ-0001lU-DA; Tue, 07 Dec 2021 16:17:21 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 4/4] netlink_delinearize: zero shift removal
Date:   Tue,  7 Dec 2021 16:16:59 +0100
Message-Id: <20211207151659.5507-5-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211207151659.5507-1-fw@strlen.de>
References: <20211207151659.5507-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Remove shifts-by-0.  These can occur after binop postprocessing
has adjusted the RHS value to account for a mask operation.

Example: frag frag-off @s4

Is internally represented via:

  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
  [ bitwise reg 1 = ( reg 1 >> 0x00000003 ) ]
  [ lookup reg 1 set s ]

First binop masks out unwanted parts of the 16-bit field.
Second binop needs to left-shift so that lookups in the set will work.

When decoding, the first binop is removed after the exthdr load
has been adjusted accordingly.  Constant propagation adjusts the
shift-value to 0 on removal.  This change then gets rid of the
shift-by-0 entirely.

After this change, 'frag frag-off @s4' input is shown as-is.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/netlink_delinearize.c                     | 21 +++++++++++++++++++
 .../testcases/sets/dumps/typeof_sets_0.nft    |  8 +++++++
 tests/shell/testcases/sets/typeof_sets_0      |  8 +++++++
 3 files changed, 37 insertions(+)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index e37a34f37ba2..6a003cf7051b 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2322,6 +2322,20 @@ static void map_binop_postprocess(struct rule_pp_ctx *ctx, struct expr *expr)
 		binop_postprocess(ctx, expr, &expr->map);
 }
 
+static bool is_shift_by_zero(const struct expr *binop)
+{
+	struct expr *rhs;
+
+	if (binop->op != OP_RSHIFT && binop->op != OP_LSHIFT)
+		return false;
+
+	rhs = binop->right;
+	if (rhs->etype != EXPR_VALUE || rhs->len > 64)
+		return false;
+
+	return mpz_get_uint64(binop->right->value) == 0;
+}
+
 static void relational_binop_postprocess(struct rule_pp_ctx *ctx,
 					 struct expr **exprp)
 {
@@ -2421,6 +2435,13 @@ static void relational_binop_postprocess(struct rule_pp_ctx *ctx,
 		 */
 
 		binop_postprocess(ctx, binop, &binop->left);
+		if (is_shift_by_zero(binop)) {
+			struct expr *lhs = binop->left;
+
+			expr_get(lhs);
+			expr_free(binop);
+			expr->left = lhs;
+		}
 	}
 }
 
diff --git a/tests/shell/testcases/sets/dumps/typeof_sets_0.nft b/tests/shell/testcases/sets/dumps/typeof_sets_0.nft
index ad442713f6dc..e397a6345462 100644
--- a/tests/shell/testcases/sets/dumps/typeof_sets_0.nft
+++ b/tests/shell/testcases/sets/dumps/typeof_sets_0.nft
@@ -53,6 +53,10 @@ table inet t {
 		vlan id @s2 accept
 	}
 
+	chain c4 {
+		frag frag-off @s4 accept
+	}
+
 	chain c5 {
 		ip option ra value @s5 accept
 	}
@@ -65,6 +69,10 @@ table inet t {
 		sctp chunk init num-inbound-streams @s7 accept
 	}
 
+	chain c8 {
+		ip version @s8 accept
+	}
+
 	chain c9 {
 		ip hdrlength @s9 accept
 	}
diff --git a/tests/shell/testcases/sets/typeof_sets_0 b/tests/shell/testcases/sets/typeof_sets_0
index 2102789e1043..be906cdcc842 100755
--- a/tests/shell/testcases/sets/typeof_sets_0
+++ b/tests/shell/testcases/sets/typeof_sets_0
@@ -58,6 +58,10 @@ EXPECTED="table inet t {
 		ether type vlan vlan id @s2 accept
 	}
 
+	chain c4 {
+		frag frag-off @s4 accept
+	}
+
 	chain c5 {
 		ip option ra value @s5 accept
 	}
@@ -70,6 +74,10 @@ EXPECTED="table inet t {
 		sctp chunk init num-inbound-streams @s7 accept
 	}
 
+	chain c8 {
+		ip version @s8 accept
+	}
+
 	chain c9 {
 		ip hdrlength @s9 accept
 	}
-- 
2.32.0

