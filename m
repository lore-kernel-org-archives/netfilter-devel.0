Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BFB82F3C2A
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Aug 2025 09:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755768225; cv=none; b=gAknUGBfbsHKcDGuFR4AuVIxnLsywZX4x012Ea9/WE9PjSpxOQwUpYCnEn7Oy0gmpjhBQFNPzyLuXmU0PhHuVioN1YXKDEWzNp+J1QOu4qUU0FW3yqXBv1+sUGOeF+Mhe8hQpTfLXMJhQh+Z+xya29Tq3zBlbBYRVYN3qjIVNss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755768225; c=relaxed/simple;
	bh=OGDyOgWvPBPCS+JpdsGq/DprvVJ0K6s7VHuriCaZq/c=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XgMUs/Q9kEYjE13RV4L7BFT8VS9Eo8yXnasF3XPwHe/C9vzDQcwYTGDquGGEHmgOIrj4znXjLhPOcUD7D7AGtAMeTCgbTq9CMAiUpme6ZNnpg6lpFw+5QO2wNTw3AQzcN1leDz/pd02t2bKzT8zYqdvPoKicOu9MK3wfe1I3pDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ugOGf8PQ; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ugOGf8PQ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ugOGf8PQ";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ugOGf8PQ"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id A2F19602B0; Thu, 21 Aug 2025 11:23:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755768222;
	bh=n+O2SDNXYlFJn3S6BeGlNqnF0VefOVC6qnciSYtBC9A=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=ugOGf8PQKeOBeFPl3eX5x1zket5YQYnw2jvPrmJTbBd7sMn2YTrAz+0xI6tjKMFvK
	 C8xgA/YV0I/4TOsf3WbNPrB5NMMZsqjfPt56/NBxKqk8AYSrCRiwiz8Gxkr8VLie/J
	 gu0Q3BxHJz6In2KbW2pHkIPPLGYJT5HtbO5Da2fcJhmSU5s/XzAg5wPHIdeW1u+6vA
	 Q+sloZfHkMy/UCd6FpVL6kDG5dsM8sG2rirr8HHGvqnqFWDCHjc8F7bElfIprQ2ueO
	 f6ZntTTrHzwVWgxYCF2SEOf4rJa0PPzfGqMJm0ll/PgZQA3xxHuizXWLL5foq5Pyym
	 6TkY69iUfyVJQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 3F0AF602AB
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Aug 2025 11:23:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755768222;
	bh=n+O2SDNXYlFJn3S6BeGlNqnF0VefOVC6qnciSYtBC9A=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=ugOGf8PQKeOBeFPl3eX5x1zket5YQYnw2jvPrmJTbBd7sMn2YTrAz+0xI6tjKMFvK
	 C8xgA/YV0I/4TOsf3WbNPrB5NMMZsqjfPt56/NBxKqk8AYSrCRiwiz8Gxkr8VLie/J
	 gu0Q3BxHJz6In2KbW2pHkIPPLGYJT5HtbO5Da2fcJhmSU5s/XzAg5wPHIdeW1u+6vA
	 Q+sloZfHkMy/UCd6FpVL6kDG5dsM8sG2rirr8HHGvqnqFWDCHjc8F7bElfIprQ2ueO
	 f6ZntTTrHzwVWgxYCF2SEOf4rJa0PPzfGqMJm0ll/PgZQA3xxHuizXWLL5foq5Pyym
	 6TkY69iUfyVJQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2 06/11] expression: replace compound_expr_clone() by type safe function
Date: Thu, 21 Aug 2025 11:23:25 +0200
Message-Id: <20250821092330.2739989-7-pablo@netfilter.org>
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

Replace compound_expr_clone() by:

- concat_expr_clone()
- list_expr_clone()
- set_expr_clone()

to validate type.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/expression.c | 42 ++++++++++++++++++++++++++++++------------
 1 file changed, 30 insertions(+), 12 deletions(-)

diff --git a/src/expression.c b/src/expression.c
index 22234567d2b1..6c5140b749f9 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -1027,15 +1027,6 @@ struct expr *compound_expr_alloc(const struct location *loc,
 	return expr;
 }
 
-static void compound_expr_clone(struct expr *new, const struct expr *expr)
-{
-	struct expr *i;
-
-	init_list_head(&new->expr_set.expressions);
-	list_for_each_entry(i, &expr->expr_set.expressions, list)
-		compound_expr_add(new, expr_clone(i));
-}
-
 static void compound_expr_destroy(struct expr *expr)
 {
 	struct expr *i, *next;
@@ -1079,6 +1070,15 @@ static void concat_expr_print(const struct expr *expr, struct output_ctx *octx)
 	compound_expr_print(expr, " . ", octx);
 }
 
+static void concat_expr_clone(struct expr *new, const struct expr *expr)
+{
+	struct expr *i;
+
+	init_list_head(&expr_concat(new)->expressions);
+	list_for_each_entry(i, &expr_concat(expr)->expressions, list)
+		concat_expr_add(new, expr_clone(i));
+}
+
 #define NFTNL_UDATA_SET_KEY_CONCAT_NEST 0
 #define NFTNL_UDATA_SET_KEY_CONCAT_NEST_MAX  NFT_REG32_SIZE
 
@@ -1234,7 +1234,7 @@ static const struct expr_ops concat_expr_ops = {
 	.name		= "concat",
 	.print		= concat_expr_print,
 	.json		= concat_expr_json,
-	.clone		= compound_expr_clone,
+	.clone		= concat_expr_clone,
 	.destroy	= concat_expr_destroy,
 	.build_udata	= concat_expr_build_udata,
 	.parse_udata	= concat_expr_parse_udata,
@@ -1258,12 +1258,21 @@ static void list_expr_print(const struct expr *expr, struct output_ctx *octx)
 	compound_expr_print(expr, ",", octx);
 }
 
+static void list_expr_clone(struct expr *new, const struct expr *expr)
+{
+	struct expr *i;
+
+	init_list_head(&expr_list(new)->expressions);
+	list_for_each_entry(i, &expr_list(expr)->expressions, list)
+		list_expr_add(new, expr_clone(i));
+}
+
 static const struct expr_ops list_expr_ops = {
 	.type		= EXPR_LIST,
 	.name		= "list",
 	.print		= list_expr_print,
 	.json		= list_expr_json,
-	.clone		= compound_expr_clone,
+	.clone		= list_expr_clone,
 	.destroy	= compound_expr_destroy,
 };
 
@@ -1375,6 +1384,15 @@ static void set_expr_print(const struct expr *expr, struct output_ctx *octx)
 	nft_print(octx, " }");
 }
 
+static void set_expr_clone(struct expr *new, const struct expr *expr)
+{
+	struct expr *i;
+
+	init_list_head(&expr_set(new)->expressions);
+	list_for_each_entry(i, &expr_set(expr)->expressions, list)
+		set_expr_add(new, expr_clone(i));
+}
+
 static void set_expr_set_type(const struct expr *expr,
 			      const struct datatype *dtype,
 			      enum byteorder byteorder)
@@ -1391,7 +1409,7 @@ static const struct expr_ops set_expr_ops = {
 	.print		= set_expr_print,
 	.json		= set_expr_json,
 	.set_type	= set_expr_set_type,
-	.clone		= compound_expr_clone,
+	.clone		= set_expr_clone,
 	.destroy	= compound_expr_destroy,
 };
 
-- 
2.30.2

