From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 12/37] netfilter: nat: remove unnecessary 'else if' branch
Date: Fri, 21 Dec 2018 01:28:16 +0100
Message-ID: <20181221002841.28587-13-pablo@netfilter.org>
References: <20181221002841.28587-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181221002841.28587-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Xiaozhou Liu <liuxiaozhou@bytedance.com>

Since a pseudo-random starting point is used in finding a port in
the default case, that 'else if' branch above is no longer a necessity.
So remove it to simplify code.

Signed-off-by: Xiaozhou Liu <liuxiaozhou@bytedance.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_nat_proto_common.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/netfilter/nf_nat_proto_common.c b/net/netfilter/nf_nat_proto_common.c
index a7de939fa5a9..136ab65c4082 100644
--- a/net/netfilter/nf_nat_proto_common.c
+++ b/net/netfilter/nf_nat_proto_common.c
@@ -80,8 +80,6 @@ void nf_nat_l4proto_unique_tuple(const struct nf_nat_l3proto *l3proto,
 		off = l3proto->secure_port(tuple, maniptype == NF_NAT_MANIP_SRC
 						  ? tuple->dst.u.all
 						  : tuple->src.u.all);
-	} else if (range->flags & NF_NAT_RANGE_PROTO_RANDOM_FULLY) {
-		off = prandom_u32();
 	} else if (range->flags & NF_NAT_RANGE_PROTO_OFFSET) {
 		off = (ntohs(*portptr) - ntohs(range->base_proto.all));
 	} else {
-- 
2.11.0
