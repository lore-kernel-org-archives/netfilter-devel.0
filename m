From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/05]: Missed and reordered checks in {arp, ip,
	ip6}_tables
Date: Mon, 30 Oct 2006 19:18:58 +0100 (MET)
Message-ID: <20061030181856.32038.26860.sendpatchset@localhost.localdomain>
References: <20061030181853.32038.97693.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20061030181853.32038.97693.sendpatchset@localhost.localdomain>
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

[NETFILTER]: Missed and reordered checks in {arp,ip,ip6}_tables

There is a number of issues in parsing user-provided table in
translate_table(). Malicious user with CAP_NET_ADMIN may crash system by
passing special-crafted table to the *_tables.

The first issue is that mark_source_chains() function is called before entry
content checks. In case of standard target, mark_source_chains() function
uses t->verdict field in order to determine new position. But the check, that
this field leads no further, than the table end, is in check_entry(), which
is called later, than mark_source_chains().

The second issue, that there is no check that target_offset points inside
entry. If so, *_ITERATE_MATCH macro will follow further, than the entry
ends. As a result, we'll have oops or memory disclosure.

And the third issue, that there is no check that the target is completely
inside entry. Results are the same, as in previous issue.

Signed-off-by: Dmitry Mishin <dim@openvz.org>
Acked-by: Kirill Korotaev <dev@openvz.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit b59a94e9119db15b4d28869997f615f236081e58
tree 2dada64d71bbd5606aec0960643e11f633b1513b
parent 68c5f8eb167a363d431d3ed02c052a60b3902ab7
author Dmitry Mishin <dim@openvz.org> Mon, 30 Oct 2006 16:28:13 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 30 Oct 2006 16:28:13 +0100

 net/ipv4/netfilter/arp_tables.c |   25 ++++++++++++++++---------
 net/ipv4/netfilter/ip_tables.c  |   30 ++++++++++++++++++++++--------
 net/ipv6/netfilter/ip6_tables.c |   24 ++++++++++++++++--------
 3 files changed, 54 insertions(+), 25 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 0849f1c..413c2d0 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -466,7 +466,13 @@ static inline int check_entry(struct arp
 		return -EINVAL;
 	}
 
+	if (e->target_offset + sizeof(struct arpt_entry_target) > e->next_offset)
+		return -EINVAL;
+
 	t = arpt_get_target(e);
+	if (e->target_offset + t->u.target_size > e->next_offset)
+		return -EINVAL;
+
 	target = try_then_request_module(xt_find_target(NF_ARP, t->u.user.name,
 							t->u.user.revision),
 					 "arpt_%s", t->u.user.name);
@@ -621,20 +627,18 @@ static int translate_table(const char *n
 		}
 	}
 
-	if (!mark_source_chains(newinfo, valid_hooks, entry0)) {
-		duprintf("Looping hook\n");
-		return -ELOOP;
-	}
-
 	/* Finally, each sanity check must pass */
 	i = 0;
 	ret = ARPT_ENTRY_ITERATE(entry0, newinfo->size,
 				 check_entry, name, size, &i);
 
-	if (ret != 0) {
-		ARPT_ENTRY_ITERATE(entry0, newinfo->size,
-				   cleanup_entry, &i);
-		return ret;
+	if (ret != 0)
+		goto cleanup;
+
+	ret = -ELOOP;
+	if (!mark_source_chains(newinfo, valid_hooks, entry0)) {
+		duprintf("Looping hook\n");
+		goto cleanup;
 	}
 
 	/* And one copy for every other CPU */
@@ -643,6 +647,9 @@ static int translate_table(const char *n
 			memcpy(newinfo->entries[i], entry0, newinfo->size);
 	}
 
+	return 0;
+cleanup:
+	ARPT_ENTRY_ITERATE(entry0, newinfo->size, cleanup_entry, &i);
 	return ret;
 }
 
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 4b90927..e2c7f6e 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -547,12 +547,18 @@ check_entry(struct ipt_entry *e, const c
 		return -EINVAL;
 	}
 
+	if (e->target_offset + sizeof(struct ipt_entry_target) > e->next_offset)
+		return -EINVAL;
+
 	j = 0;
 	ret = IPT_MATCH_ITERATE(e, check_match, name, &e->ip, e->comefrom, &j);
 	if (ret != 0)
 		goto cleanup_matches;
 
 	t = ipt_get_target(e);
+	ret = -EINVAL;
+	if (e->target_offset + t->u.target_size > e->next_offset)
+			goto cleanup_matches;
 	target = try_then_request_module(xt_find_target(AF_INET,
 						     t->u.user.name,
 						     t->u.user.revision),
@@ -712,19 +718,17 @@ translate_table(const char *name,
 		}
 	}
 
-	if (!mark_source_chains(newinfo, valid_hooks, entry0))
-		return -ELOOP;
-
 	/* Finally, each sanity check must pass */
 	i = 0;
 	ret = IPT_ENTRY_ITERATE(entry0, newinfo->size,
 				check_entry, name, size, &i);
 
-	if (ret != 0) {
-		IPT_ENTRY_ITERATE(entry0, newinfo->size,
-				  cleanup_entry, &i);
-		return ret;
-	}
+	if (ret != 0)
+		goto cleanup;
+
+	ret = -ELOOP;
+	if (!mark_source_chains(newinfo, valid_hooks, entry0))
+		goto cleanup;
 
 	/* And one copy for every other CPU */
 	for_each_possible_cpu(i) {
@@ -732,6 +736,9 @@ translate_table(const char *name,
 			memcpy(newinfo->entries[i], entry0, newinfo->size);
 	}
 
+	return 0;
+cleanup:
+	IPT_ENTRY_ITERATE(entry0, newinfo->size, cleanup_entry, &i);
 	return ret;
 }
 
@@ -1463,6 +1470,10 @@ check_compat_entry_size_and_hooks(struct
 		return -EINVAL;
 	}
 
+	if (e->target_offset + sizeof(struct compat_xt_entry_target) >
+								e->next_offset)
+		return -EINVAL;
+
 	off = 0;
 	entry_offset = (void *)e - (void *)base;
 	j = 0;
@@ -1472,6 +1483,9 @@ check_compat_entry_size_and_hooks(struct
 		goto cleanup_matches;
 
 	t = ipt_get_target(e);
+	ret = -EINVAL;
+	if (e->target_offset + t->u.target_size > e->next_offset)
+			goto cleanup_matches;
 	target = try_then_request_module(xt_find_target(AF_INET,
 						     t->u.user.name,
 						     t->u.user.revision),
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 53bf977..167c2ea 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -586,12 +586,19 @@ check_entry(struct ip6t_entry *e, const 
 		return -EINVAL;
 	}
 
+	if (e->target_offset + sizeof(struct ip6t_entry_target) >
+								e->next_offset)
+		return -EINVAL;
+
 	j = 0;
 	ret = IP6T_MATCH_ITERATE(e, check_match, name, &e->ipv6, e->comefrom, &j);
 	if (ret != 0)
 		goto cleanup_matches;
 
 	t = ip6t_get_target(e);
+	ret = -EINVAL;
+	if (e->target_offset + t->u.target_size > e->next_offset)
+			goto cleanup_matches;
 	target = try_then_request_module(xt_find_target(AF_INET6,
 							t->u.user.name,
 							t->u.user.revision),
@@ -751,19 +758,17 @@ translate_table(const char *name,
 		}
 	}
 
-	if (!mark_source_chains(newinfo, valid_hooks, entry0))
-		return -ELOOP;
-
 	/* Finally, each sanity check must pass */
 	i = 0;
 	ret = IP6T_ENTRY_ITERATE(entry0, newinfo->size,
 				check_entry, name, size, &i);
 
-	if (ret != 0) {
-		IP6T_ENTRY_ITERATE(entry0, newinfo->size,
-				  cleanup_entry, &i);
-		return ret;
-	}
+	if (ret != 0)
+		goto cleanup;
+
+	ret = -ELOOP;
+	if (!mark_source_chains(newinfo, valid_hooks, entry0))
+		goto cleanup;
 
 	/* And one copy for every other CPU */
 	for_each_possible_cpu(i) {
@@ -771,6 +776,9 @@ translate_table(const char *name,
 			memcpy(newinfo->entries[i], entry0, newinfo->size);
 	}
 
+	return 0;
+cleanup:
+	IP6T_ENTRY_ITERATE(entry0, newinfo->size, cleanup_entry, &i);
 	return ret;
 }
 
