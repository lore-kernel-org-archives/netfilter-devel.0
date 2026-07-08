Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F55136C592;
	Wed,  8 Jul 2026 12:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783514925; cv=none; b=L41WWw13SKHaFDNOVuQY9ldYnzJ/EBCt7wgl77XACC5Lfr/o031HqxCQvDnU/7QpagcXRD1xKQxQ5AODjdyKCHowXPtpsEwVgZQ0AN5mJdQUWKqqlL9j9YU9AKEBggqXALpbOcsWdH3eC4VHHVYxufa6T7BCQdWydJi9/HZjz2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783514925; c=relaxed/simple;
	bh=1v9gi2AEkBMEA2mRyZBiOEF7xQVkeUQRC8vf3RMsBg0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=G93UvomYv84eRC/IXrQxORyU3HduWeL/Klz77SklSN8GB51dQ5Aprq8x/ZYgccMz7N1DeAe3qLqnz/q7s6jXuVamDxNhGxEqSsbr1Oy+v6WpxGU/9VFkWKiUZAukwKF5Z8awBmTTT5LhTWvDYT1xjNa6ueL+B+CbcUx/zQHUR5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NgLoUN+V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NgLoUN+V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F8D61F000E9;
	Wed,  8 Jul 2026 12:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783514924;
	bh=Ss3ktjgLTrUfnRyyBurg+0JT9wxIeMA/04p7rsp5/WU=;
	h=From:Date:Subject:To:Cc;
	b=NgLoUN+VO6vcaXhgr70iHlF9fPMFzGsyK2Nai9wsNkanvpbIUMmVQkiDmALzl7i9s
	 ktCNgjJy3UiQNDMWMG/I5p3kjiXxUL4umLStv/q5b8LqZOBKVfGx8ptec/yNiZLtgo
	 TSbAeQaD2nWHQSRgiyQp/5ut7/AfpQjqdU9VhNaDc/HyL1/4OZPUrkNW87c1DlxKpk
	 n7++mBNfdt+RsvQuAtLCHAKo818yqaIAiBN7UkoswO7oNtpj/jURWPdazA+iY4q8yi
	 3fdKTvFA3h3/BAWZ16G9bwJeACzesu0HzAxf7vdunNFk+uOoYjCWw8ntttAqQYAfF9
	 ggIlEv3mKQqng==
From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Wed, 08 Jul 2026 14:48:28 +0200
Subject: [PATCH net-next] net: ip6_tunnel: use tunnel parameters for
 fill_forward_path route lookup
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260708-ip6ip6-route-lookup-fill_forward_path-v1-1-863b9647102e@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x2NQQqDMBAAvyJ77kIirZp+pYgE3ejSkIRNbAXx7
 w2Fucxl5oRMwpTh2Zwg9OHMMVTRtwbmzYaVkJfq0Kq2U70akFNXQYl7IfQxvveEjr2fXJSvlWV
 Ktmxo3Hx/WKP1QAZqKwk5Pv6fFwQqGOgoMF7XD5s3tNCBAAAA
X-Change-ID: 20260708-ip6ip6-route-lookup-fill_forward_path-9fc45a9118e9
To: David Ahern <dsahern@kernel.org>, Ido Schimmel <idosch@nvidia.com>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, Pablo Neira Ayuso <pablo@netfilter.org>, 
 Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, 
 Lorenzo Bianconi <lorenzo@kernel.org>
X-Mailer: b4 0.14.3

Pass source address, output interface and flowlabel (carrying TClass
and flow label) from the tunnel configuration to the flowi6 struct in
ip6_tnl_fill_forward_path(), aligning the route lookup with the slow
path in ipxip6_tnl_xmit().

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 net/ipv6/ip6_tunnel.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index bf8e40af60b0..557d8637ac57 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1847,6 +1847,10 @@ static int ip6_tnl_fill_forward_path(struct net_device_path_ctx *ctx,
 	struct ip6_tnl *t = netdev_priv(ctx->dev);
 	struct flowi6 fl6 = {
 		.daddr = t->parms.raddr,
+		.saddr = t->parms.laddr,
+		.flowi6_oif = t->parms.link,
+		.flowlabel = t->parms.flowinfo &
+			     (IPV6_TCLASS_MASK | IPV6_FLOWLABEL_MASK),
 	};
 	struct dst_entry *dst;
 	int err;

---
base-commit: 08030ddb87b4c6c6a2c03c82731b5e188f02f5b9
change-id: 20260708-ip6ip6-route-lookup-fill_forward_path-9fc45a9118e9

Best regards,
-- 
Lorenzo Bianconi <lorenzo@kernel.org>

