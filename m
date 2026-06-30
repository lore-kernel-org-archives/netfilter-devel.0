Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A66EC391E57
	for <netfilter-devel@vger.kernel.org>; Tue, 30 Jun 2026 09:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782812466; cv=none; b=OEIZ0VSQgwmA7dSAV8sT0V1sUKqUUPnUTEXLiswxnT2Y2cR+nRqwt95DRZViIgYuiWWyw7Bgo/7wPJPfTU4XCS0qeq+/R5oQykfbGO0ph/W7U0TE9zB8ZKZ5zPeAgDgi/WyrOTUNcqgKhVS/fsb55pJz4l+lQlm4VbCFd8vj3SY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782812466; c=relaxed/simple;
	bh=DrC3b7MsFI/KOdDyibp7SzegqaJFhwrU/1oG3fRGz2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iV0Ba8cUtH5guXNEVwNVz9mQu9BbrvyKGtGRgLebOMQTAphnxEpqyspSoyPkPRLn7ZCoHDiX3l5aEJWAhZxywu0chvbAtF/UD4X/hprH67ljBRPflYcl2CgYeWfmK2P51T2NqC3hsSkMFM3n4UCCVIPUEqA1TrrNME3Tb3t3ltI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=iopFZjR4; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="iopFZjR4"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id B117560593;
	Tue, 30 Jun 2026 11:41:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1782812463;
	bh=uCcuN4KdkRf6f5kYCpg8CS0Nvz1wfJFgl9aA5jAGsrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iopFZjR4PkgdcDa2X6lGH9ex+WCD6z+lTYbsT7hXNUjekIW59ekrULzaBnYjD2Gc6
	 +tenotUzJ1UKhOx/PKll6PfE5vCWH15y3zxgTfbwJ+9QrpkNg5vm/S4BRucJZByfRt
	 b56UJAVHuY+hRo74KYBLFbqjhtu01KM9OczCuhkVM2y4YF6QVZd8ZDdW4YxNg8K/0l
	 zc1Jgej80Q0CabMW5ta+VWDDtgKce0uzH6VVzbjCPHWlK4/zRvUAem4v/wN9Rjx2uo
	 EuAClVrAvIUgTAWl60oKkUFAFEllsQ37JbyL7wYgOInHQTnYRGuFk4Ax1yR4UCy7oq
	 OnYN7qnqdCZQA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: lorenzo@kernel.org,
	chzhengyang2023@lzu.edu.cn
Subject: [PATCH nf,v2 3/3] netfilter: flowtable: support IPIP tunnel with direct xmit
Date: Tue, 30 Jun 2026 11:40:56 +0200
Message-ID: <20260630094056.97038-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260630094056.97038-1-pablo@netfilter.org>
References: <20260630094056.97038-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The combination of IPIP tunnel with direct xmit, eg. bridge device,
breaks because no dst_entry is provided to check the skb headroom and to
set the iph->frag_off field. This leads to invalid dst usage and can
trigger a crash in the tunnel transmit path.

Fix this by moving dst_cache and dst_cookie out of the runtime union so
that they can be shared by neighbour, xfrm, and direct tunnel flows.
For FLOW_OFFLOAD_XMIT_DIRECT tuples carrying tunnel metadata, preserve
route state in these shared fields and release it through the common
dst release path.

Since dst_entry is now available to the three supported xmit modes and
dst_release() already deals with NULL dst, remove the xmit type check
in nft_flow_dst_release(). Moreover, skip the check if the dst entry
is NULL in nf_flow_dst_check() which is now the case for the direct
xmit case.

Based on patch from Rein Wei <n05ec@lzu.edu.cn>.

Fixes: d30301ba4b07 ("netfilter: flowtable: Add IPIP tx sw acceleration")
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Reported-by: Zhengyang Chen <chzhengyang2023@lzu.edu.cn>
Reported-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: - reorder dst_cookie and dst_cache to fix a 4-byte hole in struct
    - remove unnecessary zeroing on dst_cookie and dst_cache, struct is already zeroed at init
    Both updates per Lorenzo Bianconi's comment.

 include/net/netfilter/nf_flow_table.h |  5 +++--
 net/netfilter/nf_flow_table_core.c    | 12 ++++++++----
 net/netfilter/nf_flow_table_ip.c      |  3 +--
 3 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index dc5c9b48e65a..ce414118962f 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -155,11 +155,12 @@ struct flow_offload_tuple {
 					tun_num:2,
 					in_vlan_ingress:2;
 	u16				mtu;
+	u32				dst_cookie;
+	struct dst_entry		*dst_cache;
+
 	union {
 		struct {
-			struct dst_entry *dst_cache;
 			u32		ifidx;
-			u32		dst_cookie;
 		};
 		struct {
 			u32		ifidx;
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index d06ce0848b68..2a829b5e8240 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -127,12 +127,18 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 
 	switch (route->tuple[dir].xmit_type) {
 	case FLOW_OFFLOAD_XMIT_DIRECT:
+		if (flow_tuple->tun_num) {
+			flow_tuple->dst_cache = dst;
+			flow_tuple->dst_cookie =
+				flow_offload_dst_cookie(flow_tuple);
+		}
 		memcpy(flow_tuple->out.h_dest, route->tuple[dir].out.h_dest,
 		       ETH_ALEN);
 		memcpy(flow_tuple->out.h_source, route->tuple[dir].out.h_source,
 		       ETH_ALEN);
 		flow_tuple->out.ifidx = route->tuple[dir].out.ifindex;
-		dst_release(dst);
+		if (!flow_tuple->tun_num)
+			dst_release(dst);
 		break;
 	case FLOW_OFFLOAD_XMIT_XFRM:
 	case FLOW_OFFLOAD_XMIT_NEIGH:
@@ -152,9 +158,7 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 static void nft_flow_dst_release(struct flow_offload *flow,
 				 enum flow_offload_tuple_dir dir)
 {
-	if (flow->tuplehash[dir].tuple.xmit_type == FLOW_OFFLOAD_XMIT_NEIGH ||
-	    flow->tuplehash[dir].tuple.xmit_type == FLOW_OFFLOAD_XMIT_XFRM)
-		dst_release(flow->tuplehash[dir].tuple.dst_cache);
+	dst_release(flow->tuplehash[dir].tuple.dst_cache);
 }
 
 void flow_offload_route_init(struct flow_offload *flow,
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 089f2bc19972..0b78decce8a9 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -299,8 +299,7 @@ static bool nf_flow_exceeds_mtu(const struct sk_buff *skb, unsigned int mtu)
 
 static inline bool nf_flow_dst_check(struct flow_offload_tuple *tuple)
 {
-	if (tuple->xmit_type != FLOW_OFFLOAD_XMIT_NEIGH &&
-	    tuple->xmit_type != FLOW_OFFLOAD_XMIT_XFRM)
+	if (!tuple->dst_cache)
 		return true;
 
 	return dst_check(tuple->dst_cache, tuple->dst_cookie);
-- 
2.47.3

