Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADD3616D9C8
	for <netfilter-devel@vger.kernel.org>; Wed, 31 Jul 2024 22:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722464835; cv=none; b=U6ikWDgmwrlzlXsV1lG+qr7OwMK6O+XVW5NAZku6mjCEmGNp3o7VivzWuZcid7ufIuHy1ChVUTYGuaKXwoPjY6pH/FPOs58iAdm85GKIb5b1xMY8YxGkxeI3x+XLyzIR1aw88IoP1XwOlsmHTzesIV0ZVFa5dRTS2N/FS5EABog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722464835; c=relaxed/simple;
	bh=ypSLtoMu7wkYxMeMaK77c/TcduDtFG8TIpZYWQSr4uo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HzxYr7xwElv4dwsKf9bzUmuDjFSIZeu83VfUUbHCHjrQ/GJ4zxEN+FbeaR1uBYaXB0n4TEgnBDKT2xEcvPeVfWV+GQ8aOZGI3TCsgYOv+DPQ7RNztW32KZBhM3HsgFMhtk40YdrWLZFXMIYe87QC0veIbIboFaijr54qthob7uA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=clsuy/wQ; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="clsuy/wQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=TsZ1H4vD9A+wuRMAnzbw8NVf1fActLj4IuYHulNq53E=; b=clsuy/wQN4MC3vfboTxKCftOa0
	Xf1p0UfOl7raUVZnyNVbJmdNMifkSzVmqLRqHvNW0pjKp14f9fMABD4F1Z4TBCarH+uLXS+75WQh0
	af3aQEa7kV04CYJ0lE+WhyHL6QQ9Hhq8NuADbC37/9E3MJN/xviiYC5zoaL6TlOwrKaMmwDcs8bJA
	PDQ0CKSvV8ogTBpirvn5XhnCozDQQ5S3KLC0Mzk+DbCOPePou58pNJrzekSwZStQ+ksNE3LbLqrBF
	3xd9Jxni7iXFEfMZM6kyzSBIAikju/BihArqwXpzbvXl0bYPWbuLKFuDy5f32Bz7VPd/vtPXUXqYi
	RBMLnTXA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sZHmp-000000003iz-3i2P;
	Thu, 01 Aug 2024 00:27:11 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jan Engelhardt <jengelh@inai.de>
Subject: [iptables PATCH 4/8] nft: ruleparse: Drop 'iter' variable in nft_rule_to_iptables_command_state
Date: Thu,  1 Aug 2024 00:26:59 +0200
Message-ID: <20240731222703.22741-5-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240731222703.22741-1-phil@nwl.cc>
References: <20240731222703.22741-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the same named field in 'ctx' instead, it has to carry the value
anyway.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-ruleparse.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/iptables/nft-ruleparse.c b/iptables/nft-ruleparse.c
index 3b1cbe4fa1499..1ee7a94db59de 100644
--- a/iptables/nft-ruleparse.c
+++ b/iptables/nft-ruleparse.c
@@ -891,7 +891,6 @@ bool nft_rule_to_iptables_command_state(struct nft_handle *h,
 					const struct nftnl_rule *r,
 					struct iptables_command_state *cs)
 {
-	struct nftnl_expr_iter *iter;
 	struct nftnl_expr *expr;
 	struct nft_xt_ctx ctx = {
 		.cs = cs,
@@ -900,12 +899,11 @@ bool nft_rule_to_iptables_command_state(struct nft_handle *h,
 	};
 	bool ret = true;
 
-	iter = nftnl_expr_iter_create(r);
-	if (iter == NULL)
+	ctx.iter = nftnl_expr_iter_create(r);
+	if (ctx.iter == NULL)
 		return false;
 
-	ctx.iter = iter;
-	expr = nftnl_expr_iter_next(iter);
+	expr = nftnl_expr_iter_next(ctx.iter);
 	while (expr != NULL) {
 		const char *name =
 			nftnl_expr_get_str(expr, NFTNL_EXPR_NAME);
@@ -941,10 +939,10 @@ bool nft_rule_to_iptables_command_state(struct nft_handle *h,
 			ret = false;
 		}
 
-		expr = nftnl_expr_iter_next(iter);
+		expr = nftnl_expr_iter_next(ctx.iter);
 	}
 
-	nftnl_expr_iter_destroy(iter);
+	nftnl_expr_iter_destroy(ctx.iter);
 
 	if (nftnl_rule_is_set(r, NFTNL_RULE_USERDATA)) {
 		const void *data;
-- 
2.43.0

