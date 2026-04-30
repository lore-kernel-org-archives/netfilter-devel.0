Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F4233A5E68
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Apr 2026 20:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777580756; cv=none; b=ZyceG3nyHEz+y5QQW7z+RACftJ+8RKW5cWxJGJTPDX6zYkUKWRzXSRdEW7Xuv8kyZtbZd211Kg7umQ1we1jTWAT4lRVqhkGgexGqNJ4CfDe092zHVrhmRbRt5802gQ8NpUa98Ne2cwtUW0KXgG++Y0ORnB3d8bwVO6JPW2H8exc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777580756; c=relaxed/simple;
	bh=hajEqtkiwmwGsxnvIqijxcJe9bz3B6WO/8JmrnsLx9o=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gO/6tqdZeEkwNIigxJVR72yr5uarChnEGPvA/ByRsoFXE9ShxgGOUhU812+olyVW4wI7Zw03MSlZvsJcpAjB6dv/HZVf15HxVKSoNxBJ3NOVZQFYT3ngb3lg2NlWLJBuiJAB2kx2tUCvTg+efpAyAqr360QSH53M7dPEsz4q/4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Yx+7Uo4T; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Yx+7Uo4T"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 4F65260181
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Apr 2026 22:25:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1777580752;
	bh=Ub4edRqRByLPOLIXcNYyFw/lQPHmk2pXs3IlT8bHcdA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Yx+7Uo4TmFS7aM/qmJHU1t7fVk5LvFoLSnUmWlATWgfSZ3yw7iL2TkpJXXDkE5CNA
	 7Vtjf6xNfILxT+Avp7zITRWnS5V9S/lRXdNh9/UNXWXgrR2NIrcZrf4qb5PRs7jjZi
	 lX1L/Y0OYQKiGiIMFfA9m3EwwPa9c72qJFKEMUv743ceTzhp1rVCI7+eK5/RrUcRaP
	 QQcS3AfWzWmBcTlCwKx0bydYIjgEGyVJWzZH8Bh7G9XlwRHVV1D2/b3gfu6U1d0P96
	 0qwDdPM5eEeFLgMCJU14/6MIJnhb7u/mUSnmVEW0Be3P/0E2R5o+HHa5F0UcRxLUgw
	 gsCvsNOTgjnbg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v6 2/4] netfilter: flowtable: fix inline vlan encapsulation in xmit path
Date: Thu, 30 Apr 2026 22:25:45 +0200
Message-ID: <20260430202547.274256-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260430202547.274256-1-pablo@netfilter.org>
References: <20260430202547.274256-1-pablo@netfilter.org>
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

- skb_postpush_rcsum()

Fixes: c653d5a78f34 ("netfilter: flowtable: inline vlan encapsulation in xmit path")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v6: add skb_postpush_rcsum() as suggested by AI reviewer.

 net/netfilter/nf_flow_table_ip.c | 110 ++++++++++++++++++++-----------
 1 file changed, 73 insertions(+), 37 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 8d5fb7e940a1..0ce3c209050c 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -462,32 +462,6 @@ static void nf_flow_encap_pop(struct nf_flowtable_ctx *ctx,
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
-	struct net_device *dev = xmit->outdev;
-	unsigned int hh_len = LL_RESERVED_SPACE(dev);
-
-	if (unlikely(skb_headroom(skb) < hh_len && dev->header_ops)) {
-		skb = skb_expand_head(skb, hh_len);
-		if (!skb)
-			return NF_STOLEN;
-	}
-
-	skb->dev = dev;
-	dev_hard_header(skb, dev, ntohs(skb->protocol),
-			xmit->dest, xmit->source, skb->len);
-	dev_queue_xmit(skb);
-
-	return NF_STOLEN;
-}
-
 static struct flow_offload_tuple_rhash *
 nf_flow_offload_lookup(struct nf_flowtable_ctx *ctx,
 		       struct nf_flowtable *flow_table, struct sk_buff *skb)
@@ -553,6 +527,32 @@ static int nf_flow_offload_forward(struct nf_flowtable_ctx *ctx,
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
+		skb_postpush_rcsum(skb, skb->data, VLAN_HLEN);
+	}
+	__vlan_hwaccel_put_tag(skb, proto, id);
+
+	return 0;
+}
+
 static int nf_flow_pppoe_push(struct sk_buff *skb, u16 id)
 {
 	int data_len = skb->len + sizeof(__be16);
@@ -739,17 +739,19 @@ static int nf_flow_tunnel_v6_push(struct net *net, struct sk_buff *skb,
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
@@ -762,6 +764,44 @@ static int nf_flow_encap_push(struct sk_buff *skb,
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
+				 struct nf_flow_xmit *xmit)
+{
+	struct net_device *dev = xmit->outdev;
+	unsigned int hh_len = LL_RESERVED_SPACE(dev);
+
+	if (unlikely(skb_headroom(skb) < hh_len && dev->header_ops)) {
+		skb = skb_expand_head(skb, hh_len);
+		if (!skb)
+			return;
+	}
+
+	skb->dev = dev;
+	dev_hard_header(skb, dev, ntohs(skb->protocol),
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
@@ -806,9 +846,6 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	if (nf_flow_tunnel_v4_push(state->net, skb, other_tuple, &ip_daddr) < 0)
 		return NF_DROP;
 
-	if (nf_flow_encap_push(skb, other_tuple) < 0)
-		return NF_DROP;
-
 	switch (tuplehash->tuple.xmit_type) {
 	case FLOW_OFFLOAD_XMIT_NEIGH:
 		rt = dst_rtable(tuplehash->tuple.dst_cache);
@@ -838,6 +875,7 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 		WARN_ON_ONCE(1);
 		return NF_DROP;
 	}
+	xmit.tuple = other_tuple;
 
 	return nf_flow_queue_xmit(state->net, skb, &xmit);
 }
@@ -1128,9 +1166,6 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 				   &ip6_daddr, encap_limit) < 0)
 		return NF_DROP;
 
-	if (nf_flow_encap_push(skb, other_tuple) < 0)
-		return NF_DROP;
-
 	switch (tuplehash->tuple.xmit_type) {
 	case FLOW_OFFLOAD_XMIT_NEIGH:
 		rt = dst_rt6_info(tuplehash->tuple.dst_cache);
@@ -1160,6 +1195,7 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 		WARN_ON_ONCE(1);
 		return NF_DROP;
 	}
+	xmit.tuple = other_tuple;
 
 	return nf_flow_queue_xmit(state->net, skb, &xmit);
 }
-- 
2.47.3

