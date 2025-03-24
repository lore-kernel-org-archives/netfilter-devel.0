Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8DB928E7
	for <netfilter-devel@vger.kernel.org>; Mon, 24 Mar 2025 12:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742818262; cv=none; b=PzfxjYSVldLTVAoTfGubaSV1fWL55BDQEhVNHNsf07obHMKCmjj3ossOaEKJ8SKDI5ijBG//2ev2CU6oe3T08YkGcq3eUadbM3dk6StNhKR0Ah0kBlKBRaz9PopccCan32FJ3nT6zokFuj7j/FIf9DMUSEY5UZA5/5Abs9cQ6nA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742818262; c=relaxed/simple;
	bh=FL+gMqLOHf4+ImTBFdzMSyXctBde4S68dAbFc0RBGXU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZsmGAamea5F15VF7sgPqCYpUHLsHZNBmjyRzNgTuD20EIq0bIosS21Z80bNZwYW1P8zHBTTcVfgdtbcBRYy5uUcCv9w0TjgZ2/K+OF8LWz4aJfkZqi0hCo8oA6Z69P7A810Eq3A8g0qaP/u9++lu6BJVXE2/3hMbsQBB3CHf1z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1twgdo-0002WT-ML; Mon, 24 Mar 2025 13:10:52 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] evaluate: tolerate empty concatenation
Date: Mon, 24 Mar 2025 12:52:58 +0100
Message-ID: <20250324115301.11579-1-fw@strlen.de>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Don't rely on a successful evaluation of set->key.
With this input, set->key fails validation but subsequent
element evaluation asserts because the context points at
the set key -- an empty concatenation.

Causes:
nft: src/evaluate.c:1681: expr_evaluate_concat: Assertion `!list_empty(&ctx->ectx.key->expressions)' failed.

After patch:
internal:0:0-0: Error: unqualified type  specified in set definition. Try "typeof expression" instead of "type datatype".
internal:0:0-0: Error: Could not parse symbolic invalid expression

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c                                | 10 +++++--
 ...pr_evaluate_concat_empty_concat_key_assert | 27 +++++++++++++++++++
 2 files changed, 35 insertions(+), 2 deletions(-)
 create mode 100644 tests/shell/testcases/bogons/nft-j-f/expr_evaluate_concat_empty_concat_key_assert

diff --git a/src/evaluate.c b/src/evaluate.c
index 1e7f6f53542b..a6b08cf3b1b5 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1645,6 +1645,13 @@ static int list_member_evaluate(struct eval_ctx *ctx, struct expr **expr)
 	return err;
 }
 
+static bool ctx_has_concat_key(const struct eval_ctx *ctx)
+{
+	/* Ignore empty concatenation key, set eval queued an error */
+	return ctx->ectx.key && ctx->ectx.key->etype == EXPR_CONCAT &&
+	       !list_empty(&ctx->ectx.key->expressions);
+}
+
 static int expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
 {
 	const struct datatype *dtype = ctx->ectx.dtype, *tmp;
@@ -1657,9 +1664,8 @@ static int expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
 	bool runaway = false;
 	uint32_t size = 0;
 
-	if (ctx->ectx.key && ctx->ectx.key->etype == EXPR_CONCAT) {
+	if (ctx_has_concat_key(ctx)) {
 		key_ctx = ctx->ectx.key;
-		assert(!list_empty(&ctx->ectx.key->expressions));
 		key = list_first_entry(&ctx->ectx.key->expressions, struct expr, list);
 		expressions = &ctx->ectx.key->expressions;
 	}
diff --git a/tests/shell/testcases/bogons/nft-j-f/expr_evaluate_concat_empty_concat_key_assert b/tests/shell/testcases/bogons/nft-j-f/expr_evaluate_concat_empty_concat_key_assert
new file mode 100644
index 000000000000..956ecdc99721
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-j-f/expr_evaluate_concat_empty_concat_key_assert
@@ -0,0 +1,27 @@
+{
+  "nftables": [
+    {
+      "table": { "family": "ip",
+        "name": "t",
+        "handle": 0
+      }
+    },
+    {
+      "set": {
+        "family": "ip",
+        "name": "s",
+        "table": "t",
+        "type": [
+             ],
+        "elem": [
+          {
+            "concat": [
+              "foo", "bar"
+            ]
+          }
+        ]
+      }
+    }
+  ]
+}
+
-- 
2.48.1

