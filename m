Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB581BF20
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Jan 2024 14:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rPkJQ-0004wq-73; Tue, 16 Jan 2024 15:21:08 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] evaluate: don't assert on net/transport header conflict
Date: Tue, 16 Jan 2024 15:21:00 +0100
Message-ID: <20240116142103.20569-1-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

before:
nft: evaluate.c:467: conflict_resolution_gen_dependency: Assertion `expr->payload.base == PROTO_BASE_LL_HDR' failed.
Aborted (core dumped)

conflict_resolution_gen_dependency() can only handle linklayer
conflicts, hence the assert.

Rename it accordingly.  Also rename resolve_protocol_conflict, it doesn't
do anything for != PROTO_BASE_LL_HDR and extend the assertion to that
function too.

Callers now enforce PROTO_BASE_LL_HDR prerequisite.

after:
Error: conflicting transport layer protocols specified: comp vs. udp
 ip6 nexthdr comp udp dport 4789
                  ^^^^^^^^^

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c                                | 69 +++++++++----------
 ...solution_gen_dependency_base_ll_hdr_assert |  5 ++
 2 files changed, 38 insertions(+), 36 deletions(-)
 create mode 100644 tests/shell/testcases/bogons/nft-f/evaluate_conflict_resolution_gen_dependency_base_ll_hdr_assert

diff --git a/src/evaluate.c b/src/evaluate.c
index 1adec037b04b..5a25916506fc 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -499,9 +499,9 @@ int stmt_dependency_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
 }
 
 static int
-conflict_resolution_gen_dependency(struct eval_ctx *ctx, int protocol,
-				   const struct expr *expr,
-				   struct stmt **res)
+ll_conflict_resolution_gen_dependency(struct eval_ctx *ctx, int protocol,
+				      const struct expr *expr,
+				      struct stmt **res)
 {
 	enum proto_bases base = expr->payload.base;
 	const struct proto_hdr_template *tmpl;
@@ -764,56 +764,52 @@ static bool proto_is_dummy(const struct proto_desc *desc)
 	return desc == &proto_inet || desc == &proto_netdev;
 }
 
-static int resolve_protocol_conflict(struct eval_ctx *ctx,
-				     const struct proto_desc *desc,
-				     struct expr *payload)
+static int resolve_ll_protocol_conflict(struct eval_ctx *ctx,
+				        const struct proto_desc *desc,
+					struct expr *payload)
 {
 	enum proto_bases base = payload->payload.base;
 	struct stmt *nstmt = NULL;
 	struct proto_ctx *pctx;
+	unsigned int i;
 	int link, err;
 
+	assert(base == PROTO_BASE_LL_HDR);
+
 	pctx = eval_proto_ctx(ctx);
 
-	if (payload->payload.base == PROTO_BASE_LL_HDR) {
-		if (proto_is_dummy(desc)) {
-			if (ctx->inner_desc) {
-		                proto_ctx_update(pctx, PROTO_BASE_LL_HDR, &payload->location, &proto_eth);
-			} else {
-				err = meta_iiftype_gen_dependency(ctx, payload, &nstmt);
-				if (err < 0)
-					return err;
-
-				desc = payload->payload.desc;
-				rule_stmt_insert_at(ctx->rule, nstmt, ctx->stmt);
-			}
+	if (proto_is_dummy(desc)) {
+		if (ctx->inner_desc) {
+	                proto_ctx_update(pctx, PROTO_BASE_LL_HDR, &payload->location, &proto_eth);
 		} else {
-			unsigned int i;
+			err = meta_iiftype_gen_dependency(ctx, payload, &nstmt);
+			if (err < 0)
+				return err;
 
-			/* payload desc stored in the L2 header stack? No conflict. */
-			for (i = 0; i < pctx->stacked_ll_count; i++) {
-				if (pctx->stacked_ll[i] == payload->payload.desc)
-					return 0;
-			}
+			desc = payload->payload.desc;
+			rule_stmt_insert_at(ctx->rule, nstmt, ctx->stmt);
+		}
+	} else {
+		unsigned int i;
+
+		/* payload desc stored in the L2 header stack? No conflict. */
+		for (i = 0; i < pctx->stacked_ll_count; i++) {
+			if (pctx->stacked_ll[i] == payload->payload.desc)
+				return 0;
 		}
 	}
 
-	assert(base <= PROTO_BASE_MAX);
 	/* This payload and the existing context don't match, conflict. */
 	if (pctx->protocol[base + 1].desc != NULL)
 		return 1;
 
 	link = proto_find_num(desc, payload->payload.desc);
 	if (link < 0 ||
-	    conflict_resolution_gen_dependency(ctx, link, payload, &nstmt) < 0)
+	    ll_conflict_resolution_gen_dependency(ctx, link, payload, &nstmt) < 0)
 		return 1;
 
-	if (base == PROTO_BASE_LL_HDR) {
-		unsigned int i;
-
-		for (i = 0; i < pctx->stacked_ll_count; i++)
-			payload->payload.offset += pctx->stacked_ll[i]->length;
-	}
+	for (i = 0; i < pctx->stacked_ll_count; i++)
+		payload->payload.offset += pctx->stacked_ll[i]->length;
 
 	rule_stmt_insert_at(ctx->rule, nstmt, ctx->stmt);
 
@@ -855,7 +851,7 @@ static int __expr_evaluate_payload(struct eval_ctx *ctx, struct expr *expr)
 
 			link = proto_find_num(desc, payload->payload.desc);
 			if (link < 0 ||
-			    conflict_resolution_gen_dependency(ctx, link, payload, &nstmt) < 0)
+			    ll_conflict_resolution_gen_dependency(ctx, link, payload, &nstmt) < 0)
 				return expr_error(ctx->msgs, payload,
 						  "conflicting protocols specified: %s vs. %s",
 						  desc->name,
@@ -912,8 +908,8 @@ check_icmp:
 	/* If we already have context and this payload is on the same
 	 * base, try to resolve the protocol conflict.
 	 */
-	if (payload->payload.base == desc->base) {
-		err = resolve_protocol_conflict(ctx, desc, payload);
+	if (base == PROTO_BASE_LL_HDR) {
+		err = resolve_ll_protocol_conflict(ctx, desc, payload);
 		if (err <= 0)
 			return err;
 
@@ -922,7 +918,8 @@ check_icmp:
 			return 0;
 	}
 	return expr_error(ctx->msgs, payload,
-			  "conflicting protocols specified: %s vs. %s",
+			  "conflicting %s protocols specified: %s vs. %s",
+			  proto_base_names[base],
 			  pctx->protocol[base].desc->name,
 			  payload->payload.desc->name);
 }
diff --git a/tests/shell/testcases/bogons/nft-f/evaluate_conflict_resolution_gen_dependency_base_ll_hdr_assert b/tests/shell/testcases/bogons/nft-f/evaluate_conflict_resolution_gen_dependency_base_ll_hdr_assert
new file mode 100644
index 000000000000..43d72c4d97e5
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/evaluate_conflict_resolution_gen_dependency_base_ll_hdr_assert
@@ -0,0 +1,5 @@
+table ip6 t {
+	chain c {
+		ip6 nexthdr comp udp dport 4789
+	}
+}
-- 
2.43.0

