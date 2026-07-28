Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B63275AFD
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Jul 2026 11:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785236993; cv=none; b=m3B35JCokuIlwdnHVPF3zmdkcmMINIcLZVo05TvHyNmG5lkwBnRyVRpsgn9Czm2YURNgcy3JFwzgf6fEawBzweYtVC1G8IgibF5ToQrofR625JErNrxQD+lT+tOjNEuVWAHNHa6JbDv44kGzK3p3DgE+5PEjTWOk3TkQReiTHTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785236993; c=relaxed/simple;
	bh=M+dZqu2segsh0pODJi6p8V+OvHZVFM2lacllO6VNokk=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=lPZeRjnfe/pIP9WYuvicJDp6sWfbaASpxVoCKmMSWTmcmNbG8yRFzX6PKuSXejScQVPj2MjhMspycrIPy8Bd9B5N6awre1ZpciZktdu6XrjXuq/QH8y2lkmoonpR8aflTOcGJUVa3H0zniEvPCp6oi79AakckMsVRiJbvxKzvtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=eYEpEW+O; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="eYEpEW+O"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A36C660194
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Jul 2026 13:09:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785236988;
	bh=kVJGiz9aDak7ZS4YwOiry1tDCQxlv5qXw31s9BBH38g=;
	h=From:To:Subject:Date:From;
	b=eYEpEW+OXe16hQ8Kz7fXTxmUvse7dxGR5d0lyxZoX5jasX5cl9wwmXqMFJE0EiZa/
	 2psczatnzf64B91aU+Hc9oCnD3Ea2YRpu+Zc/hklc8Inbpo6f30w3akoUbBKON48UR
	 UIQYZo7S24NZ+NX78VyuNEjzQSAhFoZrOAbTz4hPw5gE43t9vWJ1PNDUgnN7NYPwZ3
	 nbiAjUg0z79BnwUUCkYzd+FdX+jvUCr/rq5VfA2EFKJZcqdMf0aGEIAepdqew8hq1G
	 RK6Ixi70sVhEsVL0hWKva4zYctyq+CzZM2TmWua9QRh3Rx63XBXZH6RlVPkY+wej/p
	 SZa6VtmWuL/rA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v3 1/5] netfilter: flowtable: consolidate net_device field in nft_forward_info struct
Date: Tue, 28 Jul 2026 13:09:38 +0200
Message-ID: <20260728110943.124900-1-pablo@netfilter.org>
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
v3: no changes

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

