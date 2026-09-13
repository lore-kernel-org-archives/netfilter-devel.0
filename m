Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C5D9361DDC;
	Sun, 13 Sep 2026 20:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789332906; cv=none; b=LkDMSdgi0OOPtoYj2uzaJXPrRWKjC0jZ3WuDvaJ+HAT5OX2eo09CmRbXLzWuzqX+MK8Fs82+e2TXfgnple104UV7ocp04jnVrofJ/wBx16N3jFcCPZXQgAMu75y6N1yxzrOMTUgJgMHG62zoEz/ck296x0DYFgnazghxRNUfGck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789332906; c=relaxed/simple;
	bh=Y2X/E8hy84EI/tNM0FrQqixMjy6juDhQY6qo77mmPyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gWyPonIHELlQ8nYDjnN2OlKGAAsBi2QI+D+te4AbmUs/KToZTQO17llNiXK/du9UataSRS0+9bi3b8X24jsttWZkxx1zcnpNK1IHoYFemgl5houo365h+8H7LAWlwVy1wlKYRpm4dXDd+5E2XMwRQvKFfe2EfdCGnHkVJbfUk5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=F4ocF6Jg; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="F4ocF6Jg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789332897;
	bh=wu9smSKyIWyeps8oUEotPo2VmYFuxqCbE0wWjR8D2sY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F4ocF6JgxjxcSmXPp9XhsbW00L3ldGI5g1Ds3f7J7QD80hgVp+OhP6OgIeXgLrfOl
	 Ccl5T4q8nriX12QnRFOSGdkMvO9uAVVtb0K1LK9f3Yd2Azjg433/IPeehrr9eb346q
	 qR2W+XFy/KJCvK3xKgJbKucGRlq8a/fvUG9TmJQsdjL7pygipIJ81ucx5FviCSAhTf
	 U6NlEOJMdNdiPlwZxaqk4yx0EKAMvt1PYknVCw1Zw/kPKiL5jKxflHfh1CsaTpS2oE
	 bO4DOR8uau+Hp+VpAciUh7rNKZv0s9+xDduVrAZaQspqzf36OgakMSrY7WNzzwkyRr
	 biNgFK7jCRH1Q==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 203D160058;
	Sun, 13 Sep 2026 22:54:57 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 1/4] netfilter: nft_nat: fully initialise new_addr in netmap setup
Date: Sun, 13 Sep 2026 22:54:44 +0200
Message-ID: <20260913205447.1889203-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260913205447.1889203-1-pablo@netfilter.org>
References: <20260913205447.1889203-1-pablo@netfilter.org>
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

