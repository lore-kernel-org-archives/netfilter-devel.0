Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A9232ECE8D
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Aug 2025 14:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755094319; cv=none; b=KQN50E1ObXxKEYqsNq88fFC/dO22r12j6TNVwOaa9N4+sKx/ep1FUJgnsU+oEBz4PC4G3LV86XIggifdslgSvnkUYIi2uuFhzBMzwVvuNWGJUgY3k2KZu9PaAJoJzZMNUYiRIU6KIGCA9fmte6RXBAVXyP3qv2yLKap5pjdqkik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755094319; c=relaxed/simple;
	bh=Cboh6fE1aqt1URDfysw2BUWQ4t1kRAMWF9Dn9LLljYc=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Sp19Y6M6n5oVk0IJnSYRbGyDShhJef7urFTyZhL+pVIAzpbqGVMMnBa2es+Q4wAg+BsEJuYe6n2khgri5wEW4uQNdoKcHy4x0oY53U4VnEVcOTMpxpwdKj3PEV777otjGulnAfoCAZRMNv6E7mMtACnifnzexdHDFC+pl4BTYUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=roW2IPaE; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=roW2IPaE; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="roW2IPaE";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="roW2IPaE"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id E146760701; Wed, 13 Aug 2025 16:11:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755094314;
	bh=t9s0H5mZ+ZirGOgWiV++z0Wz3C+To8R+usqWFcRSZk8=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=roW2IPaEyey4EQZUl5TfXj800MTxZjgfO3Zid6uRfffbshrpbeU6QypnXh80XN1zn
	 wVD2RmWq3gZhFM/sQfkFxTEKqLMcH2OEGNOzm6CkDM5LYsA01Ts0knA+Rec7n0v83r
	 QwbOBwW0hyuLhdVVMhWtzSJVGF94WcOztWQyqqi42OZpccdTnUfJ05zSd4wlCpGNF0
	 vx4WY/dqbLJ8K5ge18NWrgyztq7eqq9DxMGEkH7mAmAYfiwOYMPV/y20vzDVy/0fvw
	 Y+aw2pW6i1RoxOD1f9AXbSpnL0lIj4OP1t73AY8T0sw8CaaR6w8NZaxLz8fnhkQ5HZ
	 pCf9XiI62/91w==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 8C935606F1
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Aug 2025 16:11:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755094314;
	bh=t9s0H5mZ+ZirGOgWiV++z0Wz3C+To8R+usqWFcRSZk8=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=roW2IPaEyey4EQZUl5TfXj800MTxZjgfO3Zid6uRfffbshrpbeU6QypnXh80XN1zn
	 wVD2RmWq3gZhFM/sQfkFxTEKqLMcH2OEGNOzm6CkDM5LYsA01Ts0knA+Rec7n0v83r
	 QwbOBwW0hyuLhdVVMhWtzSJVGF94WcOztWQyqqi42OZpccdTnUfJ05zSd4wlCpGNF0
	 vx4WY/dqbLJ8K5ge18NWrgyztq7eqq9DxMGEkH7mAmAYfiwOYMPV/y20vzDVy/0fvw
	 Y+aw2pW6i1RoxOD1f9AXbSpnL0lIj4OP1t73AY8T0sw8CaaR6w8NZaxLz8fnhkQ5HZ
	 pCf9XiI62/91w==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 08/12] expression: remove compound_expr_add()
Date: Wed, 13 Aug 2025 16:11:40 +0200
Message-Id: <20250813141144.333784-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250813141144.333784-1-pablo@netfilter.org>
References: <20250813141144.333784-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

No more users of this function after conversion to type safe variant,
remove it.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/expression.h | 1 -
 src/expression.c     | 6 ------
 2 files changed, 7 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index c2c59891a8a1..ce774fd32887 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -519,7 +519,6 @@ struct expr *range_expr_to_prefix(struct expr *range);
 
 extern struct expr *compound_expr_alloc(const struct location *loc,
 					enum expr_types etypes);
-extern void compound_expr_add(struct expr *compound, struct expr *expr);
 extern void compound_expr_remove(struct expr *compound, struct expr *expr);
 extern void list_expr_sort(struct list_head *head);
 extern void list_splice_sorted(struct list_head *list, struct list_head *head);
diff --git a/src/expression.c b/src/expression.c
index 6c5140b749f9..ee1fe34e2de9 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -1048,12 +1048,6 @@ static void compound_expr_print(const struct expr *expr, const char *delim,
 	}
 }
 
-void compound_expr_add(struct expr *compound, struct expr *expr)
-{
-	list_add_tail(&expr->list, &compound->expr_set.expressions);
-	compound->expr_set.size++;
-}
-
 void compound_expr_remove(struct expr *compound, struct expr *expr)
 {
 	compound->expr_set.size--;
-- 
2.30.2

