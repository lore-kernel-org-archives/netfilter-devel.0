From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/39]: kill listhelp.h
Date: Wed, 20 Sep 2006 10:23:53 +0200 (MEST)
Message-ID: <20060920082445.14636.42449.sendpatchset@localhost.localdomain>
References: <20060920082442.14636.6806.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060920082442.14636.6806.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: kill listhelp.h

Kill listhelp.h and use the list.h functions instead.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 02f2210c487d5c2c48fb2b30d15d6dec688e1152
tree 8355de20842352f169ed61e8499f2ffb58c87d9c
parent 2b9aa10745a14bddfcac991b5b11f809c02a6ffd
author Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:27:42 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:27:42 +0200

 include/linux/netfilter/x_tables.h           |    4 -
 net/bridge/netfilter/ebtables.c              |   76 ++++++----
 net/ipv4/netfilter/arp_tables.c              |    2 
 net/ipv4/netfilter/ip_conntrack_core.c       |  189 ++++++++++++--------------
 net/ipv4/netfilter/ip_conntrack_proto_gre.c  |   24 ++-
 net/ipv4/netfilter/ip_conntrack_standalone.c |    1 
 net/ipv4/netfilter/ip_nat_core.c             |    4 -
 net/ipv4/netfilter/ip_nat_helper.c           |    4 -
 net/ipv4/netfilter/ip_nat_rule.c             |    4 -
 net/ipv4/netfilter/ip_nat_standalone.c       |    4 -
 net/ipv6/netfilter/ip6_tables.c              |    3 
 net/netfilter/nf_conntrack_core.c            |  185 ++++++++++++-------------
 net/netfilter/nf_conntrack_standalone.c      |    1 
 net/netfilter/x_tables.c                     |   17 +-
 14 files changed, 237 insertions(+), 281 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 03d1027..c832295 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -138,10 +138,6 @@ #ifdef __KERNEL__
 
 #include <linux/netdevice.h>
 
-#define ASSERT_READ_LOCK(x)
-#define ASSERT_WRITE_LOCK(x)
-#include <linux/netfilter_ipv4/listhelp.h>
-
 #ifdef CONFIG_COMPAT
 #define COMPAT_TO_USER		1
 #define COMPAT_FROM_USER	-1
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index d06a507..3df55b2 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -24,6 +24,7 @@ #include <linux/module.h>
 #include <linux/vmalloc.h>
 #include <linux/netfilter_bridge/ebtables.h>
 #include <linux/spinlock.h>
+#include <linux/mutex.h>
 #include <asm/uaccess.h>
 #include <linux/smp.h>
 #include <linux/cpumask.h>
@@ -31,12 +32,6 @@ #include <net/sock.h>
 /* needed for logical [in,out]-dev filtering */
 #include "../br_private.h"
 
-/* list_named_find */
-#define ASSERT_READ_LOCK(x)
-#define ASSERT_WRITE_LOCK(x)
-#include <linux/netfilter_ipv4/listhelp.h>
-#include <linux/mutex.h>
-
 #define BUGPRINT(format, args...) printk("kernel msg: ebtables bug: please "\
                                          "report to author: "format, ## args)
 /* #define BUGPRINT(format, args...) */
@@ -278,18 +273,22 @@ static inline void *
 find_inlist_lock_noload(struct list_head *head, const char *name, int *error,
    struct mutex *mutex)
 {
-	void *ret;
+	struct {
+		struct list_head list;
+		char name[EBT_FUNCTION_MAXNAMELEN];
+	} *e;
 
 	*error = mutex_lock_interruptible(mutex);
 	if (*error != 0)
 		return NULL;
 
-	ret = list_named_find(head, name);
-	if (!ret) {
-		*error = -ENOENT;
-		mutex_unlock(mutex);
+	list_for_each_entry(e, head, list) {
+		if (strcmp(e->name, name) == 0)
+			return e;
 	}
-	return ret;
+	*error = -ENOENT;
+	mutex_unlock(mutex);
+	return NULL;
 }
 
 #ifndef CONFIG_KMOD
@@ -1043,15 +1042,19 @@ free_newinfo:
 
 int ebt_register_target(struct ebt_target *target)
 {
+	struct ebt_target *t;
 	int ret;
 
 	ret = mutex_lock_interruptible(&ebt_mutex);
 	if (ret != 0)
 		return ret;
-	if (!list_named_insert(&ebt_targets, target)) {
-		mutex_unlock(&ebt_mutex);
-		return -EEXIST;
+	list_for_each_entry(t, &ebt_targets, list) {
+		if (strcmp(t->name, target->name) == 0) {
+			mutex_unlock(&ebt_mutex);
+			return -EEXIST;
+		}
 	}
+	list_add(&target->list, &ebt_targets);
 	mutex_unlock(&ebt_mutex);
 
 	return 0;
@@ -1060,21 +1063,25 @@ int ebt_register_target(struct ebt_targe
 void ebt_unregister_target(struct ebt_target *target)
 {
 	mutex_lock(&ebt_mutex);
-	LIST_DELETE(&ebt_targets, target);
+	list_del(&target->list);
 	mutex_unlock(&ebt_mutex);
 }
 
 int ebt_register_match(struct ebt_match *match)
 {
+	struct ebt_match *m;
 	int ret;
 
 	ret = mutex_lock_interruptible(&ebt_mutex);
 	if (ret != 0)
 		return ret;
-	if (!list_named_insert(&ebt_matches, match)) {
-		mutex_unlock(&ebt_mutex);
-		return -EEXIST;
+	list_for_each_entry(m, &ebt_matches, list) {
+		if (strcmp(m->name, match->name) == 0) {
+			mutex_unlock(&ebt_mutex);
+			return -EEXIST;
+		}
 	}
+	list_add(&match->list, &ebt_matches);
 	mutex_unlock(&ebt_mutex);
 
 	return 0;
@@ -1083,21 +1090,25 @@ int ebt_register_match(struct ebt_match 
 void ebt_unregister_match(struct ebt_match *match)
 {
 	mutex_lock(&ebt_mutex);
-	LIST_DELETE(&ebt_matches, match);
+	list_del(&match->list);
 	mutex_unlock(&ebt_mutex);
 }
 
 int ebt_register_watcher(struct ebt_watcher *watcher)
 {
+	struct ebt_watcher *w;
 	int ret;
 
 	ret = mutex_lock_interruptible(&ebt_mutex);
 	if (ret != 0)
 		return ret;
-	if (!list_named_insert(&ebt_watchers, watcher)) {
-		mutex_unlock(&ebt_mutex);
-		return -EEXIST;
+	list_for_each_entry(w, &ebt_watchers, list) {
+		if (strcmp(w->name, watcher->name) == 0) {
+			mutex_unlock(&ebt_mutex);
+			return -EEXIST;
+		}
 	}
+	list_add(&watcher->list, &ebt_watchers);
 	mutex_unlock(&ebt_mutex);
 
 	return 0;
@@ -1106,13 +1117,14 @@ int ebt_register_watcher(struct ebt_watc
 void ebt_unregister_watcher(struct ebt_watcher *watcher)
 {
 	mutex_lock(&ebt_mutex);
-	LIST_DELETE(&ebt_watchers, watcher);
+	list_del(&watcher->list);
 	mutex_unlock(&ebt_mutex);
 }
 
 int ebt_register_table(struct ebt_table *table)
 {
 	struct ebt_table_info *newinfo;
+	struct ebt_table *t;
 	int ret, i, countersize;
 
 	if (!table || !table->table ||!table->table->entries ||
@@ -1158,10 +1170,12 @@ int ebt_register_table(struct ebt_table 
 	if (ret != 0)
 		goto free_chainstack;
 
-	if (list_named_find(&ebt_tables, table->name)) {
-		ret = -EEXIST;
-		BUGPRINT("Table name already exists\n");
-		goto free_unlock;
+	list_for_each_entry(t, &ebt_tables, list) {
+		if (strcmp(t->name, table->name) == 0) {
+			ret = -EEXIST;
+			BUGPRINT("Table name already exists\n");
+			goto free_unlock;
+		}
 	}
 
 	/* Hold a reference count if the chains aren't empty */
@@ -1169,7 +1183,7 @@ int ebt_register_table(struct ebt_table 
 		ret = -ENOENT;
 		goto free_unlock;
 	}
-	list_prepend(&ebt_tables, table);
+	list_add(&table->list, &ebt_tables);
 	mutex_unlock(&ebt_mutex);
 	return 0;
 free_unlock:
@@ -1195,7 +1209,7 @@ void ebt_unregister_table(struct ebt_tab
 		return;
 	}
 	mutex_lock(&ebt_mutex);
-	LIST_DELETE(&ebt_tables, table);
+	list_del(&table->list);
 	mutex_unlock(&ebt_mutex);
 	vfree(table->private->entries);
 	if (table->private->chainstack) {
@@ -1465,7 +1479,7 @@ static int __init ebtables_init(void)
 	int ret;
 
 	mutex_lock(&ebt_mutex);
-	list_named_insert(&ebt_targets, &ebt_standard_target);
+	list_add(&ebt_standard_target.list, &ebt_targets);
 	mutex_unlock(&ebt_mutex);
 	if ((ret = nf_register_sockopt(&ebt_sockopts)) < 0)
 		return ret;
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 4f10b06..aaeaa9c 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -56,8 +56,6 @@ #else
 #define ARP_NF_ASSERT(x)
 #endif
 
-#include <linux/netfilter_ipv4/listhelp.h>
-
 static inline int arp_devaddr_compare(const struct arpt_devaddr_info *ap,
 				      char *hdr_addr, int len)
 {
diff --git a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
index 5da25ad..2568d48 100644
--- a/net/ipv4/netfilter/ip_conntrack_core.c
+++ b/net/ipv4/netfilter/ip_conntrack_core.c
@@ -47,7 +47,6 @@ #include <linux/netfilter_ipv4/ip_conntr
 #include <linux/netfilter_ipv4/ip_conntrack_protocol.h>
 #include <linux/netfilter_ipv4/ip_conntrack_helper.h>
 #include <linux/netfilter_ipv4/ip_conntrack_core.h>
-#include <linux/netfilter_ipv4/listhelp.h>
 
 #define IP_CONNTRACK_VERSION	"2.4"
 
@@ -294,15 +293,10 @@ void ip_ct_remove_expectations(struct ip
 static void
 clean_from_lists(struct ip_conntrack *ct)
 {
-	unsigned int ho, hr;
-	
 	DEBUGP("clean_from_lists(%p)\n", ct);
 	ASSERT_WRITE_LOCK(&ip_conntrack_lock);
-
-	ho = hash_conntrack(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
-	hr = hash_conntrack(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
-	LIST_DELETE(&ip_conntrack_hash[ho], &ct->tuplehash[IP_CT_DIR_ORIGINAL]);
-	LIST_DELETE(&ip_conntrack_hash[hr], &ct->tuplehash[IP_CT_DIR_REPLY]);
+	list_del(&ct->tuplehash[IP_CT_DIR_ORIGINAL].list);
+	list_del(&ct->tuplehash[IP_CT_DIR_REPLY].list);
 
 	/* Destroy all pending expectations */
 	ip_ct_remove_expectations(ct);
@@ -367,16 +361,6 @@ static void death_by_timeout(unsigned lo
 	ip_conntrack_put(ct);
 }
 
-static inline int
-conntrack_tuple_cmp(const struct ip_conntrack_tuple_hash *i,
-		    const struct ip_conntrack_tuple *tuple,
-		    const struct ip_conntrack *ignored_conntrack)
-{
-	ASSERT_READ_LOCK(&ip_conntrack_lock);
-	return tuplehash_to_ctrack(i) != ignored_conntrack
-		&& ip_ct_tuple_equal(tuple, &i->tuple);
-}
-
 struct ip_conntrack_tuple_hash *
 __ip_conntrack_find(const struct ip_conntrack_tuple *tuple,
 		    const struct ip_conntrack *ignored_conntrack)
@@ -386,7 +370,8 @@ __ip_conntrack_find(const struct ip_conn
 
 	ASSERT_READ_LOCK(&ip_conntrack_lock);
 	list_for_each_entry(h, &ip_conntrack_hash[hash], list) {
-		if (conntrack_tuple_cmp(h, tuple, ignored_conntrack)) {
+		if (tuplehash_to_ctrack(h) != ignored_conntrack &&
+		    ip_ct_tuple_equal(tuple, &h->tuple)) {
 			CONNTRACK_STAT_INC(found);
 			return h;
 		}
@@ -417,10 +402,10 @@ static void __ip_conntrack_hash_insert(s
 					unsigned int repl_hash) 
 {
 	ct->id = ++ip_conntrack_next_id;
-	list_prepend(&ip_conntrack_hash[hash],
-		     &ct->tuplehash[IP_CT_DIR_ORIGINAL].list);
-	list_prepend(&ip_conntrack_hash[repl_hash],
-		     &ct->tuplehash[IP_CT_DIR_REPLY].list);
+	list_add(&ct->tuplehash[IP_CT_DIR_ORIGINAL].list,
+		 &ip_conntrack_hash[hash]);
+	list_add(&ct->tuplehash[IP_CT_DIR_REPLY].list,
+		 &ip_conntrack_hash[repl_hash]);
 }
 
 void ip_conntrack_hash_insert(struct ip_conntrack *ct)
@@ -440,6 +425,7 @@ int
 __ip_conntrack_confirm(struct sk_buff **pskb)
 {
 	unsigned int hash, repl_hash;
+	struct ip_conntrack_tuple_hash *h;
 	struct ip_conntrack *ct;
 	enum ip_conntrack_info ctinfo;
 
@@ -470,43 +456,43 @@ __ip_conntrack_confirm(struct sk_buff **
 	/* See if there's one in the list already, including reverse:
            NAT could have grabbed it without realizing, since we're
            not in the hash.  If there is, we lost race. */
-	if (!LIST_FIND(&ip_conntrack_hash[hash],
-		       conntrack_tuple_cmp,
-		       struct ip_conntrack_tuple_hash *,
-		       &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple, NULL)
-	    && !LIST_FIND(&ip_conntrack_hash[repl_hash],
-			  conntrack_tuple_cmp,
-			  struct ip_conntrack_tuple_hash *,
-			  &ct->tuplehash[IP_CT_DIR_REPLY].tuple, NULL)) {
-		/* Remove from unconfirmed list */
-		list_del(&ct->tuplehash[IP_CT_DIR_ORIGINAL].list);
+	list_for_each_entry(h, &ip_conntrack_hash[hash], list)
+		if (ip_ct_tuple_equal(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
+				      &h->tuple))
+			goto out;
+	list_for_each_entry(h, &ip_conntrack_hash[repl_hash], list)
+		if (ip_ct_tuple_equal(&ct->tuplehash[IP_CT_DIR_REPLY].tuple,
+				      &h->tuple))
+			goto out;
 
-		__ip_conntrack_hash_insert(ct, hash, repl_hash);
-		/* Timer relative to confirmation time, not original
-		   setting time, otherwise we'd get timer wrap in
-		   weird delay cases. */
-		ct->timeout.expires += jiffies;
-		add_timer(&ct->timeout);
-		atomic_inc(&ct->ct_general.use);
-		set_bit(IPS_CONFIRMED_BIT, &ct->status);
-		CONNTRACK_STAT_INC(insert);
-		write_unlock_bh(&ip_conntrack_lock);
-		if (ct->helper)
-			ip_conntrack_event_cache(IPCT_HELPER, *pskb);
+	/* Remove from unconfirmed list */
+	list_del(&ct->tuplehash[IP_CT_DIR_ORIGINAL].list);
+
+	__ip_conntrack_hash_insert(ct, hash, repl_hash);
+	/* Timer relative to confirmation time, not original
+	   setting time, otherwise we'd get timer wrap in
+	   weird delay cases. */
+	ct->timeout.expires += jiffies;
+	add_timer(&ct->timeout);
+	atomic_inc(&ct->ct_general.use);
+	set_bit(IPS_CONFIRMED_BIT, &ct->status);
+	CONNTRACK_STAT_INC(insert);
+	write_unlock_bh(&ip_conntrack_lock);
+	if (ct->helper)
+		ip_conntrack_event_cache(IPCT_HELPER, *pskb);
 #ifdef CONFIG_IP_NF_NAT_NEEDED
-		if (test_bit(IPS_SRC_NAT_DONE_BIT, &ct->status) ||
-		    test_bit(IPS_DST_NAT_DONE_BIT, &ct->status))
-			ip_conntrack_event_cache(IPCT_NATINFO, *pskb);
+	if (test_bit(IPS_SRC_NAT_DONE_BIT, &ct->status) ||
+	    test_bit(IPS_DST_NAT_DONE_BIT, &ct->status))
+		ip_conntrack_event_cache(IPCT_NATINFO, *pskb);
 #endif
-		ip_conntrack_event_cache(master_ct(ct) ?
-					 IPCT_RELATED : IPCT_NEW, *pskb);
+	ip_conntrack_event_cache(master_ct(ct) ?
+				 IPCT_RELATED : IPCT_NEW, *pskb);
 
-		return NF_ACCEPT;
-	}
+	return NF_ACCEPT;
 
+out:
 	CONNTRACK_STAT_INC(insert_failed);
 	write_unlock_bh(&ip_conntrack_lock);
-
 	return NF_DROP;
 }
 
@@ -527,23 +513,21 @@ ip_conntrack_tuple_taken(const struct ip
 
 /* There's a small race here where we may free a just-assured
    connection.  Too bad: we're in trouble anyway. */
-static inline int unreplied(const struct ip_conntrack_tuple_hash *i)
-{
-	return !(test_bit(IPS_ASSURED_BIT, &tuplehash_to_ctrack(i)->status));
-}
-
 static int early_drop(struct list_head *chain)
 {
 	/* Traverse backwards: gives us oldest, which is roughly LRU */
 	struct ip_conntrack_tuple_hash *h;
-	struct ip_conntrack *ct = NULL;
+	struct ip_conntrack *ct = NULL, *tmp;
 	int dropped = 0;
 
 	read_lock_bh(&ip_conntrack_lock);
-	h = LIST_FIND_B(chain, unreplied, struct ip_conntrack_tuple_hash *);
-	if (h) {
-		ct = tuplehash_to_ctrack(h);
-		atomic_inc(&ct->ct_general.use);
+	list_for_each_entry_reverse(h, chain, list) {
+		tmp = tuplehash_to_ctrack(h);
+		if (!test_bit(IPS_ASSURED_BIT, &tmp->status)) {
+			ct = tmp;
+			atomic_inc(&ct->ct_general.use);
+			break;
+		}
 	}
 	read_unlock_bh(&ip_conntrack_lock);
 
@@ -559,18 +543,16 @@ static int early_drop(struct list_head *
 	return dropped;
 }
 
-static inline int helper_cmp(const struct ip_conntrack_helper *i,
-			     const struct ip_conntrack_tuple *rtuple)
-{
-	return ip_ct_tuple_mask_cmp(rtuple, &i->tuple, &i->mask);
-}
-
 static struct ip_conntrack_helper *
 __ip_conntrack_helper_find( const struct ip_conntrack_tuple *tuple)
 {
-	return LIST_FIND(&helpers, helper_cmp,
-			 struct ip_conntrack_helper *,
-			 tuple);
+	struct ip_conntrack_helper *h;
+
+	list_for_each_entry(h, &helpers, list) {
+		if (ip_ct_tuple_mask_cmp(tuple, &h->tuple, &h->mask))
+			return h;
+	}
+	return NULL;
 }
 
 struct ip_conntrack_helper *
@@ -1062,7 +1044,7 @@ int ip_conntrack_helper_register(struct 
 {
 	BUG_ON(me->timeout == 0);
 	write_lock_bh(&ip_conntrack_lock);
-	list_prepend(&helpers, me);
+	list_add(&me->list, &helpers);
 	write_unlock_bh(&ip_conntrack_lock);
 
 	return 0;
@@ -1081,24 +1063,24 @@ __ip_conntrack_helper_find_byname(const 
 	return NULL;
 }
 
-static inline int unhelp(struct ip_conntrack_tuple_hash *i,
-			 const struct ip_conntrack_helper *me)
+static inline void unhelp(struct ip_conntrack_tuple_hash *i,
+			  const struct ip_conntrack_helper *me)
 {
 	if (tuplehash_to_ctrack(i)->helper == me) {
  		ip_conntrack_event(IPCT_HELPER, tuplehash_to_ctrack(i));
 		tuplehash_to_ctrack(i)->helper = NULL;
 	}
-	return 0;
 }
 
 void ip_conntrack_helper_unregister(struct ip_conntrack_helper *me)
 {
 	unsigned int i;
+	struct ip_conntrack_tuple_hash *h;
 	struct ip_conntrack_expect *exp, *tmp;
 
 	/* Need write lock here, to delete helper. */
 	write_lock_bh(&ip_conntrack_lock);
-	LIST_DELETE(&helpers, me);
+	list_del(&me->list);
 
 	/* Get rid of expectations */
 	list_for_each_entry_safe(exp, tmp, &ip_conntrack_expect_list, list) {
@@ -1108,10 +1090,12 @@ void ip_conntrack_helper_unregister(stru
 		}
 	}
 	/* Get rid of expecteds, set helpers to NULL. */
-	LIST_FIND_W(&unconfirmed, unhelp, struct ip_conntrack_tuple_hash*, me);
-	for (i = 0; i < ip_conntrack_htable_size; i++)
-		LIST_FIND_W(&ip_conntrack_hash[i], unhelp,
-			    struct ip_conntrack_tuple_hash *, me);
+	list_for_each_entry(h, &unconfirmed, list)
+		unhelp(h, me);
+	for (i = 0; i < ip_conntrack_htable_size; i++) {
+		list_for_each_entry(h, &ip_conntrack_hash[i], list)
+			unhelp(h, me);
+	}
 	write_unlock_bh(&ip_conntrack_lock);
 
 	/* Someone could be still looking at the helper in a bh. */
@@ -1237,46 +1221,43 @@ static void ip_conntrack_attach(struct s
 	nf_conntrack_get(nskb->nfct);
 }
 
-static inline int
-do_iter(const struct ip_conntrack_tuple_hash *i,
-	int (*iter)(struct ip_conntrack *i, void *data),
-	void *data)
-{
-	return iter(tuplehash_to_ctrack(i), data);
-}
-
 /* Bring out ya dead! */
-static struct ip_conntrack_tuple_hash *
+static struct ip_conntrack *
 get_next_corpse(int (*iter)(struct ip_conntrack *i, void *data),
 		void *data, unsigned int *bucket)
 {
-	struct ip_conntrack_tuple_hash *h = NULL;
+	struct ip_conntrack_tuple_hash *h;
+	struct ip_conntrack *ct;
 
 	write_lock_bh(&ip_conntrack_lock);
 	for (; *bucket < ip_conntrack_htable_size; (*bucket)++) {
-		h = LIST_FIND_W(&ip_conntrack_hash[*bucket], do_iter,
-				struct ip_conntrack_tuple_hash *, iter, data);
-		if (h)
-			break;
+		list_for_each_entry(h, &ip_conntrack_hash[*bucket], list) {
+			ct = tuplehash_to_ctrack(h);
+			if (iter(ct, data))
+				goto found;
+		}
+	}
+	list_for_each_entry(h, &unconfirmed, list) {
+		ct = tuplehash_to_ctrack(h);
+		if (iter(ct, data))
+			goto found;
 	}
-	if (!h)
-		h = LIST_FIND_W(&unconfirmed, do_iter,
-				struct ip_conntrack_tuple_hash *, iter, data);
-	if (h)
-		atomic_inc(&tuplehash_to_ctrack(h)->ct_general.use);
 	write_unlock_bh(&ip_conntrack_lock);
+	return NULL;
 
-	return h;
+found:
+	atomic_inc(&ct->ct_general.use);
+	write_unlock_bh(&ip_conntrack_lock);
+	return ct;
 }
 
 void
 ip_ct_iterate_cleanup(int (*iter)(struct ip_conntrack *i, void *), void *data)
 {
-	struct ip_conntrack_tuple_hash *h;
+	struct ip_conntrack *ct;
 	unsigned int bucket = 0;
 
-	while ((h = get_next_corpse(iter, data, &bucket)) != NULL) {
-		struct ip_conntrack *ct = tuplehash_to_ctrack(h);
+	while ((ct = get_next_corpse(iter, data, &bucket)) != NULL) {
 		/* Time to push up daises... */
 		if (del_timer(&ct->timeout))
 			death_by_timeout((unsigned long)ct);
diff --git a/net/ipv4/netfilter/ip_conntrack_proto_gre.c b/net/ipv4/netfilter/ip_conntrack_proto_gre.c
index 4ee016c..92c6d8b 100644
--- a/net/ipv4/netfilter/ip_conntrack_proto_gre.c
+++ b/net/ipv4/netfilter/ip_conntrack_proto_gre.c
@@ -37,7 +37,6 @@ static DEFINE_RWLOCK(ip_ct_gre_lock);
 #define ASSERT_READ_LOCK(x)
 #define ASSERT_WRITE_LOCK(x)
 
-#include <linux/netfilter_ipv4/listhelp.h>
 #include <linux/netfilter_ipv4/ip_conntrack_protocol.h>
 #include <linux/netfilter_ipv4/ip_conntrack_helper.h>
 #include <linux/netfilter_ipv4/ip_conntrack_core.h>
@@ -82,10 +81,12 @@ static __be16 gre_keymap_lookup(struct i
 	__be16 key = 0;
 
 	read_lock_bh(&ip_ct_gre_lock);
-	km = LIST_FIND(&gre_keymap_list, gre_key_cmpfn,
-			struct ip_ct_gre_keymap *, t);
-	if (km)
-		key = km->tuple.src.u.gre.key;
+	list_for_each_entry(km, &gre_keymap_list, list) {
+		if (gre_key_cmpfn(km, t)) {
+			key = km->tuple.src.u.gre.key;
+			break;
+		}
+	}
 	read_unlock_bh(&ip_ct_gre_lock);
 	
 	DEBUGP("lookup src key 0x%x up key for ", key);
@@ -99,7 +100,7 @@ int
 ip_ct_gre_keymap_add(struct ip_conntrack *ct,
 		     struct ip_conntrack_tuple *t, int reply)
 {
-	struct ip_ct_gre_keymap **exist_km, *km, *old;
+	struct ip_ct_gre_keymap **exist_km, *km;
 
 	if (!ct->helper || strcmp(ct->helper->name, "pptp")) {
 		DEBUGP("refusing to add GRE keymap to non-pptp session\n");
@@ -113,13 +114,10 @@ ip_ct_gre_keymap_add(struct ip_conntrack
 
 	if (*exist_km) {
 		/* check whether it's a retransmission */
-		old = LIST_FIND(&gre_keymap_list, gre_key_cmpfn,
-				struct ip_ct_gre_keymap *, t);
-		if (old == *exist_km) {
-			DEBUGP("retransmission\n");
-			return 0;
+		list_for_each_entry(km, &gre_keymap_list, list) {
+			if (gre_key_cmpfn(km, t) && km == *exist_km)
+				return 0;
 		}
-
 		DEBUGP("trying to override keymap_%s for ct %p\n", 
 			reply? "reply":"orig", ct);
 		return -EEXIST;
@@ -136,7 +134,7 @@ ip_ct_gre_keymap_add(struct ip_conntrack
 	DUMP_TUPLE_GRE(&km->tuple);
 
 	write_lock_bh(&ip_ct_gre_lock);
-	list_append(&gre_keymap_list, km);
+	list_add_tail(&km->list, &gre_keymap_list);
 	write_unlock_bh(&ip_ct_gre_lock);
 
 	return 0;
diff --git a/net/ipv4/netfilter/ip_conntrack_standalone.c b/net/ipv4/netfilter/ip_conntrack_standalone.c
index 3f5d495..0213575 100644
--- a/net/ipv4/netfilter/ip_conntrack_standalone.c
+++ b/net/ipv4/netfilter/ip_conntrack_standalone.c
@@ -35,7 +35,6 @@ #include <linux/netfilter_ipv4/ip_conntr
 #include <linux/netfilter_ipv4/ip_conntrack_protocol.h>
 #include <linux/netfilter_ipv4/ip_conntrack_core.h>
 #include <linux/netfilter_ipv4/ip_conntrack_helper.h>
-#include <linux/netfilter_ipv4/listhelp.h>
 
 #if 0
 #define DEBUGP printk
diff --git a/net/ipv4/netfilter/ip_nat_core.c b/net/ipv4/netfilter/ip_nat_core.c
index 4c540d0..71f3e09 100644
--- a/net/ipv4/netfilter/ip_nat_core.c
+++ b/net/ipv4/netfilter/ip_nat_core.c
@@ -22,9 +22,6 @@ #include <linux/icmp.h>
 #include <linux/udp.h>
 #include <linux/jhash.h>
 
-#define ASSERT_READ_LOCK(x)
-#define ASSERT_WRITE_LOCK(x)
-
 #include <linux/netfilter_ipv4/ip_conntrack.h>
 #include <linux/netfilter_ipv4/ip_conntrack_core.h>
 #include <linux/netfilter_ipv4/ip_conntrack_protocol.h>
@@ -33,7 +30,6 @@ #include <linux/netfilter_ipv4/ip_nat_pr
 #include <linux/netfilter_ipv4/ip_nat_core.h>
 #include <linux/netfilter_ipv4/ip_nat_helper.h>
 #include <linux/netfilter_ipv4/ip_conntrack_helper.h>
-#include <linux/netfilter_ipv4/listhelp.h>
 
 #if 0
 #define DEBUGP printk
diff --git a/net/ipv4/netfilter/ip_nat_helper.c b/net/ipv4/netfilter/ip_nat_helper.c
index 021c3da..7f6a759 100644
--- a/net/ipv4/netfilter/ip_nat_helper.c
+++ b/net/ipv4/netfilter/ip_nat_helper.c
@@ -27,16 +27,12 @@ #include <net/ip.h>
 #include <net/tcp.h>
 #include <net/udp.h>
 
-#define ASSERT_READ_LOCK(x)
-#define ASSERT_WRITE_LOCK(x)
-
 #include <linux/netfilter_ipv4/ip_conntrack.h>
 #include <linux/netfilter_ipv4/ip_conntrack_helper.h>
 #include <linux/netfilter_ipv4/ip_nat.h>
 #include <linux/netfilter_ipv4/ip_nat_protocol.h>
 #include <linux/netfilter_ipv4/ip_nat_core.h>
 #include <linux/netfilter_ipv4/ip_nat_helper.h>
-#include <linux/netfilter_ipv4/listhelp.h>
 
 #if 0
 #define DEBUGP printk
diff --git a/net/ipv4/netfilter/ip_nat_rule.c b/net/ipv4/netfilter/ip_nat_rule.c
index e59f5a8..7b70383 100644
--- a/net/ipv4/netfilter/ip_nat_rule.c
+++ b/net/ipv4/netfilter/ip_nat_rule.c
@@ -19,14 +19,10 @@ #include <net/checksum.h>
 #include <net/route.h>
 #include <linux/bitops.h>
 
-#define ASSERT_READ_LOCK(x)
-#define ASSERT_WRITE_LOCK(x)
-
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ip_nat.h>
 #include <linux/netfilter_ipv4/ip_nat_core.h>
 #include <linux/netfilter_ipv4/ip_nat_rule.h>
-#include <linux/netfilter_ipv4/listhelp.h>
 
 #if 0
 #define DEBUGP printk
diff --git a/net/ipv4/netfilter/ip_nat_standalone.c b/net/ipv4/netfilter/ip_nat_standalone.c
index f3b7783..9c577db 100644
--- a/net/ipv4/netfilter/ip_nat_standalone.c
+++ b/net/ipv4/netfilter/ip_nat_standalone.c
@@ -30,9 +30,6 @@ #include <net/ip.h>
 #include <net/checksum.h>
 #include <linux/spinlock.h>
 
-#define ASSERT_READ_LOCK(x)
-#define ASSERT_WRITE_LOCK(x)
-
 #include <linux/netfilter_ipv4/ip_nat.h>
 #include <linux/netfilter_ipv4/ip_nat_rule.h>
 #include <linux/netfilter_ipv4/ip_nat_protocol.h>
@@ -40,7 +37,6 @@ #include <linux/netfilter_ipv4/ip_nat_co
 #include <linux/netfilter_ipv4/ip_nat_helper.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ip_conntrack_core.h>
-#include <linux/netfilter_ipv4/listhelp.h>
 
 #if 0
 #define DEBUGP printk
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index d1c3153..73d477c 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -70,9 +70,6 @@ #else
 #define IP_NF_ASSERT(x)
 #endif
 
-
-#include <linux/netfilter_ipv4/listhelp.h>
-
 #if 0
 /* All the better to debug you with... */
 #define static
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 3b64dbe..927137b 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -57,7 +57,6 @@ #include <net/netfilter/nf_conntrack_l3p
 #include <net/netfilter/nf_conntrack_protocol.h>
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <net/netfilter/nf_conntrack_core.h>
-#include <linux/netfilter_ipv4/listhelp.h>
 
 #define NF_CONNTRACK_VERSION	"0.5.0"
 
@@ -539,15 +538,10 @@ void nf_ct_remove_expectations(struct nf
 static void
 clean_from_lists(struct nf_conn *ct)
 {
-	unsigned int ho, hr;
-	
 	DEBUGP("clean_from_lists(%p)\n", ct);
 	ASSERT_WRITE_LOCK(&nf_conntrack_lock);
-
-	ho = hash_conntrack(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
-	hr = hash_conntrack(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
-	LIST_DELETE(&nf_conntrack_hash[ho], &ct->tuplehash[IP_CT_DIR_ORIGINAL]);
-	LIST_DELETE(&nf_conntrack_hash[hr], &ct->tuplehash[IP_CT_DIR_REPLY]);
+	list_del(&ct->tuplehash[IP_CT_DIR_ORIGINAL].list);
+	list_del(&ct->tuplehash[IP_CT_DIR_REPLY].list);
 
 	/* Destroy all pending expectations */
 	nf_ct_remove_expectations(ct);
@@ -617,16 +611,6 @@ static void death_by_timeout(unsigned lo
 	nf_ct_put(ct);
 }
 
-static inline int
-conntrack_tuple_cmp(const struct nf_conntrack_tuple_hash *i,
-		    const struct nf_conntrack_tuple *tuple,
-		    const struct nf_conn *ignored_conntrack)
-{
-	ASSERT_READ_LOCK(&nf_conntrack_lock);
-	return nf_ct_tuplehash_to_ctrack(i) != ignored_conntrack
-		&& nf_ct_tuple_equal(tuple, &i->tuple);
-}
-
 struct nf_conntrack_tuple_hash *
 __nf_conntrack_find(const struct nf_conntrack_tuple *tuple,
 		    const struct nf_conn *ignored_conntrack)
@@ -636,7 +620,8 @@ __nf_conntrack_find(const struct nf_conn
 
 	ASSERT_READ_LOCK(&nf_conntrack_lock);
 	list_for_each_entry(h, &nf_conntrack_hash[hash], list) {
-		if (conntrack_tuple_cmp(h, tuple, ignored_conntrack)) {
+		if (nf_ct_tuplehash_to_ctrack(h) != ignored_conntrack &&
+		    nf_ct_tuple_equal(tuple, &h->tuple)) {
 			NF_CT_STAT_INC(found);
 			return h;
 		}
@@ -667,10 +652,10 @@ static void __nf_conntrack_hash_insert(s
 				       unsigned int repl_hash) 
 {
 	ct->id = ++nf_conntrack_next_id;
-	list_prepend(&nf_conntrack_hash[hash],
-		     &ct->tuplehash[IP_CT_DIR_ORIGINAL].list);
-	list_prepend(&nf_conntrack_hash[repl_hash],
-		     &ct->tuplehash[IP_CT_DIR_REPLY].list);
+	list_add(&ct->tuplehash[IP_CT_DIR_ORIGINAL].list,
+		 &nf_conntrack_hash[hash]);
+	list_add(&ct->tuplehash[IP_CT_DIR_REPLY].list,
+		 &nf_conntrack_hash[repl_hash]);
 }
 
 void nf_conntrack_hash_insert(struct nf_conn *ct)
@@ -690,7 +675,9 @@ int
 __nf_conntrack_confirm(struct sk_buff **pskb)
 {
 	unsigned int hash, repl_hash;
+	struct nf_conntrack_tuple_hash *h;
 	struct nf_conn *ct;
+	struct nf_conn_help *help;
 	enum ip_conntrack_info ctinfo;
 
 	ct = nf_ct_get(*pskb, &ctinfo);
@@ -720,41 +707,41 @@ __nf_conntrack_confirm(struct sk_buff **
 	/* See if there's one in the list already, including reverse:
 	   NAT could have grabbed it without realizing, since we're
 	   not in the hash.  If there is, we lost race. */
-	if (!LIST_FIND(&nf_conntrack_hash[hash],
-		       conntrack_tuple_cmp,
-		       struct nf_conntrack_tuple_hash *,
-		       &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple, NULL)
-	    && !LIST_FIND(&nf_conntrack_hash[repl_hash],
-			  conntrack_tuple_cmp,
-			  struct nf_conntrack_tuple_hash *,
-			  &ct->tuplehash[IP_CT_DIR_REPLY].tuple, NULL)) {
-		struct nf_conn_help *help;
-		/* Remove from unconfirmed list */
-		list_del(&ct->tuplehash[IP_CT_DIR_ORIGINAL].list);
+	list_for_each_entry(h, &nf_conntrack_hash[hash], list)
+		if (nf_ct_tuple_equal(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
+				      &h->tuple))
+			goto out;
+	list_for_each_entry(h, &nf_conntrack_hash[repl_hash], list)
+		if (nf_ct_tuple_equal(&ct->tuplehash[IP_CT_DIR_REPLY].tuple,
+				      &h->tuple))
+			goto out;
 
-		__nf_conntrack_hash_insert(ct, hash, repl_hash);
-		/* Timer relative to confirmation time, not original
-		   setting time, otherwise we'd get timer wrap in
-		   weird delay cases. */
-		ct->timeout.expires += jiffies;
-		add_timer(&ct->timeout);
-		atomic_inc(&ct->ct_general.use);
-		set_bit(IPS_CONFIRMED_BIT, &ct->status);
-		NF_CT_STAT_INC(insert);
-		write_unlock_bh(&nf_conntrack_lock);
-		help = nfct_help(ct);
-		if (help && help->helper)
-			nf_conntrack_event_cache(IPCT_HELPER, *pskb);
+	/* Remove from unconfirmed list */
+	list_del(&ct->tuplehash[IP_CT_DIR_ORIGINAL].list);
+
+	__nf_conntrack_hash_insert(ct, hash, repl_hash);
+	/* Timer relative to confirmation time, not original
+	   setting time, otherwise we'd get timer wrap in
+	   weird delay cases. */
+	ct->timeout.expires += jiffies;
+	add_timer(&ct->timeout);
+	atomic_inc(&ct->ct_general.use);
+	set_bit(IPS_CONFIRMED_BIT, &ct->status);
+	NF_CT_STAT_INC(insert);
+	write_unlock_bh(&nf_conntrack_lock);
+	help = nfct_help(ct);
+	if (help && help->helper)
+		nf_conntrack_event_cache(IPCT_HELPER, *pskb);
 #ifdef CONFIG_NF_NAT_NEEDED
-		if (test_bit(IPS_SRC_NAT_DONE_BIT, &ct->status) ||
-		    test_bit(IPS_DST_NAT_DONE_BIT, &ct->status))
-			nf_conntrack_event_cache(IPCT_NATINFO, *pskb);
+	if (test_bit(IPS_SRC_NAT_DONE_BIT, &ct->status) ||
+	    test_bit(IPS_DST_NAT_DONE_BIT, &ct->status))
+		nf_conntrack_event_cache(IPCT_NATINFO, *pskb);
 #endif
-		nf_conntrack_event_cache(master_ct(ct) ?
-					 IPCT_RELATED : IPCT_NEW, *pskb);
-		return NF_ACCEPT;
-	}
+	nf_conntrack_event_cache(master_ct(ct) ?
+				 IPCT_RELATED : IPCT_NEW, *pskb);
+	return NF_ACCEPT;
 
+out:
 	NF_CT_STAT_INC(insert_failed);
 	write_unlock_bh(&nf_conntrack_lock);
 	return NF_DROP;
@@ -777,24 +764,21 @@ nf_conntrack_tuple_taken(const struct nf
 
 /* There's a small race here where we may free a just-assured
    connection.  Too bad: we're in trouble anyway. */
-static inline int unreplied(const struct nf_conntrack_tuple_hash *i)
-{
-	return !(test_bit(IPS_ASSURED_BIT,
-			  &nf_ct_tuplehash_to_ctrack(i)->status));
-}
-
 static int early_drop(struct list_head *chain)
 {
 	/* Traverse backwards: gives us oldest, which is roughly LRU */
 	struct nf_conntrack_tuple_hash *h;
-	struct nf_conn *ct = NULL;
+	struct nf_conn *ct = NULL, *tmp;
 	int dropped = 0;
 
 	read_lock_bh(&nf_conntrack_lock);
-	h = LIST_FIND_B(chain, unreplied, struct nf_conntrack_tuple_hash *);
-	if (h) {
-		ct = nf_ct_tuplehash_to_ctrack(h);
-		atomic_inc(&ct->ct_general.use);
+	list_for_each_entry_reverse(h, chain, list) {
+		tmp = nf_ct_tuplehash_to_ctrack(h);
+		if (!test_bit(IPS_ASSURED_BIT, &tmp->status)) {
+			ct = tmp;
+			atomic_inc(&ct->ct_general.use);
+			break;
+		}
 	}
 	read_unlock_bh(&nf_conntrack_lock);
 
@@ -810,18 +794,16 @@ static int early_drop(struct list_head *
 	return dropped;
 }
 
-static inline int helper_cmp(const struct nf_conntrack_helper *i,
-			     const struct nf_conntrack_tuple *rtuple)
-{
-	return nf_ct_tuple_mask_cmp(rtuple, &i->tuple, &i->mask);
-}
-
 static struct nf_conntrack_helper *
 __nf_ct_helper_find(const struct nf_conntrack_tuple *tuple)
 {
-	return LIST_FIND(&helpers, helper_cmp,
-			 struct nf_conntrack_helper *,
-			 tuple);
+	struct nf_conntrack_helper *h;
+
+	list_for_each_entry(h, &helpers, list) {
+		if (nf_ct_tuple_mask_cmp(tuple, &h->tuple, &h->mask))
+			return h;
+	}
+	return NULL;
 }
 
 struct nf_conntrack_helper *
@@ -1323,7 +1305,7 @@ int nf_conntrack_helper_register(struct 
 		return ret;
 	}
 	write_lock_bh(&nf_conntrack_lock);
-	list_prepend(&helpers, me);
+	list_add(&me->list, &helpers);
 	write_unlock_bh(&nf_conntrack_lock);
 
 	return 0;
@@ -1342,8 +1324,8 @@ __nf_conntrack_helper_find_byname(const 
 	return NULL;
 }
 
-static inline int unhelp(struct nf_conntrack_tuple_hash *i,
-			 const struct nf_conntrack_helper *me)
+static inline void unhelp(struct nf_conntrack_tuple_hash *i,
+			  const struct nf_conntrack_helper *me)
 {
 	struct nf_conn *ct = nf_ct_tuplehash_to_ctrack(i);
 	struct nf_conn_help *help = nfct_help(ct);
@@ -1352,17 +1334,17 @@ static inline int unhelp(struct nf_connt
 		nf_conntrack_event(IPCT_HELPER, ct);
 		help->helper = NULL;
 	}
-	return 0;
 }
 
 void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
 {
 	unsigned int i;
+	struct nf_conntrack_tuple_hash *h;
 	struct nf_conntrack_expect *exp, *tmp;
 
 	/* Need write lock here, to delete helper. */
 	write_lock_bh(&nf_conntrack_lock);
-	LIST_DELETE(&helpers, me);
+	list_del(&me->list);
 
 	/* Get rid of expectations */
 	list_for_each_entry_safe(exp, tmp, &nf_conntrack_expect_list, list) {
@@ -1374,10 +1356,12 @@ void nf_conntrack_helper_unregister(stru
 	}
 
 	/* Get rid of expecteds, set helpers to NULL. */
-	LIST_FIND_W(&unconfirmed, unhelp, struct nf_conntrack_tuple_hash*, me);
-	for (i = 0; i < nf_conntrack_htable_size; i++)
-		LIST_FIND_W(&nf_conntrack_hash[i], unhelp,
-			    struct nf_conntrack_tuple_hash *, me);
+	list_for_each_entry(h, &unconfirmed, list)
+		unhelp(h, me);
+	for (i = 0; i < nf_conntrack_htable_size; i++) {
+		list_for_each_entry(h, &nf_conntrack_hash[i], list)
+			unhelp(h, me);
+	}
 	write_unlock_bh(&nf_conntrack_lock);
 
 	/* Someone could be still looking at the helper in a bh. */
@@ -1510,37 +1494,40 @@ do_iter(const struct nf_conntrack_tuple_
 }
 
 /* Bring out ya dead! */
-static struct nf_conntrack_tuple_hash *
+static struct nf_conn *
 get_next_corpse(int (*iter)(struct nf_conn *i, void *data),
 		void *data, unsigned int *bucket)
 {
-	struct nf_conntrack_tuple_hash *h = NULL;
+	struct nf_conntrack_tuple_hash *h;
+	struct nf_conn *ct;
 
 	write_lock_bh(&nf_conntrack_lock);
 	for (; *bucket < nf_conntrack_htable_size; (*bucket)++) {
-		h = LIST_FIND_W(&nf_conntrack_hash[*bucket], do_iter,
-				struct nf_conntrack_tuple_hash *, iter, data);
-		if (h)
-			break;
+		list_for_each_entry(h, &nf_conntrack_hash[*bucket], list) {
+			ct = nf_ct_tuplehash_to_ctrack(h);
+			if (iter(ct, data))
+				goto found;
+		}
  	}
-	if (!h)
-		h = LIST_FIND_W(&unconfirmed, do_iter,
-				struct nf_conntrack_tuple_hash *, iter, data);
-	if (h)
-		atomic_inc(&nf_ct_tuplehash_to_ctrack(h)->ct_general.use);
+	list_for_each_entry(h, &unconfirmed, list) {
+		ct = nf_ct_tuplehash_to_ctrack(h);
+		if (iter(ct, data))
+			goto found;
+	}
+	return NULL;
+found:
+	atomic_inc(&nf_ct_tuplehash_to_ctrack(h)->ct_general.use);
 	write_unlock_bh(&nf_conntrack_lock);
-
-	return h;
+	return ct;
 }
 
 void
 nf_ct_iterate_cleanup(int (*iter)(struct nf_conn *i, void *data), void *data)
 {
-	struct nf_conntrack_tuple_hash *h;
+	struct nf_conn *ct;
 	unsigned int bucket = 0;
 
-	while ((h = get_next_corpse(iter, data, &bucket)) != NULL) {
-		struct nf_conn *ct = nf_ct_tuplehash_to_ctrack(h);
+	while ((ct = get_next_corpse(iter, data, &bucket)) != NULL) {
 		/* Time to push up daises... */
 		if (del_timer(&ct->timeout))
 			death_by_timeout((unsigned long)ct);
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 9a1de0c..5954f67 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -37,7 +37,6 @@ #include <net/netfilter/nf_conntrack_l3p
 #include <net/netfilter/nf_conntrack_protocol.h>
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack_helper.h>
-#include <linux/netfilter_ipv4/listhelp.h>
 
 #if 0
 #define DEBUGP printk
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 8037ba6..be7baf4 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -81,7 +81,7 @@ xt_unregister_target(struct xt_target *t
 	int af = target->family;
 
 	mutex_lock(&xt[af].mutex);
-	LIST_DELETE(&xt[af].target, target);
+	list_del(&target->list);
 	mutex_unlock(&xt[af].mutex);
 }
 EXPORT_SYMBOL(xt_unregister_target);
@@ -138,7 +138,7 @@ xt_unregister_match(struct xt_match *mat
 	int af =  match->family;
 
 	mutex_lock(&xt[af].mutex);
-	LIST_DELETE(&xt[af].match, match);
+	list_del(&match->list);
 	mutex_unlock(&xt[af].mutex);
 }
 EXPORT_SYMBOL(xt_unregister_match);
@@ -575,15 +575,18 @@ int xt_register_table(struct xt_table *t
 {
 	int ret;
 	struct xt_table_info *private;
+	struct xt_table *t;
 
 	ret = mutex_lock_interruptible(&xt[table->af].mutex);
 	if (ret != 0)
 		return ret;
 
 	/* Don't autoload: we'd eat our tail... */
-	if (list_named_find(&xt[table->af].tables, table->name)) {
-		ret = -EEXIST;
-		goto unlock;
+	list_for_each_entry(t, &xt[table->af].tables, list) {
+		if (strcmp(t->name, table->name) == 0) {
+			ret = -EEXIST;
+			goto unlock;
+		}
 	}
 
 	/* Simplifies replace_table code. */
@@ -598,7 +601,7 @@ int xt_register_table(struct xt_table *t
 	/* save number of initial entries */
 	private->initial_entries = private->number;
 
-	list_prepend(&xt[table->af].tables, table);
+	list_add(&table->list, &xt[table->af].tables);
 
 	ret = 0;
  unlock:
@@ -613,7 +616,7 @@ void *xt_unregister_table(struct xt_tabl
 
 	mutex_lock(&xt[table->af].mutex);
 	private = table->private;
-	LIST_DELETE(&xt[table->af].tables, table);
+	list_del(&table->list);
 	mutex_unlock(&xt[table->af].mutex);
 
 	return private;
