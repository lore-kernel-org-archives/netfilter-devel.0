From: Aaron Conole <aconole@bytheb.org>
Subject: [PATCH nf-next] ip_vs_sync: change comparison on sync_refresh_period
Date: Wed, 12 Apr 2017 16:38:12 -0400
Message-ID: <20170412203812.15091-1-aconole@bytheb.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

The sync_refresh_period variable is unsigned, so it can never be < 0.

Signed-off-by: Aaron Conole <aconole@bytheb.org>
---
 net/netfilter/ipvs/ip_vs_sync.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
index b03c280..123dc0f 100644
--- a/net/netfilter/ipvs/ip_vs_sync.c
+++ b/net/netfilter/ipvs/ip_vs_sync.c
@@ -520,7 +520,7 @@ static int ip_vs_sync_conn_needed(struct netns_ipvs *ipvs,
 		if (!(cp->flags & IP_VS_CONN_F_TEMPLATE) &&
 		    pkts % sync_period != sysctl_sync_threshold(ipvs))
 			return 0;
-	} else if (sync_refresh_period <= 0 &&
+	} else if (!sync_refresh_period &&
 		   pkts != sysctl_sync_threshold(ipvs))
 		return 0;
 
-- 
2.9.3
