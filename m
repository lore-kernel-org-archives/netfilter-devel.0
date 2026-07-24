Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED2D73A9632;
	Fri, 24 Jul 2026 07:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784877927; cv=none; b=QT4QvOhI81P8l6eStArc2084KatsCLxqVjLPdD25iUdrfoYANQ1YYtMHgoW8fzjMdyjPrOhAB/mDxADm6Q9LHAV4bnVCc6WFPRX1RORIdz+tWjbKJS+/fl5wMGwhiC8r4h8OAriYefC67F5BuVLC2x2z47KT+9acscF1CoDH+kM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784877927; c=relaxed/simple;
	bh=DEVYDfMKBm3IARX9KWdInCt7Umc8cb8rntG8k+OqTrw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=FB4HliEl3E37LolN6qFgisB4UVIXhQNJJQ+qw1HryxbyW3NCWxivJdBJXvL87g0KXzhZNULrq3uQ2aeC20PawTppdEEeJnzZaBquBSwQBYDZe8Yh2CmPDU59FBjvt8l7lIWT5ttprpGplxJVlxf+WW8YbOKNJjv8+j6M1uq2v2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Oq/vMj0t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Oq/vMj0t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F32CA1F000E9;
	Fri, 24 Jul 2026 07:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784877925;
	bh=WsRSAk6YY6P1Plmx+ZS65LWEWpi9yHtNHpVjM9Z0l/k=;
	h=From:Date:Subject:To:Cc;
	b=Oq/vMj0t+SkKC8igA62i2ICjlE9gynpQ6gD8grG0K4G2ddoTxmFrQj8eBWirZsfu1
	 wwOl8zua9NuVdrtI1+6UkiCrDfPPXSmf8qrCpvP211NtDNqv2ZkSUKRu4xcltoMQPs
	 zNuK5rkmxxRD0PaVWjDEiKCb3A+OUO+teldEKfU4Fg+AUrnL/ljGXDLiYK7LBxaGW3
	 B7WlkWFwjRgLIhsDbV2HecXrsW3Gpuy5/j/1DOvhl5aVc2DOZZWt2J0pr6nicEib/G
	 D3qLtg4nUB9+3kio7bv2sA163/Px03LvvbiaVDDD/SlGvgLUGSc15OC5N/8eMBz4Jp
	 w6NuLkhStcrnQ==
From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Fri, 24 Jul 2026 09:25:00 +0200
Subject: [PATCH net-next v3] net: ip6_tunnel: use tunnel parameters for
 fill_forward_path route lookup
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260724-ip6ip6-route-lookup-fill_forward_path-v3-1-7b7991538614@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/5WOywrCMBREf6Vk7ZUkrWnjyv8QkT5ubLAk4TbWS
 um/G7rSncJshoFzZmEjksWRHbOFEU52tN6lku8y1va1uyHYLnUmuVS85BXYoFKA/CMiDN7fHwG
 MHYar8fSsqbuGOvagTVscai1EhZolViA0dt48Z+YwgsM5sktaejtGT6/twCS2/U/XJEBApfJGq
 6IUXOLpjuRw2Hu6bYpJfmCl/BUrE9YY3pQNF7nS+gu7rusb3TLqIzwBAAA=
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
correct conditional FLOWLABEL masking based on the
IP6_TNL_F_USE_ORIG_FLOWLABEL flag.

Return -EOPNOTSUPP when IP6_TNL_F_USE_ORIG_TCLASS,
IP6_TNL_F_USE_ORIG_FLOWLABEL or IP6_TNL_F_USE_ORIG_FWMARK is set,
or for collect_md tunnels, since fill_forward_path has no access to
the original skb and cannot recover the per-packet traffic class,
flowlabel, mark or tunnel destination needed for the route lookup.

Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
Changes in v3:
- Return EOPNOTSUPP when IP6_TNL_F_USE_ORIG_TCLASS is set or for collect_md tunnels
- Link to v2: https://lore.kernel.org/r/20260722-ip6ip6-route-lookup-fill_forward_path-v2-1-ff0b7b013699@kernel.org

Changes in v2:
- Reuse flowi6 template for the route lookup
- Return EOPNOTSUPP if the tunnel is configured with
  IP6_TNL_F_USE_ORIG_FWMARK or IP6_TNL_F_USE_ORIG_FLOWLABEL
- Use flowi6 fields to setup net_device_path
- Link to v1: https://lore.kernel.org/r/20260708-ip6ip6-route-lookup-fill_forward_path-v1-1-863b9647102e@kernel.org
---
 net/ipv6/ip6_tunnel.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index bf8e40af60b0..97c3f61d627b 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1845,24 +1845,30 @@ static int ip6_tnl_fill_forward_path(struct net_device_path_ctx *ctx,
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
+	if (t->parms.flags & (IP6_TNL_F_USE_ORIG_TCLASS |
+			      IP6_TNL_F_USE_ORIG_FLOWLABEL |
+			      IP6_TNL_F_USE_ORIG_FWMARK))
 		return -EOPNOTSUPP;
-	}
+
+	if (t->parms.collect_md)
+		return -EOPNOTSUPP;
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
base-commit: 89d8006259b81dd25c962f6cc8d7ab268d6ea426
change-id: 20260708-ip6ip6-route-lookup-fill_forward_path-9fc45a9118e9

Best regards,
-- 
Lorenzo Bianconi <lorenzo@kernel.org>

