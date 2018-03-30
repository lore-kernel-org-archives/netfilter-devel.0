From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 28/47] netfilter: ebtables: use ADD_COUNTER macro
Date: Fri, 30 Mar 2018 13:43:15 +0200
Message-ID: <20180330114334.18664-9-pablo@netfilter.org>
References: <20180330114334.18664-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180330114334.18664-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

xtables uses ADD_COUNTER macro to increase
packet and byte count. ebtables also can use this.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/netfilter/ebtables.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 217aa79f7b2a..9a26d2b7420f 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -223,9 +223,7 @@ unsigned int ebt_do_table(struct sk_buff *skb,
 			return NF_DROP;
 		}
 
-		/* increase counter */
-		(*(counter_base + i)).pcnt++;
-		(*(counter_base + i)).bcnt += skb->len;
+		ADD_COUNTER(*(counter_base + i), 1, skb->len);
 
 		/* these should only watch: not modify, nor tell us
 		 * what to do with the packet
@@ -968,10 +966,9 @@ static void get_counters(const struct ebt_counter *oldcounters,
 		if (cpu == 0)
 			continue;
 		counter_base = COUNTER_BASE(oldcounters, nentries, cpu);
-		for (i = 0; i < nentries; i++) {
-			counters[i].pcnt += counter_base[i].pcnt;
-			counters[i].bcnt += counter_base[i].bcnt;
-		}
+		for (i = 0; i < nentries; i++)
+			ADD_COUNTER(counters[i], counter_base[i].pcnt,
+				    counter_base[i].bcnt);
 	}
 }
 
@@ -1324,10 +1321,8 @@ static int do_update_counters(struct net *net, const char *name,
 	write_lock_bh(&t->lock);
 
 	/* we add to the counters of the first cpu */
-	for (i = 0; i < num_counters; i++) {
-		t->private->counters[i].pcnt += tmp[i].pcnt;
-		t->private->counters[i].bcnt += tmp[i].bcnt;
-	}
+	for (i = 0; i < num_counters; i++)
+		ADD_COUNTER(t->private->counters[i], tmp[i].pcnt, tmp[i].bcnt);
 
 	write_unlock_bh(&t->lock);
 	ret = 0;
-- 
2.11.0
