Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9AE229B200
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Oct 2025 16:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761236103; cv=none; b=IVn98xoMD2PKNRAsC0N3DjQPtqc5etXflCR8wLPTcv0+3JrM7nGpsQFBX3b3/qIpIUkPA3XPW7YMkuYSTSxVDEhrZzbEbPROwfcie1Vlh3DlDhVUrUpWE16ouhe84Wp8RA9RjA4vg0aVkAR3C42V7u4tRJlXU/E/euxBGAgZHx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761236103; c=relaxed/simple;
	bh=bxghN3fSGDKcumRuW8M2cgoP2VadoTTWH9T1Vmex0E8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oUuSc6tDHBb9mOa7eAQ90IKjpG9u8w+mzy4MGWy83AjZah3/JA2saLi9aH8EGlnse/viYpkZmh6uKDxm13nn7pZ4FxDHonJ/TF0PoIKvKK2Sgq8i0MHjoyHe7NnrCZYGs6FAzOdKhs9jKlJklvZ36FY7UhZhT9Yc5+rxgCGCQkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Fd5fwMpx; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Fd5fwMpx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=mKKOdivl1JIkPsddQrQddXrMfpel7ARQHwfwxsXE6sk=; b=Fd5fwMpxnpM6+yC0n+1Qd6bzxA
	qSEVNC9g0i0fHkuEQAh1XUAi4rUBfkNBxTPvBPWF5m1PnvZ1a+Lm092CnxehX1G/cxNNnhyNO2Zdk
	13zTW2hEzoCkgqo0xQjFcgTag2WB0hMr0r1bYDSltMtfQbkAIOh1JY2sgLFyK/OIIyk5Pj2rXH2ry
	5pgN1ehvB75si+UfRqTs7qRm6QMRVuahr21noR1Ix6MzhcGxgpKbtf8l1fLRZpLEeIzSb44P9n01+
	VyT86G0c72fs/skYQWShIa6IHh2tBYOKIBA7Ld1AiRF3RNSs858spEe00Q1iY8ATYb0xRr+oGe+z+
	hucDJWjg==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vBxxs-0000000008a-05bF;
	Thu, 23 Oct 2025 18:15:00 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 09/28] netlink: No need to reference array when passing as pointer
Date: Thu, 23 Oct 2025 18:13:58 +0200
Message-ID: <20251023161417.13228-10-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251023161417.13228-1-phil@nwl.cc>
References: <20251023161417.13228-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Struct nft_data_linearize::value is an array, drop the reference
operator.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/netlink.c           | 6 +++---
 src/netlink_linearize.c | 8 ++++----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index 5511d9888e5bd..7882381ebd389 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -139,17 +139,17 @@ struct nftnl_set_elem *alloc_nftnl_setelem(const struct expr *set,
 			netlink_gen_key(key, &nld);
 			key->flags &= ~EXPR_F_INTERVAL;
 
-			nftnl_set_elem_set(nlse, NFTNL_SET_ELEM_KEY, &nld.value, nld.len);
+			nftnl_set_elem_set(nlse, NFTNL_SET_ELEM_KEY, nld.value, nld.len);
 
 			key->flags |= EXPR_F_INTERVAL_END;
 			netlink_gen_key(key, &nld);
 			key->flags &= ~EXPR_F_INTERVAL_END;
 
 			nftnl_set_elem_set(nlse, NFTNL_SET_ELEM_KEY_END,
-					   &nld.value, nld.len);
+					   nld.value, nld.len);
 		} else {
 			netlink_gen_key(key, &nld);
-			nftnl_set_elem_set(nlse, NFTNL_SET_ELEM_KEY, &nld.value, nld.len);
+			nftnl_set_elem_set(nlse, NFTNL_SET_ELEM_KEY, nld.value, nld.len);
 		}
 		break;
 	}
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index d01cadf84faf0..43cfbfa75f3d2 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -482,8 +482,8 @@ static struct expr *netlink_gen_prefix(struct netlink_linearize_ctx *ctx,
 	netlink_put_register(nle, NFTNL_EXPR_BITWISE_SREG, sreg);
 	netlink_put_register(nle, NFTNL_EXPR_BITWISE_DREG, sreg);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_BITWISE_LEN, nld.len);
-	nftnl_expr_set(nle, NFTNL_EXPR_BITWISE_MASK, &nld.value, nld.len);
-	nftnl_expr_set(nle, NFTNL_EXPR_BITWISE_XOR, &zero.value, zero.len);
+	nftnl_expr_set(nle, NFTNL_EXPR_BITWISE_MASK, nld.value, nld.len);
+	nftnl_expr_set(nle, NFTNL_EXPR_BITWISE_XOR, zero.value, zero.len);
 	nft_rule_add_expr(ctx, nle, &expr->location);
 
 	return expr->right->prefix;
@@ -558,8 +558,8 @@ static void netlink_gen_flagcmp(struct netlink_linearize_ctx *ctx,
 		netlink_put_register(nle, NFTNL_EXPR_BITWISE_SREG, sreg);
 		netlink_put_register(nle, NFTNL_EXPR_BITWISE_DREG, sreg);
 		nftnl_expr_set_u32(nle, NFTNL_EXPR_BITWISE_LEN, len);
-		nftnl_expr_set(nle, NFTNL_EXPR_BITWISE_MASK, &nld2.value, nld2.len);
-		nftnl_expr_set(nle, NFTNL_EXPR_BITWISE_XOR, &nld.value, nld.len);
+		nftnl_expr_set(nle, NFTNL_EXPR_BITWISE_MASK, nld2.value, nld2.len);
+		nftnl_expr_set(nle, NFTNL_EXPR_BITWISE_XOR, nld.value, nld.len);
 		nft_rule_add_expr(ctx, nle, &expr->location);
 
 		nle = alloc_nft_expr("cmp");
-- 
2.51.0

