Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96B35B7
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Dec 2023 09:07:09 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rDShQ-0001Yp-8i; Wed, 13 Dec 2023 18:07:08 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 3/3] evaluate: don't assert if set->data is NULL
Date: Wed, 13 Dec 2023 18:06:45 +0100
Message-ID: <20231213170650.13451-4-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231213170650.13451-1-fw@strlen.de>
References: <20231213170650.13451-1-fw@strlen.de>
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
index 39296f8226db..89b84cd03864 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2104,6 +2104,10 @@ static int expr_evaluate_mapping(struct eval_ctx *ctx, struct expr **expr)
 	if (!set_is_map(set->flags))
 		return set_error(ctx, set, "set is not a map");
 
+	/* set already has more known issues, do not evaluate further */
+	if (set->errors)
+		return -1;
+
 	expr_set_context(&ctx->ectx, set->key->dtype, set->key->len);
 	if (expr_evaluate(ctx, &mapping->left) < 0)
 		return -1;
@@ -5325,12 +5329,17 @@ static int table_evaluate(struct eval_ctx *ctx, struct table *table)
 
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
@@ -5356,6 +5365,8 @@ static int cmd_evaluate_add(struct eval_ctx *ctx, struct cmd *cmd)
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

