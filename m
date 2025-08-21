Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E009B2F4A10
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Aug 2025 09:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755768227; cv=none; b=OlvZHqMm+3K7FoAUX2Rlj2Vod6L7o4nBw4wg7i/Hy6rhsyLlt63RTg9zbD+RjzjJymvy5Zvc/qACG07zjHsyf4iXIeMLstKj3wY+U/uVQK39cGXUga+pyrxJelu1vtRJN5OeLMOed7QZ4dcmnwlZBSH1cho7v9Fwc7vAgDl6dTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755768227; c=relaxed/simple;
	bh=+y3vIBdAYbOXi0kxaTWtEif1ITEWUab2LSf8xAO5Kco=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=e/Hyp9E8T+3UvY4TvZ+2eSbLht/3JpBl3bueexbEaJ7NeRhAQLkIWuhZxJm7z7qACCLcD25to1zBKHKPtStBoap8zXfArIrsix5BIUD4K85zh+rB56i5p/EsAM3ZrZCTgKtI7HZW1Qe+unVbu8+p6cnCUU72q9/V+eqQHyWlsTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=XImh+lvf; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=XImh+lvf; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="XImh+lvf";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="XImh+lvf"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 552E4602B3; Thu, 21 Aug 2025 11:23:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755768224;
	bh=tJbE942V3gg7MrGbRNzyReRNqSm4WP6PFjBCEzuYeX8=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=XImh+lvfTYyokNMlmR0hm3x/6x0b1kX144kf/xU37AdC39wM/t4FuQ2x6gsaUU4Pl
	 UUGOwnuEjFDvNWsU+lf+ujKUUAb2uUHTlkgVk1DYo6R4LW6/UhM8MhHpbtqHZNNSWj
	 U1pZkhEdRPb/2OENHplhJw5cyJP1dCz0i5Nt4Eo3V7WN+BXASFQ/bhAvW5cSmU989P
	 bm+zD1piyX4FetXjCk2suLeKkuB6hsuLWHaVztiWcMut/xTBBpXkxsfzwl80LWG58O
	 XK4ykaoU0Q9zxILINEe9bKx6lWUBpap4VYsWofsRglyQjFFigeVgIbDp7B8ZpHY0r1
	 ycJ5tF012Na8g==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E7709602AB
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Aug 2025 11:23:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755768224;
	bh=tJbE942V3gg7MrGbRNzyReRNqSm4WP6PFjBCEzuYeX8=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=XImh+lvfTYyokNMlmR0hm3x/6x0b1kX144kf/xU37AdC39wM/t4FuQ2x6gsaUU4Pl
	 UUGOwnuEjFDvNWsU+lf+ujKUUAb2uUHTlkgVk1DYo6R4LW6/UhM8MhHpbtqHZNNSWj
	 U1pZkhEdRPb/2OENHplhJw5cyJP1dCz0i5Nt4Eo3V7WN+BXASFQ/bhAvW5cSmU989P
	 bm+zD1piyX4FetXjCk2suLeKkuB6hsuLWHaVztiWcMut/xTBBpXkxsfzwl80LWG58O
	 XK4ykaoU0Q9zxILINEe9bKx6lWUBpap4VYsWofsRglyQjFFigeVgIbDp7B8ZpHY0r1
	 ycJ5tF012Na8g==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2 09/11] expression: replace compound_expr_destroy() by type safe funtion
Date: Thu, 21 Aug 2025 11:23:28 +0200
Message-Id: <20250821092330.2739989-10-pablo@netfilter.org>
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

Replace it by {set,list,concat}_expr_destroy() to validate type.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/expression.c | 35 +++++++++++++++++++++++------------
 1 file changed, 23 insertions(+), 12 deletions(-)

diff --git a/src/expression.c b/src/expression.c
index 582d0e7f8d66..8d604fba265e 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -90,7 +90,7 @@ void expr_free(struct expr *expr)
 	datatype_free(expr->dtype);
 
 	/* EXPR_INVALID expressions lack ->ops structure.
-	 * This happens for compound types.
+	 * This happens for set, list and concat types.
 	 */
 	if (expr->etype != EXPR_INVALID)
 		expr_destroy(expr);
@@ -1027,14 +1027,6 @@ struct expr *compound_expr_alloc(const struct location *loc,
 	return expr;
 }
 
-static void compound_expr_destroy(struct expr *expr)
-{
-	struct expr *i, *next;
-
-	list_for_each_entry_safe(i, next, &expr->expr_set.expressions, list)
-		expr_free(i);
-}
-
 static void compound_expr_print(const struct expr *expr, const char *delim,
 				 struct output_ctx *octx)
 {
@@ -1050,7 +1042,10 @@ static void compound_expr_print(const struct expr *expr, const char *delim,
 
 static void concat_expr_destroy(struct expr *expr)
 {
-	compound_expr_destroy(expr);
+	struct expr *i, *next;
+
+	list_for_each_entry_safe(i, next, &expr_concat(expr)->expressions, list)
+		expr_free(i);
 }
 
 static void concat_expr_print(const struct expr *expr, struct output_ctx *octx)
@@ -1261,13 +1256,21 @@ static void list_expr_clone(struct expr *new, const struct expr *expr)
 		list_expr_add(new, expr_clone(i));
 }
 
+static void list_expr_destroy(struct expr *expr)
+{
+	struct expr *i, *next;
+
+	list_for_each_entry_safe(i, next, &expr_list(expr)->expressions, list)
+		expr_free(i);
+}
+
 static const struct expr_ops list_expr_ops = {
 	.type		= EXPR_LIST,
 	.name		= "list",
 	.print		= list_expr_print,
 	.json		= list_expr_json,
 	.clone		= list_expr_clone,
-	.destroy	= compound_expr_destroy,
+	.destroy	= list_expr_destroy,
 };
 
 struct expr *list_expr_alloc(const struct location *loc)
@@ -1393,6 +1396,14 @@ static void set_expr_clone(struct expr *new, const struct expr *expr)
 		set_expr_add(new, expr_clone(i));
 }
 
+static void set_expr_destroy(struct expr *expr)
+{
+	struct expr *i, *next;
+
+	list_for_each_entry_safe(i, next, &expr_set(expr)->expressions, list)
+		expr_free(i);
+}
+
 static void set_expr_set_type(const struct expr *expr,
 			      const struct datatype *dtype,
 			      enum byteorder byteorder)
@@ -1410,7 +1421,7 @@ static const struct expr_ops set_expr_ops = {
 	.json		= set_expr_json,
 	.set_type	= set_expr_set_type,
 	.clone		= set_expr_clone,
-	.destroy	= compound_expr_destroy,
+	.destroy	= set_expr_destroy,
 };
 
 struct expr *set_expr_alloc(const struct location *loc, const struct set *set)
-- 
2.30.2

