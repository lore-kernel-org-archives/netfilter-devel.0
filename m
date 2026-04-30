Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558282E401
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Apr 2026 05:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777528724; cv=none; b=Lb1V249/w9wxxp+cFdi6GU3pR9f1gsxF3kD5v/8WpZWqB8MP16R8FuuuqFoPPakBFb6rZV2Xei/eBDLDQ0+kZQT5yP9Cx3h2Qd3Ls9u7ht1dtSa6D0bKY+tZXGkSjLVJF9rr67KEfzTXGP4bIguUT2PywXurFGUXnDow86BhgTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777528724; c=relaxed/simple;
	bh=iJqKuCz90K3Cle7yMvZ/e5UYXSCmDvQMtxoOWBcIjSo=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=lC1dfG+KtoWBk+XIbZhL1h2HXkYRL76j/+Dip9We5h+Q53OTxVDWE2osJ0e6MKisIFYG2YgmZq2z0aAToX2RRRlHik/deGun5hHoB1W8HWGcSKYNu+HmO/B0WlPu7OGmW0ePSpHgibpdvaF713XjyVFxS3sLoEWKiPgzYJfQKq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=F9euZMVE; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="F9euZMVE"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 8E18A602CB
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Apr 2026 07:58:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1777528719;
	bh=VJC0c+A2ZfA5zjovv0mZFmdDnFCi61FUB+825VzYzeQ=;
	h=From:To:Subject:Date:From;
	b=F9euZMVEt64gG7exyfiPmTWEQqD/tu/Ur7yUMCtb1zLO07W8mkbjpH5KaQcc6xLfB
	 Ii51gpo8Rz/pW3LLqX4dzFl3kZIV0kxNotPPpjHW9b+8EswSiAZO1mOdr1Hb4hGwjD
	 oWRuhg/XzNyoX+WvSHmz27rUy357nT4gx7CLFBFePnkQX0VI6VMQwhyXacQz0zigEh
	 jpMi7vYe4U1E4fHGiuOiV5VlCcyxbBOBi1/tgZL3vqhB4SZgDOtfmXqIQj9FQ7dvIR
	 208r4ZIWeum4XAIM9pgMfm5ZP/RSK9PxhED0RWpgqEerQ+avPxIoYbNRtRe6//Ce1T
	 bptnCCOJcHPgQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v4 1/2] netfilter: flowtable: fix inline vlan encapsulation in xmit path
Date: Thu, 30 Apr 2026 07:58:35 +0200
Message-ID: <20260430055836.223494-1-pablo@netfilter.org>
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
v4: no changes

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

