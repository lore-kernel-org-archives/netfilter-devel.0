Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7769E3822B4;
	Fri, 19 Jun 2026 11:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781870121; cv=none; b=LPIuF6XfkQtxqpdR3eEwEwZIioOBl/t/B0v3+tvKUyEGaU5NFsOgECWi7nFN/iXgLN9cAeJfqVX1CSz9/dPdUqGtvsCun5vZf6EC/zfVhunHoEBl6VIcGERiWbluvbnlx+JrgZqVff18VmegXS6Mns9Gxiq5LYf9oD+oLIuK2vY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781870121; c=relaxed/simple;
	bh=+AzXFo4T6v1RIfnmKcyx8E4CwWCiT/IWhQ4pCUw5fhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ci/GzrQ1pJZpsmHNCGAT5yj7xUaYPdYtIuifp0FjtspSDPrQXLCIL8jwt/KVXx+tk+EtSXIXokGF/3AR4sNUnq65HdF2Gesj4pWpoKG/UvuJolxGTOpIvxwOH4uyJTiWlpeNjZ823vQiupPza576PEOV+ZJmBt1m/xwr2PtRvYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=hzARL2GU; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="hzARL2GU"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9E174601C1;
	Fri, 19 Jun 2026 13:55:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1781870119;
	bh=eHVdHZQlyXs+DWFytBBQ6PjoF6DaLnKX3UNbyidQQqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hzARL2GU/IYt9mwq5ba1hVEJ60pJA4O1zGZadlSXcjDo82FaO5Ff1GU0/zogxUb0K
	 yzRrw1yreiS2ZBDkIMlD47/P4hyVyeYAYt0HmGetCbDRkWKP0KFSDPkZQR6b3cqELK
	 3MLmGQ/qAjotfpZxgd/09VxtHlqCFeRNtbRR8Vr2gtSuoOh7ScXXiWbI2SVwG3RCCf
	 Hn5X1pJ3B2KT3ChfKrSQkXSDrHQpETYDwsEaz5KWy7LmWfSKQ6GQMpl/Shf7KIW+fQ
	 Rg1KiR8IMso6Tzno4R+Nqboe+s5i1nZTYcSkw+bqtpByWfd8wnhTXW/9l8VVFzrYOw
	 fXfCmYwm/o3WQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 16/16] netfilter: nft_meta_bridge: fix NFT_META_BRI_IIFPVID stack leak
Date: Fri, 19 Jun 2026 13:54:51 +0200
Message-ID: <20260619115452.93949-17-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260619115452.93949-1-pablo@netfilter.org>
References: <20260619115452.93949-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

This needs to test for nonzero retval.

Fixes: c54c7c685494 ("netfilter: nft_meta_bridge: add NFT_META_BRI_IIFPVID support")
Closes: https://sashiko.dev/#/patchset/20260618061631.21919-1-fw%40strlen.de
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/netfilter/nft_meta_bridge.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/bridge/netfilter/nft_meta_bridge.c b/net/bridge/netfilter/nft_meta_bridge.c
index 3d95f68e0906..e4c9aa1f64e2 100644
--- a/net/bridge/netfilter/nft_meta_bridge.c
+++ b/net/bridge/netfilter/nft_meta_bridge.c
@@ -44,7 +44,9 @@ static void nft_meta_bridge_get_eval(const struct nft_expr *expr,
 		if (!br_dev || !br_vlan_enabled(br_dev))
 			goto err;
 
-		br_vlan_get_pvid_rcu(in, &p_pvid);
+		if (br_vlan_get_pvid_rcu(in, &p_pvid))
+			goto err;
+
 		nft_reg_store16(dest, p_pvid);
 		return;
 	}
-- 
2.47.3

