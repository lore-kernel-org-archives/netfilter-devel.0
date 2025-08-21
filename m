Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E19A2EE61E
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Aug 2025 09:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755768227; cv=none; b=k8aEfBYAMgmElGv8oErPKfZ+qZ78WsipjJp8lt+NuEY537jyFCezmRuDQyPWmSzuxo9mRaJgu3x4zoau76Gy2sYIhQGIyu6l8CE9bP7B4AjkcI9FvMUkMXxRNq0Q40Lk6LP1KeABeJiChKQLsDY94KphcWnTGkgPG5Vl0SRzyZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755768227; c=relaxed/simple;
	bh=aGdvqo/dq2LX9aczj6umbbAjHlE8C8bEwExbOGDnw5o=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LrQ8RzZIVqG7YKWqkNx1EAJFzdshMLYyNh/VCpzWYSmRYlSOCUSQTG4in+YpJuw4EYb8gs8gz0dX2OJRJf8Gkm84D7Tx/0iTTnU0KtNoYOs8/o6C2qKTeVJjwYuT7vovSZSfmbr3qfz3qcCS2Z2QRSaNXmjodM7cofIxRtlaq0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=s7EcQV3d; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=s7EcQV3d; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="s7EcQV3d";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="s7EcQV3d"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id D285C602B2; Thu, 21 Aug 2025 11:23:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755768223;
	bh=wIpZvpjNJXpoFBaxrs7YtW8qtEtfNlVHYQbxIlDpabg=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=s7EcQV3d04kJLyKBe94zBnXzsP6ljPPGoOsTvNBxEIH7UIuRaJ2Bf87udEC/3koGg
	 YABAxyY2s3d9oLj36i+K51f/UhSp6+RSNbHbOGhu3kp+Amjn+sc1nd50lQXHVXN5dI
	 dfQLNOQMSzq0iieJJETAYKDD4eUuo4nm7kNs5A1lCU59OTwcgS4AzdEITsljO0v61L
	 WBj1lcNdQUrKAHf++vlri+Gw5cei8l94/L48VqblUcpjNG+ttOWW2Y4/8BNE/lQD/l
	 8C5QJ0uhRdTiK1/Hz22DgmsM+6ZK5dsXcEPqcv+o5ge5ok3Mx0vcoWH8/FTzImCUrj
	 htMWzy6ag8aEg==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 6AB18602AB
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Aug 2025 11:23:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755768223;
	bh=wIpZvpjNJXpoFBaxrs7YtW8qtEtfNlVHYQbxIlDpabg=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=s7EcQV3d04kJLyKBe94zBnXzsP6ljPPGoOsTvNBxEIH7UIuRaJ2Bf87udEC/3koGg
	 YABAxyY2s3d9oLj36i+K51f/UhSp6+RSNbHbOGhu3kp+Amjn+sc1nd50lQXHVXN5dI
	 dfQLNOQMSzq0iieJJETAYKDD4eUuo4nm7kNs5A1lCU59OTwcgS4AzdEITsljO0v61L
	 WBj1lcNdQUrKAHf++vlri+Gw5cei8l94/L48VqblUcpjNG+ttOWW2Y4/8BNE/lQD/l
	 8C5QJ0uhRdTiK1/Hz22DgmsM+6ZK5dsXcEPqcv+o5ge5ok3Mx0vcoWH8/FTzImCUrj
	 htMWzy6ag8aEg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2 08/11] expression: replace compound_expr_remove() by type safe function
Date: Thu, 21 Aug 2025 11:23:27 +0200
Message-Id: <20250821092330.2739989-9-pablo@netfilter.org>
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

Replace this function by {list,concat,set}_expr_remove() to validate
expression type.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/expression.h |  4 +++-
 src/expression.c     | 24 ++++++++++++++++++------
 src/segtree.c        |  6 +++---
 3 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index ce774fd32887..198ead603da6 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -519,21 +519,23 @@ struct expr *range_expr_to_prefix(struct expr *range);
 
 extern struct expr *compound_expr_alloc(const struct location *loc,
 					enum expr_types etypes);
-extern void compound_expr_remove(struct expr *compound, struct expr *expr);
 extern void list_expr_sort(struct list_head *head);
 extern void list_splice_sorted(struct list_head *list, struct list_head *head);
 
 extern struct expr *concat_expr_alloc(const struct location *loc);
 void concat_expr_add(struct expr *concat, struct expr *item);
+void concat_expr_remove(struct expr *concat, struct expr *expr);
 
 extern struct expr *list_expr_alloc(const struct location *loc);
 void list_expr_add(struct expr *expr, struct expr *item);
+void list_expr_remove(struct expr *expr, struct expr *item);
 struct expr *list_expr_to_binop(struct expr *expr);
 
 extern struct expr *set_expr_alloc(const struct location *loc,
 				   const struct set *set);
 void __set_expr_add(struct expr *set, struct expr *elem);
 void set_expr_add(struct expr *set, struct expr *elem);
+void set_expr_remove(struct expr *expr, struct expr *item);
 
 extern void concat_range_aggregate(struct expr *set);
 extern void interval_map_decompose(struct expr *set);
diff --git a/src/expression.c b/src/expression.c
index ee1fe34e2de9..582d0e7f8d66 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -1048,12 +1048,6 @@ static void compound_expr_print(const struct expr *expr, const char *delim,
 	}
 }
 
-void compound_expr_remove(struct expr *compound, struct expr *expr)
-{
-	compound->expr_set.size--;
-	list_del(&expr->list);
-}
-
 static void concat_expr_destroy(struct expr *expr)
 {
 	compound_expr_destroy(expr);
@@ -1247,6 +1241,12 @@ void concat_expr_add(struct expr *concat, struct expr *item)
 	expr_concat->size++;
 }
 
+void concat_expr_remove(struct expr *concat, struct expr *expr)
+{
+	expr_concat(concat)->size--;
+	list_del(&expr->list);
+}
+
 static void list_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
 	compound_expr_print(expr, ",", octx);
@@ -1283,6 +1283,12 @@ void list_expr_add(struct expr *expr, struct expr *item)
 	expr_list->size++;
 }
 
+void list_expr_remove(struct expr *list, struct expr *expr)
+{
+	expr_list(list)->size--;
+	list_del(&expr->list);
+}
+
 /* list is assumed to have two items at least, otherwise extend this! */
 struct expr *list_expr_to_binop(struct expr *expr)
 {
@@ -1433,6 +1439,12 @@ void set_expr_add(struct expr *set, struct expr *elem)
 	expr_set->size++;
 }
 
+void set_expr_remove(struct expr *set, struct expr *expr)
+{
+	expr_set(set)->size--;
+	list_del(&expr->list);
+}
+
 static void mapping_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
 	expr_print(expr->left, octx);
diff --git a/src/segtree.c b/src/segtree.c
index e6b14f5dd120..88207a3987b8 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -448,13 +448,13 @@ next:
 			mpz_clear(range);
 
 			r2 = list_entry(r2_next, typeof(*r2), list);
-			compound_expr_remove(expr_value(start), r1);
+			concat_expr_remove(expr_value(start), r1);
 
 			if (free_r1)
 				expr_free(r1);
 		}
 
-		compound_expr_remove(set, start);
+		set_expr_remove(set, start);
 		expr_free(start);
 		start = NULL;
 	}
@@ -584,7 +584,7 @@ void interval_map_decompose(struct expr *set)
 			catchall = i;
 			continue;
 		}
-		compound_expr_remove(set, i);
+		set_expr_remove(set, i);
 		elements[n++] = i;
 	}
 	qsort(elements, n, sizeof(elements[0]), expr_value_cmp);
-- 
2.30.2

