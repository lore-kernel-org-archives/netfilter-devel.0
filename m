Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C19EC433F5
	for <netfilter-devel@archiver.kernel.org>; Sat, 11 Dec 2021 18:55:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbhLKSzd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 11 Dec 2021 13:55:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231775AbhLKSzc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 11 Dec 2021 13:55:32 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71CE2C0617A2
        for <netfilter-devel@vger.kernel.org>; Sat, 11 Dec 2021 10:55:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=2KYrXVEXfsbvdAD+Xd4LY7JygZw5L461z02wTn34ims=; b=nwZsC8FJDqdr3EhhGePxbjXPqa
        UM6jcTdCCUiyUOQtS9RdNOc/igmbs3DR65H9LO60zM2H1/Syti6Ofe/eUo5x2rvSAOrLWFS61Tsg0
        rq1grrz3JG6EUyFly7voRrO++3xlwFsm+oCCKRe6Pe5ZbWOIVcOa0ZMv3trJm4X2zy4TQpvZNwBc3
        uS+Z1/jQHATYIzmmn5bCRFOPfCaXBPxpZMRbwqY2BMf4AJEqr/4LNKbRRf+fI3iXzavUp0JyEBP2v
        LWRR2ZFjRD39sznLbAvQYyjyoHOnEO/KJ4kvN53X2s8wj2HG1Fm4LHcmI1/EG2MfdINZkeItVG5qK
        ShqwR/wg==;
Received: from ulthar.dreamlands ([192.168.96.2] helo=ulthar.dreamlands.azazel.net)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mw7Ws-004cqg-8X
        for netfilter-devel@vger.kernel.org; Sat, 11 Dec 2021 18:55:30 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [nft PATCH 3/3] evaluate: reject: support ethernet as L2 protcol for inet table
Date:   Sat, 11 Dec 2021 18:55:25 +0000
Message-Id: <20211211185525.20527-4-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211211185525.20527-1-jeremy@azazel.net>
References: <20211211185525.20527-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 192.168.96.2
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When we are evaluating a `reject` statement in the `inet` family, we may
have `ether` and `ip` or `ip6` as the L2 and L3 protocols in the
evaluation context:

  table inet filter {
    chain input {
      type filter hook input priority filter;
      ether saddr aa:bb:cc:dd:ee:ff ip daddr 192.168.0.1 reject
    }
  }

Since no `reject` option is given, nft attempts to infer one and fails:

  BUG: unsupported familynft: evaluate.c:2766:stmt_evaluate_reject_inet_family: Assertion `0' failed.
  Aborted

The reason it fails is that the ethernet protocol numbers for IPv4 and
IPv6 (`ETH_P_IP` and `ETH_P_IPV6`) do not match `NFPROTO_IPV4` and
`NFPROTO_IPV6`.  Add support for the ethernet protocol numbers.

Replace the current `BUG("unsupported family")` error message with
something more informative that tells the user to provide an explicit
reject option.

Add a Python test case.

Fixes: 5fdd0b6a0600 ("nft: complete reject support")
Link: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1001360
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/evaluate.c                      |  7 +++++-
 tests/py/inet/reject.t              |  2 ++
 tests/py/inet/reject.t.json         | 34 +++++++++++++++++++++++++++++
 tests/py/inet/reject.t.payload.inet | 10 +++++++++
 4 files changed, 52 insertions(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 4d4dcc2e3d08..8edefbd1be21 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2751,19 +2751,22 @@ static int stmt_evaluate_reject_inet_family(struct eval_ctx *ctx,
 		protocol = proto_find_num(base, desc);
 		switch (protocol) {
 		case NFPROTO_IPV4:
+		case __constant_htons(ETH_P_IP):
 			if (stmt->reject.family == NFPROTO_IPV4)
 				break;
 			return stmt_binary_error(ctx, stmt->reject.expr,
 				  &ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR],
 				  "conflicting protocols specified: ip vs ip6");
 		case NFPROTO_IPV6:
+		case __constant_htons(ETH_P_IPV6):
 			if (stmt->reject.family == NFPROTO_IPV6)
 				break;
 			return stmt_binary_error(ctx, stmt->reject.expr,
 				  &ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR],
 				  "conflicting protocols specified: ip vs ip6");
 		default:
-			BUG("unsupported family");
+			return stmt_error(ctx, stmt,
+				  "cannot infer ICMP reject variant to use: explicit value required.\n");
 		}
 		break;
 	}
@@ -2923,10 +2926,12 @@ static int stmt_evaluate_reject_default(struct eval_ctx *ctx,
 		protocol = proto_find_num(base, desc);
 		switch (protocol) {
 		case NFPROTO_IPV4:
+		case __constant_htons(ETH_P_IP):
 			stmt->reject.family = NFPROTO_IPV4;
 			stmt->reject.icmp_code = ICMP_PORT_UNREACH;
 			break;
 		case NFPROTO_IPV6:
+		case __constant_htons(ETH_P_IPV6):
 			stmt->reject.family = NFPROTO_IPV6;
 			stmt->reject.icmp_code = ICMP6_DST_UNREACH_NOPORT;
 			break;
diff --git a/tests/py/inet/reject.t b/tests/py/inet/reject.t
index 1c8aeebe1b07..61a6d556d2ad 100644
--- a/tests/py/inet/reject.t
+++ b/tests/py/inet/reject.t
@@ -37,3 +37,5 @@ meta l4proto udp reject with tcp reset;fail
 
 meta nfproto ipv4 reject with icmpx admin-prohibited;ok
 meta nfproto ipv6 reject with icmpx admin-prohibited;ok
+
+ether saddr aa:bb:cc:dd:ee:ff ip daddr 192.168.0.1 reject;ok;ether saddr aa:bb:cc:dd:ee:ff ip daddr 192.168.0.1 reject with icmp port-unreachable
diff --git a/tests/py/inet/reject.t.json b/tests/py/inet/reject.t.json
index 76cd1bf579d2..02ac9007ef33 100644
--- a/tests/py/inet/reject.t.json
+++ b/tests/py/inet/reject.t.json
@@ -295,3 +295,37 @@
     }
 ]
 
+# ether saddr aa:bb:cc:dd:ee:ff ip daddr 192.168.0.1 reject
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "saddr",
+                    "protocol": "ether"
+                }
+            },
+            "op": "==",
+            "right": "aa:bb:cc:dd:ee:ff"
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "daddr",
+                    "protocol": "ip"
+                }
+            },
+            "op": "==",
+            "right": "192.168.0.1"
+        }
+    },
+    {
+        "reject": {
+            "expr": "port-unreachable",
+            "type": "icmp"
+        }
+    }
+]
+
diff --git a/tests/py/inet/reject.t.payload.inet b/tests/py/inet/reject.t.payload.inet
index 62078d91b0cf..828cb839c30c 100644
--- a/tests/py/inet/reject.t.payload.inet
+++ b/tests/py/inet/reject.t.payload.inet
@@ -132,3 +132,13 @@ inet test-inet input
   [ cmp eq reg 1 0x0000000a ]
   [ reject type 2 code 3 ]
 
+# ether saddr aa:bb:cc:dd:ee:ff ip daddr 192.168.0.1 reject
+inet test-inet input
+  [ meta load iiftype => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 8b @ link header + 6 => reg 1 ]
+  [ cmp eq reg 1 0xddccbbaa 0x0008ffee ]
+  [ payload load 4b @ network header + 16 => reg 1 ]
+  [ cmp eq reg 1 0x0100a8c0 ]
+  [ reject type 0 code 3 ]
+
-- 
2.33.0

