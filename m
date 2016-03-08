From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 01/10] netfilter: ipvs: Remove noisy debug print from ip_vs_del_service
Date: Tue,  8 Mar 2016 11:00:41 +0100
Message-ID: <1457431250-3086-2-git-send-email-pablo@netfilter.org>
References: <1457431250-3086-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1457431250-3086-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Yannick Brosseau <scientist@fb.com>

This have been there for a long time, but does not seem to add value

Signed-off-by: Yannick Brosseau <scientist@fb.com>
Signed-off-by: Simon Horman <horms@verge.net.au>
---
 net/netfilter/ipvs/ip_vs_ctl.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index e7c1b05..daf4cb7 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -1376,8 +1376,6 @@ static void __ip_vs_del_service(struct ip_vs_service *svc, bool cleanup)
 	struct ip_vs_pe *old_pe;
 	struct netns_ipvs *ipvs = svc->ipvs;
 
-	pr_info("%s: enter\n", __func__);
-
 	/* Count only IPv4 services for old get/setsockopt interface */
 	if (svc->af == AF_INET)
 		ipvs->num_services--;
-- 
2.1.4
