From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 18/47] netfilter: make xt_rateest hash table per net
Date: Fri, 30 Mar 2018 13:38:45 +0200
Message-ID: <20180330113914.18431-9-pablo@netfilter.org>
References: <20180330113914.18431-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180330113914.18431-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

As suggested by Eric, we need to make the xt_rateest
hash table and its lock per netns to reduce lock
contentions.

Cc: Florian Westphal <fw@strlen.de>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/xt_rateest.h |  4 +-
 net/netfilter/xt_RATEEST.c         | 91 +++++++++++++++++++++++++++-----------
 net/netfilter/xt_rateest.c         | 10 ++---
 3 files changed, 72 insertions(+), 33 deletions(-)

diff --git a/include/net/netfilter/xt_rateest.h b/include/net/netfilter/xt_rateest.h
index b1db13772554..832ab69efda5 100644
--- a/include/net/netfilter/xt_rateest.h
+++ b/include/net/netfilter/xt_rateest.h
@@ -21,7 +21,7 @@ struct xt_rateest {
 	struct net_rate_estimator __rcu *rate_est;
 };
 
-struct xt_rateest *xt_rateest_lookup(const char *name);
-void xt_rateest_put(struct xt_rateest *est);
+struct xt_rateest *xt_rateest_lookup(struct net *net, const char *name);
+void xt_rateest_put(struct net *net, struct xt_rateest *est);
 
 #endif /* _XT_RATEEST_H */
diff --git a/net/netfilter/xt_RATEEST.c b/net/netfilter/xt_RATEEST.c
index 141c295191f6..dec843cadf46 100644
--- a/net/netfilter/xt_RATEEST.c
+++ b/net/netfilter/xt_RATEEST.c
@@ -14,15 +14,21 @@
 #include <linux/slab.h>
 #include <net/gen_stats.h>
 #include <net/netlink.h>
+#include <net/netns/generic.h>
 
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_RATEEST.h>
 #include <net/netfilter/xt_rateest.h>
 
-static DEFINE_MUTEX(xt_rateest_mutex);
-
 #define RATEEST_HSIZE	16
-static struct hlist_head rateest_hash[RATEEST_HSIZE] __read_mostly;
+
+struct xt_rateest_net {
+	struct mutex hash_lock;
+	struct hlist_head hash[RATEEST_HSIZE];
+};
+
+static unsigned int xt_rateest_id;
+
 static unsigned int jhash_rnd __read_mostly;
 
 static unsigned int xt_rateest_hash(const char *name)
@@ -31,21 +37,23 @@ static unsigned int xt_rateest_hash(const char *name)
 	       (RATEEST_HSIZE - 1);
 }
 
-static void xt_rateest_hash_insert(struct xt_rateest *est)
+static void xt_rateest_hash_insert(struct xt_rateest_net *xn,
+				   struct xt_rateest *est)
 {
 	unsigned int h;
 
 	h = xt_rateest_hash(est->name);
-	hlist_add_head(&est->list, &rateest_hash[h]);
+	hlist_add_head(&est->list, &xn->hash[h]);
 }
 
-static struct xt_rateest *__xt_rateest_lookup(const char *name)
+static struct xt_rateest *__xt_rateest_lookup(struct xt_rateest_net *xn,
+					      const char *name)
 {
 	struct xt_rateest *est;
 	unsigned int h;
 
 	h = xt_rateest_hash(name);
-	hlist_for_each_entry(est, &rateest_hash[h], list) {
+	hlist_for_each_entry(est, &xn->hash[h], list) {
 		if (strcmp(est->name, name) == 0) {
 			est->refcnt++;
 			return est;
@@ -55,20 +63,23 @@ static struct xt_rateest *__xt_rateest_lookup(const char *name)
 	return NULL;
 }
 
-struct xt_rateest *xt_rateest_lookup(const char *name)
+struct xt_rateest *xt_rateest_lookup(struct net *net, const char *name)
 {
+	struct xt_rateest_net *xn = net_generic(net, xt_rateest_id);
 	struct xt_rateest *est;
 
-	mutex_lock(&xt_rateest_mutex);
-	est = __xt_rateest_lookup(name);
-	mutex_unlock(&xt_rateest_mutex);
+	mutex_lock(&xn->hash_lock);
+	est = __xt_rateest_lookup(xn, name);
+	mutex_unlock(&xn->hash_lock);
 	return est;
 }
 EXPORT_SYMBOL_GPL(xt_rateest_lookup);
 
-void xt_rateest_put(struct xt_rateest *est)
+void xt_rateest_put(struct net *net, struct xt_rateest *est)
 {
-	mutex_lock(&xt_rateest_mutex);
+	struct xt_rateest_net *xn = net_generic(net, xt_rateest_id);
+
+	mutex_lock(&xn->hash_lock);
 	if (--est->refcnt == 0) {
 		hlist_del(&est->list);
 		gen_kill_estimator(&est->rate_est);
@@ -78,7 +89,7 @@ void xt_rateest_put(struct xt_rateest *est)
 		 */
 		kfree_rcu(est, rcu);
 	}
-	mutex_unlock(&xt_rateest_mutex);
+	mutex_unlock(&xn->hash_lock);
 }
 EXPORT_SYMBOL_GPL(xt_rateest_put);
 
@@ -98,6 +109,7 @@ xt_rateest_tg(struct sk_buff *skb, const struct xt_action_param *par)
 
 static int xt_rateest_tg_checkentry(const struct xt_tgchk_param *par)
 {
+	struct xt_rateest_net *xn = net_generic(par->net, xt_rateest_id);
 	struct xt_rateest_target_info *info = par->targinfo;
 	struct xt_rateest *est;
 	struct {
@@ -108,10 +120,10 @@ static int xt_rateest_tg_checkentry(const struct xt_tgchk_param *par)
 
 	net_get_random_once(&jhash_rnd, sizeof(jhash_rnd));
 
-	mutex_lock(&xt_rateest_mutex);
-	est = __xt_rateest_lookup(info->name);
+	mutex_lock(&xn->hash_lock);
+	est = __xt_rateest_lookup(xn, info->name);
 	if (est) {
-		mutex_unlock(&xt_rateest_mutex);
+		mutex_unlock(&xn->hash_lock);
 		/*
 		 * If estimator parameters are specified, they must match the
 		 * existing estimator.
@@ -119,7 +131,7 @@ static int xt_rateest_tg_checkentry(const struct xt_tgchk_param *par)
 		if ((!info->interval && !info->ewma_log) ||
 		    (info->interval != est->params.interval ||
 		     info->ewma_log != est->params.ewma_log)) {
-			xt_rateest_put(est);
+			xt_rateest_put(par->net, est);
 			return -EINVAL;
 		}
 		info->est = est;
@@ -148,14 +160,14 @@ static int xt_rateest_tg_checkentry(const struct xt_tgchk_param *par)
 		goto err2;
 
 	info->est = est;
-	xt_rateest_hash_insert(est);
-	mutex_unlock(&xt_rateest_mutex);
+	xt_rateest_hash_insert(xn, est);
+	mutex_unlock(&xn->hash_lock);
 	return 0;
 
 err2:
 	kfree(est);
 err1:
-	mutex_unlock(&xt_rateest_mutex);
+	mutex_unlock(&xn->hash_lock);
 	return ret;
 }
 
@@ -163,7 +175,7 @@ static void xt_rateest_tg_destroy(const struct xt_tgdtor_param *par)
 {
 	struct xt_rateest_target_info *info = par->targinfo;
 
-	xt_rateest_put(info->est);
+	xt_rateest_put(par->net, info->est);
 }
 
 static struct xt_target xt_rateest_tg_reg __read_mostly = {
@@ -178,19 +190,46 @@ static struct xt_target xt_rateest_tg_reg __read_mostly = {
 	.me         = THIS_MODULE,
 };
 
-static int __init xt_rateest_tg_init(void)
+static __net_init int xt_rateest_net_init(struct net *net)
+{
+	struct xt_rateest_net *xn = net_generic(net, xt_rateest_id);
+	int i;
+
+	mutex_init(&xn->hash_lock);
+	for (i = 0; i < ARRAY_SIZE(xn->hash); i++)
+		INIT_HLIST_HEAD(&xn->hash[i]);
+	return 0;
+}
+
+static void __net_exit xt_rateest_net_exit(struct net *net)
 {
-	unsigned int i;
+	struct xt_rateest_net *xn = net_generic(net, xt_rateest_id);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(xn->hash); i++)
+		WARN_ON_ONCE(!hlist_empty(&xn->hash[i]));
+}
 
-	for (i = 0; i < ARRAY_SIZE(rateest_hash); i++)
-		INIT_HLIST_HEAD(&rateest_hash[i]);
+static struct pernet_operations xt_rateest_net_ops = {
+	.init = xt_rateest_net_init,
+	.exit = xt_rateest_net_exit,
+	.id   = &xt_rateest_id,
+	.size = sizeof(struct xt_rateest_net),
+};
+
+static int __init xt_rateest_tg_init(void)
+{
+	int err = register_pernet_subsys(&xt_rateest_net_ops);
 
+	if (err)
+		return err;
 	return xt_register_target(&xt_rateest_tg_reg);
 }
 
 static void __exit xt_rateest_tg_fini(void)
 {
 	xt_unregister_target(&xt_rateest_tg_reg);
+	unregister_pernet_subsys(&xt_rateest_net_ops);
 }
 
 
diff --git a/net/netfilter/xt_rateest.c b/net/netfilter/xt_rateest.c
index 755d2f6693a2..bf77326861af 100644
--- a/net/netfilter/xt_rateest.c
+++ b/net/netfilter/xt_rateest.c
@@ -95,13 +95,13 @@ static int xt_rateest_mt_checkentry(const struct xt_mtchk_param *par)
 	}
 
 	ret  = -ENOENT;
-	est1 = xt_rateest_lookup(info->name1);
+	est1 = xt_rateest_lookup(par->net, info->name1);
 	if (!est1)
 		goto err1;
 
 	est2 = NULL;
 	if (info->flags & XT_RATEEST_MATCH_REL) {
-		est2 = xt_rateest_lookup(info->name2);
+		est2 = xt_rateest_lookup(par->net, info->name2);
 		if (!est2)
 			goto err2;
 	}
@@ -111,7 +111,7 @@ static int xt_rateest_mt_checkentry(const struct xt_mtchk_param *par)
 	return 0;
 
 err2:
-	xt_rateest_put(est1);
+	xt_rateest_put(par->net, est1);
 err1:
 	return ret;
 }
@@ -120,9 +120,9 @@ static void xt_rateest_mt_destroy(const struct xt_mtdtor_param *par)
 {
 	struct xt_rateest_match_info *info = par->matchinfo;
 
-	xt_rateest_put(info->est1);
+	xt_rateest_put(par->net, info->est1);
 	if (info->est2)
-		xt_rateest_put(info->est2);
+		xt_rateest_put(par->net, info->est2);
 }
 
 static struct xt_match xt_rateest_mt_reg __read_mostly = {
-- 
2.11.0
