Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFBC72135A6;
	Thu, 13 Feb 2025 10:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739441125; cv=none; b=EwMPZyCkZI4VosWFng/nkZ4X7GefUjHUdNihp/xQoCeFzy7pIJBez1lmiCVaoF+1l0mQlcTWxDhYwLZFwzQKeaBpxv5K+BB8gaIbkIwX46uxeYELHrMOfR8jMhsqmQD5mJx1YilV46kTjwr3lJxSDiJ9dO4Yw3Jc11pb7Rf00jE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739441125; c=relaxed/simple;
	bh=WmsomkJ100p7pSf7xL38z54aaFNpB7l8QlDbE8kCpLQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uN+jVFIgK5DPCwQE70u/T/faJliwKKt2P+/J/w0bqhOkfAPt7atPyJc9bfzDkze9Ws+qUqw4Ezm12k/TFajuWI0r5xXjse/TVpfifUGjXUqNijUWwfRiguggPiVbI/UWOr9Nfj6UQgHDn01PzIUaDWN140RbhCUIck+MQISz5Ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=TEZxhGFy; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=XPYHNgOn; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="TEZxhGFy";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="XPYHNgOn"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 442D66056C; Thu, 13 Feb 2025 11:05:16 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1739441116;
	bh=0FjhRGzxaA/4a6gzXP9+0Iz4nUTyuEMmSJ2bbQBb32o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TEZxhGFye5Wp67UjZL4Ev8PWK9/jpSO7asoomZQdsGqScKi22OMwg5Kk4Ye1J4i+G
	 MqqkIBkpv+BPSxfX14Sf34Dmp6ScfcjnFp+3hSYp7IIuaAreA32boInIV2OLf3mGFD
	 bg5kh9MqLYfhfijdcfEokzVZd+hlpIxENxS6NEmPYgNiX+net/gZm+xrpGnlwsjmCx
	 sIsB7UObYPeZDyUw3d6qKfVbEDmc3lTbsSozpmxjyerpVHtc55IQt8sz8R1oG6jqsx
	 VqGiyXmlTPBh10UHf2wjflimfk0rXisfGACEfB2e94agdd/CusHJvTZqJJulXnn59i
	 u2SHdP5DUuNPA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A399160568;
	Thu, 13 Feb 2025 11:05:14 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1739441115;
	bh=0FjhRGzxaA/4a6gzXP9+0Iz4nUTyuEMmSJ2bbQBb32o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XPYHNgOnpkLeUGd7aG78UzgcHGdUZrSdNrzLEOX8dyWn0KnjTJ4MDqrkP+2QUHx6n
	 5tvU19tg8MAeVHYG35eFpzMrTdLSXkdnpqH+KHPvxJBifZ52fTSkyJnzdi6wGBReqR
	 T5oPWacsEjIFn7IvYJsYXoiojv9n2m5SPAIk98FSg5OscxhkWNUZiHbjeVCafGhspM
	 ZI2Wl37yudRcZ71Thj/ebXcBxu0TSZa8vQu4/VTD4fkTnEIP7dY9zgBpMUhiJSJWbY
	 pnXBV1bn/bOmqL6jACq5OMPSQgJ3ffChnBjXgKxJbXtdv19iodabbrkKHtzJVsUN6C
	 LpuVoxENZu5ug==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 1/1] Revert "netfilter: flowtable: teardown flow if cached mtu is stale"
Date: Thu, 13 Feb 2025 11:05:02 +0100
Message-Id: <20250213100502.3983-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250213100502.3983-1-pablo@netfilter.org>
References: <20250213100502.3983-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This reverts commit b8baac3b9c5cc4b261454ff87d75ae8306016ffd.

IPv4 packets with no DF flag set on result in frequent flow entry
teardown cycles, this is visible in the network topology that is used in
the nft_flowtable.sh test.

nft_flowtable.sh test ocassionally fails reporting that the dscp_fwd
test sees no packets going through the flowtable path.

Fixes: b8baac3b9c5c ("netfilter: flowtable: teardown flow if cached mtu is stale")
Reported-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_ip.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 97c6eb8847a0..8cd4cf7ae211 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -381,10 +381,8 @@ static int nf_flow_offload_forward(struct nf_flowtable_ctx *ctx,
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
 
 	mtu = flow->tuplehash[dir].tuple.mtu + ctx->offset;
-	if (unlikely(nf_flow_exceeds_mtu(skb, mtu))) {
-		flow_offload_teardown(flow);
+	if (unlikely(nf_flow_exceeds_mtu(skb, mtu)))
 		return 0;
-	}
 
 	iph = (struct iphdr *)(skb_network_header(skb) + ctx->offset);
 	thoff = (iph->ihl * 4) + ctx->offset;
@@ -662,10 +660,8 @@ static int nf_flow_offload_ipv6_forward(struct nf_flowtable_ctx *ctx,
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
 
 	mtu = flow->tuplehash[dir].tuple.mtu + ctx->offset;
-	if (unlikely(nf_flow_exceeds_mtu(skb, mtu))) {
-		flow_offload_teardown(flow);
+	if (unlikely(nf_flow_exceeds_mtu(skb, mtu)))
 		return 0;
-	}
 
 	ip6h = (struct ipv6hdr *)(skb_network_header(skb) + ctx->offset);
 	thoff = sizeof(*ip6h) + ctx->offset;
-- 
2.30.2

