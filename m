Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA823A0E8E;
	Sun, 14 Jun 2026 11:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781437588; cv=none; b=P+Lr3HSniQGtgQDvS+VhFgEVgUYHthBGA8P5Nm7eVcQHzqkEMihf6Ux6Kp62GozkT2RhKJuyJzpNI5XORjU3+CruJS2HlOdpKsXB1UnnKGmZs3cMjdeHRKKFsuoJcmwV8qRa0+ml3bI9tQrnw+toaE3gF/SFmB/kBrlIS1dMox8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781437588; c=relaxed/simple;
	bh=4ENf8zrMzCVgaFObuwl/5RRDqMct5Cf2wXOCM029SW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FCHPzQLKyXYLs8F/Yg+6MD5B4O87d7bwKOZ2N/ajPFaNid8QOwQ8LdmITfoZOo+X3I7R7X1auU1Q8VKOQsOdhFEXoPs0H15X7wsXY/khSs1BPjIhmSGdoPTaFsEXrhXPkRIeb7H4VXlN8LYqF/CMkPxY/eYTCGhUuH+20TZT9Ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=G5uNBD5m; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="G5uNBD5m"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id BFD766019B;
	Sun, 14 Jun 2026 13:46:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1781437583;
	bh=eO1JauI0r1V91b2fUny1kCr7ZKD8ei8hRKPRZSXrNTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G5uNBD5mpkmGOStSaNsJKmA4tqF9H+Ul4ojosoyKT+AUQk8E4kfXXWJ2j8FH08Sy0
	 11diWZ+y+3wBxq5Y6WKfZbbxUszTgE8cZPobCLoLQbPaNnfoxcr8gOuZo9mB1gqmM+
	 yR+GbBW4q+rb3oDfsQTcerGNkDU3es3ag6CFH9/yrf08urpC9rjulOk4SCzAD4EQJg
	 P5uZqwdCy3mnedTy4p+8oY4fbKYTuOwlnrXCIRkeiRCBdPXjagWlUhKD+kDs60fdp8
	 RqHy2fC6EMYrZath4eLQy8Azv4Z/tFwyor0tNX4iqQYDEwKDEAnwQsDFXYiPo5PKX/
	 pTzTQ3QOwwErw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 09/11] netfilter: flowtable: bail out if forward path cannot be discovered
Date: Sun, 14 Jun 2026 13:46:03 +0200
Message-ID: <20260614114605.474783-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260614114605.474783-1-pablo@netfilter.org>
References: <20260614114605.474783-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If forward path discovery fails for any reason or netdevice is not
registered for this flowtable, then bail out to classic forwarding path
rather than providing incomplete forwarding path.

Update the existing forward path parser functions to report an error
so the flow_offload expressions gives up on setting up the flowtable
entry.

Link: https://sashiko.dev/#/patchset/20260607094954.48892-15-pablo%40netfilter.org?part=14
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_path.c | 81 +++++++++++++++++-------------
 1 file changed, 46 insertions(+), 35 deletions(-)

diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
index a3e6b82f2f8e..1e7e216b9f89 100644
--- a/net/netfilter/nf_flow_table_path.c
+++ b/net/netfilter/nf_flow_table_path.c
@@ -90,9 +90,9 @@ struct nft_forward_info {
 	enum flow_offload_xmit_type xmit_type;
 };
 
-static void nft_dev_path_info(const struct net_device_path_stack *stack,
-			      struct nft_forward_info *info,
-			      unsigned char *ha, struct nf_flowtable *flowtable)
+static int nft_dev_path_info(const struct net_device_path_stack *stack,
+			     struct nft_forward_info *info,
+			     unsigned char *ha, struct nf_flowtable *flowtable)
 {
 	const struct net_device_path *path;
 	int i;
@@ -120,19 +120,17 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 
 			/* DEV_PATH_VLAN, DEV_PATH_PPPOE and DEV_PATH_TUN */
 			if (path->type == DEV_PATH_TUN) {
-				if (info->num_tuns) {
-					info->indev = NULL;
-					break;
-				}
+				if (info->num_tuns)
+					return -1;
+
 				info->tun.src_v6 = path->tun.src_v6;
 				info->tun.dst_v6 = path->tun.dst_v6;
 				info->tun.l3_proto = path->tun.l3_proto;
 				info->num_tuns++;
 			} else {
-				if (info->num_encaps >= NF_FLOW_TABLE_ENCAP_MAX) {
-					info->indev = NULL;
-					break;
-				}
+				if (info->num_encaps >= NF_FLOW_TABLE_ENCAP_MAX)
+					return -1;
+
 				info->encap[info->num_encaps].id =
 					path->encap.id;
 				info->encap[info->num_encaps].proto =
@@ -151,22 +149,23 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 
 			switch (path->bridge.vlan_mode) {
 			case DEV_PATH_BR_VLAN_UNTAG_HW:
+				if (info->num_encaps == 0)
+					return -1;
+
 				info->ingress_vlans |= BIT(info->num_encaps - 1);
 				break;
 			case DEV_PATH_BR_VLAN_TAG:
-				if (info->num_encaps >= NF_FLOW_TABLE_ENCAP_MAX) {
-					info->indev = NULL;
-					break;
-				}
+				if (info->num_encaps >= NF_FLOW_TABLE_ENCAP_MAX)
+					return -1;
+
 				info->encap[info->num_encaps].id = path->bridge.vlan_id;
 				info->encap[info->num_encaps].proto = path->bridge.vlan_proto;
 				info->num_encaps++;
 				break;
 			case DEV_PATH_BR_VLAN_UNTAG:
-				if (info->num_encaps == 0) {
-					info->indev = NULL;
-					break;
-				}
+				if (info->num_encaps == 0)
+					return -1;
+
 				info->num_encaps--;
 				break;
 			case DEV_PATH_BR_VLAN_KEEP:
@@ -175,8 +174,7 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 			info->xmit_type = FLOW_OFFLOAD_XMIT_DIRECT;
 			break;
 		default:
-			info->indev = NULL;
-			break;
+			return -1;
 		}
 	}
 	info->outdev = info->indev;
@@ -184,6 +182,8 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 	if (nf_flowtable_hw_offload(flowtable) &&
 	    nft_is_valid_ether_device(info->indev))
 		info->xmit_type = FLOW_OFFLOAD_XMIT_DIRECT;
+
+	return 0;
 }
 
 static bool nft_flowtable_find_dev(const struct net_device *dev,
@@ -241,11 +241,11 @@ static int nft_flow_tunnel_update_route(const struct nft_pktinfo *pkt,
 	return 0;
 }
 
-static void nft_dev_forward_path(const struct nft_pktinfo *pkt,
-				 struct nf_flow_route *route,
-				 const struct nf_conn *ct,
-				 enum ip_conntrack_dir dir,
-				 struct nft_flowtable *ft)
+static int nft_dev_forward_path(const struct nft_pktinfo *pkt,
+				struct nf_flow_route *route,
+				const struct nf_conn *ct,
+				enum ip_conntrack_dir dir,
+				struct nft_flowtable *ft)
 {
 	const struct dst_entry *dst = route->tuple[dir].dst;
 	struct net_device_path_stack stack;
@@ -253,15 +253,16 @@ static void nft_dev_forward_path(const struct nft_pktinfo *pkt,
 	unsigned char ha[ETH_ALEN];
 	int i;
 
-	if (nft_dev_fill_forward_path(route, dst, ct, dir, ha, &stack) >= 0)
-		nft_dev_path_info(&stack, &info, ha, &ft->data);
+	if (nft_dev_fill_forward_path(route, dst, ct, dir, ha, &stack) < 0 ||
+	    nft_dev_path_info(&stack, &info, ha, &ft->data) < 0)
+		return -ENOENT;
+
+	if (!nft_flowtable_find_dev(info.indev, ft))
+		return -ENOENT;
 
 	if (info.outdev)
 		route->tuple[dir].out.ifindex = info.outdev->ifindex;
 
-	if (!info.indev || !nft_flowtable_find_dev(info.indev, ft))
-		return;
-
 	route->tuple[!dir].in.ifindex = info.indev->ifindex;
 	for (i = 0; i < info.num_encaps; i++) {
 		route->tuple[!dir].in.encap[i].id = info.encap[i].id;
@@ -285,6 +286,8 @@ static void nft_dev_forward_path(const struct nft_pktinfo *pkt,
 		route->tuple[dir].xmit_type = info.xmit_type;
 	}
 	route->tuple[dir].out.needs_gso_segment = info.needs_gso_segment;
+
+	return 0;
 }
 
 int nft_flow_route(const struct nft_pktinfo *pkt, const struct nf_conn *ct,
@@ -329,11 +332,19 @@ int nft_flow_route(const struct nft_pktinfo *pkt, const struct nf_conn *ct,
 	nft_default_forward_path(route, this_dst, dir);
 	nft_default_forward_path(route, other_dst, !dir);
 
-	if (route->tuple[dir].xmit_type	== FLOW_OFFLOAD_XMIT_NEIGH)
-		nft_dev_forward_path(pkt, route, ct, dir, ft);
-	if (route->tuple[!dir].xmit_type == FLOW_OFFLOAD_XMIT_NEIGH)
-		nft_dev_forward_path(pkt, route, ct, !dir, ft);
+	if (route->tuple[dir].xmit_type	== FLOW_OFFLOAD_XMIT_NEIGH &&
+	    nft_dev_forward_path(pkt, route, ct, dir, ft) < 0)
+		goto err_dst_release;
+
+	if (route->tuple[!dir].xmit_type == FLOW_OFFLOAD_XMIT_NEIGH &&
+	    nft_dev_forward_path(pkt, route, ct, !dir, ft) < 0)
+		goto err_dst_release;
 
 	return 0;
+
+err_dst_release:
+	dst_release(route->tuple[dir].dst);
+	dst_release(route->tuple[!dir].dst);
+	return -ENOENT;
 }
 EXPORT_SYMBOL_GPL(nft_flow_route);
-- 
2.47.3

