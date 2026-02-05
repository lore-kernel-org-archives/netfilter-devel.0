Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5705E2BFC8F
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Feb 2026 02:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770259299; cv=none; b=r7jBvorP0VWvRh8qe6H1ZMJNDMctPiUy0GuWl6BWrKrDuKm5t2zwwSXg72czsU28EwCAW3vZRyUdQlLn2DJtRTRLND5K+wauzPqRNlYKQplyXLOuyTtta4PKB6PC3D+5VCEBMATeqQwrWypek+wzmj+e4oGcIeYN8dZoQje/JTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770259299; c=relaxed/simple;
	bh=l+/ND5u2mytqZyskWxqkj3qkZdsM3DTvcIDSa/4ePNs=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T1Q7a7mib3UuYf/GADDWHnizbozlXJlPzIj2+AjFYjiEwE+zWxES7Q54sjIavhUKgzD+DS3R2CiUfm8d3AifJ1itOM+/3PBTjthOd5qrBeVtmfNf4FUeQLSW3OYO4uR5ZAbVwQ0fIcUnUTWWHPnk98w4RPvUQ/VUgK2l+SgwbAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Fwl4b9dn; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Fwl4b9dn"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id C322A60871
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Feb 2026 03:41:37 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1770259297;
	bh=vR8nyCoXxD6TH7okf8h5beVy4J1wPWf7miOr3H0ZfP8=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Fwl4b9dn6BA+qNedrXThnmC/Mydg7bSNTLwCdcnnFq6SpPpQ8FRu4A7DqPagDhqxw
	 nxAvhPFvwO0wY1nG6ae8C+fl6o+02JrHzGXeJflP7zZ79ocPe5iU7te03CU8WGi/lT
	 LHZ7cZ1OXS3ErCeRnZSRKKx+DhNYT0YbWNvco2XJFHBZ9d9XcGqLI70oAS+EGWKPU9
	 8YgVEWEz4Orm9GWJDTVP1dicqbgHm4kyZsyzBGRAVbF0Uc5i2/rFBVa/E3JzB+SpmM
	 FpLeHh+UHqgy/4OOC4V0KGok7rGpV6LXMsYxML9JiMJt97Bu6v27ruwX1hsZTLBGnW
	 Yef2E17Tczd4w==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 02/20] src: allocate EXPR_SET_ELEM for EXPR_SET in embedded set declaration in sets
Date: Thu,  5 Feb 2026 03:41:11 +0100
Message-ID: <20260205024130.1470284-3-pablo@netfilter.org>
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

Normalize the representation so the expressions list in EXPR_SET always
contains EXPR_SET_ELEM. Add assert() to validate this.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c     | 3 ++-
 src/parser_bison.y | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 13e0c6916ac7..e6689adf0880 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2070,7 +2070,8 @@ static int expr_evaluate_set(struct eval_ctx *ctx, struct expr **expr)
 	const struct expr *elem;
 
 	list_for_each_entry_safe(i, next, &expr_set(set)->expressions, list) {
-		/* recursive EXPR_SET are merged here. */
+		assert(i->etype == EXPR_SET_ELEM);
+
 		if (list_member_evaluate(ctx, &i) < 0)
 			return -1;
 
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 361f43d95104..6c0e29c82065 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -4556,7 +4556,7 @@ set_list_expr		:	set_list_member_expr
 
 set_list_member_expr	:	opt_newline	set_expr	opt_newline
 			{
-				$$ = $2;
+				$$ = set_elem_expr_alloc(&@$, $2);
 			}
 			|	opt_newline	set_elem_expr	opt_newline
 			{
-- 
2.47.3

