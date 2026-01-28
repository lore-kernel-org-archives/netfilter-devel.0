Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B17AD233149
	for <netfilter-devel@vger.kernel.org>; Wed, 28 Jan 2026 21:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769636698; cv=none; b=uZjhnVpZad2hGV7iBCfEJnkgcdPtMhoaURW7lz9Cc5XL9dKqe3/hX/zKpL3U1poRMwJrb0oqIDCHr6kioVNp1QDBHkdx708YxcPlK5skC0AAEwyM8vE7fIi2hSLbzA2MLjJV3HNvoIenLL5cm+f4YJy7tmM4gNlqr3zQzIjRu2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769636698; c=relaxed/simple;
	bh=hA8FaNawd080L9FAPBwmRBjkDytr4fEXsrZTAs7ORC4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=sHw0xbNelgv05DD9+4p0ClCAdcm+h1NG4K6P0vfklMEZUcarG2qEQ9WfNFQ1VlzKAJ5ev0yCODCyEK5b91x+3TlKozuUzyeYiH+O1dt5bQYlyJbblrVCcDcamFoNS/9+z1/KnoEp0o15Kz+BIM0xC6QK9U/XxzmAaLh6wRAdkWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=XVV/Luoi; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="XVV/Luoi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=URkSd1ZiwCkIBGOMirK4WxGwAqZNgR6KYUgu1oynIB4=; b=XVV/LuoiTEsyL2NeZ4sdQbN6z4
	tlTrQJ/PjnOZSCBTl65P/dnp1eX88O8/nl/CzzYzzjEHX7hc2/ketFewIRM60VUGHRRue+i6oA9fO
	5jackkTVCQRc51qTVRgGwqLAJVZKXOIz2zEsnBHDTU2/vsPIGaTC8f5nFGACND2HLbHGP3FZwFNdk
	J2UIewwWAH3L69EXqwwFd8A80UYsMG3M8O3da+fqok79J0N2a3bBC4SioR/TFyBpkQN4xkLoIYHaz
	TvFDTyX6+/jW3pyEqrmNACeaL12LAmb4oGC2kk9O/JGPefzpBziiiq5Dxq2UszC5hKjYBvtR1JpXY
	UW+8AE9A==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1vlDLE-0000000060U-2DFX
	for netfilter-devel@vger.kernel.org;
	Wed, 28 Jan 2026 22:44:48 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] ruleparse: arp: Fix for all-zero mask on Big Endian
Date: Wed, 28 Jan 2026 22:44:43 +0100
Message-ID: <20260128214443.27971-1-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With 16bit mask values, the first two bytes of bitwise.mask in struct
nft_xt_ctx_reg are significant. Reading the first 32bit-sized field
works only on Little Endian, on Big Endian the mask appears in the upper
two bytes which are discarded when assigning to a 16bit variable.

Fixes: ab2d5f8c7bbee ("nft-arp: add missing mask support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-ruleparse-arp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/iptables/nft-ruleparse-arp.c b/iptables/nft-ruleparse-arp.c
index b0671cb0dfe8f..0648b2748931f 100644
--- a/iptables/nft-ruleparse-arp.c
+++ b/iptables/nft-ruleparse-arp.c
@@ -90,7 +90,7 @@ static void nft_arp_parse_payload(struct nft_xt_ctx *ctx,
 		if (inv)
 			fw->arp.invflags |= IPT_INV_ARPHRD;
 		if (reg->bitwise.set)
-			fw->arp.arhrd_mask = reg->bitwise.mask[0];
+			fw->arp.arhrd_mask = ((uint16_t *)reg->bitwise.mask)[0];
 		break;
 	case offsetof(struct arphdr, ar_pro):
 		get_cmp_data(e, &ar_pro, sizeof(ar_pro), &inv);
@@ -99,7 +99,7 @@ static void nft_arp_parse_payload(struct nft_xt_ctx *ctx,
 		if (inv)
 			fw->arp.invflags |= IPT_INV_PROTO;
 		if (reg->bitwise.set)
-			fw->arp.arpro_mask = reg->bitwise.mask[0];
+			fw->arp.arpro_mask = ((uint16_t *)reg->bitwise.mask)[0];
 		break;
 	case offsetof(struct arphdr, ar_op):
 		get_cmp_data(e, &ar_op, sizeof(ar_op), &inv);
@@ -108,7 +108,7 @@ static void nft_arp_parse_payload(struct nft_xt_ctx *ctx,
 		if (inv)
 			fw->arp.invflags |= IPT_INV_ARPOP;
 		if (reg->bitwise.set)
-			fw->arp.arpop_mask = reg->bitwise.mask[0];
+			fw->arp.arpop_mask = ((uint16_t *)reg->bitwise.mask)[0];
 		break;
 	case offsetof(struct arphdr, ar_hln):
 		get_cmp_data(e, &ar_hln, sizeof(ar_hln), &inv);
@@ -117,7 +117,7 @@ static void nft_arp_parse_payload(struct nft_xt_ctx *ctx,
 		if (inv)
 			fw->arp.invflags |= IPT_INV_ARPHLN;
 		if (reg->bitwise.set)
-			fw->arp.arhln_mask = reg->bitwise.mask[0];
+			fw->arp.arhln_mask = ((uint8_t *)reg->bitwise.mask)[0];
 		break;
 	case offsetof(struct arphdr, ar_pln):
 		get_cmp_data(e, &ar_pln, sizeof(ar_pln), &inv);
-- 
2.51.0

