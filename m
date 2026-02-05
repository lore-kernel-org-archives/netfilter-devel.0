Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC0882C0F75
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Feb 2026 02:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770259303; cv=none; b=jIUTuuxmqXG8ZTpOSSlJOABDHwswMpJfKKyWpA9U2dOyr8yRsfkmQgJ8lEIdGvzpwqsW3vBW3KpJldxucKv+MuDwc00XfZ9h1lSLSqftUebw/q8ZePLUyQ9oH9wRH8hFS/miuUymWfkUWHOWgDu9b7TTvYBFNHaYtNErYikgHUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770259303; c=relaxed/simple;
	bh=lVu6EGHqSGwiT39aLM2bjD3cZYfYx/v8XN1e4Zh6cX4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OiFTTC0nFJ9/uw/oipWC3qwXVBnz4mU0QpqaslcCteWSTmbZebDVJuV8brFBoparCndUeMCRr9LI5WLxXANGzlKw51MzhnYl7ZOQ/i3DWKxqjerN+F039MGc5UVlqoNrum7iC2xEmmmXb//ZggdUWMwMFH3L6cdxMtXUdxqB0zI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=C/SezDi1; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="C/SezDi1"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E55656087B
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Feb 2026 03:41:40 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1770259301;
	bh=F3XcNw3HdzhPe+yi52tXnCxuZLKqtAhf+ToiAF5C6PM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=C/SezDi192ZJzbIWdB1hoqaasfPCdyDWMO+CopCzUpuyOa11XYSfqjovBo1HgzToc
	 qT/kLNorn0cO5BiovnfzIDLUj26ysXlz84uWxJdIB87SOrYWKAuA1Rw//MjNnivRoi
	 prA2LF694DJMYiCKiAtXQN1IKnq5Nlay14KYNia5G6DyIPTiJmJ0TpIyl7XOj+So9x
	 QTuUMz8Ps9T4saPTKQymhg9tZkzyxAQJ0cziQaEcGEr0rEyzlxgJNjG9FeNDGlGrue
	 gu4EuOY0NC5nwQrdq5S82qNEW2d0yqVL57UqOBFYmja6khfN1IE/g4H3UZywHCVJ/u
	 J1DQZxuZb/8Lw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 05/20] evaluate: clean up expr_evaluate_set()
Date: Thu,  5 Feb 2026 03:41:14 +0100
Message-ID: <20260205024130.1470284-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260205024130.1470284-1-pablo@netfilter.org>
References: <20260205024130.1470284-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove redundant check for elem->etype == EXPR_SET_ELEM, assert()
already validates this at the beginning of the loop.

Remove redundant pointer to set element, use iterator index instead.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 556664d640a3..7caa161bbe23 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2067,7 +2067,6 @@ static void expr_evaluate_set_ref(struct eval_ctx *ctx, struct expr *expr)
 static int expr_evaluate_set(struct eval_ctx *ctx, struct expr **expr)
 {
 	struct expr *set = *expr, *i, *next;
-	const struct expr *elem;
 
 	list_for_each_entry_safe(i, next, &expr_set(set)->expressions, list) {
 		assert(i->etype == EXPR_SET_ELEM);
@@ -2094,10 +2093,7 @@ static int expr_evaluate_set(struct eval_ctx *ctx, struct expr **expr)
 			continue;
 		}
 
-		elem = i;
-
-		if (elem->etype == EXPR_SET_ELEM &&
-		    elem->key->etype == EXPR_SET_REF)
+		if (i->key->etype == EXPR_SET_REF)
 			return expr_error(ctx->msgs, i,
 					  "Set reference cannot be part of another set");
 
@@ -2105,8 +2101,7 @@ static int expr_evaluate_set(struct eval_ctx *ctx, struct expr **expr)
 			return expr_error(ctx->msgs, i,
 					  "Set member is not constant");
 
-		if (i->etype == EXPR_SET_ELEM &&
-		    i->key->etype == EXPR_SET) {
+		if (i->key->etype == EXPR_SET) {
 			/* Merge recursive set definitions */
 			list_splice_tail_init(&expr_set(i->key)->expressions, &i->list);
 			list_del(&i->list);
@@ -2115,9 +2110,9 @@ static int expr_evaluate_set(struct eval_ctx *ctx, struct expr **expr)
 			expr_free(i);
 		} else if (!expr_is_singleton(i)) {
 			expr_set(set)->set_flags |= NFT_SET_INTERVAL;
-			if ((elem->key->etype == EXPR_MAPPING &&
-			     elem->key->left->etype == EXPR_CONCAT) ||
-			    elem->key->etype == EXPR_CONCAT)
+			if ((i->key->etype == EXPR_MAPPING &&
+			     i->key->left->etype == EXPR_CONCAT) ||
+			    i->key->etype == EXPR_CONCAT)
 				expr_set(set)->set_flags |= NFT_SET_CONCAT;
 		}
 	}
-- 
2.47.3

