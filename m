Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1AAD3BB12C;
	Wed, 22 Jul 2026 07:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784704390; cv=none; b=GBayEAkEgUPuCBZyZGMVJGCJPNiiHytL3q9sBpATrxW8wb78anZf03aqeYBDvrtfKyhk7QmRbXH1V6WlJzjdJk/d6ySck60ROl+OPKeyxqUBAKeUHUaLYGPKMyigcBlBUjYDIfRupIDvK9vaYZLkh++eAqEqRWFQFpiFzbiCmhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784704390; c=relaxed/simple;
	bh=QcS4Np0N9VqNKZuPeRX0MYJx1nNT2QZbIVEf9kxYwoI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=bqRH1H4ufs2yTTwnM2lnEYtiuYYruEIk9RR7ERTyibkn6jwq36G5yKzjNeM1Yh26N7iHBkq77kFEWRuoZ04uZ2XBC+zWgLadAAlnDZmUcozV97lHbLbzAihhaeieFDZQbowSXUyX9ED2rrgh2J2GN9aT09I41zuhYV7ysqLe1xQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IY6TolyO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IY6TolyO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E73C91F000E9;
	Wed, 22 Jul 2026 07:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784704389;
	bh=J0VpLcMzzu2U7Y+PkMyO7ZweUe1yAX+ZlJIfYx22x5w=;
	h=From:Date:Subject:To:Cc;
	b=IY6TolyOIarPghXxRvwTSRb1aiTpuEc5aj4M2yGFD6uOLomv+2ly/NT3v9mZIKEt8
	 c4H/UR+Y90toas9bnbDqO5KOODpdk9sp1G5xiNSdUX9rYNI9AdffAbLdzMl3xbjweA
	 b/F7sdiVShZXKjw6tdS0tKbZ8xLwIKC497AXDDdqNTguJCwRI37wT/0OMjF6I/NEKC
	 fccfnQGEAsulzS0KywamhnfrrUbYKPE/SO/uc4D/WeiO81R48Zou2Szl3v47oteVGd
	 8W9AqzmcqSZSxq6qSKzdHRk2E/hGb3ODzx/m8tg0SLV+oSVWA85f9NjUeq7woHfCBp
	 naQeiaMztCrIw==
From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Wed, 22 Jul 2026 09:12:47 +0200
Subject: [PATCH net-next v2] net: ip6_tunnel: use tunnel parameters for
 fill_forward_path route lookup
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260722-ip6ip6-route-lookup-fill_forward_path-v2-1-ff0b7b013699@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/5WOUQqDMBBEryL73S0mtdH0q/coIlZXDUoS1mgt4
 t0bvEFhfh4D82aHmdjQDI9kB6bVzMbZCPKSQDPUtic0bWSQqVRpnhZovIpBdksgnJwbF4+dmaa
 qc/ypua18HQbUXZPday1EQRrilmfqzHZ6XmApoKUtQBmbwczB8fc8sIqz/9O1ChRYqNtbqywXq
 aTnSGxpujruoTyO4wfxW5DC5QAAAA==
X-Change-ID: 20260708-ip6ip6-route-lookup-fill_forward_path-9fc45a9118e9
To: David Ahern <dsahern@kernel.org>, Ido Schimmel <idosch@nvidia.com>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, Pablo Neira Ayuso <pablo@netfilter.org>, 
 Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, 
 Lorenzo Bianconi <lorenzo@kernel.org>
X-Mailer: b4 0.14.3

Reuse the flowi6 template t->fl.u.ip6 built by ip6_tnl_link_config() in
ip6_tnl_fill_forward_path(), aligning the fast-path route lookup with
the slow path in ipxip6_tnl_xmit(). This automatically inherits the
correct conditional TCLASS and FLOWLABEL masking based on the
IP6_TNL_F_USE_ORIG_TCLASS and IP6_TNL_F_USE_ORIG_FLOWLABEL flags.

Return -EOPNOTSUPP when IP6_TNL_F_USE_ORIG_FLOWLABEL or
IP6_TNL_F_USE_ORIG_FWMARK is set, since fill_forward_path has no
access to the original skb and cannot recover the per-packet flowlabel
or mark needed for the route lookup.

IP6_TNL_F_USE_ORIG_TCLASS no longer triggers -EOPNOTSUPP: it only
affects the outer DS field, not the route lookup's flowi6.flowlabel
(the template leaves TCLASS bits zero when this flag is set, matching
the slow path).

Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
Changes in v2:
- Reuse flowi6 template for the route lookup
- Return EOPNOTSUPP if the tunnel is configured with
  IP6_TNL_F_USE_ORIG_FWMARK or IP6_TNL_F_USE_ORIG_FLOWLABEL
- Use flowi6 fields to setup net_device_path
- Link to v1: https://lore.kernel.org/r/20260708-ip6ip6-route-lookup-fill_forward_path-v1-1-863b9647102e@kernel.org
---
 net/ipv6/ip6_tunnel.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index bf8e40af60b0..2708d5567c6a 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1845,24 +1845,26 @@ static int ip6_tnl_fill_forward_path(struct net_device_path_ctx *ctx,
 				     struct net_device_path *path)
 {
 	struct ip6_tnl *t = netdev_priv(ctx->dev);
-	struct flowi6 fl6 = {
-		.daddr = t->parms.raddr,
-	};
 	struct dst_entry *dst;
+	struct flowi6 fl6;
 	int err;
 
-	if (!(t->parms.flags & IP6_TNL_F_IGN_ENCAP_LIMIT)) {
-		/* encaplimit option is currently not supported is
-		 * sw-acceleration path.
-		 */
+	if (t->parms.flags & (IP6_TNL_F_USE_ORIG_FLOWLABEL |
+			      IP6_TNL_F_USE_ORIG_FWMARK))
 		return -EOPNOTSUPP;
-	}
+
+	if (!(t->parms.flags & IP6_TNL_F_IGN_ENCAP_LIMIT))
+		return -EOPNOTSUPP;
+
+	memcpy(&fl6, &t->fl.u.ip6, sizeof(fl6));
+	fl6.flowi6_mark = t->parms.fwmark;
+	fl6.flowi6_proto = 0;
 
 	dst = ip6_route_output(dev_net(ctx->dev), NULL, &fl6);
 	if (!dst->error) {
 		path->type = DEV_PATH_TUN;
-		path->tun.src_v6 = t->parms.laddr;
-		path->tun.dst_v6 = t->parms.raddr;
+		path->tun.src_v6 = fl6.saddr;
+		path->tun.dst_v6 = fl6.daddr;
 		path->tun.l3_proto = IPPROTO_IPV6;
 		path->dev = ctx->dev;
 		ctx->dev = dst->dev;

---
base-commit: df13c1df8147675470213ffff29dd5762fa321f5
change-id: 20260708-ip6ip6-route-lookup-fill_forward_path-9fc45a9118e9

Best regards,
-- 
Lorenzo Bianconi <lorenzo@kernel.org>

