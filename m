From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 12/13] vlan: make != tests work
Date: Sun, 16 Aug 2015 21:05:55 +0200
Message-ID: <1439751955-31190-13-git-send-email-fw@strlen.de>
References: <1439751955-31190-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:34753 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751788AbbHPTGR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Aug 2015 15:06:17 -0400
In-Reply-To: <1439751955-31190-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 src/netlink_delinearize.c              |  1 +
 tests/regression/bridge/vlan.t         |  1 +
 tests/regression/bridge/vlan.t.payload | 11 +++++++++++
 3 files changed, 13 insertions(+)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 537e34c..2e3b090 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1084,6 +1084,7 @@ static void relational_binop_postprocess(struct rule_pp_ctx *ctx, struct expr *e
 	struct expr *binop = expr->left, *value = expr->right;
 
 	if (binop->op == OP_AND && expr->op == OP_NEQ &&
+	    value->dtype->basetype &&
 	    value->dtype->basetype->type == TYPE_BITMASK &&
 	    !mpz_cmp_ui(value->value, 0)) {
 		/* Flag comparison: data & flags != 0
diff --git a/tests/regression/bridge/vlan.t b/tests/regression/bridge/vlan.t
index e80ea50..f86561a 100644
--- a/tests/regression/bridge/vlan.t
+++ b/tests/regression/bridge/vlan.t
@@ -6,6 +6,7 @@ vlan id 0;ok
 # bad vlan id
 vlan id 4096;fail
 vlan id 4094 vlan cfi 0;ok
+vlan id 4094 vlan cfi != 1;ok
 vlan id 4094 vlan cfi 1;ok
 # bad cfi
 vlan id 4094 vlan cfi 2;fail
diff --git a/tests/regression/bridge/vlan.t.payload b/tests/regression/bridge/vlan.t.payload
index 4a5714a..35dc437 100644
--- a/tests/regression/bridge/vlan.t.payload
+++ b/tests/regression/bridge/vlan.t.payload
@@ -25,6 +25,17 @@ bridge test-bridge input
   [ bitwise reg 1 = (reg=1 & 0x00000010 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000000 ]
 
+# vlan id 4094 vlan cfi != 1
+bridge test-bridge input
+  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x00000081 ]
+  [ payload load 2b @ link header + 14 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0000fe0f ]
+  [ payload load 1b @ link header + 15 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00000010 ) ^ 0x00000000 ]
+  [ cmp neq reg 1 0x00000010 ]
+
 # vlan id 4094 vlan cfi 1
 bridge test-bridge input
   [ payload load 2b @ link header + 12 => reg 1 ]
-- 
2.0.5

