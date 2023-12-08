Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F043C121
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Dec 2023 10:41:51 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rBfnK-0000uJ-KZ; Fri, 08 Dec 2023 19:41:50 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nft] parser_bison: fix objref statement corruption
Date: Fri,  8 Dec 2023 19:41:39 +0100
Message-ID: <20231208184143.21593-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Consider this:

counter_stmt            :       counter_stmt_alloc
                        |       counter_stmt_alloc      counter_args

counter_stmt_alloc      :       COUNTER { $$ = counter_stmt_alloc(&@$); }
                        |       COUNTER         NAME    stmt_expr
                        {
                                $$ = objref_stmt_alloc(&@$);
                                $$->objref.type = NFT_OBJECT_COUNTER;
                                $$->objref.expr = $3;
                        }
                        ;

counter_args            :       counter_arg { $<stmt>$        = $<stmt>0; }
                        |       counter_args    counter_arg
                        ;

counter_arg             :       PACKETS NUM { $<stmt>0->counter.packets = $2; }

[..]

This has 'counter_stmt_alloc' EITHER return counter or objref statement.
Both are the same structure but with different (union'd) trailer content.

counter_stmt permits the 'packet' and 'byte' argument.

But the 'counter_arg' directive only works with a statement
coming from counter_stmt_alloc().

afl++ came up with following input:

table inet x {
        chain y {
                counter name ip saddr bytes 1.1.1. 1024
        }
}

This clobbers $<stmt>->objref.expr pointer, we then crash when
calling expr_evaluate() on it.

Split the objref related statements into their own directive.

After this, the input will fail with:
"syntax error, unexpected bytes, expecting newline or semicolon".

Also split most of the other objref statements into their own blocks.
synproxy seems to have same problem, limit and quota appeared to be ok.

v1 added objref_stmt to stateful_stmt list, this is wrong, we will
assert when generating the 'counter' statement.
Place it in the normal statement list so netlink_gen_stmt_stateful_assert
throws the expected parser error.

Fixes: dccab4f646b4 ("parser_bison: consolidate stmt_expr rule")
Signed-off-by: Florian Westphal <fw@strlen.de>
---

src/parser_bison.y                            | 97 ++++++++++++-------
 .../bogons/nft-f/counter_objref_crash         |  5 +
 .../nft-f/netlink_gen_stmt_stateful_assert    |  6 ++
 3 files changed, 71 insertions(+), 37 deletions(-)
 create mode 100644 tests/shell/testcases/bogons/nft-f/counter_objref_crash
 create mode 100644 tests/shell/testcases/bogons/nft-f/netlink_gen_stmt_stateful_assert

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 1a3d64f794cb..64946a43f93e 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -744,6 +744,9 @@ int nft_lex(void *, void *, void *);
 %destructor { stmt_free($$); }	stmt match_stmt verdict_stmt set_elem_stmt
 %type <stmt>			counter_stmt counter_stmt_alloc stateful_stmt last_stmt
 %destructor { stmt_free($$); }	counter_stmt counter_stmt_alloc stateful_stmt last_stmt
+%type <stmt>			objref_stmt objref_stmt_counter objref_stmt_limit objref_stmt_quota objref_stmt_ct objref_stmt_synproxy
+%destructor { stmt_free($$); }	objref_stmt objref_stmt_counter objref_stmt_limit objref_stmt_quota objref_stmt_ct objref_stmt_synproxy
+
 %type <stmt>			payload_stmt
 %destructor { stmt_free($$); }	payload_stmt
 %type <stmt>			ct_stmt
@@ -3051,6 +3054,60 @@ stateful_stmt_list	:	stateful_stmt
 			}
 			;
 
+objref_stmt_counter	:	COUNTER		NAME	stmt_expr	close_scope_counter
+			{
+				$$ = objref_stmt_alloc(&@$);
+				$$->objref.type = NFT_OBJECT_COUNTER;
+				$$->objref.expr = $3;
+			}
+			;
+
+objref_stmt_limit	: 	LIMIT	NAME	stmt_expr	close_scope_limit
+			{
+				$$ = objref_stmt_alloc(&@$);
+				$$->objref.type = NFT_OBJECT_LIMIT;
+				$$->objref.expr = $3;
+			}
+			;
+
+objref_stmt_quota	:	QUOTA	NAME	stmt_expr	close_scope_quota
+			{
+				$$ = objref_stmt_alloc(&@$);
+				$$->objref.type = NFT_OBJECT_QUOTA;
+				$$->objref.expr = $3;
+			}
+			;
+
+objref_stmt_synproxy	: 	SYNPROXY	NAME	stmt_expr close_scope_synproxy
+			{
+				$$ = objref_stmt_alloc(&@$);
+				$$->objref.type = NFT_OBJECT_SYNPROXY;
+				$$->objref.expr = $3;
+			}
+			;
+
+objref_stmt_ct		:	CT	TIMEOUT		SET	stmt_expr	close_scope_ct
+			{
+				$$ = objref_stmt_alloc(&@$);
+				$$->objref.type = NFT_OBJECT_CT_TIMEOUT;
+				$$->objref.expr = $4;
+
+			}
+			|	CT	EXPECTATION	SET	stmt_expr	close_scope_ct
+			{
+				$$ = objref_stmt_alloc(&@$);
+				$$->objref.type = NFT_OBJECT_CT_EXPECT;
+				$$->objref.expr = $4;
+			}
+			;
+
+objref_stmt		:	objref_stmt_counter
+			|	objref_stmt_limit
+			|	objref_stmt_quota
+			|	objref_stmt_synproxy
+			|	objref_stmt_ct
+			;
+
 stateful_stmt		:	counter_stmt	close_scope_counter
 			|	limit_stmt
 			|	quota_stmt
@@ -3080,6 +3137,7 @@ stmt			:	verdict_stmt
 			|	chain_stmt
 			|	optstrip_stmt
 			|	xt_stmt		close_scope_xt
+			|	objref_stmt
 			;
 
 xt_stmt			:	XT	STRING	string
@@ -3169,12 +3227,6 @@ counter_stmt_alloc	:	COUNTER
 			{
 				$$ = counter_stmt_alloc(&@$);
 			}
-			|	COUNTER		NAME	stmt_expr
-			{
-				$$ = objref_stmt_alloc(&@$);
-				$$->objref.type = NFT_OBJECT_COUNTER;
-				$$->objref.expr = $3;
-			}
 			;
 
 counter_args		:	counter_arg
@@ -3186,10 +3238,12 @@ counter_args		:	counter_arg
 
 counter_arg		:	PACKETS			NUM
 			{
+				assert($<stmt>0->ops->type == STMT_COUNTER);
 				$<stmt>0->counter.packets = $2;
 			}
 			|	BYTES			NUM
 			{
+				assert($<stmt>0->ops->type == STMT_COUNTER);
 				$<stmt>0->counter.bytes	 = $2;
 			}
 			;
@@ -3470,12 +3524,6 @@ limit_stmt		:	LIMIT	RATE	limit_mode	limit_rate_pkts	limit_burst_pkts	close_scope
 				$$->limit.type	= NFT_LIMIT_PKT_BYTES;
 				$$->limit.flags = $3;
 			}
-			|	LIMIT	NAME	stmt_expr	close_scope_limit
-			{
-				$$ = objref_stmt_alloc(&@$);
-				$$->objref.type = NFT_OBJECT_LIMIT;
-				$$->objref.expr = $3;
-			}
 			;
 
 quota_mode		:	OVER		{ $$ = NFT_QUOTA_F_INV; }
@@ -3519,12 +3567,6 @@ quota_stmt		:	QUOTA	quota_mode NUM quota_unit quota_used	close_scope_quota
 				$$->quota.used = $5;
 				$$->quota.flags	= $2;
 			}
-			|	QUOTA	NAME	stmt_expr	close_scope_quota
-			{
-				$$ = objref_stmt_alloc(&@$);
-				$$->objref.type = NFT_OBJECT_QUOTA;
-				$$->objref.expr = $3;
-			}
 			;
 
 limit_mode		:	OVER				{ $$ = NFT_LIMIT_F_INV; }
@@ -3715,12 +3757,6 @@ synproxy_stmt_alloc	:	SYNPROXY
 			{
 				$$ = synproxy_stmt_alloc(&@$);
 			}
-			|	SYNPROXY	NAME	stmt_expr
-			{
-				$$ = objref_stmt_alloc(&@$);
-				$$->objref.type = NFT_OBJECT_SYNPROXY;
-				$$->objref.expr = $3;
-			}
 			;
 
 synproxy_args		:	synproxy_arg
@@ -5533,19 +5569,6 @@ ct_stmt			:	CT	ct_key		SET	stmt_expr	close_scope_ct
 					break;
 				}
 			}
-			|	CT	TIMEOUT		SET	stmt_expr	close_scope_ct
-			{
-				$$ = objref_stmt_alloc(&@$);
-				$$->objref.type = NFT_OBJECT_CT_TIMEOUT;
-				$$->objref.expr = $4;
-
-			}
-			|	CT	EXPECTATION	SET	stmt_expr	close_scope_ct
-			{
-				$$ = objref_stmt_alloc(&@$);
-				$$->objref.type = NFT_OBJECT_CT_EXPECT;
-				$$->objref.expr = $4;
-			}
 			|	CT	ct_dir	ct_key_dir_optional SET	stmt_expr	close_scope_ct
 			{
 				$$ = ct_stmt_alloc(&@$, $3, $2, $5);
diff --git a/tests/shell/testcases/bogons/nft-f/counter_objref_crash b/tests/shell/testcases/bogons/nft-f/counter_objref_crash
new file mode 100644
index 000000000000..3a4b981be63c
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/counter_objref_crash
@@ -0,0 +1,5 @@
+table inet x {
+        chain y {
+                counter name ip saddr bytes 1.1.1. 1024
+        }
+}
diff --git a/tests/shell/testcases/bogons/nft-f/netlink_gen_stmt_stateful_assert b/tests/shell/testcases/bogons/nft-f/netlink_gen_stmt_stateful_assert
new file mode 100644
index 000000000000..547b937f1459
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/netlink_gen_stmt_stateful_assert
@@ -0,0 +1,6 @@
+table ip x {
+	map sctm_o1 {
+		type mark : counter
+		counter name meta mark
+	}
+}
-- 
2.41.0

