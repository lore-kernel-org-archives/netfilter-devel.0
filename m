Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE34D399368;
	Fri, 10 Jul 2026 14:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783694291; cv=none; b=ZROPwyqdWbh43jFEehX2OIlQgnpgpgoLvTLA2Lx8xNX1e6XHIIgGOrrfZjYnk0SmIHvPgwaAsfudIRM1DRI2Cwf4BQuoPByUg3MrjiKG7A0I7NeNtGAZlwRXFHYUttDKMUV07rK9JjR4NMuNvc5HeLkz29LhMzsiFXDRgJDYUsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783694291; c=relaxed/simple;
	bh=Qlsr2cSvInZcbbw2CMiGHiyiFqoycJH0qRmdPuHoleo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AqNOUJ/31/CUN1g/ZgJGImowIui1EeVZ0l3S/VwdOsFPimjTZBNSq7Gc03TQ+PafIQ8cIRHleH3pKJPDMC7K1NR49b+ovgfH0moLxeS6YuVVeT5e6zxVscTZYzFtteA1jSWAujV0mttTZtbPjG7/Sg/eu9a/mJ630Tw14ZgLsrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 6BB30605B5; Fri, 10 Jul 2026 16:38:08 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 6/9] netfilter: flowtable: use correct direction to set up tunnel route
Date: Fri, 10 Jul 2026 16:37:30 +0200
Message-ID: <20260710143733.29741-7-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260710143733.29741-1-fw@strlen.de>
References: <20260710143733.29741-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pablo Neira Ayuso <pablo@netfilter.org>

The layer 2 encapsulation and layer 3 tunnel information in the xmit
path is taken from the other tuple, because the tunnel information that
is included in the tuple for hashtable lookups is also used to perform
the egress encapsulation in the transmit path.

This patch uses the correct direction when setting up the tunnel, the
original proposed patch to address this fix uses the reversed direction.

While at it, remove the redundant check to call dst_release() to drop
the reference on the dst that was obtained from the forward path, which
is not useful in the direct xmit path unless tunneling is performed.

Fixes: fa7395c02d95 ("netfilter: flowtable: support IPIP tunnel with direct xmit")
Cc: stable@vger.kernel.org
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_flow_table_core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 2a829b5e8240..b66e65439341 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -127,18 +127,18 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 
 	switch (route->tuple[dir].xmit_type) {
 	case FLOW_OFFLOAD_XMIT_DIRECT:
-		if (flow_tuple->tun_num) {
+		if (route->tuple[!dir].in.num_tuns) {
 			flow_tuple->dst_cache = dst;
 			flow_tuple->dst_cookie =
 				flow_offload_dst_cookie(flow_tuple);
+		} else {
+			dst_release(dst);
 		}
 		memcpy(flow_tuple->out.h_dest, route->tuple[dir].out.h_dest,
 		       ETH_ALEN);
 		memcpy(flow_tuple->out.h_source, route->tuple[dir].out.h_source,
 		       ETH_ALEN);
 		flow_tuple->out.ifidx = route->tuple[dir].out.ifindex;
-		if (!flow_tuple->tun_num)
-			dst_release(dst);
 		break;
 	case FLOW_OFFLOAD_XMIT_XFRM:
 	case FLOW_OFFLOAD_XMIT_NEIGH:
-- 
2.54.0

