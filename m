Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6200534403E;
	Wed, 26 Nov 2025 20:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764190590; cv=none; b=uucw78ln6OcRMLi7VzgGaASNIrPCOB6qYj8ysgq4mnMKaBN70oQJQCI7RTyWFd+Y9hYj6NKJkEWGbhU5QI5ziOdrxoH4mDlkLW7OU2Sd/pT6d+dymRhTPkdvbFEmIAyfvbdQMswM3J+/o4my7UeleKYwwr4AyyTdTVjbOtm9o6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764190590; c=relaxed/simple;
	bh=gp3+EnR+xL0mR4m0UDzkoA7RsgJuOo3J2/to/muGrU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i9pWc8N9x5UZJQXtE1/47HjP66hK3+viGhwZeD+tuItG75ofkZGFBSmZcAdZ6TrSqBguK8wAuTBJV76PrnXrwcdI2+myvGZQgavKzHX4scR4ivsYZY+JYwDQs4jRXhhO0aMNgZ7iWFY/QL5akAQA1qSjn/7PVSs/rjEMyLCyTg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Ggxp+46+; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Ggxp+46+"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 4FF6360272;
	Wed, 26 Nov 2025 21:56:26 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1764190586;
	bh=Wx8GEwfV5s1eJi0satYLObYkZAGdfGKMQJHtJ2gILBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ggxp+46+NFhfQULsQjdf+NRKfpwm+226f3JnfHNGx8P77tOG57jO8IeJq8ZX0qKbS
	 TMscCNh3T+JtvCHQD98xl+VdHNMgViAdRdt0AcwOZor2GDCo6NMPFrQhVFpZL9wQvO
	 5MShdHW/xdpamwV75+VqLZ4YQOUxN/ZQZZ9RKfCol0KZDjYPyrJXn94zlCbmrivUzT
	 r43VHXDNg6cMEUoqdWLBbwuHCeSitqQ/kU6xbEBqqVHFiTnh+SVAPbMhvU9xyyWLT1
	 b7fXCNcTM7pfJFTlPI5rO0i4rmaStgSHS31cGgr5QLYRRdiZ/bMwndsFUB+jHZoWpF
	 SWD04TxDbT2+g==
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
Date: Wed, 26 Nov 2025 20:56:00 +0000
Message-ID: <20251126205611.1284486-6-pablo@netfilter.org>
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
index 7c330caae52b..f7306276ece7 100644
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

