Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D2053E470
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Jan 2024 08:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rNTvg-0006qq-ER; Wed, 10 Jan 2024 09:27:16 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nft 3/3] evaluate: don't assert if set->data is NULL
Date: Wed, 10 Jan 2024 09:26:54 +0100
Message-ID: <20240110082657.1967-4-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20240110082657.1967-1-fw@strlen.de>
References: <20240110082657.1967-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For the objref map case, set->data is only non-null if set evaluation
completed successfully.

Before:
nft: src/evaluate.c:2115: expr_evaluate_mapping: Assertion `set->data != NULL' failed.

After:
expr_evaluate_mapping_no_data_assert:1:5-5: Error: No such file or directory
map m p {
    ^

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c                                      | 13 ++++++++++++-
 .../nft-f/expr_evaluate_mapping_no_data_assert      |  4 ++++
 2 files changed, 16 insertions(+), 1 deletion(-)
 create mode 100644 tests/shell/testcases/bogons/nft-f/expr_evaluate_mapping_no_data_assert

diff --git a/src/evaluate.c b/src/evaluate.c
index 4e9a95ad4c9d..582877ecea9a 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2144,6 +2144,10 @@ static int expr_evaluate_mapping(struct eval_ctx *ctx, struct expr **expr)
 	if (!set_is_map(set->flags))
 		return set_error(ctx, set, "set is not a map");
 
+	/* set already has more known issues, do not evaluate further */
+	if (set->errors)
+		return -1;
+
 	expr_set_context(&ctx->ectx, set->key->dtype, set->key->len);
 	if (expr_evaluate(ctx, &mapping->left) < 0)
 		return -1;
@@ -5387,12 +5391,17 @@ static int table_evaluate(struct eval_ctx *ctx, struct table *table)
 
 static int cmd_evaluate_add(struct eval_ctx *ctx, struct cmd *cmd)
 {
+	int err = -1;
+
 	switch (cmd->obj) {
 	case CMD_OBJ_ELEMENTS:
 		return setelem_evaluate(ctx, cmd);
 	case CMD_OBJ_SET:
 		handle_merge(&cmd->set->handle, &cmd->handle);
-		return set_evaluate(ctx, cmd->set);
+		err = set_evaluate(ctx, cmd->set);
+		if (err)
+			cmd->set->errors = true;
+		break;
 	case CMD_OBJ_SETELEMS:
 		return elems_evaluate(ctx, cmd->set);
 	case CMD_OBJ_RULE:
@@ -5418,6 +5427,8 @@ static int cmd_evaluate_add(struct eval_ctx *ctx, struct cmd *cmd)
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
 	}
+
+	return err;
 }
 
 static void table_del_cache(struct eval_ctx *ctx, struct cmd *cmd)
diff --git a/tests/shell/testcases/bogons/nft-f/expr_evaluate_mapping_no_data_assert b/tests/shell/testcases/bogons/nft-f/expr_evaluate_mapping_no_data_assert
new file mode 100644
index 000000000000..34d3df61f334
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/expr_evaluate_mapping_no_data_assert
@@ -0,0 +1,4 @@
+map m p {
+	type ipv4_addr : counter
+	elements = { 1.2.3.4 : 1, }
+}
-- 
2.41.0

