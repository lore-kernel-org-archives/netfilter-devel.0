Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A0AB32AAC6;
	Wed, 10 Jun 2026 16:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781108207; cv=none; b=fY9G6XNbO0l25Js+V7Ca7cO4PVpy4tlpQkNC7WIJMqOCvlCq35kIIysK5F9X2CGFb8I0uA7YMFEnQYQsZp3uc/rxSHPWqMbRIioeUrqwgUh3LB9u0zdywttVvYIP4Ov0weJwX/AaLFcizgB0utxEiAHeIZzruiBl5gyw02CiHdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781108207; c=relaxed/simple;
	bh=x2+gipZEzGQ96L9IBsfRwA9Xx/yC+O4SKqgDciZcPZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iOmNJq2N2w0AnQDKhc+VSGjDZzZ8nkB4wE3DuQkxmrK5IqkQXsBG5x29PmwGz+33GTPVLMY9P3nrbWgWH1JSKJ9QcNk+LpManrqF9GSmq0yM+9uZiNX6dDKunGL4Nf50EQH021HXpuzgifWrEpYAsZ0A0OJS1dzSleo3zN8hk7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=sWf9xJQi; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="sWf9xJQi"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id AB7BE601C5;
	Wed, 10 Jun 2026 18:16:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1781108203;
	bh=5uVcllhylUaGGRkjXw/I3kQSsth8SM3VuyX/RTjhKrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sWf9xJQisTe10w2a/RK8Lje9m0e2GmU/Qr1mzxl2KjupGWJqyDVPDS+OYDdUn+xdp
	 ecGayFBZsMzNFl+dzkF3dDU0h0gXjXifOapEAz9GhIkDQZnW+cFarnJdzlZLgm+WR6
	 4hMkeRXzvHpzsw2mLEp9K0sUvxGm6lJJ7zrm2HejUumoZiQe4zTTtVxQzZgoeAm152
	 OhWFuXJtke2XA1j8/NN4R7lJsit0AzI0lRFzcHyKuE0qu/Oc4hb80kgj3/Qe2l4ih/
	 /9XtYacIlCwxSyVciyQ/AcG6kSQerVPxFrU1EdseH+zWw59pOIx+hSQzuWNq9UEW1i
	 grj9YEKDXHekg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 8/8] netfilter: nft_meta_bridge: fix stale stack leak via IIFHWADDR register
Date: Wed, 10 Jun 2026 18:16:28 +0200
Message-ID: <20260610161629.214092-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260610161629.214092-1-pablo@netfilter.org>
References: <20260610161629.214092-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Davide Ornaghi <d.ornaghi97@gmail.com>

NFT_META_BRI_IIFHWADDR declares its destination register with
len = ETH_ALEN (6 bytes), which the register-init tracking rounds up to
two 32-bit registers (8 bytes). nft_meta_bridge_get_eval() then does
memcpy(dest, br_dev->dev_addr, ETH_ALEN), writing only 6 bytes and
leaving the upper 2 bytes of the second register as uninitialised
nft_do_chain() stack. A downstream load of that register span leaks
those stale bytes to userspace.

Zero the second register before the memcpy so the full declared span is
written.

Fixes: cbd2257dc96e ("netfilter: nft_meta_bridge: introduce NFT_META_BRI_IIFHWADDR support")
Cc: stable@vger.kernel.org
Signed-off-by: Davide Ornaghi <d.ornaghi97@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/netfilter/nft_meta_bridge.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bridge/netfilter/nft_meta_bridge.c b/net/bridge/netfilter/nft_meta_bridge.c
index 7763e78abb00..219c40680260 100644
--- a/net/bridge/netfilter/nft_meta_bridge.c
+++ b/net/bridge/netfilter/nft_meta_bridge.c
@@ -64,6 +64,8 @@ static void nft_meta_bridge_get_eval(const struct nft_expr *expr,
 		if (!br_dev)
 			goto err;
 
+		/* ETH_ALEN (6) is shorter than the destination register span (8) */
+		dest[1] = 0;
 		memcpy(dest, br_dev->dev_addr, ETH_ALEN);
 		return;
 	default:
-- 
2.47.3

