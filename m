From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 07/64]: ip_tables: move compat offset calculation to x_tables
Date: Tue, 18 Dec 2007 00:46:22 +0100 (MET)
Message-ID: <20071217234621.23601.86532.sendpatchset@localhost.localdomain>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38899 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757532AbXLQXqX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:46:23 -0500
In-Reply-To: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: ip_tables: move compat offset calculation to x_tables

Its needed by ip6_tables and arp_tables as well.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 8803d89ba96c5169a1183647f2753822f36faeff
tree 5ae2a9b3219825357046b5616cd4c8632a7f0e51
parent a1df013706dd1275e74a2baf9006853892c523ea
author Patrick McHardy <kaber@trash.net> Mon, 17 Dec 2007 14:57:42 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 17 Dec 2007 16:04:32 +0100

 include/linux/netfilter/x_tables.h |    4 ++
 net/ipv4/netfilter/ip_tables.c     |   67 ++++--------------------------------
 net/netfilter/x_tables.c           |   58 +++++++++++++++++++++++++++++++
 3 files changed, 70 insertions(+), 59 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 8ab754e..b99ede5 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -424,6 +424,10 @@ struct compat_xt_counters_info
 extern void xt_compat_lock(int af);
 extern void xt_compat_unlock(int af);
 
+extern int xt_compat_add_offset(int af, unsigned int offset, short delta);
+extern void xt_compat_flush_offsets(int af);
+extern short xt_compat_calc_jump(int af, unsigned int offset);
+
 extern int xt_compat_match_offset(struct xt_match *match);
 extern int xt_compat_match_from_user(struct xt_entry_match *m,
 				     void **dstptr, int *size);
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index d8caa1e..07be12c 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1014,63 +1014,12 @@ copy_entries_to_user(unsigned int total_size,
 }
 
 #ifdef CONFIG_COMPAT
-struct compat_delta {
-	struct compat_delta *next;
-	unsigned int offset;
-	short delta;
-};
-
-static struct compat_delta *compat_offsets;
-
-static int compat_add_offset(unsigned int offset, short delta)
-{
-	struct compat_delta *tmp;
-
-	tmp = kmalloc(sizeof(struct compat_delta), GFP_KERNEL);
-	if (!tmp)
-		return -ENOMEM;
-	tmp->offset = offset;
-	tmp->delta = delta;
-	if (compat_offsets) {
-		tmp->next = compat_offsets->next;
-		compat_offsets->next = tmp;
-	} else {
-		compat_offsets = tmp;
-		tmp->next = NULL;
-	}
-	return 0;
-}
-
-static void compat_flush_offsets(void)
-{
-	struct compat_delta *tmp, *next;
-
-	if (compat_offsets) {
-		for (tmp = compat_offsets; tmp; tmp = next) {
-			next = tmp->next;
-			kfree(tmp);
-		}
-		compat_offsets = NULL;
-	}
-}
-
-static short compat_calc_jump(unsigned int offset)
-{
-	struct compat_delta *tmp;
-	short delta;
-
-	for (tmp = compat_offsets, delta = 0; tmp; tmp = tmp->next)
-		if (tmp->offset < offset)
-			delta += tmp->delta;
-	return delta;
-}
-
 static void compat_standard_from_user(void *dst, void *src)
 {
 	int v = *(compat_int_t *)src;
 
 	if (v > 0)
-		v += compat_calc_jump(v);
+		v += xt_compat_calc_jump(AF_INET, v);
 	memcpy(dst, &v, sizeof(v));
 }
 
@@ -1079,7 +1028,7 @@ static int compat_standard_to_user(void __user *dst, void *src)
 	compat_int_t cv = *(int *)src;
 
 	if (cv > 0)
-		cv -= compat_calc_jump(cv);
+		cv -= xt_compat_calc_jump(AF_INET, cv);
 	return copy_to_user(dst, &cv, sizeof(cv)) ? -EFAULT : 0;
 }
 
@@ -1104,7 +1053,7 @@ static int compat_calc_entry(struct ipt_entry *e,
 	t = ipt_get_target(e);
 	off += xt_compat_target_offset(t->u.kernel.target);
 	newinfo->size -= off;
-	ret = compat_add_offset(entry_offset, off);
+	ret = xt_compat_add_offset(AF_INET, entry_offset, off);
 	if (ret)
 		return ret;
 
@@ -1167,7 +1116,7 @@ static int get_info(void __user *user, int *len, int compat)
 		if (compat) {
 			struct xt_table_info tmp;
 			ret = compat_table_info(private, &tmp);
-			compat_flush_offsets();
+			xt_compat_flush_offsets(AF_INET);
 			private = &tmp;
 		}
 #endif
@@ -1631,7 +1580,7 @@ check_compat_entry_size_and_hooks(struct compat_ipt_entry *e,
 
 	off += xt_compat_target_offset(target);
 	*size += off;
-	ret = compat_add_offset(entry_offset, off);
+	ret = xt_compat_add_offset(AF_INET, entry_offset, off);
 	if (ret)
 		goto out;
 
@@ -1797,7 +1746,7 @@ translate_compat_table(const char *name,
 	ret = COMPAT_IPT_ENTRY_ITERATE(entry0, total_size,
 				       compat_copy_entry_from_user, &pos, &size,
 				       name, newinfo, entry1);
-	compat_flush_offsets();
+	xt_compat_flush_offsets(AF_INET);
 	xt_compat_unlock(AF_INET);
 	if (ret)
 		goto free_newinfo;
@@ -1834,7 +1783,7 @@ out:
 	COMPAT_IPT_ENTRY_ITERATE(entry0, total_size, compat_release_entry, &j);
 	return ret;
 out_unlock:
-	compat_flush_offsets();
+	xt_compat_flush_offsets(AF_INET);
 	xt_compat_unlock(AF_INET);
 	goto out;
 }
@@ -1997,7 +1946,7 @@ compat_get_entries(struct compat_ipt_get_entries __user *uptr, int *len)
 				 get.size);
 			ret = -EINVAL;
 		}
-		compat_flush_offsets();
+		xt_compat_flush_offsets(AF_INET);
 		module_put(t->me);
 		xt_table_unlock(t);
 	} else
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index b95284e..8d4fca9 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -34,12 +34,21 @@ MODULE_DESCRIPTION("[ip,ip6,arp]_tables backend module");
 
 #define SMP_ALIGN(x) (((x) + SMP_CACHE_BYTES-1) & ~(SMP_CACHE_BYTES-1))
 
+struct compat_delta {
+	struct compat_delta *next;
+	unsigned int offset;
+	short delta;
+};
+
 struct xt_af {
 	struct mutex mutex;
 	struct list_head match;
 	struct list_head target;
 	struct list_head tables;
+#ifdef CONFIG_COMPAT
 	struct mutex compat_mutex;
+	struct compat_delta *compat_offsets;
+#endif
 };
 
 static struct xt_af *xt;
@@ -335,6 +344,54 @@ int xt_check_match(const struct xt_match *match, unsigned short family,
 EXPORT_SYMBOL_GPL(xt_check_match);
 
 #ifdef CONFIG_COMPAT
+int xt_compat_add_offset(int af, unsigned int offset, short delta)
+{
+	struct compat_delta *tmp;
+
+	tmp = kmalloc(sizeof(struct compat_delta), GFP_KERNEL);
+	if (!tmp)
+		return -ENOMEM;
+
+	tmp->offset = offset;
+	tmp->delta = delta;
+
+	if (xt[af].compat_offsets) {
+		tmp->next = xt[af].compat_offsets->next;
+		xt[af].compat_offsets->next = tmp;
+	} else {
+		xt[af].compat_offsets = tmp;
+		tmp->next = NULL;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(xt_compat_add_offset);
+
+void xt_compat_flush_offsets(int af)
+{
+	struct compat_delta *tmp, *next;
+
+	if (xt[af].compat_offsets) {
+		for (tmp = xt[af].compat_offsets; tmp; tmp = next) {
+			next = tmp->next;
+			kfree(tmp);
+		}
+		xt[af].compat_offsets = NULL;
+	}
+}
+EXPORT_SYMBOL_GPL(xt_compat_flush_offsets);
+
+short xt_compat_calc_jump(int af, unsigned int offset)
+{
+	struct compat_delta *tmp;
+	short delta;
+
+	for (tmp = xt[af].compat_offsets, delta = 0; tmp; tmp = tmp->next)
+		if (tmp->offset < offset)
+			delta += tmp->delta;
+	return delta;
+}
+EXPORT_SYMBOL_GPL(xt_compat_calc_jump);
+
 int xt_compat_match_offset(struct xt_match *match)
 {
 	u_int16_t csize = match->compatsize ? : match->matchsize;
@@ -873,6 +930,7 @@ static int __init xt_init(void)
 		mutex_init(&xt[i].mutex);
 #ifdef CONFIG_COMPAT
 		mutex_init(&xt[i].compat_mutex);
+		xt[i].compat_offsets = NULL;
 #endif
 		INIT_LIST_HEAD(&xt[i].target);
 		INIT_LIST_HEAD(&xt[i].match);
