Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 715512144B9;
	Wed,  5 Mar 2025 10:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741170625; cv=none; b=akHtNL1IlBrCbgWcbuiVV15fYtRxZaYX//aOkkZnl56FNgAhgK6HgLfLgWWsoRRVBnAg6l4PtId2j8UYg9TnUWj7esWdKcNhi0VFzdivFQroIibluQCbNp3Mqw/TpCGuz761Ur/A3aE3yIn2RYvSWUYjG8tw/KcdpC7RMBc7aZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741170625; c=relaxed/simple;
	bh=hlWUZMMjuKADtGppUZMtaNFacTd6nV0tzjbOD4afBPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OJlHbsfs5PS5k/6PZJbPj0vbjteZF3L6a7zLH9LkStn0cm0iYbGvqRxo/cehlHwuRv2NY3zyLXvlsMO3EqWEV70Dg+yYDRrqoTB5ZvQLBYBw6Rtpz1dw1KZOhDQx2hePU3qNIOOgal/PcSH7LmwotCbe69T+8jOBGzQsfpcaCVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F3+Im8ai; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F3+Im8ai"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-abf45d8db04so680584566b.1;
        Wed, 05 Mar 2025 02:30:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741170622; x=1741775422; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zyT2Mi/6pyGYcArKqE9jEC5bRVJkRpNfVbm3I9wiTzQ=;
        b=F3+Im8aifsZa8YbOMy4BMx8wKnw9kMjny0SVlpMD7ovs1Ca+QTxMZ1EHSdHzR+vBRi
         j2a8foVX/K7fbNQbAxHhaqZhFfOvp+Q8c3R2bnzaix5cwguoFPAGTv9C0k6KTJVUctQF
         DEedCNbFaiQmGNyvAsuEddWPtuE4TcG5cX6rPUWPtTzLocYUMUiFomnvSKNs4dQLwxDc
         VZdmwhBQN4+MIQmS/6RqtnAkKRVatGDyuQDagcPAngkC4xoDSXN7yr+p06Fr7SboevLC
         jg0pNgGGkvxzX4XJ29pg07cxohYrLZiEywfVqXAqGAAlYdMjDGhbqnAOAdNxvKPdOk7Y
         mimQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741170622; x=1741775422;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zyT2Mi/6pyGYcArKqE9jEC5bRVJkRpNfVbm3I9wiTzQ=;
        b=w3iui7sk+UMze3qWWb9KHor1LcdLEmIQMZf60Ld9UJbQ+kahyimPCw0evi2RIgkbb8
         WWIlzysrv+46nQjD0XayTTwl2g4LJHy1+Vka4JOMJnIXioGBTZo/Y6Wuk0gkmOxDcmJ4
         POR8PhkRMStv6P/a88NZbWco4eeWTxEosKaF9hA5f4zwokP0ImavOvTTWecdlDVAIHVY
         9gKEwkQQIe9diJwrg7a2JPL71MHq2fK7/2u79ERVZuf35eq/UqTbI0s78RXkgRQmwY1K
         EYEu8ZgDV7eEPGr9nPcpWnr+c0Gv/LAal+X0Kw96+FXHLw2lXjRqk0xvz5cAeJsM1RfC
         AwiA==
X-Forwarded-Encrypted: i=1; AJvYcCV6IaNqRzkW4JaK/tC5PSKWqEhm5V+87leZ74H56RrcCxOeFE8KIL/jM2lHeERDfxAXKyBbPl43r7FKGL/1H+U=@vger.kernel.org, AJvYcCWi4bpfPbraPfJ4H/Ir2g+vgBOfLjXiWbwXpAcrLjpC3Z4ezIv++PpNmAkYOQuNMQv0ktdoYTw4CYsah91Vv88a@vger.kernel.org, AJvYcCXdXFf6VATBGLyjOZ7HMYYERKjFz9zr0OP18p2/pTMGMHqzufrtzixmSOTHF+fyK4Bq3jPu+6cURqCtSg0D@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4g7jX76p9sXinfhCZdjJJe2/B+Q+ryiMW+cTCekVECyfuQmye
	AWtQsdYM8evGGOilpndgfumNL0rly8E/avFtcXkz92H9jG2jWaUo
X-Gm-Gg: ASbGnctxB7oZyEAjA+P1Y/jMh1F3XMyZsPnrUsvYVoUjPnCueVLAQ5yS18SL3jpJpmZ
	KuPlKw0EJdbrwo75XJVLkSGD3QAN+lpAgvckL/WS0XaRaTDWIvk1eBgAhaCir23888M1583roQr
	mqFdSSFSqhyCAW4knHSGtnEb0ljz2UTjiDb6v1q5yFtIgxsriBq3ex+9IJjytL9FW0vdtQH/czY
	LwWbSR70VUE5F3tb/pB+C0DzPEyIa5YdyzZh3aF/UNu0bPvySPhFfnX4XlXeTLPWjtzsr2CleOM
	qb3baYsR+uUbQv+w5TP2ELPJatU36moEVqpQLW28FnlNXVSSo7ltL3YW9xlp0pPT0mwd+k9+57o
	prdJDxOYYYQE2PSPuCPZhLX8q/7uLpkxWZImIZCfwMV/4xdA1kfonDXksAJLBiQ==
X-Google-Smtp-Source: AGHT+IEYoyIO/7Ua8QChf7dL+PueD75+tHKS8ttknXnuhde+EClQAHkSCbndwT05/pBTf0yKshUXyA==
X-Received: by 2002:a17:907:7dab:b0:ac0:9b39:32aa with SMTP id a640c23a62f3a-ac20d8bd056mr192767866b.23.1741170621433;
        Wed, 05 Mar 2025 02:30:21 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac1f7161a4esm247154266b.161.2025.03.05.02.30.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Mar 2025 02:30:21 -0800 (PST)
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
	Ahmed Zaki <ahmed.zaki@intel.com>,
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
	linux-hardening@vger.kernel.org,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v9 nf 15/15] netfilter: nft_flow_offload: Add bridgeflow to nft_flow_offload_eval()
Date: Wed,  5 Mar 2025 11:29:49 +0100
Message-ID: <20250305102949.16370-16-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250305102949.16370-1-ericwouds@gmail.com>
References: <20250305102949.16370-1-ericwouds@gmail.com>
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

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
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

