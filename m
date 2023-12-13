Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84850B7
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Dec 2023 09:07:05 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rDShM-0001YM-6V; Wed, 13 Dec 2023 18:07:04 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 2/3] src: do not merge a set with a erroneous one
Date: Wed, 13 Dec 2023 18:06:44 +0100
Message-ID: <20231213170650.13451-3-fw@strlen.de>
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

The included sample causes a crash because we attempt to
range-merge a prefix expression with a symbolic expression.

This happens because the first set is evaluated, the symbol
expr evaluation fails, because the symbolic name cannot be resolved.

nft queues error message
("Could not resolve service: Servname not supported for ai_socktype")
*BUT CONTINUES PROCESSING* of the remaining ruleset.

It then encounters the same set definition again and merges the
new content with the preceeding one.

But the first set structure is dodgy, it still contains the
unresolved symbolic expression.

That then makes nft crash (assert) in the set internals.

There are various different incarnations of this issue, but the low
level set processing code does not allow for any partially transformed
expressions to still remain.

After this nft will exit with an error and will print
all errors that it found during processing of the 'first' set.

After this change, the reproducer from
'intervals: BUG on prefix expressions without value' errors out
as expected without triggering asssertions.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/rule.h                                       |  2 ++
 src/evaluate.c                                       |  4 +++-
 src/intervals.c                                      |  2 +-
 .../bogons/nft-f/invalid_range_expr_type_binop       | 12 ++++++++++++
 4 files changed, 18 insertions(+), 2 deletions(-)
 create mode 100644 tests/shell/testcases/bogons/nft-f/invalid_range_expr_type_binop

diff --git a/include/rule.h b/include/rule.h
index 6236d2927c0a..40d7d50a3e4d 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -329,6 +329,7 @@ void rule_stmt_insert_at(struct rule *rule, struct stmt *nstmt,
  * @policy:	set mechanism policy
  * @automerge:	merge adjacents and overlapping elements, if possible
  * @comment:	comment
+ * @errors:	expr evaluation errors seen
  * @desc.size:		count of set elements
  * @desc.field_len:	length of single concatenated fields, bytes
  * @desc.field_count:	count of concatenated fields
@@ -353,6 +354,7 @@ struct set {
 	bool			root;
 	bool			automerge;
 	bool			key_typeof_valid;
+	bool			errors;
 	const char		*comment;
 	struct {
 		uint32_t	size;
diff --git a/src/evaluate.c b/src/evaluate.c
index 61672b0462c4..39296f8226db 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -4735,8 +4735,10 @@ static int elems_evaluate(struct eval_ctx *ctx, struct set *set)
 
 		__expr_set_context(&ctx->ectx, set->key->dtype,
 				   set->key->byteorder, set->key->len, 0);
-		if (expr_evaluate(ctx, &set->init) < 0)
+		if (expr_evaluate(ctx, &set->init) < 0) {
+			set->errors = true;
 			return -1;
+		}
 		if (set->init->etype != EXPR_SET)
 			return expr_error(ctx->msgs, set->init, "Set %s: Unexpected initial type %s, missing { }?",
 					  set->handle.set.name, expr_name(set->init));
diff --git a/src/intervals.c b/src/intervals.c
index 6849b221df2c..d0a05cde5018 100644
--- a/src/intervals.c
+++ b/src/intervals.c
@@ -130,7 +130,7 @@ static void set_sort_splice(struct expr *init, struct set *set)
 	set_to_range(init);
 	list_expr_sort(&init->expressions);
 
-	if (!existing_set)
+	if (!existing_set || existing_set->errors)
 		return;
 
 	if (existing_set->init) {
diff --git a/tests/shell/testcases/bogons/nft-f/invalid_range_expr_type_binop b/tests/shell/testcases/bogons/nft-f/invalid_range_expr_type_binop
new file mode 100644
index 000000000000..514d6ffe1319
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/invalid_range_expr_type_binop
@@ -0,0 +1,12 @@
+table ip x {
+	map z {
+		type ipv4_addr : ipv4_addr
+		elements = { 1&.141.0.1 - 192.168.0.2}
+	}
+
+	map z {
+		type ipv4_addr : ipv4_addr
+		flags interval
+		elements = { 10.141.0.0, * : 192.168.0.4 }
+	}
+}
-- 
2.41.0

