Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4B94199936;
	Thu, 31 Oct 2024 10:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730368888; cv=none; b=Sd/finCUGSg1QE+GFSThJzjY9vKpR//SOz9IAKaUAHIb8CyLPyfrUwNtvT8yeIs2X7DGkBf3eFbLpTN08cx3SLDEv/OfVxFHp5sjnI5NM92+3qSWjxxa/2yPBTWngJ1f/RuHMwp06pTuYc+/f3nUxjuzxQ184dgcfWgeitGj368=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730368888; c=relaxed/simple;
	bh=n2YCcxRWAkMaCAzg5bpKKhTVz0sdILj8PWv2IcBG+lI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pZMKUGare8/73pCuLPIxmYGk/OkvUYlnMQwOy4JFWmcC8E44s0dViyra/O8LJLD+sG2SFLVwo8LDcJKOogch5KeLKrsFYVTAGvhaD1U5djpWg/XyJJrlYzsv+IQy6Vmjx7ba43V6JJE03v1yDTseqIM3iO4oVDaAVopb8KGjFLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net 4/4] netfilter: nft_payload: sanitize offset and length before calling skb_checksum()
Date: Thu, 31 Oct 2024 11:01:17 +0100
Message-Id: <20241031100117.152995-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20241031100117.152995-1-pablo@netfilter.org>
References: <20241031100117.152995-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If access to offset + length is larger than the skbuff length, then
skb_checksum() triggers BUG_ON().

skb_checksum() internally subtracts the length parameter while iterating
over skbuff, BUG_ON(len) at the end of it checks that the expected
length to be included in the checksum calculation is fully consumed.

Fixes: 7ec3f7b47b8d ("netfilter: nft_payload: add packet mangling support")
Reported-by: Slavin Liu <slavin-ayu@qq.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_payload.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 330609a76fb2..7dfc5343dae4 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -904,6 +904,9 @@ static void nft_payload_set_eval(const struct nft_expr *expr,
 	    ((priv->base != NFT_PAYLOAD_TRANSPORT_HEADER &&
 	      priv->base != NFT_PAYLOAD_INNER_HEADER) ||
 	     skb->ip_summed != CHECKSUM_PARTIAL)) {
+		if (offset + priv->len > skb->len)
+			goto err;
+
 		fsum = skb_checksum(skb, offset, priv->len, 0);
 		tsum = csum_partial(src, priv->len, 0);
 
-- 
2.30.2

