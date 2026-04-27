Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 396283E121A
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Apr 2026 17:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777310059; cv=none; b=DqhPBh23g986aI+jgLjMxao3wHNM2PyGGKWQNAN0T0qRrLtjuLV86zV5bEp0bi1sfmcTepG2SVpQ72e8icTlEN7a8NCE1o2FNAdaCnteJf6Va/8lYQAvoxuA6J0uzR/yhTnTRwJeetVML0bKnd4z0U9EWDn6NuuV5md64Q53TQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777310059; c=relaxed/simple;
	bh=c8qwr8hpFSAA7XPdf4vQwky8AsTs0mQgsbBp4jyBNg8=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=XKJkWkye2vP4jiNK/SDC6wNmBcEtSubknuBBNjvifjHJf8GtLDfoubQZW7YBG4ATHjcPweN8trzlIlvzKd+ehfSS5djqIbVHm+x0U403gLLT+vwa0YdWp4oWpjru1rgn5l6ndNNZ1KsbXFJrf5WpXle0g2vHQ8CU/HS6C1PAhJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=do7JGdZM; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="do7JGdZM"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 5E20360178
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Apr 2026 19:14:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1777310052;
	bh=nVUcpAc9NDYqUyTn6N1pBijEFa49qXFuRs+jcZ+rG98=;
	h=From:To:Subject:Date:From;
	b=do7JGdZMwniM8yPEVNeaNcWBem/Bui5hE/7JuVSI6IxvImJNU7ZiYM9wLGHs4TNhc
	 CaxvCEK/iMeLWhi4hRRcfxXBs39vNv/TxeKyqanUIKy0qxDHQrQOaAmU1s6GTy6fip
	 rP7g8fE4DRGMfMBtnqNAikm59ybQ68h1M5iyVPnvz1mMuVpDvNxp9NfmFA4AOD2gA4
	 81PGR50pf3VpuE1VqIVOXKU59XZ5ji9eYQ4ceQOULq9B2z4sYJWX8gEca+zpUtCfna
	 vJWsn/ZnAehQsNaotq4fAeqCIlaus70H6883Tjb1RwT2I0FDTMlzBu+0ubWwQsyAB6
	 nw762apCYfltQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v2 1/2] netfilter: flowtable: fix inline vlan encapsulation in xmit path
Date: Mon, 27 Apr 2026 19:14:07 +0200
Message-ID: <20260427171408.23018-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Several issues in the inline vlan support:

- The layer 2 encapsulation representation in the tuple takes encap[0] as
  the outer header and encap[1] as the inner header as seen from the ingress
  path. Reverse the encap loop to push first the inner then the outer vlan
  header.

- Postpone pushing the layer 2 header once destination device is known.
  This allows to calculate the needed hearoom via LL_RESERVED_SPACE to
  accommodate the layer 2 headers.

- Add and use nf_flow_vlan_push() as suggested by Eric Woudstra, this
  is a simplified version of skb_vlan_push() for egress path only.

Fixes: c653d5a78f34 ("netfilter: flowtable: inline vlan encapsulation in xmit path")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: no changes.

Severals comments for AI:

- This is catching skbuffs from ingress, skb->data points to network
  header. The existing mac header from ingress can be overwritten
  when xmitting packets to the egress path.
- skb->network_header is updated to point to the VLAN header with
  double-tagged VLAN as usual.

 net/netfilter/nf_flow_table_ip.c | 91 ++++++++++++++++++++++----------
 1 file changed, 63 insertions(+), 28 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index dbd7644fdbeb..6da0bc3965df 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -462,23 +462,6 @@ static void nf_flow_encap_pop(struct nf_flowtable_ctx *ctx,
 		nf_flow_ip_tunnel_pop(ctx, skb);
 }
 
-struct nf_flow_xmit {
-	const void		*dest;
-	const void		*source;
-	struct net_device	*outdev;
-};
-
-static unsigned int nf_flow_queue_xmit(struct net *net, struct sk_buff *skb,
-				       struct nf_flow_xmit *xmit)
-{
-	skb->dev = xmit->outdev;
-	dev_hard_header(skb, skb->dev, ntohs(skb->protocol),
-			xmit->dest, xmit->source, skb->len);
-	dev_queue_xmit(skb);
-
-	return NF_STOLEN;
-}
-
 static struct flow_offload_tuple_rhash *
 nf_flow_offload_lookup(struct nf_flowtable_ctx *ctx,
 		       struct nf_flowtable *flow_table, struct sk_buff *skb)
@@ -544,6 +527,31 @@ static int nf_flow_offload_forward(struct nf_flowtable_ctx *ctx,
 	return 1;
 }
 
+/* Similar to skb_vlan_push. */
+static int nf_flow_vlan_push(struct sk_buff *skb, __be16 proto, u16 id,
+			     u32 needed_headroom)
+{
+	if (skb_vlan_tag_present(skb)) {
+		struct vlan_hdr *vhdr;
+
+		if (skb_cow_head(skb, needed_headroom + VLAN_HLEN))
+			return -1;
+
+		__skb_push(skb, VLAN_HLEN);
+		if (skb_mac_header_was_set(skb))
+			skb->mac_header -= VLAN_HLEN;
+
+		vhdr = (struct vlan_hdr *)skb->data;
+		skb->network_header -= VLAN_HLEN;
+		vhdr->h_vlan_TCI = htons(skb_vlan_tag_get(skb));
+		vhdr->h_vlan_encapsulated_proto = skb->protocol;
+		skb->protocol = skb->vlan_proto;
+	}
+	__vlan_hwaccel_put_tag(skb, proto, id);
+
+	return 0;
+}
+
 static int nf_flow_pppoe_push(struct sk_buff *skb, u16 id)
 {
 	int data_len = skb->len + sizeof(__be16);
@@ -730,17 +738,19 @@ static int nf_flow_tunnel_v6_push(struct net *net, struct sk_buff *skb,
 }
 
 static int nf_flow_encap_push(struct sk_buff *skb,
-			      struct flow_offload_tuple *tuple)
+			      struct flow_offload_tuple *tuple,
+			      struct net_device *outdev)
 {
+	u32 needed_headroom = LL_RESERVED_SPACE(outdev);
 	int i;
 
-	for (i = 0; i < tuple->encap_num; i++) {
+	for (i = tuple->encap_num - 1; i >= 0; i--) {
 		switch (tuple->encap[i].proto) {
 		case htons(ETH_P_8021Q):
 		case htons(ETH_P_8021AD):
-			skb_reset_mac_header(skb);
-			if (skb_vlan_push(skb, tuple->encap[i].proto,
-					  tuple->encap[i].id) < 0)
+			if (nf_flow_vlan_push(skb, tuple->encap[i].proto,
+					      tuple->encap[i].id,
+					      needed_headroom) < 0)
 				return -1;
 			break;
 		case htons(ETH_P_PPP_SES):
@@ -753,6 +763,35 @@ static int nf_flow_encap_push(struct sk_buff *skb,
 	return 0;
 }
 
+struct nf_flow_xmit {
+	const void		*dest;
+	const void		*source;
+	struct net_device	*outdev;
+	struct flow_offload_tuple *tuple;
+};
+
+static void __nf_flow_queue_xmit(struct net *net, struct sk_buff *skb,
+				    struct nf_flow_xmit *xmit)
+{
+	skb->dev = xmit->outdev;
+	dev_hard_header(skb, skb->dev, ntohs(skb->protocol),
+			xmit->dest, xmit->source, skb->len);
+	dev_queue_xmit(skb);
+}
+
+static unsigned int nf_flow_queue_xmit(struct net *net, struct sk_buff *skb,
+				       struct nf_flow_xmit *xmit)
+{
+	if (xmit->tuple->encap_num) {
+		if (nf_flow_encap_push(skb, xmit->tuple, xmit->outdev) < 0)
+			return NF_DROP;
+	}
+
+	__nf_flow_queue_xmit(net, skb, xmit);
+
+	return NF_STOLEN;
+}
+
 unsigned int
 nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 			const struct nf_hook_state *state)
@@ -797,9 +836,6 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	if (nf_flow_tunnel_v4_push(state->net, skb, other_tuple, &ip_daddr) < 0)
 		return NF_DROP;
 
-	if (nf_flow_encap_push(skb, other_tuple) < 0)
-		return NF_DROP;
-
 	switch (tuplehash->tuple.xmit_type) {
 	case FLOW_OFFLOAD_XMIT_NEIGH:
 		rt = dst_rtable(tuplehash->tuple.dst_cache);
@@ -829,6 +865,7 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 		WARN_ON_ONCE(1);
 		return NF_DROP;
 	}
+	xmit.tuple = other_tuple;
 
 	return nf_flow_queue_xmit(state->net, skb, &xmit);
 }
@@ -1119,9 +1156,6 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 				   &ip6_daddr, encap_limit) < 0)
 		return NF_DROP;
 
-	if (nf_flow_encap_push(skb, other_tuple) < 0)
-		return NF_DROP;
-
 	switch (tuplehash->tuple.xmit_type) {
 	case FLOW_OFFLOAD_XMIT_NEIGH:
 		rt = dst_rt6_info(tuplehash->tuple.dst_cache);
@@ -1151,6 +1185,7 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 		WARN_ON_ONCE(1);
 		return NF_DROP;
 	}
+	xmit.tuple = other_tuple;
 
 	return nf_flow_queue_xmit(state->net, skb, &xmit);
 }
-- 
2.47.3

