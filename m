Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD1AE1FE443
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Mar 2025 20:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743020613; cv=none; b=fosqqFxbXO1/22AMrMGPEVWPPCDefx/AI89UzM14LNU9d1+BLtvKz8QwJ/imuQOM1yb1Kp1GR86zmSFN/clJ+oKT1d5r5amGLncqkLJWEcK9M1OtgE2+A3DkWRgDPkEbx9W3D7D78r80Y5zcmktdgrHmTZyXKNE+/6mpk9T/KqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743020613; c=relaxed/simple;
	bh=F0d4lifj03WAqWRm4FsOoSRtw/XmymSfaJhrdk2q1Cg=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=L/7Ec444KqqQle9uTGzWRfHAMFdKh91aXahBxUkLFwc7jCZV0ExfDDN9o5aqr6HjGmXMKOupVOgqdisoJsueEaA1vFfGnMfa6r9ARb2S4QxBEBxKnNd4sbfhgmguri31zBn+k+Pj1nSpvdvca0jab9WCTq99eUYhzN/XeaLUjCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ONNJyJ/C; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=VVXNQOne; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ONNJyJ/C";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="VVXNQOne"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 2CEEA607F5; Wed, 26 Mar 2025 21:23:23 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743020603;
	bh=9rN7GooFbNRxGezqCImdmaqknPMvFBb6t6+vAYet1wY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=ONNJyJ/CTbSZfWDfUPTXMf9dnaRu7dO0G2rFYbzTzmG92QgKla3O0kBar+OKHlYpg
	 uA5V8tTE9fo92hmXpvlHb22CBwdCD7auUNgRLjT2jcdV3Ww7XEUZhgnOpWEPBEFLNO
	 qS2RrkPFGQx7vQD3v9Dfo3f5EauHr9nCPlDhJjb0iaoaCyU4sIk1Uv/D/QklYId2Mi
	 9jI5ScTVIO++jmcBjn4zzPKHArRqjXRMcFDJGeLaqfC0yslR4wK8ZfY/nEQv/MKRh3
	 1p/kPWMLFmsK/j4fgk1Awtef56DP91YpvvhX/CcQWFZzaKCRAqh4CvLcAd1IbNdDPS
	 Nv3/vYAZmWjdw==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id AC516606B5
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Mar 2025 21:23:22 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743020602;
	bh=9rN7GooFbNRxGezqCImdmaqknPMvFBb6t6+vAYet1wY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=VVXNQOne/3xDFK7MgQrS5+c2LL6AB6kqqlEHSOwC3fvuYHoH14cb4UHZchd0cCfHE
	 uaD1WLPOk544F6hp8JUDN+AzRLzIO7ckkrKXPcnRaOc15z8hDO86DXV4jqzjyb/wwr
	 T0PMkREzrUiH9v4Fjh8bFnojxHzrH+1z4ISXRmSj1aWSuzOwgo5c3PQzqJRskbg3b7
	 ROKP5BfrNHvKMs0rZIOZ3aHBv2k4RLJndhY9AjCzGKrYT2w+KfdOiFyGje1KKE/Rni
	 kh53Z3T7RTDyWfW6SW6rqAgICTWQ4JVFfmSo3rGQAAnGegg2jlK4r57PW9Y05pXMK1
	 OnOEZdWMbbUyA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 3/4] src: transform flag match expression to binop expression from parser
Date: Wed, 26 Mar 2025 21:23:02 +0100
Message-Id: <20250326202303.20396-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250326202303.20396-1-pablo@netfilter.org>
References: <20250326202303.20396-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Transform flagcmp expression to a relational with binop on the left hand
side, ie.

         relational
          /      \
       binop    value
       /   \
 payload  mask

Add list_expr_to_binop() to make this transformation.

Goal is two-fold:

- Allow -o/--optimize to pick up on this representation.
- Remove the flagcmp expression in a follow up patch.

This prepare for the removal of the flagcmp expression added by:

  c3d57114f119 ("parser_bison: add shortcut syntax for matching flags without binary operations")

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/expression.h |  1 +
 src/expression.c     | 23 +++++++++++++++++++++++
 src/parser_bison.y   | 22 ++++++++++++++++++----
 3 files changed, 42 insertions(+), 4 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index 8472748621ef..818d7a7dc74b 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -519,6 +519,7 @@ extern void list_splice_sorted(struct list_head *list, struct list_head *head);
 extern struct expr *concat_expr_alloc(const struct location *loc);
 
 extern struct expr *list_expr_alloc(const struct location *loc);
+struct expr *list_expr_to_binop(struct expr *expr);
 
 extern struct expr *set_expr_alloc(const struct location *loc,
 				   const struct set *set);
diff --git a/src/expression.c b/src/expression.c
index 156a66eb37f0..2a30d5af92a4 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -1263,6 +1263,29 @@ struct expr *list_expr_alloc(const struct location *loc)
 	return compound_expr_alloc(loc, EXPR_LIST);
 }
 
+/* list is assumed to have two items at least, otherwise extend this! */
+struct expr *list_expr_to_binop(struct expr *expr)
+{
+	struct expr *first, *last, *i;
+
+	first = list_first_entry(&expr->expressions, struct expr, list);
+	i = first;
+
+	list_for_each_entry_continue(i, &expr->expressions, list) {
+		if (first) {
+			last = binop_expr_alloc(&expr->location, OP_OR, first, i);
+			first = NULL;
+		} else {
+			last = binop_expr_alloc(&expr->location, OP_OR, i, last);
+		}
+	}
+	/* zap list expressions, they have been moved to binop expression. */
+	init_list_head(&expr->expressions);
+	expr_free(expr);
+
+	return last;
+}
+
 static const char *calculate_delim(const struct expr *expr, int *count,
 				   struct output_ctx *octx)
 {
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 5760ba479fc9..4b2b51d4275c 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -4917,19 +4917,33 @@ relational_expr		:	expr	/* implicit */	rhs_expr
 			}
 			|	expr	/* implicit */	basic_rhs_expr	SLASH	list_rhs_expr
 			{
-				$$ = flagcmp_expr_alloc(&@$, OP_EQ, $1, $4, $2);
+				struct expr *mask = list_expr_to_binop($4);
+				struct expr *binop = binop_expr_alloc(&@$, OP_AND, $1, mask);
+
+				$$ = relational_expr_alloc(&@$, OP_IMPLICIT, binop, $2);
 			}
 			|	expr	/* implicit */	list_rhs_expr	SLASH	list_rhs_expr
 			{
-				$$ = flagcmp_expr_alloc(&@$, OP_EQ, $1, $4, $2);
+				struct expr *value = list_expr_to_binop($2);
+				struct expr *mask = list_expr_to_binop($4);
+				struct expr *binop = binop_expr_alloc(&@$, OP_AND, $1, mask);
+
+				$$ = relational_expr_alloc(&@$, OP_IMPLICIT, binop, value);
 			}
 			|	expr	relational_op	basic_rhs_expr	SLASH	list_rhs_expr
 			{
-				$$ = flagcmp_expr_alloc(&@$, $2, $1, $5, $3);
+				struct expr *mask = list_expr_to_binop($5);
+				struct expr *binop = binop_expr_alloc(&@$, OP_AND, $1, mask);
+
+				$$ = relational_expr_alloc(&@$, $2, binop, $3);
 			}
 			|	expr	relational_op	list_rhs_expr	SLASH	list_rhs_expr
 			{
-				$$ = flagcmp_expr_alloc(&@$, $2, $1, $5, $3);
+				struct expr *value = list_expr_to_binop($3);
+				struct expr *mask = list_expr_to_binop($5);
+				struct expr *binop = binop_expr_alloc(&@$, OP_AND, $1, mask);
+
+				$$ = relational_expr_alloc(&@$, $2, binop, value);
 			}
 			|	expr	relational_op	rhs_expr
 			{
-- 
2.30.2

