From: kaber@trash.net
Subject: [PATCH 06/37] ipvs: remove _bh from percpu stats reading
Date: Tue, 15 Mar 2011 20:43:46 +0100
Message-ID: <1300218257-26953-7-git-send-email-kaber@trash.net>
References: <1300218257-26953-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: davem@davemloft.net
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1300218257-26953-1-git-send-email-kaber@trash.net>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Julian Anastasov <ja@ssi.bg>

 	ip_vs_read_cpu_stats is called only from timer, so
no need for _bh locks.

Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Hans Schillstrom <hans@schillstrom.com>
Signed-off-by: Simon Horman <horms@verge.net.au>
---
 net/netfilter/ipvs/ip_vs_est.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_est.c b/net/netfilter/ipvs/ip_vs_est.c
index f560a05..88bd716 100644
--- a/net/netfilter/ipvs/ip_vs_est.c
+++ b/net/netfilter/ipvs/ip_vs_est.c
@@ -69,10 +69,10 @@ static void ip_vs_read_cpu_stats(struct ip_vs_stats_user *sum,
 			sum->inpkts += s->ustats.inpkts;
 			sum->outpkts += s->ustats.outpkts;
 			do {
-				start = u64_stats_fetch_begin_bh(&s->syncp);
+				start = u64_stats_fetch_begin(&s->syncp);
 				inbytes = s->ustats.inbytes;
 				outbytes = s->ustats.outbytes;
-			} while (u64_stats_fetch_retry_bh(&s->syncp, start));
+			} while (u64_stats_fetch_retry(&s->syncp, start));
 			sum->inbytes += inbytes;
 			sum->outbytes += outbytes;
 		} else {
@@ -80,10 +80,10 @@ static void ip_vs_read_cpu_stats(struct ip_vs_stats_user *sum,
 			sum->inpkts = s->ustats.inpkts;
 			sum->outpkts = s->ustats.outpkts;
 			do {
-				start = u64_stats_fetch_begin_bh(&s->syncp);
+				start = u64_stats_fetch_begin(&s->syncp);
 				sum->inbytes = s->ustats.inbytes;
 				sum->outbytes = s->ustats.outbytes;
-			} while (u64_stats_fetch_retry_bh(&s->syncp, start));
+			} while (u64_stats_fetch_retry(&s->syncp, start));
 		}
 	}
 }
-- 
1.7.2.3

