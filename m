From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 9/18] Netfilter:  Clean up the kmod handling code in
	iptables.c
Date: Wed, 05 Jan 2005 14:33:49 +1100
Message-ID: <1104896029.20582.72.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Linus Torvalds <torvalds@osdl.org>
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

Name: Clean up the kmod handling code in iptables.c
Status: Tested under nfsim
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

We now have a convenient kmod macro try_then_request_module(). 

1) Split our current "generic" function into separate
   find_target_lock(), find_table_lock() and find_match_lock()
   functions explicitly.

2) Have those functions do try_module_get() for us, and fix up the one
   caller who didn't do that anyway.

3) Have the caller use try_then_request_module().

4) Remove __ipt_mutex_up() and __ipt_find_target_lock() which weren't
   used (even in patch-o-matic AFAICT).

This cleanup takes us closer to using standard list macros everywhere,
and makes the version patch simpler.

Index: linux-2.6.10-bk1-Netfilter/net/ipv4/netfilter/ip_tables.c
===================================================================
--- linux-2.6.10-bk1-Netfilter.orig/net/ipv4/netfilter/ip_tables.c	2005-01-01 12:26:20.508126400 +1100
+++ linux-2.6.10-bk1-Netfilter/net/ipv4/netfilter/ip_tables.c	2005-01-01 12:27:36.343597656 +1100
@@ -26,6 +26,7 @@
 #include <asm/uaccess.h>
 #include <asm/semaphore.h>
 #include <linux/proc_fs.h>
+#include <linux/err.h>
 
 #include <linux/netfilter_ipv4/ip_tables.h>
 
@@ -408,85 +409,55 @@
 #endif
 }
 
-/* If it succeeds, returns element and locks mutex */
-static inline void *
-find_inlist_lock_noload(struct list_head *head,
-			const char *name,
-			int *error,
-			struct semaphore *mutex)
-{
-	void *ret;
-
-#if 0 
-	duprintf("find_inlist: searching for `%s' in %s.\n",
-		 name, head == &ipt_target ? "ipt_target"
-		 : head == &ipt_match ? "ipt_match"
-		 : head == &ipt_tables ? "ipt_tables" : "UNKNOWN");
-#endif
-
-	*error = down_interruptible(mutex);
-	if (*error != 0)
-		return NULL;
+/*
+ * These are weird, but module loading must not be done with mutex
+ * held (since they will register), and we have to have a single
+ * function to use try_then_request_module().
+ */
 
-	ret = list_named_find(head, name);
-	if (!ret) {
-		*error = -ENOENT;
-		up(mutex);
-	}
-	return ret;
-}
+/* Find table by name, grabs mutex & ref.  Returns ERR_PTR() on error. */
+static inline struct ipt_table *find_table_lock(const char *name)
+{
+	struct ipt_table *t;
 
-#ifndef CONFIG_KMOD
-#define find_inlist_lock(h,n,p,e,m) find_inlist_lock_noload((h),(n),(e),(m))
-#else
-static void *
-find_inlist_lock(struct list_head *head,
-		 const char *name,
-		 const char *prefix,
-		 int *error,
-		 struct semaphore *mutex)
-{
-	void *ret;
-
-	ret = find_inlist_lock_noload(head, name, error, mutex);
-	if (!ret) {
-		duprintf("find_inlist: loading `%s%s'.\n", prefix, name);
-		request_module("%s%s", prefix, name);
-		ret = find_inlist_lock_noload(head, name, error, mutex);
-	}
+	if (down_interruptible(&ipt_mutex) != 0)
+		return ERR_PTR(-EINTR);
 
-	return ret;
+	list_for_each_entry(t, &ipt_tables, list)
+		if (strcmp(t->name, name) == 0 && try_module_get(t->me))
+			return t;
+	up(&ipt_mutex);
+	return NULL;
 }
-#endif
 
-static inline struct ipt_table *
-ipt_find_table_lock(const char *name, int *error, struct semaphore *mutex)
+/* Find match by name, grabs mutex & ref.  Returns ERR_PTR() on error. */
+static inline struct ipt_match *find_match_lock(const char *name)
 {
-	return find_inlist_lock(&ipt_tables, name, "iptable_", error, mutex);
-}
+	struct ipt_match *m;
 
-static inline struct ipt_match *
-find_match_lock(const char *name, int *error, struct semaphore *mutex)
-{
-	return find_inlist_lock(&ipt_match, name, "ipt_", error, mutex);
-}
+	if (down_interruptible(&ipt_mutex) != 0)
+		return ERR_PTR(-EINTR);
 
-static struct ipt_target *
-ipt_find_target_lock(const char *name, int *error, struct semaphore *mutex)
-{
-	return find_inlist_lock(&ipt_target, name, "ipt_", error, mutex);
+	list_for_each_entry(m, &ipt_match, list)
+		if (strcmp(m->name, name) == 0 && try_module_get(m->me))
+			return m;
+	up(&ipt_mutex);
+	return NULL;
 }
 
-struct ipt_target *
-__ipt_find_target_lock(const char *name, int *error)
+/* Find target by name, grabs mutex & ref.  Returns ERR_PTR() on error. */
+static inline struct ipt_target *find_target_lock(const char *name)
 {
-	return ipt_find_target_lock(name,error,&ipt_mutex);
-}
+	struct ipt_target *t;
 
-void
-__ipt_mutex_up(void)
-{
+	if (down_interruptible(&ipt_mutex) != 0)
+		return ERR_PTR(-EINTR);
+
+	list_for_each_entry(t, &ipt_target, list)
+		if (strcmp(t->name, name) == 0 && try_module_get(t->me))
+			return t;
 	up(&ipt_mutex);
+	return NULL;
 }
 
 /* All zeroes == unconditional rule. */
@@ -648,17 +619,13 @@
 	    unsigned int hookmask,
 	    unsigned int *i)
 {
-	int ret;
 	struct ipt_match *match;
 
-	match = find_match_lock(m->u.user.name, &ret, &ipt_mutex);
-	if (!match) {
+	match = try_then_request_module(find_match_lock(m->u.user.name),
+					"ipt_%s", m->u.user.name);
+	if (IS_ERR(match) || !match) {
 		duprintf("check_match: `%s' not found\n", m->u.user.name);
-		return ret;
-	}
-	if (!try_module_get(match->me)) {
-		up(&ipt_mutex);
-		return -ENOENT;
+		return match ? PTR_ERR(match) : -ENOENT;
 	}
 	m->u.kernel.match = match;
 	up(&ipt_mutex);
@@ -699,14 +666,11 @@
 		goto cleanup_matches;
 
 	t = ipt_get_target(e);
-	target = ipt_find_target_lock(t->u.user.name, &ret, &ipt_mutex);
-	if (!target) {
+	target = try_then_request_module(find_target_lock(t->u.user.name),
+					 "ipt_%s", t->u.user.name);
+	if (IS_ERR(target) || !target) {
 		duprintf("check_entry: `%s' not found\n", t->u.user.name);
-		goto cleanup_matches;
-	}
-	if (!try_module_get(target->me)) {
-		up(&ipt_mutex);
-		ret = -ENOENT;
+		ret = target ? PTR_ERR(target) : -ENOENT;
 		goto cleanup_matches;
 	}
 	t->u.kernel.target = target;
@@ -1036,8 +1000,8 @@
 	int ret;
 	struct ipt_table *t;
 
-	t = ipt_find_table_lock(entries->name, &ret, &ipt_mutex);
-	if (t) {
+	t = find_table_lock(entries->name);
+	if (t && !IS_ERR(t)) {
 		duprintf("t->private->number = %u\n",
 			 t->private->number);
 		if (entries->size == t->private->size)
@@ -1049,10 +1013,10 @@
 				 entries->size);
 			ret = -EINVAL;
 		}
+		module_put(t->me);
 		up(&ipt_mutex);
 	} else
-		duprintf("get_entries: Can't find %s!\n",
-			 entries->name);
+		ret = t ? PTR_ERR(t) : -ENOENT;
 
 	return ret;
 }
@@ -1103,25 +1067,21 @@
 
 	duprintf("ip_tables: Translated table\n");
 
-	t = ipt_find_table_lock(tmp.name, &ret, &ipt_mutex);
-	if (!t)
+	t = try_then_request_module(find_table_lock(tmp.name),
+				    "iptable_%s", tmp.name);
+	if (!t || IS_ERR(t)) {
+		ret = t ? PTR_ERR(t) : -ENOENT;
 		goto free_newinfo_counters_untrans;
+	}
 
 	/* You lied! */
 	if (tmp.valid_hooks != t->valid_hooks) {
 		duprintf("Valid hook crap: %08X vs %08X\n",
 			 tmp.valid_hooks, t->valid_hooks);
 		ret = -EINVAL;
-		goto free_newinfo_counters_untrans_unlock;
-	}
-
-	/* Get a reference in advance, we're not allowed fail later */
-	if (!try_module_get(t->me)) {
-		ret = -EBUSY;
-		goto free_newinfo_counters_untrans_unlock;
+		goto put_module;
 	}
 
-
 	oldinfo = replace_table(t, tmp.num_counters, newinfo, &ret);
 	if (!oldinfo)
 		goto put_module;
@@ -1150,7 +1110,6 @@
 
  put_module:
 	module_put(t->me);
- free_newinfo_counters_untrans_unlock:
 	up(&ipt_mutex);
  free_newinfo_counters_untrans:
 	IPT_ENTRY_ITERATE(newinfo->entries, newinfo->size, cleanup_entry,NULL);
@@ -1189,7 +1148,7 @@
 	unsigned int i;
 	struct ipt_counters_info tmp, *paddc;
 	struct ipt_table *t;
-	int ret;
+	int ret = 0;
 
 	if (copy_from_user(&tmp, user, sizeof(tmp)) != 0)
 		return -EFAULT;
@@ -1206,9 +1165,11 @@
 		goto free;
 	}
 
-	t = ipt_find_table_lock(tmp.name, &ret, &ipt_mutex);
-	if (!t)
+	t = find_table_lock(tmp.name);
+	if (!t || IS_ERR(t)) {
+		ret = t ? PTR_ERR(t) : -ENOENT;
 		goto free;
+	}
 
 	write_lock_bh(&t->lock);
 	if (t->private->number != paddc->num_counters) {
@@ -1225,6 +1186,7 @@
  unlock_up_free:
 	write_unlock_bh(&t->lock);
 	up(&ipt_mutex);
+	module_put(t->me);
  free:
 	vfree(paddc);
 
@@ -1281,8 +1243,10 @@
 			break;
 		}
 		name[IPT_TABLE_MAXNAMELEN-1] = '\0';
-		t = ipt_find_table_lock(name, &ret, &ipt_mutex);
-		if (t) {
+
+		t = try_then_request_module(find_table_lock(name),
+					    "iptable_%s", name);
+		if (t && !IS_ERR(t)) {
 			struct ipt_getinfo info;
 
 			info.valid_hooks = t->valid_hooks;
@@ -1298,9 +1262,10 @@
 				ret = -EFAULT;
 			else
 				ret = 0;
-
 			up(&ipt_mutex);
-		}
+			module_put(t->me);
+		} else
+			ret = t ? PTR_ERR(t) : -ENOENT;
 	}
 	break;
 
@@ -1889,8 +1854,6 @@
 EXPORT_SYMBOL(ipt_do_table);
 EXPORT_SYMBOL(ipt_register_target);
 EXPORT_SYMBOL(ipt_unregister_target);
-EXPORT_SYMBOL_GPL(__ipt_find_target_lock);
-EXPORT_SYMBOL_GPL(__ipt_mutex_up);
 
 module_init(init);
 module_exit(fini);
Index: linux-2.6.10-bk1-Netfilter/include/linux/netfilter_ipv4/ip_tables.h
===================================================================
--- linux-2.6.10-bk1-Netfilter.orig/include/linux/netfilter_ipv4/ip_tables.h	2005-01-01 12:25:41.721022936 +1100
+++ linux-2.6.10-bk1-Netfilter/include/linux/netfilter_ipv4/ip_tables.h	2005-01-01 12:26:36.671669168 +1100
@@ -413,10 +413,6 @@
 extern int ipt_register_match(struct ipt_match *match);
 extern void ipt_unregister_match(struct ipt_match *match);
 
-extern struct ipt_target *
-__ipt_find_target_lock(const char *name, int *error);
-extern void __ipt_mutex_up(void);
-
 /* Furniture shopping... */
 struct ipt_table
 {
