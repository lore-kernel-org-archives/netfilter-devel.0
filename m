From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 31/51] netfilter: ebtables: add ebt_free_table_info function
Date: Mon,  7 May 2018 00:46:49 +0200
Message-ID: <20180506224709.29100-32-pablo@netfilter.org>
References: <20180506224709.29100-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180506224709.29100-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

A ebt_free_table_info frees all of chainstacks.
It similar to xt_free_table_info. this inline function
reduces code line.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/netfilter/ebtables.c | 39 +++++++++++++++------------------------
 1 file changed, 15 insertions(+), 24 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 032e0fe45940..355410b13316 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -343,6 +343,16 @@ find_table_lock(struct net *net, const char *name, int *error,
 				"ebtable_", error, mutex);
 }
 
+static inline void ebt_free_table_info(struct ebt_table_info *info)
+{
+	int i;
+
+	if (info->chainstack) {
+		for_each_possible_cpu(i)
+			vfree(info->chainstack[i]);
+		vfree(info->chainstack);
+	}
+}
 static inline int
 ebt_check_match(struct ebt_entry_match *m, struct xt_mtchk_param *par,
 		unsigned int *cnt)
@@ -975,7 +985,7 @@ static void get_counters(const struct ebt_counter *oldcounters,
 static int do_replace_finish(struct net *net, struct ebt_replace *repl,
 			      struct ebt_table_info *newinfo)
 {
-	int ret, i;
+	int ret;
 	struct ebt_counter *counterstmp = NULL;
 	/* used to be able to unlock earlier */
 	struct ebt_table_info *table;
@@ -1051,13 +1061,8 @@ static int do_replace_finish(struct net *net, struct ebt_replace *repl,
 			  ebt_cleanup_entry, net, NULL);
 
 	vfree(table->entries);
-	if (table->chainstack) {
-		for_each_possible_cpu(i)
-			vfree(table->chainstack[i]);
-		vfree(table->chainstack);
-	}
+	ebt_free_table_info(table);
 	vfree(table);
-
 	vfree(counterstmp);
 
 #ifdef CONFIG_AUDIT
@@ -1078,11 +1083,7 @@ static int do_replace_finish(struct net *net, struct ebt_replace *repl,
 free_counterstmp:
 	vfree(counterstmp);
 	/* can be initialized in translate_table() */
-	if (newinfo->chainstack) {
-		for_each_possible_cpu(i)
-			vfree(newinfo->chainstack[i]);
-		vfree(newinfo->chainstack);
-	}
+	ebt_free_table_info(newinfo);
 	return ret;
 }
 
@@ -1147,8 +1148,6 @@ static int do_replace(struct net *net, const void __user *user,
 
 static void __ebt_unregister_table(struct net *net, struct ebt_table *table)
 {
-	int i;
-
 	mutex_lock(&ebt_mutex);
 	list_del(&table->list);
 	mutex_unlock(&ebt_mutex);
@@ -1157,11 +1156,7 @@ static void __ebt_unregister_table(struct net *net, struct ebt_table *table)
 	if (table->private->nentries)
 		module_put(table->me);
 	vfree(table->private->entries);
-	if (table->private->chainstack) {
-		for_each_possible_cpu(i)
-			vfree(table->private->chainstack[i]);
-		vfree(table->private->chainstack);
-	}
+	ebt_free_table_info(table->private);
 	vfree(table->private);
 	kfree(table);
 }
@@ -1263,11 +1258,7 @@ int ebt_register_table(struct net *net, const struct ebt_table *input_table,
 free_unlock:
 	mutex_unlock(&ebt_mutex);
 free_chainstack:
-	if (newinfo->chainstack) {
-		for_each_possible_cpu(i)
-			vfree(newinfo->chainstack[i]);
-		vfree(newinfo->chainstack);
-	}
+	ebt_free_table_info(newinfo);
 	vfree(newinfo->entries);
 free_newinfo:
 	vfree(newinfo);
-- 
2.11.0
