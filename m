Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5542F4A05
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Aug 2025 09:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755768228; cv=none; b=J+UBOFKlCuTeGeJdBhwHjlYwL16CeyLe6K53gh/xye5aJMSsIuLB05VbuR579yQgRl6ppBr2eRMX9SlRGCfsSMmO/aDPi/z+ILS85evw63idDUlzJarSpSBk+DaNSGHz+vWjlefNgMgQyQ/bpvoDUVI1F7pbpux5rKVwkPcS0jA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755768228; c=relaxed/simple;
	bh=09BF0Eqje71/guueKIpzE9RlkfCWVgzHL85mAUx5fDs=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HwJ2QhgTckKYVwB9nH909+hYVI9tZ+1V68F9ZcJlv3cXE3Be2+T8643UYvjRHhr0g6Q05aD2TTA4eUGLMXer4+JRAiEVhA9vzyjBJgG4/vmQQL8CQgZNK2g7Vsm4GiHttYENXzk3cMpzRyxj0502Z2oZozGzlZE3zYlXtPAl15o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=M4oWLKV2; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=M4oWLKV2; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="M4oWLKV2";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="M4oWLKV2"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id C2856602B4; Thu, 21 Aug 2025 11:23:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755768224;
	bh=tJdYotht4wmWQaJCWjW9mLJyT7Z9+fAdTK0FwWBca2E=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=M4oWLKV2Ve1IMhhvqCxTvhEAf7voLhtOMGUphLXwc6kLlYMhbjqap6fiico1CAruZ
	 0SRMIqhmeX8ANbXrgpfGC6aPQALDvUSU88ATCv3vAay+yLQ1pHoUZUuIDamdgiRyHg
	 fMmu5i3i4vKHdqfOzl/O/dtWRuMzCGUOWu2t1iKsLQUweq4nuqxUZQr7b5397A7lvw
	 whhIOujkMwcjPRSIcfZs5q8n7AlLMxyMpxhqu5X73LogqhbqsOsCIeewQwkCw+HuvW
	 oU00DZEyhwsWOhIHiTR7OgryQ40Vka+DcG7fN08ip0WClUjUQoDd7SQNbNMA3v1soO
	 0q3X4QZSVGLKA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 6D873602AB
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Aug 2025 11:23:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755768224;
	bh=tJdYotht4wmWQaJCWjW9mLJyT7Z9+fAdTK0FwWBca2E=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=M4oWLKV2Ve1IMhhvqCxTvhEAf7voLhtOMGUphLXwc6kLlYMhbjqap6fiico1CAruZ
	 0SRMIqhmeX8ANbXrgpfGC6aPQALDvUSU88ATCv3vAay+yLQ1pHoUZUuIDamdgiRyHg
	 fMmu5i3i4vKHdqfOzl/O/dtWRuMzCGUOWu2t1iKsLQUweq4nuqxUZQr7b5397A7lvw
	 whhIOujkMwcjPRSIcfZs5q8n7AlLMxyMpxhqu5X73LogqhbqsOsCIeewQwkCw+HuvW
	 oU00DZEyhwsWOhIHiTR7OgryQ40Vka+DcG7fN08ip0WClUjUQoDd7SQNbNMA3v1soO
	 0q3X4QZSVGLKA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2 10/11] expression: replace compound_expr_print() by type safe function
Date: Thu, 21 Aug 2025 11:23:29 +0200
Message-Id: <20250821092330.2739989-11-pablo@netfilter.org>
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

