Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF07F13CF85
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Jun 2024 17:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718298814; cv=none; b=OMHyQKpT1EaFG76ha3Up8R5V6G6hlgdPTGlo6NmvI4oNoIKES7wsi5+LyhgypBmdJHRtcfVl8voXRjKiUvZ4DwMtay/liAEtZuGdFNTyvSgRxzXERyc4ozrpKZnevcnPdTpvk40Uj9/s1Stfitil7GSmkKlC7g0B3YUl30DBD8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718298814; c=relaxed/simple;
	bh=PiihNOfcyEATAtCG900JeUIgMm/Oa/AY2JJ7f9Jlat8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=OMP1dNsyRX+AR/knogNoLQaMSSh8Jw6Y3u2d1y+D91zdopwbsVLuG4T5FT6XtdH1fthT76/M8GpocV4J463F2fFDw5gDw931jUJTOM/ueuLCJgqJoecv61xaTmaLwrfAexa2iQf0noW1Y5P0m4Yvnumkp8pJnMJUsGebsPyspfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	stable@vger.kernel.or,
	sashal@kernel.org
Subject: [PATCH -stable,5.4] netfilter: nftables: exthdr: fix 4-byte stack OOB write
Date: Thu, 13 Jun 2024 19:13:26 +0200
Message-Id: <20240613171326.121697-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

commit fd94d9dadee58e09b49075240fe83423eb1dcd36 upstream.

If priv->len is a multiple of 4, then dst[len / 4] can write past
the destination array which leads to stack corruption.

This construct is necessary to clean the remainder of the register
in case ->len is NOT a multiple of the register size, so make it
conditional just like nft_payload.c does.

The bug was added in 4.1 cycle and then copied/inherited when
tcp/sctp and ip option support was added.

Bug reported by Zero Day Initiative project (ZDI-CAN-21950,
ZDI-CAN-21951, ZDI-CAN-21961).

Fixes: 49499c3e6e18 ("netfilter: nf_tables: switch registers to 32 bit addressing")
Fixes: 935b7f643018 ("netfilter: nft_exthdr: add TCP option matching")
Fixes: 133dc203d77d ("netfilter: nft_exthdr: Support SCTP chunks")
Fixes: dbb5281a1f84 ("netfilter: nf_tables: add support for matching IPv4 options")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Hi Greg, Sasha,

This backport is missing in 5.4, please apply to -stable. Thanks.

 net/netfilter/nft_exthdr.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index 670dd146fb2b..ca268293cfa1 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -33,6 +33,14 @@ static unsigned int optlen(const u8 *opt, unsigned int offset)
 		return opt[offset + 1];
 }
 
+static int nft_skb_copy_to_reg(const struct sk_buff *skb, int offset, u32 *dest, unsigned int len)
+{
+	if (len % NFT_REG32_SIZE)
+		dest[len / NFT_REG32_SIZE] = 0;
+
+	return skb_copy_bits(skb, offset, dest, len);
+}
+
 static void nft_exthdr_ipv6_eval(const struct nft_expr *expr,
 				 struct nft_regs *regs,
 				 const struct nft_pktinfo *pkt)
@@ -54,8 +62,7 @@ static void nft_exthdr_ipv6_eval(const struct nft_expr *expr,
 	}
 	offset += priv->offset;
 
-	dest[priv->len / NFT_REG32_SIZE] = 0;
-	if (skb_copy_bits(pkt->skb, offset, dest, priv->len) < 0)
+	if (nft_skb_copy_to_reg(pkt->skb, offset, dest, priv->len) < 0)
 		goto err;
 	return;
 err:
@@ -151,8 +158,7 @@ static void nft_exthdr_ipv4_eval(const struct nft_expr *expr,
 	}
 	offset += priv->offset;
 
-	dest[priv->len / NFT_REG32_SIZE] = 0;
-	if (skb_copy_bits(pkt->skb, offset, dest, priv->len) < 0)
+	if (nft_skb_copy_to_reg(pkt->skb, offset, dest, priv->len) < 0)
 		goto err;
 	return;
 err:
@@ -208,7 +214,8 @@ static void nft_exthdr_tcp_eval(const struct nft_expr *expr,
 		if (priv->flags & NFT_EXTHDR_F_PRESENT) {
 			*dest = 1;
 		} else {
-			dest[priv->len / NFT_REG32_SIZE] = 0;
+			if (priv->len % NFT_REG32_SIZE)
+				dest[priv->len / NFT_REG32_SIZE] = 0;
 			memcpy(dest, opt + offset, priv->len);
 		}
 
-- 
2.30.2

