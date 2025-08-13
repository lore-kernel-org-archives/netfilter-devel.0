Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F9C2ED145
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Aug 2025 14:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755094320; cv=none; b=o9ZB+SAMgcqE88jgqdPN8QUhxcv5h1Kz271WzOe4/I56FqdDgOwXXbQDOiKlCo9fk6zNJOxO+i6WnXxp2eUr82fKn3eWs0ykEIzkarBeZ4bvf4NyqVdLEeXCiyfBWO2f7PEXZjvWHSgo9dIHJTyiuB7Zu7fXe3vzkx0Yi8FNL2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755094320; c=relaxed/simple;
	bh=09BF0Eqje71/guueKIpzE9RlkfCWVgzHL85mAUx5fDs=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ndCf/rY8q+tgocTa/n3KeVEj7JoFdP8HSXMj48wiuHOv5mEQeTNgg6gn4yfD/GDLMxOd6lrWywchSj2enSl5kShSxNd43glDjGxF7PxW6b/4LkjeCj+KT4BNOg7WaLN6k45jIG/oHZzaqJCA7DkNQHZ6R38QaYrthbRBQFb2LvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=nJ5YJ/Z5; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=nJ5YJ/Z5; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="nJ5YJ/Z5";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="nJ5YJ/Z5"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id ED79A606FA; Wed, 13 Aug 2025 16:11:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755094315;
	bh=tJdYotht4wmWQaJCWjW9mLJyT7Z9+fAdTK0FwWBca2E=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=nJ5YJ/Z5DQ/7dGDvu5uCQdJBPEaQfGNlUaLJcAH8jVkfaXdGxudpeu/5ReD1ExUS5
	 FfHqHDsOtF2rLtZB9iMLOHWQyiRLKZdQ82BJCOy6NhyX7X6uP9n9eWU+sM4iPqK5Wt
	 AEzzCXi0esgLIoQRNoNhg7nkbfuIrnlBXkmOZb6SgI0+CbeOVhU+O9Odoph1r4v3NW
	 sUFA2OnBojoNLLxSVeauxHeUxQMLG9RTXbf5qtLft6A6j0ON6g+5NIuwUomwT/tE+q
	 aYaYWO8oWvkOIOBf4cVsqjFaJvdGnEBb7XjQ0vFWV5U94sMSwc1Z3WBGCWrT347OsG
	 +rmsvTprAJamA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 949E6606F1
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Aug 2025 16:11:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755094315;
	bh=tJdYotht4wmWQaJCWjW9mLJyT7Z9+fAdTK0FwWBca2E=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=nJ5YJ/Z5DQ/7dGDvu5uCQdJBPEaQfGNlUaLJcAH8jVkfaXdGxudpeu/5ReD1ExUS5
	 FfHqHDsOtF2rLtZB9iMLOHWQyiRLKZdQ82BJCOy6NhyX7X6uP9n9eWU+sM4iPqK5Wt
	 AEzzCXi0esgLIoQRNoNhg7nkbfuIrnlBXkmOZb6SgI0+CbeOVhU+O9Odoph1r4v3NW
	 sUFA2OnBojoNLLxSVeauxHeUxQMLG9RTXbf5qtLft6A6j0ON6g+5NIuwUomwT/tE+q
	 aYaYWO8oWvkOIOBf4cVsqjFaJvdGnEBb7XjQ0vFWV5U94sMSwc1Z3WBGCWrT347OsG
	 +rmsvTprAJamA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 11/12] expression: replace compound_expr_print() by type safe function
Date: Wed, 13 Aug 2025 16:11:43 +0200
Message-Id: <20250813141144.333784-12-pablo@netfilter.org>
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

Replace compound_expr_print() by {list,set,concat}_expr_print() to
validate expression type.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/expression.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/src/expression.c b/src/expression.c
index 8d604fba265e..c0ab5d5598f2 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -1027,19 +1027,6 @@ struct expr *compound_expr_alloc(const struct location *loc,
 	return expr;
 }
 
-static void compound_expr_print(const struct expr *expr, const char *delim,
-				 struct output_ctx *octx)
-{
-	const struct expr *i;
-	const char *d = "";
-
-	list_for_each_entry(i, &expr->expr_set.expressions, list) {
-		nft_print(octx, "%s", d);
-		expr_print(i, octx);
-		d = delim;
-	}
-}
-
 static void concat_expr_destroy(struct expr *expr)
 {
 	struct expr *i, *next;
@@ -1050,7 +1037,14 @@ static void concat_expr_destroy(struct expr *expr)
 
 static void concat_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
-	compound_expr_print(expr, " . ", octx);
+	const struct expr *i;
+	const char *d = "";
+
+	list_for_each_entry(i, &expr_concat(expr)->expressions, list) {
+		nft_print(octx, "%s", d);
+		expr_print(i, octx);
+		d = " . ";
+	}
 }
 
 static void concat_expr_clone(struct expr *new, const struct expr *expr)
@@ -1244,7 +1238,14 @@ void concat_expr_remove(struct expr *concat, struct expr *expr)
 
 static void list_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
-	compound_expr_print(expr, ",", octx);
+	const struct expr *i;
+	const char *d = "";
+
+	list_for_each_entry(i, &expr_list(expr)->expressions, list) {
+		nft_print(octx, "%s", d);
+		expr_print(i, octx);
+		d = ",";
+	}
 }
 
 static void list_expr_clone(struct expr *new, const struct expr *expr)
-- 
2.30.2

