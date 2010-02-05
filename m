From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 4/7] netfilter: ebtables: split do_replace into two functions
Date: Fri,  5 Feb 2010 02:43:12 +0100
Message-ID: <1265334195-28120-5-git-send-email-fw@strlen.de>
References: <1265334195-28120-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:59376 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756717Ab0BEBoP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Feb 2010 20:44:15 -0500
In-Reply-To: <1265334195-28120-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

once CONFIG_COMPAT support is merged this allows
to call do_replace_finish() after doing the CONFIG_COMPAT conversion
instead of copy & pasting this.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/bridge/netfilter/ebtables.c |  133 ++++++++++++++++++++-------------------
 1 files changed, 69 insertions(+), 64 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 1939041..a658de2 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -958,90 +958,44 @@ static void get_counters(struct ebt_counter *oldcounters,
 	}
 }
 
-/* replace the table */
-static int do_replace(struct net *net, void __user *user, unsigned int len)
+static int do_replace_finish(struct net *net, struct ebt_replace *repl,
+                             struct ebt_table_info *newinfo)
 {
-	int ret, i, countersize;
-	struct ebt_table_info *newinfo;
-	struct ebt_replace tmp;
-	struct ebt_table *t;
+	int ret, i;
 	struct ebt_counter *counterstmp = NULL;
 	/* used to be able to unlock earlier */
 	struct ebt_table_info *table;
-
-	if (copy_from_user(&tmp, user, sizeof(tmp)) != 0)
-		return -EFAULT;
-
-	if (len != sizeof(tmp) + tmp.entries_size) {
-		BUGPRINT("Wrong len argument\n");
-		return -EINVAL;
-	}
-
-	if (tmp.entries_size == 0) {
-		BUGPRINT("Entries_size never zero\n");
-		return -EINVAL;
-	}
-	/* overflow check */
-	if (tmp.nentries >= ((INT_MAX - sizeof(struct ebt_table_info)) / NR_CPUS -
-			SMP_CACHE_BYTES) / sizeof(struct ebt_counter))
-		return -ENOMEM;
-	if (tmp.num_counters >= INT_MAX / sizeof(struct ebt_counter))
-		return -ENOMEM;
-
-	countersize = COUNTER_OFFSET(tmp.nentries) * nr_cpu_ids;
-	newinfo = vmalloc(sizeof(*newinfo) + countersize);
-	if (!newinfo)
-		return -ENOMEM;
-
-	if (countersize)
-		memset(newinfo->counters, 0, countersize);
-
-	newinfo->entries = vmalloc(tmp.entries_size);
-	if (!newinfo->entries) {
-		ret = -ENOMEM;
-		goto free_newinfo;
-	}
-	if (copy_from_user(
-	   newinfo->entries, tmp.entries, tmp.entries_size) != 0) {
-		BUGPRINT("Couldn't copy entries from userspace\n");
-		ret = -EFAULT;
-		goto free_entries;
-	}
+	struct ebt_table *t;
 
 	/* the user wants counters back
 	   the check on the size is done later, when we have the lock */
-	if (tmp.num_counters) {
-		counterstmp = vmalloc(tmp.num_counters * sizeof(*counterstmp));
-		if (!counterstmp) {
-			ret = -ENOMEM;
-			goto free_entries;
-		}
+	if (repl->num_counters) {
+		counterstmp = vmalloc(repl->num_counters * sizeof(*counterstmp));
+		if (!counterstmp)
+			return -ENOMEM;
 	}
-	else
-		counterstmp = NULL;
 
-	/* this can get initialized by translate_table() */
 	newinfo->chainstack = NULL;
-	ret = ebt_verify_pointers(&tmp, newinfo);
+	ret = ebt_verify_pointers(repl, newinfo);
 	if (ret != 0)
 		goto free_counterstmp;
 
-	ret = translate_table(net, tmp.name, newinfo);
+	ret = translate_table(net, repl->name, newinfo);
 
 	if (ret != 0)
 		goto free_counterstmp;
 
-	t = find_table_lock(net, tmp.name, &ret, &ebt_mutex);
+	t = find_table_lock(net, repl->name, &ret, &ebt_mutex);
 	if (!t) {
 		ret = -ENOENT;
 		goto free_iterate;
 	}
 
 	/* the table doesn't like it */
-	if (t->check && (ret = t->check(newinfo, tmp.valid_hooks)))
+	if (t->check && (ret = t->check(newinfo, repl->valid_hooks)))
 		goto free_unlock;
 
-	if (tmp.num_counters && tmp.num_counters != t->private->nentries) {
+	if (repl->num_counters && repl->num_counters != t->private->nentries) {
 		BUGPRINT("Wrong nr. of counters requested\n");
 		ret = -EINVAL;
 		goto free_unlock;
@@ -1057,7 +1011,7 @@ static int do_replace(struct net *net, void __user *user, unsigned int len)
 		module_put(t->me);
 	/* we need an atomic snapshot of the counters */
 	write_lock_bh(&t->lock);
-	if (tmp.num_counters)
+	if (repl->num_counters)
 		get_counters(t->private->counters, counterstmp,
 		   t->private->nentries);
 
@@ -1068,10 +1022,9 @@ static int do_replace(struct net *net, void __user *user, unsigned int len)
 	   allocation. Only reason why this is done is because this way the lock
 	   is held only once, while this doesn't bring the kernel into a
 	   dangerous state. */
-	if (tmp.num_counters &&
-	   copy_to_user(tmp.counters, counterstmp,
-	   tmp.num_counters * sizeof(struct ebt_counter))) {
-		BUGPRINT("Couldn't copy counters to userspace\n");
+	if (repl->num_counters &&
+	   copy_to_user(repl->counters, counterstmp,
+	   repl->num_counters * sizeof(struct ebt_counter))) {
 		ret = -EFAULT;
 	}
 	else
@@ -1105,6 +1058,58 @@ free_counterstmp:
 			vfree(newinfo->chainstack[i]);
 		vfree(newinfo->chainstack);
 	}
+	return ret;
+}
+
+/* replace the table */
+static int do_replace(struct net *net, void __user *user, unsigned int len)
+{
+	int ret, countersize;
+	struct ebt_table_info *newinfo;
+	struct ebt_replace tmp;
+
+	if (copy_from_user(&tmp, user, sizeof(tmp)) != 0)
+		return -EFAULT;
+
+	if (len != sizeof(tmp) + tmp.entries_size) {
+		BUGPRINT("Wrong len argument\n");
+		return -EINVAL;
+	}
+
+	if (tmp.entries_size == 0) {
+		BUGPRINT("Entries_size never zero\n");
+		return -EINVAL;
+	}
+	/* overflow check */
+	if (tmp.nentries >= ((INT_MAX - sizeof(struct ebt_table_info)) / NR_CPUS -
+			SMP_CACHE_BYTES) / sizeof(struct ebt_counter))
+		return -ENOMEM;
+	if (tmp.num_counters >= INT_MAX / sizeof(struct ebt_counter))
+		return -ENOMEM;
+
+	countersize = COUNTER_OFFSET(tmp.nentries) * nr_cpu_ids;
+	newinfo = vmalloc(sizeof(*newinfo) + countersize);
+	if (!newinfo)
+		return -ENOMEM;
+
+	if (countersize)
+		memset(newinfo->counters, 0, countersize);
+
+	newinfo->entries = vmalloc(tmp.entries_size);
+	if (!newinfo->entries) {
+		ret = -ENOMEM;
+		goto free_newinfo;
+	}
+	if (copy_from_user(
+	   newinfo->entries, tmp.entries, tmp.entries_size) != 0) {
+		BUGPRINT("Couldn't copy entries from userspace\n");
+		ret = -EFAULT;
+		goto free_entries;
+	}
+
+	ret = do_replace_finish(net, &tmp, newinfo);
+	if (ret == 0)
+		return ret;
 free_entries:
 	vfree(newinfo->entries);
 free_newinfo:
-- 
1.6.4.4

