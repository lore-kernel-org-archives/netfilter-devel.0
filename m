Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B2512BEC2A
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Feb 2026 02:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770259313; cv=none; b=XWuHOtv3Rjrz0ELuiUQSAqjtO9e16fIEno3jJwLtiq6zvhVIMglcz8pVE25oa4dmTWonOSpy062MPReNe0ktR+qoLnMOPljlmjOPVGrIWCLdKM8PM6Pvpz8RTDKl5TSZgniSE9ADgKJwya/+owqSZ35/uI/5InUXeMPY5l7Snys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770259313; c=relaxed/simple;
	bh=EGHR9BHwvy2O98pkYzOKbCMrBNs3XDaWIyH3ZwirqIc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s6GTy4AiEq1d+nOHyPKEwiwtn5krq0+axV7QqB2U6nTG/IyHLfYjj1+ICjaIcryZSs0RSaVKG3oi96XiC+jH0caNI6ke38c7+zE7PsvU11Y2MuTKDdRykP0j+Cys+tlB5PYti1wnSvuQVBVWe/dlxXpATJnasaSCYnrAbO4Al+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=LRD50zpz; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="LRD50zpz"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9BB9A60882
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Feb 2026 03:41:51 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1770259311;
	bh=xwHgq+joay7Gk7qutFC4tZAZuycdXHLPk11dFo7NK34=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=LRD50zpztKMYShY30OePSFRNeNy85Vcw4nX/Q+J7hP2gHDaWKdtDatfm9xbDCs+XA
	 JAw2CGGDMtlYpJpOhG0kwXjkwM0S0wbEpQnVcHU0j7bLht7P2AT5+TvZZoic397sQF
	 JUAOWHRaHDp54WCrfv51hhFUeiC8p64IoPeJ2fg+kKU/z7lBdpYcSXBSw5ZLHdKj2N
	 g+9HohRTgSpVbjLK9t4NzuKxM7DRjj9KFVT062r4kjI+LLofspHrhXU+DMtOO9HocZ
	 vrVAbEtwsT1AXFArUEY3Y+BbRE0eevMhAYMf5z6324XxkBX60Kuwtmn1Dv2+QhZ1JT
	 uMGn0t0o0VNLg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 15/20] segtree: disentangle concat_range_aggregate()
Date: Thu,  5 Feb 2026 03:41:24 +0100
Message-ID: <20260205024130.1470284-16-pablo@netfilter.org>
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

Consolidate calls to expr_value() in concat_range_aggregate() to
simplify this code.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/segtree.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/src/segtree.c b/src/segtree.c
index 69d6f513c55d..06f8be92ccfa 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -351,7 +351,7 @@ static int range_mask_len(const mpz_t start, const mpz_t end, unsigned int len)
  */
 void concat_range_aggregate(struct expr *set)
 {
-	struct expr *i, *start = NULL, *end, *r1, *r2, *next, *r1_next, *tmp;
+	struct expr *i, *start, *end, *prev = NULL, *r1, *r2, *next, *r1_next, *tmp;
 	struct list_head *r2_next;
 	int prefix_len, free_r1;
 	mpz_t range, p;
@@ -359,21 +359,22 @@ void concat_range_aggregate(struct expr *set)
 	list_for_each_entry_safe(i, next, &expr_set(set)->expressions, list) {
 		assert(i->etype == EXPR_SET_ELEM);
 
-		if (!start) {
-			start = i;
+		if (!prev) {
+			prev = i;
 			continue;
 		}
-		end = i;
+		start = expr_value(prev);
+		end = expr_value(i);
 
 		/* Walk over r1 (start expression) and r2 (end) in parallel,
 		 * form ranges between corresponding r1 and r2 expressions,
 		 * store them by replacing r2 expressions, and free r1
 		 * expressions.
 		 */
-		r2 = list_first_entry(&expr_concat(expr_value(end))->expressions,
+		r2 = list_first_entry(&expr_concat(end)->expressions,
 				      struct expr, list);
 		list_for_each_entry_safe(r1, r1_next,
-					 &expr_concat(expr_value(start))->expressions,
+					 &expr_concat(start)->expressions,
 					 list) {
 			bool string_type = false;
 
@@ -452,15 +453,15 @@ next:
 			mpz_clear(range);
 
 			r2 = list_entry(r2_next, typeof(*r2), list);
-			concat_expr_remove(expr_value(start), r1);
+			concat_expr_remove(start, r1);
 
 			if (free_r1)
 				expr_free(r1);
 		}
 
-		set_expr_remove(set, start);
-		expr_free(start);
-		start = NULL;
+		set_expr_remove(set, prev);
+		expr_free(prev);
+		prev = NULL;
 	}
 }
 
-- 
2.47.3

