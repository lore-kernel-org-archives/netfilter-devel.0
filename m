Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 379BE1A01B9
	for <netfilter-devel@vger.kernel.org>; Thu,  6 Mar 2025 18:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741285707; cv=none; b=ffrHQl6h4cHy8KG/6XPJ1Dz13OspX+9H/L8Ok9tbjWrHA8tby6ykFjIO63aVZCf8ZnrCJZRi+iEBSbgL62dd3qRMoNbfCVGaaPFy1uOdENbH7KsuPcZ7Phy+RoHir3IhYGgGUueeHwWCxcry+DaGTv6egfoVw97rZzaPI/HxAx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741285707; c=relaxed/simple;
	bh=rZj1Ke1FxLojBUVMaHFaoZUZ9N17NVvFmOeNSi/WNLM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fC7blOfwjkd/yjcRuHQ/L/HIWHCq0u0+5eXCx5HKHPLjDQTXg+arwL5B3mmom099P7K51z9+MD9//zZ8lVQyaOnhmwnjeAuwgNb2MJwdIswGr1w2DN3LE3rgQA1EmlBgO8JPE35TkBZGFT7PNMkIlYpYafTi1bSn1FvBtNzUh0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=jSN2NH/i; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=sTQDOCyL; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="jSN2NH/i";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="sTQDOCyL"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 4BBBC60290; Thu,  6 Mar 2025 19:28:23 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741285703;
	bh=V+LWjehDWkI6mPTmTmDDdvs3jy6zCv5I4rMZAver/rE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jSN2NH/ibnBf10wS4scM0hD3SMpFsmaoA37fMD0lLcqJBYOxL3m+jjWoZnN80PGw1
	 yF2x1GZpqkCjwUEX3phmK+0HFVHip/1Wn9GxR0FXvv0UuZFZjbIVc7zR4YqDvOyNom
	 NX+kDDBVXgLAyW+BbdQe0T9vaSM9rJcmHs81B+UP3RoIf/ezIb7jaIyZGQWtDIlQtj
	 oLYhlbjNdCX0XhkCEye3gKpmkjWwSJOCKqX6XCN2bA+z9lfQud9VQWmmI/Alv/e8ta
	 Onq6Pimc39MGdG5b/N7efW/8XUAQ68lCS8/PuEWpnoLUiaKKCqPGuyw1whCi9Bwa5C
	 lqLivUz6YylaQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9989760290;
	Thu,  6 Mar 2025 19:28:22 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741285702;
	bh=V+LWjehDWkI6mPTmTmDDdvs3jy6zCv5I4rMZAver/rE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sTQDOCyL8M4p3CEqDFFrKzlJ/2D3xR8kMrptE2k4yFCl3ExuenZjxVga7sLIErcgA
	 etknBKUF2e2xSZqgsrydzH5HMYyNfcktmgruY1TYVyiLTlgalEsvPqAtr4sfpa5K5X
	 bLxTWw7NWaYXSXomJYtfXXUsxIgcegOSOCQQGOdCsr8nyqGCs6eCLIeHBW+JWeVnGG
	 6KiUTgRkwpURQJRemYBFvp1hY4TPOxpdhT2bZrw+Qrv8BgSPIY+4Re09MPuOxoq/+x
	 sgMG767cj7v0gEbvysNZv9DjHxsTwc4ry2sdpE2AABlsqDba/1JTU/7s0T6HLHjSE/
	 S5nzwiZL+HaEg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nft,v2 2/3] segtree: incomplete output in get element command with maps
Date: Thu,  6 Mar 2025 19:28:11 +0100
Message-Id: <20250306182812.330871-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250306182812.330871-1-pablo@netfilter.org>
References: <20250306182812.330871-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

get element command displays an incomplete range:

 # nft get element x y { 1.1.1.2 }

Before:

 table ip x {
        map y {
                type ipv4_addr : mark
                flags interval,timeout
                elements = { 1.1.1.1 counter packets 0 bytes 0 timeout 10m expires 1m24s160ms : 0x00000014 }
        }
 }

Note that it displays 1.1.1.1, instead of 1.1.1.1-1.1.1.10.

After this fix:

 table ip x {
        map y {
                type ipv4_addr : mark
                flags interval,timeout
                elements = { 1.1.1.1-1.1.1.10 counter packets 0 bytes 0 timeout 10m expires 1m24s160ms : 0x00000014 }
        }
 }

Fixes: a43cc8d53096 ("src: support for get element command")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: new in this series

 src/segtree.c | 39 ++++++++++++++++++++-------------------
 1 file changed, 20 insertions(+), 19 deletions(-)

diff --git a/src/segtree.c b/src/segtree.c
index bce38eef293c..e785fc25b5a2 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -110,19 +110,34 @@ struct expr *get_set_intervals(const struct set *set, const struct expr *init)
 	return new_init;
 }
 
+static struct expr *expr_value(struct expr *expr)
+{
+	switch (expr->etype) {
+	case EXPR_MAPPING:
+		return expr->left->key;
+	case EXPR_SET_ELEM:
+		return expr->key;
+	case EXPR_VALUE:
+		return expr;
+	default:
+		BUG("invalid expression type %s\n", expr_name(expr));
+	}
+}
+
 static struct expr *get_set_interval_find(const struct set *cache_set,
 					  struct expr *left,
 					  struct expr *right)
 {
 	const struct set *set = cache_set;
 	struct expr *range = NULL;
-	struct expr *i;
+	struct expr *i, *key;
 	mpz_t val;
 
 	mpz_init2(val, set->key->len);
 
 	list_for_each_entry(i, &set->init->expressions, list) {
-		switch (i->key->etype) {
+		key = expr_value(i);
+		switch (key->etype) {
 		case EXPR_VALUE:
 			if (expr_basetype(i->key)->type != TYPE_STRING)
 				break;
@@ -131,14 +146,14 @@ static struct expr *get_set_interval_find(const struct set *cache_set,
 		case EXPR_PREFIX:
 		case EXPR_RANGE:
 			range_expr_value_low(val, i);
-			if (left && mpz_cmp(left->key->value, val))
+			if (left && mpz_cmp(expr_value(left)->value, val))
 				break;
 
 			range_expr_value_high(val, i);
-			if (right && mpz_cmp(right->key->value, val))
+			if (right && mpz_cmp(expr_value(right)->value, val))
 				break;
 
-			range = expr_clone(i->key);
+			range = expr_clone(i);
 			goto out;
 		default:
 			break;
@@ -150,20 +165,6 @@ out:
 	return range;
 }
 
-static struct expr *expr_value(struct expr *expr)
-{
-	switch (expr->etype) {
-	case EXPR_MAPPING:
-		return expr->left->key;
-	case EXPR_SET_ELEM:
-		return expr->key;
-	case EXPR_VALUE:
-		return expr;
-	default:
-		BUG("invalid expression type %s\n", expr_name(expr));
-	}
-}
-
 static struct expr *__expr_to_set_elem(struct expr *low, struct expr *expr)
 {
 	struct expr *elem = set_elem_expr_alloc(&low->location, expr);
-- 
2.30.2

