From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 19/47] netfilter: xt_limit: Spelling s/maxmum/maximum/
Date: Fri, 30 Mar 2018 13:38:46 +0200
Message-ID: <20180330113914.18431-10-pablo@netfilter.org>
References: <20180330113914.18431-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180330113914.18431-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_limit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/xt_limit.c b/net/netfilter/xt_limit.c
index 55d18cd67635..9f098ecb2449 100644
--- a/net/netfilter/xt_limit.c
+++ b/net/netfilter/xt_limit.c
@@ -46,7 +46,7 @@ MODULE_ALIAS("ip6t_limit");
 
    See Alexey's formal explanation in net/sched/sch_tbf.c.
 
-   To get the maxmum range, we multiply by this factor (ie. you get N
+   To get the maximum range, we multiply by this factor (ie. you get N
    credits per jiffy).  We want to allow a rate as low as 1 per day
    (slowest userspace tool allows), which means
    CREDITS_PER_JIFFY*HZ*60*60*24 < 2^32. ie. */
-- 
2.11.0
