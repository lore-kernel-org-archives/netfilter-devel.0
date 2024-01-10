Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C2133E478
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Jan 2024 08:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rNTvc-0006qP-Ah; Wed, 10 Jan 2024 09:27:12 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nft 2/3] src: do not merge a set with a erroneous one
Date: Wed, 10 Jan 2024 09:26:53 +0100
Message-ID: <20240110082657.1967-3-fw@strlen.de>
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
 include/rule.h                                       |  2 ++
 src/evaluate.c                                       |  4 +++-
 src/intervals.c                                      |  3 +++
 .../bogons/nft-f/invalid_range_expr_type_binop       | 12 ++++++++++++
 4 files changed, 20 insertions(+), 1 deletion(-)
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
index eac9267a0107..4e9a95ad4c9d 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -4800,8 +4800,10 @@ static int elems_evaluate(struct eval_ctx *ctx, struct set *set)
 
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
index ea39dbb80665..85b44d105402 100644
--- a/src/intervals.c
+++ b/src/intervals.c
@@ -142,6 +142,9 @@ static int set_sort_splice(struct list_head *msgs,
 	if (!existing_set)
 		return 0;
 
+	if (existing_set->errors)
+		return -1;
+
 	if (existing_set->init) {
 		err = set_to_range(msgs, existing_set->init);
 		if (err)
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

