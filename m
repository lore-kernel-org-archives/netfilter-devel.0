Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE3C82877E5
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Oct 2025 16:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761236069; cv=none; b=o2s32rU1Z0eB5PP51VBq5bAcjQLtyE+KeuVwVqKdlZk6zwuu6KkO7l2CcX8RKQ+rJc5GO6Lm8of35OEVKYBK3jDQ/1DIZIAbPgoB/BE0HziFIWhkc2ZUNugf/sK8XDH/xEPfs0rguOCBNYdoZvmt2qdBW+GHoIe+5xvFWzT/6zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761236069; c=relaxed/simple;
	bh=vx9BHurlCV0sahbis40c1sKOqBD88H2eQF5n3BWOlfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=prUH4xujBz81DSNk5PxtBxKpXEAeevarhYhwLyd0axKf8ghaJ7WGUXa8T4EX4eSSVMlkggErcQU1wwelfEJa3dQntQoOPWyjDgajGoRA9ot6PzTw/omd1UyGP0wLoLbJaHN4Q2CkH6RTsGoK43ZfzO4gA5RqS8yJH5A7uUdbc2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=pHVcPjxa; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="pHVcPjxa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=PDrmOG2YXIn1QS7fg3d2xs43IGUKdehSECtHNFeFCGc=; b=pHVcPjxaCgG1kJ6exiFFS9Dpza
	RCr0oSKw9hadtFv4eJIObGbd/+CPNE7UADxMGsLIAGsUBDHA+M2vAT3+qhWTcqHFE5YO2T42Ls3Ek
	cYLeyikqJ2B2opYb/qkl0t3MnjryTC8THr2uUQ/p+6eLn/ylbbIbkjFSK+LlNXTD1rPs1RPn8qwl/
	vc0NzrkI+cpHvVUjy06BcUtXbcPQpRrD0SMlbMC8dCYRIDw55IzCzlF08ScVip4GJZZcCaHnwdg2l
	+/yR6Br9xVVPqyuMs9YRvdvbm8Qm/xd3qjGiBdVWJFkyf/nsDKkiZnjZ3XM6v3iWchyjfmGcb0oFn
	X2U/e31A==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vBxxJ-00000000054-3yVv;
	Thu, 23 Oct 2025 18:14:26 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 16/28] expression: Set range expression 'len' field
Date: Thu, 23 Oct 2025 18:14:05 +0200
Message-ID: <20251023161417.13228-17-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251023161417.13228-1-phil@nwl.cc>
References: <20251023161417.13228-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The length value is needed for netlink debug output of concatenated
ranges. Set it to one of the inner elements' lengths (which should be
identical).

Since the inner element length may not be set initially, set it in
eval phase again. This covers at least all cases in tests/py.

Without this, netlink_gen_concat_key() et al. would have to inspect
element types and extract lengths accordingly, this is much easier.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/evaluate.c   | 1 +
 src/expression.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index be366140c12f2..cee500312bc6d 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1337,6 +1337,7 @@ static int expr_evaluate_range(struct eval_ctx *ctx, struct expr **exprp)
 
 	datatype_set(range, left->dtype);
 	range->flags |= EXPR_F_CONSTANT;
+	range->len = left->len;
 	return 0;
 }
 
diff --git a/src/expression.c b/src/expression.c
index 019c263f187b8..de63196b60a6a 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -1013,6 +1013,7 @@ struct expr *range_expr_alloc(const struct location *loc,
 			  BYTEORDER_INVALID, 0);
 	expr->left  = left;
 	expr->right = right;
+	expr->len = left->len;
 	return expr;
 }
 
-- 
2.51.0

