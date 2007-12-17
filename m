From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 06/64]: ip_tables: fix compat types
Date: Tue, 18 Dec 2007 00:46:20 +0100 (MET)
Message-ID: <20071217234620.23601.62995.sendpatchset@localhost.localdomain>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38896 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757836AbXLQXqW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:46:22 -0500
In-Reply-To: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: ip_tables: fix compat types

Use compat types and compat iterators when dealing with compat entries for
clarity. This doesn't actually make a difference for ip_tables, but is
needed for ip6_tables and arp_tables.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit a1df013706dd1275e74a2baf9006853892c523ea
tree b441fd49848be77aa1622b9c375bdd49b4818eed
parent cac25046b4856c4b88839f58149fa287a5067d55
author Patrick McHardy <kaber@trash.net> Mon, 17 Dec 2007 14:57:41 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 17 Dec 2007 16:02:34 +0100

 include/linux/netfilter_ipv4/ip_tables.h |   25 ++++++++++++---
 net/ipv4/netfilter/ip_tables.c           |   51 ++++++++++++++++--------------
 2 files changed, 47 insertions(+), 29 deletions(-)

diff --git a/include/linux/netfilter_ipv4/ip_tables.h b/include/linux/netfilter_ipv4/ip_tables.h
index 1e0cfca..45fcad9 100644
--- a/include/linux/netfilter_ipv4/ip_tables.h
+++ b/include/linux/netfilter_ipv4/ip_tables.h
@@ -236,11 +236,6 @@ ipt_get_target(struct ipt_entry *e)
 #define IPT_ENTRY_ITERATE(entries, size, fn, args...) \
 	XT_ENTRY_ITERATE(struct ipt_entry, entries, size, fn, ## args)
 
-/* fn returns 0 to continue iteration */
-#define IPT_ENTRY_ITERATE_CONTINUE(entries, size, n, fn, args...) \
-	XT_ENTRY_ITERATE_CONTINUE(struct ipt_entry, entries, size, n, fn, \
-				  ## args)
-
 /*
  *	Main firewall chains definitions and global var's definitions.
  */
@@ -316,8 +311,28 @@ struct compat_ipt_entry
 	unsigned char elems[0];
 };
 
+/* Helper functions */
+static inline struct ipt_entry_target *
+compat_ipt_get_target(struct compat_ipt_entry *e)
+{
+	return (void *)e + e->target_offset;
+}
+
 #define COMPAT_IPT_ALIGN(s) 	COMPAT_XT_ALIGN(s)
 
+/* fn returns 0 to continue iteration */
+#define COMPAT_IPT_MATCH_ITERATE(e, fn, args...) \
+	XT_MATCH_ITERATE(struct compat_ipt_entry, e, fn, ## args)
+
+/* fn returns 0 to continue iteration */
+#define COMPAT_IPT_ENTRY_ITERATE(entries, size, fn, args...) \
+	XT_ENTRY_ITERATE(struct compat_ipt_entry, entries, size, fn, ## args)
+
+/* fn returns 0 to continue iteration */
+#define COMPAT_IPT_ENTRY_ITERATE_CONTINUE(entries, size, n, fn, args...) \
+	XT_ENTRY_ITERATE_CONTINUE(struct compat_ipt_entry, entries, size, n, \
+				  fn, ## args)
+
 #endif /* CONFIG_COMPAT */
 #endif /*__KERNEL__*/
 #endif /* _IPTABLES_H */
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index cc896fe..d8caa1e 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1559,7 +1559,7 @@ compat_release_match(struct ipt_entry_match *m, unsigned int *i)
 }
 
 static inline int
-compat_release_entry(struct ipt_entry *e, unsigned int *i)
+compat_release_entry(struct compat_ipt_entry *e, unsigned int *i)
 {
 	struct ipt_entry_target *t;
 
@@ -1567,14 +1567,14 @@ compat_release_entry(struct ipt_entry *e, unsigned int *i)
 		return 1;
 
 	/* Cleanup all matches */
-	IPT_MATCH_ITERATE(e, compat_release_match, NULL);
-	t = ipt_get_target(e);
+	COMPAT_IPT_MATCH_ITERATE(e, compat_release_match, NULL);
+	t = compat_ipt_get_target(e);
 	module_put(t->u.kernel.target->me);
 	return 0;
 }
 
 static inline int
-check_compat_entry_size_and_hooks(struct ipt_entry *e,
+check_compat_entry_size_and_hooks(struct compat_ipt_entry *e,
 				  struct xt_table_info *newinfo,
 				  unsigned int *size,
 				  unsigned char *base,
@@ -1603,19 +1603,20 @@ check_compat_entry_size_and_hooks(struct ipt_entry *e,
 		return -EINVAL;
 	}
 
-	ret = check_entry(e, name);
+	/* For purposes of check_entry casting the compat entry is fine */
+	ret = check_entry((struct ipt_entry *)e, name);
 	if (ret)
 		return ret;
 
 	off = sizeof(struct ipt_entry) - sizeof(struct compat_ipt_entry);
 	entry_offset = (void *)e - (void *)base;
 	j = 0;
-	ret = IPT_MATCH_ITERATE(e, compat_find_calc_match, name, &e->ip,
-				e->comefrom, &off, &j);
+	ret = COMPAT_IPT_MATCH_ITERATE(e, compat_find_calc_match, name,
+				       &e->ip, e->comefrom, &off, &j);
 	if (ret != 0)
 		goto release_matches;
 
-	t = ipt_get_target(e);
+	t = compat_ipt_get_target(e);
 	target = try_then_request_module(xt_find_target(AF_INET,
 							t->u.user.name,
 							t->u.user.revision),
@@ -1643,7 +1644,7 @@ check_compat_entry_size_and_hooks(struct ipt_entry *e,
 	}
 
 	/* Clear counters and comefrom */
-	e->counters = ((struct ipt_counters) { 0, 0 });
+	memset(&e->counters, 0, sizeof(e->counters));
 	e->comefrom = 0;
 
 	(*i)++;
@@ -1657,7 +1658,7 @@ release_matches:
 }
 
 static int
-compat_copy_entry_from_user(struct ipt_entry *e, void **dstptr,
+compat_copy_entry_from_user(struct compat_ipt_entry *e, void **dstptr,
 			    unsigned int *size, const char *name,
 			    struct xt_table_info *newinfo, unsigned char *base)
 {
@@ -1671,15 +1672,17 @@ compat_copy_entry_from_user(struct ipt_entry *e, void **dstptr,
 	origsize = *size;
 	de = (struct ipt_entry *)*dstptr;
 	memcpy(de, e, sizeof(struct ipt_entry));
+	memcpy(&de->counters, &e->counters, sizeof(e->counters));
 
-	*dstptr += sizeof(struct compat_ipt_entry);
+	*dstptr += sizeof(struct ipt_entry);
 	*size += sizeof(struct ipt_entry) - sizeof(struct compat_ipt_entry);
 
-	ret = IPT_MATCH_ITERATE(e, xt_compat_match_from_user, dstptr, size);
+	ret = COMPAT_IPT_MATCH_ITERATE(e, xt_compat_match_from_user,
+				       dstptr, size);
 	if (ret)
 		return ret;
 	de->target_offset = e->target_offset - (origsize - *size);
-	t = ipt_get_target(e);
+	t = compat_ipt_get_target(e);
 	target = t->u.kernel.target;
 	xt_compat_target_from_user(t, dstptr, size);
 
@@ -1746,11 +1749,11 @@ translate_compat_table(const char *name,
 	j = 0;
 	xt_compat_lock(AF_INET);
 	/* Walk through entries, checking offsets. */
-	ret = IPT_ENTRY_ITERATE(entry0, total_size,
-				check_compat_entry_size_and_hooks,
-				info, &size, entry0,
-				entry0 + total_size,
-				hook_entries, underflows, &j, name);
+	ret = COMPAT_IPT_ENTRY_ITERATE(entry0, total_size,
+				       check_compat_entry_size_and_hooks,
+				       info, &size, entry0,
+				       entry0 + total_size,
+				       hook_entries, underflows, &j, name);
 	if (ret != 0)
 		goto out_unlock;
 
@@ -1791,9 +1794,9 @@ translate_compat_table(const char *name,
 	entry1 = newinfo->entries[raw_smp_processor_id()];
 	pos = entry1;
 	size = total_size;
-	ret = IPT_ENTRY_ITERATE(entry0, total_size,
-				compat_copy_entry_from_user, &pos, &size,
-				name, newinfo, entry1);
+	ret = COMPAT_IPT_ENTRY_ITERATE(entry0, total_size,
+				       compat_copy_entry_from_user, &pos, &size,
+				       name, newinfo, entry1);
 	compat_flush_offsets();
 	xt_compat_unlock(AF_INET);
 	if (ret)
@@ -1808,8 +1811,8 @@ translate_compat_table(const char *name,
 				name, &i);
 	if (ret) {
 		j -= i;
-		IPT_ENTRY_ITERATE_CONTINUE(entry1, newinfo->size, i,
-					   compat_release_entry, &j);
+		COMPAT_IPT_ENTRY_ITERATE_CONTINUE(entry0, newinfo->size, i,
+						  compat_release_entry, &j);
 		IPT_ENTRY_ITERATE(entry1, newinfo->size, cleanup_entry, &i);
 		xt_free_table_info(newinfo);
 		return ret;
@@ -1828,7 +1831,7 @@ translate_compat_table(const char *name,
 free_newinfo:
 	xt_free_table_info(newinfo);
 out:
-	IPT_ENTRY_ITERATE(entry0, total_size, compat_release_entry, &j);
+	COMPAT_IPT_ENTRY_ITERATE(entry0, total_size, compat_release_entry, &j);
 	return ret;
 out_unlock:
 	compat_flush_offsets();
