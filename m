Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97BC91F7545
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Jan 2025 23:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736293854; cv=none; b=gSOCAb5MM8HAnNqk+q2oSF/dr0WnR6XAemlcNyoMYEytcGR785TtkTXl4dAiBf0FmaPs1LE4Xj67ezXFAjA2EgKRkEMKQsZ/JPZeFQ749BdURjvQ6VzV5i03QZGK7YS6cPu+586i4+llS2+keiZX+/KKEHuqpIjGn2nTl2WMHR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736293854; c=relaxed/simple;
	bh=iZYAUiTRIESwta2F4fwzM0mFHSqlcgZvfF1IJRzf7io=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=f4eIAIOMgCjccyLz6NmgzLrSIR4r9ekb9XVh2ac27Smff6AepBQqumYWVSQNPG49Ct7Y3w3Ew7PFj5olaYJBSIXfrkGy7g3c0QVJVV4zQrRfYFY75Rt2EPNSy3owFO56C9NsRsHpcEsboZlost6VoiruoJk5h1T4mJrYrOEj+og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf-next,v2 5/6] netfilter: flowtable: teardown flow if cached mtu is stale
Date: Wed,  8 Jan 2025 00:50:37 +0100
Message-Id: <20250107235038.115651-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250107235038.115651-1-pablo@netfilter.org>
References: <20250107235038.115651-1-pablo@netfilter.org>
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
v2: new in this series.

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

