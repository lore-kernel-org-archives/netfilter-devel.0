Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 335B71459E8
	for <netfilter-devel@vger.kernel.org>; Thu, 16 May 2024 11:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715858815; cv=none; b=DQMHizZjHhP50X6sLRW5H9wenIITloSOCG7iSdWwKWIZLHIGBysCKiocCzoFCmGYsNYLUiNbih8i6dPHMOHLxCh+s6V2eFeNeu2GGt5Ysygz1LMQ+H19ri5R6FCTmaSmgeYtfpZlzkvpAFBuCC1yNsJ9rxHFzG+7CWKhXO7jF9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715858815; c=relaxed/simple;
	bh=+5CJMgz8C3oxTTNnyNN86J8chxkMDj6+QVZjXS+y2YM=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VfMRbL0IC2MRWgG/J0C9r3oNxxtjzMdcZT5nOv42+epciFKp2S4XnsSw22UbaZSRs7pqgSXxcmb7QTua++fO+WGn+szeghvHjiwuf7wvBa83/BgGb2eMoVkvfFuORQ/MrC7pEtwhueJ7VtCs3zW6WyjDMNRpPXNBr0Zt2lG+mC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/3] evaluate: bogus protocol conflicts in vlan with implicit dependencies
Date: Thu, 16 May 2024 13:26:37 +0200
Message-Id: <20240516112639.141425-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240516112639.141425-1-pablo@netfilter.org>
References: <20240516112639.141425-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The following command:

 # nft add rule netdev x y ip saddr 10.1.1.1 icmp type echo-request vlan id set 321

fails with:

Error: conflicting link layer protocols specified: ether vs. vlan
netdev x y ip saddr 10.1.1.1 icmp type echo-request vlan id set 321
                                                    ^^^^^^^

which is triggered by the follow check in resolve_ll_protocol_conflict():

       /* This payload and the existing context don't match, conflict. */
       if (pctx->protocol[base + 1].desc != NULL)
               return 1;

This check was added by 39f15c243912 ("nft: support listing expressions
that use non-byte header fields") and f7d5590688a6 ("tests: vlan tests")
to deal with vlan support to deal with conflicting link layer protocols:

	 ether type ip vlan id 1

One possibility is to removing such check, but nft does not bail out and
it results in bytecode that never matches:

 # nft --debug=netlink netdev x y ether type ip vlan id 10
 netdev x y
  [ meta load iiftype => reg 1 ]
  [ cmp eq reg 1 0x00000001 ]
  [ payload load 2b @ link header + 12 => reg 1 ] <---- ether type
  [ cmp eq reg 1 0x00000008 ]                     <---- ip
  [ payload load 2b @ link header + 12 => reg 1 ] <---- ether type
  [ cmp eq reg 1 0x00000081 ]                     <---- vlan
  [ payload load 2b @ link header + 14 => reg 1 ]
  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
  [ cmp eq reg 1 0x00000a00 ]

This is due to resolve_ll_protocol_conflict() which deals with the
conflict by updating protocol context and emitting an implicit
dependency, but there is already an explicit match coming from the user.

The workaround to make this work is to prepend an explicit match for
vlan ethertype field, that is:

	ether type vlan ip saddr 10.1.1.1 ...
        ^-------------^

This patch adds a new helper function to check if an implicit dependency
clashes with an existing statement:

	# nft add rule netdev x y ether type ip vlan id 1
        Error: conflicting statements
        add rule netdev x y ether type ip vlan id 1
                            ^^^^^^^^^^^^^ ~~~~~~~

Theoretically, no duplicated implicit dependency should ever be emitted
if protocol context is correctly handled.

Only implicit payload expression are considered at this stage, this
patch can be extended to deal with other dependency types.

Fixes: 39f15c243912 ("nft: support listing expressions that use non-byte header fields")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 69 +++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 57 insertions(+), 12 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 1682ba58989e..d624a1b5dfe6 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -775,6 +775,46 @@ static bool proto_is_dummy(const struct proto_desc *desc)
 	return desc == &proto_inet || desc == &proto_netdev;
 }
 
+static int stmt_dep_conflict(struct eval_ctx *ctx, const struct stmt *nstmt)
+{
+	struct stmt *stmt;
+
+	list_for_each_entry(stmt, &ctx->rule->stmts, list) {
+		if (stmt == nstmt)
+			break;
+
+		if (stmt->ops->type != STMT_EXPRESSION ||
+		    stmt->expr->etype != EXPR_RELATIONAL ||
+		    stmt->expr->right->etype != EXPR_VALUE ||
+		    stmt->expr->left->etype != EXPR_PAYLOAD ||
+		    stmt->expr->left->etype != nstmt->expr->left->etype ||
+		    stmt->expr->left->len != nstmt->expr->left->len)
+			continue;
+
+		if (stmt->expr->left->payload.desc != nstmt->expr->left->payload.desc ||
+		    stmt->expr->left->payload.inner_desc != nstmt->expr->left->payload.inner_desc ||
+		    stmt->expr->left->payload.base != nstmt->expr->left->payload.base ||
+		    stmt->expr->left->payload.offset != nstmt->expr->left->payload.offset)
+			continue;
+
+		return stmt_binary_error(ctx, stmt, nstmt,
+					 "conflicting statements");
+	}
+
+	return 0;
+}
+
+static int rule_stmt_dep_add(struct eval_ctx *ctx,
+			     struct stmt *nstmt, struct stmt *stmt)
+{
+	rule_stmt_insert_at(ctx->rule, nstmt, ctx->stmt);
+
+	if (stmt_dep_conflict(ctx, nstmt) < 0)
+		return -1;
+
+	return 0;
+}
+
 static int resolve_ll_protocol_conflict(struct eval_ctx *ctx,
 				        const struct proto_desc *desc,
 					struct expr *payload)
@@ -798,7 +838,8 @@ static int resolve_ll_protocol_conflict(struct eval_ctx *ctx,
 				return err;
 
 			desc = payload->payload.desc;
-			rule_stmt_insert_at(ctx->rule, nstmt, ctx->stmt);
+			if (rule_stmt_dep_add(ctx, nstmt, ctx->stmt) < 0)
+				return -1;
 		}
 	} else {
 		unsigned int i;
@@ -810,10 +851,6 @@ static int resolve_ll_protocol_conflict(struct eval_ctx *ctx,
 		}
 	}
 
-	/* This payload and the existing context don't match, conflict. */
-	if (pctx->protocol[base + 1].desc != NULL)
-		return 1;
-
 	link = proto_find_num(desc, payload->payload.desc);
 	if (link < 0 ||
 	    ll_conflict_resolution_gen_dependency(ctx, link, payload, &nstmt) < 0)
@@ -822,7 +859,8 @@ static int resolve_ll_protocol_conflict(struct eval_ctx *ctx,
 	for (i = 0; i < pctx->stacked_ll_count; i++)
 		payload->payload.offset += pctx->stacked_ll[i]->length;
 
-	rule_stmt_insert_at(ctx->rule, nstmt, ctx->stmt);
+	if (rule_stmt_dep_add(ctx, nstmt, ctx->stmt) < 0)
+		return -1;
 
 	return 0;
 }
@@ -850,7 +888,8 @@ static int __expr_evaluate_payload(struct eval_ctx *ctx, struct expr *expr)
 		if (payload_gen_dependency(ctx, payload, &nstmt) < 0)
 			return -1;
 
-		rule_stmt_insert_at(ctx->rule, nstmt, ctx->stmt);
+		if (rule_stmt_dep_add(ctx, nstmt, ctx->stmt) < 0)
+			return -1;
 
 		desc = pctx->protocol[base].desc;
 
@@ -870,7 +909,10 @@ static int __expr_evaluate_payload(struct eval_ctx *ctx, struct expr *expr)
 
 			assert(pctx->stacked_ll_count);
 			payload->payload.offset += pctx->stacked_ll[0]->length;
-			rule_stmt_insert_at(ctx->rule, nstmt, ctx->stmt);
+
+			if (rule_stmt_dep_add(ctx, nstmt, ctx->stmt) < 0)
+				return -1;
+
 			return 1;
 		}
 		goto check_icmp;
@@ -911,8 +953,8 @@ check_icmp:
 		if (payload_gen_icmp_dependency(ctx, expr, &nstmt) < 0)
 			return -1;
 
-		if (nstmt)
-			rule_stmt_insert_at(ctx->rule, nstmt, ctx->stmt);
+		if (nstmt && rule_stmt_dep_add(ctx, nstmt, ctx->stmt) < 0)
+			return -1;
 
 		return 0;
 	}
@@ -988,7 +1030,8 @@ static int expr_evaluate_inner(struct eval_ctx *ctx, struct expr **exprp)
 		if (payload_gen_inner_dependency(ctx, expr, &nstmt) < 0)
 			return -1;
 
-		rule_stmt_insert_at(ctx->rule, nstmt, ctx->stmt);
+		if (rule_stmt_dep_add(ctx, nstmt, ctx->stmt) < 0)
+			return -1;
 
 		proto_ctx_update(pctx, PROTO_BASE_TRANSPORT_HDR, &expr->location, expr->payload.inner_desc);
 	}
@@ -1119,7 +1162,9 @@ static int ct_gen_nh_dependency(struct eval_ctx *ctx, struct expr *ct)
 	relational_expr_pctx_update(pctx, dep);
 
 	nstmt = expr_stmt_alloc(&dep->location, dep);
-	rule_stmt_insert_at(ctx->rule, nstmt, ctx->stmt);
+
+	if (rule_stmt_dep_add(ctx, nstmt, ctx->stmt) < 0)
+		return -1;
 
 	return 0;
 }
-- 
2.30.2

