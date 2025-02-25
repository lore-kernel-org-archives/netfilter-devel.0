Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E3721B9D2;
	Tue, 25 Feb 2025 20:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740514606; cv=none; b=tMNghqtRiXNADQhPHbouXhx9MuUaX7fDMb5p2JKIS7tefCaecrpkKvip5LD0JkUFDj8+EZlxtE/6T9PBtHc7Q0mBHeLS3LV9SLjWpbptq8+BoZn2Iybzcmd/IX0+Gms2qxhG/oTM80wPAHkF7JKgnuNg6GGngzgYo0z3Mu2pO3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740514606; c=relaxed/simple;
	bh=ao9814Zv6bDQnM5yUC6g/RI939BnwcO/605XslPLDVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=csapvVm59sn26bcfvFg0ID8EtPUe8TJ2INC/2xEbEMBF5yxChZTkWJq7LtoklzhedliEVBe+Jlu/T9yVlQmE7fec60Em6KilMt5eS9tauUMHhp8LQq3uV4WVdqp7yI4JTN+1SXHacGMe0xhL5TD0CC5EXJ41Iq+/4Y8ZfEGBG5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j96eEWMO; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j96eEWMO"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-abbdf897503so36715266b.0;
        Tue, 25 Feb 2025 12:16:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740514602; x=1741119402; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E8P5h61gnv0DfF0R+vjh2CpjgGHUfjM4UjNVV+Pbc34=;
        b=j96eEWMOP3Phcf13bSY4u+bwGrMWS1lGwamp6Tvq6aCnnaKY6AssBb3XkjXgjxlYJ3
         CcbOJEyuAsKsGhHzAPY1+uqHGkHPCSUHo4Hvs8ZwWceLnaal3uIppwnrqSOeajv8qVG6
         yxLn6cyZaTSqcC0ht/PKYJ5tn9l+N+a28TM6uXUTc6E/vFVvTzeXPzIx5uiDIV2WGb8q
         0GVuM7ZEsutqzP4un2j2S1EdDMDTvBGS5HECl3iZwPEh+a7jE0P8bZTbY/cxPxqvRu8F
         aNcULP7D+pQFgRGC+xNJGOiSWzuw9ateJ2qvt++UM8wFgjsU1I4JsGewjD3JRtFeOy1w
         eZuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740514602; x=1741119402;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E8P5h61gnv0DfF0R+vjh2CpjgGHUfjM4UjNVV+Pbc34=;
        b=ONLXv2VSagVcRzIuYteyQ91tag+80GM4v+RpBk0adTPjua1WWOqo+9XxO9PJhZNhTC
         h+E0oHUA2kPI5JJkhDsAsca7nsaHmjL+4jVwlgIvWgVCVqY1BjG5GdZmq0IaT+4cRSZj
         26omvEva4lrf7K9yAWm70atdhqBpdfbso+7+t/i27re0DXlO6scwW5A8ny4t7389Ch1y
         LN4knOTC+IeiFg9+s5aqCo9LHJzCCxj5Q+qH3iGoWBqJ6mFAhtZ1GNFd191TehUNluSP
         QXlFpkLL0p43tDftULckTaAzggGAXwGzhfuTVunrZKSfOmzFGplVDqzOVJONQnO2fsgc
         ODXw==
X-Forwarded-Encrypted: i=1; AJvYcCWtII5GEjv0j9w2si7qUvywLOafuENoFCCoBJFi5aTmPGF3JS74iEHaf51I3xC7WwmTdYfM3LdYqlAOSXY=@vger.kernel.org, AJvYcCX3r5ihwKSOC5tHscGKG+m0gFVb25Ax6+dJo7HcTrNOTCBFq0gNVnnHLUcQTpAD0kJF+tJ8WaTN8GatXhWj6lcN@vger.kernel.org
X-Gm-Message-State: AOJu0YwAKwCvZKYhSxM9HHN96+0yKTK4abaGCQtpAHPjxRbIK+DRPQpN
	gvwS61dmoZJ9ixdA1p/k6zT2ABgp3Z8o/mxFaQzl6dcL3lCgA1cI
X-Gm-Gg: ASbGncs0M9p/4ojLiQsVY287VxVdbqiAVU+fkE7gW5blngTucYO2zPV2eInpFN1xxsR
	NVnylsQg5VZfnIaplOi4z2TtfCzdCJgEkOWrAUBvaWyGenffWUFedat6QV+NXXVvfqTXZVK5C0P
	odKjB+2W9dTXHzTJZuq5lM/Z7W/iY1NfDx7ufiRIktmfYRhZPXqE/Z6Aj9Aok0qmY8zqs5yJPex
	pGrVANILjM6SrMUm1iYexp6asB/F/om6rO+Sc400Vr/DWSzLN8yDQIfQlR46oEQJ01kIq9Vq0Xi
	Yx3kisvNqMTgWqXQZKLdol5HBQtXNNVGuE7Z8xBpdkcKdl/4bsfO7xwVGbTfzHmih7R2v6pFRj3
	S8r3B3hnpowfto1jBnqbxcU9pbiZqkrAPx+o/sgawzh0=
X-Google-Smtp-Source: AGHT+IErCNHvUEetSRKi2Fz/dRzAsZ4C8dWcnPsAPVqwFDmd0GWTebWBy4vbvP5wLftQ4Gc/RXx2yA==
X-Received: by 2002:a17:907:7fa4:b0:aba:e1eb:1a90 with SMTP id a640c23a62f3a-abc0abb3bb2mr2093020566b.0.1740514601742;
        Tue, 25 Feb 2025 12:16:41 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abed201218fsm194319666b.104.2025.02.25.12.16.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2025 12:16:41 -0800 (PST)
From: Eric Woudstra <ericwouds@gmail.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Jiri Pirko <jiri@resnulli.us>,
	Ivan Vecera <ivecera@redhat.com>,
	Roopa Prabhu <roopa@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Joe Damato <jdamato@fastly.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"Frank Wunderlich" <frank-w@public-files.de>,
	Daniel Golle <daniel@makrotopia.org>
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	bridge@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v7 net-next 14/14] netfilter: nft_flow_offload: Add bridgeflow to nft_flow_offload_eval()
Date: Tue, 25 Feb 2025 21:16:16 +0100
Message-ID: <20250225201616.21114-15-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250225201616.21114-1-ericwouds@gmail.com>
References: <20250225201616.21114-1-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Edit nft_flow_offload_eval() to make it possible to handle a flowtable of
the nft bridge family.

Use nft_flow_offload_bridge_init() to fill the flow tuples. It uses
nft_dev_fill_bridge_path() in each direction.

Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 net/netfilter/nft_flow_offload.c | 142 +++++++++++++++++++++++++++++--
 1 file changed, 137 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index c0c310c569cd..03a0b5f7e8d2 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -193,6 +193,128 @@ static bool nft_flowtable_find_dev(const struct net_device *dev,
 	return found;
 }
 
+static int nft_dev_fill_bridge_path(struct flow_offload *flow,
+				    struct nft_flowtable *ft,
+				    enum ip_conntrack_dir dir,
+				    const struct net_device *src_dev,
+				    const struct net_device *dst_dev,
+				    unsigned char *src_ha,
+				    unsigned char *dst_ha)
+{
+	struct flow_offload_tuple_rhash *th = flow->tuplehash;
+	struct net_device_path_ctx ctx = {};
+	struct net_device_path_stack stack;
+	struct nft_forward_info info = {};
+	int i, j = 0;
+
+	for (i = th[dir].tuple.encap_num - 1; i >= 0 ; i--) {
+		if (info.num_encaps >= NF_FLOW_TABLE_ENCAP_MAX)
+			return -1;
+
+		if (th[dir].tuple.in_vlan_ingress & BIT(i))
+			continue;
+
+		info.encap[info.num_encaps].id = th[dir].tuple.encap[i].id;
+		info.encap[info.num_encaps].proto = th[dir].tuple.encap[i].proto;
+		info.num_encaps++;
+
+		if (th[dir].tuple.encap[i].proto == htons(ETH_P_PPP_SES))
+			continue;
+
+		if (ctx.num_vlans >= NET_DEVICE_PATH_VLAN_MAX)
+			return -1;
+		ctx.vlan[ctx.num_vlans].id = th[dir].tuple.encap[i].id;
+		ctx.vlan[ctx.num_vlans].proto = th[dir].tuple.encap[i].proto;
+		ctx.num_vlans++;
+	}
+	ctx.dev = src_dev;
+	ether_addr_copy(ctx.daddr, dst_ha);
+
+	if (dev_fill_bridge_path(&ctx, &stack) < 0)
+		return -1;
+
+	nft_dev_path_info(&stack, &info, dst_ha, &ft->data);
+
+	if (!info.indev || info.indev != dst_dev)
+		return -1;
+
+	th[!dir].tuple.iifidx = info.indev->ifindex;
+	for (i = info.num_encaps - 1; i >= 0; i--) {
+		th[!dir].tuple.encap[j].id = info.encap[i].id;
+		th[!dir].tuple.encap[j].proto = info.encap[i].proto;
+		if (info.ingress_vlans & BIT(i))
+			th[!dir].tuple.in_vlan_ingress |= BIT(j);
+		j++;
+	}
+	th[!dir].tuple.encap_num = info.num_encaps;
+
+	th[dir].tuple.mtu = dst_dev->mtu;
+	ether_addr_copy(th[dir].tuple.out.h_source, src_ha);
+	ether_addr_copy(th[dir].tuple.out.h_dest, dst_ha);
+	th[dir].tuple.out.ifidx = info.outdev->ifindex;
+	th[dir].tuple.xmit_type = FLOW_OFFLOAD_XMIT_DIRECT;
+
+	return 0;
+}
+
+static int nft_flow_offload_bridge_init(struct flow_offload *flow,
+					const struct nft_pktinfo *pkt,
+					enum ip_conntrack_dir dir,
+					struct nft_flowtable *ft)
+{
+	const struct net_device *in_dev, *out_dev;
+	struct ethhdr *eth = eth_hdr(pkt->skb);
+	struct flow_offload_tuple *tuple;
+	struct pppoe_hdr *phdr;
+	struct vlan_hdr *vhdr;
+	int err, i = 0;
+
+	in_dev = nft_in(pkt);
+	if (!in_dev || !nft_flowtable_find_dev(in_dev, ft))
+		return -1;
+
+	out_dev = nft_out(pkt);
+	if (!out_dev || !nft_flowtable_find_dev(out_dev, ft))
+		return -1;
+
+	tuple =  &flow->tuplehash[!dir].tuple;
+
+	if (skb_vlan_tag_present(pkt->skb)) {
+		tuple->encap[i].id = skb_vlan_tag_get(pkt->skb);
+		tuple->encap[i].proto = pkt->skb->vlan_proto;
+		i++;
+	}
+	switch (pkt->skb->protocol) {
+	case htons(ETH_P_8021Q):
+		vhdr = (struct vlan_hdr *)skb_network_header(pkt->skb);
+		tuple->encap[i].id = ntohs(vhdr->h_vlan_TCI);
+		tuple->encap[i].proto = pkt->skb->protocol;
+		i++;
+		break;
+	case htons(ETH_P_PPP_SES):
+		phdr = (struct pppoe_hdr *)skb_network_header(pkt->skb);
+		tuple->encap[i].id = ntohs(phdr->sid);
+		tuple->encap[i].proto = pkt->skb->protocol;
+		i++;
+		break;
+	}
+	tuple->encap_num = i;
+
+	err = nft_dev_fill_bridge_path(flow, ft, !dir, out_dev, in_dev,
+				       eth->h_dest, eth->h_source);
+	if (err < 0)
+		return err;
+
+	memset(tuple->encap, 0, sizeof(tuple->encap));
+
+	err = nft_dev_fill_bridge_path(flow, ft, dir, in_dev, out_dev,
+				       eth->h_source, eth->h_dest);
+	if (err < 0)
+		return err;
+
+	return 0;
+}
+
 static void nft_dev_forward_path(struct nf_flow_route *route,
 				 const struct nf_conn *ct,
 				 enum ip_conntrack_dir dir,
@@ -311,6 +433,7 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 {
 	struct nft_flow_offload *priv = nft_expr_priv(expr);
 	struct nf_flowtable *flowtable = &priv->flowtable->data;
+	bool routing = flowtable->type->family != NFPROTO_BRIDGE;
 	struct tcphdr _tcph, *tcph = NULL;
 	struct nf_flow_route route = {};
 	enum ip_conntrack_info ctinfo;
@@ -364,14 +487,21 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 		goto out;
 
 	dir = CTINFO2DIR(ctinfo);
-	if (nft_flow_route(pkt, ct, &route, dir, priv->flowtable) < 0)
-		goto err_flow_route;
+	if (routing) {
+		if (nft_flow_route(pkt, ct, &route, dir, priv->flowtable) < 0)
+			goto err_flow_route;
+	}
 
 	flow = flow_offload_alloc(ct);
 	if (!flow)
 		goto err_flow_alloc;
 
-	flow_offload_route_init(flow, &route);
+	if (routing)
+		flow_offload_route_init(flow, &route);
+	else
+		if (nft_flow_offload_bridge_init(flow, pkt, dir, priv->flowtable) < 0)
+			goto err_flow_add;
+
 	if (tcph)
 		flow_offload_ct_tcp(ct);
 
@@ -419,8 +549,10 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 err_flow_add:
 	flow_offload_free(flow);
 err_flow_alloc:
-	dst_release(route.tuple[dir].dst);
-	dst_release(route.tuple[!dir].dst);
+	if (routing) {
+		dst_release(route.tuple[dir].dst);
+		dst_release(route.tuple[!dir].dst);
+	}
 err_flow_route:
 	clear_bit(IPS_OFFLOAD_BIT, &ct->status);
 out:
-- 
2.47.1

