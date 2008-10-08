From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 61/79: remove unused Ebtables functions
Date: Wed,  8 Oct 2008 12:47:43 +0200 (MEST)
Message-ID: <20081008104743.10423.73993.sendpatchset@x2.localnet>
References: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46048 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754800AbYJHKro (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Oct 2008 06:47:44 -0400
In-Reply-To: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 66bff35b722956cc2423f55fcf1b69cefa24ef8b
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Wed Oct 8 11:35:16 2008 +0200

    netfilter: remove unused Ebtables functions
    
    Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/include/linux/netfilter_bridge/ebtables.h b/include/linux/netfilter_bridge/ebtables.h
index d3f9243..568a690 100644
--- a/include/linux/netfilter_bridge/ebtables.h
+++ b/include/linux/netfilter_bridge/ebtables.h
@@ -302,12 +302,6 @@ struct ebt_table
 		     ~(__alignof__(struct ebt_replace)-1))
 extern int ebt_register_table(struct ebt_table *table);
 extern void ebt_unregister_table(struct ebt_table *table);
-extern int ebt_register_match(struct ebt_match *match);
-extern void ebt_unregister_match(struct ebt_match *match);
-extern int ebt_register_watcher(struct ebt_watcher *watcher);
-extern void ebt_unregister_watcher(struct ebt_watcher *watcher);
-extern int ebt_register_target(struct ebt_target *target);
-extern void ebt_unregister_target(struct ebt_target *target);
 extern unsigned int ebt_do_table(unsigned int hook, struct sk_buff *skb,
    const struct net_device *in, const struct net_device *out,
    struct ebt_table *table);
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 7964d3f..b489ed2 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -56,9 +56,6 @@
 
 static DEFINE_MUTEX(ebt_mutex);
 static LIST_HEAD(ebt_tables);
-static LIST_HEAD(ebt_targets);
-static LIST_HEAD(ebt_matches);
-static LIST_HEAD(ebt_watchers);
 
 static struct xt_target ebt_standard_target = {
 	.name       = "standard",
@@ -322,24 +319,6 @@ find_table_lock(const char *name, int *error, struct mutex *mutex)
 	return find_inlist_lock(&ebt_tables, name, "ebtable_", error, mutex);
 }
 
-static inline struct ebt_match *
-find_match_lock(const char *name, int *error, struct mutex *mutex)
-{
-	return find_inlist_lock(&ebt_matches, name, "ebt_", error, mutex);
-}
-
-static inline struct ebt_watcher *
-find_watcher_lock(const char *name, int *error, struct mutex *mutex)
-{
-	return find_inlist_lock(&ebt_watchers, name, "ebt_", error, mutex);
-}
-
-static inline struct ebt_target *
-find_target_lock(const char *name, int *error, struct mutex *mutex)
-{
-	return find_inlist_lock(&ebt_targets, name, "ebt_", error, mutex);
-}
-
 static inline int
 ebt_check_match(struct ebt_entry_match *m, struct ebt_entry *e,
    const char *name, unsigned int hookmask, unsigned int *cnt)
@@ -1103,87 +1082,6 @@ free_newinfo:
 	return ret;
 }
 
-int ebt_register_target(struct ebt_target *target)
-{
-	struct ebt_target *t;
-	int ret;
-
-	ret = mutex_lock_interruptible(&ebt_mutex);
-	if (ret != 0)
-		return ret;
-	list_for_each_entry(t, &ebt_targets, list) {
-		if (strcmp(t->name, target->name) == 0) {
-			mutex_unlock(&ebt_mutex);
-			return -EEXIST;
-		}
-	}
-	list_add(&target->list, &ebt_targets);
-	mutex_unlock(&ebt_mutex);
-
-	return 0;
-}
-
-void ebt_unregister_target(struct ebt_target *target)
-{
-	mutex_lock(&ebt_mutex);
-	list_del(&target->list);
-	mutex_unlock(&ebt_mutex);
-}
-
-int ebt_register_match(struct ebt_match *match)
-{
-	struct ebt_match *m;
-	int ret;
-
-	ret = mutex_lock_interruptible(&ebt_mutex);
-	if (ret != 0)
-		return ret;
-	list_for_each_entry(m, &ebt_matches, list) {
-		if (strcmp(m->name, match->name) == 0) {
-			mutex_unlock(&ebt_mutex);
-			return -EEXIST;
-		}
-	}
-	list_add(&match->list, &ebt_matches);
-	mutex_unlock(&ebt_mutex);
-
-	return 0;
-}
-
-void ebt_unregister_match(struct ebt_match *match)
-{
-	mutex_lock(&ebt_mutex);
-	list_del(&match->list);
-	mutex_unlock(&ebt_mutex);
-}
-
-int ebt_register_watcher(struct ebt_watcher *watcher)
-{
-	struct ebt_watcher *w;
-	int ret;
-
-	ret = mutex_lock_interruptible(&ebt_mutex);
-	if (ret != 0)
-		return ret;
-	list_for_each_entry(w, &ebt_watchers, list) {
-		if (strcmp(w->name, watcher->name) == 0) {
-			mutex_unlock(&ebt_mutex);
-			return -EEXIST;
-		}
-	}
-	list_add(&watcher->list, &ebt_watchers);
-	mutex_unlock(&ebt_mutex);
-
-	return 0;
-}
-
-void ebt_unregister_watcher(struct ebt_watcher *watcher)
-{
-	mutex_lock(&ebt_mutex);
-	list_del(&watcher->list);
-	mutex_unlock(&ebt_mutex);
-}
-
 int ebt_register_table(struct ebt_table *table)
 {
 	struct ebt_table_info *newinfo;
@@ -1575,12 +1473,6 @@ static void __exit ebtables_fini(void)
 
 EXPORT_SYMBOL(ebt_register_table);
 EXPORT_SYMBOL(ebt_unregister_table);
-EXPORT_SYMBOL(ebt_register_match);
-EXPORT_SYMBOL(ebt_unregister_match);
-EXPORT_SYMBOL(ebt_register_watcher);
-EXPORT_SYMBOL(ebt_unregister_watcher);
-EXPORT_SYMBOL(ebt_register_target);
-EXPORT_SYMBOL(ebt_unregister_target);
 EXPORT_SYMBOL(ebt_do_table);
 module_init(ebtables_init);
 module_exit(ebtables_fini);
