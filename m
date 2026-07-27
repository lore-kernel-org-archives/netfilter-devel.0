Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A513BB4A
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Jul 2026 11:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785153590; cv=none; b=FHRAANs2GvUXHrFMdAXGqv8lilKy5LCX//a+R43YuiwNenI2pUGdt+hcPmgojpu62VUcxK8SZGtVb9MSMtgiLBrFDyMh55aelwVSpjOUR0ZT/osc/0ubRria8sHOMjuAbQEH42mFdGBS/SR118uPjIQp0r3fT9X315RxwnDbJsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785153590; c=relaxed/simple;
	bh=EZFyakdOzYZGwNbORmZfuzlRjcULcHvrK/Np5jLrwvo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Pggd1QoJMdOMq7JPeW+/ea0XL1lnUVcb9SQGRSRXwSzidsSgbvHs1HK6jjzFfQz5x9Tf/g+HLFXnAUVN90YWjgfVB1r7YUAlBVMEKpaaqx9U3mjtbnIF3adAix5IXow40NYbZBXfNEriOsR59k/gPs8Ded6yXdvFsRBpa353Xg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=gziuCYGe; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="gziuCYGe"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id CCF486019B;
	Mon, 27 Jul 2026 13:59:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785153579;
	bh=PV5jbIkVN8CjxWN+Msjiuc5RjVI82Kap6tMduC6IiwY=;
	h=From:To:Cc:Subject:Date:From;
	b=gziuCYGeHESSzvoN3y5fyrpG0BQgbN4yHIySSCkawt59oPL59N+K7bKVrnv6FnIsj
	 o0RT0JvtlCzskcE+5vedc4o1upZvjT2ffiPSKmVjZyZ6cT0zxJPSF6l5Cx1fz2wfYr
	 EEwHww+E4w1ScLruvFGwJqFDz4xF9ZAW7saVIHlUJzlyx2iYvJ9x9xT9SHm/xWUYxy
	 Si2gqk3booqOaaBTQKjOGIcrJOc087SLHUtMlQwHCXluyMwzDsYJKxx1JuY+rfgsv4
	 OUMcqmLKdhWTu2Ntx6DshM8C3M7GVc4a4tixLRbCb9XK8OmO7u+HuJTsn7D7LILTqN
	 VfIB/uyPaO4sQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: lorenzo@kernel.org
Subject: [PATCH nf-next,v2 1/5] netfilter: flowtable: consolidate net_device field in nft_forward_info struct
Date: Mon, 27 Jul 2026 13:59:28 +0200
Message-ID: <20260727115932.88335-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

info->indev and info->outdev refer to the same device, a single
info->dev field is sufficient.

While at it, remove unused router parameter from the flowtable path
discovery function.

Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: no changes

 net/netfilter/nf_flow_table_path.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
index 98c03b487f52..261bb44d08eb 100644
--- a/net/netfilter/nf_flow_table_path.c
+++ b/net/netfilter/nf_flow_table_path.c
@@ -42,8 +42,7 @@ static bool nft_is_valid_ether_device(const struct net_device *dev)
 	return true;
 }
 
-static int nft_dev_fill_forward_path(const struct nf_flow_route *route,
-				     const struct dst_entry *dst_cache,
+static int nft_dev_fill_forward_path(const struct dst_entry *dst_cache,
 				     const struct nf_conn *ct,
 				     enum ip_conntrack_dir dir, u8 *ha,
 				     struct net_device_path_stack *stack)
@@ -76,8 +75,7 @@ static int nft_dev_fill_forward_path(const struct nf_flow_route *route,
 }
 
 struct nft_forward_info {
-	const struct net_device *indev;
-	const struct net_device *outdev;
+	const struct net_device *dev;
 	struct id {
 		__u16	id;
 		__be16	proto;
@@ -109,7 +107,7 @@ static int nft_dev_path_info(const struct net_device_path_stack *stack,
 		case DEV_PATH_VLAN:
 		case DEV_PATH_PPPOE:
 		case DEV_PATH_TUN:
-			info->indev = path->dev;
+			info->dev = path->dev;
 			if (is_zero_ether_addr(info->h_source))
 				memcpy(info->h_source, path->dev->dev_addr, ETH_ALEN);
 
@@ -179,10 +177,9 @@ static int nft_dev_path_info(const struct net_device_path_stack *stack,
 			return -1;
 		}
 	}
-	info->outdev = info->indev;
 
 	if (nf_flowtable_hw_offload(flowtable) &&
-	    nft_is_valid_ether_device(info->indev))
+	    nft_is_valid_ether_device(info->dev))
 		info->xmit_type = FLOW_OFFLOAD_XMIT_DIRECT;
 
 	return 0;
@@ -255,17 +252,16 @@ static int nft_dev_forward_path(const struct nft_pktinfo *pkt,
 	unsigned char ha[ETH_ALEN];
 	int i;
 
-	if (nft_dev_fill_forward_path(route, dst, ct, dir, ha, &stack) < 0 ||
+	if (nft_dev_fill_forward_path(dst, ct, dir, ha, &stack) < 0 ||
 	    nft_dev_path_info(&stack, &info, ha, &ft->data) < 0)
 		return -ENOENT;
 
-	if (!nft_flowtable_find_dev(info.indev, ft))
+	if (!nft_flowtable_find_dev(info.dev, ft))
 		return -ENOENT;
 
-	if (info.outdev)
-		route->tuple[dir].out.ifindex = info.outdev->ifindex;
+	route->tuple[!dir].in.ifindex = info.dev->ifindex;
+	route->tuple[dir].out.ifindex = info.dev->ifindex;
 
-	route->tuple[!dir].in.ifindex = info.indev->ifindex;
 	for (i = 0; i < info.num_encaps; i++) {
 		route->tuple[!dir].in.encap[i].id = info.encap[i].id;
 		route->tuple[!dir].in.encap[i].proto = info.encap[i].proto;
-- 
2.47.3

