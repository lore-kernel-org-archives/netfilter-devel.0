Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C20261E231E
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Jun 2025 21:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750111058; cv=none; b=Obbysg9VSGhsNL5yqNtJeGhRe8Cn1CPcJvuCBeRgIyLn2goIDNqLv1mOrX3xk9DHB+Ufk+uaI5zSLRYq1kXET5JbHYdRnRK4Cpsxi56FmAuCTAJ5zDptcAlPJjaMAg0HFXng9ftZnq0v3cDCip4z7TM1v/+CDnHfNeF2O1R5mgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750111058; c=relaxed/simple;
	bh=GLeOwD1Qu9cE1RCHe36WrqUhXpSFHHWGnYDg029Nmfk=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=q3qia4bDV1ZmWKHJvI1ack0jPioI5qmlAx7dfHE6ez12hnMc4ynJKZ1anHjWnvKNrIP7fq1q7uNHtg4Fur1Ir5nLrtsYZRnqP6f+DY4f1fNOtNFTVvsKmPsAABGVC9IxdD27Ug2cVtouqElUK3wFZ2mIKm3AwqNSPa7OQ+YejmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=RyR+40Pf; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=b1BCFUZA; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="RyR+40Pf";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="b1BCFUZA"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 13204603B9; Mon, 16 Jun 2025 23:57:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1750111048;
	bh=yQK1t3cboLBm4F7gN/SOjK0eKuAbsXTwkppW0YXceC4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=RyR+40Pf7E+hZGIelUlBkiOxTOR/YrSemkSe/PWc8/fZMIEh7PO1QXTKoi/Fevm1E
	 V0dGtGOTBOqC+EaSlrV0SYb9x7KKodKkWI3ZWv8KtOwTaslcahKsM8iX36ssBMYAcO
	 pNDqxuVAU2FcwaZRYH37Wl/fbG85WtWt2lHOZRkrUGbsf1Eex4oDKHQ15IjLRyDlkI
	 2S21P8IZQ7eIzVdJ2m5nQsigu9kT8oEgqirXH6K0Sep3nxEEKLX+XTfda4tbFR3DSK
	 PP3V4tAdkfMotRImIqaoc79/KteHNTPOUojTTk7DJ+1FZkwOM6W/R0sDEZEg9B7ktd
	 PNOjITTjA62hw==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A4C2F603B6
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Jun 2025 23:57:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1750111047;
	bh=yQK1t3cboLBm4F7gN/SOjK0eKuAbsXTwkppW0YXceC4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=b1BCFUZA+yhzo3+N8oExuaCjI5lv6b0E0gT/xzNcvQl4DcATXns4og0wqbuiwYGbE
	 9artzvctrkyjY9FSD1uxqzAvr9zDGGlDyzZpLM2mkh21TBn4OWd+gTYhMneoqMKdny
	 SzsWgyYeURTZ5IlQVeUDBOdD9vtOHNm+2Jq8WL23zWYBX1Gismn1lxkJDq6QjMEhUS
	 NjbjaAokp21c/PQA3NNm0QJ+8UpndynNRvlpigO7wPcLKvJf1x8fOmKMEm7BTxlKiM
	 /nTmadCEwTMZDoTSg0Cwe866m41f6Ca+NVviwmuMOmLt6/fFE8Y3bISaUWHcMrzuFv
	 Uh3oAo+ZxLNug==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/3,v2] src: use constant range expression for interval+concatenation sets
Date: Mon, 16 Jun 2025 23:57:21 +0200
Message-Id: <20250616215723.608990-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250616215723.608990-1-pablo@netfilter.org>
References: <20250616215723.608990-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Expand 347039f64509 ("src: add symbol range expression to further
compact intervals") to use constant range expression for elements with
concatenation of intervals.

Ruleset with 100k elements of this type:

 table inet x {
        set y {
                typeof ip saddr . tcp dport
                flags interval
                elements = {
			0.1.2.0-0.1.2.240 . 0-1,
			...
		}
	}
 }

Memory consumption for this set:

Before: 123.80 Mbytes
After:   80.19 Mbytes (-35.23%)

This patch keeps the workaround 2fbade3cd990 ("netlink: bogus
concatenated set ranges with netlink message overrun") in place.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: fix error hint when flags interval is missing in set declaration

 src/evaluate.c |  5 +++--
 src/netlink.c  | 11 +++++++++++
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 9c7f23cb080e..b157a9c9d935 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1879,6 +1879,7 @@ static int expr_evaluate_set_elem(struct eval_ctx *ctx, struct expr **expr)
 		switch (elem->key->etype) {
 		case EXPR_PREFIX:
 		case EXPR_RANGE:
+		case EXPR_RANGE_VALUE:
 			key = elem->key;
 			goto err_missing_flag;
 		case EXPR_CONCAT:
@@ -1886,6 +1887,7 @@ static int expr_evaluate_set_elem(struct eval_ctx *ctx, struct expr **expr)
 				switch (key->etype) {
 				case EXPR_PREFIX:
 				case EXPR_RANGE:
+				case EXPR_RANGE_VALUE:
 					goto err_missing_flag;
 				default:
 					break;
@@ -2366,9 +2368,8 @@ static int expr_evaluate_symbol_range(struct eval_ctx *ctx, struct expr **exprp)
 	left = range->left;
 	right = range->right;
 
-	/* concatenation and maps need more work to use constant_range_expr. */
+	/* maps need more work to use constant_range_expr. */
 	if (ctx->set && !set_is_map(ctx->set->flags) &&
-	    set_is_non_concat_range(ctx->set) &&
 	    left->etype == EXPR_VALUE &&
 	    right->etype == EXPR_VALUE) {
 		constant_range = constant_range_expr_alloc(&expr->location,
diff --git a/src/netlink.c b/src/netlink.c
index 73fe579a477c..94cf177213fd 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -285,6 +285,17 @@ static int __netlink_gen_concat_key(uint32_t flags, const struct expr *i,
 			byteorder_switch_expr_value(value, expr);
 
 		i = expr;
+		break;
+	case EXPR_RANGE_VALUE:
+		if (flags & EXPR_F_INTERVAL_END)
+			mpz_init_set(value, i->range.high);
+		else
+			mpz_init_set(value, i->range.low);
+
+		if (expr_basetype(i)->type == TYPE_INTEGER &&
+		    i->byteorder == BYTEORDER_HOST_ENDIAN)
+			byteorder_switch_expr_value(value, i);
+
 		break;
 	case EXPR_PREFIX:
 		if (flags & EXPR_F_INTERVAL_END) {
-- 
2.30.2

