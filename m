Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EC1CC27C40
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Nov 2023 21:01:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232271AbjKVVBn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Nov 2023 16:01:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231437AbjKVVBm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Nov 2023 16:01:42 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 71A06112
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2023 13:01:38 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] evaluate: clone unary expression datatype to deal with dynamic datatype
Date:   Wed, 22 Nov 2023 22:01:06 +0100
Message-Id: <20231122210106.183932-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When allocating a unary expression, clone the datatype to deal with
dynamic datatypes.

Fixes: 6b01bb9ff798 ("datatype: concat expression only releases dynamically allocated datatype")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c                                  |  2 +-
 tests/shell/testcases/maps/dumps/vmap_unary.nft | 11 +++++++++++
 tests/shell/testcases/maps/vmap_unary           | 17 +++++++++++++++++
 3 files changed, 29 insertions(+), 1 deletion(-)
 create mode 100644 tests/shell/testcases/maps/dumps/vmap_unary.nft
 create mode 100755 tests/shell/testcases/maps/vmap_unary

diff --git a/src/evaluate.c b/src/evaluate.c
index bcf83d804f32..2ead03471102 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1245,7 +1245,7 @@ static int expr_evaluate_unary(struct eval_ctx *ctx, struct expr **expr)
 		BUG("invalid unary operation %u\n", unary->op);
 	}
 
-	unary->dtype	 = arg->dtype;
+	unary->dtype	 = datatype_clone(arg->dtype);
 	unary->byteorder = byteorder;
 	unary->len	 = arg->len;
 	return 0;
diff --git a/tests/shell/testcases/maps/dumps/vmap_unary.nft b/tests/shell/testcases/maps/dumps/vmap_unary.nft
new file mode 100644
index 000000000000..46c538b7910d
--- /dev/null
+++ b/tests/shell/testcases/maps/dumps/vmap_unary.nft
@@ -0,0 +1,11 @@
+table ip filter {
+	map ipsec_in {
+		typeof ipsec in reqid . iif : verdict
+		flags interval
+	}
+
+	chain INPUT {
+		type filter hook input priority filter; policy drop;
+		ipsec in reqid . iif vmap @ipsec_in
+	}
+}
diff --git a/tests/shell/testcases/maps/vmap_unary b/tests/shell/testcases/maps/vmap_unary
new file mode 100755
index 000000000000..4038d1c109ff
--- /dev/null
+++ b/tests/shell/testcases/maps/vmap_unary
@@ -0,0 +1,17 @@
+#!/bin/bash
+
+set -e
+
+RULESET="table ip filter {
+	map ipsec_in {
+		typeof ipsec in reqid . iif : verdict
+		flags interval
+	}
+
+	chain INPUT {
+		type filter hook input priority 0; policy drop
+		ipsec in reqid . iif vmap @ipsec_in
+	}
+}"
+
+$NFT -f - <<< $RULESET
-- 
2.30.2

