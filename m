Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A7DF245012
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Apr 2025 10:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744194751; cv=none; b=k8u7lFSH8I0Jn0mPPZgqEv3C2hjzj63hBb12YgGMIDgL9qmRCC1GVD0BSTdfBJDsHjBTOfM41vtSd2h5PWNvugpKUl3fCf91Jl8/QByaWoXGAHHPfx1GBIxvuBPP4Q/dXCDOCl5DdzS5HFlDaT/oh0dl6SaWtf0q9UrEbWuFsR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744194751; c=relaxed/simple;
	bh=kuASB+nY/IX7BcvSlvLzHHjZqwyVgPZq3XPywQCrl+8=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=HcUQcgvstz+gh+xQQpPDEpXAh1QjR4L9g8JQaxJunU9oRzwXzqyn5dGIftSOQsBY4FqV6Lt8pYL6WQnUJID2di3J4Xo5hWY9QUEwLKBGIQ8BE1ChdnY6jSxZXldkVyM5VejhOa1X7itbU0UT/pX4IVaynLtAuOj6TQ7CQ7mzwPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=wLklzO6l; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=BnmiEo/9; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="wLklzO6l";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="BnmiEo/9"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 23AEA605CE; Wed,  9 Apr 2025 12:32:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1744194744;
	bh=bBRJHYXxZOooU1oUc2S0KFz7x1IgACPPFCfqobz8mUA=;
	h=From:To:Subject:Date:From;
	b=wLklzO6lmlKWZJObJQv0Qgd5+OjqGKuk7lRz+7ovZclnTwlaq3Xeoq8D/0h08ozOM
	 ogPT093zdzeLGtJ/GEcrcUbhvROTfPRftnXBEH+ZQLhQ2vCzgkCpFwOhSR7B9nmVrY
	 Acs5HS4p8TImq12lO18/WefSySfk3R4GA2ueIn8uIKj92TFJfy5mYlldWhxD58uD/j
	 LNrLN2JL2ppxU60OUKY3fSYvVh0F3QJTUBdX97ZKKMm2XkuXulU4kJvQizRdbloJMl
	 4PEQXDbZqnlVOy822TYwTEvklMXpVxfskvTTiEuu92vx4Neks/tdCmvBo7cM/ZwFkP
	 PLG2juhsobBaw==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id B21506058C
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Apr 2025 12:32:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1744194743;
	bh=bBRJHYXxZOooU1oUc2S0KFz7x1IgACPPFCfqobz8mUA=;
	h=From:To:Subject:Date:From;
	b=BnmiEo/9lX8UTEDz6rZRqxwkemaaj5JVgxHN1/0BDkQxTCh0x5WrqM44qRIAHskka
	 Ymdj4mKnVPMwk+v2yG7IXA5ME/oIy2qCQK/whFvjWiwBXr4nnNLFqW3MZhcmF3Be7Y
	 sGJANrMGZ0Pe2BcfLY3/GDkT+ncpZmoJfJx02oQWHNKqa5fwn9FHyxcOzLJjEbyRxe
	 wzhWEKbfrL28ajwTGIhrrp7uOIGh4iwgMj373FXGadbkePCEQvu/zjHVuwcWH8PdnX
	 VDDhNRiAwTaPAzEjQSjRAiiL4gGv4AsBzhQ8kzIWPvhV0DfMdk1reOH3JIm4oxWc2A
	 8T9np3A5N9p5w==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] optimize: invalidate merge in case of duplicated key in set/map
Date: Wed,  9 Apr 2025 12:32:20 +0200
Message-Id: <20250409103220.441751-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

-o/--optimize results in EEXIST error when merging two rules that lead
to ambiguous set/map, for instance:

 table ip x {
        chain v4icmp {}
        chain v4icmpc {}

        chain y {
                ip protocol icmp jump v4icmp
                ip protocol icmp goto v4icmpc
        }
 }

which is not possible because duplicated keys are not possible in
set/map. This is how it shows when running a test:

 Merging:
 testcases/sets/dumps/sets_with_ifnames.nft:56:3-30:            ip protocol icmp jump v4icmp
 testcases/sets/dumps/sets_with_ifnames.nft:57:3-31:            ip protocol icmp goto v4icmpc
 into:
       ip protocol vmap { icmp : jump v4icmp, icmp : goto v4icmpc }
 internal:0:0-0: Error: Could not process rule: File exists

Add a new step to compare rules that are candidate to be merged to
detect colissions in set/map keys in order to skip them in the next
final merging step.

Fixes: fb298877ece2 ("src: add ruleset optimization infrastructure")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/optimize.c | 40 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 39 insertions(+), 1 deletion(-)

diff --git a/src/optimize.c b/src/optimize.c
index 139bc2d73c3c..5b7b0ab62fbc 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -138,6 +138,8 @@ static bool __expr_cmp(const struct expr *expr_a, const struct expr *expr_b)
 			return false;
 
 		return !strcmp(expr_a->identifier, expr_b->identifier);
+	case EXPR_VALUE:
+		return !mpz_cmp(expr_a->value, expr_b->value);
 	default:
 		return false;
 	}
@@ -548,6 +550,8 @@ struct merge {
 	/* statements to be merged (index relative to statement matrix) */
 	uint32_t	stmt[MAX_STMTS];
 	uint32_t	num_stmts;
+	/* merge has been invalidated */
+	bool		skip;
 };
 
 static void merge_expr_stmts(const struct optimize_ctx *ctx,
@@ -1379,8 +1383,42 @@ static int chain_optimize(struct nft_ctx *nft, struct list_head *rules)
 		}
 	}
 
-	/* Step 4: Infer how to merge the candidate rules */
+	/* Step 4: Invalidate merge in case of duplicated keys in set/map. */
+	for (k = 0; k < num_merges; k++) {
+		uint32_t r1, r2;
+
+		i = merge[k].rule_from;
+
+		for (r1 = i; r1 < i + merge[k].num_rules; r1++) {
+			for (r2 = r1 + 1; r2 < i + merge[k].num_rules; r2++) {
+				bool match_same_value = true, match_seen = false;
+
+				for (m = 0; m < ctx->num_stmts; m++) {
+					if (!ctx->stmt_matrix[r1][m])
+						continue;
+
+					switch (ctx->stmt_matrix[r1][m]->type) {
+					case STMT_EXPRESSION:
+						match_seen = true;
+						if (!__expr_cmp(ctx->stmt_matrix[r1][m]->expr->right,
+							        ctx->stmt_matrix[r2][m]->expr->right))
+							match_same_value = false;
+						break;
+					default:
+						break;
+					}
+				}
+				if (match_seen && match_same_value)
+					merge[k].skip = true;
+			}
+		}
+	}
+
+	/* Step 5: Infer how to merge the candidate rules */
 	for (k = 0; k < num_merges; k++) {
+		if (merge[k].skip)
+			continue;
+
 		i = merge[k].rule_from;
 
 		for (m = 0; m < ctx->num_stmts; m++) {
-- 
2.30.2

