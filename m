From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 4/4] netlink_delinarize: shift constant for ranges too
Date: Wed,  9 Mar 2016 00:09:48 +0100
Message-ID: <1457478588-12592-4-git-send-email-fw@strlen.de>
References: <1457478588-12592-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:39527 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750940AbcCHXQ5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Mar 2016 18:16:57 -0500
In-Reply-To: <1457478588-12592-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

... else rule like vlan pcp 1-3 won't work and will be displayed
as 0-0 (reverse direction already works since range is represented
as two lte/gte compare expressions).

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/netlink_linearize.c               | 2 ++
 tests/py/bridge/vlan.t.payload        | 4 ++--
 tests/py/bridge/vlan.t.payload.netdev | 4 ++--
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 49b4676..bb51de7 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -446,6 +446,7 @@ static void netlink_gen_range(struct netlink_linearize_ctx *ctx,
 		BUG("invalid range operation %u\n", expr->op);
 	}
 
+	payload_shift_value(expr->left, range->left);
 	netlink_gen_data(range->left, &nld);
 	nftnl_expr_set(nle, NFTNL_EXPR_CMP_DATA, nld.value, nld.len);
 	nftnl_rule_add_expr(ctx->nlr, nle);
@@ -466,6 +467,7 @@ static void netlink_gen_range(struct netlink_linearize_ctx *ctx,
 		BUG("invalid range operation %u\n", expr->op);
 	}
 
+	payload_shift_value(expr->left, range->right);
 	netlink_gen_data(range->right, &nld);
 	nftnl_expr_set(nle, NFTNL_EXPR_CMP_DATA, nld.value, nld.len);
 	nftnl_rule_add_expr(ctx->nlr, nle);
diff --git a/tests/py/bridge/vlan.t.payload b/tests/py/bridge/vlan.t.payload
index 02242d2..78ee7ef 100644
--- a/tests/py/bridge/vlan.t.payload
+++ b/tests/py/bridge/vlan.t.payload
@@ -196,6 +196,6 @@ bridge test-bridge input
   [ lookup reg 1 set set%d ]
   [ payload load 1b @ link header + 14 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x000000e0 ) ^ 0x00000000 ]
-  [ cmp gte reg 1 0x00000001 ]
-  [ cmp lte reg 1 0x00000003 ]
+  [ cmp gte reg 1 0x00000020 ]
+  [ cmp lte reg 1 0x00000060 ]
 
diff --git a/tests/py/bridge/vlan.t.payload.netdev b/tests/py/bridge/vlan.t.payload.netdev
index 62c7adf..f60587f 100644
--- a/tests/py/bridge/vlan.t.payload.netdev
+++ b/tests/py/bridge/vlan.t.payload.netdev
@@ -230,6 +230,6 @@ netdev test-netdev ingress
   [ lookup reg 1 set set%d ]
   [ payload load 1b @ link header + 14 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x000000e0 ) ^ 0x00000000 ]
-  [ cmp gte reg 1 0x00000001 ]
-  [ cmp lte reg 1 0x00000003 ]
+  [ cmp gte reg 1 0x00000020 ]
+  [ cmp lte reg 1 0x00000060 ]
 
-- 
2.4.10

