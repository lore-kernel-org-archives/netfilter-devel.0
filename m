Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D7CE403150;
	Sun, 11 Oct 2026 22:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791756004; cv=none; b=u8nvVz6a/nu1dAyyBONtvtf4wNojmsMy1O4GMP3BEaMXBKz6N9QmVl+ll5aEtxd/+hjhcrYgjuMIMFteIwWZM7au8A//zUwzEbfWWLH5dReiKVdaaia+bk6gz7WHK7DcdVfxZ9+6ErqhPdkgamERhhQ9Nb9Nrjp2HRbdMnPmNSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791756004; c=relaxed/simple;
	bh=VnAdcLaoCHkRmKFv2Iunxu7chaYFnMY/THV56wuNbuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WsG0AWhBtc2miyKP4eAk535l4BPrOb7VwoZ2awXJwzR2ffkPs6M8KmgflPLqxhaOi4HFK7ocPF398Ix0mvQWOSbaGHj8wRaLSBJi7443PYZTyuKHnQ5do1BtQba5Eim2qd+SpO6khCcr4wWO2ICKGl3qsI9C/ZqGak2OOvuoHVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Sgq+xzS7; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Sgq+xzS7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1791756001;
	bh=VgxcTg6BeEP/WBXUL39BjwpOvumOutBr0NLBzBVUSSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sgq+xzS7didi5LlwjuOYmoCF1XzBFHZ7EmHuJf5mghTYkUCNJWWJ8VbL1X3+17qiq
	 JtDGToka8yOYOxR5eqIiVldxO/xUWQ4HClf3Z+JQAN46bh1BdAFGDAxllIzRc+kjI9
	 TDPbsHgPtwnlBc35bWMzO6Bo2gfcs6qTFRWRXxapOy4tha4C6NNHXQlGejP8/uREvX
	 bsLZceckGGoLb+5pk+tyysgfCq0gJjLi4tAuYNpf7LJIy/QsJdDVxSZeUsHJ4wt490
	 pj5mNAWPMaoMzfKVNyN71Ld2YmTYGcnwju3uug3KVGMWq7Ygl3gSNQbkB1Gd/HkwYB
	 1rwVu2iaqojUg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id BAA5460076;
	Mon, 12 Oct 2026 00:00:00 +0200 (CEST)
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
Subject: [PATCH net-next 02/15] netfilter: flowtable: recognize IPv4/IPv6 in tunnel proto matching
Date: Sun, 11 Oct 2026 23:59:40 +0200
Message-ID: <20261011215953.1334630-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261011215953.1334630-1-pablo@netfilter.org>
References: <20261011215953.1334630-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

Allow the flowtable to parse IPv4-in-IPv6 and IPv6-in-IPv4 tunnels by
accepting both IPPROTO_IPIP and IPPROTO_IPV6 as the inner protocol when
walking the outer header in nf_flow_ip4_tunnel_proto() and
nf_flow_ip6_tunnel_proto(). This is a preliminary patch to support IPv4
over IPv6 and SIT tunnel flowtable offload.
Please note IPv4 over IPv6 and SIT tunnel flowtable offloading is not
enabled yet.

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_ip.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index c8c29a9a1684..42e8de696474 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -326,7 +326,7 @@ static bool nf_flow_ip4_tunnel_proto(struct nf_flowtable_ctx *ctx,
 	if (iph->ttl <= 1)
 		return false;
 
-	if (iph->protocol == IPPROTO_IPIP) {
+	if (iph->protocol == IPPROTO_IPIP || iph->protocol == IPPROTO_IPV6) {
 		ctx->tun.inner_proto = iph->protocol;
 		ctx->tun.hdr_size = size;
 		ctx->offset += ctx->tun.hdr_size;
@@ -351,7 +351,7 @@ static bool nf_flow_ip6_tunnel_proto(struct nf_flowtable_ctx *ctx,
 	if (ipv6_ext_hdr(ip6h->nexthdr))
 		return false;
 
-	if (ip6h->nexthdr == IPPROTO_IPV6) {
+	if (ip6h->nexthdr == IPPROTO_IPIP || ip6h->nexthdr == IPPROTO_IPV6) {
 		ctx->tun.inner_proto = ip6h->nexthdr;
 		ctx->tun.hdr_size = sizeof(*ip6h);
 		ctx->offset += ctx->tun.hdr_size;
-- 
2.47.3

