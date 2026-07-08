Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C4FB3A8741;
	Wed,  8 Jul 2026 11:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783509938; cv=none; b=kEuSdZT9GCUe8IaySkK81ee0koyzWJBUE+2A/tPteQbmDXT8ndD9N8EK7fUDT2OaSI44fdngK4kMaR0Ffdl6EN/Zo7UQGKS4OzTkvxakMH3JZaoP+Bb1vVcH9VgLG3nFchfAH2nNyl7wWt3zoGBa9qkeU2AVq8/XsIUWo0jyqo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783509938; c=relaxed/simple;
	bh=84PMDdJTdc/8LkogfzioAu97kqRYNS20rB39544MOHQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=T+MWKZUFzZhp/W5hVDnctJzO8J0RFP3qkzBSeqrPeu/Vt6GrkGfvvJofRatPysrQDSXnQBPQN9C5Cj+qxKSMPVHRqnTF6OXc5ZZxLqyTwDVygMm2lSvdU2D6CBGZw82xNIogkNDaJW8cld1aRGs95vkSXaIUbPI5M/wTyCEa78c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JhBTlTRA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JhBTlTRA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68E151F000E9;
	Wed,  8 Jul 2026 11:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783509936;
	bh=pUsFCtblw0cweRpabo6PXQ27P9GWRIBHnxgFsdpDEDI=;
	h=From:Date:Subject:To:Cc;
	b=JhBTlTRAhjMj6IVDdcT5EXTHk++LNouH6kSZVOh9nR0IWGaEOc27fU4CMV/HenJH3
	 ztMJlQQLmhsCcSZvdduRYWePMQ3Ue1skeaDNkuGs2BdAn1Fr0kcKkDDvII8n/CLiEM
	 qChYpekqniRd9z5COrVyV2Zsgy8KD0Zs0l/DKQtFtO5KuR/AyzXT122sbIh64hJjRy
	 LvmCew4rAAK+1HKqnm+jYuwm8bJLjBfuNBuF/BiOHENg8hA8jndyncpb82BADESFMt
	 VZOlQJfjeAzCQ3ogIsfpN4lQLvCyzrxce/OYMUUe2RvGpivWtFJEnRBeQM5LPinQ/M
	 6LNtpxUzYDuzA==
From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Wed, 08 Jul 2026 13:25:18 +0200
Subject: [PATCH net-next] net: ipip: use tunnel parameters for
 fill_forward_path route lookup
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260708-ipip-route-lookup-fill_forward_path-v1-1-b77df74822ed@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x3NQQqDMBBA0avIrDsQRW3oVUqRQSd1aEjCJLaCe
 HdDl2/z/wGZVTjDozlA+StZYqhobw3MK4U3oyzV0JluNHdjUZIk1LgVRh/jZ0voxPvJRf2RLlO
 isuJIllrXD8b2M9RSUnay/y9PCFww8F7gdZ4Xu69mrX8AAAA=
X-Change-ID: 20260708-ipip-route-lookup-fill_forward_path-6a8a1f45084c
To: David Ahern <dsahern@kernel.org>, Ido Schimmel <idosch@nvidia.com>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, Pablo Neira Ayuso <pablo@netfilter.org>, 
 Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, 
 Lorenzo Bianconi <lorenzo@kernel.org>
X-Mailer: b4 0.14.3

Pass source address, DSCP and output interface from the tunnel
configuration to ip_route_output() in ipip_fill_forward_path(), aligning
the route lookup with the slow path in ipip_tunnel_xmit().

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 net/ipv4/ipip.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/ipip.c b/net/ipv4/ipip.c
index b643194f57d2..d1aa048a6099 100644
--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -360,8 +360,9 @@ static int ipip_fill_forward_path(struct net_device_path_ctx *ctx,
 	const struct iphdr *tiph = &tunnel->parms.iph;
 	struct rtable *rt;
 
-	rt = ip_route_output(dev_net(ctx->dev), tiph->daddr, 0, 0, 0,
-			     RT_SCOPE_UNIVERSE);
+	rt = ip_route_output(dev_net(ctx->dev), tiph->daddr, tiph->saddr,
+			     inet_dsfield_to_dscp(tiph->tos),
+			     tunnel->parms.link, RT_SCOPE_UNIVERSE);
 	if (IS_ERR(rt))
 		return PTR_ERR(rt);
 

---
base-commit: 155c68aef2397f8c5d72ef10acf48ae159bf1869
change-id: 20260708-ipip-route-lookup-fill_forward_path-6a8a1f45084c

Best regards,
-- 
Lorenzo Bianconi <lorenzo@kernel.org>

