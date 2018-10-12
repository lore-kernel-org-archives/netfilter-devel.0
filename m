From: Omar Sandoval <osandov@osandov.com>
Subject: [PATCH] netfilter: x_tables: fix missing unlock if table init fails
Date: Fri, 12 Oct 2018 16:16:53 -0700
Message-ID: <32ddddccb89d8be6a73cd2de2fb20283b2ef6a94.1539385788.git.osandov@fb.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, kernel-team@fb.com
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

Commit 7dde07e9c536 ("netfilter: x_tables: unlock on error in
xt_find_table_lock()") fixed one missing unlock in xt_find_table_lock(),
but we're also missing one if t->table_init() fails.

Fixes: b9e69e127397 ("netfilter: xtables: don't hook tables by default")
Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 net/netfilter/x_tables.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index aecadd471e1d..2a0106e6305e 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1207,28 +1207,31 @@ struct xt_table *xt_find_table_lock(struct net *net, u_int8_t af,
 				    const char *name)
 {
 	struct xt_table *t, *found = NULL;
+	int err;
 
 	mutex_lock(&xt[af].mutex);
 	list_for_each_entry(t, &net->xt.tables[af], list)
 		if (strcmp(t->name, name) == 0 && try_module_get(t->me))
 			return t;
 
-	if (net == &init_net)
+	if (net == &init_net) {
+		err = -ENOENT;
 		goto out;
+	}
 
 	/* Table doesn't exist in this netns, re-try init */
 	list_for_each_entry(t, &init_net.xt.tables[af], list) {
-		int err;
-
 		if (strcmp(t->name, name))
 			continue;
-		if (!try_module_get(t->me))
+		if (!try_module_get(t->me)) {
+			err = -ENOENT;
 			goto out;
+		}
 		mutex_unlock(&xt[af].mutex);
 		err = t->table_init(net);
 		if (err < 0) {
 			module_put(t->me);
-			return ERR_PTR(err);
+			goto out;
 		}
 
 		found = t;
@@ -1237,8 +1240,10 @@ struct xt_table *xt_find_table_lock(struct net *net, u_int8_t af,
 		break;
 	}
 
-	if (!found)
+	if (!found) {
+		err = -ENOENT;
 		goto out;
+	}
 
 	/* and once again: */
 	list_for_each_entry(t, &net->xt.tables[af], list)
@@ -1248,7 +1253,7 @@ struct xt_table *xt_find_table_lock(struct net *net, u_int8_t af,
 	module_put(found->me);
  out:
 	mutex_unlock(&xt[af].mutex);
-	return ERR_PTR(-ENOENT);
+	return ERR_PTR(err);
 }
 EXPORT_SYMBOL_GPL(xt_find_table_lock);
 
-- 
2.19.1
