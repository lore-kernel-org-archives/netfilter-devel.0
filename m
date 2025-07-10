Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E101DF49;
	Thu, 10 Jul 2025 01:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752109651; cv=none; b=QJip4gISvzuimEthowI0KXy3KDyPu2DsdEfx6I30Tbz0h6P3k2gVJTcJ5cXj0TxdG/UsLWORlfReaibEDpZtpIyF/K/PjXJhDjVYf0jD+FPqmpKxPOvLuM6hJ55GOMpVE1s3HL/VscUvw5Tcqsv22Loyf4hnTJCTal9p+yLlnfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752109651; c=relaxed/simple;
	bh=RDC3j8wGaOOVJWPCP/Po/uZHOXWzsP5h47eggFQ38d8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QttxAjk8vqAb3ctgO3snBrUyy/c8EcgG5jeJmyYYHrBfOBCqDGqjiJAGQmAqJPVfljZ0uNhkvFQ6YyraOJgiyieFViI37kPcpumGuRX8wcgjn/3m5AqZJYC7Vbvl2vFlPHfwc4uC1u3DHZ4MtkrSQ4oK+sTB+fYkBQbU/mwkHVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=YFZoVoAR; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Lo34gOy0; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="YFZoVoAR";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Lo34gOy0"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 4CEF160269; Thu, 10 Jul 2025 03:07:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752109648;
	bh=VBHd4INkEeZodi67wtmxuJtMNEHdOSY0kUfPkxfgEcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YFZoVoARj48ZcLcjI6mB+ot3t56bm9xh/aI0bJMsg5LVDMw0H80m+gmFAm44TvVZ4
	 7BeYcS122X5pyf2r3zTLgxM1fxZk7lrRlvoEyMW0QAU3J8xIpQMDB0dS9q4IL//EM/
	 OiyARM0jNl/S8R2WRZ1LsWZb/8DjYs7r3GUyUamAlWrtP0Dr1mgiR+51AmcFYte/kM
	 xzhWwkLs60zsrRjpAM0G4JWNBP5zAn8z1QSdGnDwExWdugl+fX0sFgaTm/URLFS50j
	 uZG54q9GOLmXMjUeGuzIvd3zNeR13kWrGTWt3K4gtAZ3WHdvZd0Cdbo6BFySZBIzvh
	 cCPiLQvFunvIQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 0F62E60255;
	Thu, 10 Jul 2025 03:07:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752109634;
	bh=VBHd4INkEeZodi67wtmxuJtMNEHdOSY0kUfPkxfgEcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lo34gOy0Ub7A3YzzVlNM8zTRkFlvNhC8DBS2BlqfsEhQsdmpgKghc6u4FK5tMnr8S
	 9mxwril79/pEf5572tDa7WGVMBd1KWHduy2YP2q8q+17lCpgpfJhhHFZaPZMQEivsO
	 daNE381IOJ05DGtkeAG04p43lm9+/x+ujofTJWJOtaWPNFMoffzeBGWMYFAOTuTDRd
	 JGKiaKt3FL5JW/WdbbEq0GzVOH5E+75bfnRZUc8bRocl6WgfWerFti6KM3OLqq9gix
	 kMCVWNOHpHtinarcsb/vO3uevRQtshvM9xeQoPXBqBEaEN5qSA8q/K2/o8ZoEEdLCM
	 lg2WY5LBzIvFg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 4/4] netfilter: nf_tables: adjust lockdep assertions handling
Date: Thu, 10 Jul 2025 03:07:06 +0200
Message-Id: <20250710010706.2861281-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250710010706.2861281-1-pablo@netfilter.org>
References: <20250710010706.2861281-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fedor Pchelkin <pchelkin@ispras.ru>

It's needed to check the return value of lockdep_commit_lock_is_held(),
otherwise there's no point in this assertion as it doesn't print any
debug information on itself.

Found by Linux Verification Center (linuxtesting.org) with Svace static
analysis tool.

Fixes: b04df3da1b5c ("netfilter: nf_tables: do not defer rule destruction via call_rcu")
Reported-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 4ec117b31611..620824a56a55 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4042,7 +4042,7 @@ void nf_tables_rule_destroy(const struct nft_ctx *ctx, struct nft_rule *rule)
 /* can only be used if rule is no longer visible to dumps */
 static void nf_tables_rule_release(const struct nft_ctx *ctx, struct nft_rule *rule)
 {
-	lockdep_commit_lock_is_held(ctx->net);
+	WARN_ON_ONCE(!lockdep_commit_lock_is_held(ctx->net));
 
 	nft_rule_expr_deactivate(ctx, rule, NFT_TRANS_RELEASE);
 	nf_tables_rule_destroy(ctx, rule);
@@ -5864,7 +5864,7 @@ void nf_tables_deactivate_set(const struct nft_ctx *ctx, struct nft_set *set,
 			      struct nft_set_binding *binding,
 			      enum nft_trans_phase phase)
 {
-	lockdep_commit_lock_is_held(ctx->net);
+	WARN_ON_ONCE(!lockdep_commit_lock_is_held(ctx->net));
 
 	switch (phase) {
 	case NFT_TRANS_PREPARE_ERROR:
-- 
2.30.2

