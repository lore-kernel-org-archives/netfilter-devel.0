Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0841BC433DB
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Jan 2021 10:02:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D26EB20771
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Jan 2021 10:02:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S316811AbhAZXKk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Jan 2021 18:10:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392281AbhAZR67 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Jan 2021 12:58:59 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C555DC061786
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Jan 2021 09:55:55 -0800 (PST)
Received: from localhost ([::1]:44172 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1l4SZG-0004pi-BJ; Tue, 26 Jan 2021 18:55:54 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org,
        "Jose M . Guisado Gomez" <guigom@riseup.net>
Subject: [nft PATCH 1/2] reject: Fix for missing dependencies in netdev family
Date:   Tue, 26 Jan 2021 18:55:39 +0100
Message-Id: <20210126175540.9557-1-phil@nwl.cc>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Like with bridge family, rejecting with either icmp or icmpv6 must
create a dependency match on meta protocol. Upon delinearization, treat
netdev reject identical to bridge as well so no family info is lost.

This makes reject statement in netdev family fully symmetric so fix
the tests in tests/py/netdev/reject.t, adjust the related payload dumps
and add JSON equivalents which were missing altogether.

Fixes: 0c42a1f2a0cc5 ("evaluate: add netdev support for reject default")
Fixes: a51a0bec1f698 ("tests: py: add netdev folder and reject.t icmp cases")
Cc: Jose M. Guisado Gomez <guigom@riseup.net>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/evaluate.c                   |   3 +-
 src/netlink_delinearize.c        |   1 +
 tests/py/netdev/reject.t         |  26 +++---
 tests/py/netdev/reject.t.json    | 137 +++++++++++++++++++++++++++++++
 tests/py/netdev/reject.t.payload |  42 ++++++++--
 5 files changed, 187 insertions(+), 22 deletions(-)
 create mode 100644 tests/py/netdev/reject.t.json

diff --git a/src/evaluate.c b/src/evaluate.c
index 53f636b7ebe79..c06de4d9b8d03 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2720,7 +2720,7 @@ static int stmt_evaluate_reject_bridge(struct eval_ctx *ctx, struct stmt *stmt,
 	const struct proto_desc *desc;
 
 	desc = ctx->pctx.protocol[PROTO_BASE_LL_HDR].desc;
-	if (desc != &proto_eth && desc != &proto_vlan)
+	if (desc != &proto_eth && desc != &proto_vlan && desc != &proto_netdev)
 		return stmt_binary_error(ctx,
 					 &ctx->pctx.protocol[PROTO_BASE_LL_HDR],
 					 stmt, "unsupported link layer protocol");
@@ -2760,6 +2760,7 @@ static int stmt_evaluate_reject_family(struct eval_ctx *ctx, struct stmt *stmt,
 		}
 		break;
 	case NFPROTO_BRIDGE:
+	case NFPROTO_NETDEV:
 		if (stmt_evaluate_reject_bridge(ctx, stmt, expr) < 0)
 			return -1;
 		break;
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 7315072284119..ca4d723dea0ec 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2491,6 +2491,7 @@ static void stmt_reject_postprocess(struct rule_pp_ctx *rctx)
 		stmt->reject.family = protocol;
 		break;
 	case NFPROTO_BRIDGE:
+	case NFPROTO_NETDEV:
 		if (stmt->reject.type == NFT_REJECT_ICMPX_UNREACH) {
 			datatype_set(stmt->reject.expr, &icmpx_code_type);
 			break;
diff --git a/tests/py/netdev/reject.t b/tests/py/netdev/reject.t
index a4434b6c126b6..8f8c4e0375977 100644
--- a/tests/py/netdev/reject.t
+++ b/tests/py/netdev/reject.t
@@ -2,19 +2,19 @@
 
 *netdev;test-netdev;ingress
 
-reject with icmp type host-unreachable;ok;reject
-reject with icmp type net-unreachable;ok;reject
-reject with icmp type prot-unreachable;ok;reject
-reject with icmp type port-unreachable;ok;reject
-reject with icmp type net-prohibited;ok;reject
-reject with icmp type host-prohibited;ok;reject
-reject with icmp type admin-prohibited;ok;reject
+reject with icmp type host-unreachable;ok
+reject with icmp type net-unreachable;ok
+reject with icmp type prot-unreachable;ok
+reject with icmp type port-unreachable;ok
+reject with icmp type net-prohibited;ok
+reject with icmp type host-prohibited;ok
+reject with icmp type admin-prohibited;ok
 
-reject with icmpv6 type no-route;ok;reject
-reject with icmpv6 type admin-prohibited;ok;reject
-reject with icmpv6 type addr-unreachable;ok;reject
-reject with icmpv6 type port-unreachable;ok;reject
-reject with icmpv6 type policy-fail;ok;reject
-reject with icmpv6 type reject-route;ok;reject
+reject with icmpv6 type no-route;ok
+reject with icmpv6 type admin-prohibited;ok
+reject with icmpv6 type addr-unreachable;ok
+reject with icmpv6 type port-unreachable;ok
+reject with icmpv6 type policy-fail;ok
+reject with icmpv6 type reject-route;ok
 
 reject;ok
diff --git a/tests/py/netdev/reject.t.json b/tests/py/netdev/reject.t.json
new file mode 100644
index 0000000000000..ffc72794ac611
--- /dev/null
+++ b/tests/py/netdev/reject.t.json
@@ -0,0 +1,137 @@
+# reject with icmp type host-unreachable
+[
+    {
+        "reject": {
+            "expr": "host-unreachable",
+            "type": "icmp"
+        }
+    }
+]
+
+# reject with icmp type net-unreachable
+[
+    {
+        "reject": {
+            "expr": "net-unreachable",
+            "type": "icmp"
+        }
+    }
+]
+
+# reject with icmp type prot-unreachable
+[
+    {
+        "reject": {
+            "expr": "prot-unreachable",
+            "type": "icmp"
+        }
+    }
+]
+
+# reject with icmp type port-unreachable
+[
+    {
+        "reject": {
+            "expr": "port-unreachable",
+            "type": "icmp"
+        }
+    }
+]
+
+# reject with icmp type net-prohibited
+[
+    {
+        "reject": {
+            "expr": "net-prohibited",
+            "type": "icmp"
+        }
+    }
+]
+
+# reject with icmp type host-prohibited
+[
+    {
+        "reject": {
+            "expr": "host-prohibited",
+            "type": "icmp"
+        }
+    }
+]
+
+# reject with icmp type admin-prohibited
+[
+    {
+        "reject": {
+            "expr": "admin-prohibited",
+            "type": "icmp"
+        }
+    }
+]
+
+# reject with icmpv6 type no-route
+[
+    {
+        "reject": {
+            "expr": "no-route",
+            "type": "icmpv6"
+        }
+    }
+]
+
+# reject with icmpv6 type admin-prohibited
+[
+    {
+        "reject": {
+            "expr": "admin-prohibited",
+            "type": "icmpv6"
+        }
+    }
+]
+
+# reject with icmpv6 type addr-unreachable
+[
+    {
+        "reject": {
+            "expr": "addr-unreachable",
+            "type": "icmpv6"
+        }
+    }
+]
+
+# reject with icmpv6 type port-unreachable
+[
+    {
+        "reject": {
+            "expr": "port-unreachable",
+            "type": "icmpv6"
+        }
+    }
+]
+
+# reject with icmpv6 type policy-fail
+[
+    {
+        "reject": {
+            "expr": "policy-fail",
+            "type": "icmpv6"
+        }
+    }
+]
+
+# reject with icmpv6 type reject-route
+[
+    {
+        "reject": {
+            "expr": "reject-route",
+            "type": "icmpv6"
+        }
+    }
+]
+
+# reject
+[
+    {
+        "reject": null
+    }
+]
+
diff --git a/tests/py/netdev/reject.t.payload b/tests/py/netdev/reject.t.payload
index d3af2f33b43a7..aead412772c0d 100644
--- a/tests/py/netdev/reject.t.payload
+++ b/tests/py/netdev/reject.t.payload
@@ -1,56 +1,82 @@
 # reject with icmp type host-unreachable
 netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
   [ reject type 0 code 1 ]
 
-# reject
-netdev 
-  [ reject type 2 code 1 ]
-
-# reject with icmp type admin-prohibited
-netdev 
-  [ reject type 0 code 13 ]
-
 # reject with icmp type net-unreachable
 netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
   [ reject type 0 code 0 ]
 
 # reject with icmp type prot-unreachable
 netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
   [ reject type 0 code 2 ]
 
 # reject with icmp type port-unreachable
 netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
   [ reject type 0 code 3 ]
 
 # reject with icmp type net-prohibited
 netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
   [ reject type 0 code 9 ]
 
 # reject with icmp type host-prohibited
 netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
   [ reject type 0 code 10 ]
 
+# reject with icmp type admin-prohibited
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ reject type 0 code 13 ]
+
 # reject with icmpv6 type no-route
 netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
   [ reject type 0 code 0 ]
 
 # reject with icmpv6 type admin-prohibited
 netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
   [ reject type 0 code 1 ]
 
 # reject with icmpv6 type addr-unreachable
 netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
   [ reject type 0 code 3 ]
 
 # reject with icmpv6 type port-unreachable
 netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
   [ reject type 0 code 4 ]
 
 # reject with icmpv6 type policy-fail
 netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
   [ reject type 0 code 5 ]
 
 # reject with icmpv6 type reject-route
 netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
   [ reject type 0 code 6 ]
 
+# reject
+netdev 
+  [ reject type 2 code 1 ]
+
-- 
2.28.0

