From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 26/38] ipvs: drop conn templates under attack
Date: Fri, 20 Jul 2018 15:08:54 +0200
Message-ID: <20180720130906.27687-27-pablo@netfilter.org>
References: <20180720130906.27687-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180720130906.27687-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Julian Anastasov <ja@ssi.bg>

Before now, connection templates were ignored by the random
dropentry procedure. But Michal Koutný suggests that we
should add exception for connections under SYN attack.
He provided patch that implements it for TCP:

<quote>

IPVS includes protection against filling the ip_vs_conn_tab by
dropping 1/32 of feasible entries every second. The template
entries (for persistent services) are never directly deleted by
this mechanism but when a picked TCP connection entry is being
dropped (1), the respective template entry is dropped too (realized
by expiring 60 seconds after the connection entry being dropped).

There is another mechanism that removes connection entries when they
time out (2), in this case the associated template entry is not deleted.
Under SYN flood template entries would accumulate (due to their entry
longer timeout).

The accumulation takes place also with drop_entry being enabled. Roughly
15% ((31/32)^60) of SYN_RECV connections survive the dropping mechanism
(1) and are removed by the timeout mechanism (2)(defaults to 60 seconds
for SYN_RECV), thus template entries would still accumulate.

The patch ensures that when a connection entry times out, we also remove
the template entry from the table. To prevent breaking persistent
services (since the connection may time out in already established state)
we add a new entry flag to protect templates what spawned at least one
established TCP connection.

</quote>

We already added ASSURED flag for the templates in previous patch, so
that we can use it now to decide which connection templates should be
dropped under attack. But we also have some cases that need special
handling.

We modify the dropentry procedure as follows:

- Linux timers currently use LIFO ordering but we can not rely on
this to drop controlling connections. So, set cp->timeout to 0
to indicate that connection was dropped and that on expiration we
should try to drop our controlling connections. As result, we can
now avoid the ip_vs_conn_expire_now call.

- move the cp->n_control check above, so that it avoids restarting
the timer for controlling connections when not needed.

- drop unassured connection templates here if they are not referred
by any connections.

On connection expiration: if connection was dropped (cp->timeout=0)
try to drop our controlling connection except if it is a template
in assured state.

In ip_vs_conn_flush change order of ip_vs_conn_expire_now calls
according to the LIFO timer expiration order. It should work
faster for controlling connections with single controlled one.

Suggested-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_conn.c | 59 +++++++++++++++++++++++++++--------------
 1 file changed, 39 insertions(+), 20 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index de5a64e42ebd..0edc62910ebf 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -825,12 +825,23 @@ static void ip_vs_conn_expire(struct timer_list *t)
 
 	/* Unlink conn if not referenced anymore */
 	if (likely(ip_vs_conn_unlink(cp))) {
+		struct ip_vs_conn *ct = cp->control;
+
 		/* delete the timer if it is activated by other users */
 		del_timer(&cp->timer);
 
 		/* does anybody control me? */
-		if (cp->control)
+		if (ct) {
 			ip_vs_control_del(cp);
+			/* Drop CTL or non-assured TPL if not used anymore */
+			if (!cp->timeout && !atomic_read(&ct->n_control) &&
+			    (!(ct->flags & IP_VS_CONN_F_TEMPLATE) ||
+			     !(ct->state & IP_VS_CTPL_S_ASSURED))) {
+				IP_VS_DBG(4, "drop controlling connection\n");
+				ct->timeout = 0;
+				ip_vs_conn_expire_now(ct);
+			}
+		}
 
 		if ((cp->flags & IP_VS_CONN_F_NFCT) &&
 		    !(cp->flags & IP_VS_CONN_F_ONE_PACKET)) {
@@ -872,6 +883,10 @@ static void ip_vs_conn_expire(struct timer_list *t)
 
 /* Modify timer, so that it expires as soon as possible.
  * Can be called without reference only if under RCU lock.
+ * We can have such chain of conns linked with ->control: DATA->CTL->TPL
+ * - DATA (eg. FTP) and TPL (persistence) can be present depending on setup
+ * - cp->timeout=0 indicates all conns from chain should be dropped but
+ * TPL is not dropped if in assured state
  */
 void ip_vs_conn_expire_now(struct ip_vs_conn *cp)
 {
@@ -1197,8 +1212,11 @@ static const struct seq_operations ip_vs_conn_sync_seq_ops = {
 #endif
 
 
-/*
- *      Randomly drop connection entries before running out of memory
+/* Randomly drop connection entries before running out of memory
+ * Can be used for DATA and CTL conns. For TPL conns there are exceptions:
+ * - traffic for services in OPS mode increases ct->in_pkts, so it is supported
+ * - traffic for services not in OPS mode does not increase ct->in_pkts in
+ * all cases, so it is not supported
  */
 static inline int todrop_entry(struct ip_vs_conn *cp)
 {
@@ -1242,7 +1260,7 @@ static inline bool ip_vs_conn_ops_mode(struct ip_vs_conn *cp)
 void ip_vs_random_dropentry(struct netns_ipvs *ipvs)
 {
 	int idx;
-	struct ip_vs_conn *cp, *cp_c;
+	struct ip_vs_conn *cp;
 
 	rcu_read_lock();
 	/*
@@ -1254,13 +1272,15 @@ void ip_vs_random_dropentry(struct netns_ipvs *ipvs)
 		hlist_for_each_entry_rcu(cp, &ip_vs_conn_tab[hash], c_list) {
 			if (cp->ipvs != ipvs)
 				continue;
+			if (atomic_read(&cp->n_control))
+				continue;
 			if (cp->flags & IP_VS_CONN_F_TEMPLATE) {
-				if (atomic_read(&cp->n_control) ||
-				    !ip_vs_conn_ops_mode(cp))
-					continue;
-				else
-					/* connection template of OPS */
+				/* connection template of OPS */
+				if (ip_vs_conn_ops_mode(cp))
 					goto try_drop;
+				if (!(cp->state & IP_VS_CTPL_S_ASSURED))
+					goto drop;
+				continue;
 			}
 			if (cp->protocol == IPPROTO_TCP) {
 				switch(cp->state) {
@@ -1294,15 +1314,10 @@ void ip_vs_random_dropentry(struct netns_ipvs *ipvs)
 					continue;
 			}
 
-			IP_VS_DBG(4, "del connection\n");
+drop:
+			IP_VS_DBG(4, "drop connection\n");
+			cp->timeout = 0;
 			ip_vs_conn_expire_now(cp);
-			cp_c = cp->control;
-			/* cp->control is valid only with reference to cp */
-			if (cp_c && __ip_vs_conn_get(cp)) {
-				IP_VS_DBG(4, "del conn template\n");
-				ip_vs_conn_expire_now(cp_c);
-				__ip_vs_conn_put(cp);
-			}
 		}
 		cond_resched_rcu();
 	}
@@ -1325,15 +1340,19 @@ static void ip_vs_conn_flush(struct netns_ipvs *ipvs)
 		hlist_for_each_entry_rcu(cp, &ip_vs_conn_tab[idx], c_list) {
 			if (cp->ipvs != ipvs)
 				continue;
-			IP_VS_DBG(4, "del connection\n");
-			ip_vs_conn_expire_now(cp);
+			/* As timers are expired in LIFO order, restart
+			 * the timer of controlling connection first, so
+			 * that it is expired after us.
+			 */
 			cp_c = cp->control;
 			/* cp->control is valid only with reference to cp */
 			if (cp_c && __ip_vs_conn_get(cp)) {
-				IP_VS_DBG(4, "del conn template\n");
+				IP_VS_DBG(4, "del controlling connection\n");
 				ip_vs_conn_expire_now(cp_c);
 				__ip_vs_conn_put(cp);
 			}
+			IP_VS_DBG(4, "del connection\n");
+			ip_vs_conn_expire_now(cp);
 		}
 		cond_resched_rcu();
 	}
-- 
2.11.0
