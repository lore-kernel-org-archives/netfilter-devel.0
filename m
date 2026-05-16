Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742603DE442;
	Sat, 16 May 2026 11:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778932603; cv=none; b=hKEMQxxnnKL4f3F92vqBTOt/YGcKNeRuxC0EAyRNWXtpN4xlw748XQzFMUJONwdSOned9VyUyhBEfhVJa9o636NbgYEfBdrFdixILXLyZ3WylDtMTO/4WFNEovDOtqn7l4Ye/R591CMM+K3xDOYP9rb8/TR+C9yKen9N+xgrbHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778932603; c=relaxed/simple;
	bh=a3L0rjLMCE2ihewJ5dR4JE2REE9FjLpg0BmBvTSBuDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H1uel3mK70OdJTgpWBgjBmOERVkmGrCyoA4YlklD5b90CgjxE182IKvQyg5X9G2sjEeQ8iDFxqKoIu05klKYAnaqvi/4k1PznjT7pSTWzZ4tqURVQu8xBUzcDdjO36ouSYjC6CsiZd52llrgM7CUJ2KvfsF2zmbcO+MFxkhrPYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=VWScnKTV; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="VWScnKTV"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 1E884601AB;
	Sat, 16 May 2026 13:56:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1778932599;
	bh=VnNBUNQ/mJvsO2HEUTglBfQ9YieyTMdKq9EjdSx7Ou0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VWScnKTV8TujQkSui2DncFRdejm/ISWs7xn0ayn61VSzAE6Fg4We43SBwVknuopyz
	 wEU4gYIExiqQo8lS3wGdgKDnQgGKqC17Uc+cajfYBSz1KVd86GLdKk3bmFhZsvQQP1
	 QLl9DFGcvt7cxrBLdwyWBxE44Rt7t2M8saNwTdAP1zT48S0RB9J74pTJhfyZFP4EYE
	 Xr4eQUimBb7ngi65lZUiDkOUFwTKQ1ukKtMXOAukkHI22kzd158l8SsYMphgGZc+rK
	 VMd0VjwWFT+W8j/SOAvJYPSvHPI/Hcb9LUmbDM/axmK5Gxv0cZuR2TsW3q2WMWwKbZ
	 00JzkOk1xKn2Q==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 06/12] netfilter: nft_inner: release local_lock before re-enabling softirqs
Date: Sat, 16 May 2026 13:56:21 +0200
Message-ID: <20260516115627.967773-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260516115627.967773-1-pablo@netfilter.org>
References: <20260516115627.967773-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

Quoting sashiko:
 In the error path, local_bh_enable() is called before
 local_unlock_nested_bh().

Fixes: ba36fada9ab4 ("netfilter: nft_inner: Use nested-BH locking for nft_pcpu_tun_ctx")
Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_inner.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_inner.c b/net/netfilter/nft_inner.c
index 859aa38e333b..d14ca157910b 100644
--- a/net/netfilter/nft_inner.c
+++ b/net/netfilter/nft_inner.c
@@ -246,8 +246,8 @@ static bool nft_inner_restore_tun_ctx(const struct nft_pktinfo *pkt,
 	local_lock_nested_bh(&nft_pcpu_tun_ctx.bh_lock);
 	this_cpu_tun_ctx = this_cpu_ptr(&nft_pcpu_tun_ctx.ctx);
 	if (this_cpu_tun_ctx->cookie != (unsigned long)pkt->skb) {
-		local_bh_enable();
 		local_unlock_nested_bh(&nft_pcpu_tun_ctx.bh_lock);
+		local_bh_enable();
 		return false;
 	}
 	*tun_ctx = *this_cpu_tun_ctx;
-- 
2.47.3

