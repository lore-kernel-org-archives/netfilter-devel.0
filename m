Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C7171E3775;
	Tue,  7 Jan 2025 09:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736240785; cv=none; b=bq6YS9/logu5/9CcYO/4Vh/0O6jfCGsUD4DpjWyHrBBPqKR+g8+ME4eMFI0vusn4yFhBknNbyuy53Jn8/ytcEpTlOGYQcKL6Ri+0S1p6ByGE2pMdAPCZktIX9RDEqzvhyFLPp3Rff7Z4/bz18DdZOW1A9COnPHjiyVCLMTKsrOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736240785; c=relaxed/simple;
	bh=53JGUH2pR8oX8Xp8+Xw+36LGxxviOGdtjx+fvNsDyms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u/94Zai9q3YyQO+mTdH4jonpVEnH94+JgjFP6jmLBaawB4987WW0cBACutGecftCBnahkIwx7Db7rcgIY54op0ZTkdFMqLKrS78R25MXJT7yAC9lRyCC77kg2J9wsqQnLW+c8nOY5blipDjS/6epKH0atIw4zlcSP3mwZw2tXik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eunsjwsK; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eunsjwsK"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5d90a5581fcso8268425a12.1;
        Tue, 07 Jan 2025 01:06:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736240781; x=1736845581; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kjMfgZPTOt1wzklPxYQo1KoCry3saUouaCrKRGjXlrM=;
        b=eunsjwsKK+0zNsMZzTNQuxY5ebbVEe5Ex62rOp4WFXdJHqEekueMwhUuuo3ZExCmPS
         P4tjzlHvQNhAVPZ8TTqaoq0HazIdifsojT7FWoUse9SodCuD/k9JI9gY2AN3/Q9xrQgP
         oGOW54QWWsEd5idCx+QIre2SGSZGWt2QKv4r+iCXwTHqx5maj/RhvY6GwOIHHigzM1u2
         c+SHgK85tAYrbLNru7ifOhzHd2tEzcmKXULVY7tXsGVGzxuE+hy68ViotWIjYE58+vVV
         izoF2j9sLwJkIN8lgGYguDAFSMdtnqYZOuz6oC77Be3y2h0g0icY57sAboIvurj2JG0I
         Lntw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736240781; x=1736845581;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kjMfgZPTOt1wzklPxYQo1KoCry3saUouaCrKRGjXlrM=;
        b=spUUPaRnzuI1m3Ur9KOI+MJMXPWAmfUFTFULkGxAiM7cjviOvqWLvQsRHfKF/9tIzQ
         q5Svd14fDZW0EtiSjNJa9YdqycRdAQk35ykX1XYayct7a4JSwalnBKAsFFjVRhszhtg4
         DyDOh4ONMuI6xpvIohJiI49H3k/Ydzk9qIdn8Lx24bx1dN7rgxVHJ5fnU0CM2E6r2Aqy
         9rNU50Ls3H45th5WObLuD2XKFR4q+xugmkWy7GD82JgCpmfUty0mkVEiD+ZdykZkLR8A
         BlnxA22Ohfdkinyn9DuV5zdGJoqyT9a0VwdvlssPGSyZYj13BY7hZRBzmcby3t7D3je1
         E1bQ==
X-Forwarded-Encrypted: i=1; AJvYcCVx5kfkKahtTHPLDOGfIasgcdZ08fD6S+ZIyS9q4T/gJXJ5UX3YM+E2eqsRHfEFb+Rika2OawjbjkrMwGF5GHTp@vger.kernel.org, AJvYcCX+92CWNCfec+BNbxBoS+6bEEOGI/R3Xvwhw/ffXlp7KRR6YLUFKOqI0BBIHyXZ9T8IjOVEbXr+V9rJoA8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzKsfwBSNsvX0tWZkId/LZbHj+pC3k6Y1mclEzKWlF08L1olpZ9
	RHldsHgVC76HxwqDYKT4n+g4pXIjyQp83XinHbdfWreuznbCrnlG
X-Gm-Gg: ASbGncvpesD5sdmZxcrP+kp37YQFHVLXhv68BtbDZ5mRSAMxILSeQ4b9Piy1MFgsY91
	22CSZGPmCpovJwH8l+Mg87vkr94WE6tXwlYm9e8VuFt9JciEuVOXvg2/JR6JNMHcGLZCpV5yq9g
	uWntsPoSCsNFehUeCpz1QYRCu10eCsBQCKoAjgWtfz0r8moDFK941n+5jzKvb0+maNbr4sJVTQ7
	94pL5gIDUaOF4cPywzJy5+D8TU00/S1xAPYcyF0NdrknAYNjXxw/uh6UdIxSDntlKzrEySNYy5x
	4ji9Eoa2e+MhKod9P31UlwhuhfUPiRLFHL8UZPVRGgBulRX4TEJQYw0l/AK9YOKoXPwYxQGiGw=
	=
X-Google-Smtp-Source: AGHT+IEZgOPUuG7xbszfCT298CU/i252/FBQIVsTD95aponqU63zDuW03UcIkUyIYtVMFWqIiCMCcQ==
X-Received: by 2002:a05:6402:26c3:b0:5d6:37e9:8a93 with SMTP id 4fb4d7f45d1cf-5d81dd5e95amr53938837a12.2.1736240781203;
        Tue, 07 Jan 2025 01:06:21 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d80676f3f9sm24005333a12.23.2025.01.07.01.06.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2025 01:06:19 -0800 (PST)
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
Subject: [PATCH v4 net-next 13/13] netfilter: nft_flow_offload: Add bridgeflow to nft_flow_offload_eval()
Date: Tue,  7 Jan 2025 10:05:30 +0100
Message-ID: <20250107090530.5035-14-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250107090530.5035-1-ericwouds@gmail.com>
References: <20250107090530.5035-1-ericwouds@gmail.com>
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

