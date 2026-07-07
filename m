Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F07391846
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Jul 2026 09:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783415487; cv=none; b=k6Wqko/U3POOKK4recJlLxuBNClkRYvwgNdPNGt6WZxEIX8R+cyS5qxeQcugLdOD3nD3F4p5t+VhQ5AK6QsgKsaBUmCxvMAQy9x/Fhw+bQyzEPEzWfANO+LH5B6wXBx10s4mU4+vD1PvR87b2opex8fCjW015JcXDtdjs+asceA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783415487; c=relaxed/simple;
	bh=cIupgpL+oLAc4FT3upk6ZOM6xx4HQ5fC0K1GWbF5Ijk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MgGon3T0qdMiYnA3dp+YITmPA61dj69R+PdN5E5lGRXiNZtOnnoc0drAejuEI/dbDJ8jCZAyk+dFCyWn+B5+ngTb6jrqgBYrFVS+C878dVYDsZwzid9RbXdbcHNO/6m197Uw+XUaX0AspDbXO+HAoiHAvcgtZpub4Wj4whPRDZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VaraqvXS; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VaraqvXS"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6989c0ec3c5so7734161a12.2
        for <netfilter-devel@vger.kernel.org>; Tue, 07 Jul 2026 02:11:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783415484; x=1784020284; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=55T+jBPAl2TQo9pZ1aG/hh01uhhF19W9W07xYipeSiM=;
        b=VaraqvXS3d5dhvT5bO0WOlgX7th4yYMznF7aC8uDWE916B4Ws6mB/MMDVBuiloAP9P
         DHqL6wDRgEv/ENQbZcACPVsNNksO3O6Rc3ORsk/2b7VwQ8Kn7NsYxcOmKewREWVPF0eL
         XAwEHO/dcvbqHLjWPGVmCT13GnOCJwNThep8hUg/9eDxpoaVtOkoQoHzFuPhwQsYuJRv
         Y7k10NNYz64j3qR89gQaUGpVIWtzP7Gz7l7E6DD+8Occ5HJQg+kEFyWfcP1hXkS9I9tS
         9f2jypMM/+dCMFXXAxEzJh+/uI2lAHzamgLeIxI2dr6ImBPpA29CSf0Yy5hvB0S+m46G
         VYUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783415484; x=1784020284;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=55T+jBPAl2TQo9pZ1aG/hh01uhhF19W9W07xYipeSiM=;
        b=tB/nt/yOM0NOeJolYpzoSmeNwhgYPb5/PoP1qbyXXMWM0FnCy8+e9FZrnVs6L+GcU6
         Op6OKoRdDFocl8Fm1mbZK+qzrAlm55o+1pePbGKjyW0DwGqvbHic4aZmcWH7qpfQT6I1
         OEkmPIefyHXRO1xxd15TPOI41LZRBMxhzE5L5vN1qowr9igi5/g1HBlmXcqDfVeNA1u0
         8yuT4f4Cf8D/T3Z4PZ/Gb6vPLluclbjWrFdK2lnRyhL5OEtpxe+Bu9P85EzlfkYiQxRs
         x/U89gryyB8/gzOa+7ls5KZsU+sm6+eq/+LoqNgQeY9ZOWhPyREGBUr/HI1KJJToaWI3
         CniA==
X-Forwarded-Encrypted: i=1; AHgh+Rqn+sY0pqoOtuizUtyC8SNCPtd8n7/l04eWD5tGGhvTXCGNslZsUxs9REZzX47Lw3LbAefZbEoFhQKS5ZCIP/o=@vger.kernel.org
X-Gm-Message-State: AOJu0YxV/Aad7nRr0P1d4rqHoGB+HjhjKfdcaVquH0JCRaXTNJuXj/Ty
	HpIgXtZZtJRuiK0brxXe4akMg3q+2pxKsRhQ9wD0UClyDFzKRL0RDzbY
X-Gm-Gg: AfdE7ckaRQvGqhMBJ+UCa9jse527w1YzHU5hpZwOTzJ/XX37SDHaBxdWYEpmc5j/xik
	AgQ3zqiADsMn9Le2+SbVKrIV1VmE1JEiLZPeGv35RfT9/QBOFpCDnTU87CKPArgEgw482ufbCtd
	nLKgvyWCj78V73sRQGDu9Su4ImkHRfaF1sfTCr1c6T0AOpLRYfW2VS+tFYoeUZknptSiWVvRIfn
	1zZjjjd/2uwFnon3+y058vtd4toIKuKueUN6TG40nH5EBO8xftQqCKQcGgTg9H0kRWcqC/CSBuU
	KFmPEzsbau1B5VTntwVXmQzFs1hzrArq7W2lF8tNDSUd9tiRA56/WumkfmtErDaxN7j7/eeC7nT
	a6O62SDk2u5RThLFPTmUqhuG4LyLtHYQ0kAO0eNZea64ZiQJlVAE+V02X7b3V31xLekKESRszv1
	Ua1yi+L9bFEbXHulw6ggqv23s9q75tdWL+5EELonXiVCIENDVY1V7OVldDh/0Bdna9q2T6WmQzs
	kFK88EBQ9krDydLdFBKoR73+SNfOJdMpQZgZ6hya5QC
X-Received: by 2002:aa7:d0c8:0:b0:698:18e7:9c48 with SMTP id 4fb4d7f45d1cf-69a85b96550mr1571758a12.15.1783415483553;
        Tue, 07 Jul 2026 02:11:23 -0700 (PDT)
Received: from eric (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-69a19cd87d6sm5297152a12.6.2026.07.07.02.11.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 02:11:23 -0700 (PDT)
From: Eric Woudstra <ericwouds@gmail.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Stanislav Fomichev <sdf.kernel@gmail.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Krishna Kumar <krikku@gmail.com>,
	Martin Karsten <mkarsten@uwaterloo.ca>
Cc: netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	bridge@lists.linux.dev,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v12 nf-next 7/7] netfilter: nft_flow_offload: Add bridgeflow to nft_flow_offload_eval()
Date: Tue,  7 Jul 2026 11:10:45 +0200
Message-ID: <20260707091045.967678-8-ericwouds@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260707091045.967678-1-ericwouds@gmail.com>
References: <20260707091045.967678-1-ericwouds@gmail.com>
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
 include/net/netfilter/nf_flow_table.h |   5 +
 net/netfilter/nf_flow_table_path.c    | 126 ++++++++++++++++++++++++++
 net/netfilter/nft_flow_offload.c      |  20 +++-
 3 files changed, 146 insertions(+), 5 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 5c6e3b65ae85b..a109eda5250c7 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -305,6 +305,11 @@ nf_flow_table_offload_del_cb(struct nf_flowtable *flow_table,
 void flow_offload_route_init(struct flow_offload *flow,
 			     struct nf_flow_route *route);
 
+int flow_offload_bridge_init(struct flow_offload *flow,
+			     const struct nft_pktinfo *pkt,
+			     enum ip_conntrack_dir dir,
+			     struct nft_flowtable *ft);
+
 int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow);
 void flow_offload_refresh(struct nf_flowtable *flow_table,
 			  struct flow_offload *flow, bool force);
diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
index 2b6ebb594a9ee..cdd6a822cb811 100644
--- a/net/netfilter/nf_flow_table_path.c
+++ b/net/netfilter/nf_flow_table_path.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/if_vlan.h>
 #include <linux/init.h>
 #include <linux/etherdevice.h>
 #include <linux/netlink.h>
@@ -365,3 +366,128 @@ int nft_flow_route(const struct nft_pktinfo *pkt, const struct nf_conn *ct,
 	return -ENOENT;
 }
 EXPORT_SYMBOL_GPL(nft_flow_route);
+
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
+int flow_offload_bridge_init(struct flow_offload *flow,
+			     const struct nft_pktinfo *pkt,
+			     enum ip_conntrack_dir dir,
+			     struct nft_flowtable *ft)
+{
+	const struct net_device *in_dev, *out_dev;
+	struct ethhdr *eth = eth_hdr(pkt->skb);
+	struct flow_offload_tuple *tuple;
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
+
+	switch (eth_hdr(pkt->skb)->h_proto) {
+	case htons(ETH_P_8021Q): {
+		struct vlan_hdr *vhdr = (struct vlan_hdr *)(skb_mac_header(pkt->skb)
+					 + sizeof(struct ethhdr));
+		tuple->encap[i].id = ntohs(vhdr->h_vlan_TCI);
+		tuple->encap[i].proto = htons(ETH_P_8021Q);
+		i++;
+		break;
+	}
+	case htons(ETH_P_PPP_SES): {
+		struct pppoe_hdr *phdr = (struct pppoe_hdr *)(skb_mac_header(pkt->skb)
+					  + sizeof(struct ethhdr));
+
+		tuple->encap[i].id = ntohs(phdr->sid);
+		tuple->encap[i].proto = htons(ETH_P_PPP_SES);
+		i++;
+		break;
+	}
+	}
+	tuple->encap_num = i;
+
+	err = nft_dev_fill_bridge_path(flow, ft, !dir, out_dev, in_dev,
+				       eth->h_dest, eth->h_source);
+	if (err < 0)
+		return err;
+
+	err = nft_dev_fill_bridge_path(flow, ft, dir, in_dev, out_dev,
+				       eth->h_source, eth->h_dest);
+	if (err < 0)
+		return err;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(flow_offload_bridge_init);
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 0be62841155b6..d0d63ef7cecd5 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -53,6 +53,7 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 {
 	struct nft_flow_offload *priv = nft_expr_priv(expr);
 	struct nf_flowtable *flowtable = &priv->flowtable->data;
+	bool routing = flowtable->type->family != NFPROTO_BRIDGE;
 	struct tcphdr _tcph, *tcph = NULL;
 	struct nf_flow_route route = {};
 	enum ip_conntrack_info ctinfo;
@@ -109,14 +110,21 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
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
+		if (flow_offload_bridge_init(flow, pkt, dir, priv->flowtable) < 0)
+			goto err_flow_add;
+
 	if (tcph)
 		flow_offload_ct_tcp(ct);
 
@@ -164,8 +172,10 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
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
2.53.0

