Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E77715687F
	for <netfilter-devel@vger.kernel.org>; Wed, 24 Apr 2024 21:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713995907; cv=none; b=WVvLQtbn9MnPb3p6p4kE+YihDXHNcdKKegKWE9pLmSRthvCYadrxGPtaYdRjGdeU6f54H10HpXh7spPZ02pRu5F9EjJJt8H8EhrOFU4QwxOgwJ6/ydunSta2rmSHP7Kh2NocCsBiphjd4dUFO2PBlmcsTzqt5VMHT4acoPpEyIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713995907; c=relaxed/simple;
	bh=9VBVSD9zzfj+7ke2Ij9cAkxPUrLbgo639XvZSA26UyM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jw+LaOMxcHifmjpN8uwNFuAauzK56f9Q4RvgTHSPMB9XQ5egMzCxt2PM+sbZiNJGfOSs01l9sBWvCCRlUmYIRMDT2qDs4rwBr6pl+aKoOFTOVX7i2pzKUy0G/ih2cTv9zNKJ9ldrXAse/Lilbgw6/M66DyDqmM5XH7nKZF6JCHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=KdVhDiC0; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="KdVhDiC0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=C5J/+e/gICFSs7XzTnGHGUbNN3BKF0RdYRvQvzGaWXc=; b=KdVhDiC0JS7lauiSNGbiRawkgM
	y5+ruGlOv177oOZ6XZkmntMqqGPa+RCxmH0dEuRLVfd44Hg9koDJfeuvYvMf0DSuMso0ksUdg7fFt
	pPTzsN8Iy/i+O91lbDC5RoS/HvRws64bv8Hu0rD23n4RjCkDB986nSmneUvPZmTB1RRLiomy08K1l
	sNmJw7XEYHEMjffI0P+BF3XJp0VfvvOJbaue1shd4Q5CwHwjCjmASkC53tN5X786QS/eFq7T5nOtQ
	rNQ0+WRU+nU1NUsdVhrx+c4eWXfWjwlLOqXGC20IJwS3iBQvQ558VjcWgif92y6zvnl1N7S4ET7KP
	9HitzSrA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rzkdC-000000003oQ-0OeE;
	Wed, 24 Apr 2024 23:58:22 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH] json: Fix for memleak in __binop_expr_json
Date: Wed, 24 Apr 2024 23:58:21 +0200
Message-ID: <20240424215821.19169-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When merging the JSON arrays generated for LHS and RHS of nested binop
expressions, the emptied array objects leak if their reference is not
decremented.

Fix this and tidy up other spots which did it right already by
introducing a json_array_extend wrapper.

Reported-by: Pablo Neira Ayuso <pablo@netfilter.org>
Fixes: 0ac39384fd9e4 ("json: Accept more than two operands in binary expressions")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/json.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/src/json.c b/src/json.c
index 3753017169930..b4fad0abd4b35 100644
--- a/src/json.c
+++ b/src/json.c
@@ -42,6 +42,15 @@
 })
 #endif
 
+static int json_array_extend_new(json_t *array, json_t *other_array)
+{
+	int ret;
+
+	ret = json_array_extend(array, other_array);
+	json_decref(other_array);
+	return ret;
+}
+
 static json_t *expr_print_json(const struct expr *expr, struct output_ctx *octx)
 {
 	const struct expr_ops *ops;
@@ -546,8 +555,10 @@ __binop_expr_json(int op, const struct expr *expr, struct output_ctx *octx)
 	json_t *a = json_array();
 
 	if (expr->etype == EXPR_BINOP && expr->op == op) {
-		json_array_extend(a, __binop_expr_json(op, expr->left, octx));
-		json_array_extend(a, __binop_expr_json(op, expr->right, octx));
+		json_array_extend_new(a,
+				      __binop_expr_json(op, expr->left, octx));
+		json_array_extend_new(a,
+				      __binop_expr_json(op, expr->right, octx));
 	} else {
 		json_array_append_new(a, expr_print_json(expr, octx));
 	}
@@ -1743,8 +1754,7 @@ static json_t *table_print_json_full(struct netlink_ctx *ctx,
 		}
 	}
 
-	json_array_extend(root, rules);
-	json_decref(rules);
+	json_array_extend_new(root, rules);
 
 	return root;
 }
@@ -1752,7 +1762,7 @@ static json_t *table_print_json_full(struct netlink_ctx *ctx,
 static json_t *do_list_ruleset_json(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	unsigned int family = cmd->handle.family;
-	json_t *root = json_array(), *tmp;
+	json_t *root = json_array();
 	struct table *table;
 
 	list_for_each_entry(table, &ctx->nft->cache.table_cache.list, cache.list) {
@@ -1760,9 +1770,7 @@ static json_t *do_list_ruleset_json(struct netlink_ctx *ctx, struct cmd *cmd)
 		    table->handle.family != family)
 			continue;
 
-		tmp = table_print_json_full(ctx, table);
-		json_array_extend(root, tmp);
-		json_decref(tmp);
+		json_array_extend_new(root, table_print_json_full(ctx, table));
 	}
 
 	return root;
-- 
2.43.0

