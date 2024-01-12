Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A175D6A029
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Jan 2024 12:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rOGVc-00067d-KC; Fri, 12 Jan 2024 13:19:36 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft v3] src: do not merge a set with a erroneous one
Date: Fri, 12 Jan 2024 13:19:26 +0100
Message-ID: <20240112121930.11363-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The included sample causes a crash because we attempt to
range-merge a prefix expression with a symbolic expression.

The first set is evaluated, the symbol expression evaluation fails
and nft queues an error message ("Could not resolve hostname").

However, nft continues evaluation.

nft then encounters the same set definition again and merges the
new content with the preceeding one.

But the first set structure is dodgy, it still contains the
unresolved symbolic expression.

That then makes nft crash (assert) in the set internals.

There are various different incarnations of this issue, but the low
level set processing code does not allow for any partially transformed
expressions to still remain.

Before:
nft --check -f tests/shell/testcases/bogons/nft-f/invalid_range_expr_type_binop
BUG: invalid range expression type binop
nft: src/expression.c:1479: range_expr_value_low: Assertion `0' failed.

After:
nft --check -f tests/shell/testcases/bogons/nft-f/invalid_range_expr_type_binop
invalid_range_expr_type_binop:4:18-25: Error: Could not resolve hostname: Name or service not known
elements = { 1&.141.0.1 - 192.168.0.2}
             ^^^^^^^^

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v3: rebased on current master, bug still triggers without this change.

 include/rule.h                                       |  2 ++
 src/evaluate.c                                       |  4 +++-
 src/intervals.c                                      |  2 +-
 .../bogons/nft-f/invalid_range_expr_type_binop       | 12 ++++++++++++
 4 files changed, 18 insertions(+), 2 deletions(-)
 create mode 100644 tests/shell/testcases/bogons/nft-f/invalid_range_expr_type_binop

diff --git a/include/rule.h b/include/rule.h
index 6835fe069165..02fe2e1665e3 100644
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
index 3b3661669b30..5576b56ece67 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -4829,8 +4829,10 @@ static int elems_evaluate(struct eval_ctx *ctx, struct set *set)
 
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
index 5a88a8eb20bd..68728349e999 100644
--- a/src/intervals.c
+++ b/src/intervals.c
@@ -132,7 +132,7 @@ static void set_sort_splice(struct expr *init, struct set *set)
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

