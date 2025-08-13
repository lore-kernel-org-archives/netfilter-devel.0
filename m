Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8102ECD34
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Aug 2025 14:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755094318; cv=none; b=rmMKaIxGmtQZTSv6BtzcV5YDeH2dGTbaZSBoKdzWqRZGe7DB61s2MxyCz9E9Yj4Aw2RGb78jIZ1ZP9eI0ibZdUxiVqU8NY1QQ7w7lMvTQ0Td/NIEowupniUYIZbY+F8ErBUeZdA7pG+AvDrUp1ByweZk67pTTl10EkvHS/DjW8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755094318; c=relaxed/simple;
	bh=h1kON0byX0G/nog8YzKhF/xJtxDd6dLhPeZdVhAWSzs=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DqyZ/uM3GmM/x1m7zqkCpdM+g8jXaHzh7pu9cPfEqiK2+ci/glx+pZ+r7anN0WIhaMnMAWio3J+oQwgwKFjfUD2mjSkgQoheh6odrO3yDW5ZmhqyOHnFnGnNWr/ZIi3p4o7cA1ntrj2QSwM30OfCd85l7OnJX/La0Y9nOHAxlqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=TW7Vyt0+; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=hBRTtgXD; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="TW7Vyt0+";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="hBRTtgXD"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 1379760702; Wed, 13 Aug 2025 16:11:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755094314;
	bh=8sOIIFPbNUQvJSUbZhuQqW9KzqnWGWhWm3CqIfMV4Lw=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=TW7Vyt0+NU7nvk2gXvPf8tGfl6sbTWmZ89YswJI6drwogM3ABwwXpHh/6+RT0//o0
	 FiG3RH8y7LlbhfxxliMeim5TfdWKhqErKFZm/tKTFICEher/JxoDYlViXcDXjuHh1e
	 LZYS/RSUcEL+z41vNAv9H7B8lpFQnH+WFLRSJcjzuZbwWfHUkrE7dD0W479O2G8u95
	 575C700DL3i+xOqqhfcHpcxWX7oRE/IAwwIsqJPoWGw4t3SqKLuBKlTJTBTlBcSLeI
	 z+YAKmzXuEghi9na/mrOSkH4foWSWohNRfoSgAvBGxPYKauMZcgjrgL962maW4opDv
	 XpreSElKRBoww==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 465BE60701
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Aug 2025 16:11:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755094313;
	bh=8sOIIFPbNUQvJSUbZhuQqW9KzqnWGWhWm3CqIfMV4Lw=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=hBRTtgXDT2uAPnOZozxCkKYKws56xeHwbhXnANf/kfvFONcoUFWY/Lt4SWnI6QvCv
	 QAASm2Lm0qk7bOOhpT1nY0MHeQSWWPs5ofnJiFJYlBgRgYJ22SE1YMI1DMiWWk6+2B
	 j4+v3SwptDw5STFYiamgUf4kUuJu6A+WTLiR1SLUvqeKRQmT4WK4aNc2FhiM2APhu7
	 JRz2xhEBbWvYdUH8WxHugO63Yb5SpyplQJLX6uvfm/ISpe/n8YnF2QsSFx3CosHrkd
	 STaYZbXlUMTjdi7539H29YvuU9v6zTuvtgbbTkd66O5YrQ55dABZALR/ZfCfET0Fv5
	 U/SWRKwZ3cXZQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 05/12] src: replace compound_expr_add() by type safe function
Date: Wed, 13 Aug 2025 16:11:37 +0200
Message-Id: <20250813141144.333784-6-pablo@netfilter.org>
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

Replace compound_expr_add() by list_expr_add() to validate type.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/expression.h      |  1 +
 src/expression.c          |  8 ++++++++
 src/netlink_delinearize.c |  2 +-
 src/parser_bison.y        | 20 ++++++++++----------
 src/parser_json.c         |  6 +++---
 src/trace.c               | 10 +++++-----
 6 files changed, 28 insertions(+), 19 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index 71a7298891cc..c2c59891a8a1 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -528,6 +528,7 @@ extern struct expr *concat_expr_alloc(const struct location *loc);
 void concat_expr_add(struct expr *concat, struct expr *item);
 
 extern struct expr *list_expr_alloc(const struct location *loc);
+void list_expr_add(struct expr *expr, struct expr *item);
 struct expr *list_expr_to_binop(struct expr *expr);
 
 extern struct expr *set_expr_alloc(const struct location *loc,
diff --git a/src/expression.c b/src/expression.c
index 106208f2b19c..22234567d2b1 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -1272,6 +1272,14 @@ struct expr *list_expr_alloc(const struct location *loc)
 	return compound_expr_alloc(loc, EXPR_LIST);
 }
 
+void list_expr_add(struct expr *expr, struct expr *item)
+{
+	struct expr_list *expr_list = expr_list(expr);
+
+	list_add_tail(&item->list, &expr_list->expressions);
+	expr_list->size++;
+}
+
 /* list is assumed to have two items at least, otherwise extend this! */
 struct expr *list_expr_to_binop(struct expr *expr)
 {
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 0822203cd350..0edf16e5bcb7 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2438,7 +2438,7 @@ static struct expr *binop_tree_to_list(struct expr *list, struct expr *expr)
 	} else {
 		if (list == NULL)
 			return expr_get(expr);
-		compound_expr_add(list, expr_get(expr));
+		list_expr_add(list, expr_get(expr));
 	}
 
 	return list;
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 778b56cfc266..3022be1ac4e7 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -2463,11 +2463,11 @@ flowtable_expr		:	'{'	flowtable_list_expr	'}'
 flowtable_list_expr	:	flowtable_expr_member
 			{
 				$$ = compound_expr_alloc(&@$, EXPR_LIST);
-				compound_expr_add($$, $1);
+				list_expr_add($$, $1);
 			}
 			|	flowtable_list_expr	COMMA	flowtable_expr_member
 			{
-				compound_expr_add($1, $3);
+				list_expr_add($1, $3);
 				$$ = $1;
 			}
 			|	flowtable_list_expr	COMMA	opt_newline
@@ -2802,14 +2802,14 @@ dev_spec		:	DEVICE	string
 					YYERROR;
 
 				$$ = compound_expr_alloc(&@$, EXPR_LIST);
-				compound_expr_add($$, expr);
+				list_expr_add($$, expr);
 
 			}
 			|	DEVICE	variable_expr
 			{
 				datatype_set($2->sym->expr, &ifname_type);
 				$$ = compound_expr_alloc(&@$, EXPR_LIST);
-				compound_expr_add($$, $2);
+				list_expr_add($$, $2);
 			}
 			|	DEVICES		'='	flowtable_expr
 			{
@@ -4976,13 +4976,13 @@ relational_expr		:	expr	/* implicit */	rhs_expr
 list_rhs_expr		:	basic_rhs_expr		COMMA		basic_rhs_expr
 			{
 				$$ = list_expr_alloc(&@$);
-				compound_expr_add($$, $1);
-				compound_expr_add($$, $3);
+				list_expr_add($$, $1);
+				list_expr_add($$, $3);
 			}
 			|	list_rhs_expr		COMMA		basic_rhs_expr
 			{
 				$1->location = @$;
-				compound_expr_add($1, $3);
+				list_expr_add($1, $3);
 				$$ = $1;
 			}
 			;
@@ -5530,13 +5530,13 @@ symbol_stmt_expr		:	symbol_expr
 list_stmt_expr		:	symbol_stmt_expr	COMMA	symbol_stmt_expr
 			{
 				$$ = list_expr_alloc(&@$);
-				compound_expr_add($$, $1);
-				compound_expr_add($$, $3);
+				list_expr_add($$, $1);
+				list_expr_add($$, $3);
 			}
 			|	list_stmt_expr	COMMA	symbol_stmt_expr
 			{
 				$1->location = @$;
-				compound_expr_add($1, $3);
+				list_expr_add($1, $3);
 				$$ = $1;
 			}
 			;
diff --git a/src/parser_json.c b/src/parser_json.c
index 2216d41563b0..17e13ebe4458 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -1686,7 +1686,7 @@ static struct expr *json_parse_expr(struct json_ctx *ctx, json_t *root)
 				expr_free(list);
 				return NULL;
 			}
-			compound_expr_add(list, expr);
+			list_expr_add(list, expr);
 		}
 		return list;
 	case JSON_TRUE:
@@ -3002,7 +3002,7 @@ static struct expr *json_parse_devs(struct json_ctx *ctx, json_t *root)
 			return NULL;
 		}
 
-		compound_expr_add(expr, tmp);
+		list_expr_add(expr, tmp);
 		return expr;
 	}
 	if (!json_is_array(root)) {
@@ -3023,7 +3023,7 @@ static struct expr *json_parse_devs(struct json_ctx *ctx, json_t *root)
 			expr_free(expr);
 			return NULL;
 		}
-		compound_expr_add(expr, tmp);
+		list_expr_add(expr, tmp);
 	}
 	return expr;
 }
diff --git a/src/trace.c b/src/trace.c
index b270951025b8..b0f26e03169b 100644
--- a/src/trace.c
+++ b/src/trace.c
@@ -267,11 +267,11 @@ static struct expr *trace_alloc_list(const struct datatype *dtype,
 		if (bitv == 0)
 			continue;
 
-		compound_expr_add(list_expr,
-				  constant_expr_alloc(&netlink_location,
-						      dtype, byteorder,
-						      len * BITS_PER_BYTE,
-						      &bitv));
+		list_expr_add(list_expr,
+			      constant_expr_alloc(&netlink_location,
+						  dtype, byteorder,
+						  len * BITS_PER_BYTE,
+						  &bitv));
 	}
 
 	mpz_clear(value);
-- 
2.30.2

