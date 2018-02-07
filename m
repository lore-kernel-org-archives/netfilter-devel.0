From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 07/11] netfilter: xt_RATEEST: acquire xt_rateest_mutex for hash insert
Date: Wed,  7 Feb 2018 18:42:25 +0100
Message-ID: <20180207174229.4098-8-pablo@netfilter.org>
References: <20180207174229.4098-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180207174229.4098-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

rateest_hash is supposed to be protected by xt_rateest_mutex,
and, as suggested by Eric, lookup and insert should be atomic,
so we should acquire the xt_rateest_mutex once for both.

So introduce a non-locking helper for internal use and keep the
locking one for external.

Reported-by: <syzbot+5cb189720978275e4c75@syzkaller.appspotmail.com>
Fixes: 5859034d7eb8 ("[NETFILTER]: x_tables: add RATEEST target")
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Reviewed-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_RATEEST.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/xt_RATEEST.c b/net/netfilter/xt_RATEEST.c
index 498b54fd04d7..141c295191f6 100644
--- a/net/netfilter/xt_RATEEST.c
+++ b/net/netfilter/xt_RATEEST.c
@@ -39,23 +39,31 @@ static void xt_rateest_hash_insert(struct xt_rateest *est)
 	hlist_add_head(&est->list, &rateest_hash[h]);
 }
 
-struct xt_rateest *xt_rateest_lookup(const char *name)
+static struct xt_rateest *__xt_rateest_lookup(const char *name)
 {
 	struct xt_rateest *est;
 	unsigned int h;
 
 	h = xt_rateest_hash(name);
-	mutex_lock(&xt_rateest_mutex);
 	hlist_for_each_entry(est, &rateest_hash[h], list) {
 		if (strcmp(est->name, name) == 0) {
 			est->refcnt++;
-			mutex_unlock(&xt_rateest_mutex);
 			return est;
 		}
 	}
-	mutex_unlock(&xt_rateest_mutex);
+
 	return NULL;
 }
+
+struct xt_rateest *xt_rateest_lookup(const char *name)
+{
+	struct xt_rateest *est;
+
+	mutex_lock(&xt_rateest_mutex);
+	est = __xt_rateest_lookup(name);
+	mutex_unlock(&xt_rateest_mutex);
+	return est;
+}
 EXPORT_SYMBOL_GPL(xt_rateest_lookup);
 
 void xt_rateest_put(struct xt_rateest *est)
@@ -100,8 +108,10 @@ static int xt_rateest_tg_checkentry(const struct xt_tgchk_param *par)
 
 	net_get_random_once(&jhash_rnd, sizeof(jhash_rnd));
 
-	est = xt_rateest_lookup(info->name);
+	mutex_lock(&xt_rateest_mutex);
+	est = __xt_rateest_lookup(info->name);
 	if (est) {
+		mutex_unlock(&xt_rateest_mutex);
 		/*
 		 * If estimator parameters are specified, they must match the
 		 * existing estimator.
@@ -139,11 +149,13 @@ static int xt_rateest_tg_checkentry(const struct xt_tgchk_param *par)
 
 	info->est = est;
 	xt_rateest_hash_insert(est);
+	mutex_unlock(&xt_rateest_mutex);
 	return 0;
 
 err2:
 	kfree(est);
 err1:
+	mutex_unlock(&xt_rateest_mutex);
 	return ret;
 }
 
-- 
2.11.0
