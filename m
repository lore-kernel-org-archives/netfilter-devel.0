Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9199123D408;
	Tue, 10 Dec 2024 09:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733823998; cv=none; b=c17xqyggpKBwt84CdrT7LCrSPNh7Q9OTUmzn2LrT8+jUJ/GL2JoPeQJ2QhOo82suUWBkkZLMA03S1dAMSA5QNGWSTE/WxN9q7s1SEtcB8bgvzYMo/aCzRW0xFZ7yPi5hpZp9LtFRGerya2d3AIT8wsUzEo5b3aLMwpIFSexcTR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733823998; c=relaxed/simple;
	bh=53JGUH2pR8oX8Xp8+Xw+36LGxxviOGdtjx+fvNsDyms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lTkSpQSUa81Ik1hvKTYZIVfL0NWCuiFCjVEXfEApQWGLT6SikIm09+QuBnReg+E9AYpnVc9CcKZPk2LDPPumuLjDT/ok/cvGZ4ABWJE+d6broIjk6ndRJ972Buvi6QR913C0yRznkN2bkKMCz7c0CS7OyYOnIUedDxfpPhsIISs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NPtf2hJm; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NPtf2hJm"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5d3ecae02beso3176556a12.0;
        Tue, 10 Dec 2024 01:46:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733823995; x=1734428795; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kjMfgZPTOt1wzklPxYQo1KoCry3saUouaCrKRGjXlrM=;
        b=NPtf2hJm33sdfs5FhNapzTmBIbeEEb0oiZ2inIGbcIAvwrSnraPcGPKz5wLKNC0kcj
         KexCCL3ElbhaUyotMWiwXSu+F5EWWjldhio2I3JirkTyDpJf3KfGvQqcmz2hU/BVldaE
         jpJsBhRJ8oxFJg2WYBSp7BTpGvKXzl+fqrWTtN1E+NHdwvCbx7o8xUjGYQB/alAMj1ee
         MDNK/j36gl7Xsv4SUKckIRPqK8x3NmxhP9ZveN50Ji20KPzStwjFuBbMPqLb2/36gj54
         J0ESHKwPtm3rZ13QOlEoZFElWsJ0RVNgNb8izbhGt+m+rDud5UR/6A2qXQgw+r4ieiij
         fcfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733823995; x=1734428795;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kjMfgZPTOt1wzklPxYQo1KoCry3saUouaCrKRGjXlrM=;
        b=wLjGNGwKqZZ0c1SQXvZlXTQ1zuFAOVGW4DC4pWLG8NwgCFFUVyfOS4LOWOZ1a0La64
         AZBajMFtBMK/SqdleCy+QYQ1yJqyTNFlGUHi44B0hFhRNS/Q8+Ug4isQB9iXOMm5TTQt
         z1cnY7rh1ITilvIQYGEGScyrG4ClgsldkF3qVj2qPCXq3abzuqRtVDbsLmcON03BV7Ma
         4MjmbA3AfpJSqbzk3VyaioUZAwtq9z5AVkp6jaOBa9jVZl4J5JF10GuYLfWFN61C2ioR
         MFyXDhAaFNmBNgkVPIox1P3cujcwTcZTP2C5OfezS+DoSKIqO3iSHao91gGvfe5SOLRa
         4zgA==
X-Forwarded-Encrypted: i=1; AJvYcCUm1MP5J4EAI+KmbVVBFot3trR6MjZ75w+fxiyUg8u9tUHcC/ECdUkyRm4JNOA+nmKOrzk22EY+ZrdhgYsaRsHr@vger.kernel.org, AJvYcCVhON/99rrvaYbv2qr1eiP+x2JJOQBk/azccuVH3f4bIWM539C8DXs7R/B9DmwlabR74sStAQM5SwZzOh0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+c+uvWF5B0FyaIBANkuvpZ5dQ94q1FlXb4HOVOyJOZSTkrI5r
	HWqi7Lsqqns0DtRo4hiifyv6NOEDMLTOs3IU6+4lTC518yFZoFxe
X-Gm-Gg: ASbGncvU35zOb+wABbCiJfBO+SPONFhJbwSf1KuxqUYZqulwATmFOputD/baOxRO/0R
	FsYY9J43jHSunXsbGTZ0bqHqmH+11hGPhGrccumV4wgAqLhX0eLJYNx3CYYCvgIf4foewLBR5I0
	CelYqTLbExghluMhdYHF4FGvOnBY3AFFSvZu23b+hyEDzoR1jHkRkLXBQsvC7xegdPXfpVu7yx8
	5jWwzshMMROb7lb6pSGBTmv1rEXR4w0mYMebYkdKfePFCPIebdETTGQ6O4y4IljWrdq+GjRTUIB
	T35vuo7lRAP59fYeKxk23/RGqxNzDT2XjOMFwmaLr/gJ11w2/MS3nHdHveMlbeOdv3ECKOA=
X-Google-Smtp-Source: AGHT+IFAu59kegmItDpMGH7TM0Tzld+Gwydm4Aw22u8I6s2WTgEkJzLS/k6ir2kKhoX3eegXigdJOA==
X-Received: by 2002:a05:6402:51cb:b0:5d2:7346:3ecb with SMTP id 4fb4d7f45d1cf-5d3be69d3admr15117186a12.12.1733823994692;
        Tue, 10 Dec 2024 01:46:34 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d14b609e56sm7313936a12.40.2024.12.10.01.46.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2024 01:46:33 -0800 (PST)
From: Eric Woudstra <ericwouds@gmail.com>
To: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Jiri Pirko <jiri@resnulli.us>,
	Ivan Vecera <ivecera@redhat.com>,
	Roopa Prabhu <roopa@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	David Ahern <dsahern@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
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
Subject: [PATCH RFC v3 net-next 13/13] netfilter: nft_flow_offload: Add bridgeflow to nft_flow_offload_eval()
Date: Tue, 10 Dec 2024 10:45:01 +0100
Message-ID: <20241210094501.3069-14-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241210094501.3069-1-ericwouds@gmail.com>
References: <20241210094501.3069-1-ericwouds@gmail.com>
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
 net/netfilter/nft_flow_offload.c | 144 +++++++++++++++++++++++++++++--
 1 file changed, 139 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index ed0e9b499971..b17a3ef79852 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -196,6 +196,131 @@ static bool nft_flowtable_find_dev(const struct net_device *dev,
 	return found;
 }
 
+static int nft_dev_fill_bridge_path(struct flow_offload *flow,
+				    struct nft_flowtable *ft,
+				    const struct nft_pktinfo *pkt,
+				    enum ip_conntrack_dir dir,
+				    const struct net_device *src_dev,
+				    const struct net_device *dst_dev,
+				    unsigned char *src_ha,
+				    unsigned char *dst_ha)
+{
+	struct flow_offload_tuple_rhash *th = flow->tuplehash;
+	struct net_device_path_stack stack;
+	struct net_device_path_ctx ctx = {};
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
+	th[dir].tuple.out.hw_ifidx = info.hw_outdev->ifindex;
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
+	struct ethhdr *eth = eth_hdr(pkt->skb);
+	struct flow_offload_tuple *tuple;
+	const struct net_device *out_dev;
+	const struct net_device *in_dev;
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
+	err = nft_dev_fill_bridge_path(flow, ft, pkt, !dir, out_dev, in_dev,
+				       eth->h_dest, eth->h_source);
+	if (err < 0)
+		return err;
+
+	memset(tuple->encap, 0, sizeof(tuple->encap));
+
+	err = nft_dev_fill_bridge_path(flow, ft, pkt, dir, in_dev, out_dev,
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
@@ -306,6 +431,7 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 {
 	struct nft_flow_offload *priv = nft_expr_priv(expr);
 	struct nf_flowtable *flowtable = &priv->flowtable->data;
+	bool routing = (flowtable->type->family != NFPROTO_BRIDGE);
 	struct tcphdr _tcph, *tcph = NULL;
 	struct nf_flow_route route = {};
 	enum ip_conntrack_info ctinfo;
@@ -359,14 +485,20 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
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
+			goto err_flow_route;
 
 	if (tcph) {
 		ct->proto.tcp.seen[0].flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
@@ -419,8 +551,10 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
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

