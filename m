Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2191D443C3F
	for <netfilter-devel@vger.kernel.org>; Fri, 11 Sep 2026 11:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789125719; cv=none; b=IvQ0pEZefTyDn5E3GCJnokuMXcZdjAFbv8uMaggtqw1iTvxJb96aX32RcsbcYveS9b6+60BzOv66hj/H/vqFQybU2bbRYmckG11ybw+lZA3TOEnPCUljttNpCvILLeziXnLAMb4476iiy01wiPxhL7TzaBaVV0Ryqr2Cx5/bCU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789125719; c=relaxed/simple;
	bh=Y2X/E8hy84EI/tNM0FrQqixMjy6juDhQY6qo77mmPyM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RwFVLgzu/N/xXkz54UZcIATLCBPNz5rwO0IGna5y/0HBA44CVkB5p43TTv50EAwkwZCwRZlvlO6tSF/RNy7j6E6cctAvprSymF8BO1VMLJUtcguK+OSPoeT7o7XETYb6ATMUkLsqPr++kQ45/bvdLH7te0Vgfc9xhKjXDYUzums=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=s6snFb7b; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="s6snFb7b"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789125709;
	bh=wu9smSKyIWyeps8oUEotPo2VmYFuxqCbE0wWjR8D2sY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=s6snFb7bH/lcU00UZxzwrBaG56oMGDoL9/WWpQuI3+8s8T6Ggn5PWgqsGid2noKtH
	 SzmgV7nkv0hrVCDJmbKVy1lkMhWf29zQ+jl4sT+i5o3O0rwns8a2sdQ6l/LLxeWIzQ
	 M3GdlbLbOr+EKiaL2cmY4XlYnrU4Yl78Tu6vpDWQhr9f+JWawfinxXGs78WqGsICuT
	 i3dGzc8zn4M2voTAxoD6fQxf7lR51DPa69HHpSXM7mcxaRJRSrSkmHNLidRLkum7OZ
	 7vZBhvlcqcxpGtyN6wiYQni2RTNhQZgmQwqar+5ckjNml3bVfUDpIsMADh5TBX7YlU
	 NGyTR5cVY+aRA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 85387603DA
	for <netfilter-devel@vger.kernel.org>; Fri, 11 Sep 2026 13:21:49 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH net 1/4] netfilter: nft_nat: fully initialise new_addr in netmap setup
Date: Fri, 11 Sep 2026 13:21:41 +0200
Message-ID: <20260911112144.1860514-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260911112144.1860514-1-pablo@netfilter.org>
References: <20260911112144.1860514-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>

nft_nat_setup_netmap() builds the mapped address in an on-stack
union nf_inet_addr. For an IPv4 mapping it writes only the 4-byte .ip
member and the loop runs a single 32-bit iteration, but it then copies
the whole 16-byte union into range->min_addr and range->max_addr, so the
upper 12 bytes reach nf_nat_setup_info() uninitialised.

KMSAN reports an uninit-value in nf_nat_setup_info() reached from
nft_nat_eval(). The IPv6 path fills all 16 bytes and is not affected.

Zero-initialise new_addr.

Fixes: 3ff7ddb1353d ("netfilter: nft_nat: add netmap support")
Signed-off-by: Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_nat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index e32cd9fbc7c2..cdbd800cac96 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -64,8 +64,8 @@ static void nft_nat_setup_netmap(struct nf_nat_range2 *range,
 				 const struct nft_pktinfo *pkt,
 				 const struct nft_nat *priv)
 {
+	union nf_inet_addr new_addr = {};
 	struct sk_buff *skb = pkt->skb;
-	union nf_inet_addr new_addr;
 	__be32 netmask;
 	int i, len = 0;
 
-- 
2.47.3

