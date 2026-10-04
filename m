Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7471746EF64
	for <netfilter-devel@vger.kernel.org>; Sun,  4 Oct 2026 17:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791134190; cv=none; b=ViPcKIiBiOTV5vun51/txXrU0JHildk5djvMI0PnHnjwPQJ8S0PRJVFFAVohJ/bNcvHN0a+0CocvEl+kIdZKR6B4s0HzZJqVyNjzKyYGfSWG901PWTSZ25M4ic82kpNBlInccrfsHfsgl8SUk+KLaX/yPvwAwLbDPe0uDHcbYEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791134190; c=relaxed/simple;
	bh=0IdcxFzam7QG4020+xfTCbZlrwLZGDQ0UkEWaUMrWIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tn8z0Lx+JARLHcMgTa6l7zTMpQCGxnyyrfZD6zM+kwzm1I5p7pnE4oMY4jaN9ay4Nbqe/r1vRVo+XQOiwROqIKCcGJj22h4dRrClArdzFGZcCgg3+fHFkMkmN9r9oJj8AApt3eFbK0aozSBw4z5E5O6dYD6ld2HT8YcyB024Ueo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=dIAIAd5G; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="dIAIAd5G"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c2e36c3478aso152534866b.0
        for <netfilter-devel@vger.kernel.org>; Sun, 04 Oct 2026 10:16:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1791134182; x=1791738982; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dgkhJg3NRCmkewoiVqHo3ms5h7gv31W6oGsVKLV/gUs=;
        b=dIAIAd5GZXc391P3qHPRdtmiy/oM3wGfRMkuHiEM8auUrkEr+dqg6BPIdQtuZRno/E
         sZQ6sF1DRhMckDGy5BxNWSRwzgnA/4vN5C56uXc4mC7+SNPdwc5F2ZaektUsbW/xScpj
         rTunjyYB60Y5n0GUX/sshUkIv9OFhSmHdW3x83YcAdPvHkmnJk3vNhCcW0exuOInTYrS
         +GQEpyo/pJvBXhjTrvNLvmPaV5zwOA/E0mJvLT/XDsI+1RssDsWVXBAhbdVzG8ynjSYQ
         cOTFexwEB6CN0sfqHdFM7QUu4+kTh9ot9M+yk6fDyDCTuEAx99pVUJ2W0pQJiTN7uxsO
         7MBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791134182; x=1791738982;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dgkhJg3NRCmkewoiVqHo3ms5h7gv31W6oGsVKLV/gUs=;
        b=XCNzH1jiBkle6Xn4TAkkMPHsY2Cpyq5A95+6gJzsuXmH4EBF0HxLx0p5pKeceQsUzk
         xnJ8Mom4+beyB/hOFmr3DgEjgPoZ+bZYcXCNdiy6EOoMkwpaJXllapFKvYLvs6HMHppP
         gi20S9Od/q2KPtJt7jQYXmCZGNjRLzsadGIXMTACbFCWEujDdCoRwQyL2mGbCHeL2Ehk
         xshAX0PPUEBkMEf4mXSCD6cOa9oKKniFLS0KrzIZmgqsXuC61cg8GRt4LCQfxYqCtR/j
         ZxWwJ0R53/KFj96VueblOY/J+L9d7oHBJyWot+pcdxJX2RoQEdlfutiRtSvnb9aNWc1e
         iTkQ==
X-Gm-Message-State: AFuF++kQfrncCDfkm08VkAkvVK7B4ak2Qa1dNhTML1aVlga9LQ217w6m
	H1Ky0rNhRXzHLyX8BS4fnCXbIjxJ+ogZUu6+chXpJxWzmNcTLIrMcU2Iu5orIY4hd1IpWgIWx0Y
	Uxg07Xg==
X-Gm-Gg: AYBFou36wKCfbrGMTPvgTi72wpny4ZAs+26DeHpy7Soce0viS+cZGM9+5rtOtbbZJ2B
	8PoJYnmqW76EGzkqoP1oY5Pe/nmlWppZaI19WG2Y6nmJ4RX2aaIJHRl+oqSquHFFMRJaTK0qQFH
	EafLdnvB03+8Bi4Ai0tvyW6I6iImi4677jN9D0m4+DOTurO0lBledvtboIFtAx289rnfuWslXzl
	8vBZrpeay5qCYsKM5R7gXqL2LiBMetaebFqpIuWAaj5asDzTakYLqAW9GXuNJnglkPkmd+mS9zM
	LCQ/3Cl6x5Iwzg8lgB3NSCvONqVEN2pRKilMdRpg8jXL2hqgAG3FwzurkZpZ4dPTJhEuOe0I/kM
	3T8hm7cBGREQvo/L+PwBltJklzfRzyQqy6lKfusgqhQyh4JBbq9e2FBGq3X51c9SRv3SnBSHpik
	O7CP29YLf9wVLub4J8FLm7pvlMtbZNrVBZaMYeL0mzF/3mCF0gjnGkC/2jiEBWbPeQwFt5zndYl
	ET3S1e/jVZsfzpgvyHL4UP/hpYc8B6ZJXgpncwghyFiJfSWzDTPowaaEDVthPPfsH84FSFjxbaz
	c1fZ4FiYbFT53WYIvBP2hMCNbyfUIOR/5cYziJSkxR11JBVTVhqk53PCscxisQmtcsDovcwTjlz
	wrr+11CLyM24A+a7DbAB/ihRyOPNfOz1trC2jvfUp+ncwd/6nTqAZ6RT6QPZL1ZjHUiffctOm0P
	e7y34ynFfRcYAP0GtQ4o0ckJXwhOYQmSkETQ==
X-Received: by 2002:a17:907:a648:b0:c29:4513:f6fd with SMTP id a640c23a62f3a-c2e6ee555efmr421126366b.35.1791134182307;
        Sun, 04 Oct 2026 10:16:22 -0700 (PDT)
Received: from Desktop (pd9513667.dip0.t-ipconnect.de. [217.81.54.103])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2e4cd278cesm314885266b.37.2026.10.04.10.16.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2026 10:16:21 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	andrew+netdev@lunn.ch,
	shuah@kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	nbd@nbd.name
Subject: [PATCH nf-next 2/3] netfilter: flowtable: update upper device stats in the fast path
Date: Sun,  4 Oct 2026 19:16:15 +0200
Message-ID: <20261004171616.3544880-3-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261004171616.3544880-1-julius@bairaktaris.de>
References: <20261004171616.3544880-1-julius@bairaktaris.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The software fast path receives and transmits on the lowest devices of
the input and output stacks, so the bridge, VLAN, PPPoE and tunnel
devices above them stop counting after the first packets of a
connection.

Store the ifindexes of these devices from the forward path and update
their counters from the fast path. Each device counts what it counts in
the classic path: the IP packet plus the headers of the devices above it
(PPPoE, outer IP, inner VLAN tag), plus the Ethernet header on transmit
for Ethernet devices.

A GSO packet sent through a PPPoE device is counted once. The classic
path segments it in front of the ppp device and counts every segment.

struct flow_offload grows from 296 to 328 bytes.

Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
 include/net/netfilter/nf_flow_table.h |  8 +++-
 net/netfilter/nf_flow_table_core.c    |  3 ++
 net/netfilter/nf_flow_table_ip.c      | 53 +++++++++++++++++++++++++++
 net/netfilter/nf_flow_table_path.c    |  9 +++++
 4 files changed, 72 insertions(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index f2e2771f188f..1f451fcf05d0 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -106,6 +106,8 @@ enum flow_offload_xmit_type {
 };
 
 #define NF_FLOW_TABLE_ENCAP_MAX		2
+/* Devices above the flowtable device in a forward path. */
+#define NF_FLOW_TABLE_UPPER_MAX		(NET_DEVICE_PATH_STACK_MAX - 1)
 
 struct flow_offload_tunnel {
 	union {
@@ -153,7 +155,8 @@ struct flow_offload_tuple {
 					encap_num:2,
 					needs_gso_segment:1,
 					tun_num:2,
-					in_vlan_ingress:2;
+					in_vlan_ingress:2,
+					num_uppers:3;
 	u16				mtu;
 	u32				dst_cookie;
 	struct dst_entry		*dst_cache;
@@ -171,6 +174,7 @@ struct flow_offload_tuple {
 			u32		iifidx;
 		} tc;
 	};
+	u32				upper_ifidx[NF_FLOW_TABLE_UPPER_MAX];
 };
 
 struct flow_offload_tuple_rhash {
@@ -228,6 +232,8 @@ struct nf_flow_route {
 			u8			num_encaps:2,
 						num_tuns:2,
 						ingress_vlans:2;
+			u32			upper_ifidx[NF_FLOW_TABLE_UPPER_MAX];
+			u8			num_uppers;
 		} in;
 		struct {
 			u32			ifindex;
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 03241d4bfd5e..2c9a0d97c9fb 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -122,6 +122,9 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 
 	flow_tuple->tun = route->tuple[dir].in.tun;
 	flow_tuple->encap_num = route->tuple[dir].in.num_encaps;
+	memcpy(flow_tuple->upper_ifidx, route->tuple[dir].in.upper_ifidx,
+	       sizeof(flow_tuple->upper_ifidx));
+	flow_tuple->num_uppers = route->tuple[dir].in.num_uppers;
 	flow_tuple->needs_gso_segment = route->tuple[dir].out.needs_gso_segment;
 	flow_tuple->tun_num = route->tuple[dir].in.num_tuns;
 
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index c8c29a9a1684..e1a3511d5f1f 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -453,6 +453,49 @@ static void nf_flow_encap_pop(struct nf_flowtable_ctx *ctx,
 		nf_flow_ip_tunnel_pop(ctx, skb);
 }
 
+/* The fast path bypasses the devices above the flowtable device. */
+static void nf_flow_upper_stats_add(struct net *net,
+				    const struct flow_offload_tuple *tuple,
+				    bool rx, unsigned int len)
+{
+	unsigned int n, vlan_hlen = 0;
+	struct net_device *dev;
+	int i;
+
+	for (i = 0; i < tuple->num_uppers; i++) {
+		dev = dev_get_by_index_rcu(net, tuple->upper_ifidx[i]);
+		if (!dev)
+			continue;
+
+		n = len;
+		if (!rx && dev->type == ARPHRD_ETHER)
+			n += ETH_HLEN;
+
+		if (is_vlan_dev(dev)) {
+			/* Q-in-Q: the outer VLAN device counts the inner tag. */
+			n += vlan_hlen;
+			if (rx)
+				vlan_dev_sw_netstats_rx_add(dev, n);
+			else
+				vlan_dev_sw_netstats_tx_add(dev, 1, n);
+			vlan_hlen += VLAN_HLEN;
+		} else if (dev->pcpu_stat_type == NETDEV_PCPU_STAT_TSTATS) {
+			if (rx)
+				dev_sw_netstats_rx_add(dev, n);
+			else
+				dev_sw_netstats_tx_add(dev, 1, n);
+		}
+
+		/* The devices below also count this device's header. */
+		if (dev->type == ARPHRD_PPP)
+			len += PPPOE_SES_HLEN;
+		else if (dev->type == ARPHRD_TUNNEL)
+			len += sizeof(struct iphdr);
+		else if (dev->type == ARPHRD_TUNNEL6)
+			len += sizeof(struct ipv6hdr);
+	}
+}
+
 static struct flow_offload_tuple_rhash *
 nf_flow_offload_lookup(struct nf_flowtable_ctx *ctx,
 		       struct nf_flowtable *flow_table, struct sk_buff *skb)
@@ -512,6 +555,11 @@ static int nf_flow_offload_forward(struct nf_flowtable_ctx *ctx,
 	if (flow_table->flags & NF_FLOWTABLE_COUNTER)
 		nf_ct_acct_update(flow->ct, tuplehash->tuple.dir, skb->len);
 
+	nf_flow_upper_stats_add(dev_net(ctx->in), &tuplehash->tuple, true,
+				skb->len);
+	nf_flow_upper_stats_add(dev_net(ctx->in), &flow->tuplehash[!dir].tuple,
+				false, skb->len);
+
 	return 1;
 }
 
@@ -1107,6 +1155,11 @@ static int nf_flow_offload_ipv6_forward(struct nf_flowtable_ctx *ctx,
 	if (flow_table->flags & NF_FLOWTABLE_COUNTER)
 		nf_ct_acct_update(flow->ct, tuplehash->tuple.dir, skb->len);
 
+	nf_flow_upper_stats_add(dev_net(ctx->in), &tuplehash->tuple, true,
+				skb->len);
+	nf_flow_upper_stats_add(dev_net(ctx->in), &flow->tuplehash[!dir].tuple,
+				false, skb->len);
+
 	return 1;
 }
 
diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
index 1e55644f2edb..ba5ac3ebe614 100644
--- a/net/netfilter/nf_flow_table_path.c
+++ b/net/netfilter/nf_flow_table_path.c
@@ -83,6 +83,8 @@ static int nft_dev_fill_forward_path(const struct dst_entry *dst_cache,
 
 struct nft_forward_info {
 	const struct net_device *dev;
+	u32 upper_ifidx[NF_FLOW_TABLE_UPPER_MAX];
+	u8 num_uppers;
 	struct id {
 		__u16	id;
 		__be16	proto;
@@ -187,6 +189,10 @@ static int nft_dev_path_info(struct net_device_path_stack *stack,
 		}
 	}
 
+	for (i = 0; info->dev && stack->path[i].dev != info->dev; i++)
+		info->upper_ifidx[i] = stack->path[i].dev->ifindex;
+	info->num_uppers = i;
+
 	if (nf_flowtable_hw_offload(&ft->data) &&
 	    nft_is_valid_ether_device(info->dev))
 		info->xmit_type = FLOW_OFFLOAD_XMIT_DIRECT;
@@ -253,6 +259,9 @@ static int nft_dev_forward_path(const struct nft_pktinfo *pkt,
 
 	route->tuple[!dir].in.num_encaps = info.num_encaps;
 	route->tuple[!dir].in.ingress_vlans = info.ingress_vlans;
+	memcpy(route->tuple[!dir].in.upper_ifidx, info.upper_ifidx,
+	       sizeof(info.upper_ifidx));
+	route->tuple[!dir].in.num_uppers = info.num_uppers;
 
 	if (info.xmit_type == FLOW_OFFLOAD_XMIT_DIRECT) {
 		memcpy(route->tuple[dir].out.h_source, info.h_source, ETH_ALEN);
-- 
2.53.0

