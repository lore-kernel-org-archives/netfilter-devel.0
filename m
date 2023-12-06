Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03580AC
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Dec 2023 05:07:18 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rArcS-000875-KX; Wed, 06 Dec 2023 14:07:16 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] evaluate: reset statement length context for relational expressions
Date: Wed,  6 Dec 2023 14:07:09 +0100
Message-ID: <20231206130712.19368-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

'meta mark set vlan id map { 1 : 0x00000001, 4095 : 0x00004095 }' will
crash.  Reason is that the l2 dependency generated here is errounously
expanded to a 32bit-one, so the evaluation path won't recognize this
as a L2 dependency.  Therefore, pctx->stacked_ll_count is 0 and
__expr_evaluate_payload() crashes with a null deref when
dereferencing pctx->stacked_ll[0].

Reset stmt_len in expr_evaluate_relational() to avoid
this.

nft-test.py gains a fugly hack to tolerate '!map typeof vlan id : meta mark'.
For more generic support we should find something more acceptable, e.g.

!map typeof( everything here is a key or data ) timeout ...

Fixes: 57f092a87fc4 ("evaluate: reset statement length context only for set mappings")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c                     |  3 +++
 tests/py/any/meta.t                |  4 ++++
 tests/py/any/meta.t.payload        | 26 ++++++++++++++++++++++++++
 tests/py/any/meta.t.payload.bridge | 21 +++++++++++++++++++++
 tests/py/nft-test.py               | 17 +++++++++++++----
 5 files changed, 67 insertions(+), 4 deletions(-)
 create mode 100644 tests/py/any/meta.t.payload.bridge

diff --git a/src/evaluate.c b/src/evaluate.c
index 58cc811aca9a..c5e8158b379e 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -818,6 +818,7 @@ static int __expr_evaluate_payload(struct eval_ctx *ctx, struct expr *expr)
 						  desc->name,
 						  payload->payload.desc->name);
 
+			assert(pctx->stacked_ll_count);
 			payload->payload.offset += pctx->stacked_ll[0]->length;
 			rule_stmt_insert_at(ctx->rule, nstmt, ctx->stmt);
 			return 1;
@@ -2417,6 +2418,8 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
 	struct expr *range;
 	int ret;
 
+	ctx->stmt_len = 0;
+
 	right = rel->right;
 	if (right->etype == EXPR_SYMBOL &&
 	    right->symtype == SYMBOL_SET &&
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
2.41.0

