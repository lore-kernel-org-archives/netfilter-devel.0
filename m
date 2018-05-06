From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 02/51] netfilter: ipvs: Keep latest weight of destination
Date: Mon,  7 May 2018 00:46:20 +0200
Message-ID: <20180506224709.29100-3-pablo@netfilter.org>
References: <20180506224709.29100-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180506224709.29100-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Inju Song <inju.song@navercorp.com>

The hashing table in scheduler such as source hash or maglev hash
should ignore the changed weight to 0 and allow changing the weight
from/to non-0 values. So, struct ip_vs_dest needs to keep weight
with latest non-0 weight.

Signed-off-by: Inju Song <inju.song@navercorp.com>
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Simon Horman <horms@verge.net.au>
---
 include/net/ip_vs.h            | 1 +
 net/netfilter/ipvs/ip_vs_ctl.c | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index eb0bec043c96..0ac795b41ab8 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -668,6 +668,7 @@ struct ip_vs_dest {
 	volatile unsigned int	flags;		/* dest status flags */
 	atomic_t		conn_flags;	/* flags to copy to conn */
 	atomic_t		weight;		/* server weight */
+	atomic_t		last_weight;	/* server latest weight */
 
 	refcount_t		refcnt;		/* reference counter */
 	struct ip_vs_stats      stats;          /* statistics */
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 5ebde4b15810..b91bb70ece92 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -821,6 +821,10 @@ __ip_vs_update_dest(struct ip_vs_service *svc, struct ip_vs_dest *dest,
 	if (add && udest->af != svc->af)
 		ipvs->mixed_address_family_dests++;
 
+	/* keep the last_weight with latest non-0 weight */
+	if (add || udest->weight != 0)
+		atomic_set(&dest->last_weight, udest->weight);
+
 	/* set the weight and the flags */
 	atomic_set(&dest->weight, udest->weight);
 	conn_flags = udest->conn_flags & IP_VS_CONN_F_DEST_MASK;
-- 
2.11.0
