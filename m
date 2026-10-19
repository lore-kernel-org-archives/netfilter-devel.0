Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792422193;
	b=lQ2LaULEMmZ+WLUbca3HbTxZaydV9BdB7hPRYrCJNVzNH8QU1zvo5xb5Q95E7P/kUvTY
	 STFzrN4oSyT8LtyS5I8XdVgmGkvNMdHUupV3eLlKxlmX+H1HpC01b6VilsTaGfH4wy5OP
	 RyvDTwKiZ7X0iQnsjt/XbKYB76v86rkERsWlljUW2n0UVVwxyR+sUH+IlWCRFA1NwFlEy
	 Jl9zMmCZqw+lZ24tcOPIE60tRwCuO8qD6EjMvCEG6ZKMj3Pz/f6iCgZo5mcZeim4X9idQ
	 eDChKhRkMe04Z0pJbJsfTNBtGWvzvNrdU9GIpRWNS/KRXH7GtY5U9z4gDxHL+Ie4rRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792422193;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=FCRhwFDKUPCGVOrQpwOVNJDTi0vWDTAgAftOWG5Jrkg=;
	b=H9CRhxY0FyPq+MEGv9vSGDl961W0r0kLVEsDzYTf8ZFwGfJEFsBYutxwbS9SH83nJH2e
	 YFwvzMvWvGY6x7/PT2SrNFfaRIKWodWlPNiBIR3xAUasauIouCnFeqxAI89SS5N13JVSk
	 FMQKJdNfu5sqsEKw9sPanC/nS71kjXH1cZSo6N4+tXwGKQrkK+r//Lgw0JYFpSjs1LEyq
	 D5xTg3c3L4TUnqVCa9hLyHv7XwEMw/FkKLqt/1TXtoASZ8gJI8Ps4Tw560YmJWrepGF2y
	 YmhyX4jFRVcP/LJLpDxlk/6e6A0JG5390L1+9RnDgUEVAaC0Pie/YvDLhVPRvtaPUqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b="v/Dz9XGa";
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECBB2607D370;
	Mon, 19 Oct 2026 15:03:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ECBB2607D370
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=v/Dz9XGa
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792422191;
	bh=FCRhwFDKUPCGVOrQpwOVNJDTi0vWDTAgAftOWG5Jrkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v/Dz9XGauFQWm0D4qfsHJP3ICzn9Uq0SChyJF0Y5GHLy50iSrVsRb+4Nl5s9Qi1WT
	 wDMmwST4nfejrt4tXyQja2JY5j9AOgOVSdQh4xruv0qONpBjykRvkoJwxzhhbl+kg8
	 q+c9RaRtbyhimB6T45D7Bgl4vvMjc1QqnApiv34mMrap0B49auExcbbbXeos/dkw+D
	 Ht8nxEI7hpSelBPXrSF649WxLoAFFumcglBI0mISkSeyFiyfbRFS5/7uGBY804G0RF
	 OmsOGMp2EL8tXiynu/hajs5cEmR3YzQvmF6Alm2HKY+l0aWlvB3PzuPLpt24m/wZRd
	 AzMSQ6WBWQQNw==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 7451B6005E;
	Mon, 19 Oct 2026 17:03:10 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@kernel.org,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 09/10] netfilter: flowtable: reset transport header after nf_flow_encap_pop()
Date: Mon, 19 Oct 2026 17:02:48 +0200
Message-ID: <20261019150249.1879516-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261019150249.1879516-1-pablo@netfilter.org>
References: <20261019150249.1879516-1-pablo@netfilter.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

nf_flow_encap_pop() pulls vlan/pppoe or ip tunnel headers and resets the
network header, but leaves the transport header pointing into the removed
outer header. Reset the transport header to the inner L4 header, otherwise
later consumers (e.g. GSO segmentation) parse a bogus header.

Fixes: 4cd91f7c290f ("netfilter: flowtable: add vlan support")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_ip.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 2dec15d402ca..bb894c4f2b4a 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -502,6 +502,7 @@ static int nf_flow_offload_forward(struct nf_flowtable_ctx *ctx,
 
 	nf_flow_encap_pop(ctx, skb, tuplehash);
 	thoff -= ctx->offset;
+	skb_set_transport_header(skb, thoff);
 
 	iph = ip_hdr(skb);
 	nf_flow_nat_ip(flow, skb, thoff, dir, iph);
@@ -1097,6 +1098,7 @@ static int nf_flow_offload_ipv6_forward(struct nf_flowtable_ctx *ctx,
 	flow_offload_refresh(flow_table, flow, false);
 
 	nf_flow_encap_pop(ctx, skb, tuplehash);
+	skb_set_transport_header(skb, sizeof(*ip6h));
 
 	ip6h = ipv6_hdr(skb);
 	nf_flow_nat_ipv6(flow, skb, dir, ip6h);
-- 
2.47.3

