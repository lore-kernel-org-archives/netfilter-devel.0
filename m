Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADAFB22ACF3
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Feb 2025 10:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740653266; cv=none; b=TaS65xvxwMJJt62h3BCCPWfAKRuKffkYC+ZlAMrZB+vX1JlJLTJYbKkyGQRgo1ql23ucWr/XbjaQKN3+oUE02RRMafc3DEmOjLYB2Jncl73PelRLVtrKn/BJBd2qyW6M0xztKGPTQOQo81yvoVf+tiGL1P7/MCRfRBk8cu0Pesg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740653266; c=relaxed/simple;
	bh=Kr4ptLEQ/y58tsTSHTeT3fReazKd3qjZe2EknapJE74=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Dc9erqKE7bGsrTxvaiuzQYWKGYUw/K2oEh3uA1SyDT+rylWp2/6tkiWqU2twTfUYye41mYbdC6IKQ5znz4uWCyUWlpaiEJfD73DNOit2tsjM8Zuw+r8e1DntqCdJs/HPTkgSI8jw1+FyKZsOqXpO+0u97XVy6Ihvj8GvggO/Y/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1tnbQV-00009n-Tw; Thu, 27 Feb 2025 11:47:35 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>,
	Xiao Liang <shaw.leon@gmail.com>
Subject: [PATCH nft] payload: don't kill dependency for proto_th
Date: Thu, 27 Feb 2025 11:47:02 +0100
Message-ID: <20250227104705.9283-1-fw@strlen.de>
X-Mailer: git-send-email 2.45.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

proto_th carries no information about the proto number, we need to
preserve the L4 protocol expression unless we can be sure that

For example, if "meta l4proto 91 @th,0,16 0" is simplified to
"th sport 0", the information of protocol number is lost.

Based on initial patch from Xiao Liang.

Signed-off-by: Xiao Liang <shaw.leon@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/netlink_delinearize.c         |  1 +
 src/payload.c                     | 16 ++++++++++++++--
 tests/py/any/rawpayload.t         |  1 +
 tests/py/any/rawpayload.t.json    | 31 +++++++++++++++++++++++++++++++
 tests/py/any/rawpayload.t.payload |  8 ++++++++
 5 files changed, 55 insertions(+), 2 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 86c8602860f6..b629916ebff8 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2102,6 +2102,7 @@ static void payload_match_expand(struct rule_pp_ctx *ctx,
 		 */
 		payload_dependency_kill(&dl->pdctx, nexpr->left,
 					dl->pctx.family);
+		expr_set_type(tmp, nexpr->left->dtype, nexpr->byteorder);
 		if (expr->op == OP_EQ && left->flags & EXPR_F_PROTOCOL)
 			payload_dependency_store(&dl->pdctx, nstmt, base);
 	}
diff --git a/src/payload.c b/src/payload.c
index ee6b39a34cb4..018719751103 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -812,7 +812,7 @@ static bool icmp_dep_type_match(enum icmp_hdr_field_type t, uint8_t type)
 	BUG("Missing icmp type mapping");
 }
 
-static bool payload_may_dependency_kill_icmp(struct payload_dep_ctx *ctx, struct expr *expr)
+static bool payload_may_dependency_kill_icmp(struct payload_dep_ctx *ctx, const struct expr *expr)
 {
 	const struct expr *dep = payload_dependency_get(ctx, expr->payload.base);
 	enum icmp_hdr_field_type icmp_dep;
@@ -832,7 +832,7 @@ static bool payload_may_dependency_kill_icmp(struct payload_dep_ctx *ctx, struct
 	return ctx->icmp_type == icmp_dep_to_type(icmp_dep);
 }
 
-static bool payload_may_dependency_kill_ll(struct payload_dep_ctx *ctx, struct expr *expr)
+static bool payload_may_dependency_kill_ll(struct payload_dep_ctx *ctx, const struct expr *expr)
 {
 	const struct expr *dep = payload_dependency_get(ctx, expr->payload.base);
 
@@ -894,6 +894,18 @@ static bool payload_may_dependency_kill(struct payload_dep_ctx *ctx,
 	if (expr->payload.base != PROTO_BASE_TRANSPORT_HDR)
 		return true;
 
+	if (expr->payload.desc == &proto_th) {
+		/* &proto_th could mean any of udp, tcp, dccp, ... so we
+		 * cannot remove the dependency.
+		 *
+		 * Also prefer raw payload @th syntax, there is no
+		 * 'source/destination port' protocol here.
+		 */
+		expr->payload.desc = &proto_unknown;
+		expr->dtype = &xinteger_type;
+		return false;
+	}
+
 	if (dep->left->etype != EXPR_PAYLOAD ||
 	    dep->left->payload.base != PROTO_BASE_TRANSPORT_HDR)
 		return true;
diff --git a/tests/py/any/rawpayload.t b/tests/py/any/rawpayload.t
index 745b4a615e6c..118f58fd0f75 100644
--- a/tests/py/any/rawpayload.t
+++ b/tests/py/any/rawpayload.t
@@ -21,6 +21,7 @@ meta l4proto tcp @th,16,16 { 22, 23, 80};ok;tcp dport { 22, 23, 80}
 @ll,0,128 0xfedcba987654321001234567890abcde;ok
 
 meta l4proto 91 @th,400,16 0x0 accept;ok
+meta l4proto 91 @th,0,16 0x0 accept;ok
 
 @ih,32,32 0x14000000;ok
 @ih,58,6 set 0 @ih,86,6 set 0 @ih,170,22 set 0;ok;@ih,58,6 set 0x0 @ih,86,6 set 0x0 @ih,170,22 set 0x0
diff --git a/tests/py/any/rawpayload.t.json b/tests/py/any/rawpayload.t.json
index 4a06c5987a7b..04ed0acf1ed0 100644
--- a/tests/py/any/rawpayload.t.json
+++ b/tests/py/any/rawpayload.t.json
@@ -187,6 +187,37 @@
     }
 ]
 
+# meta l4proto 91 @th,0,16 0x0 accept
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "l4proto"
+                }
+            },
+            "op": "==",
+            "right": 91
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "base": "th",
+                    "len": 16,
+                    "offset": 0
+                }
+            },
+            "op": "==",
+            "right": 0
+        }
+    },
+    {
+        "accept": null
+    }
+]
+
 # @ih,32,32 0x14000000
 [
     {
diff --git a/tests/py/any/rawpayload.t.payload b/tests/py/any/rawpayload.t.payload
index 8984eef6a481..c093d5d8932f 100644
--- a/tests/py/any/rawpayload.t.payload
+++ b/tests/py/any/rawpayload.t.payload
@@ -56,6 +56,14 @@ inet test-inet input
   [ cmp eq reg 1 0x00000000 ]
   [ immediate reg 0 accept ]
 
+# meta l4proto 91 @th,0,16 0x0 accept
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x0000005b ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000000 ]
+  [ immediate reg 0 accept ]
+
 # @ih,32,32 0x14000000
 inet test-inet input
   [ payload load 4b @ inner header + 4 => reg 1 ]
-- 
2.45.3

