Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B31B81FC3
	for <netfilter-devel@vger.kernel.org>; Mon, 31 Mar 2025 15:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743436225; cv=none; b=HtifsPFgG8HvCTwX7g8d1ehBcCT2RXkx2KgaVB04SmcT8miOV8ycGRN3RxlLlMD8/Dkmuk+itRS1m9W7RQaYQjwQGvBXY36mzOfJO0vWMiFXyLhLXtFokkQU3vu4BTZS+fISVqMI3gM13YQk/yYB0O4HrW2jT/z24VjoZK4G0d0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743436225; c=relaxed/simple;
	bh=HAh2fpUsJU8cmQM25r55dJLOaw284tY6vofficJgENs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=abRS47Y4gXGbwsFP77Y9fBxkTCj1mHBUctqOdJwWaB1/xUR7svQFY2kv9Z+CkJLNrqFOppAbTKxnEdK324RbzOe5pu2FbrhRkA/CpMkZhQ9aYpJG2D9/mKz7SzKd4nRk4qcG6D0DFicSo5+Ri44IQXx8Z3QVZ/TysAb91BMFmsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=kd/PwJzj; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=kd/PwJzj; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="kd/PwJzj";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="kd/PwJzj"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id BE94560571; Mon, 31 Mar 2025 17:50:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743436218;
	bh=+ubVQTW0RN7x/ZuGRr9J40pmsg5Ghx2xCMGEcAQao4k=;
	h=From:To:Cc:Subject:Date:From;
	b=kd/PwJzjm4mI0PcsC5v+8gioTuq8HraCZRKi2ESbX+OCOcJoE/jsy1l5XxbhgZJZq
	 lEJmx6Fl9+d9wyoRmd8DR9ZkHi0J+YJ+fGm/fsv7VVXxvPf9f+CUxKmzuUYbhvGDnJ
	 s2ACnIXd9MlKwug4+NbiihAqsqpKaTTzKgyKI5lbTYeNfO4LCG70yB3dT+ZmtsuN/d
	 IaSyaius9FQdGD8B4XKXTTMQS7eSyUfR386KLy9TnBNXGwP0fNF3W2GxMlES8+zhIj
	 b+1FddjZNUiHH7xWvXFzXqsFyJ71AESlqs1/27QEmIg+30Mg2SRWKpgv//ALDPLoEh
	 1ldunsofiVgyQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 1587C60571;
	Mon, 31 Mar 2025 17:50:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743436218;
	bh=+ubVQTW0RN7x/ZuGRr9J40pmsg5Ghx2xCMGEcAQao4k=;
	h=From:To:Cc:Subject:Date:From;
	b=kd/PwJzjm4mI0PcsC5v+8gioTuq8HraCZRKi2ESbX+OCOcJoE/jsy1l5XxbhgZJZq
	 lEJmx6Fl9+d9wyoRmd8DR9ZkHi0J+YJ+fGm/fsv7VVXxvPf9f+CUxKmzuUYbhvGDnJ
	 s2ACnIXd9MlKwug4+NbiihAqsqpKaTTzKgyKI5lbTYeNfO4LCG70yB3dT+ZmtsuN/d
	 IaSyaius9FQdGD8B4XKXTTMQS7eSyUfR386KLy9TnBNXGwP0fNF3W2GxMlES8+zhIj
	 b+1FddjZNUiHH7xWvXFzXqsFyJ71AESlqs1/27QEmIg+30Mg2SRWKpgv//ALDPLoEh
	 1ldunsofiVgyQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nft] expression: initialize list of expression to silence gcc compile warning
Date: Mon, 31 Mar 2025 17:50:13 +0200
Message-Id: <20250331155013.572712-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The helper function to translate flagcmp expression to binop expression
results in the following compile warning.

  src/expression.c: In function 'list_expr_to_binop':
  src/expression.c:1286:16: warning: 'last' may be used uninitialized [-Wmaybe-uninitialized]
  1286 |         return last;

While at it, add assert() to validate the premises where this function
can be called.

Fixes: 4d5990c92c83 ("src: transform flag match expression to binop expression from parser")
Reported-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/expression.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/src/expression.c b/src/expression.c
index 0b51b22e6103..9f19a379df0f 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -1266,7 +1266,9 @@ struct expr *list_expr_alloc(const struct location *loc)
 /* list is assumed to have two items at least, otherwise extend this! */
 struct expr *list_expr_to_binop(struct expr *expr)
 {
-	struct expr *first, *last, *i;
+	struct expr *first, *last = NULL, *i;
+
+	assert(!list_empty(&expr->expressions));
 
 	first = list_first_entry(&expr->expressions, struct expr, list);
 	i = first;
@@ -1279,6 +1281,9 @@ struct expr *list_expr_to_binop(struct expr *expr)
 			last = binop_expr_alloc(&expr->location, OP_OR, i, last);
 		}
 	}
+	/* list with one single item only, this should not happen. */
+	assert(first);
+
 	/* zap list expressions, they have been moved to binop expression. */
 	init_list_head(&expr->expressions);
 	expr_free(expr);
-- 
2.30.2

