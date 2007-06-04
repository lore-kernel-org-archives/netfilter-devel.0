From: Dmitry Mishin <dim@openvz.org>
Subject: Re: iptables throws unknown error - suspecting 32/64 compat issue
Date: Mon, 4 Jun 2007 11:54:10 +0400
Message-ID: <200706041154.11187.dim@openvz.org>
References: <Pine.LNX.4.61.0705100812440.32349@yvahk01.tjqt.qr>
	<200706031047.44848.dim@openvz.org> <4662F2E9.1090903@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: sparclinux@vger.kernel.org,
	Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4662F2E9.1090903@trash.net>
Content-Disposition: inline
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

On Sunday 03 June 2007 20:57, Patrick McHardy wrote:
> Dmitry Mishin wrote:
> > On Saturday 02 June 2007 16:54, Patrick McHardy wrote:
> >>Here it is, could you please test whether it fixes the crash by
> >>backing out the hashlimit compat patch and triggering the size
> >>error again? Thanks.
> >
> > Patrick,
> > it looks like translate_compat_table() should be fixed also.
>
> You're right, thanks for catching this. This patch should be
> better.
It's better, but I see the issue with iterate with compat_check_entry() calls.
If it fails, some of target/matches' check_* functions are called, some not.
Please, review my version of this patch.

Signed-off-by: Dmitry Mishin <dim@openvz.org>
---
diff --git a/include/linux/netfilter_ipv4/ip_tables.h 
b/include/linux/netfilter_ipv4/ip_tables.h
index 2f46dd7..9c294a5 100644
--- a/include/linux/netfilter_ipv4/ip_tables.h
+++ b/include/linux/netfilter_ipv4/ip_tables.h
@@ -264,6 +264,23 @@ ({								\
 	__ret;							\
 })
 
+/* fn returns 0 to continue iteration */
+#define IPT_ENTRY_ITERATE_CONTINUE(entries, size, i, fn, args...) \
+({								\
+	unsigned int __i;					\
+	int __ret = 0;						\
+	struct ipt_entry *__entry;				\
+								\
+	for (__i = i; __i < (size); __i += __entry->next_offset) { \
+		__entry = (void *)(entries) + __i;		\
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
@@ -499,7 +499,8 @@ check_entry(struct ipt_entry *e, const c
 }
 
 static inline int check_match(struct ipt_entry_match *m, const char *name,
-				const struct ipt_ip *ip, unsigned int hookmask)
+				const struct ipt_ip *ip, unsigned int hookmask,
+				unsigned int *i)
 {
 	struct xt_match *match;
 	int ret;
@@ -515,6 +516,8 @@ static inline int check_match(struct ipt
 			 m->u.kernel.match->name);
 		ret = -EINVAL;
 	}
+	if (!ret)
+		(*i)++;
 	return ret;
 }
 
@@ -537,11 +540,10 @@ find_check_match(struct ipt_entry_match 
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
@@ -1449,6 +1451,31 @@ compat_check_calc_match(struct ipt_entry
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
@@ -1485,10 +1512,10 @@ check_compat_entry_size_and_hooks(struct
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
@@ -1499,7 +1526,7 @@ check_compat_entry_size_and_hooks(struct
 		duprintf("check_compat_entry_size_and_hooks: `%s' not found\n",
 							t->u.user.name);
 		ret = target ? PTR_ERR(target) : -ENOENT;
-		goto cleanup_matches;
+		goto release_matches;
 	}
 	t->u.kernel.target = target;
 
@@ -1526,8 +1553,8 @@ check_compat_entry_size_and_hooks(struct
 
 out:
 	module_put(t->u.kernel.target->me);
-cleanup_matches:
-	IPT_MATCH_ITERATE(e, cleanup_match, &j);
+release_matches:
+	IPT_MATCH_ITERATE(e, compat_release_match, &j);
 	return ret;
 }
 
@@ -1574,15 +1601,26 @@ static int compat_copy_entry_from_user(s
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
