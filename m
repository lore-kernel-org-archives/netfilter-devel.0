Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 025E91DFE03;
	Sun, 19 Jan 2025 17:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737307270; cv=none; b=rtWqAJQrk/Kog9oYHAhmPGYeeZg7JzzwkMsB9vCitrV05av7TbD8GuHs/FMnNaf3ooDz51t2MKV/NVq9agyg897tFaq2SJNDJUfTNTH/hMWcs1Pf00OFxGpFPJy29zCFc3iJ13c71KSAAHfcxdjMVd0Mgl7rmSK7UOivWKeVVFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737307270; c=relaxed/simple;
	bh=TpOe8lEa+VWEybRdhUyswpd6EgPwBrCIeX+GSFaQbjU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GgBgVqYYrutH3ino3I5gKJcxusxnGpIFweX72Me/W0VtGG05456wL521v5OT0S2CeGPuv9gCB0NZJp4uXWN7NzfLsvsQxz9sAVQ7ZXjYA6UXMCh0oNevWZr7F8sTpn60J92ET4iBX66uoeTKEh2aIqGFZJOJ8L2JFqpGH3tDkcc=
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
Subject: [PATCH net-next 13/14] netfilter: flowtable: teardown flow if cached mtu is stale
Date: Sun, 19 Jan 2025 18:20:50 +0100
Message-Id: <20250119172051.8261-14-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250119172051.8261-1-pablo@netfilter.org>
References: <20250119172051.8261-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Tear down the flow entry in the unlikely case that the interface mtu
changes, this gives the flow a chance to refresh the cached mtu,
otherwise such refresh does not occur until flow entry expires.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_ip.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 98edcaa37b38..a22856106383 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -377,8 +377,10 @@ static int nf_flow_offload_forward(struct nf_flowtable_ctx *ctx,
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
 
 	mtu = flow->tuplehash[dir].tuple.mtu + ctx->offset;
-	if (unlikely(nf_flow_exceeds_mtu(skb, mtu)))
+	if (unlikely(nf_flow_exceeds_mtu(skb, mtu))) {
+		flow_offload_teardown(flow);
 		return 0;
+	}
 
 	iph = (struct iphdr *)(skb_network_header(skb) + ctx->offset);
 	thoff = (iph->ihl * 4) + ctx->offset;
@@ -656,8 +658,10 @@ static int nf_flow_offload_ipv6_forward(struct nf_flowtable_ctx *ctx,
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
 
 	mtu = flow->tuplehash[dir].tuple.mtu + ctx->offset;
-	if (unlikely(nf_flow_exceeds_mtu(skb, mtu)))
+	if (unlikely(nf_flow_exceeds_mtu(skb, mtu))) {
+		flow_offload_teardown(flow);
 		return 0;
+	}
 
 	ip6h = (struct ipv6hdr *)(skb_network_header(skb) + ctx->offset);
 	thoff = sizeof(*ip6h) + ctx->offset;
-- 
2.30.2

