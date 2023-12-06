Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6610FD46
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Dec 2023 09:48:35 -0800 (PST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nft] evaluate: reset statement length context before evaluating statement
Date: Wed,  6 Dec 2023 18:48:29 +0100
Message-Id: <20231206174829.869237-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch consolidates ctx->stmt_len reset in stmt_evaluate() to avoid
this problem. Note that stmt_evaluate_meta() and stmt_evaluate_ct()
already reset it after the statement evaluation.

Moreover, statement dependency can be generated while evaluating a meta
and ct statement. Payload statement dependency already manually stashes
this before calling stmt_evaluate(). Add a new stmt_dependency_evaluate()
function to stash statement length context when evaluating a new statement
dependency and use it for all of the existing statement dependencies.

Florian also says:

'meta mark set vlan id map { 1 : 0x00000001, 4095 : 0x00004095 }' will
crash. Reason is that the l2 dependency generated here is errounously
expanded to a 32bit-one, so the evaluation path won't recognize this
as a L2 dependency.  Therefore, pctx->stacked_ll_count is 0 and
__expr_evaluate_payload() crashes with a null deref when
dereferencing pctx->stacked_ll[0].

nft-test.py gains a fugly hack to tolerate '!map typeof vlan id : meta mark'.
For more generic support we should find something more acceptable, e.g.

!map typeof( everything here is a key or data ) timeout ...

tests/py update and assert(pctx->stacked_ll_count) by Florian Westphal.

Fixes: edecd58755a8 ("evaluate: support shifts larger than the width of the left operand")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/statement.h                |  1 +
 src/evaluate.c                     | 26 ++++++++++++++++++--------
 src/payload.c                      | 29 +++++++----------------------
 tests/py/any/meta.t                |  4 ++++
 tests/py/any/meta.t.payload        | 26 ++++++++++++++++++++++++++
 tests/py/any/meta.t.payload.bridge | 21 +++++++++++++++++++++
 tests/py/nft-test.py               | 17 +++++++++++++----
 7 files changed, 90 insertions(+), 34 deletions(-)
 create mode 100644 tests/py/any/meta.t.payload.bridge

diff --git a/include/statement.h b/include/statement.h
index 720a6ac2c754..662f99ddef79 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -416,6 +416,7 @@ struct stmt {
 extern struct stmt *stmt_alloc(const struct location *loc,
 			       const struct stmt_ops *ops);
 int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt);
+int stmt_dependency_evaluate(struct eval_ctx *ctx, struct stmt *stmt);
 extern void stmt_free(struct stmt *stmt);
 extern void stmt_list_free(struct list_head *list);
 extern void stmt_print(const struct stmt *stmt, struct output_ctx *octx);
diff --git a/src/evaluate.c b/src/evaluate.c
index c32857c75565..a62a23460e7b 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -454,6 +454,18 @@ static int expr_evaluate_primary(struct eval_ctx *ctx, struct expr **expr)
 	return 0;
 }
 
+int stmt_dependency_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
+{
+	uint32_t stmt_len = ctx->stmt_len;
+
+	if (stmt_evaluate(ctx, stmt) < 0)
+		return stmt_error(ctx, stmt, "dependency statement is invalid");
+
+	ctx->stmt_len = stmt_len;
+
+	return 0;
+}
+
 static int
 conflict_resolution_gen_dependency(struct eval_ctx *ctx, int protocol,
 				   const struct expr *expr,
@@ -479,7 +491,7 @@ conflict_resolution_gen_dependency(struct eval_ctx *ctx, int protocol,
 
 	dep = relational_expr_alloc(&expr->location, OP_EQ, left, right);
 	stmt = expr_stmt_alloc(&dep->location, dep);
-	if (stmt_evaluate(ctx, stmt) < 0)
+	if (stmt_dependency_evaluate(ctx, stmt) < 0)
 		return expr_error(ctx->msgs, expr,
 					  "dependency statement is invalid");
 
@@ -705,9 +717,8 @@ static int meta_iiftype_gen_dependency(struct eval_ctx *ctx,
 				  "for this family");
 
 	nstmt = meta_stmt_meta_iiftype(&payload->location, type);
-	if (stmt_evaluate(ctx, nstmt) < 0)
-		return expr_error(ctx->msgs, payload,
-				  "dependency statement is invalid");
+	if (stmt_dependency_evaluate(ctx, nstmt) < 0)
+		return -1;
 
 	if (ctx->inner_desc)
 		nstmt->expr->left->meta.inner_desc = ctx->inner_desc;
@@ -818,6 +829,7 @@ static int __expr_evaluate_payload(struct eval_ctx *ctx, struct expr *expr)
 						  desc->name,
 						  payload->payload.desc->name);
 
+			assert(pctx->stacked_ll_count);
 			payload->payload.offset += pctx->stacked_ll[0]->length;
 			rule_stmt_insert_at(ctx->rule, nstmt, ctx->stmt);
 			return 1;
@@ -3171,8 +3183,6 @@ static int stmt_evaluate_meta(struct eval_ctx *ctx, struct stmt *stmt)
 				stmt->meta.tmpl->len,
 				stmt->meta.tmpl->byteorder,
 				&stmt->meta.expr);
-	ctx->stmt_len = 0;
-
 	if (ret < 0)
 		return ret;
 
@@ -3200,8 +3210,6 @@ static int stmt_evaluate_ct(struct eval_ctx *ctx, struct stmt *stmt)
 				stmt->ct.tmpl->len,
 				stmt->ct.tmpl->byteorder,
 				&stmt->ct.expr);
-	ctx->stmt_len = 0;
-
 	if (ret < 0)
 		return -1;
 
@@ -4497,6 +4505,8 @@ int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
 		erec_destroy(erec);
 	}
 
+	ctx->stmt_len = 0;
+
 	switch (stmt->ops->type) {
 	case STMT_CONNLIMIT:
 	case STMT_COUNTER:
diff --git a/src/payload.c b/src/payload.c
index 140ca50addf7..5de3d320758a 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -407,7 +407,6 @@ static int payload_add_dependency(struct eval_ctx *ctx,
 	const struct proto_hdr_template *tmpl;
 	struct expr *dep, *left, *right;
 	struct proto_ctx *pctx;
-	unsigned int stmt_len;
 	struct stmt *stmt;
 	int protocol;
 
@@ -429,15 +428,9 @@ static int payload_add_dependency(struct eval_ctx *ctx,
 
 	dep = relational_expr_alloc(&expr->location, OP_EQ, left, right);
 
-	stmt_len = ctx->stmt_len;
-	ctx->stmt_len = 0;
-
 	stmt = expr_stmt_alloc(&dep->location, dep);
-	if (stmt_evaluate(ctx, stmt) < 0) {
-		return expr_error(ctx->msgs, expr,
-					  "dependency statement is invalid");
-	}
-	ctx->stmt_len = stmt_len;
+	if (stmt_dependency_evaluate(ctx, stmt) < 0)
+		return -1;
 
 	if (ctx->inner_desc) {
 		if (tmpl->meta_key)
@@ -547,7 +540,6 @@ int payload_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
 	const struct hook_proto_desc *h;
 	const struct proto_desc *desc;
 	struct proto_ctx *pctx;
-	unsigned int stmt_len;
 	struct stmt *stmt;
 	uint16_t type;
 
@@ -564,17 +556,11 @@ int payload_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
 					  "protocol specification is invalid "
 					  "for this family");
 
-		stmt_len = ctx->stmt_len;
-		ctx->stmt_len = 0;
-
 		stmt = meta_stmt_meta_iiftype(&expr->location, type);
-		if (stmt_evaluate(ctx, stmt) < 0) {
-			return expr_error(ctx->msgs, expr,
-					  "dependency statement is invalid");
-		}
-		*res = stmt;
+		if (stmt_dependency_evaluate(ctx, stmt) < 0)
+			return -1;
 
-		ctx->stmt_len = stmt_len;
+		*res = stmt;
 
 		return 0;
 	}
@@ -1442,9 +1428,8 @@ int payload_gen_icmp_dependency(struct eval_ctx *ctx, const struct expr *expr,
 
 	pctx->th_dep.icmp.type = type;
 
-	if (stmt_evaluate(ctx, stmt) < 0)
-		return expr_error(ctx->msgs, expr,
-				  "icmp dependency statement is invalid");
+	if (stmt_dependency_evaluate(ctx, stmt) < 0)
+		return -1;
 done:
 	*res = stmt;
 	return 0;
diff --git a/tests/py/any/meta.t b/tests/py/any/meta.t
index 12fabb79f5f9..718c7ad96186 100644
--- a/tests/py/any/meta.t
+++ b/tests/py/any/meta.t
@@ -224,3 +224,7 @@ time > "2022-07-01 11:00:00" accept;ok;meta time > "2022-07-01 11:00:00" accept
 meta time "meh";fail
 meta hour "24:00" drop;fail
 meta day 7 drop;fail
+
+meta mark set vlan id map { 1 : 0x00000001, 4095 : 0x00004095 };ok
+!map1 typeof vlan id : meta mark;ok
+meta mark set vlan id map @map1;ok
diff --git a/tests/py/any/meta.t.payload b/tests/py/any/meta.t.payload
index 16dc12118bac..d841377ec6cd 100644
--- a/tests/py/any/meta.t.payload
+++ b/tests/py/any/meta.t.payload
@@ -1072,3 +1072,29 @@ ip test-ip4 input
   [ byteorder reg 1 = hton(reg 1, 8, 8) ]
   [ cmp gt reg 1 0xf3a8fd16 0x00a07719 ]
   [ immediate reg 0 accept ]
+
+# meta mark set vlan id map { 1 : 0x00000001, 4095 : 0x00004095 }
+__map%d test-ip4 b size 2
+__map%d test-ip4 0
+	element 00000100  : 00000001 0 [end]	element 0000ff0f  : 00004095 0 [end]
+ip test-ip4 input
+  [ meta load iiftype => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x00000081 ]
+  [ payload load 2b @ link header + 14 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ lookup reg 1 set __map%d dreg 1 ]
+  [ meta set mark with reg 1 ]
+
+# meta mark set vlan id map @map1
+ip test-ip4 input
+  [ meta load iiftype => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x00000081 ]
+  [ payload load 2b @ link header + 14 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ lookup reg 1 set map1 dreg 1 ]
+  [ meta set mark with reg 1 ]
+
diff --git a/tests/py/any/meta.t.payload.bridge b/tests/py/any/meta.t.payload.bridge
new file mode 100644
index 000000000000..829a29b99974
--- /dev/null
+++ b/tests/py/any/meta.t.payload.bridge
@@ -0,0 +1,21 @@
+# meta mark set vlan id map { 1 : 0x00000001, 4095 : 0x00004095 }
+__map%d test-bridge b size 2
+__map%d test-bridge 0
+	element 00000100  : 00000001 0 [end]	element 0000ff0f  : 00004095 0 [end]
+bridge test-bridge input
+  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x00000081 ]
+  [ payload load 2b @ link header + 14 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ lookup reg 1 set __map%d dreg 1 ]
+  [ meta set mark with reg 1 ]
+
+# meta mark set vlan id map @map1
+bridge test-bridge input
+  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x00000081 ]
+  [ payload load 2b @ link header + 14 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ lookup reg 1 set map1 dreg 1 ]
+  [ meta set mark with reg 1 ]
+
diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
index 9a25503d1f38..a7d27c25f9fe 100755
--- a/tests/py/nft-test.py
+++ b/tests/py/nft-test.py
@@ -368,9 +368,9 @@ def set_add(s, test_result, filename, lineno):
             flags = "flags %s; " % flags
 
         if s.data == "":
-                cmd = "add set %s %s { type %s;%s %s}" % (table, s.name, s.type, s.timeout, flags)
+                cmd = "add set %s %s { %s;%s %s}" % (table, s.name, s.type, s.timeout, flags)
         else:
-                cmd = "add map %s %s { type %s : %s;%s %s}" % (table, s.name, s.type, s.data, s.timeout, flags)
+                cmd = "add map %s %s { %s : %s;%s %s}" % (table, s.name, s.type, s.data, s.timeout, flags)
 
         ret = execute_cmd(cmd, filename, lineno)
 
@@ -410,7 +410,7 @@ def map_add(s, test_result, filename, lineno):
         if flags != "":
             flags = "flags %s; " % flags
 
-        cmd = "add map %s %s { type %s : %s;%s %s}" % (table, s.name, s.type, s.data, s.timeout, flags)
+        cmd = "add map %s %s { %s : %s;%s %s}" % (table, s.name, s.type, s.data, s.timeout, flags)
 
         ret = execute_cmd(cmd, filename, lineno)
 
@@ -1144,11 +1144,16 @@ def set_process(set_line, filename, lineno):
 
     tokens = set_line[0].split(" ")
     set_name = tokens[0]
-    set_type = tokens[2]
+    parse_typeof = tokens[1] == "typeof"
+    set_type = tokens[1] + " " + tokens[2]
     set_data = ""
     set_flags = ""
 
     i = 3
+    if parse_typeof and tokens[i] == "id":
+        set_type += " " + tokens[i]
+        i += 1;
+
     while len(tokens) > i and tokens[i] == ".":
         set_type += " . " + tokens[i+1]
         i += 2
@@ -1157,6 +1162,10 @@ def set_process(set_line, filename, lineno):
         set_data = tokens[i+1]
         i += 2
 
+    if parse_typeof and tokens[i] == "mark":
+        set_data += " " + tokens[i]
+        i += 1;
+
     if len(tokens) == i+2 and tokens[i] == "timeout":
         timeout = "timeout " + tokens[i+1] + ";"
         i += 2
-- 
2.30.2

