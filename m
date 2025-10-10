Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4097513A265
	for <netfilter-devel@vger.kernel.org>; Fri, 10 Oct 2025 11:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760095132; cv=none; b=jfms5EP1J+NuoyBqbXWIJPJC5EhbMFY7ynwzyZoMe9vuiWkQmk6PX1hn4xH54vreNdCJdEYHzkLUAFco8w1YP/2eVW9QNVhm0iwg0ZRgEAdetWUQrDkl3TebnjZ49U3iWQcV3Q1sLtSVtyW13b8wJvYhgSNfyxEi0eQN/sAL30E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760095132; c=relaxed/simple;
	bh=wyEJXiRYBZdu2OenIZN0UUI55wN+IJ0/A7HHI5AGLaY=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UkTPOngsNhgiIxI+iDF1bReYiHeQAAXKphKynAGm1vKF8Jtl/As/d+1RUIiwChR1L6/Tl90pMn0HxSd5FRdUNV0gceOejz73AW13DJZgcANzhHVD8ohQK2lilvqfW+9VL1EIjD3ITROPaRwnmM9+yn0Kw6QdhUGYniOwZrmc+as=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=u8d0Iqc/; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=uLfFvbZ7; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="u8d0Iqc/";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="uLfFvbZ7"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 4381F602B0; Fri, 10 Oct 2025 13:18:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1760095120;
	bh=kTdvfQbBP4p1P4Vee2PHeyz497sRzA6oF74qhQwXItY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=u8d0Iqc/chn2Y8gWi5kaocjE7HAo6VHfQMQw21z1bNYy/ZfQuzytck97aY1GY2gtM
	 s3GTwJRvnFKcupQclwDyRBOGSE0V4G6oUEFTaEJ+A1WD6YwrE6kxRre413lkmtCMIE
	 7pKWYLOQfPhMq+AzoiVkjT8YD4mGIVkmzVqgUiyGRoofw3MIc0e52VyBM/ziDJCk+H
	 l8EADZyvzfpF1nFneYr1Xid4dAmcoE/vRz2lTWD3NxvS1/G6tVTLshl37okEy5LLdw
	 Itr9ibKCMbGW9B4lSSHGuLwl0Pl9pC4Zm7kO0JZ4CQ0QtoVVL2yBhRz84475DKWuo9
	 s2kDalOsoPnmA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id B85E4602A9
	for <netfilter-devel@vger.kernel.org>; Fri, 10 Oct 2025 13:18:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1760095119;
	bh=kTdvfQbBP4p1P4Vee2PHeyz497sRzA6oF74qhQwXItY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=uLfFvbZ7WdB9WL3PLYdU9+1zBu9mQTP6Oy+4tgKYppVpFLfU6UcHH/wOiSjj7IxPk
	 Ecn3x4ycoqXo119TDnAVWYlzSsQ1694hHY6pijd8d1vzl3gMRUhnb4WubrI+d4XIlQ
	 o8npiIb5ivYlqoN4SOxo+yvSUU1keQ7d4S6GZ9IIV4mh9nlt9oYhdRuUO39kSLve5o
	 vqff4gHmjYoY+CoUw0DaZa5jY7DydkiVhFJED2baUAc66vKlwLyw/O/j17myDI/TU2
	 JkpH40IerN+5RQZKq8iSWDncHWhfoxm1uOoPB0th1WC4fLk2TILUOVSTznTb9MDZln
	 gtiSHedSgfcAw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 5/5] netfilter: flowtable: remove hw_ifidx
Date: Fri, 10 Oct 2025 13:18:25 +0200
Message-Id: <20251010111825.6723-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20251010111825.6723-1-pablo@netfilter.org>
References: <20251010111825.6723-1-pablo@netfilter.org>
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
2.30.2

