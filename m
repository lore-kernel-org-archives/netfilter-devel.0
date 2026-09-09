Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C926472545;
	Wed,  9 Sep 2026 22:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788992347; cv=none; b=Zv6d0eZjiw44rIkNKv2thwEXoQkpo79q200MdUC7yjDc48jlNSsDXZCw5twnDjFHdTjLzmVuU/10jsCLnX5TiDfhSvSYZtgrDnibcnuzvKiI4fOtfQ6wznuO4VltWGbm9Evn4d7K7ipLckHRNRMAz/Z+Z9I/WyVHx/I56s4rt2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788992347; c=relaxed/simple;
	bh=Y2X/E8hy84EI/tNM0FrQqixMjy6juDhQY6qo77mmPyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DOCpXFNESF1tLuewbSZSS1x6rg+SUh8fk/RrdH/rUSlVGadnMaxRP9mG5T+Aj7iq8AvuwA2rGqlxWiuHc5XF0rjZR52tQbCYRTdyEvv6jktAWCl7u3wq5GF31sN+Sx71GAvNRB2DHz3YFRRMFOoGuUcYEZUaHmmbdtXo17WGpIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=vuoNTZS5; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="vuoNTZS5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1788992331;
	bh=wu9smSKyIWyeps8oUEotPo2VmYFuxqCbE0wWjR8D2sY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vuoNTZS588GmNeAugVTA4XkVgN0GWm1UWFmusD0PScYXCsKPm3MdRbDz9kZ0FeLLq
	 lB//fU/tTgJ7K96TzkOUvixiJE4GFE7yS7KMqJftYIVm5qLL1gUChuRKsjDHVOWG3c
	 k49IWFA1SOSyK+GqH4If9QnQBCxGyVCj2SUf2Gqr3J32B50IRJIQ11ZlxpuvQhpk2b
	 1RyKLFeqV7nKJb48X2Z5ZdIplILXiOBWeIPjeLCESCOrulkzN3PfMk5bw633N175Hv
	 lzVsv2S47uyLuJpcCmUddNoYSfIDuqWCItqGv2oAJDggImUNMqUgmsCHjsQgFWAU7S
	 zSIiSf25tculg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 63F1D607BF;
	Thu, 10 Sep 2026 00:18:51 +0200 (CEST)
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
Subject: [PATCH net 1/7] netfilter: nft_nat: fully initialise new_addr in netmap setup
Date: Thu, 10 Sep 2026 00:18:38 +0200
Message-ID: <20260909221844.1650275-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260909221844.1650275-1-pablo@netfilter.org>
References: <20260909221844.1650275-1-pablo@netfilter.org>
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

