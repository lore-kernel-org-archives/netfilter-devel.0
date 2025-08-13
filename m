Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAA3D2ECD06
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Aug 2025 14:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755094317; cv=none; b=sDFQUwrtmrhPvZyrCUCvM8DiE92fyBPsidCmtmXCnJbh2542Jv5KbtgqcoDLU7MZSxBU7347onH0VNwhT4+8KLAF7zORRe2P0N/PDJ6mrNVkDn/OVOIcRBl4Q9CVYdpDH1+Gb7OjTl2jQbP0gTv8+6fnXs7F3UQ5zdbxJLlr+0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755094317; c=relaxed/simple;
	bh=Sxaw8v2oGvjKAH4eBqUx437U4lnx6/r7RA47slXN54w=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LAEVbQKZ+R2CeYJo1SBWbHClvTSJe3fx3l5AU3kGFsDjWF3dKrRcHJCKTTOc88f+bshUdki1Ml6vvwCAb1VAhglobGre50fBdxyycJWyucmVnGEgdsiISdrUVXW+WfD+QE3C9OH85yiPyFM7H5hbygijjPnA3bMdq6o+g4sOK2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=pIHJcMMF; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=a5SJNXnF; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="pIHJcMMF";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="a5SJNXnF"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id C369E60705; Wed, 13 Aug 2025 16:11:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755094313;
	bh=EDRR4bmSIbA/7vmCZGJawumwm0pt2fmGFSjCcUx//vc=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=pIHJcMMF6wNW4gnGoY/4Izl4cYdhzVHBLamC6hT1VRzPd5ptFN1LFHUgCuX5C61iT
	 ON9QgQuoIi+3qJSaVGqTsV31XqPQhAH3zCcyEn6ksBii/ZseQsvQaJOSCra/LT2QOR
	 BdRkFW40JzemCmhfFAQ8oMdlYVjB1mSUjIizxkfZ+Rvttoet7zjJ5ESFbKMVMOi1+l
	 i5zcu2WUggifocCD5Z9iFB1CRSczAtd9SybgXsWUQlrhSJE9LWA/afinnh3IP4QA/J
	 z3CduT5aOFjt6JOgKUB0NVE6320OjoU3IiYflKryEzq9KumAQN8t5kFGeRLo/Ql50Y
	 eftp5LIILv10Q==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id CBC81606F9
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Aug 2025 16:11:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755094312;
	bh=EDRR4bmSIbA/7vmCZGJawumwm0pt2fmGFSjCcUx//vc=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=a5SJNXnFNa336tVmFs7nyIvEPTXz4JRpO7VbWRPASk9At/op0mXH4DxDWNdOJNVAa
	 HyeIvbqfisOQVX9SzuuzoiJgpKmjhVAGTMzIzQ/GSiFOFSOuXrMvrJXLAj6801Z2oL
	 4P+9ZwuSTYBfIFtfm4Mb/bUAP4KzaR/wvT5sXw5qD5lZ/trL1ZtLuUZ/Me+lGBQL/p
	 5HN4wsFJxddC8Q8pju0uJMqUW+0D7asM4Ya5A+a4Gx/xcadkhrljKl6neYZW2WAzba
	 p16jlN+4oZb6d2EG8pUFw2k2aSqGSp89QEgQvU87CPOwO36WFPcMlMID+TuuQACQlW
	 Hz1N5uIHQRkZg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 04/12] src: replace compound_expr_add() by type safe function
Date: Wed, 13 Aug 2025 16:11:36 +0200
Message-Id: <20250813141144.333784-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250813141144.333784-1-pablo@netfilter.org>
References: <20250813141144.333784-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace compound_expr_add by concat_expr_add() to validate type.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/expression.h      |  1 +
 src/expression.c          | 10 +++++++++-
 src/netlink.c             |  4 ++--
 src/netlink_delinearize.c |  6 +++---
 src/optimize.c            | 18 +++++++++---------
 src/parser_bison.y        |  4 ++--
 src/parser_json.c         |  6 +++---
 7 files changed, 29 insertions(+), 20 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index 21be74068468..71a7298891cc 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -525,6 +525,7 @@ extern void list_expr_sort(struct list_head *head);
 extern void list_splice_sorted(struct list_head *list, struct list_head *head);
 
 extern struct expr *concat_expr_alloc(const struct location *loc);
+void concat_expr_add(struct expr *concat, struct expr *item);
 
 extern struct expr *list_expr_alloc(const struct location *loc);
 struct expr *list_expr_to_binop(struct expr *expr);
diff --git a/src/expression.c b/src/expression.c
index 32e101ea9070..106208f2b19c 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -1211,7 +1211,7 @@ static struct expr *concat_expr_parse_udata(const struct nftnl_udata *attr)
 			goto err_free;
 
 		dt = concat_subtype_add(dt, expr->dtype->type);
-		compound_expr_add(concat_expr, expr);
+		concat_expr_add(concat_expr, expr);
 		len += netlink_padded_len(expr->len);
 	}
 
@@ -1245,6 +1245,14 @@ struct expr *concat_expr_alloc(const struct location *loc)
 	return compound_expr_alloc(loc, EXPR_CONCAT);
 }
 
+void concat_expr_add(struct expr *concat, struct expr *item)
+{
+	struct expr_concat *expr_concat = expr_concat(concat);
+
+	list_add_tail(&item->list, &expr_concat->expressions);
+	expr_concat->size++;
+}
+
 static void list_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
 	compound_expr_print(expr, ",", octx);
diff --git a/src/netlink.c b/src/netlink.c
index a5989def7d06..51c2f94a72f9 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1365,7 +1365,7 @@ static struct expr *netlink_parse_concat_elem_key(const struct set *set,
 	concat = concat_expr_alloc(&data->location);
 	while (off > 0) {
 		expr = concat_elem_expr(set, n, dtype, data, &off);
-		compound_expr_add(concat, expr);
+		concat_expr_add(concat, expr);
 		if (set->key->etype == EXPR_CONCAT)
 			n = list_next_entry(n, list);
 	}
@@ -1404,7 +1404,7 @@ static struct expr *netlink_parse_concat_elem(const struct set *set,
 
 			range = range_expr_alloc(&data->location, left, expr);
 			range = range_expr_reduce(range);
-			compound_expr_add(concat, range);
+			concat_expr_add(concat, range);
 		}
 		assert(list_empty(&expressions));
 	} else {
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index b4d4a3da3b37..0822203cd350 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -128,7 +128,7 @@ static struct expr *netlink_parse_concat_expr(struct netlink_parse_ctx *ctx,
 				      "Relational expression size mismatch");
 			goto err;
 		}
-		compound_expr_add(concat, expr);
+		concat_expr_add(concat, expr);
 
 		consumed = netlink_padded_len(expr->len);
 		assert(consumed > 0);
@@ -171,7 +171,7 @@ static struct expr *netlink_parse_concat_key(struct netlink_parse_ctx *ctx,
 			expr_set_type(expr, i, i->byteorder);
 		}
 
-		compound_expr_add(concat, expr);
+		concat_expr_add(concat, expr);
 
 		consumed = netlink_padded_len(expr->len);
 		assert(consumed > 0);
@@ -204,7 +204,7 @@ static struct expr *netlink_parse_concat_data(struct netlink_parse_ctx *ctx,
 		}
 		i = constant_expr_splice(data, expr->len);
 		data->len -= netlink_padding_len(expr->len);
-		compound_expr_add(concat, i);
+		concat_expr_add(concat, i);
 
 		len -= netlink_padded_len(expr->len);
 		reg += netlink_register_space(expr->len);
diff --git a/src/optimize.c b/src/optimize.c
index b2fd9e829f00..cdd6913a306d 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -657,7 +657,7 @@ static void __merge_concat(const struct optimize_ctx *ctx, uint32_t i,
 				list_for_each_entry(expr, &expr_set(stmt_a->expr->right)->expressions, list) {
 					concat_clone = expr_clone(concat);
 					clone = expr_clone(expr->key);
-					compound_expr_add(concat_clone, clone);
+					concat_expr_add(concat_clone, clone);
 					list_add_tail(&concat_clone->list, &pending_list);
 				}
 				list_del(&concat->list);
@@ -670,13 +670,13 @@ static void __merge_concat(const struct optimize_ctx *ctx, uint32_t i,
 			case EXPR_RANGE:
 			case EXPR_RANGE_VALUE:
 				clone = expr_clone(stmt_a->expr->right);
-				compound_expr_add(concat, clone);
+				concat_expr_add(concat, clone);
 				break;
 			case EXPR_LIST:
 				list_for_each_entry(expr, &expr_list(stmt_a->expr->right)->expressions, list) {
 					concat_clone = expr_clone(concat);
 					clone = expr_clone(expr);
-					compound_expr_add(concat_clone, clone);
+					concat_expr_add(concat_clone, clone);
 					list_add_tail(&concat_clone->list, &pending_list);
 				}
 				list_del(&concat->list);
@@ -720,7 +720,7 @@ static void merge_concat_stmts(const struct optimize_ctx *ctx,
 
 	for (k = 0; k < merge->num_stmts; k++) {
 		stmt_a = ctx->stmt_matrix[from][merge->stmt[k]];
-		compound_expr_add(concat, expr_get(stmt_a->expr->left));
+		concat_expr_add(concat, expr_get(stmt_a->expr->left));
 	}
 	expr_free(stmt->expr->left);
 	stmt->expr->left = concat;
@@ -920,7 +920,7 @@ static void merge_concat_stmts_vmap(const struct optimize_ctx *ctx,
 	concat_a = concat_expr_alloc(&internal_location);
 	for (i = 0; i < merge->num_stmts; i++) {
 		stmt_a = ctx->stmt_matrix[from][merge->stmt[i]];
-		compound_expr_add(concat_a, expr_get(stmt_a->expr->left));
+		concat_expr_add(concat_a, expr_get(stmt_a->expr->left));
 	}
 
 	/* build set data contenation, eg. { eth0 . 1.1.1.1 . 22 : accept } */
@@ -1021,8 +1021,8 @@ static struct expr *stmt_nat_expr(struct stmt *nat_stmt)
 	if (nat_stmt->nat.proto) {
 		if (nat_stmt->nat.addr) {
 			nat_expr = concat_expr_alloc(&internal_location);
-			compound_expr_add(nat_expr, expr_get(nat_stmt->nat.addr));
-			compound_expr_add(nat_expr, expr_get(nat_stmt->nat.proto));
+			concat_expr_add(nat_expr, expr_get(nat_stmt->nat.addr));
+			concat_expr_add(nat_expr, expr_get(nat_stmt->nat.proto));
 		} else {
 			nat_expr = expr_get(nat_stmt->nat.proto);
 		}
@@ -1110,7 +1110,7 @@ static void merge_concat_nat(const struct optimize_ctx *ctx,
 		for (j = 0; j < merge->num_stmts; j++) {
 			stmt = ctx->stmt_matrix[i][merge->stmt[j]];
 			expr = stmt->expr->right;
-			compound_expr_add(concat, expr_get(expr));
+			concat_expr_add(concat, expr_get(expr));
 		}
 
 		nat_stmt = ctx->stmt_matrix[i][k];
@@ -1131,7 +1131,7 @@ static void merge_concat_nat(const struct optimize_ctx *ctx,
 			else if (left->payload.desc == &proto_ip6)
 				family = NFPROTO_IPV6;
 		}
-		compound_expr_add(concat, expr_get(left));
+		concat_expr_add(concat, expr_get(left));
 	}
 	expr = map_expr_alloc(&internal_location, concat, set);
 
diff --git a/src/parser_bison.y b/src/parser_bison.y
index cb9bf9711b55..778b56cfc266 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -121,7 +121,7 @@ static struct expr *handle_concat_expr(const struct location *loc,
 {
 	if (expr->etype != EXPR_CONCAT) {
 		expr = concat_expr_alloc(loc);
-		compound_expr_add(expr, expr_l);
+		concat_expr_add(expr, expr_l);
 	} else {
 		location_update(&expr_r->location, loc_rhs, 2);
 
@@ -129,7 +129,7 @@ static struct expr *handle_concat_expr(const struct location *loc,
 		expr->location = *loc;
 	}
 
-	compound_expr_add(expr, expr_r);
+	concat_expr_add(expr, expr_r);
 	return expr;
 }
 
diff --git a/src/parser_json.c b/src/parser_json.c
index 1a37246ef7f6..2216d41563b0 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -1330,10 +1330,10 @@ static struct expr *json_parse_concat_expr(struct json_ctx *ctx,
 			struct expr *concat;
 
 			concat = concat_expr_alloc(int_loc);
-			compound_expr_add(concat, expr);
+			concat_expr_add(concat, expr);
 			expr = concat;
 		}
-		compound_expr_add(expr, tmp);
+		concat_expr_add(expr, tmp);
 	}
 	return expr ? json_check_concat_expr(ctx, expr) : NULL;
 }
@@ -1806,7 +1806,7 @@ static struct expr *json_parse_dtype_expr(struct json_ctx *ctx, json_t *root)
 				expr_free(expr);
 				return NULL;
 			}
-			compound_expr_add(expr, i);
+			concat_expr_add(expr, i);
 		}
 
 		return json_check_concat_expr(ctx, expr);
-- 
2.30.2

