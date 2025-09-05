Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 077322F7ABA
	for <netfilter-devel@vger.kernel.org>; Fri,  5 Sep 2025 15:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757086608; cv=none; b=rhohQkJgPlv5FJfBru8bbpwm/PrtZhrdPuhk7xWqKO9M0sN2KkPuvgE2WLUdoPWQw9Xb3G4r/MsLAhgsiE3MB4FU7EOBy+E3sTeCH4cf6idHA5Rt4ZpzPXTqdz2Y8eOSA/jTYzYzsrIDftaWXmsVFWlKHRRsGe6oGOTUj6h9p58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757086608; c=relaxed/simple;
	bh=C/ztuz7tKYotKnmfWBm1SXMTV+8VWJoLk7X2a1UjU8E=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bl4eyrDuBV7mEqKc08KYul5lWwGXrMNbVeQB5C1dRLrh6x3B93ayI4jmHDfah9lEghFDnHB2OVPwRjYhehmsgXbwsEovAjetRHTWsDTndfnj9mwPEo/EKWX0tWJ6fCFedsETQFqMIgjakE7Coqy651LzvuIvM9+zS0yDANbA6Vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=OfteJuLR; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=amOKuYBw; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="OfteJuLR";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="amOKuYBw"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 2896B608D9; Fri,  5 Sep 2025 17:36:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1757086600;
	bh=bBicDXOFqM+HMUOSUnGQS7xhYRqJ4uARUpfjb6YAoaQ=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=OfteJuLRBM8f4L2G56qPucxyfHJXrJnN+gxnQuiBaC2DltN8h9tkfGEV1VLY9tr5j
	 wFhzsfrnd/p8ccpEirX9fxjnP3vhx1RYOITUcjcvBS7AclK2xZLaLoLgqgOfudGZnV
	 K/t9+pfr8Iccq68OnaPUxPY5zoffQd8QZ+lRKu2ZEbdywnO0NqeqwTvkVJUcEbilIG
	 bEhA7Jh64mowEbhOraACOiVjmHWNJxMxzsImJOxRP6zcs4JUCaOlv2a42SO7wzUqHJ
	 iUUkIoan3rBepLFJPvebTHHXO9iY4PLaUURnIId8jpXQ6iECOcOPi9KNC537fw7nsr
	 eDjOgbqq1LqnQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 0B4F0608CF
	for <netfilter-devel@vger.kernel.org>; Fri,  5 Sep 2025 17:36:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1757086598;
	bh=bBicDXOFqM+HMUOSUnGQS7xhYRqJ4uARUpfjb6YAoaQ=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=amOKuYBwWKgS5TX/0iwThrfBBikBeBYHSdEZfj2A35rUsmhrZDwKuktYQoUUXwt8M
	 kay1RfXqtoGA1QKh9/geg4S1XU43yDu7b/AecbhWV+LtkfraDOLldBPzcMnGMXaoAO
	 5TpZUtCzYepZhCfDAkfvlSGIDeL4aAzQYp7/p9k/t0sprP0ytwXccoC74poJFRncLm
	 pWChs25w0M/ZF0Cp9T1dcsGZ1ALdXO1ZTBjUbry/CUM5CT5EC/zBBSjJ3uZ7gie9ZV
	 64vK8uTs6j5JEQCJ3mfQQa0wXtAkMSHF5or8C+mjXB/p2lgqFhn5fPssNNgaXWqAA6
	 rf/rtUktnkRtQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 5/7] evaluate: clean up expr_evaluate_set()
Date: Fri,  5 Sep 2025 17:36:25 +0200
Message-Id: <20250905153627.1315405-6-pablo@netfilter.org>
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

Remove redundant check for elem->etype == EXPR_SET_ELEM, assert()
already validates this at the beginning of the loop.

Remove redundant pointer to set element, use iterator index instead.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 85c446a124ee..82736bc5211c 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2056,7 +2056,6 @@ static void expr_evaluate_set_ref(struct eval_ctx *ctx, struct expr *expr)
 static int expr_evaluate_set(struct eval_ctx *ctx, struct expr **expr)
 {
 	struct expr *set = *expr, *i, *next;
-	const struct expr *elem;
 
 	list_for_each_entry_safe(i, next, &expr_set(set)->expressions, list) {
 		assert(i->etype == EXPR_SET_ELEM);
@@ -2083,10 +2082,7 @@ static int expr_evaluate_set(struct eval_ctx *ctx, struct expr **expr)
 			continue;
 		}
 
-		elem = i;
-
-		if (elem->etype == EXPR_SET_ELEM &&
-		    elem->key->etype == EXPR_SET_REF)
+		if (i->key->etype == EXPR_SET_REF)
 			return expr_error(ctx->msgs, i,
 					  "Set reference cannot be part of another set");
 
@@ -2094,8 +2090,7 @@ static int expr_evaluate_set(struct eval_ctx *ctx, struct expr **expr)
 			return expr_error(ctx->msgs, i,
 					  "Set member is not constant");
 
-		if (i->etype == EXPR_SET_ELEM &&
-		    i->key->etype == EXPR_SET) {
+		if (i->key->etype == EXPR_SET) {
 			/* Merge recursive set definitions */
 			list_splice_tail_init(&expr_set(i->key)->expressions, &i->list);
 			list_del(&i->list);
@@ -2104,9 +2099,9 @@ static int expr_evaluate_set(struct eval_ctx *ctx, struct expr **expr)
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
2.30.2

