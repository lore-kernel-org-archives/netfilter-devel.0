Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA1E37C10B
	for <netfilter-devel@vger.kernel.org>; Fri,  5 Sep 2025 15:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757087132; cv=none; b=gg6jpw06BbuYCNPntzqdwAucDkV5LNUslXKQX25RNPIz1BTiKAcDxc0SkRIz+Xxeo+vLP3OEfpR+bT4lqbA2neB201cLsu/NzCJu4XZMtxMtZdzrOZONTJ58v9zotsgKefJgrFodZwIJRbqJcK/WM8aIjQgsHPbRkeepL+ZXW7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757087132; c=relaxed/simple;
	bh=e2oBKXImX76VIgvlWYYj5VtuumYmczeE+Xx7HzqbFWE=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jvH/yxgMH9wrR/W+TCwj8N6lmMpsf+Z+ijuvLQIB+nPVVLh35OnE+9GlAIUDYH4nkAGtNkt2C/rq1MeItIowaOmfERaMVGh5I8y0IjNs0IC9do3lTjOsvptIk7mbZVoufpR1HTuPNPOdIXx/enfoxeagfFDZc/XigqBSWY4wHjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ONhBbzY+; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ONhBbzY+; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ONhBbzY+";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ONhBbzY+"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id A610D608D0; Fri,  5 Sep 2025 17:36:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1757086597;
	bh=iL8/CfMwLbXAI3ZLZAYKfGT43pR6WObvq6dra1OyekE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=ONhBbzY+MQwStSWOPY06cZIKnoS12XTBMQWOUt1mtpuaVURbDS06/Yl8GxJG3QPNv
	 WQUVdu6N4ZtgMHujbE5vJ3pc0Am1k/SVr7LukQQNqj0+LoHhjknnuH4qBrWzFssWbU
	 P/LD32shnp2gjQAdqIvdbhjxmg8jrTCNNyMOPdSlr2LOUjKDON6DLorYk/npfOohSY
	 IM6BhvngaHKnjXMipR+krNxX6xvchUS+dwLdxJXleJqj9VbCEu60dMSAgM4L8+oAlr
	 i+R/f4covgUj8+U0oF7bg3F+5yHmXmUQmWKF7ZliCyL9f98ZHjIHcgA0HYggrA0VlX
	 jHfKI54Ed5Jyg==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 20DA1608BA
	for <netfilter-devel@vger.kernel.org>; Fri,  5 Sep 2025 17:36:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1757086597;
	bh=iL8/CfMwLbXAI3ZLZAYKfGT43pR6WObvq6dra1OyekE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=ONhBbzY+MQwStSWOPY06cZIKnoS12XTBMQWOUt1mtpuaVURbDS06/Yl8GxJG3QPNv
	 WQUVdu6N4ZtgMHujbE5vJ3pc0Am1k/SVr7LukQQNqj0+LoHhjknnuH4qBrWzFssWbU
	 P/LD32shnp2gjQAdqIvdbhjxmg8jrTCNNyMOPdSlr2LOUjKDON6DLorYk/npfOohSY
	 IM6BhvngaHKnjXMipR+krNxX6xvchUS+dwLdxJXleJqj9VbCEu60dMSAgM4L8+oAlr
	 i+R/f4covgUj8+U0oF7bg3F+5yHmXmUQmWKF7ZliCyL9f98ZHjIHcgA0HYggrA0VlX
	 jHfKI54Ed5Jyg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/7] src: allocate EXPR_SET_ELEM for EXPR_SET in embedded set declaration in sets
Date: Fri,  5 Sep 2025 17:36:22 +0200
Message-Id: <20250905153627.1315405-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250905153627.1315405-1-pablo@netfilter.org>
References: <20250905153627.1315405-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Normalize the representation so the expressions list in EXPR_SET always
contains EXPR_SET_ELEM. Add assert() to validate this.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c     | 3 ++-
 src/parser_bison.y | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 3ed6f1b3f8ca..b0a3e990e476 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2059,7 +2059,8 @@ static int expr_evaluate_set(struct eval_ctx *ctx, struct expr **expr)
 	const struct expr *elem;
 
 	list_for_each_entry_safe(i, next, &expr_set(set)->expressions, list) {
-		/* recursive EXPR_SET are merged here. */
+		assert(i->etype == EXPR_SET_ELEM);
+
 		if (list_member_evaluate(ctx, &i) < 0)
 			return -1;
 
diff --git a/src/parser_bison.y b/src/parser_bison.y
index d0cb2f7f929f..dcbdc4514298 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -4599,7 +4599,7 @@ set_list_expr		:	set_list_member_expr
 
 set_list_member_expr	:	opt_newline	set_expr	opt_newline
 			{
-				$$ = $2;
+				$$ = set_elem_expr_alloc(&@$, $2);
 			}
 			|	opt_newline	set_elem_expr	opt_newline
 			{
-- 
2.30.2

