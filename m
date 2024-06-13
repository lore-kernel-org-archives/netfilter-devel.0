Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 255B36AFAE;
	Thu, 13 Jun 2024 11:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279225; cv=none; b=ruiQ5O9F1zO9gK0vy6sSdJXH6HTQmCgF0y5YThWRui0XKDmlH12Rn2QTNeETI+KVUrveqDjb+elBSY/nBoq2TSQ9P1K8LErGNppuku2QHQCOGHxj6MRBZpLF3zDX8ERqG9Zl303a8aJs5g3L2IcWAE2R8HwvvDgORvKrto9eipw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279225; c=relaxed/simple;
	bh=gBZWNMJZXwvMyPUusqLil7RFQyzWEHflhjRsXeRWfYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s0ZW/GnPObS6Ea/vxfOxYq09EDuoC+q9+7qTETyZ/KdzPNG4zDPFWswwh9/SXkJvqpFRm4ciDdUCtr4zFyEe8XWst5B0STmp1pd359N2WFXSSJCkIhfq3fFL245gsr73OnvyXMSU/oTXpi0ieZwGzZnte4fUq+bUI/s3iX/nxYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iatiC6z7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iatiC6z7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D310C2BBFC;
	Thu, 13 Jun 2024 11:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279225;
	bh=gBZWNMJZXwvMyPUusqLil7RFQyzWEHflhjRsXeRWfYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iatiC6z7Nv7qwPBp+WnH/wOWz7yk2gqe2DGue087E61TzcZszowzvI7cMhLCnwRgw
	 pBwEYk/voGOUaZF5zn/9NkWvLSIUapuqt+xpoHMcWTLoKFJWflY2ShGwEImHAE8It+
	 GHDvtolQzyNm2iX/Mu3lC3ndH5j2in65XqABoDWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 4.19 186/213] netfilter: nftables: exthdr: fix 4-byte stack OOB write
Date: Thu, 13 Jun 2024 13:33:54 +0200
Message-ID: <20240613113235.156045419@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_exthdr.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -36,6 +36,14 @@ static unsigned int optlen(const u8 *opt
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
@@ -57,8 +65,7 @@ static void nft_exthdr_ipv6_eval(const s
 	}
 	offset += priv->offset;
 
-	dest[priv->len / NFT_REG32_SIZE] = 0;
-	if (skb_copy_bits(pkt->skb, offset, dest, priv->len) < 0)
+	if (nft_skb_copy_to_reg(pkt->skb, offset, dest, priv->len) < 0)
 		goto err;
 	return;
 err:
@@ -114,7 +121,8 @@ static void nft_exthdr_tcp_eval(const st
 		if (priv->flags & NFT_EXTHDR_F_PRESENT) {
 			*dest = 1;
 		} else {
-			dest[priv->len / NFT_REG32_SIZE] = 0;
+			if (priv->len % NFT_REG32_SIZE)
+				dest[priv->len / NFT_REG32_SIZE] = 0;
 			memcpy(dest, opt + offset, priv->len);
 		}
 


