Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDFECC433EF
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Nov 2021 10:35:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B90560F24
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Nov 2021 10:35:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbhKBKh7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 2 Nov 2021 06:37:59 -0400
Received: from mail.netfilter.org ([217.70.188.207]:60240 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbhKBKh6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 Nov 2021 06:37:58 -0400
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 6DBF563F5C
        for <netfilter-devel@vger.kernel.org>; Tue,  2 Nov 2021 11:33:30 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] evaluate: postpone transport protocol match check after nat expression evaluation
Date:   Tue,  2 Nov 2021 11:35:20 +0100
Message-Id: <20211102103520.244560-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Fix bogus error report when using transport protocol as map key.

Fixes: 50780456a01a ("evaluate: check for missing transport protocol match in nat map with concatenations")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c                | 13 +++++++------
 tests/py/ip/dnat.t            |  1 +
 tests/py/ip/dnat.t.payload.ip | 13 +++++++++++++
 tests/py/ip/snat.t.payload    | 13 +++++++++++++
 4 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 609e171d8993..6a8c396f33c4 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3170,12 +3170,6 @@ static int stmt_evaluate_nat_map(struct eval_ctx *ctx, struct stmt *stmt)
 	const struct datatype *dtype;
 	int addr_type, err;
 
-	if (pctx->protocol[PROTO_BASE_TRANSPORT_HDR].desc == NULL &&
-	    !nat_evaluate_addr_has_th_expr(stmt->nat.addr))
-		return stmt_binary_error(ctx, stmt->nat.addr, stmt,
-					 "transport protocol mapping is only "
-					 "valid after transport protocol match");
-
 	switch (stmt->nat.family) {
 	case NFPROTO_IPV4:
 		addr_type = TYPE_IPADDR;
@@ -3192,6 +3186,13 @@ static int stmt_evaluate_nat_map(struct eval_ctx *ctx, struct stmt *stmt)
 	if (expr_evaluate(ctx, &stmt->nat.addr))
 		return -1;
 
+	if (pctx->protocol[PROTO_BASE_TRANSPORT_HDR].desc == NULL &&
+	    !nat_evaluate_addr_has_th_expr(stmt->nat.addr)) {
+		return stmt_binary_error(ctx, stmt->nat.addr, stmt,
+					 "transport protocol mapping is only "
+					 "valid after transport protocol match");
+	}
+
 	if (stmt->nat.addr->etype != EXPR_MAP)
 		return 0;
 
diff --git a/tests/py/ip/dnat.t b/tests/py/ip/dnat.t
index c5ca4c40db1b..889f0fd7bf6c 100644
--- a/tests/py/ip/dnat.t
+++ b/tests/py/ip/dnat.t
@@ -18,3 +18,4 @@ dnat to ct mark . ip daddr map { 0x00000014 . 1.1.1.1 : 1.2.3.4};ok
 dnat ip to ip saddr . tcp dport map { 192.168.1.2 . 80 : 10.141.10.0/24  . 8888 - 8999 };ok
 dnat ip to ip saddr . tcp dport map { 192.168.1.2 . 80 : 10.141.10.0/24  . 80 };ok
 dnat ip to ip saddr . tcp dport map { 192.168.1.2 . 80 : 10.141.10.2 . 8888 - 8999 };ok
+ip daddr 192.168.0.1 dnat ip to tcp dport map { 443 : 10.141.10.4 . 8443, 80 : 10.141.10.4 . 8080 };ok
diff --git a/tests/py/ip/dnat.t.payload.ip b/tests/py/ip/dnat.t.payload.ip
index 4872545a85a1..e53838a32262 100644
--- a/tests/py/ip/dnat.t.payload.ip
+++ b/tests/py/ip/dnat.t.payload.ip
@@ -167,3 +167,16 @@ ip
   [ immediate reg 4 0x00002723 ]
   [ nat dnat ip addr_min reg 1 addr_max reg 2 proto_min reg 3 proto_max reg 4 flags 0x2 ]
 
+# ip daddr 192.168.0.1 dnat ip to tcp dport map { 443 : 10.141.10.4 . 8443, 80 : 10.141.10.4 . 8080 }
+__map%d test-ip4 b size 2
+__map%d test-ip4 0
+        element 0000bb01  : 040a8d0a 0000fb20 0 [end]   element 00005000  : 040a8d0a 0000901f 0 [end]
+ip
+  [ payload load 4b @ network header + 16 => reg 1 ]
+  [ cmp eq reg 1 0x0100a8c0 ]
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __map%d dreg 1 ]
+  [ nat dnat ip addr_min reg 1 proto_min reg 9 ]
+
diff --git a/tests/py/ip/snat.t.payload b/tests/py/ip/snat.t.payload
index 48ae46b31121..71a5e2f1a54e 100644
--- a/tests/py/ip/snat.t.payload
+++ b/tests/py/ip/snat.t.payload
@@ -139,3 +139,16 @@ ip
   [ lookup reg 1 set __map%d dreg 1 ]
   [ nat snat ip addr_min reg 1 proto_min reg 9 ]
 
+# ip daddr 192.168.0.1 dnat to tcp dport map { 443 : 10.141.10.4 . 8443, 80 : 10.141.10.4 . 8080 }
+__map%d x b size 2
+__map%d x 0
+        element 0000bb01  : 040a8d0a 0000fb20 0 [end]   element 00005000  : 040a8d0a 0000901f 0 [end]
+ip
+  [ payload load 4b @ network header + 16 => reg 1 ]
+  [ cmp eq reg 1 0x0100a8c0 ]
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __map%d dreg 1 ]
+  [ nat dnat ip addr_min reg 1 proto_min reg 9 ]
+
-- 
2.30.2

