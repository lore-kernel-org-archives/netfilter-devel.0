Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA70643849A;
	Wed,  8 Jul 2026 14:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783519453; cv=none; b=du3SXFDI1ha6BuV1B846HIWTPbpKdHeJLmXon6582bXp/ZoOMocIgQDxKLSRHgMyYa4lFMPEkM/tOjwNYPSKzTUEBMhVZD3Rhc/FHQOaCYQ3ALCLbg6H3E6H4N+/uY1oSYST1qMS0iQGCdSlHGX67Xk3lc5iDFCzuie9+Fyed8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783519453; c=relaxed/simple;
	bh=2we8uSJuxZf5OYq3eLJCLjbehjSN6X9bMEAUTZY7Ou0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f5BTbhBiKeVerUJktACbJfDW+6fG7Txzye7/TsTjx/SuKQfI6Q1IUkFuf+riTFFqBFMWSOpeyIqH57VRKPF+dGCC6j8CHANZsbKRbc+tscnRTcdAvo8w0gnIWsC5c0g3U/FzDZLop5Vh6m0ZrOMVewyVBNx5UlntKRIdcSTOc1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 6221160CFA; Wed, 08 Jul 2026 16:04:10 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 12/17] netfilter: flowtable: support IPIP tunnel with direct xmit
Date: Wed,  8 Jul 2026 16:03:04 +0200
Message-ID: <20260708140309.19633-13-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260708140309.19633-1-fw@strlen.de>
References: <20260708140309.19633-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pablo Neira Ayuso <pablo@netfilter.org>

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
Cc: stable@vger.kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Reported-by: Zhengyang Chen <chzhengyang2023@lzu.edu.cn>
Reported-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
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
2.54.0

