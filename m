From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 101/103] netfilter: xtables1: remove xt1 table handling
Date: Tue,  4 Aug 2009 09:26:25 +0200
Message-ID: <1249370787-17583-102-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56964 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932610AbZHDH2V (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:28:21 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/x_tables.h |   18 ---
 net/netfilter/x_tables.c           |  244 ------------------------------------
 2 files changed, 0 insertions(+), 262 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 77573a5..1c37428 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -595,17 +595,6 @@ extern int xt_check_target(struct xt_tgchk_param *,
 			   unsigned int size, u_int8_t proto, bool inv_proto,
 			   bool check_pad);
 
-extern struct xt_table *xt_register_table(struct net *net,
-					  const struct xt_table *table,
-					  struct xt_table_info *bootstrap,
-					  struct xt_table_info *newinfo);
-extern void *xt_unregister_table(struct xt_table *table);
-
-extern struct xt_table_info *xt_replace_table(struct xt_table *table,
-					      unsigned int num_counters,
-					      struct xt_table_info *newinfo,
-					      int *error);
-
 extern struct xt_match *xt_find_match(u8 af, const char *name, u8 revision);
 extern struct xt_target *xt_find_target(u8 af, const char *name, u8 revision);
 extern struct xt_match *xt_request_find_match(uint8_t, const char *, uint8_t);
@@ -614,16 +603,9 @@ extern struct xt_target *xt_request_find_target(u8 af, const char *name,
 extern int xt_find_revision(u8 af, const char *name, u8 revision,
 			    int target, int *err);
 
-extern struct xt_table *xt_find_table_lock(struct net *net, u_int8_t af,
-					   const char *name);
-extern void xt_table_unlock(struct xt_table *t);
-
 extern int xt_proto_init(struct net *net, u_int8_t af);
 extern void xt_proto_fini(struct net *net, u_int8_t af);
 
-extern struct xt_table_info *xt_alloc_table_info(unsigned int size);
-extern void xt_free_table_info(struct xt_table_info *info);
-
 /*
  * Per-CPU spinlock associated with per-cpu table entries, and
  * with a counter for the "reading" side that allows a recursive
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 29d9ea8..167332c 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -650,97 +650,6 @@ int xt_compat_target_to_user(const struct xt_entry_target *t,
 EXPORT_SYMBOL_GPL(xt_compat_target_to_user);
 #endif
 
-struct xt_table_info *xt_alloc_table_info(unsigned int size)
-{
-	struct xt_table_info *newinfo;
-	int cpu;
-
-	/* Pedantry: prevent them from hitting BUG() in vmalloc.c --RR */
-	if ((SMP_ALIGN(size) >> PAGE_SHIFT) + 2 > num_physpages)
-		return NULL;
-
-	newinfo = kzalloc(XT_TABLE_INFO_SZ, GFP_KERNEL);
-	if (!newinfo)
-		return NULL;
-
-	newinfo->size = size;
-
-	for_each_possible_cpu(cpu) {
-		if (size <= PAGE_SIZE)
-			newinfo->entries[cpu] = kmalloc_node(size,
-							GFP_KERNEL,
-							cpu_to_node(cpu));
-		else
-			newinfo->entries[cpu] = vmalloc_node(size,
-							cpu_to_node(cpu));
-
-		if (newinfo->entries[cpu] == NULL) {
-			xt_free_table_info(newinfo);
-			return NULL;
-		}
-	}
-
-	return newinfo;
-}
-EXPORT_SYMBOL(xt_alloc_table_info);
-
-void xt_free_table_info(struct xt_table_info *info)
-{
-	int cpu;
-
-	for_each_possible_cpu(cpu) {
-		if (info->size <= PAGE_SIZE)
-			kfree(info->entries[cpu]);
-		else
-			vfree(info->entries[cpu]);
-	}
-
-	if (info->jumpstack != NULL) {
-		if (sizeof(void *) * info->stacksize > PAGE_SIZE) {
-			for_each_possible_cpu(cpu)
-				vfree(info->jumpstack[cpu]);
-		} else {
-			for_each_possible_cpu(cpu)
-				kfree(info->jumpstack[cpu]);
-		}
-	}
-
-	if (sizeof(void **) * nr_cpu_ids > PAGE_SIZE)
-		vfree(info->jumpstack);
-	else
-		kfree(info->jumpstack);
-	if (sizeof(unsigned int) * nr_cpu_ids > PAGE_SIZE)
-		vfree(info->stackptr);
-	else
-		kfree(info->stackptr);
-
-	kfree(info);
-}
-EXPORT_SYMBOL(xt_free_table_info);
-
-/* Find table by name, grabs mutex & ref.  Returns ERR_PTR() on error. */
-struct xt_table *xt_find_table_lock(struct net *net, u_int8_t af,
-				    const char *name)
-{
-	struct xt_table *t;
-
-	if (mutex_lock_interruptible(&xt[af].mutex) != 0)
-		return ERR_PTR(-EINTR);
-
-	list_for_each_entry(t, &net->xt.tables[af], list)
-		if (strcmp(t->name, name) == 0 && try_module_get(t->me))
-			return t;
-	mutex_unlock(&xt[af].mutex);
-	return NULL;
-}
-EXPORT_SYMBOL_GPL(xt_find_table_lock);
-
-void xt_table_unlock(struct xt_table *table)
-{
-	mutex_unlock(&xt[table->af].mutex);
-}
-EXPORT_SYMBOL_GPL(xt_table_unlock);
-
 #ifdef CONFIG_COMPAT
 void xt_compat_lock(u_int8_t af)
 {
@@ -758,159 +667,6 @@ EXPORT_SYMBOL_GPL(xt_compat_unlock);
 DEFINE_PER_CPU(struct xt_info_lock, xt_info_locks);
 EXPORT_PER_CPU_SYMBOL_GPL(xt_info_locks);
 
-static int xt_jumpstack_alloc(struct xt_table_info *i)
-{
-	unsigned int size;
-	int cpu;
-
-	size = sizeof(unsigned int) * nr_cpu_ids;
-	if (size > PAGE_SIZE)
-		i->stackptr = vmalloc(size);
-	else
-		i->stackptr = kmalloc(size, GFP_KERNEL);
-	if (i->stackptr == NULL)
-		return -ENOMEM;
-	memset(i->stackptr, 0, size);
-
-	size = sizeof(void **) * nr_cpu_ids;
-	if (size > PAGE_SIZE)
-		i->jumpstack = vmalloc(size);
-	else
-		i->jumpstack = kmalloc(size, GFP_KERNEL);
-	if (i->jumpstack == NULL)
-		return -ENOMEM;
-	memset(i->jumpstack, 0, size);
-
-	i->stacksize *= xt_jumpstack_multiplier;
-	size = sizeof(void *) * i->stacksize;
-	for_each_possible_cpu(cpu) {
-		if (size > PAGE_SIZE)
-			i->jumpstack[cpu] = vmalloc_node(size,
-				cpu_to_node(cpu));
-		else
-			i->jumpstack[cpu] = kmalloc_node(size,
-				GFP_KERNEL, cpu_to_node(cpu));
-		if (i->jumpstack[cpu] == NULL)
-			return -ENOMEM;
-	}
-
-	return 0;
-}
-
-struct xt_table_info *
-xt_replace_table(struct xt_table *table,
-	      unsigned int num_counters,
-	      struct xt_table_info *newinfo,
-	      int *error)
-{
-	struct xt_table_info *private;
-	int ret;
-
-	/* Do the substitution. */
-	local_bh_disable();
-	private = table->private;
-
-	/* Check inside lock: is the old number correct? */
-	if (num_counters != private->number) {
-		duprintf("num_counters != table->private->number (%u/%u)\n",
-			 num_counters, private->number);
-		local_bh_enable();
-		*error = -EAGAIN;
-		return NULL;
-	}
-
-	ret = xt_jumpstack_alloc(newinfo);
-	if (ret < 0) {
-		*error = ret;
-		return NULL;
-	}
-
-	table->private = newinfo;
-	newinfo->initial_entries = private->initial_entries;
-
-	/*
-	 * Even though table entries have now been swapped, other CPU's
-	 * may still be using the old entries. This is okay, because
-	 * resynchronization happens because of the locking done
-	 * during the get_counters() routine.
-	 */
-	local_bh_enable();
-
-	return private;
-}
-EXPORT_SYMBOL_GPL(xt_replace_table);
-
-struct xt_table *xt_register_table(struct net *net,
-				   const struct xt_table *input_table,
-				   struct xt_table_info *bootstrap,
-				   struct xt_table_info *newinfo)
-{
-	int ret;
-	struct xt_table_info *private;
-	struct xt_table *t, *table;
-
-	ret = xt_jumpstack_alloc(newinfo);
-	if (ret < 0)
-		return ERR_PTR(ret);
-
-	/* Don't add one object to multiple lists. */
-	table = kmemdup(input_table, sizeof(struct xt_table), GFP_KERNEL);
-	if (!table) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	ret = mutex_lock_interruptible(&xt[table->af].mutex);
-	if (ret != 0)
-		goto out_free;
-
-	/* Don't autoload: we'd eat our tail... */
-	list_for_each_entry(t, &net->xt.tables[table->af], list) {
-		if (strcmp(t->name, table->name) == 0) {
-			ret = -EEXIST;
-			goto unlock;
-		}
-	}
-
-	/* Simplifies replace_table code. */
-	table->private = bootstrap;
-
-	if (!xt_replace_table(table, 0, newinfo, &ret))
-		goto unlock;
-
-	private = table->private;
-	duprintf("table->private->number = %u\n", private->number);
-
-	/* save number of initial entries */
-	private->initial_entries = private->number;
-
-	list_add(&table->list, &net->xt.tables[table->af]);
-	mutex_unlock(&xt[table->af].mutex);
-	return table;
-
- unlock:
-	mutex_unlock(&xt[table->af].mutex);
-out_free:
-	kfree(table);
-out:
-	return ERR_PTR(ret);
-}
-EXPORT_SYMBOL_GPL(xt_register_table);
-
-void *xt_unregister_table(struct xt_table *table)
-{
-	struct xt_table_info *private;
-
-	mutex_lock(&xt[table->af].mutex);
-	private = table->private;
-	list_del(&table->list);
-	mutex_unlock(&xt[table->af].mutex);
-	kfree(table);
-
-	return private;
-}
-EXPORT_SYMBOL_GPL(xt_unregister_table);
-
 #ifdef CONFIG_PROC_FS
 struct xt_names_priv {
 	struct seq_net_private p;
-- 
1.6.3.3

