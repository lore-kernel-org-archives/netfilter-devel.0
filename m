Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ECC421D3E2
	for <netfilter-devel@vger.kernel.org>; Fri, 14 Nov 2025 00:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763079958; cv=none; b=reyv/T8uZPjA8b9hdHzXHyBHSbHwQunLAmZYZ2Ivw8QkVwxwiFCUdzOQcOvkjRsnSDnC1IJZveHqxBatWn81ZA9HWwltOY5Vovo0ECpnxDL1KFt0vyoAanGvIEedWtdroYbWzHDM8BXotlxr/Kmxunf67tHlGtTco0YnU+7KUlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763079958; c=relaxed/simple;
	bh=AWovMTAPdwfm3IZWi4UJWm4wPHtqeCM7mYUOEIwBUF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=btDBeJ/wCUKsWGqVWzeiOWfcshTCmRnrVOplX16xajSSSKlo40Np+bs0RgekHoF0elZCCOxeV+1dhnwaf/XdAVyms6HTTX48O6Rk1AhKrfvLICmZQKIezcWKAP3yL59YPREqau2fmdE4vgWDgqJ2F+XkEw/1imNAhO2h3RJSG1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=YThRIkTL; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="YThRIkTL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=NuAROOuyyo0VoD5kmXn+NzhGLdCmbs2Ut4Ek0QiIe1s=; b=YThRIkTLsR/zHoPiIjMbTdiMrg
	wpbCXEdoyJoyBepgQhoJJ6kkY9pc45TJQjt7ULdYEEL9k+YOeWXVm5dLOJCLBtfPeBLNZWT5ghxTs
	mLwWTb8WEqMxZyYJXNVVc15pDZV1VORI2WidaIMvtDqEyCC3BdMVesz7IypjbRbHadRleKrad4l8V
	RwiO6pEdXL2mPhCugoZrkOTWUwbUxPCBXc6Xcb85PekvmHWUfusZ10pW1u/eMizf0iQrR+72OddEj
	ZrfP1ITR6eTy/fOeATuBh7/fvAirWDvzORdxbJx2IkG6r9sMJiTHkGfBGek33q6mCRvlau1Zpw3RG
	mPntEZzA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vJhdT-000000005kS-0BOY;
	Fri, 14 Nov 2025 01:25:55 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH v2 05/11] expression: Set range expression 'len' field
Date: Fri, 14 Nov 2025 01:25:36 +0100
Message-ID: <20251114002542.22667-6-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251114002542.22667-1-phil@nwl.cc>
References: <20251114002542.22667-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The length value is needed for netlink debug output of concatenated
ranges. Set it to one of the inner elements' lengths (which should be
identical).

Since the inner element length may not be set initially, set it in
eval phase again. This covers at least all cases in tests/py.

Without this, netlink_gen_concat_key() et al. would have to inspect
element types and extract lengths accordingly, this is much easier.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/evaluate.c   | 1 +
 src/expression.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index 5a5e6cb5b2885..62bf8e44b4ccc 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1347,6 +1347,7 @@ static int expr_evaluate_range(struct eval_ctx *ctx, struct expr **exprp)
 
 	datatype_set(range, left->dtype);
 	range->flags |= EXPR_F_CONSTANT;
+	range->len = left->len;
 	return 0;
 }
 
diff --git a/src/expression.c b/src/expression.c
index 4d68967f112e4..e036c4bb69965 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -1018,6 +1018,7 @@ struct expr *range_expr_alloc(const struct location *loc,
 			  BYTEORDER_INVALID, 0);
 	expr->left  = left;
 	expr->right = right;
+	expr->len = left->len;
 	return expr;
 }
 
-- 
2.51.0

