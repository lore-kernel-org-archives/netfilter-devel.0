Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B91AE2ECD0C
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Aug 2025 14:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755094319; cv=none; b=T7xQv8spiHn/IQS9dckibrhqUZBRkgJQXlHwH51ZkMHTi2fOWKXq2is6b+KYZkankCHKstZYjjr5N12nLHkJx3RfN+ABgpgw3d10TnW+07WZmABKLfGOQnVrPHYzNPwrCtap9FgD3mIM30Hz2ZHpZYjxK03QAoR73hEtSjNCt6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755094319; c=relaxed/simple;
	bh=+y3vIBdAYbOXi0kxaTWtEif1ITEWUab2LSf8xAO5Kco=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EuslpeKjLhD5vsFGeaTyUOjQQE574TwFxvblusTPylmC5lJfUDyUTG5xFBkEDGMkpTXtvEhEaSUntKDTbmEvhKkOoI2XrAxM5OQzyvUnyvUkCgUwp8jdiKKEJQAosv+DyCE6czgtAwDUOyekVn3bg0jQkxzxq7eXBAXe1jiij2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=YdVXQDly; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=YdVXQDly; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="YdVXQDly";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="YdVXQDly"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id B7B346070D; Wed, 13 Aug 2025 16:11:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755094315;
	bh=tJbE942V3gg7MrGbRNzyReRNqSm4WP6PFjBCEzuYeX8=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=YdVXQDlyMmNZmV//WKmOY+/eNASSp3mqq/KIWzlrcZ1IQd5nEZxifxLLGxNODvCPO
	 ScCBiZecGhgTOf5rVgWnHDOKmUmvvMX/DXkfNMqPw5+bP2UlPszAJ/utoruOl+933i
	 IDujnJzvIjpliXU5B4L3g+AWDbO5fd7jQO5Hd/y+3cYJ34OkNUHwrfheApdktLLzrY
	 Km4mYSbIZj1AXyvQAX1OokX7ZCNvzEc9l8Ert0jl0ENxO9y51ay08LOkYOny346U4/
	 0wiWuwC6DpKLCt2HCXJFuHeffyXBp0Z7CXlmhM7SUw7kKOB9hczNLak1r7cD/Ayd30
	 iba3QTeYW1d9g==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 48343606F9
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Aug 2025 16:11:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755094315;
	bh=tJbE942V3gg7MrGbRNzyReRNqSm4WP6PFjBCEzuYeX8=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=YdVXQDlyMmNZmV//WKmOY+/eNASSp3mqq/KIWzlrcZ1IQd5nEZxifxLLGxNODvCPO
	 ScCBiZecGhgTOf5rVgWnHDOKmUmvvMX/DXkfNMqPw5+bP2UlPszAJ/utoruOl+933i
	 IDujnJzvIjpliXU5B4L3g+AWDbO5fd7jQO5Hd/y+3cYJ34OkNUHwrfheApdktLLzrY
	 Km4mYSbIZj1AXyvQAX1OokX7ZCNvzEc9l8Ert0jl0ENxO9y51ay08LOkYOny346U4/
	 0wiWuwC6DpKLCt2HCXJFuHeffyXBp0Z7CXlmhM7SUw7kKOB9hczNLak1r7cD/Ayd30
	 iba3QTeYW1d9g==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 10/12] expression: replace compound_expr_destroy() by type safe funtion
Date: Wed, 13 Aug 2025 16:11:42 +0200
Message-Id: <20250813141144.333784-11-pablo@netfilter.org>
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

