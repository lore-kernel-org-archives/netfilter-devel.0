Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D9002EFD91;
	Tue, 25 Nov 2025 22:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764110011; cv=none; b=j9wRdOUvd6vNYncdCcpE1StTijEpmizc2xGweTGbwHkUQJnuBb4I8rWamEp40U7PzDdgSP8CsLEX0SLwb16rXb9cySRkp9W9YACN7uwVPftKULAZB7i/G+vm9htJQWl7FmqCqvkQgrV0sGoiDJz94y+HjypqLUQvO/A6zF4dSjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764110011; c=relaxed/simple;
	bh=GEgP7pTGGsMiZpf//hiNTCzLaM6X/i9iYWWhrmctPik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SfZHhgQ9LyCqveuDO+krTtFvZwzz/K4dLX24m7mpq6K7df+S8oPBv0IPQno4mAeJTGJS1b8y+DZsLQ8ywwnzDmqShDk7SP8jO1UtJ7IAbBYfWcUH2o6Lpdk5vk47qBWg1P8tVqo+EoiCMdP/kGZcM1gDrMN11Rp+s5Nyxzweq3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=mROIB8Ms; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="mROIB8Ms"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 49939602AA;
	Tue, 25 Nov 2025 23:33:25 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1764110005;
	bh=BVsP/MKfnPtMnAFYwQ8+lv384v46S/jFMatyaYYMzBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mROIB8MsTclzT/gPsuRb37hu/xaZ4rcLae05irT/T+2JmOpf055XLzdWXzxLWD/PV
	 jmry1pJKhSmU3rEJVnKkG3TWKCbodh4wtkFHeuD9c9gBeRuBPRJxy1kEvWtHhmYDTw
	 ghLcn01D/ftt85KVLrBQaJrJtGCj+ESxPm2Vl0LzebTaHOSyExLPO8tT9kpawyFVxL
	 25aIop0PFjEZkEx2MGlY5m8P8lV/3wRzeq+A0A5PfuuYfaOSH+hZR2dO9ByKdTPxsh
	 64Lnwp6szgNXcFyC21SCMtzKjPWkCiVnIBqwrpRCS/UR22uuSGrXCzpniBnX2wb9VH
	 wtnNyutmiN/Sw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 05/16] netfilter: flowtable: remove hw_ifidx
Date: Tue, 25 Nov 2025 22:33:01 +0000
Message-ID: <20251125223312.1246891-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251125223312.1246891-1-pablo@netfilter.org>
References: <20251125223312.1246891-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

hw_ifidx was originally introduced to store the real netdevice as a
requirement for the hardware offload support in:

 73f97025a972 ("netfilter: nft_flow_offload: use direct xmit if hardware offload is enabled")

Since ("netfilter: flowtable: consolidate xmit path"), ifidx and
hw_ifidx points to the real device in the xmit path, remove it.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_flow_table.h | 1 -
 net/netfilter/nf_flow_table_core.c    | 1 -
 net/netfilter/nf_flow_table_offload.c | 2 +-
 net/netfilter/nf_flow_table_path.c    | 3 ---
 4 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index efede742106c..89cfe7228398 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -146,7 +146,6 @@ struct flow_offload_tuple {
 		};
 		struct {
 			u32		ifidx;
-			u32		hw_ifidx;
 			u8		h_source[ETH_ALEN];
 			u8		h_dest[ETH_ALEN];
 		} out;
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 98d7b3708602..6c6a5165f993 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -127,7 +127,6 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 		memcpy(flow_tuple->out.h_source, route->tuple[dir].out.h_source,
 		       ETH_ALEN);
 		flow_tuple->out.ifidx = route->tuple[dir].out.ifindex;
-		flow_tuple->out.hw_ifidx = route->tuple[dir].out.hw_ifindex;
 		dst_release(dst);
 		break;
 	case FLOW_OFFLOAD_XMIT_XFRM:
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index e06bc36f49fe..d8f7bfd60ac6 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -555,7 +555,7 @@ static void flow_offload_redirect(struct net *net,
 	switch (this_tuple->xmit_type) {
 	case FLOW_OFFLOAD_XMIT_DIRECT:
 		this_tuple = &flow->tuplehash[dir].tuple;
-		ifindex = this_tuple->out.hw_ifidx;
+		ifindex = this_tuple->out.ifidx;
 		break;
 	case FLOW_OFFLOAD_XMIT_NEIGH:
 		other_tuple = &flow->tuplehash[!dir].tuple;
diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
index 7ba6a0c4e5d8..50b2b7d0c579 100644
--- a/net/netfilter/nf_flow_table_path.c
+++ b/net/netfilter/nf_flow_table_path.c
@@ -75,7 +75,6 @@ static int nft_dev_fill_forward_path(const struct nf_flow_route *route,
 struct nft_forward_info {
 	const struct net_device *indev;
 	const struct net_device *outdev;
-	const struct net_device *hw_outdev;
 	struct id {
 		__u16	id;
 		__be16	proto;
@@ -152,7 +151,6 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 		}
 	}
 	info->outdev = info->indev;
-	info->hw_outdev = info->indev;
 
 	if (nf_flowtable_hw_offload(flowtable) &&
 	    nft_is_valid_ether_device(info->indev))
@@ -205,7 +203,6 @@ static void nft_dev_forward_path(struct nf_flow_route *route,
 	if (info.xmit_type == FLOW_OFFLOAD_XMIT_DIRECT) {
 		memcpy(route->tuple[dir].out.h_source, info.h_source, ETH_ALEN);
 		memcpy(route->tuple[dir].out.h_dest, info.h_dest, ETH_ALEN);
-		route->tuple[dir].out.hw_ifindex = info.hw_outdev->ifindex;
 		route->tuple[dir].xmit_type = info.xmit_type;
 	}
 }
-- 
2.47.3

