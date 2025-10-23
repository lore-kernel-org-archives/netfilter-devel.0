Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E269299A8C
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Oct 2025 16:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761236076; cv=none; b=jszFdI8tzwh25nZ0p4OH/BFP19+vCVAQ4u8PU8VnCVfR9jtydl6agVF6cfa8ZPKQTpY8gu1eHyZ20hMFA1l4CIBNni+bD0Xz4jJKAEaIt9Ng5tppLYBElIgHUUQubTNGFSMo6/zM3297jEGJzelOEtDOmdnB+67Myn28pogIFMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761236076; c=relaxed/simple;
	bh=xDcHzCrvdjfpq2ztWxHKFt3j3xweM5k8BclVjZkF4tM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sqijKMHJQDbTp1W+ZD0z8f6lhEt+/w/qe1LjxL0+Vl5YxjiXdICf1pvSsq2JxdSlgPNdydij6oLHYUr5xBiZreI53G0pgqXoBFsHcHzo7NC2WlRbHsIR+6q/frvsmkWZGZ+BAoq4FkufQ2RMINu7x0JY/cNZhl5wR917hKaDVdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=nbFE/mcP; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="nbFE/mcP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=/5YDhAPOqkq6JThf3in/RYCOpjWeah5x8JrGlkFvirY=; b=nbFE/mcPG19TsVXpd4nOhrCSa7
	lFlez7s754Qps2nZIut0tEo7FCSRVIE1ZVt1x+qrCOW+/qFAKNILMF8/wUsMt/dmZg9He8dDhEaMf
	tJpogxV+EOeWGGup813JyfZMraTqR3Nc5GTu09mr7wMB9vod8ORBAzgAX5vS9ZZ74VvNmIvj4466D
	Vrmwiw5/w1oVJr8Tz29Dy4nCQfnyM7mJ5N+M9UBCPxHbZ7gkfz7Icu9OjxU0G3J087cSZbOL/+MMS
	Iyz1ID7BtkbmJchhxSMDVqQwkVQu3HnCWlKsr2SZaZkbzQEvW4BKrfSRGetoexGrIDO9ZdLnlj1rl
	WTX61Njw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vBxxO-0000000005Y-2HW3;
	Thu, 23 Oct 2025 18:14:31 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 02/28] optimize: Fix verdict expression comparison
Date: Thu, 23 Oct 2025 18:13:51 +0200
Message-ID: <20251023161417.13228-3-phil@nwl.cc>
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

In verdict expression, 'chain' points at a constant expression of
verdict_type, not a symbol expression. Therefore 'chain->identifier'
points eight bytes (on 64bit systems) into the mpz_t 'value' holding the
chain name. This matches the '_mp_d' data pointer, so works by accident.

Fix this by copying what verdict_jump_chain_print() does and export
chain names before comparing.

Fixes: fb298877ece27 ("src: add ruleset optimization infrastructure")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/optimize.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/src/optimize.c b/src/optimize.c
index cdd6913a306dd..ffc06480d4ee5 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -341,13 +341,18 @@ static bool __stmt_type_eq(const struct stmt *stmt_a, const struct stmt *stmt_b,
 
 static bool expr_verdict_eq(const struct expr *expr_a, const struct expr *expr_b)
 {
+	char chain_a[NFT_CHAIN_MAXNAMELEN];
+	char chain_b[NFT_CHAIN_MAXNAMELEN];
+
 	if (expr_a->verdict != expr_b->verdict)
 		return false;
 	if (expr_a->chain && expr_b->chain) {
-		if (expr_a->chain->etype != expr_b->chain->etype)
+		if (expr_a->chain->etype != EXPR_VALUE ||
+		    expr_a->chain->etype != expr_b->chain->etype)
 			return false;
-		if (expr_a->chain->etype == EXPR_VALUE &&
-		    strcmp(expr_a->chain->identifier, expr_b->chain->identifier))
+		expr_chain_export(expr_a->chain, chain_a);
+		expr_chain_export(expr_b->chain, chain_b);
+		if (strcmp(chain_a, chain_b))
 			return false;
 	} else if (expr_a->chain || expr_b->chain) {
 		return false;
-- 
2.51.0

