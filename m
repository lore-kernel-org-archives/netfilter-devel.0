Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 574A12BEC2A
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Feb 2026 02:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770259312; cv=none; b=AXEHzRLlrrzBeH7i0T0n8j4ujrep6+q3oExDshN3LNyhyVZlMO29ungdaJiiM0HllXq2Al1sl1BjNryWKCFLxtztYQM88bMvqpVintsaKNUsS2gU2O78w67a3u7xi00ZxA/e0G3kU8u6/BaXlWxpuX6Wm2nUHe209SSjEETHU4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770259312; c=relaxed/simple;
	bh=4IqNp7EI8nGbiVokZiZ72FQjcVPRnAD60yX4P3aq2iY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ybl2HfRDrsehQMxNq3rqVgg7jZBEOjfF+zOfiw8ATBxpkpZnFBelUrhc5fRSY17w1HZlXhPwMoDZdXYEDjNr9ExKhvr0fZ7KpFxMihql+YMqd0vAJ1YwJCqP4Y0pM1/9Vt6iVhuVOZBQvEKPjMMJyiXMbxpJuBS98S9awl5o1zI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=h708T3j7; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="h708T3j7"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id AFD7F6087B
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Feb 2026 03:41:50 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1770259310;
	bh=aZb8kqPqNTN+gSIselZ6ZzTFKAe8KEXA69SJ7UWENjc=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=h708T3j7NVG9Mgr60jbtAJrHDVUXEGS6nSjZcvqvFEdz7csmLbq+tEteoqOHGvhs1
	 xcCQpiXSgr39UuGkUkTP0B2D+V78mSFY0FsXUIPWoGE3Hn2lyFY369u4LbNl/4ZA8l
	 fiUaLgQUFsdCbG0/nMgV1VaBJQomDOEVW9fQ19pQYZ/VNSEOcuDF0iGOTuSUefSCE4
	 538LQrbfs07gjA/cR80y+Je2/WooL0QdlWSUTY3KiYF+hcaIyaMOEHsmUYKCT6m80z
	 3tjMSLPvXgm0Cnxh+aE9q9a+jRxZFU1VVi5QlJ8PsNwb8luAAtSTt9r7YKbAfRg8Bl
	 BnC7h4uk70CAw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 14/20] segtree: remove dead code in set_expr_add_splice()
Date: Thu,  5 Feb 2026 03:41:23 +0100
Message-ID: <20260205024130.1470284-15-pablo@netfilter.org>
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

If get_set_interval_find() always returns EXPR_SET_ELEM, then,
set_expr_add_splice() always takes EXPR_SET_ELEM.

This reworks:

  2b164aec4295 ("src: fix reset element support for interval set type")

which does _not_ seem to have a tests/shell unit.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/segtree.c | 19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff --git a/src/segtree.c b/src/segtree.c
index 0ff1577b75b9..69d6f513c55d 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -218,26 +218,11 @@ static struct expr *expr_to_set_elem(struct expr *e)
 
 static void set_expr_add_splice(struct expr *compound, struct expr *expr, struct expr *orig)
 {
-	struct expr *elem;
-
 	assert(expr->etype == EXPR_SET_ELEM);
 	assert(orig->etype == EXPR_SET_ELEM);
 
-	switch (expr->etype) {
-	case EXPR_SET_ELEM:
-		list_splice_init(&orig->stmt_list, &expr->stmt_list);
-		set_expr_add(compound, expr);
-		break;
-	case EXPR_MAPPING:
-		list_splice_init(&orig->left->stmt_list, &expr->left->stmt_list);
-		set_expr_add(compound, expr);
-		break;
-	default:
-		elem = set_elem_expr_alloc(&orig->location, expr);
-		list_splice_init(&orig->stmt_list, &elem->stmt_list);
-		set_expr_add(compound, elem);
-		break;
-	}
+	list_splice_init(&orig->stmt_list, &expr->stmt_list);
+	set_expr_add(compound, expr);
 }
 
 int get_set_decompose(struct set *cache_set, struct set *set)
-- 
2.47.3

