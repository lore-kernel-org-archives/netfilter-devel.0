Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C6D92F5318
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Aug 2025 09:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755768229; cv=none; b=X2pRZDHMIP8qG0NEC/vdM/T1GwAe/hW2kjAKpCeA/PCwAec5oT2g+mut79g91REGGVsBELGNckP7mBDZZ9AvLux3yTBD/Q3qRftZqr5+AgTiXW3cH0eEW6gsT5OfGzf5YLWDTpOLdoRae3SnKTZR9fQt4lbd2aU6UM4Pw46FLGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755768229; c=relaxed/simple;
	bh=fCvyWfXjslqzLeY7mfQAxOlrhrk6Bt6X2tkAFXgH39Y=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Js4w/OgC4MBQ01D9NGUjpXnzgbrFFXZYIpmhqUXP10NL100UWzhr5S9rPFL8UsfbuV7XgzPOPgyA6JeDzZ8KPqofGNXtBksOUDSXDlyoHS2qRVVtZ39N9QwT6lcscCuLqHrbF+WiaXrZyS7HMy8KRj0d1OoO8rw/wj7f88LZRe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=d9XMQVdx; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=d9XMQVdx; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="d9XMQVdx";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="d9XMQVdx"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id CF345602AE; Thu, 21 Aug 2025 11:23:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755768225;
	bh=ojue7r2oe+aUGK2s3fB/fucoIQy4RFKB0c9CCABIu4Y=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=d9XMQVdxV6yXqgB+T+GHHIBUgLziEnYXYzctzMp0I2vgTqWWMQuyRAGc6yVlGlv+r
	 /S1jaZ9Tlvfk3zRUsowCLLcd98TF3eQVjyutIVgHHrt6vWIrPN/iI1oXvVxtdQD9ia
	 8okmUi/gNufA0zYl0RGcDF3FKxBJ1j/1o/L5fOx+Pk6VXf8Y5m02xkJZmC1QkXOfw7
	 2TFAeMY+em6BAVfyZB04CUkeF6RF9VNLw3X4QQAGcvYjQ43O3CnlrGRuiRS8guCvq/
	 DJ5GnLP7HXoECp63jKS0vPqYIX7keVusUr5r5Jza93T63vTeyoVa+vJ//GMLLJ907N
	 OmcVDx+3lg8NQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 0973B602AB
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Aug 2025 11:23:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755768225;
	bh=ojue7r2oe+aUGK2s3fB/fucoIQy4RFKB0c9CCABIu4Y=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=d9XMQVdxV6yXqgB+T+GHHIBUgLziEnYXYzctzMp0I2vgTqWWMQuyRAGc6yVlGlv+r
	 /S1jaZ9Tlvfk3zRUsowCLLcd98TF3eQVjyutIVgHHrt6vWIrPN/iI1oXvVxtdQD9ia
	 8okmUi/gNufA0zYl0RGcDF3FKxBJ1j/1o/L5fOx+Pk6VXf8Y5m02xkJZmC1QkXOfw7
	 2TFAeMY+em6BAVfyZB04CUkeF6RF9VNLw3X4QQAGcvYjQ43O3CnlrGRuiRS8guCvq/
	 DJ5GnLP7HXoECp63jKS0vPqYIX7keVusUr5r5Jza93T63vTeyoVa+vJ//GMLLJ907N
	 OmcVDx+3lg8NQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2 11/11] src: replace compound_expr_alloc() by type safe function
Date: Thu, 21 Aug 2025 11:23:30 +0200
Message-Id: <20250821092330.2739989-12-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250821092330.2739989-1-pablo@netfilter.org>
References: <20250821092330.2739989-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace compound_expr_alloc() by {set,list,concat}_expr_alloc() to
validate expression type.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/expression.h |  2 --
 src/evaluate.c       |  2 +-
 src/expression.c     | 30 ++++++++++++++++--------------
 src/parser_bison.y   |  8 ++++----
 src/parser_json.c    |  2 +-
 5 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index 198ead603da6..650063bd0e9e 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -517,8 +517,6 @@ extern struct expr *range_expr_alloc(const struct location *loc,
 				     struct expr *low, struct expr *high);
 struct expr *range_expr_to_prefix(struct expr *range);
 
-extern struct expr *compound_expr_alloc(const struct location *loc,
-					enum expr_types etypes);
 extern void list_expr_sort(struct list_head *head);
 extern void list_splice_sorted(struct list_head *list, struct list_head *head);
 
diff --git a/src/evaluate.c b/src/evaluate.c
index fc9177d3a91e..f4420866bf22 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -5475,7 +5475,7 @@ static struct expr *expr_set_to_list(struct eval_ctx *ctx, struct expr *dev_expr
 
 	loc = dev_expr->location;
 	expr_free(dev_expr);
-	dev_expr = compound_expr_alloc(&loc, EXPR_LIST);
+	dev_expr = list_expr_alloc(&loc);
 	list_splice_init(&tmp, &expr_list(dev_expr)->expressions);
 
 	return dev_expr;
diff --git a/src/expression.c b/src/expression.c
index c0ab5d5598f2..c0d644249a71 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -1016,17 +1016,6 @@ struct expr *range_expr_alloc(const struct location *loc,
 	return expr;
 }
 
-struct expr *compound_expr_alloc(const struct location *loc,
-				 enum expr_types etype)
-{
-	struct expr *expr;
-
-	expr = expr_alloc(loc, etype, &invalid_type, BYTEORDER_INVALID, 0);
-	/* same layout for EXPR_CONCAT, EXPR_SET and EXPR_LIST. */
-	init_list_head(&expr->expr_set.expressions);
-	return expr;
-}
-
 static void concat_expr_destroy(struct expr *expr)
 {
 	struct expr *i, *next;
@@ -1219,7 +1208,12 @@ static const struct expr_ops concat_expr_ops = {
 
 struct expr *concat_expr_alloc(const struct location *loc)
 {
-	return compound_expr_alloc(loc, EXPR_CONCAT);
+	struct expr *expr;
+
+	expr = expr_alloc(loc, EXPR_CONCAT, &invalid_type, BYTEORDER_INVALID, 0);
+	init_list_head(&expr_concat(expr)->expressions);
+
+	return expr;
 }
 
 void concat_expr_add(struct expr *concat, struct expr *item)
@@ -1276,7 +1270,12 @@ static const struct expr_ops list_expr_ops = {
 
 struct expr *list_expr_alloc(const struct location *loc)
 {
-	return compound_expr_alloc(loc, EXPR_LIST);
+	struct expr *expr;
+
+	expr = expr_alloc(loc, EXPR_LIST, &invalid_type, BYTEORDER_INVALID, 0);
+	init_list_head(&expr_list(expr)->expressions);
+
+	return expr;
 }
 
 void list_expr_add(struct expr *expr, struct expr *item)
@@ -1427,7 +1426,10 @@ static const struct expr_ops set_expr_ops = {
 
 struct expr *set_expr_alloc(const struct location *loc, const struct set *set)
 {
-	struct expr *set_expr = compound_expr_alloc(loc, EXPR_SET);
+	struct expr *set_expr;
+
+	set_expr = expr_alloc(loc, EXPR_SET, &invalid_type, BYTEORDER_INVALID, 0);
+	init_list_head(&expr_set(set_expr)->expressions);
 
 	if (!set)
 		return set_expr;
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 6d4eb98f3b5a..9fd2ab9e7117 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -2462,7 +2462,7 @@ flowtable_expr		:	'{'	flowtable_list_expr	'}'
 
 flowtable_list_expr	:	flowtable_expr_member
 			{
-				$$ = compound_expr_alloc(&@$, EXPR_LIST);
+				$$ = list_expr_alloc(&@$);
 				list_expr_add($$, $1);
 			}
 			|	flowtable_list_expr	COMMA	flowtable_expr_member
@@ -2801,14 +2801,14 @@ dev_spec		:	DEVICE	string
 				if (!expr)
 					YYERROR;
 
-				$$ = compound_expr_alloc(&@$, EXPR_LIST);
+				$$ = list_expr_alloc(&@$);
 				list_expr_add($$, expr);
 
 			}
 			|	DEVICE	variable_expr
 			{
 				datatype_set($2->sym->expr, &ifname_type);
-				$$ = compound_expr_alloc(&@$, EXPR_LIST);
+				$$ = list_expr_alloc(&@$);
 				list_expr_add($$, $2);
 			}
 			|	DEVICES		'='	flowtable_expr
@@ -4697,7 +4697,7 @@ set_rhs_expr		:	concat_rhs_expr
 
 initializer_expr	:	rhs_expr
 			|	list_rhs_expr
-			|	'{' '}'		{ $$ = compound_expr_alloc(&@$, EXPR_SET); }
+			|	'{' '}'		{ $$ = set_expr_alloc(&@$, NULL); }
 			|	DASH	NUM
 			{
 				int32_t num = -$2;
diff --git a/src/parser_json.c b/src/parser_json.c
index 17e13ebe4458..cff27a764a9e 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -2990,7 +2990,7 @@ static struct expr *ifname_expr_alloc(struct json_ctx *ctx,
 
 static struct expr *json_parse_devs(struct json_ctx *ctx, json_t *root)
 {
-	struct expr *tmp, *expr = compound_expr_alloc(int_loc, EXPR_LIST);
+	struct expr *tmp, *expr = list_expr_alloc(int_loc);
 	const char *dev;
 	json_t *value;
 	size_t index;
-- 
2.30.2

