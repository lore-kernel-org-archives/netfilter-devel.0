Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3498B371D00
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Jun 2026 11:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781005942; cv=none; b=hfbbhjmT9Dy+07+za79LR5byy6WtEhN9br7n8TRJdLeES1b+/aG+Wo7rQjm7/k/9YqJXN+ZeTa61Xx8P4zHBkXOnvX2T3W0sp1X0tPBap03iRa0j5a3//UiGlgkEOJC6VdZq9XfzvyXWkgSWuY/PtS/rPtbdtuSx5xvpqi3H9ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781005942; c=relaxed/simple;
	bh=EQtR6V/4fsGNduXxz+CYPfoGbPYVslMJ5fSjo+AhANo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oQmloajud00S6JI3vQVV6qDEzHtTwmZFl8RQ6LHpLF81WVufOY2hT1PO50JwEPRmDPBYT/QAttDUhQjtvpZdOPrkCPYy60AcOY+nm4L1WqGFwg+IcpOJPpBY/RNOFCNfjGzNg51kWGVlhEKxRzk+bQnIQMaMkXtkYxPTNnuHZUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id AA037605BD; Tue, 09 Jun 2026 13:52:19 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH v3 nf-next 3/3] netfilter: nftables: restrict checkum update offset
Date: Tue,  9 Jun 2026 13:51:55 +0200
Message-ID: <20260609115201.2563-4-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260609115201.2563-1-fw@strlen.de>
References: <20260609115201.2563-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After previous patch, writes to network header are restricted.
However, there is another way to manipulate the l3 header: The
checksum update function.

Restrict this for network header writes, only the ipv4 header is
allowed.  This needs run-time checks because BRIDGE, INET, NETDEV
families can carry l3 headers other than IP.

checksum updates to the udp/tcp (l4) headers are not restricted.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v3: no changes.

 net/netfilter/nft_payload.c | 100 ++++++++++++++++++++++++++++++++++++
 1 file changed, 100 insertions(+)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 8e4388bee459..a8ba9dacde62 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -990,6 +990,83 @@ static bool nft_ll_write_ok(const struct nft_pktinfo *pkt, int offset)
 	return offset <= skb_network_offset(pkt->skb);
 }
 
+static bool nft_payload_validate_inet_csum_offset(const struct nft_ctx *ctx,
+						  const struct nft_payload_set *priv)
+{
+	switch (priv->base) {
+	case NFT_PAYLOAD_LL_HEADER:
+		break;
+	case NFT_PAYLOAD_NETWORK_HEADER:
+		if (ctx->family == NFPROTO_IPV4) {
+			if (offsetof(struct iphdr, check) == priv->csum_offset)
+				return true;
+
+			return false;
+		}
+		return true; /* run time validation required */
+	case NFT_PAYLOAD_TRANSPORT_HEADER:
+		if (priv->csum_flags) /* makes no sense, asks for "re-update" of L4 checksum */
+			return false;
+
+		/* no further check here; offset can't be negative so bogus
+		 * offsets can corrupt L4 or payload but not l3 headers.
+		 * We already allow arbitrary l4/inner payload writes.
+		 */
+		return true;
+	case NFT_PAYLOAD_INNER_HEADER:
+		return true;
+	case NFT_PAYLOAD_TUN_HEADER:
+		break;
+	}
+
+	return false;
+}
+
+/* do not allow arbitrary network header mangling via bogus csum_off.
+ * We only support ipv4.  Only NFPROTO_IPV4 can be checked from control
+ * plane.
+ */
+static bool nft_payload_csum_nh_write_ok(const struct nft_payload_set *priv,
+					 const struct nft_pktinfo *pkt)
+{
+	switch (pkt->state->pf) {
+	case NFPROTO_IPV4:
+		/* Warning: NFPROTO_INET was not checked; we can't return true here. */
+		return priv->csum_offset == offsetof(struct iphdr, check);
+	case NFPROTO_IPV6:
+		return false;
+	case NFPROTO_BRIDGE:
+		return pkt->ethertype == htons(ETH_P_IP) &&
+		       priv->csum_offset == offsetof(struct iphdr, check);
+	case NFPROTO_NETDEV:
+		return pkt->skb->protocol == htons(ETH_P_IP) &&
+		       priv->csum_offset == offsetof(struct iphdr, check);
+	}
+
+	return false;
+}
+
+static bool nft_payload_csum_write_ok(const struct nft_pktinfo *pkt,
+				      const struct nft_payload_set *priv)
+{
+	switch (priv->base) {
+	case NFT_PAYLOAD_LL_HEADER:
+		break;
+	case NFT_PAYLOAD_NETWORK_HEADER:
+		return nft_payload_csum_nh_write_ok(priv, pkt);
+	case NFT_PAYLOAD_TRANSPORT_HEADER:
+	case NFT_PAYLOAD_INNER_HEADER:
+		/* neither offsets are validated, offsets cannot be
+		 * negative so real l3 headers cannot be mangled.
+		 */
+		return true;
+	case NFT_PAYLOAD_TUN_HEADER:
+		break;
+	}
+
+	return false;
+}
+
 static void nft_payload_set_eval(const struct nft_expr *expr,
 				 struct nft_regs *regs,
 				 const struct nft_pktinfo *pkt)
@@ -1054,6 +1131,7 @@ static void nft_payload_set_eval(const struct nft_expr *expr,
 		tsum = csum_partial(src, priv->len, 0);
 
 		if (priv->csum_type == NFT_PAYLOAD_CSUM_INET &&
+		    nft_payload_csum_write_ok(pkt, priv) &&
 		    nft_payload_csum_inet(skb, src, fsum, tsum, csum_offset))
 			goto err;
 
@@ -1120,7 +1198,26 @@ static int nft_payload_set_init(const struct nft_ctx *ctx,
 
 	switch (csum_type) {
 	case NFT_PAYLOAD_CSUM_NONE:
+		if (priv->csum_offset) /* nonsensical */
+			return -EINVAL;
+
+		if (priv->csum_flags == 0)
+			break;
+
+		/* Userspace requests L4 checksum update, e.g.:
+		 * - IPv6 stateless NAT (no l3 csum)
+		 * - transport header mangling
+		 * - inner data mangling
+		 */
+		if (priv->base == NFT_PAYLOAD_NETWORK_HEADER ||
+		    priv->base == NFT_PAYLOAD_TRANSPORT_HEADER ||
+		    priv->base == NFT_PAYLOAD_INNER_HEADER)
+			break;
+
+		return -EINVAL;
 	case NFT_PAYLOAD_CSUM_INET:
+		if (!nft_payload_validate_inet_csum_offset(ctx, priv))
+			return -EINVAL;
 		break;
 	case NFT_PAYLOAD_CSUM_SCTP:
 		if (priv->base != NFT_PAYLOAD_TRANSPORT_HEADER)
@@ -1128,6 +1225,9 @@ static int nft_payload_set_init(const struct nft_ctx *ctx,
 
 		if (priv->csum_offset != offsetof(struct sctphdr, checksum))
 			return -EINVAL;
+
+		if (priv->csum_flags)
+			return -EINVAL;
 		break;
 	default:
 		return -EOPNOTSUPP;
-- 
2.53.0

