Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E12C2E7F2C
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Aug 2025 09:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755768227; cv=none; b=XMgdssZK/x+lvWL9l1eflgOtFoFerS2kendSTYNHYHGLQ546lvZFGWcdQ2gW6+68BGknrvX78sKOcIhkXsAXhfQYC6/gx+PkrSpuAI9VDVmJRPM0MzG+3gfBV1hpZjiR0p08YvUJhLnJGkIgPtjgfT7iFaBA4e/oyg5lsKfBBFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755768227; c=relaxed/simple;
	bh=Cboh6fE1aqt1URDfysw2BUWQ4t1kRAMWF9Dn9LLljYc=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=N6+A7L7YTwIiSIZxyv9rwIJCynUNNWLxsyphUpapFX2odKG6OkVLV6cLMUVx2Xxb7IzYLTjIu2WGwOA+qRNtJe+pjJW0dBGRXhfVyVDm3HXV4ww98gNKZ9wn/EZsv3BTsl/W3iMutQVHu/XqjtcwVmdNYv+8t1u1EfWO+OPt6zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=XLvBGZld; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=UZC+PAUd; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="XLvBGZld";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="UZC+PAUd"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 304AB602B1; Thu, 21 Aug 2025 11:23:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755768223;
	bh=t9s0H5mZ+ZirGOgWiV++z0Wz3C+To8R+usqWFcRSZk8=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=XLvBGZldx1VEhnV9f62rxIkjarXYDrOwXmKUeiITc62PRQ7eqDliqthOVOIAmwqbL
	 HynF8LVzyRFiu8dBH+vsPYgbo0Yf4yHUFry2YgZ5m71m21zF0YOjbeXEDt87c6JDFm
	 X5vLNmtGWp6S3l339Wq9fT0NlkpUUQstbZM7fTFMS5p3uR3sg4urOiDRtrMBeJ7/DT
	 opZ6EpNBz6Kz82UIZEWV22q4SCybtEfWvx6KdwOklM7po+n9bidlKzAwo90PM/sp/j
	 TWa7f0Xs5qZZUPMyxpOms2S+tsqibYnb9Qc+7scFo7U1Nyn0AWPfc8w/Yw3E26jhBv
	 4qIU19ZtnHRpQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D0EC6602AB
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Aug 2025 11:23:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755768222;
	bh=t9s0H5mZ+ZirGOgWiV++z0Wz3C+To8R+usqWFcRSZk8=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=UZC+PAUdLrXjyODOOpch21BBnV8DSrZK6lH6lLHtuaBeFkiADEMPdXHarmqZElhNn
	 4FleHvjdhgHgwrovXCdiZ7X7mmYC5Com2grWY99I5ccBS7oGbznQFeQoEMd/GPKq6h
	 la5R75WM13tdcfewSlEhSacflt3tSANedsQPkTmYGppfHbmBwjNj9S2QGP4OYMnT3J
	 LSGqbaa410G04SlEhl3mriF17+y17FB+MPs57gkl/+1xRTcLwVAJFTCVnzmxkusstO
	 AllyI+Adym7p0dphm4BmzZdQ4dSYyjJJMdqsTUdzdXx7mkLuZL+5zcf93hasNJ5znb
	 LjbCaZi7zM+FA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2 07/11] expression: remove compound_expr_add()
Date: Thu, 21 Aug 2025 11:23:26 +0200
Message-Id: <20250821092330.2739989-8-pablo@netfilter.org>
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

