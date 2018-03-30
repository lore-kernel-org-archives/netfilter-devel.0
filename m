From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 21/47] ipvs: use true and false for boolean values
Date: Fri, 30 Mar 2018 13:43:08 +0200
Message-ID: <20180330114334.18664-2-pablo@netfilter.org>
References: <20180330114334.18664-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180330114334.18664-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>

Assign true or false to boolean variables instead of an integer value.

This issue was detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
Signed-off-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_lblc.c  | 4 ++--
 net/netfilter/ipvs/ip_vs_lblcr.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_lblc.c b/net/netfilter/ipvs/ip_vs_lblc.c
index 6a340c94c4b8..942e835caf7f 100644
--- a/net/netfilter/ipvs/ip_vs_lblc.c
+++ b/net/netfilter/ipvs/ip_vs_lblc.c
@@ -238,7 +238,7 @@ static void ip_vs_lblc_flush(struct ip_vs_service *svc)
 	int i;
 
 	spin_lock_bh(&svc->sched_lock);
-	tbl->dead = 1;
+	tbl->dead = true;
 	for (i = 0; i < IP_VS_LBLC_TAB_SIZE; i++) {
 		hlist_for_each_entry_safe(en, next, &tbl->bucket[i], list) {
 			ip_vs_lblc_del(en);
@@ -369,7 +369,7 @@ static int ip_vs_lblc_init_svc(struct ip_vs_service *svc)
 	tbl->max_size = IP_VS_LBLC_TAB_SIZE*16;
 	tbl->rover = 0;
 	tbl->counter = 1;
-	tbl->dead = 0;
+	tbl->dead = false;
 	tbl->svc = svc;
 
 	/*
diff --git a/net/netfilter/ipvs/ip_vs_lblcr.c b/net/netfilter/ipvs/ip_vs_lblcr.c
index 0627881128da..a5acab25c36b 100644
--- a/net/netfilter/ipvs/ip_vs_lblcr.c
+++ b/net/netfilter/ipvs/ip_vs_lblcr.c
@@ -404,7 +404,7 @@ static void ip_vs_lblcr_flush(struct ip_vs_service *svc)
 	struct hlist_node *next;
 
 	spin_lock_bh(&svc->sched_lock);
-	tbl->dead = 1;
+	tbl->dead = true;
 	for (i = 0; i < IP_VS_LBLCR_TAB_SIZE; i++) {
 		hlist_for_each_entry_safe(en, next, &tbl->bucket[i], list) {
 			ip_vs_lblcr_free(en);
@@ -532,7 +532,7 @@ static int ip_vs_lblcr_init_svc(struct ip_vs_service *svc)
 	tbl->max_size = IP_VS_LBLCR_TAB_SIZE*16;
 	tbl->rover = 0;
 	tbl->counter = 1;
-	tbl->dead = 0;
+	tbl->dead = false;
 	tbl->svc = svc;
 
 	/*
-- 
2.11.0
