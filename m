Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19B22877C3
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Feb 2026 02:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770259309; cv=none; b=YQW/ZZTC8fZ58ZkzKG4gVui8sn4nbg6DHvdKaRrtHGfcVR9YUI+Q4iE+Yi8x85ZgHHPVNLphIs5WHdpDhEJPPGubi54+CPlaSPZoJ/7cA9JleLt+RKTBeuNgpPK31PWSAZf9Jim3ZMTe/k2aAKiMpBACcAtV5j6hcMjHE+RDFeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770259309; c=relaxed/simple;
	bh=cXEVPzw1AmqdiOLFBi8gVIc/e4LuG8MdIwd1sFHDfjs=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KXIBqOyGdjNjEJSLkwzAJa4oS7gddr5FcFXWNwIh2X8r1YWXkUrAKaGOQf1usGuD2TjvCIpiVY5a52zHxKOLtTNmqhrUy93SdFTFNEZAXrIp6/bN8a0zM1F/pilxIJcfE+wnaBWEcFGVw4+DJj7J62lrDtTkIW/CYIR2Sdjjj8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=L+10FmXq; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="L+10FmXq"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D6AC96087B
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Feb 2026 03:41:47 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1770259308;
	bh=Cbux5ATY8IYjs9owI/ti87Pi5MWYUI/MEoBNoww1mbY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=L+10FmXqTrIpJjtZa9GvNnyKu9z4ks6BMmbyWxTLqYaONOt/r8LDWes5LjscnucR2
	 Dc4j0yM54JSstQBJBDfQDZcC3ceCLJGdfUwaDfRD4D83ZkDYZP2djsbgK3RdtbjGk0
	 0mnTVd7I1r4COB1ab7lEY5TFPUebIAGx0QZTn6qDEaj7bWoFnXqCplkecL+sSa8Sez
	 ay+nBZ5v1Zhw2ZSf92RCPVtCz2Nufcp3SqaLk8molTRXLqHZG7EJ2IsR0l910TeEPA
	 ige8nuWrLvjYxDbz7AkBfFBJESKCcMT7cgRdzfeIsYcOQpgE8S1TW+mkUpJVuzIa8v
	 63P+Sxgc2/SUg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 11/20] src: move __set_expr_add() to src/intervals.c
Date: Thu,  5 Feb 2026 03:41:20 +0100
Message-ID: <20260205024130.1470284-12-pablo@netfilter.org>
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

Where this is only used.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/expression.h | 1 -
 src/expression.c     | 5 -----
 src/intervals.c      | 5 +++++
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index bce75d29ee2c..7abff4ba72ab 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -537,7 +537,6 @@ struct expr *list_expr_to_binop(struct expr *expr);
 
 extern struct expr *set_expr_alloc(const struct location *loc,
 				   const struct set *set);
-void __set_expr_add(struct expr *set, struct expr *elem);
 void set_expr_add(struct expr *set, struct expr *elem);
 void set_expr_remove(struct expr *expr, struct expr *item);
 
diff --git a/src/expression.c b/src/expression.c
index 415d678ba2e3..23ff42ac9331 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -1454,11 +1454,6 @@ struct expr *set_expr_alloc(const struct location *loc, const struct set *set)
 	return set_expr;
 }
 
-void __set_expr_add(struct expr *set, struct expr *elem)
-{
-	list_add_tail(&elem->list, &expr_set(set)->expressions);
-}
-
 void set_expr_add(struct expr *set, struct expr *elem)
 {
 	struct expr_set *expr_set = expr_set(set);
diff --git a/src/intervals.c b/src/intervals.c
index 743e034519b5..c9e278b2a895 100644
--- a/src/intervals.c
+++ b/src/intervals.c
@@ -13,6 +13,11 @@
 #include <intervals.h>
 #include <rule.h>
 
+static void __set_expr_add(struct expr *set, struct expr *elem)
+{
+	list_add_tail(&elem->list, &expr_set(set)->expressions);
+}
+
 static void set_to_range(struct expr *init);
 
 static void __setelem_expr_to_range(struct expr **exprp)
-- 
2.47.3

