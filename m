Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 829D02192F5;
	Fri, 28 Nov 2025 00:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764289443; cv=none; b=N5gplsc5iYCSK/HJR82xGodDHaoVruiWlGfoOY7jU1ouIWR7UUBsStkuQYR3LCuTe34fXRnvHn/T/lcIwSsLe120zYRTNnCaLZuDPd8wGhuPZOtwxi7SGimv/wbURFnpQOjSa4Wxn9CBej6oBnTJvZ/JExp7vQGse38Ce0bBnPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764289443; c=relaxed/simple;
	bh=AdDtYsDfqwUdJVBJ4oGO+Zlnw1codZ8xhJ7PfasdAQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iO7LRmifjCVWwgeuYAl7f3B31XSAKCN5PIhNISGqyOI0W8BqFhq2ECN27qeyfG9xzbBm3GGXE6NjPSKUTW89u0nU1KV7a16BTfZ03XtSsGX/np2PZNn7xC7h9QW4S2Df6ia9PztuxlXl9vPeFmxaqDFbOJwnx51yZD4i006vecQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=svcCUiBP; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="svcCUiBP"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D9E0460279;
	Fri, 28 Nov 2025 01:23:56 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1764289437;
	bh=uar/1iRXnyuKDYEZLYOOhiKv3DAwT+zzp3rR/Tf2ZbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=svcCUiBPR9XKS8e4wwnrziMdDqBzGzwMXTx8ZEtRciTKLAgR+HtC3jZ/bi3dXRvaf
	 qCv2jGbjhLMQ1ivtXNSIfGJX70c8zWzrpnwr2qjkttBsl/EE574/NVuq+6EaKAkxvT
	 /5hCgVYKOAKczB923wX3+9hLuqbZxWC2AkPez/nnzgbi95MOSYeBMMeYQGpV1r9n9F
	 xriOJKXVOecmVXeJI7uw+c9Dq5Mn/u6LDLkn7bkZ+AWzsEnCP1k9JFwkBhEdZVZpRn
	 PJzmXcnvfOizni2wpXAvxz0XyyVy0JPw0Pfbugx7bfsZl5AFeXlPwHdiKGtn6l1sbR
	 qGYWAgaAoLgeA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 06/17] netfilter: flowtable: remove hw_ifidx
Date: Fri, 28 Nov 2025 00:23:33 +0000
Message-ID: <20251128002345.29378-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251128002345.29378-1-pablo@netfilter.org>
References: <20251128002345.29378-1-pablo@netfilter.org>
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
index c51e310bb2ab..eb9b33a1873a 100644
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
@@ -159,7 +158,6 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 		}
 	}
 	info->outdev = info->indev;
-	info->hw_outdev = info->indev;
 
 	if (nf_flowtable_hw_offload(flowtable) &&
 	    nft_is_valid_ether_device(info->indev))
@@ -212,7 +210,6 @@ static void nft_dev_forward_path(struct nf_flow_route *route,
 	if (info.xmit_type == FLOW_OFFLOAD_XMIT_DIRECT) {
 		memcpy(route->tuple[dir].out.h_source, info.h_source, ETH_ALEN);
 		memcpy(route->tuple[dir].out.h_dest, info.h_dest, ETH_ALEN);
-		route->tuple[dir].out.hw_ifindex = info.hw_outdev->ifindex;
 		route->tuple[dir].xmit_type = info.xmit_type;
 	}
 }
-- 
2.47.3

