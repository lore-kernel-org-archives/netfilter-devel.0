From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/03]: ip_tables: fix compat related crash
Date: Tue,  5 Jun 2007 15:35:11 +0200 (MEST)
Message-ID: <20070605133511.10309.33387.sendpatchset@localhost.localdomain>
References: <20070605133508.10309.36756.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070605133508.10309.36756.sendpatchset@localhost.localdomain>
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

[NETFILTER]: ip_tables: fix compat related crash

check_compat_entry_size_and_hooks iterates over the matches and calls
compat_check_calc_match, which loads the match and calculates the
compat offsets, but unlike the non-compat version, doesn't call
->checkentry yet. On error however it calls cleanup_matches, which in
turn calls ->destroy, which can result in crashes if the destroy
function (validly) expects to only get called after the checkentry
function.

Add a compat_release_match function that only drops the module reference
on error and rename compat_check_calc_match to compat_find_calc_match to
reflect the fact that it doesn't call the checkentry function.

Reported by Jan Engelhardt <jengelh@linux01.gwdg.de>

Signed-off-by: Dmitry Mishin <dim@openvz.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit b14c27ef9486854969ae471aa5818b1e1352a0d7
tree 9ad281718d3780c20b7dc147d7ff8be0d0bbf298
parent eed17841cda83ffa195b9e5ec4d5ee4b6840ed17
author Dmitry Mishin <dim@openvz.org> Tue, 05 Jun 2007 15:33:02 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 05 Jun 2007 15:33:02 +0200

 include/linux/netfilter_ipv4/ip_tables.h |   20 +++++++
 net/ipv4/netfilter/ip_tables.c           |   81 +++++++++++++++++++++++-------
 2 files changed, 83 insertions(+), 18 deletions(-)

diff --git a/include/linux/netfilter_ipv4/ip_tables.h b/include/linux/netfilter_ipv4/ip_tables.h
index 2f46dd7..e992cd6 100644
--- a/include/linux/netfilter_ipv4/ip_tables.h
+++ b/include/linux/netfilter_ipv4/ip_tables.h
@@ -264,6 +264,26 @@ ipt_get_target(struct ipt_entry *e)
 	__ret;							\
 })
 
+/* fn returns 0 to continue iteration */
+#define IPT_ENTRY_ITERATE_CONTINUE(entries, size, n, fn, args...) \
+({								\
+	unsigned int __i, __n;					\
+	int __ret = 0;						\
+	struct ipt_entry *__entry;				\
+								\
+	for (__i = 0, __n = 0; __i < (size);			\
+	     __i += __entry->next_offset, __n++) { 		\
+		__entry = (void *)(entries) + __i;		\
+		if (__n < n)					\
+			continue;				\
+								\
+		__ret = fn(__entry , ## args);			\
+		if (__ret != 0)					\
+			break;					\
+	}							\
+	__ret;							\
+})
+
 /*
  *	Main firewall chains definitions and global var's definitions.
  */
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index e3f83bf..9bacf1a 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -499,7 +499,8 @@ check_entry(struct ipt_entry *e, const char *name)
 }
 
 static inline int check_match(struct ipt_entry_match *m, const char *name,
-				const struct ipt_ip *ip, unsigned int hookmask)
+				const struct ipt_ip *ip, unsigned int hookmask,
+				unsigned int *i)
 {
 	struct xt_match *match;
 	int ret;
@@ -515,6 +516,8 @@ static inline int check_match(struct ipt_entry_match *m, const char *name,
 			 m->u.kernel.match->name);
 		ret = -EINVAL;
 	}
+	if (!ret)
+		(*i)++;
 	return ret;
 }
 
@@ -537,11 +540,10 @@ find_check_match(struct ipt_entry_match *m,
 	}
 	m->u.kernel.match = match;
 
-	ret = check_match(m, name, ip, hookmask);
+	ret = check_match(m, name, ip, hookmask, i);
 	if (ret)
 		goto err;
 
-	(*i)++;
 	return 0;
 err:
 	module_put(m->u.kernel.match->me);
@@ -1425,7 +1427,7 @@ out:
 }
 
 static inline int
-compat_check_calc_match(struct ipt_entry_match *m,
+compat_find_calc_match(struct ipt_entry_match *m,
 	    const char *name,
 	    const struct ipt_ip *ip,
 	    unsigned int hookmask,
@@ -1449,6 +1451,31 @@ compat_check_calc_match(struct ipt_entry_match *m,
 }
 
 static inline int
+compat_release_match(struct ipt_entry_match *m, unsigned int *i)
+{
+	if (i && (*i)-- == 0)
+		return 1;
+
+	module_put(m->u.kernel.match->me);
+	return 0;
+}
+
+static inline int
+compat_release_entry(struct ipt_entry *e, unsigned int *i)
+{
+	struct ipt_entry_target *t;
+
+	if (i && (*i)-- == 0)
+		return 1;
+
+	/* Cleanup all matches */
+	IPT_MATCH_ITERATE(e, compat_release_match, NULL);
+	t = ipt_get_target(e);
+	module_put(t->u.kernel.target->me);
+	return 0;
+}
+
+static inline int
 check_compat_entry_size_and_hooks(struct ipt_entry *e,
 			   struct xt_table_info *newinfo,
 			   unsigned int *size,
@@ -1485,10 +1512,10 @@ check_compat_entry_size_and_hooks(struct ipt_entry *e,
 	off = 0;
 	entry_offset = (void *)e - (void *)base;
 	j = 0;
-	ret = IPT_MATCH_ITERATE(e, compat_check_calc_match, name, &e->ip,
+	ret = IPT_MATCH_ITERATE(e, compat_find_calc_match, name, &e->ip,
 			e->comefrom, &off, &j);
 	if (ret != 0)
-		goto cleanup_matches;
+		goto release_matches;
 
 	t = ipt_get_target(e);
 	target = try_then_request_module(xt_find_target(AF_INET,
@@ -1499,7 +1526,7 @@ check_compat_entry_size_and_hooks(struct ipt_entry *e,
 		duprintf("check_compat_entry_size_and_hooks: `%s' not found\n",
 							t->u.user.name);
 		ret = target ? PTR_ERR(target) : -ENOENT;
-		goto cleanup_matches;
+		goto release_matches;
 	}
 	t->u.kernel.target = target;
 
@@ -1526,8 +1553,8 @@ check_compat_entry_size_and_hooks(struct ipt_entry *e,
 
 out:
 	module_put(t->u.kernel.target->me);
-cleanup_matches:
-	IPT_MATCH_ITERATE(e, cleanup_match, &j);
+release_matches:
+	IPT_MATCH_ITERATE(e, compat_release_match, &j);
 	return ret;
 }
 
@@ -1574,15 +1601,26 @@ static int compat_copy_entry_from_user(struct ipt_entry *e, void **dstptr,
 	return ret;
 }
 
-static inline int compat_check_entry(struct ipt_entry *e, const char *name)
+static inline int compat_check_entry(struct ipt_entry *e, const char *name,
+						unsigned int *i)
 {
-	int ret;
+	int j, ret;
 
-	ret = IPT_MATCH_ITERATE(e, check_match, name, &e->ip, e->comefrom);
+	j = 0;
+	ret = IPT_MATCH_ITERATE(e, check_match, name, &e->ip, e->comefrom, &j);
 	if (ret)
-		return ret;
+		goto cleanup_matches;
+
+	ret = check_target(e, name);
+	if (ret)
+		goto cleanup_matches;
 
-	return check_target(e, name);
+	(*i)++;
+	return 0;
+
+ cleanup_matches:
+	IPT_MATCH_ITERATE(e, cleanup_match, &j);
+	return ret;
 }
 
 static int
@@ -1673,10 +1711,17 @@ translate_compat_table(const char *name,
 	if (!mark_source_chains(newinfo, valid_hooks, entry1))
 		goto free_newinfo;
 
+	i = 0;
 	ret = IPT_ENTRY_ITERATE(entry1, newinfo->size, compat_check_entry,
-									name);
-	if (ret)
-		goto free_newinfo;
+								name, &i);
+	if (ret) {
+		j -= i;
+		IPT_ENTRY_ITERATE_CONTINUE(entry1, newinfo->size, i,
+						compat_release_entry, &j);
+		IPT_ENTRY_ITERATE(entry1, newinfo->size, cleanup_entry, &i);
+		xt_free_table_info(newinfo);
+		return ret;
+	}
 
 	/* And one copy for every other CPU */
 	for_each_possible_cpu(i)
@@ -1691,7 +1736,7 @@ translate_compat_table(const char *name,
 free_newinfo:
 	xt_free_table_info(newinfo);
 out:
-	IPT_ENTRY_ITERATE(entry0, total_size, cleanup_entry, &j);
+	IPT_ENTRY_ITERATE(entry0, total_size, compat_release_entry, &j);
 	return ret;
 out_unlock:
 	compat_flush_offsets();
