Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69AA12BEFFE
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Feb 2026 02:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770259306; cv=none; b=YsNN1w20+9eKC39O90IUVklcRmKjP2i2hfLccL3xCcbPrIop147RuPD+HtiRBURivHG8hZmqkbG4lGZe+d//x6ONb6gJQoWP0/6UnUAkEh9nn0UTVb9/HyjikiObfYbL0jeG+JkkWIOAJNZXSD9Y4g/IinYPHMFGj3OqJk9fHMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770259306; c=relaxed/simple;
	bh=UZu+eTDyxj/knCtXU26ScdDB9LO+hhWNqK0qJCgE/io=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KkONzZ+Xh/kLvB1llCqCM5VY7FWonAWQNn3FE0KfdiAw0DU8E+z/stgF+/AQATXDOxyMhmJeAXtURYgj6NW4CC62e/NKjTxNsdHaIK5OTkjqPdaAxCPO/4Vrbes+PGRn0Rd6QQcxP0qPF0T8FDlR3nVydUbC88fYPqJemCp1S28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=QIwOWogO; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="QIwOWogO"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 556AF6087B
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Feb 2026 03:41:44 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1770259304;
	bh=5bNs1cz4KbWpgLb6PnGY0oaEDccJxeqO3VhQX3t6jxk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=QIwOWogOkqCwpBZwnMhQ6oEsEzGFKQCzOKkg7p9FyZKBXLgjnCF+Uisdm8DBk//qm
	 bqPb9bnjZm3gyaccdNrqXFxMEflErDw6zEtul4Ug/6Hb1IzFyaspbYVv2GcTnhwU94
	 Rq9W96rYvrBm13cEPTIoy4U3jilwRESconQBDsAQuxt3qEv2sA4XM3zkazvFC+QGSj
	 g6JHSxqarclnXpKw24v85zvRIkYItVIaF0axZ6fmgViuAxubWAXVrrweROUjkKLXx+
	 W/9uW9ov60rf+n0Fs2O61Huh3FHVo4HA1cXr94CJxWHoGrqLRx4qisuuRQmnmlwCVM
	 ZsX8TBUGsNVlg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 08/20] src: remove EXPR_SET_ELEM in range_expr_value_{low,high}()
Date: Thu,  5 Feb 2026 03:41:17 +0100
Message-ID: <20260205024130.1470284-9-pablo@netfilter.org>
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

Call range_expr_value_{low,high}() with the key instead to skip one
level of indirection.

This is to prepare for the future removal of EXPR_SET_ELEM.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/expression.c |  4 ----
 src/intervals.c  | 12 ++++++------
 src/segtree.c    |  8 ++++----
 3 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/src/expression.c b/src/expression.c
index fac4901d8ecc..415d678ba2e3 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -1799,8 +1799,6 @@ void range_expr_value_low(mpz_t rop, const struct expr *expr)
 		return range_expr_value_low(rop, expr->left);
 	case EXPR_MAPPING:
 		return range_expr_value_low(rop, expr->left);
-	case EXPR_SET_ELEM:
-		return range_expr_value_low(rop, expr->key);
 	default:
 		BUG("invalid range expression type %s", expr_name(expr));
 	}
@@ -1826,8 +1824,6 @@ void range_expr_value_high(mpz_t rop, const struct expr *expr)
 		return range_expr_value_high(rop, expr->right);
 	case EXPR_MAPPING:
 		return range_expr_value_high(rop, expr->left);
-	case EXPR_SET_ELEM:
-		return range_expr_value_high(rop, expr->key);
 	default:
 		BUG("invalid range expression type %s", expr_name(expr));
 	}
diff --git a/src/intervals.c b/src/intervals.c
index 0a1e8fc79ecd..4f15095c4bb4 100644
--- a/src/intervals.c
+++ b/src/intervals.c
@@ -191,8 +191,8 @@ static void setelem_automerge(struct set_automerge_ctx *ctx)
 		if (expr_type_catchall(i->key))
 			continue;
 
-		range_expr_value_low(range.low, i);
-		range_expr_value_high(range.high, i);
+		range_expr_value_low(range.low, i->key);
+		range_expr_value_high(range.high, i->key);
 
 		if (!prev) {
 			set_prev_elem(&prev, i, &prev_range, &range);
@@ -439,8 +439,8 @@ static int setelem_delete(struct list_head *msgs, struct set *set,
 			mpz_bitmask(range.low, len);
 			mpz_bitmask(range.high, len);
 		} else {
-			range_expr_value_low(range.low, i);
-			range_expr_value_high(range.high, i);
+			range_expr_value_low(range.low, i->key);
+			range_expr_value_high(range.high, i->key);
 		}
 
 		if (!prev && elem->key->flags & EXPR_F_REMOVE) {
@@ -603,8 +603,8 @@ static int setelem_overlap(struct list_head *msgs, struct set *set,
 		if (expr_type_catchall(i->key))
 			continue;
 
-		range_expr_value_low(range.low, i);
-		range_expr_value_high(range.high, i);
+		range_expr_value_low(range.low, i->key);
+		range_expr_value_high(range.high, i->key);
 
 		if (!prev) {
 			prev = elem;
diff --git a/src/segtree.c b/src/segtree.c
index 37bdcb5867cf..5e03122ebfb7 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -96,9 +96,9 @@ struct expr *get_set_intervals(const struct set *set, const struct expr *init)
 			set_expr_add(new_init, expr_clone(i));
 			break;
 		default:
-			range_expr_value_low(low, i);
+			range_expr_value_low(low, i->key);
 			set_elem_expr_add(set, new_init, low, 0, i->byteorder);
-			range_expr_value_high(high, i);
+			range_expr_value_high(high, i->key);
 			mpz_add_ui(high, high, 1);
 			set_elem_expr_add(set, new_init, high,
 					  EXPR_F_INTERVAL_END, i->byteorder);
@@ -150,11 +150,11 @@ static struct expr *get_set_interval_find(const struct set *cache_set,
 			/* fall-through */
 		case EXPR_PREFIX:
 		case EXPR_RANGE:
-			range_expr_value_low(val, i);
+			range_expr_value_low(val, i->key);
 			if (left && mpz_cmp(expr_value(left)->value, val))
 				break;
 
-			range_expr_value_high(val, i);
+			range_expr_value_high(val, i->key);
 			if (right && mpz_cmp(expr_value(right)->value, val))
 				break;
 
-- 
2.47.3

