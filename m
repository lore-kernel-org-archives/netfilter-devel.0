Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7D9AC433FE
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Mar 2022 09:00:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231963AbiC2JCa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Mar 2022 05:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234367AbiC2JC3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Mar 2022 05:02:29 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AD107208247
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Mar 2022 02:00:46 -0700 (PDT)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id BD59C6302B
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Mar 2022 10:57:34 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2 3/4] src: allow to use integer type header fields via typeof set declaration
Date:   Tue, 29 Mar 2022 11:00:40 +0200
Message-Id: <20220329090041.1156012-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220329090041.1156012-1-pablo@netfilter.org>
References: <20220329090041.1156012-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Header fields such as udp length cannot be used in concatenations because
it is using the generic integer_type:

 test.nft:3:10-19: Error: can not use variable sized data types (integer) in concat expressions
                typeof udp length . @th,32,32
                       ^^^^^^^^^^~~~~~~~~~~~~

This patch slightly extends ("src: allow to use typeof of raw expressions in
set declaration") to set on NFTNL_UDATA_SET_KEY_PAYLOAD_LEN in userdata if
TYPE_INTEGER is used.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: add more tests.

 src/evaluate.c                                |  2 +-
 src/payload.c                                 | 15 ++++++-----
 .../testcases/maps/dumps/typeof_integer_0.nft | 20 ++++++++++++++
 tests/shell/testcases/maps/typeof_integer_0   | 27 +++++++++++++++++++
 4 files changed, 57 insertions(+), 7 deletions(-)
 create mode 100644 tests/shell/testcases/maps/dumps/typeof_integer_0.nft
 create mode 100755 tests/shell/testcases/maps/typeof_integer_0

diff --git a/src/evaluate.c b/src/evaluate.c
index 61dd4fea10e6..6b3b63662411 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3970,7 +3970,7 @@ static int set_expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
 			return expr_error(ctx->msgs, i,
 					  "specify either ip or ip6 for address matching");
 
-		if (i->etype == EXPR_PAYLOAD && i->payload.is_raw &&
+		if (i->etype == EXPR_PAYLOAD &&
 		    i->dtype->type == TYPE_INTEGER) {
 			struct datatype *dtype;
 
diff --git a/src/payload.c b/src/payload.c
index fd6f7011365d..66418cddb3b5 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -153,9 +153,9 @@ static int payload_expr_build_udata(struct nftnl_udata_buf *udbuf,
 				    expr->payload.base);
 		nftnl_udata_put_u32(udbuf, NFTNL_UDATA_SET_KEY_PAYLOAD_OFFSET,
 				    expr->payload.offset);
-		nftnl_udata_put_u32(udbuf, NFTNL_UDATA_SET_KEY_PAYLOAD_LEN,
-				    expr->len);
 	}
+	if (expr->dtype->type == TYPE_INTEGER)
+		nftnl_udata_put_u32(udbuf, NFTNL_UDATA_SET_KEY_PAYLOAD_LEN, expr->len);
 
 	return 0;
 }
@@ -191,7 +191,7 @@ static int payload_parse_udata(const struct nftnl_udata *attr, void *data)
 static struct expr *payload_expr_parse_udata(const struct nftnl_udata *attr)
 {
 	const struct nftnl_udata *ud[NFTNL_UDATA_SET_KEY_PAYLOAD_MAX + 1] = {};
-	unsigned int type, base, offset, len;
+	unsigned int type, base, offset, len = 0;
 	const struct proto_desc *desc;
 	bool is_raw = false;
 	struct expr *expr;
@@ -209,20 +209,23 @@ static struct expr *payload_expr_parse_udata(const struct nftnl_udata *attr)
 	desc = find_proto_desc(ud[NFTNL_UDATA_SET_KEY_PAYLOAD_DESC]);
 	if (!desc) {
 		if (!ud[NFTNL_UDATA_SET_KEY_PAYLOAD_BASE] ||
-		    !ud[NFTNL_UDATA_SET_KEY_PAYLOAD_OFFSET] ||
-		    !ud[NFTNL_UDATA_SET_KEY_PAYLOAD_LEN])
+		    !ud[NFTNL_UDATA_SET_KEY_PAYLOAD_OFFSET])
 			return NULL;
 
 		base = nftnl_udata_get_u32(ud[NFTNL_UDATA_SET_KEY_PAYLOAD_BASE]);
 		offset = nftnl_udata_get_u32(ud[NFTNL_UDATA_SET_KEY_PAYLOAD_OFFSET]);
-		len = nftnl_udata_get_u32(ud[NFTNL_UDATA_SET_KEY_PAYLOAD_LEN]);
 		is_raw = true;
 	}
 
 	type = nftnl_udata_get_u32(ud[NFTNL_UDATA_SET_KEY_PAYLOAD_TYPE]);
+	if (ud[NFTNL_UDATA_SET_KEY_PAYLOAD_LEN])
+		len = nftnl_udata_get_u32(ud[NFTNL_UDATA_SET_KEY_PAYLOAD_LEN]);
 
 	expr = payload_expr_alloc(&internal_location, desc, type);
 
+	if (len)
+		expr->len = len;
+
 	if (is_raw) {
 		struct datatype *dtype;
 
diff --git a/tests/shell/testcases/maps/dumps/typeof_integer_0.nft b/tests/shell/testcases/maps/dumps/typeof_integer_0.nft
new file mode 100644
index 000000000000..330415574c95
--- /dev/null
+++ b/tests/shell/testcases/maps/dumps/typeof_integer_0.nft
@@ -0,0 +1,20 @@
+table inet t {
+	map m1 {
+		typeof udp length . @ih,32,32 : verdict
+		flags interval
+		elements = { 20-80 . 0x14 : accept,
+			     1-10 . 0xa : drop }
+	}
+
+	map m2 {
+		typeof udp length . @ih,32,32 : verdict
+		elements = { 30 . 0x1e : drop,
+			     20 . 0x24 : accept }
+	}
+
+	chain c {
+		udp length . @ih,32,32 vmap @m1
+		udp length . @ih,32,32 vmap @m2
+		udp length . @th,160,128 vmap { 47-63 . 0xe373135363130333131303735353203 : accept }
+	}
+}
diff --git a/tests/shell/testcases/maps/typeof_integer_0 b/tests/shell/testcases/maps/typeof_integer_0
new file mode 100755
index 000000000000..d8781e39812a
--- /dev/null
+++ b/tests/shell/testcases/maps/typeof_integer_0
@@ -0,0 +1,27 @@
+#!/bin/bash
+
+EXPECTED="table inet t {
+        map m1 {
+                typeof udp length . @ih,32,32 : verdict
+                flags interval
+                elements = { 20-80 . 0x14 : accept, 1-10 . 0xa : drop }
+        }
+
+        map m2 {
+                typeof udp length . @ih,32,32 : verdict
+                elements = { 20 . 0x24 : accept, 30 . 0x1e : drop }
+        }
+
+        chain c {
+                udp length . @ih,32,32 vmap @m1
+                udp length . @ih,32,32 vmap @m2
+		udp length . @th,160,128 vmap { 47-63 . 0xe373135363130333131303735353203 : accept }
+        }
+}"
+
+$NFT add element inet t m1 { 90-100 . 40 : drop }
+$NFT delete element inet t m2 { 20 . 20 : accept }
+
+set -e
+$NFT -f - <<< $EXPECTED
+
-- 
2.30.2

