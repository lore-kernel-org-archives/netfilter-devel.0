Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C21751D5170;
	Sun,  9 Feb 2025 11:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739099470; cv=none; b=P+R35y6hJj8dSZupunppmTAd+LxZ8RTPt5vlR/4LckX8nnAUNkFLuUdLrf7gewC5FW+mI0+RCaixtb4QjB1Ouo11IjMHkTPXbl3/qD/IJnbSpVEeqn+hg/2NY18Cd1LS+o3Uhlp1V5loZ3zhSWPHZ+CiSp1fn/62pYWvLXAaquw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739099470; c=relaxed/simple;
	bh=ao9814Zv6bDQnM5yUC6g/RI939BnwcO/605XslPLDVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P844k/4H9dXUwEsqWRBCHpZqY5S8TMnPUZDC4t7bBFWUNYI2q8cdXemfmWC6vZaxh9ayt9ArfuRLQExDTpbUOU4wSSNcZHLXHa61yZ0Z1OrXIH0rrubfIy4V8BYC7Cy+iIlg00IzToWujZqR8j0SLWW8TGwc0jGK/AxJH77jLw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CZ9jrClh; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CZ9jrClh"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-aa67ac42819so542794366b.0;
        Sun, 09 Feb 2025 03:11:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739099467; x=1739704267; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E8P5h61gnv0DfF0R+vjh2CpjgGHUfjM4UjNVV+Pbc34=;
        b=CZ9jrClh7emwIoGqQJCitj5g4kozIQpdMiwPA9CUcFSRvJzjdoF0uhurtG/C3h9+ES
         tF8ZoAOkrSnyRd05gofR3udpKq2sQypWEhwmugKBZAz3pvMyNrHdCSwLvAWpNaxKJqFI
         W+zMJOwwBEGe79ISz6ioU3INBeU70PbHOJma3CFPmwDPJLAe4rNWQ2EXjGhwSc2jyAh7
         qgjXOA84lK4VlG7YEQg+yOddNVM13+2kb8tnUWIkwvlHc9clo3/+1HQvxJSF3Gu4RbgW
         DJBpst2VcYyo9l/gxtRBVA+/oLxYGLk3Yr1oG2LckzYnZj20OXCFDCrbCbIciqSwL0Os
         N4BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739099467; x=1739704267;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E8P5h61gnv0DfF0R+vjh2CpjgGHUfjM4UjNVV+Pbc34=;
        b=PqM0fOjMNgoN3ummX1eewEg5cz8Qrw//+Buqi7xPkEBsUH04mE28BBSqxeyZspXSml
         ejp/QYdtOZVzn4m8z4nb9n/WUFfyy5uMqP5Ar/OZLrK2WWJ1w8jPuWnDpEl7j/spmj/X
         Wh9mk6O1joBAXjBDVgOAsP4BvzdPGxkkqlv24rqW5GW2oZdEnuJI64dfZ0inJz7nYEYm
         fxEOip3dfexRazXXfMsfIbjJxW1kiu1CEfq3pYLNGH+WmeKvoZCQYAz34NZcOgn6klP2
         eT9Mi7/vFeQO+fxel5BgevqX2tLv0/Ry393CnZlPMtjAJ2Oley/LNMe4/GV/Tm13nMO+
         mifQ==
X-Forwarded-Encrypted: i=1; AJvYcCWgImOblH7HZ3y5wgyFH2r8TNp9yH8ltm7m3iCsagu25hMgnQfgaMufukH1pMAZiDyX8ttCI+T/hTz5qujsvyOe@vger.kernel.org, AJvYcCXVj8VFk+gsl3GyfuoSlVhlJ22IccM91CwwZFvY/YoMbghkwvgiGQFEfjE3niwOEI7Z4K7SQihZ6i6juDU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1RJJTLAQFBdXc3/431tkneeKABLJsqcjDiVWnMJW0pELwX4l4
	mpr14i2Pafj9Rs4CiQfqWY4z+fx0cwH+fpfsfj1ZdVnnmgoMnrx0
X-Gm-Gg: ASbGncvMD+t75n9HNkDmY6HBA1xmeGvfiW9IKXBsbOAVSMHxilibE6xtBqYOjrv+Nx3
	L8w5XXk1XJfJE3LtOQmleM7w34yKLXdvVc97guj2ILISdZibLMsYmq2h9W/xCEqOH2e+UOlEOzH
	3d7eYRaHFIYZ9CcEHDnWdMPPUNn44+kbjF6NrqJVwaACNJdja66Ds1gcc9cq7v9TvDnrMfMXugr
	H4onazLQg8YY6h0o1go3F5dOqoxpWK6sChmV0nCugtOmYI5CsMThe1usNeZ1QTytCcnFQ+msnL4
	OL+fXeDBYEcDmUfZiBRQqJT1lo+qB0Us/heKsEIH5WbFWaiv6FD3ZRn9/REObRYmobapFP9YsEA
	p1IixrR8Yl0xzABKtl5hPhKkYv7H6wnEH
X-Google-Smtp-Source: AGHT+IGZRF6k7gUou0armnQJpdzdTVsxQVaZTHzDyoIUAwWtfIpjPHiTBin2asf2/t+io5MqclVHSQ==
X-Received: by 2002:a17:907:971e:b0:ab7:a1a4:8da4 with SMTP id a640c23a62f3a-ab7a1a49004mr506860966b.33.1739099466925;
        Sun, 09 Feb 2025 03:11:06 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab79afc7452sm357516366b.163.2025.02.09.03.11.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Feb 2025 03:11:05 -0800 (PST)
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
	Kuniyuki Iwashima <kuniyu@amazon.com>,
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
Subject: [PATCH v6 net-next 14/14] netfilter: nft_flow_offload: Add bridgeflow to nft_flow_offload_eval()
Date: Sun,  9 Feb 2025 12:10:34 +0100
Message-ID: <20250209111034.241571-15-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250209111034.241571-1-ericwouds@gmail.com>
References: <20250209111034.241571-1-ericwouds@gmail.com>
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

