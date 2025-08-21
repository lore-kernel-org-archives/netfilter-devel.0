Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46CBD2F0C5B
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Aug 2025 09:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755767873; cv=none; b=F28BHn9b3aSOfOcUctDfCelCivCQNKWTyqWiwKrPAh68tLX/M4xsh6V+TIFyRhjo4WXvMZBWjoMblDlBsATlBEOFOH4m+cPEJ0X99hU/4ect8sJl9J1CxrreDsNTZF8zuDvRlqKBgkXUR0a8uwaqSo6Wggp2zE7l8JQGA085xTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755767873; c=relaxed/simple;
	bh=63RBJE0Yqep/QDZYvgZ/KF0HP9Sr/I9wD1DtsgXNfvM=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=tsPUI0AXg2aCTQXz8SM3lfYvSdbuoPB4JF7S3GayhkpwR3S+OQMJ6xzt9R5PdNzMbcAa3Gjma6Jk6bYDzkjncn74Igh5v0awC9PJscU0XuTPYGsmeV8iQLoQmM/Ky07qTpaezw7K2IWIXjUzDA9QHpHl2+7NCLDAOsBy+E1rqVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=AHQcil6r; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=AHQcil6r; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="AHQcil6r";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="AHQcil6r"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 7069660294; Thu, 21 Aug 2025 11:17:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755767865;
	bh=lrceeMEfBnvQvvBXWX5LC+w1WSQflE5M5X11LzNSJbc=;
	h=From:To:Subject:Date:From;
	b=AHQcil6r07v96IO1dAOl6cIPXsD7xSF7oR0XzwdfMhAWH8d5adCRSxnTNcwXXL783
	 24p6QcPvB1RoQ4Gvyb+a6jjINbnokJrsFwnMhyWTM1uZIHwl2GTUV+Q75r0E9EQHF3
	 RaCPFlBbfpivWWx1PUdCkUHPPAiMJVwRuJJlHocBheMMo3WewCDHaOnu41WQ6IK4Lt
	 a8ltfXO669IunJTmwQ4/1QodVCT2F8nMYAtAuIAKvZINHtl/UGiFme3on4XAUvWmVL
	 nSOcXztg1ZraAwJx1cL8US+p22uCr+bw6GHAxZchYyHU2KNYMKaz78uxVo9ay/X+8E
	 FST+72Gl6rhkQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id F12B760292
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Aug 2025 11:17:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755767865;
	bh=lrceeMEfBnvQvvBXWX5LC+w1WSQflE5M5X11LzNSJbc=;
	h=From:To:Subject:Date:From;
	b=AHQcil6r07v96IO1dAOl6cIPXsD7xSF7oR0XzwdfMhAWH8d5adCRSxnTNcwXXL783
	 24p6QcPvB1RoQ4Gvyb+a6jjINbnokJrsFwnMhyWTM1uZIHwl2GTUV+Q75r0E9EQHF3
	 RaCPFlBbfpivWWx1PUdCkUHPPAiMJVwRuJJlHocBheMMo3WewCDHaOnu41WQ6IK4Lt
	 a8ltfXO669IunJTmwQ4/1QodVCT2F8nMYAtAuIAKvZINHtl/UGiFme3on4XAUvWmVL
	 nSOcXztg1ZraAwJx1cL8US+p22uCr+bw6GHAxZchYyHU2KNYMKaz78uxVo9ay/X+8E
	 FST+72Gl6rhkQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/2] evaluate: simplify set to list normalisation for device expressions
Date: Thu, 21 Aug 2025 11:17:40 +0200
Message-Id: <20250821091741.2739718-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When evaluating the list of devices, two expressions are possible:

- EXPR_LIST, which is the expected expression type to store the list of
  chain/flowtable devices.

- EXPR_SET, in case that a variable is used to express the device list.
  This is because it is not possible to know if the variable defines
  set elements or devices. Since sets are more common, EXPR_SET is used.

In the latter case, this list expressed as EXPR_SET gets translated to
EXPR_LIST. Before such translation, the EXPR_VARIABLE is evaluated,
therefore all variables are gone and only EXPR_SET_ELEM are possible in
expr_set_to_list().

Remove the EXPR_VALUE and EXPR_VARIABLE cases in expr_set_to_list()
since those are never seen. Add BUG() in case any other expressions than
EXPR_SET_ELEM is seen.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
This can be postponed after 1.1.5 including the JSON regression fix is released.

 src/evaluate.c | 16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index aaeb7b4e18d4..a2ca3aaea35c 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -5460,27 +5460,13 @@ static struct expr *expr_set_to_list(struct eval_ctx *ctx, struct expr *dev_expr
 		list_del(&expr->list);
 
 		switch (expr->etype) {
-		case EXPR_VARIABLE:
-			expr_set_context(&ctx->ectx, &ifname_type,
-					 IFNAMSIZ * BITS_PER_BYTE);
-			if (!evaluate_expr_variable(ctx, &expr))
-				return false;
-
-			if (expr->etype == EXPR_SET) {
-				expr = expr_set_to_list(ctx, expr);
-				list_splice_init(&expr_list(expr)->expressions, &tmp);
-				expr_free(expr);
-				continue;
-			}
-			break;
 		case EXPR_SET_ELEM:
 			key = expr_clone(expr->key);
 			expr_free(expr);
 			expr = key;
 			break;
-		case EXPR_VALUE:
-			break;
 		default:
+			BUG("invalid expression type %s\n", expr_name(expr));
 			break;
 		}
 
-- 
2.30.2

