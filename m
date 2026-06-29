Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E41D423161
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Jun 2026 14:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782743996; cv=none; b=qxT0XK0y7i5uyWrN5/ZQf7t3rIXX1u3ZtjJgtMmT8ZXyUmmVUqjm+2zgUmr2czsEj2td7fpc5jIQSaL8F0A1NQA68/s+iaKEoGEA3hvi0n8C4q+JcMix18ls1jjbQgF2KvMErBdPIh+b9mjIJTSVXTxyImw1/Y5Gd7iVA60U5ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782743996; c=relaxed/simple;
	bh=96CdN+WFuHBF6hW40Hp/D4yW95jCUvGoD2rik/2c0Ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uWuNB7TfxiX0f9w37bBEj/rMmwR2dRXH6DLUmgJErerH7tR7Az4gyZn+Vt9zJCXyJNgo0M0kmFQogGzgKziOe7RJ44y8iWWsANnoauP+z4EAu2Xg4cN+WlW/qtfcySQrhSwdedjAVgyBxB58XmvWOPZWfjLWPogq1JvC8Aqb/ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=qe0CnztN; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="qe0CnztN"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 8016F6058B;
	Mon, 29 Jun 2026 16:39:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1782743985;
	bh=9GB6kdBzapsXEkOtd700/LMKO3DkQ/NQe+KrnwhtLrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qe0CnztN8yEOZx324gMtYeAx5SykRo0lqEOthIvdfrI6CyGLeV6Lqdl48gQwmDJUL
	 TAJhGowi0YQXq6LPc1XgJr4lw8mZJU9HDgFtpyTDMirbimm2xPJd85UVI92WCFWJ7+
	 JNCTIXqzFFJrpnaiMHMn6EhCoLNDkABIoXKGgVCoqgfVq10NBwXcGmSpaAkXAKc/Xv
	 8te2zXG4Jygw57d/xUtpEmtksnL+LLf/UkMJFngawQ97mWyTsLBwHJDHNtG7hhkSnN
	 nF6IZxuusbi2qX/U+2Xp20Y5X9uJIJPrcFS9rygTQ5sVrkyf3i7kOb6R0ggTJFAJP2
	 Y2gMTt/IwvHoQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: chzhengyang2023@lzu.edu.cn,
	lorenzo@kernel.org
Subject: [PATCH nf 3/3] netfilter: flowtable: support IPIP tunnel with direct xmit
Date: Mon, 29 Jun 2026 16:39:36 +0200
Message-ID: <20260629143936.61239-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260629143936.61239-1-pablo@netfilter.org>
References: <20260629143936.61239-1-pablo@netfilter.org>
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
 include/net/netfilter/nf_flow_table.h |  4 ++--
 net/netfilter/nf_flow_table_core.c    | 15 +++++++++++----
 net/netfilter/nf_flow_table_ip.c      |  3 +--
 3 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 7b23b245a5a8..369f6a717811 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -155,11 +155,11 @@ struct flow_offload_tuple {
 					tun_num:2,
 					in_vlan_ingress:2;
 	u16				mtu;
+	struct dst_entry		*dst_cache;
+	u32				dst_cookie;
 	union {
 		struct {
-			struct dst_entry *dst_cache;
 			u32		ifidx;
-			u32		dst_cookie;
 		};
 		struct {
 			u32		ifidx;
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 99c5b9d671a0..6f195ccf222a 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -127,12 +127,21 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 
 	switch (route->tuple[dir].xmit_type) {
 	case FLOW_OFFLOAD_XMIT_DIRECT:
+		if (flow_tuple->tun_num) {
+			flow_tuple->dst_cache = dst;
+			flow_tuple->dst_cookie =
+				flow_offload_dst_cookie(flow_tuple);
+		} else {
+			flow_tuple->dst_cache = NULL;
+			flow_tuple->dst_cookie = 0;
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
@@ -152,9 +161,7 @@ static int flow_offload_fill_route(struct flow_offload *flow,
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

