Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D841F2EFDA2
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Aug 2025 09:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755768225; cv=none; b=jE1tWVbtMf7gD/BEFR96DSYS6Z+8zksBpd9o8Ca15BlWOCtnatr8WFCaBdyprAL78EfKNUeMxCtll9ml0Lr0RiWMRmXIfG7YNXsbfulbbl5oo+VJyAIIpSDb6WJQOqmQlLYrTV8XiDAJhOVuwL7myOnpQm1DqSZ6ZRDaOMN7HBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755768225; c=relaxed/simple;
	bh=KLTWHFojTNLrWIEQkDaj8LJZMaXEm+zb2d/kbV7kOjg=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tm2f7kUEwfF08B2/Xn3P2T4VqLu1CQ4NulQAB1YV/j+zcnUBuBaBIlL3G+g9MhGO32jGZu3Bbs4rhGTPL5k74tRLdPXN4VkTfVZ/sYF0O/7jKrglseuorGORrrCn8A4NaTEMVU3RLqBf8Zi9VxHZyJxbJ58nkJieg86AvFB6sAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=TjpBXZmI; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=OxfzEOOu; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="TjpBXZmI";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="OxfzEOOu"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id F306B602AF; Thu, 21 Aug 2025 11:23:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755768222;
	bh=/v8fMizFSnXxSyn80/D3HSWUYqCSZlDMA9rXBbZiq80=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=TjpBXZmInEhtLb2prBMbpQuxNe/B+941afBO39JOg+NQCDzfb5pIfTlS9oMBRs5c2
	 YCWEyFwxaTtyAEav9U859nRHmYtiD7R8WxE8/wvVLHdEUU0lFf3bsnbu5z9ER9E+u6
	 Ci7EjIY31LxAYf0oJYyQBb4fbCJxL3tW1Lm6xpUq+lU+rOc+uPQaZwbPXVZPwM18vF
	 5ZPLrCIQAAKb474Yc6i1IZqSlge5Y9rcOZb28Gurs1ZW5YrFO6fHtiyokrPqOBx/n1
	 sZ9Vy0DVMbOIufjOZn1z/S2y1ZGoHtmJTFJr8q8C5AJEvX6Ijli9k61vT79Glhpx11
	 J6t4XIPlrL1eg==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 943B9602AB
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Aug 2025 11:23:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755768221;
	bh=/v8fMizFSnXxSyn80/D3HSWUYqCSZlDMA9rXBbZiq80=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=OxfzEOOuT0LXr/L+qXTKnlvRSJMJXnyd1zDdgSy9tF4zsr5UViaxsIvmWIimGt3ri
	 ugQlMhdgyGuAmEi7soz5kdrcvhXY6N/mS6CfSZYgq2oleMe+fWIKJ+6YClg7uMnv1X
	 +1t3UHCeFS7pZBGmRDdH7OyySZuX7b8gWsNL3FZK7T9tZ6GJr26rV57DT3e2TwXzr3
	 622LbgpoTet9THCJ1bLorJBhHlKbUBoWejJOcTFkrmkGgjk8J+6fCsPrm7WPq5LLdO
	 kjoKaNYv0HXeeDNPSjALqC0BeDBGz66L9S6Vqv6vdRV2x5VQltsvjnSFsBssh9/Set
	 NobYWojYpAU0w==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2 05/11] segtree: rename set_compound_expr_add() to set_expr_add_splice()
Date: Thu, 21 Aug 2025 11:23:24 +0200
Message-Id: <20250821092330.2739989-6-pablo@netfilter.org>
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

To avoid confusion when perfoming git grep to search for compound_expr_add()

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/segtree.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/src/segtree.c b/src/segtree.c
index 9395b5388507..e6b14f5dd120 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -207,7 +207,7 @@ static struct expr *expr_to_set_elem(struct expr *e)
 	return __expr_to_set_elem(e, expr);
 }
 
-static void set_compound_expr_add(struct expr *compound, struct expr *expr, struct expr *orig)
+static void set_expr_add_splice(struct expr *compound, struct expr *expr, struct expr *orig)
 {
 	struct expr *elem;
 
@@ -250,7 +250,7 @@ int get_set_decompose(struct set *cache_set, struct set *set)
 				return -1;
 			}
 
-			set_compound_expr_add(new_init, range, left);
+			set_expr_add_splice(new_init, range, left);
 
 			expr_free(left);
 			expr_free(i);
@@ -262,9 +262,9 @@ int get_set_decompose(struct set *cache_set, struct set *set)
 							      left, NULL);
 
 				if (range)
-					set_compound_expr_add(new_init, range, left);
+					set_expr_add_splice(new_init, range, left);
 				else
-					set_compound_expr_add(new_init,
+					set_expr_add_splice(new_init,
 							      expr_to_set_elem(left), left);
 			}
 			left = i;
@@ -273,9 +273,9 @@ int get_set_decompose(struct set *cache_set, struct set *set)
 	if (left) {
 		range = get_set_interval_find(cache_set, left, NULL);
 		if (range)
-			set_compound_expr_add(new_init, range, left);
+			set_expr_add_splice(new_init, range, left);
 		else
-			set_compound_expr_add(new_init, expr_to_set_elem(left), left);
+			set_expr_add_splice(new_init, expr_to_set_elem(left), left);
 	}
 
 	expr_free(set->init);
-- 
2.30.2

