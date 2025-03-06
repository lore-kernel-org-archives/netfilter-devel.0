Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E4D13D897
	for <netfilter-devel@vger.kernel.org>; Thu,  6 Mar 2025 18:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741285707; cv=none; b=YbGVhxTZZu4P6dE6j02QTJ+tAvyBsZrTZ9Fmqfww19JhflCLlt8BFIl17ApbcnqToxLz6b2VAyWKUZyldlNOMVysmcWaW9oC6L3rSkVnO3ZzD2RPj9b3M5dMiH/nrYzfT3xrY/fKtsEZR5AC3Yr7OnIqF2G+8TeTPtBWamjS59g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741285707; c=relaxed/simple;
	bh=bDe05PbCeAtaRkGzwJEe++8HD6aQ+D8NRITTRTL226A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=IlTugCsHABuWP0g7vwezYaTkrSIDEwB8r5eJfGV/Y/1ehMkvCoy6D7VLrWH3RCUMnFF6IInGiYSgfWyxUsAffY4PKaz6XDF35IPtAYPSKuj9eXRi+qCk2bNUWUCKnHbhJsIJSOCyAf9eQRw7y8oo3zA1BX4Nb9HXoilTU1H5mrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=skFhtnhb; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=pq+7URvH; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="skFhtnhb";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="pq+7URvH"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 52F236028D; Thu,  6 Mar 2025 19:28:22 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741285702;
	bh=c3BgnfB0j5xKVqHiaBQ+tTxLzV/hUfhSMLuvc3RdOfA=;
	h=From:To:Cc:Subject:Date:From;
	b=skFhtnhbke4L4ICTEGXvahjVNg2GGrDFPqLhh1PAitE3AawPNjGkprg5dma5GYj92
	 4BErkIuQgnRRxJY188+Jv/M5arcCECq8eV3MC5Gmf3y6W4W/37c3fnmPr1XVXK+4uc
	 4slkcon9nMLKGuvtJvACQICWbYnqwBA2nEtuz47NQPZXHIiAXWlt5y3mSKckIQBuOi
	 GpYH93J6RL5ZfCO/nguKRHIC4YV+77PZJhfxE+adXp8Ko3SW6z18Q+9yb0YZRL9cDY
	 osUWpwjQENGRibeTPqsvLHsUVxBfuMC+TwRpe1HOCMNzzh4TVRfuSA1VbYGJEikGEm
	 FYFMbR72YyfXQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 86A2D6028D;
	Thu,  6 Mar 2025 19:28:21 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741285701;
	bh=c3BgnfB0j5xKVqHiaBQ+tTxLzV/hUfhSMLuvc3RdOfA=;
	h=From:To:Cc:Subject:Date:From;
	b=pq+7URvHaGa02qJE7dyz+TvrgCJwA5jX7DHf2hX0uBfkH2/iUK9kzVI1Rao/lgLzo
	 6AMvg/Ha21gGz/Rm+VQuXuLNukqjZiZPyS+I0i8Stx/L2T96N++9fu/OrrrEKs6v7g
	 SU3s/r6rxmwEFOxRB3deRS7+1Avy3v/rFUbzlmnBYUBlhG4RMH/9eIsg/arkxnE6wk
	 PNpwynjZnHQaM3i7T/4z6e2wjBBCvmUBkawd6K05xaESsZraOWR4sgRDIL5DcoiFhz
	 yS+A2sAwbDJndk0FAv9rxjmV89LqoOq/BbBQYHF0Sf03843k/4OBvIORYlVE4niW2O
	 w5KzgjWs4URjQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nft,v2 1/3] src: fix reset element support for interval set type
Date: Thu,  6 Mar 2025 19:28:10 +0100
Message-Id: <20250306182812.330871-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

Running reset command yields on an interval (rbtree) set yields:
nft reset element inet filter rbtreeset {1.2.3.4}
BUG: unhandled op 8

This is easy to fix, CMD_RESET doesn't add or remove so it should be
treated like CMD_GET.

Unfortunately, this still doesn't work properly:

nft get element inet filter rbset {1.2.3.4}
returns:
 ... elements = { 1.2.3.4 }

but its expected that "get" and "reset" also return stateful objects
associated with the element.  This works for other set types, but for
rbtree, the list of statements gets lost during segtree processing.

After fix, get/reset returns:
  elements = { 1.2.3.4 counter packets 10 ...

A follow up patch will add a test case.

Fixes: 83e0f4402fb7 ("Implement 'reset {set,map,element}' commands")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: while at this, fix maps too.

@Florian: This is a follow-up on top of your series.

 src/evaluate.c |  1 +
 src/segtree.c  | 36 ++++++++++++++++++++++++++++++------
 2 files changed, 31 insertions(+), 6 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index c9c56588cee4..e27d08ce7ef8 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1953,6 +1953,7 @@ static int interval_set_eval(struct eval_ctx *ctx, struct set *set,
 				 ctx->nft->debug_mask);
 		break;
 	case CMD_GET:
+	case CMD_RESET:
 		break;
 	default:
 		BUG("unhandled op %d\n", ctx->cmd->op);
diff --git a/src/segtree.c b/src/segtree.c
index 2e32a3291979..bce38eef293c 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -206,6 +206,27 @@ static struct expr *expr_to_set_elem(struct expr *e)
 	return __expr_to_set_elem(e, expr);
 }
 
+static void set_compound_expr_add(struct expr *compound, struct expr *expr, struct expr *orig)
+{
+	struct expr *elem;
+
+	switch (expr->etype) {
+	case EXPR_SET_ELEM:
+		list_splice_init(&orig->stmt_list, &expr->stmt_list);
+		compound_expr_add(compound, expr);
+		break;
+	case EXPR_MAPPING:
+		list_splice_init(&orig->left->stmt_list, &expr->left->stmt_list);
+		compound_expr_add(compound, expr);
+		break;
+	default:
+		elem = set_elem_expr_alloc(&orig->location, expr);
+		list_splice_init(&orig->stmt_list, &elem->stmt_list);
+		compound_expr_add(compound, elem);
+		break;
+	}
+}
+
 int get_set_decompose(struct set *cache_set, struct set *set)
 {
 	struct expr *i, *next, *range;
@@ -227,20 +248,23 @@ int get_set_decompose(struct set *cache_set, struct set *set)
 				errno = ENOENT;
 				return -1;
 			}
+
+			set_compound_expr_add(new_init, range, left);
+
 			expr_free(left);
 			expr_free(i);
 
-			compound_expr_add(new_init, range);
 			left = NULL;
 		} else {
 			if (left) {
 				range = get_set_interval_find(cache_set,
 							      left, NULL);
+
 				if (range)
-					compound_expr_add(new_init, range);
+					set_compound_expr_add(new_init, range, left);
 				else
-					compound_expr_add(new_init,
-							  expr_to_set_elem(left));
+					set_compound_expr_add(new_init,
+							      expr_to_set_elem(left), left);
 			}
 			left = i;
 		}
@@ -248,9 +272,9 @@ int get_set_decompose(struct set *cache_set, struct set *set)
 	if (left) {
 		range = get_set_interval_find(cache_set, left, NULL);
 		if (range)
-			compound_expr_add(new_init, range);
+			set_compound_expr_add(new_init, range, left);
 		else
-			compound_expr_add(new_init, expr_to_set_elem(left));
+			set_compound_expr_add(new_init, expr_to_set_elem(left), left);
 	}
 
 	expr_free(set->init);
-- 
2.30.2

