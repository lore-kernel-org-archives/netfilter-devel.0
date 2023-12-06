Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC89CD3
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Dec 2023 08:46:09 -0800 (PST)
Received: from [78.30.43.141] (port=59874 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1rAv2D-003yAh-PQ; Wed, 06 Dec 2023 17:46:08 +0100
Date: Wed, 6 Dec 2023 17:46:04 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] evaluate: reset statement length context for
 relational expressions
Message-ID: <ZXClTPtzZa3G8pyL@calendula>
References: <20231206130712.19368-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="/IY+lOJZhZ+GdkcI"
Content-Disposition: inline
In-Reply-To: <20231206130712.19368-1-fw@strlen.de>
X-Spam-Score: -1.8 (-)


--/IY+lOJZhZ+GdkcI
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Florian,

On Wed, Dec 06, 2023 at 02:07:09PM +0100, Florian Westphal wrote:
> 'meta mark set vlan id map { 1 : 0x00000001, 4095 : 0x00004095 }' will
> crash.  Reason is that the l2 dependency generated here is errounously
> expanded to a 32bit-one, so the evaluation path won't recognize this
> as a L2 dependency.  Therefore, pctx->stacked_ll_count is 0 and
> __expr_evaluate_payload() crashes with a null deref when
> dereferencing pctx->stacked_ll[0].
> 
> Reset stmt_len in expr_evaluate_relational() to avoid
> this.

See patch attached, I mangled your original patch with this:

    Consolidate stmt_len reset in stmt_evaluate() to avoid this.
    stmt_evaluate_meta() and stmt_evaluate_ct() already resets it, payload
    dependencies also manually reset this before calling stmt_evaluate() to
    evaluate such dependency.

See attachment. The idea is to consolidate all these ctx->stmt_len
resets.

--/IY+lOJZhZ+GdkcI
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0001-evaluate-reset-statement-length-context-for-relation.patch"

From ec20bdac25c11d0ec7b7867c1b68324e9d2ab8d9 Mon Sep 17 00:00:00 2001
From: Florian Westphal <fw@strlen.de>
Date: Wed, 6 Dec 2023 17:34:08 +0100
Subject: [PATCH] evaluate: reset statement length context for relational
 expressions

'meta mark set vlan id map { 1 : 0x00000001, 4095 : 0x00004095 }' will
crash.  Reason is that the l2 dependency generated here is errounously
expanded to a 32bit-one, so the evaluation path won't recognize this
as a L2 dependency.  Therefore, pctx->stacked_ll_count is 0 and
__expr_evaluate_payload() crashes with a null deref when
dereferencing pctx->stacked_ll[0].

Consolidate stmt_len reset in stmt_evaluate() to avoid this.
stmt_evaluate_meta() and stmt_evaluate_ct() already resets it, payload
dependencies also manually reset this before calling stmt_evaluate() to
evaluate such dependency.

nft-test.py gains a fugly hack to tolerate '!map typeof vlan id : meta mark'.
For more generic support we should find something more acceptable, e.g.

!map typeof( everything here is a key or data ) timeout ...

Fixes: 57f092a87fc4 ("evaluate: reset statement length context only for set mappings")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c                     |  7 +++----
 src/payload.c                      |  2 --
 tests/py/any/meta.t                |  4 ++++
 tests/py/any/meta.t.payload        | 26 ++++++++++++++++++++++++++
 tests/py/any/meta.t.payload.bridge | 21 +++++++++++++++++++++
 tests/py/nft-test.py               | 17 +++++++++++++----
 6 files changed, 67 insertions(+), 10 deletions(-)
 create mode 100644 tests/py/any/meta.t.payload.bridge

diff --git a/src/evaluate.c b/src/evaluate.c
index c32857c75565..440637ed0e39 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -818,6 +818,7 @@ static int __expr_evaluate_payload(struct eval_ctx *ctx, struct expr *expr)
 						  desc->name,
 						  payload->payload.desc->name);
 
+			assert(pctx->stacked_ll_count);
 			payload->payload.offset += pctx->stacked_ll[0]->length;
 			rule_stmt_insert_at(ctx->rule, nstmt, ctx->stmt);
 			return 1;
@@ -3171,8 +3172,6 @@ static int stmt_evaluate_meta(struct eval_ctx *ctx, struct stmt *stmt)
 				stmt->meta.tmpl->len,
 				stmt->meta.tmpl->byteorder,
 				&stmt->meta.expr);
-	ctx->stmt_len = 0;
-
 	if (ret < 0)
 		return ret;
 
@@ -3200,8 +3199,6 @@ static int stmt_evaluate_ct(struct eval_ctx *ctx, struct stmt *stmt)
 				stmt->ct.tmpl->len,
 				stmt->ct.tmpl->byteorder,
 				&stmt->ct.expr);
-	ctx->stmt_len = 0;
-
 	if (ret < 0)
 		return -1;
 
@@ -4497,6 +4494,8 @@ int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
 		erec_destroy(erec);
 	}
 
+	ctx->stmt_len = 0;
+
 	switch (stmt->ops->type) {
 	case STMT_CONNLIMIT:
 	case STMT_COUNTER:
diff --git a/src/payload.c b/src/payload.c
index 140ca50addf7..66c93e5064cf 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -430,7 +430,6 @@ static int payload_add_dependency(struct eval_ctx *ctx,
 	dep = relational_expr_alloc(&expr->location, OP_EQ, left, right);
 
 	stmt_len = ctx->stmt_len;
-	ctx->stmt_len = 0;
 
 	stmt = expr_stmt_alloc(&dep->location, dep);
 	if (stmt_evaluate(ctx, stmt) < 0) {
@@ -565,7 +564,6 @@ int payload_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
 					  "for this family");
 
 		stmt_len = ctx->stmt_len;
-		ctx->stmt_len = 0;
 
 		stmt = meta_stmt_meta_iiftype(&expr->location, type);
 		if (stmt_evaluate(ctx, stmt) < 0) {
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


--/IY+lOJZhZ+GdkcI--
