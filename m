From: timg@tpi.com (Tim Gardner)
Subject: [PATCH] xt_recent: Fix buffer overflow
Date: Fri, 19 Feb 2010 10:48:04 -0700 (MST)
Message-ID: <20100219174804.43CD8F8C3F@sepang.rtg.net>
Cc: coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
	netfilter@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

>From 478a6cbbd7646c78370da48677e99cc602076dd7 Mon Sep 17 00:00:00 2001
From: Tim Gardner <tim.gardner@canonical.com>
Date: Thu, 18 Feb 2010 20:04:51 -0700
Subject: [PATCH] xt_recent: Fix buffer overflow

e->index overflows e->stamps[] every ip_pkt_list_tot
packets.

Consider the case when ip_pkt_list_tot==1; the first packet received is stored
in e->stamps[0] and e->index is initialized to 1. The next received packet
timestamp is then stored at e->stamps[1] in recent_entry_update(),
a buffer overflow because the maximum e->stamps[] index is 0.

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Cc: stable@kernel.org
---
 net/netfilter/xt_recent.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index fc70a49..1bb0d6c 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -173,10 +173,10 @@ recent_entry_init(struct recent_table *t, const union nf_inet_addr *addr,
 
 static void recent_entry_update(struct recent_table *t, struct recent_entry *e)
 {
+	e->index %= ip_pkt_list_tot;
 	e->stamps[e->index++] = jiffies;
 	if (e->index > e->nstamps)
 		e->nstamps = e->index;
-	e->index %= ip_pkt_list_tot;
 	list_move_tail(&e->lru_list, &t->lru_list);
 }
 
-- 
1.6.2.4

