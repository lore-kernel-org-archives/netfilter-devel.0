Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 949693C417F;
	Tue, 23 Jun 2026 22:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782252960; cv=none; b=PrTJE4NZDfgW//hACx6PQjxdMK8JXgNCRbdV2ZFDKwC+XsYrOyLn4Bmv+hBGTPrqG6NBAcaxYni7Rf7JoEAgzu7COwJCpvkWm047OW/BgR84MXBKq5aJMOV4q2QCUp1P6niKeWBG56J0CxL8J9L81JUtnCoKh393vMp4HwNJShg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782252960; c=relaxed/simple;
	bh=HrTNQeIJ7ETzm12mosv7neJFV5Vng/StKGaaY4MuzMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L5wY60g2lJzMiX1lJGQOVybeSNx+UTYObNKPOBf6iL7dAoG1x+ojsot2mB6peFCgtq+xiSYTIxPBN0+KlOC4wVzot7Pd0vwHfiRPjB9N0yjV7p0TwryLzulH49K+/JK+waa9QW9yzPUBIGmKwm/XOOsd26zrKFXrrg+STellHGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=rI5iF+9s; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="rI5iF+9s"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id AEC5B60579;
	Wed, 24 Jun 2026 00:15:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1782252957;
	bh=oubevtyeMm2nCyrP79NnTfzja3bRJR62KjsEtES6KMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rI5iF+9su1h/dqabinwXLq/hSXO/so4K4XLslcFEzc/LUZsCWCZ6SsMcsoAHLz47L
	 INl3siD1LL3DWzr+ZUckYJiMfzpv+Agt648ikvlxjFzwij7JLA7L/8GZX9AMN4MFEF
	 1pHSF6yHUOBdK6NHmOjGwUJukIv/ok42jVQH1LoeLobo6g9TGqf+W8ui7PJ3w6qyk3
	 Hw3rsSvDp/B4zPkNPcXlDh/3YIazw2oGY4rwCZrYs7vEQFjBwuP+X080k81sUOp7sE
	 7tb8mgsEupCvUzoBNNscRoQN8XOVDNMdsUXPZdw8hpW3piK5W2pzeY3ODCwnDHvqBQ
	 qxU9O3NKstzhw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 03/14] netfilter: flowtable: Validate iph->ihl in nf_flow_ip4_tunnel_proto()
Date: Wed, 24 Jun 2026 00:15:36 +0200
Message-ID: <20260623221548.701545-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260623221548.701545-1-pablo@netfilter.org>
References: <20260623221548.701545-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Lorenzo Bianconi <lorenzo@kernel.org>

Add sanity check for iph->ihl field in nf_flow_ip4_tunnel_proto() before
using it to compute the header size, avoiding out-of-bounds access with
malformed IP headers.
While at it, use iph->protocol instead of the hardcoded IPPROTO_IPIP
constant when setting ctx->tun.proto and reference ctx->tun.hdr_size
when updating ctx->offset.

Fixes: ab427db178858 ("netfilter: flowtable: Add IPIP rx sw acceleration")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_ip.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index e7a3fb2b2d94..29e93ac1e2e4 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -326,8 +326,10 @@ static bool nf_flow_ip4_tunnel_proto(struct nf_flowtable_ctx *ctx,
 		return false;
 
 	iph = (struct iphdr *)(skb_network_header(skb) + ctx->offset);
-	size = iph->ihl << 2;
+	if (iph->ihl < 5)
+		return false;
 
+	size = iph->ihl << 2;
 	if (ip_is_fragment(iph) || unlikely(ip_has_options(size)))
 		return false;
 
@@ -335,9 +337,9 @@ static bool nf_flow_ip4_tunnel_proto(struct nf_flowtable_ctx *ctx,
 		return false;
 
 	if (iph->protocol == IPPROTO_IPIP) {
-		ctx->tun.proto = IPPROTO_IPIP;
+		ctx->tun.proto = iph->protocol;
 		ctx->tun.hdr_size = size;
-		ctx->offset += size;
+		ctx->offset += ctx->tun.hdr_size;
 	}
 
 	return true;
-- 
2.47.3

