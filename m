Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 573CE3E1209
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Apr 2026 17:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777310059; cv=none; b=o1RHhbAysRq7cDRTPzMKIw3KWnTt4HAj/mNCWJOzk/zgUevtka+7diCVBljNRUT5GotorVvRGP9XLLZkZDvtDApepyq0nncjOjFlrLno+HHALT3QQOB3+9BOG+RnIGTt6NRIKPgcJi6+9P8sER4jbp73n/Df4qFyDdoIhdYX6rU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777310059; c=relaxed/simple;
	bh=EDHAKnyK1kIA+pBzX1ADbDz27mEJeaIfnCqAczdgUE8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lDg7cTtCGYc7G2I3OCSqgq6IG7rAcTd+rk8zNbXJ3Dow7s1nN4FShpgpNmzy1JaTSVYrPKjiFEXBbl6pihjCqMYMU2uh5A9cST1lj9ykj8JdTyTDJXUVr6JScaX4rnOfUCXwj/cq3v8V1uyDlOcs/o68BHKrSgzDLcSp69ETWTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=JSqlTksk; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="JSqlTksk"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id BC52260272
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Apr 2026 19:14:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1777310053;
	bh=gc4voeAZBiYXGy1MGJYq40+utIXPgtsmtaHKZldyOhY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=JSqlTkskcb/IqvqjrmOrtTlJxTlAzqL4oAyG7VERwbYy5YK1hpwex+xLWtfkA9R8i
	 AjO3CaNiOp0JCwLh5fUfxAeRhxQuagu1upBF7c0xMdheAxKIouyMlWXNFab5f3XeMc
	 2vQPipioL3WMKFVBdGpktKybi3yn3ObvtCYKJ7tfNFpim1iJGyAw3ivLdzy3PAhHGs
	 riXg16jCSelEZvGOfcPJpkhuRcOFJc7DW8Nt/HANOKqcQnOxyJiv7WFOrxVLvhrwmD
	 bz1HQrJ0vsO7LO5h8lwL83j5t35LT9+ld2cnyFvCy+inhqo7ual/Pe2OPx01dfda4M
	 YLjvoX4U65HnQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v2 2/2] netfilter: flowtable: fix inline pppoe encapsulation in xmit path
Date: Mon, 27 Apr 2026 19:14:08 +0200
Message-ID: <20260427171408.23018-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260427171408.23018-1-pablo@netfilter.org>
References: <20260427171408.23018-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Address two issues in the inline pppoe encapsulation:

- Add needs_gso_segment flag to segment PPPoE packets in software
  given that there is no GSO support for this.

- Use FLOW_OFFLOAD_XMIT_DIRECT since neighbour cache is not available
  in point-to-point device, use the hardware address that is obtained
  via flowtable path discovery (ie. fill_forward_path).

Fixes: 18d27bed0880 ("netfilter: flowtable: inline pppoe encapsulation in xmit path")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: - fix skb memleak on error in skb_gso_segment().
    - store the needs_gso_flag in the right direction.

Comments for AI:
- skbs payload is never shrunk, so skb_gso_segment should not ever return NULL.
- no mac header is in placed when skb_gso_segment() is called, this VLAN/PPPoE
  header is pushed then dev_queue_xmit() pushes the mac header.

 include/net/netfilter/nf_flow_table.h |  4 ++-
 net/netfilter/nf_flow_table_core.c    |  1 +
 net/netfilter/nf_flow_table_ip.c      | 38 ++++++++++++++++++++++++---
 net/netfilter/nf_flow_table_path.c    |  7 ++++-
 4 files changed, 45 insertions(+), 5 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index b09c11c048d5..7b23b245a5a8 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -148,9 +148,10 @@ struct flow_offload_tuple {
 	/* All members above are keys for lookups, see flow_offload_hash(). */
 	struct { }			__hash;
 
-	u8				dir:2,
+	u16				dir:2,
 					xmit_type:3,
 					encap_num:2,
+					needs_gso_segment:1,
 					tun_num:2,
 					in_vlan_ingress:2;
 	u16				mtu;
@@ -232,6 +233,7 @@ struct nf_flow_route {
 			u32			hw_ifindex;
 			u8			h_source[ETH_ALEN];
 			u8			h_dest[ETH_ALEN];
+			u8			needs_gso_segment:1;
 		} out;
 		enum flow_offload_xmit_type	xmit_type;
 	} tuple[FLOW_OFFLOAD_DIR_MAX];
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 2c4140e6f53c..785d8c244a77 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -122,6 +122,7 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 
 	flow_tuple->tun = route->tuple[dir].in.tun;
 	flow_tuple->encap_num = route->tuple[dir].in.num_encaps;
+	flow_tuple->needs_gso_segment = route->tuple[dir].out.needs_gso_segment;
 	flow_tuple->tun_num = route->tuple[dir].in.num_tuns;
 
 	switch (route->tuple[dir].xmit_type) {
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 6da0bc3965df..9bcdc3b85ca1 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -552,7 +552,8 @@ static int nf_flow_vlan_push(struct sk_buff *skb, __be16 proto, u16 id,
 	return 0;
 }
 
-static int nf_flow_pppoe_push(struct sk_buff *skb, u16 id)
+static int nf_flow_pppoe_push(struct sk_buff *skb, u16 id,
+			      u32 needed_headroom)
 {
 	int data_len = skb->len + sizeof(__be16);
 	struct ppp_hdr {
@@ -561,7 +562,7 @@ static int nf_flow_pppoe_push(struct sk_buff *skb, u16 id)
 	} *ph;
 	__be16 proto;
 
-	if (skb_cow_head(skb, PPPOE_SES_HLEN))
+	if (skb_cow_head(skb, needed_headroom + PPPOE_SES_HLEN))
 		return -1;
 
 	switch (skb->protocol) {
@@ -754,7 +755,8 @@ static int nf_flow_encap_push(struct sk_buff *skb,
 				return -1;
 			break;
 		case htons(ETH_P_PPP_SES):
-			if (nf_flow_pppoe_push(skb, tuple->encap[i].id) < 0)
+			if (nf_flow_pppoe_push(skb, tuple->encap[i].id,
+					       needed_headroom) < 0)
 				return -1;
 			break;
 		}
@@ -768,6 +770,7 @@ struct nf_flow_xmit {
 	const void		*source;
 	struct net_device	*outdev;
 	struct flow_offload_tuple *tuple;
+	bool			needs_gso_segment;
 };
 
 static void __nf_flow_queue_xmit(struct net *net, struct sk_buff *skb,
@@ -779,10 +782,37 @@ static void __nf_flow_queue_xmit(struct net *net, struct sk_buff *skb,
 	dev_queue_xmit(skb);
 }
 
+static unsigned int nf_flow_encap_gso_xmit(struct net *net, struct sk_buff *skb,
+					   struct nf_flow_xmit *xmit)
+{
+	struct sk_buff *segs, *nskb;
+
+	segs = skb_gso_segment(skb, 0);
+	if (IS_ERR(segs) || !segs)
+		return NF_DROP;
+
+	skb_list_walk_safe(segs, segs, nskb) {
+		skb_mark_not_on_list(segs);
+
+		if (nf_flow_encap_push(segs, xmit->tuple, xmit->outdev) < 0) {
+			kfree_skb(segs);
+			kfree_skb_list(nskb);
+			return NF_DROP;
+		}
+		__nf_flow_queue_xmit(net, segs, xmit);
+	}
+	consume_skb(skb);
+
+	return NF_STOLEN;
+}
+
 static unsigned int nf_flow_queue_xmit(struct net *net, struct sk_buff *skb,
 				       struct nf_flow_xmit *xmit)
 {
 	if (xmit->tuple->encap_num) {
+		if (skb_is_gso(skb) && xmit->needs_gso_segment)
+			return nf_flow_encap_gso_xmit(net, skb, xmit);
+
 		if (nf_flow_encap_push(skb, xmit->tuple, xmit->outdev) < 0)
 			return NF_DROP;
 	}
@@ -866,6 +896,7 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 		return NF_DROP;
 	}
 	xmit.tuple = other_tuple;
+	xmit.needs_gso_segment = tuplehash->tuple.needs_gso_segment;
 
 	return nf_flow_queue_xmit(state->net, skb, &xmit);
 }
@@ -1186,6 +1217,7 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 		return NF_DROP;
 	}
 	xmit.tuple = other_tuple;
+	xmit.needs_gso_segment = tuplehash->tuple.needs_gso_segment;
 
 	return nf_flow_queue_xmit(state->net, skb, &xmit);
 }
diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
index 6bb9579dcc2a..9e88ea6a2eef 100644
--- a/net/netfilter/nf_flow_table_path.c
+++ b/net/netfilter/nf_flow_table_path.c
@@ -86,6 +86,7 @@ struct nft_forward_info {
 	u8 ingress_vlans;
 	u8 h_source[ETH_ALEN];
 	u8 h_dest[ETH_ALEN];
+	bool needs_gso_segment;
 	enum flow_offload_xmit_type xmit_type;
 };
 
@@ -138,8 +139,11 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 					path->encap.proto;
 				info->num_encaps++;
 			}
-			if (path->type == DEV_PATH_PPPOE)
+			if (path->type == DEV_PATH_PPPOE) {
 				memcpy(info->h_dest, path->encap.h_dest, ETH_ALEN);
+				info->xmit_type = FLOW_OFFLOAD_XMIT_DIRECT;
+				info->needs_gso_segment = 1;
+			}
 			break;
 		case DEV_PATH_BRIDGE:
 			if (is_zero_ether_addr(info->h_source))
@@ -279,6 +283,7 @@ static void nft_dev_forward_path(const struct nft_pktinfo *pkt,
 		memcpy(route->tuple[dir].out.h_dest, info.h_dest, ETH_ALEN);
 		route->tuple[dir].xmit_type = info.xmit_type;
 	}
+	route->tuple[dir].out.needs_gso_segment = info.needs_gso_segment;
 }
 
 int nft_flow_route(const struct nft_pktinfo *pkt, const struct nf_conn *ct,
-- 
2.47.3

