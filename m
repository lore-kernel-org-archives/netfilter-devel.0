Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12FAA3F9F45
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Jun 2026 15:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780932225; cv=none; b=fNfgf4J5aZTX130rv+v9tSqqz2EDyIOrWtw3f96Z4SIJ46puPzxrfgdXTFeflDBEkgCxwzqvPry6YwReCkYikW7oKgEmhQ5MD55Ogpwurq3J/XLeKYWbodYjnz83vYwR8LW9FS9CiI/U2V9q0CIkDASZ6TC5dAJPr0ZB7TbtC0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780932225; c=relaxed/simple;
	bh=D316F8o+UmjYfme/lZ7Tbr4V1v9nAY+62BNjaw8O3xI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GrGgVuXReRQ0n+Dm315eF+Lv6lKbJfh7BYcPUQO7AWU5FKlMMNwk4srZBaz5+8yQVG7AqEZiAjkDjKRJYZITsAj2G62CH3zk5p3Am1f55PyBwo8g3zPoUiACdfS6zdChkmH2rDgG06QWCg8hLJw+/mwOsBNnHh7+MJ2JDyw7Lcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id B1F1F602F8; Mon, 08 Jun 2026 17:23:42 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v2 2/3] netfilter: nftables: restrict linklayer and network header writes
Date: Mon,  8 Jun 2026 17:23:18 +0200
Message-ID: <20260608152324.20700-4-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260608152324.20700-1-fw@strlen.de>
References: <20260608152324.20700-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Don't permit arbitrary writes to linklayer and network header data.
Several spots in network stack trust header validation performed in
ipv4/ipv6 before PRE_ROUTING hook.

For linklayer, allow writes for netdev ingress. For other hooks, only
allow link layer writes that do not spill into network header.

For network header, check the offset/length combinations:
 - changing dscp requires store at offset 0 for checsum fixups, so
 make sure ip version + length field isn't altered.
 - ip6 dscp starts directly after the version field, so make sure it
   remains 6.

Several of these checks could already be done at rule insertion time.
Risk is that this might cause ruleset load failures for existing
rulesets. With this change such writes are silently skipped and packet
passes unchanged.

Transport and inner header bases are not checked / restricted.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_payload.c | 170 ++++++++++++++++++++++++++++++++++++
 1 file changed, 170 insertions(+)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 484a5490832e..8e4388bee459 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -824,6 +824,172 @@ nft_payload_set_vlan(const u32 *src, struct sk_buff *skb, u16 offset, u8 len,
 	return true;
 }
 
+/* Ingress is very early, before l3 protocol handlers.
+ * There should be no in-tree code that trusts l3/l4 headers
+ * between ingress and NF_INET_PRE_ROUTING hooks.
+ */
+static bool nft_in_ingress(const struct nf_hook_state *s)
+{
+	return s->pf == NFPROTO_NETDEV && s->hook == NF_NETDEV_INGRESS;
+}
+
+static bool nft_nh_write_ok_ip4(const struct nft_pktinfo *pkt,
+				const struct nft_payload_set *priv,
+				const u32 *src)
+{
+	unsigned int offset = priv->offset + skb_network_offset(pkt->skb);
+	const u8 *new_octets = (const u8 *)src;
+	u8 old_octet;
+
+	switch (priv->offset) {
+	case 0: /* csum fixups does expand dscp/tos store to 2 bytes.
+		 * make sure ihl/version remain unchanged.
+		 */
+		if (skb_copy_bits(pkt->skb, offset, &old_octet, sizeof(old_octet)))
+			return false;
+
+		return priv->len == 2 &&
+		       *new_octets == old_octet;
+	case offsetof(struct iphdr, tos):
+		return priv->len == 1;
+	case offsetof(struct iphdr, id):
+		return priv->len == 2;
+	case offsetof(struct iphdr, ttl):
+		if (priv->len == 1)
+			return true;
+
+		if (priv->len != 2)
+			return false;
+
+		/* same, csum fixup does expand ttl store to two bytes.
+		 * check protocol is not altered.
+		 */
+		if (skb_copy_bits(pkt->skb, offset + 1, &old_octet, sizeof(old_octet)))
+			return false;
+
+		return new_octets[1] == old_octet;
+	case offsetof(struct iphdr, check):
+		return priv->len <= 2 + 4 + 4;
+	case offsetof(struct iphdr, saddr):
+		return priv->len <= 4 + 4;
+	case offsetof(struct iphdr, daddr):
+		return priv->len <= 4;
+	}
+
+	return false;
+}
+
+static bool nft_nh_write_ok_ip6(const struct nft_pktinfo *pkt,
+				const struct nft_payload_set *priv,
+				const u32 *src)
+{
+	const struct ipv6hdr *ih = (const void *)src;
+
+	switch (priv->offset) {
+	case 0: /* store to dscp must not alter ip6 version */
+		return priv->len <= 4 && ih->version == 6;
+	case 2:
+		return priv->len <= 2;
+	case offsetof(struct ipv6hdr, hop_limit):
+		return priv->len == 1;
+	case offsetof(struct ipv6hdr, saddr):
+		return priv->len <= 16 + 16;
+	case offsetof(struct ipv6hdr, daddr):
+		return priv->len <= 16;
+	}
+
+	return false;
+}
+
+static bool nft_nh_write_ok_arp(const struct nft_payload_set *priv)
+{
+	/* Variable size for standard ethernet arp */
+	const unsigned int eth_ip = 2 * (ETH_ALEN + 4);
+	unsigned int offset = priv->offset;
+
+	switch (offset) {
+	case offsetof(struct arphdr, ar_op):
+		return priv->len == 2;
+	default:
+		break;
+	}
+
+	/* permit writes post fixed arp header size. offset + len are
+	 * checked vs skb size via skb_ensure_writable.
+	 */
+	return offset >= sizeof(struct arphdr) && priv->len <= eth_ip;
+}
+
+static bool nft_nh_write_ok_netdev(const struct nft_pktinfo *pkt,
+				   const struct nft_payload_set *priv,
+				   const u32 *src)
+{
+#ifdef CONFIG_NF_TABLES_NETDEV
+	switch (pkt->skb->protocol) {
+	case htons(ETH_P_ARP):
+		return nft_nh_write_ok_arp(priv);
+	case htons(ETH_P_IP):
+		return nft_nh_write_ok_ip4(pkt, priv, src);
+	case htons(ETH_P_IPV6):
+		return nft_nh_write_ok_ip6(pkt, priv, src);
+	}
+#endif
+	/* default to false for now, relax later in case we have
+	 * use-cases that need inner header manipulation for
+	 * encapsulated traffic like vlan or PPPoE.
+	 */
+	return false;
+}
+
+static bool nft_nh_write_ok_bridge(const struct nft_pktinfo *pkt,
+				   const struct nft_payload_set *priv,
+				   const u32 *src)
+{
+#if IS_ENABLED(CONFIG_NF_TABLES_BRIDGE)
+	switch (pkt->ethertype) {
+	case htons(ETH_P_ARP):
+		return nft_nh_write_ok_arp(priv);
+	case htons(ETH_P_IP):
+		return nft_nh_write_ok_ip4(pkt, priv, src);
+	case htons(ETH_P_IPV6):
+		return nft_nh_write_ok_ip6(pkt, priv, src);
+	}
+#endif
+	/* see nft_nh_write_ok_netdev: default to false */
+	return false;
+}
+
+static bool nft_nh_write_ok(const struct nft_pktinfo *pkt,
+			    const struct nft_payload_set *priv,
+			    const u32 *src)
+{
+	switch (pkt->state->pf) {
+	case NFPROTO_ARP:
+		return nft_nh_write_ok_arp(priv);
+	case NFPROTO_BRIDGE:
+		return nft_nh_write_ok_bridge(pkt, priv, src);
+	case NFPROTO_IPV4:
+		return nft_nh_write_ok_ip4(pkt, priv, src);
+	case NFPROTO_IPV6:
+		return nft_nh_write_ok_ip6(pkt, priv, src);
+	case NFPROTO_NETDEV:
+		if (pkt->state->hook == NF_NETDEV_INGRESS)
+			return true;
+		return nft_nh_write_ok_netdev(pkt, priv, src);
+	}
+
+	return false;
+}
+
+/* check linklayer modifications don't spill into network header. */
+static bool nft_ll_write_ok(const struct nft_pktinfo *pkt, int offset)
+{
+	if (nft_in_ingress(pkt->state))
+		return true;
+
+	return offset <= skb_network_offset(pkt->skb);
+}
+
 static void nft_payload_set_eval(const struct nft_expr *expr,
 				 struct nft_regs *regs,
 				 const struct nft_pktinfo *pkt)
@@ -851,8 +1017,12 @@ static void nft_payload_set_eval(const struct nft_expr *expr,
 		}
 
 		offset = skb_mac_header(skb) - skb->data - vlan_hlen;
+		if (!nft_ll_write_ok(pkt, priv->len + priv->offset + offset))
+			goto err;
 		break;
 	case NFT_PAYLOAD_NETWORK_HEADER:
+		if (!nft_nh_write_ok(pkt, priv, src))
+			goto err;
 		offset = skb_network_offset(skb);
 		break;
 	case NFT_PAYLOAD_TRANSPORT_HEADER:
-- 
2.53.0

