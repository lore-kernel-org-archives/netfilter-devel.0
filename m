Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644C2340DBD;
	Wed, 26 Nov 2025 20:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764190586; cv=none; b=M+qQeFWu0cC5CLlZT6Twcfj8txuwBmEJYzQK5tbExsF8/CjdRnGGJQcMXOW7NvlLgYzwD7GX78i0YTQZM4VDjSzEIIWc8ezr17G/NgfVaOO8G6NZFhQBdMac7Kf4P29F5yh3IViky7XtroXmMzYlkV5E75FMyBxepGm4JfIUas4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764190586; c=relaxed/simple;
	bh=piqlPIY7uHH7s/b7jkJ5nrQv8nrpdVtN5mXf70/ns8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I9n4gh8GpnEf3aV46vl8pZKi1O46SibV82vSaO++kk/aD+lCMKiF9OiRSHCTiklkj5HGiHvUJXF94KNqtOxqQ8RmDpI9yj7tgWrhwSa1Hj3G1G7Y3+X8IRwt0LUVVKNksv7vJg1y3750Mifk3auDKGrGbypzKkyR64yjJ0hkOo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=uKJxef2r; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="uKJxef2r"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 34ECE60272;
	Wed, 26 Nov 2025 21:56:20 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1764190580;
	bh=EEsNT/pgjEhmDM3MkuBuSbDVtCLDPL0AMzwfDJOpTNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uKJxef2rmQKLtoGuc4we4QjfXATcIeJ8RnY1+PsUVVMKGqn+43asiqUpgHlb6QBIO
	 XOzWDewflWw2NTP2QT+fui7rjPe/tVGht/lLZEFbv50rHt+ZfFuvmLiDURchXTXnXX
	 PyC0JjHzxn6ngxhWU5UxXY4V2hmG0LAn6BV4GMsB0DwFOFrL6HS762BR2C9ACbUfIa
	 mxcE809N0wPP8gNnVvCVOQcif5ZU8sGhgYbGlU9M9v3P3yX9S5bof6MnS22HVxZP+T
	 dn8EOSqqUSZZHN88yELZWchInp/SPg4qI4jkUu8a7i6yWH0dg+kGs25T5rykDXs1v/
	 r2DHtAZWoBygw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 01/16] netfilter: flowtable: move path discovery infrastructure to its own file
Date: Wed, 26 Nov 2025 20:55:56 +0000
Message-ID: <20251126205611.1284486-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251126205611.1284486-1-pablo@netfilter.org>
References: <20251126205611.1284486-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This file contains the path discovery that is run from the forward chain
for the packet offloading the flow into the flowtable. This consists
of a series of calls to dev_fill_forward_path() for each device stack.

More topologies may be supported in the future, so move this code to its
own file to separate it from the nftables flow_offload expression.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_flow_table.h |   6 +
 net/netfilter/Makefile                |   1 +
 net/netfilter/nf_flow_table_path.c    | 267 ++++++++++++++++++++++++++
 net/netfilter/nft_flow_offload.c      | 252 ------------------------
 4 files changed, 274 insertions(+), 252 deletions(-)
 create mode 100644 net/netfilter/nf_flow_table_path.c

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index c003cd194fa2..e9f72d2558e9 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -222,6 +222,12 @@ struct nf_flow_route {
 struct flow_offload *flow_offload_alloc(struct nf_conn *ct);
 void flow_offload_free(struct flow_offload *flow);
 
+struct nft_flowtable;
+struct nft_pktinfo;
+int nft_flow_route(const struct nft_pktinfo *pkt, const struct nf_conn *ct,
+		   struct nf_flow_route *route, enum ip_conntrack_dir dir,
+		   struct nft_flowtable *ft);
+
 static inline int
 nf_flow_table_offload_add_cb(struct nf_flowtable *flow_table,
 			     flow_setup_cb_t *cb, void *cb_priv)
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index e43e20f529f8..6bfc250e474f 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -141,6 +141,7 @@ obj-$(CONFIG_NFT_FWD_NETDEV)	+= nft_fwd_netdev.o
 # flow table infrastructure
 obj-$(CONFIG_NF_FLOW_TABLE)	+= nf_flow_table.o
 nf_flow_table-objs		:= nf_flow_table_core.o nf_flow_table_ip.o \
+				   nf_flow_table_path.o \
 				   nf_flow_table_offload.o nf_flow_table_xdp.o
 nf_flow_table-$(CONFIG_NF_FLOW_TABLE_PROCFS) += nf_flow_table_procfs.o
 ifeq ($(CONFIG_NF_FLOW_TABLE),m)
diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
new file mode 100644
index 000000000000..159aa5c8da60
--- /dev/null
+++ b/net/netfilter/nf_flow_table_path.c
@@ -0,0 +1,267 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/netlink.h>
+#include <linux/netfilter.h>
+#include <linux/spinlock.h>
+#include <linux/netfilter/nf_conntrack_common.h>
+#include <linux/netfilter/nf_tables.h>
+#include <net/ip.h>
+#include <net/inet_dscp.h>
+#include <net/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables_core.h>
+#include <net/netfilter/nf_conntrack_core.h>
+#include <net/netfilter/nf_conntrack_extend.h>
+#include <net/netfilter/nf_flow_table.h>
+
+static enum flow_offload_xmit_type nft_xmit_type(struct dst_entry *dst)
+{
+	if (dst_xfrm(dst))
+		return FLOW_OFFLOAD_XMIT_XFRM;
+
+	return FLOW_OFFLOAD_XMIT_NEIGH;
+}
+
+static void nft_default_forward_path(struct nf_flow_route *route,
+				     struct dst_entry *dst_cache,
+				     enum ip_conntrack_dir dir)
+{
+	route->tuple[!dir].in.ifindex	= dst_cache->dev->ifindex;
+	route->tuple[dir].dst		= dst_cache;
+	route->tuple[dir].xmit_type	= nft_xmit_type(dst_cache);
+}
+
+static bool nft_is_valid_ether_device(const struct net_device *dev)
+{
+	if (!dev || (dev->flags & IFF_LOOPBACK) || dev->type != ARPHRD_ETHER ||
+	    dev->addr_len != ETH_ALEN || !is_valid_ether_addr(dev->dev_addr))
+		return false;
+
+	return true;
+}
+
+static int nft_dev_fill_forward_path(const struct nf_flow_route *route,
+				     const struct dst_entry *dst_cache,
+				     const struct nf_conn *ct,
+				     enum ip_conntrack_dir dir, u8 *ha,
+				     struct net_device_path_stack *stack)
+{
+	const void *daddr = &ct->tuplehash[!dir].tuple.src.u3;
+	struct net_device *dev = dst_cache->dev;
+	struct neighbour *n;
+	u8 nud_state;
+
+	if (!nft_is_valid_ether_device(dev))
+		goto out;
+
+	n = dst_neigh_lookup(dst_cache, daddr);
+	if (!n)
+		return -1;
+
+	read_lock_bh(&n->lock);
+	nud_state = n->nud_state;
+	ether_addr_copy(ha, n->ha);
+	read_unlock_bh(&n->lock);
+	neigh_release(n);
+
+	if (!(nud_state & NUD_VALID))
+		return -1;
+
+out:
+	return dev_fill_forward_path(dev, ha, stack);
+}
+
+struct nft_forward_info {
+	const struct net_device *indev;
+	const struct net_device *outdev;
+	const struct net_device *hw_outdev;
+	struct id {
+		__u16	id;
+		__be16	proto;
+	} encap[NF_FLOW_TABLE_ENCAP_MAX];
+	u8 num_encaps;
+	u8 ingress_vlans;
+	u8 h_source[ETH_ALEN];
+	u8 h_dest[ETH_ALEN];
+	enum flow_offload_xmit_type xmit_type;
+};
+
+static void nft_dev_path_info(const struct net_device_path_stack *stack,
+			      struct nft_forward_info *info,
+			      unsigned char *ha, struct nf_flowtable *flowtable)
+{
+	const struct net_device_path *path;
+	int i;
+
+	memcpy(info->h_dest, ha, ETH_ALEN);
+
+	for (i = 0; i < stack->num_paths; i++) {
+		path = &stack->path[i];
+		switch (path->type) {
+		case DEV_PATH_ETHERNET:
+		case DEV_PATH_DSA:
+		case DEV_PATH_VLAN:
+		case DEV_PATH_PPPOE:
+			info->indev = path->dev;
+			if (is_zero_ether_addr(info->h_source))
+				memcpy(info->h_source, path->dev->dev_addr, ETH_ALEN);
+
+			if (path->type == DEV_PATH_ETHERNET)
+				break;
+			if (path->type == DEV_PATH_DSA) {
+				i = stack->num_paths;
+				break;
+			}
+
+			/* DEV_PATH_VLAN and DEV_PATH_PPPOE */
+			if (info->num_encaps >= NF_FLOW_TABLE_ENCAP_MAX) {
+				info->indev = NULL;
+				break;
+			}
+			if (!info->outdev)
+				info->outdev = path->dev;
+			info->encap[info->num_encaps].id = path->encap.id;
+			info->encap[info->num_encaps].proto = path->encap.proto;
+			info->num_encaps++;
+			if (path->type == DEV_PATH_PPPOE)
+				memcpy(info->h_dest, path->encap.h_dest, ETH_ALEN);
+			break;
+		case DEV_PATH_BRIDGE:
+			if (is_zero_ether_addr(info->h_source))
+				memcpy(info->h_source, path->dev->dev_addr, ETH_ALEN);
+
+			switch (path->bridge.vlan_mode) {
+			case DEV_PATH_BR_VLAN_UNTAG_HW:
+				info->ingress_vlans |= BIT(info->num_encaps - 1);
+				break;
+			case DEV_PATH_BR_VLAN_TAG:
+				info->encap[info->num_encaps].id = path->bridge.vlan_id;
+				info->encap[info->num_encaps].proto = path->bridge.vlan_proto;
+				info->num_encaps++;
+				break;
+			case DEV_PATH_BR_VLAN_UNTAG:
+				info->num_encaps--;
+				break;
+			case DEV_PATH_BR_VLAN_KEEP:
+				break;
+			}
+			info->xmit_type = FLOW_OFFLOAD_XMIT_DIRECT;
+			break;
+		default:
+			info->indev = NULL;
+			break;
+		}
+	}
+	if (!info->outdev)
+		info->outdev = info->indev;
+
+	info->hw_outdev = info->indev;
+
+	if (nf_flowtable_hw_offload(flowtable) &&
+	    nft_is_valid_ether_device(info->indev))
+		info->xmit_type = FLOW_OFFLOAD_XMIT_DIRECT;
+}
+
+static bool nft_flowtable_find_dev(const struct net_device *dev,
+				   struct nft_flowtable *ft)
+{
+	struct nft_hook *hook;
+	bool found = false;
+
+	list_for_each_entry_rcu(hook, &ft->hook_list, list) {
+		if (!nft_hook_find_ops_rcu(hook, dev))
+			continue;
+
+		found = true;
+		break;
+	}
+
+	return found;
+}
+
+static void nft_dev_forward_path(struct nf_flow_route *route,
+				 const struct nf_conn *ct,
+				 enum ip_conntrack_dir dir,
+				 struct nft_flowtable *ft)
+{
+	const struct dst_entry *dst = route->tuple[dir].dst;
+	struct net_device_path_stack stack;
+	struct nft_forward_info info = {};
+	unsigned char ha[ETH_ALEN];
+	int i;
+
+	if (nft_dev_fill_forward_path(route, dst, ct, dir, ha, &stack) >= 0)
+		nft_dev_path_info(&stack, &info, ha, &ft->data);
+
+	if (!info.indev || !nft_flowtable_find_dev(info.indev, ft))
+		return;
+
+	route->tuple[!dir].in.ifindex = info.indev->ifindex;
+	for (i = 0; i < info.num_encaps; i++) {
+		route->tuple[!dir].in.encap[i].id = info.encap[i].id;
+		route->tuple[!dir].in.encap[i].proto = info.encap[i].proto;
+	}
+	route->tuple[!dir].in.num_encaps = info.num_encaps;
+	route->tuple[!dir].in.ingress_vlans = info.ingress_vlans;
+
+	if (info.xmit_type == FLOW_OFFLOAD_XMIT_DIRECT) {
+		memcpy(route->tuple[dir].out.h_source, info.h_source, ETH_ALEN);
+		memcpy(route->tuple[dir].out.h_dest, info.h_dest, ETH_ALEN);
+		route->tuple[dir].out.ifindex = info.outdev->ifindex;
+		route->tuple[dir].out.hw_ifindex = info.hw_outdev->ifindex;
+		route->tuple[dir].xmit_type = info.xmit_type;
+	}
+}
+
+int nft_flow_route(const struct nft_pktinfo *pkt, const struct nf_conn *ct,
+		   struct nf_flow_route *route, enum ip_conntrack_dir dir,
+		   struct nft_flowtable *ft)
+{
+	struct dst_entry *this_dst = skb_dst(pkt->skb);
+	struct dst_entry *other_dst = NULL;
+	struct flowi fl;
+
+	memset(&fl, 0, sizeof(fl));
+	switch (nft_pf(pkt)) {
+	case NFPROTO_IPV4:
+		fl.u.ip4.daddr = ct->tuplehash[dir].tuple.src.u3.ip;
+		fl.u.ip4.saddr = ct->tuplehash[!dir].tuple.src.u3.ip;
+		fl.u.ip4.flowi4_oif = nft_in(pkt)->ifindex;
+		fl.u.ip4.flowi4_iif = this_dst->dev->ifindex;
+		fl.u.ip4.flowi4_dscp = ip4h_dscp(ip_hdr(pkt->skb));
+		fl.u.ip4.flowi4_mark = pkt->skb->mark;
+		fl.u.ip4.flowi4_flags = FLOWI_FLAG_ANYSRC;
+		break;
+	case NFPROTO_IPV6:
+		fl.u.ip6.daddr = ct->tuplehash[dir].tuple.src.u3.in6;
+		fl.u.ip6.saddr = ct->tuplehash[!dir].tuple.src.u3.in6;
+		fl.u.ip6.flowi6_oif = nft_in(pkt)->ifindex;
+		fl.u.ip6.flowi6_iif = this_dst->dev->ifindex;
+		fl.u.ip6.flowlabel = ip6_flowinfo(ipv6_hdr(pkt->skb));
+		fl.u.ip6.flowi6_mark = pkt->skb->mark;
+		fl.u.ip6.flowi6_flags = FLOWI_FLAG_ANYSRC;
+		break;
+	}
+
+	if (!dst_hold_safe(this_dst))
+		return -ENOENT;
+
+	nf_route(nft_net(pkt), &other_dst, &fl, false, nft_pf(pkt));
+	if (!other_dst) {
+		dst_release(this_dst);
+		return -ENOENT;
+	}
+
+	nft_default_forward_path(route, this_dst, dir);
+	nft_default_forward_path(route, other_dst, !dir);
+
+	if (route->tuple[dir].xmit_type	== FLOW_OFFLOAD_XMIT_NEIGH &&
+	    route->tuple[!dir].xmit_type == FLOW_OFFLOAD_XMIT_NEIGH) {
+		nft_dev_forward_path(route, ct, dir, ft);
+		nft_dev_forward_path(route, ct, !dir, ft);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(nft_flow_route);
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 14dd1c0698c3..b8f76c9057fd 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -20,258 +20,6 @@ struct nft_flow_offload {
 	struct nft_flowtable	*flowtable;
 };
 
-static enum flow_offload_xmit_type nft_xmit_type(struct dst_entry *dst)
-{
-	if (dst_xfrm(dst))
-		return FLOW_OFFLOAD_XMIT_XFRM;
-
-	return FLOW_OFFLOAD_XMIT_NEIGH;
-}
-
-static void nft_default_forward_path(struct nf_flow_route *route,
-				     struct dst_entry *dst_cache,
-				     enum ip_conntrack_dir dir)
-{
-	route->tuple[!dir].in.ifindex	= dst_cache->dev->ifindex;
-	route->tuple[dir].dst		= dst_cache;
-	route->tuple[dir].xmit_type	= nft_xmit_type(dst_cache);
-}
-
-static bool nft_is_valid_ether_device(const struct net_device *dev)
-{
-	if (!dev || (dev->flags & IFF_LOOPBACK) || dev->type != ARPHRD_ETHER ||
-	    dev->addr_len != ETH_ALEN || !is_valid_ether_addr(dev->dev_addr))
-		return false;
-
-	return true;
-}
-
-static int nft_dev_fill_forward_path(const struct nf_flow_route *route,
-				     const struct dst_entry *dst_cache,
-				     const struct nf_conn *ct,
-				     enum ip_conntrack_dir dir, u8 *ha,
-				     struct net_device_path_stack *stack)
-{
-	const void *daddr = &ct->tuplehash[!dir].tuple.src.u3;
-	struct net_device *dev = dst_cache->dev;
-	struct neighbour *n;
-	u8 nud_state;
-
-	if (!nft_is_valid_ether_device(dev))
-		goto out;
-
-	n = dst_neigh_lookup(dst_cache, daddr);
-	if (!n)
-		return -1;
-
-	read_lock_bh(&n->lock);
-	nud_state = n->nud_state;
-	ether_addr_copy(ha, n->ha);
-	read_unlock_bh(&n->lock);
-	neigh_release(n);
-
-	if (!(nud_state & NUD_VALID))
-		return -1;
-
-out:
-	return dev_fill_forward_path(dev, ha, stack);
-}
-
-struct nft_forward_info {
-	const struct net_device *indev;
-	const struct net_device *outdev;
-	const struct net_device *hw_outdev;
-	struct id {
-		__u16	id;
-		__be16	proto;
-	} encap[NF_FLOW_TABLE_ENCAP_MAX];
-	u8 num_encaps;
-	u8 ingress_vlans;
-	u8 h_source[ETH_ALEN];
-	u8 h_dest[ETH_ALEN];
-	enum flow_offload_xmit_type xmit_type;
-};
-
-static void nft_dev_path_info(const struct net_device_path_stack *stack,
-			      struct nft_forward_info *info,
-			      unsigned char *ha, struct nf_flowtable *flowtable)
-{
-	const struct net_device_path *path;
-	int i;
-
-	memcpy(info->h_dest, ha, ETH_ALEN);
-
-	for (i = 0; i < stack->num_paths; i++) {
-		path = &stack->path[i];
-		switch (path->type) {
-		case DEV_PATH_ETHERNET:
-		case DEV_PATH_DSA:
-		case DEV_PATH_VLAN:
-		case DEV_PATH_PPPOE:
-			info->indev = path->dev;
-			if (is_zero_ether_addr(info->h_source))
-				memcpy(info->h_source, path->dev->dev_addr, ETH_ALEN);
-
-			if (path->type == DEV_PATH_ETHERNET)
-				break;
-			if (path->type == DEV_PATH_DSA) {
-				i = stack->num_paths;
-				break;
-			}
-
-			/* DEV_PATH_VLAN and DEV_PATH_PPPOE */
-			if (info->num_encaps >= NF_FLOW_TABLE_ENCAP_MAX) {
-				info->indev = NULL;
-				break;
-			}
-			if (!info->outdev)
-				info->outdev = path->dev;
-			info->encap[info->num_encaps].id = path->encap.id;
-			info->encap[info->num_encaps].proto = path->encap.proto;
-			info->num_encaps++;
-			if (path->type == DEV_PATH_PPPOE)
-				memcpy(info->h_dest, path->encap.h_dest, ETH_ALEN);
-			break;
-		case DEV_PATH_BRIDGE:
-			if (is_zero_ether_addr(info->h_source))
-				memcpy(info->h_source, path->dev->dev_addr, ETH_ALEN);
-
-			switch (path->bridge.vlan_mode) {
-			case DEV_PATH_BR_VLAN_UNTAG_HW:
-				info->ingress_vlans |= BIT(info->num_encaps - 1);
-				break;
-			case DEV_PATH_BR_VLAN_TAG:
-				info->encap[info->num_encaps].id = path->bridge.vlan_id;
-				info->encap[info->num_encaps].proto = path->bridge.vlan_proto;
-				info->num_encaps++;
-				break;
-			case DEV_PATH_BR_VLAN_UNTAG:
-				info->num_encaps--;
-				break;
-			case DEV_PATH_BR_VLAN_KEEP:
-				break;
-			}
-			info->xmit_type = FLOW_OFFLOAD_XMIT_DIRECT;
-			break;
-		default:
-			info->indev = NULL;
-			break;
-		}
-	}
-	if (!info->outdev)
-		info->outdev = info->indev;
-
-	info->hw_outdev = info->indev;
-
-	if (nf_flowtable_hw_offload(flowtable) &&
-	    nft_is_valid_ether_device(info->indev))
-		info->xmit_type = FLOW_OFFLOAD_XMIT_DIRECT;
-}
-
-static bool nft_flowtable_find_dev(const struct net_device *dev,
-				   struct nft_flowtable *ft)
-{
-	struct nft_hook *hook;
-	bool found = false;
-
-	list_for_each_entry_rcu(hook, &ft->hook_list, list) {
-		if (!nft_hook_find_ops_rcu(hook, dev))
-			continue;
-
-		found = true;
-		break;
-	}
-
-	return found;
-}
-
-static void nft_dev_forward_path(struct nf_flow_route *route,
-				 const struct nf_conn *ct,
-				 enum ip_conntrack_dir dir,
-				 struct nft_flowtable *ft)
-{
-	const struct dst_entry *dst = route->tuple[dir].dst;
-	struct net_device_path_stack stack;
-	struct nft_forward_info info = {};
-	unsigned char ha[ETH_ALEN];
-	int i;
-
-	if (nft_dev_fill_forward_path(route, dst, ct, dir, ha, &stack) >= 0)
-		nft_dev_path_info(&stack, &info, ha, &ft->data);
-
-	if (!info.indev || !nft_flowtable_find_dev(info.indev, ft))
-		return;
-
-	route->tuple[!dir].in.ifindex = info.indev->ifindex;
-	for (i = 0; i < info.num_encaps; i++) {
-		route->tuple[!dir].in.encap[i].id = info.encap[i].id;
-		route->tuple[!dir].in.encap[i].proto = info.encap[i].proto;
-	}
-	route->tuple[!dir].in.num_encaps = info.num_encaps;
-	route->tuple[!dir].in.ingress_vlans = info.ingress_vlans;
-
-	if (info.xmit_type == FLOW_OFFLOAD_XMIT_DIRECT) {
-		memcpy(route->tuple[dir].out.h_source, info.h_source, ETH_ALEN);
-		memcpy(route->tuple[dir].out.h_dest, info.h_dest, ETH_ALEN);
-		route->tuple[dir].out.ifindex = info.outdev->ifindex;
-		route->tuple[dir].out.hw_ifindex = info.hw_outdev->ifindex;
-		route->tuple[dir].xmit_type = info.xmit_type;
-	}
-}
-
-static int nft_flow_route(const struct nft_pktinfo *pkt,
-			  const struct nf_conn *ct,
-			  struct nf_flow_route *route,
-			  enum ip_conntrack_dir dir,
-			  struct nft_flowtable *ft)
-{
-	struct dst_entry *this_dst = skb_dst(pkt->skb);
-	struct dst_entry *other_dst = NULL;
-	struct flowi fl;
-
-	memset(&fl, 0, sizeof(fl));
-	switch (nft_pf(pkt)) {
-	case NFPROTO_IPV4:
-		fl.u.ip4.daddr = ct->tuplehash[dir].tuple.src.u3.ip;
-		fl.u.ip4.saddr = ct->tuplehash[!dir].tuple.src.u3.ip;
-		fl.u.ip4.flowi4_oif = nft_in(pkt)->ifindex;
-		fl.u.ip4.flowi4_iif = this_dst->dev->ifindex;
-		fl.u.ip4.flowi4_dscp = ip4h_dscp(ip_hdr(pkt->skb));
-		fl.u.ip4.flowi4_mark = pkt->skb->mark;
-		fl.u.ip4.flowi4_flags = FLOWI_FLAG_ANYSRC;
-		break;
-	case NFPROTO_IPV6:
-		fl.u.ip6.daddr = ct->tuplehash[dir].tuple.src.u3.in6;
-		fl.u.ip6.saddr = ct->tuplehash[!dir].tuple.src.u3.in6;
-		fl.u.ip6.flowi6_oif = nft_in(pkt)->ifindex;
-		fl.u.ip6.flowi6_iif = this_dst->dev->ifindex;
-		fl.u.ip6.flowlabel = ip6_flowinfo(ipv6_hdr(pkt->skb));
-		fl.u.ip6.flowi6_mark = pkt->skb->mark;
-		fl.u.ip6.flowi6_flags = FLOWI_FLAG_ANYSRC;
-		break;
-	}
-
-	if (!dst_hold_safe(this_dst))
-		return -ENOENT;
-
-	nf_route(nft_net(pkt), &other_dst, &fl, false, nft_pf(pkt));
-	if (!other_dst) {
-		dst_release(this_dst);
-		return -ENOENT;
-	}
-
-	nft_default_forward_path(route, this_dst, dir);
-	nft_default_forward_path(route, other_dst, !dir);
-
-	if (route->tuple[dir].xmit_type	== FLOW_OFFLOAD_XMIT_NEIGH &&
-	    route->tuple[!dir].xmit_type == FLOW_OFFLOAD_XMIT_NEIGH) {
-		nft_dev_forward_path(route, ct, dir, ft);
-		nft_dev_forward_path(route, ct, !dir, ft);
-	}
-
-	return 0;
-}
-
 static bool nft_flow_offload_skip(struct sk_buff *skb, int family)
 {
 	if (skb_sec_path(skb))
-- 
2.47.3

