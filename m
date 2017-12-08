From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 1/3] netfilter: xtables: add and use xt_request_find_table_lock
Date: Fri,  8 Dec 2017 17:01:53 +0100
Message-ID: <20171208160155.968-2-fw@strlen.de>
References: <20171208160155.968-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:52220 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754101AbdLHQCX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Dec 2017 11:02:23 -0500
In-Reply-To: <20171208160155.968-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

currently we always return -ENOENT to userspace if we can't find
a particular table, or if the table initialization fails.

Followup patch will make nat table init fail in case nftables already
registered a nat hook so this change makes xt_find_table_lock return
an ERR_PTR to return the errno value reported from the table init
function.

Add xt_request_find_table_lock as try_then_request_module replacement
and use it where needed.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter/x_tables.h |  2 ++
 net/ipv4/netfilter/arp_tables.c    | 26 ++++++++++++--------------
 net/ipv4/netfilter/ip_tables.c     | 26 ++++++++++++--------------
 net/ipv6/netfilter/ip6_tables.c    | 26 ++++++++++++--------------
 net/netfilter/x_tables.c           | 37 +++++++++++++++++++++++++++----------
 5 files changed, 65 insertions(+), 52 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 33f7530f96b9..1313b35c3ab7 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -320,6 +320,8 @@ int xt_find_revision(u8 af, const char *name, u8 revision, int target,
 
 struct xt_table *xt_find_table_lock(struct net *net, u_int8_t af,
 				    const char *name);
+struct xt_table *xt_request_find_table_lock(struct net *net, u_int8_t af,
+					    const char *name);
 void xt_table_unlock(struct xt_table *t);
 
 int xt_proto_init(struct net *net, u_int8_t af);
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index f88221aebc9d..8cfe3d37cbb1 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -811,9 +811,8 @@ static int get_info(struct net *net, void __user *user,
 	if (compat)
 		xt_compat_lock(NFPROTO_ARP);
 #endif
-	t = try_then_request_module(xt_find_table_lock(net, NFPROTO_ARP, name),
-				    "arptable_%s", name);
-	if (t) {
+	t = xt_request_find_table_lock(net, NFPROTO_ARP, name);
+	if (!IS_ERR(t)) {
 		struct arpt_getinfo info;
 		const struct xt_table_info *private = t->private;
 #ifdef CONFIG_COMPAT
@@ -842,7 +841,7 @@ static int get_info(struct net *net, void __user *user,
 		xt_table_unlock(t);
 		module_put(t->me);
 	} else
-		ret = -ENOENT;
+		ret = PTR_ERR(t);
 #ifdef CONFIG_COMPAT
 	if (compat)
 		xt_compat_unlock(NFPROTO_ARP);
@@ -867,7 +866,7 @@ static int get_entries(struct net *net, struct arpt_get_entries __user *uptr,
 	get.name[sizeof(get.name) - 1] = '\0';
 
 	t = xt_find_table_lock(net, NFPROTO_ARP, get.name);
-	if (t) {
+	if (!IS_ERR(t)) {
 		const struct xt_table_info *private = t->private;
 
 		if (get.size == private->size)
@@ -879,7 +878,7 @@ static int get_entries(struct net *net, struct arpt_get_entries __user *uptr,
 		module_put(t->me);
 		xt_table_unlock(t);
 	} else
-		ret = -ENOENT;
+		ret = PTR_ERR(t);
 
 	return ret;
 }
@@ -904,10 +903,9 @@ static int __do_replace(struct net *net, const char *name,
 		goto out;
 	}
 
-	t = try_then_request_module(xt_find_table_lock(net, NFPROTO_ARP, name),
-				    "arptable_%s", name);
-	if (!t) {
-		ret = -ENOENT;
+	t = xt_request_find_table_lock(net, NFPROTO_ARP, name);
+	if (IS_ERR(t)) {
+		ret = ERR_PTR(t);
 		goto free_newinfo_counters_untrans;
 	}
 
@@ -1021,8 +1019,8 @@ static int do_add_counters(struct net *net, const void __user *user,
 		return PTR_ERR(paddc);
 
 	t = xt_find_table_lock(net, NFPROTO_ARP, tmp.name);
-	if (!t) {
-		ret = -ENOENT;
+	if (IS_ERR(t)) {
+		ret = ERR_PTR(t);
 		goto free;
 	}
 
@@ -1409,7 +1407,7 @@ static int compat_get_entries(struct net *net,
 
 	xt_compat_lock(NFPROTO_ARP);
 	t = xt_find_table_lock(net, NFPROTO_ARP, get.name);
-	if (t) {
+	if (!IS_ERR(t)) {
 		const struct xt_table_info *private = t->private;
 		struct xt_table_info info;
 
@@ -1424,7 +1422,7 @@ static int compat_get_entries(struct net *net,
 		module_put(t->me);
 		xt_table_unlock(t);
 	} else
-		ret = -ENOENT;
+		ret = PTR_ERR(t);
 
 	xt_compat_unlock(NFPROTO_ARP);
 	return ret;
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 4cbe5e80f3bf..38e3a19dbac3 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -974,9 +974,8 @@ static int get_info(struct net *net, void __user *user,
 	if (compat)
 		xt_compat_lock(AF_INET);
 #endif
-	t = try_then_request_module(xt_find_table_lock(net, AF_INET, name),
-				    "iptable_%s", name);
-	if (t) {
+	t = xt_request_find_table_lock(net, AF_INET, name);
+	if (!IS_ERR(t)) {
 		struct ipt_getinfo info;
 		const struct xt_table_info *private = t->private;
 #ifdef CONFIG_COMPAT
@@ -1006,7 +1005,7 @@ static int get_info(struct net *net, void __user *user,
 		xt_table_unlock(t);
 		module_put(t->me);
 	} else
-		ret = -ENOENT;
+		ret = PTR_ERR(t);
 #ifdef CONFIG_COMPAT
 	if (compat)
 		xt_compat_unlock(AF_INET);
@@ -1031,7 +1030,7 @@ get_entries(struct net *net, struct ipt_get_entries __user *uptr,
 	get.name[sizeof(get.name) - 1] = '\0';
 
 	t = xt_find_table_lock(net, AF_INET, get.name);
-	if (t) {
+	if (!IS_ERR(t)) {
 		const struct xt_table_info *private = t->private;
 		if (get.size == private->size)
 			ret = copy_entries_to_user(private->size,
@@ -1042,7 +1041,7 @@ get_entries(struct net *net, struct ipt_get_entries __user *uptr,
 		module_put(t->me);
 		xt_table_unlock(t);
 	} else
-		ret = -ENOENT;
+		ret = PTR_ERR(t);
 
 	return ret;
 }
@@ -1065,10 +1064,9 @@ __do_replace(struct net *net, const char *name, unsigned int valid_hooks,
 		goto out;
 	}
 
-	t = try_then_request_module(xt_find_table_lock(net, AF_INET, name),
-				    "iptable_%s", name);
-	if (!t) {
-		ret = -ENOENT;
+	t = xt_request_find_table_lock(net, AF_INET, name);
+	if (IS_ERR(t)) {
+		ret = PTR_ERR(t);
 		goto free_newinfo_counters_untrans;
 	}
 
@@ -1182,8 +1180,8 @@ do_add_counters(struct net *net, const void __user *user,
 		return PTR_ERR(paddc);
 
 	t = xt_find_table_lock(net, AF_INET, tmp.name);
-	if (!t) {
-		ret = -ENOENT;
+	if (IS_ERR(t)) {
+		ret = PTR_ERR(t);
 		goto free;
 	}
 
@@ -1626,7 +1624,7 @@ compat_get_entries(struct net *net, struct compat_ipt_get_entries __user *uptr,
 
 	xt_compat_lock(AF_INET);
 	t = xt_find_table_lock(net, AF_INET, get.name);
-	if (t) {
+	if (!IS_ERR(t)) {
 		const struct xt_table_info *private = t->private;
 		struct xt_table_info info;
 		ret = compat_table_info(private, &info);
@@ -1640,7 +1638,7 @@ compat_get_entries(struct net *net, struct compat_ipt_get_entries __user *uptr,
 		module_put(t->me);
 		xt_table_unlock(t);
 	} else
-		ret = -ENOENT;
+		ret = PTR_ERR(t);
 
 	xt_compat_unlock(AF_INET);
 	return ret;
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index f06e25065a34..fb7bb55ab788 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -992,9 +992,8 @@ static int get_info(struct net *net, void __user *user,
 	if (compat)
 		xt_compat_lock(AF_INET6);
 #endif
-	t = try_then_request_module(xt_find_table_lock(net, AF_INET6, name),
-				    "ip6table_%s", name);
-	if (t) {
+	t = xt_request_find_table_lock(net, AF_INET6, name);
+	if (!IS_ERR(t)) {
 		struct ip6t_getinfo info;
 		const struct xt_table_info *private = t->private;
 #ifdef CONFIG_COMPAT
@@ -1024,7 +1023,7 @@ static int get_info(struct net *net, void __user *user,
 		xt_table_unlock(t);
 		module_put(t->me);
 	} else
-		ret = -ENOENT;
+		ret = PTR_ERR(t);
 #ifdef CONFIG_COMPAT
 	if (compat)
 		xt_compat_unlock(AF_INET6);
@@ -1050,7 +1049,7 @@ get_entries(struct net *net, struct ip6t_get_entries __user *uptr,
 	get.name[sizeof(get.name) - 1] = '\0';
 
 	t = xt_find_table_lock(net, AF_INET6, get.name);
-	if (t) {
+	if (!IS_ERR(t)) {
 		struct xt_table_info *private = t->private;
 		if (get.size == private->size)
 			ret = copy_entries_to_user(private->size,
@@ -1061,7 +1060,7 @@ get_entries(struct net *net, struct ip6t_get_entries __user *uptr,
 		module_put(t->me);
 		xt_table_unlock(t);
 	} else
-		ret = -ENOENT;
+		ret = PTR_ERR(t);
 
 	return ret;
 }
@@ -1084,10 +1083,9 @@ __do_replace(struct net *net, const char *name, unsigned int valid_hooks,
 		goto out;
 	}
 
-	t = try_then_request_module(xt_find_table_lock(net, AF_INET6, name),
-				    "ip6table_%s", name);
-	if (!t) {
-		ret = -ENOENT;
+	t = xt_request_find_table_lock(net, AF_INET6, name);
+	if (IS_ERR(t)) {
+		ret = PTR_ERR(t);
 		goto free_newinfo_counters_untrans;
 	}
 
@@ -1200,8 +1198,8 @@ do_add_counters(struct net *net, const void __user *user, unsigned int len,
 	if (IS_ERR(paddc))
 		return PTR_ERR(paddc);
 	t = xt_find_table_lock(net, AF_INET6, tmp.name);
-	if (!t) {
-		ret = -ENOENT;
+	if (IS_ERR(t)) {
+		ret = PTR_ERR(t);
 		goto free;
 	}
 
@@ -1637,7 +1635,7 @@ compat_get_entries(struct net *net, struct compat_ip6t_get_entries __user *uptr,
 
 	xt_compat_lock(AF_INET6);
 	t = xt_find_table_lock(net, AF_INET6, get.name);
-	if (t) {
+	if (!IS_ERR(t)) {
 		const struct xt_table_info *private = t->private;
 		struct xt_table_info info;
 		ret = compat_table_info(private, &info);
@@ -1651,7 +1649,7 @@ compat_get_entries(struct net *net, struct compat_ip6t_get_entries __user *uptr,
 		module_put(t->me);
 		xt_table_unlock(t);
 	} else
-		ret = -ENOENT;
+		ret = PTR_ERR(t);
 
 	xt_compat_unlock(AF_INET6);
 	return ret;
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 7c1414e89f4d..40360bae7792 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1027,7 +1027,7 @@ void xt_free_table_info(struct xt_table_info *info)
 }
 EXPORT_SYMBOL(xt_free_table_info);
 
-/* Find table by name, grabs mutex & ref.  Returns NULL on error. */
+/* Find table by name, grabs mutex & ref.  Returns ERR_PTR on error. */
 struct xt_table *xt_find_table_lock(struct net *net, u_int8_t af,
 				    const char *name)
 {
@@ -1043,17 +1043,17 @@ struct xt_table *xt_find_table_lock(struct net *net, u_int8_t af,
 
 	/* Table doesn't exist in this netns, re-try init */
 	list_for_each_entry(t, &init_net.xt.tables[af], list) {
+		int err;
+
 		if (strcmp(t->name, name))
 			continue;
-		if (!try_module_get(t->me)) {
-			mutex_unlock(&xt[af].mutex);
-			return NULL;
-		}
-
+		if (!try_module_get(t->me))
+			goto out;
 		mutex_unlock(&xt[af].mutex);
-		if (t->table_init(net) != 0) {
+		err = t->table_init(net);
+		if (err < 0) {
 			module_put(t->me);
-			return NULL;
+			return ERR_PTR(err);
 		}
 
 		found = t;
@@ -1073,9 +1073,26 @@ struct xt_table *xt_find_table_lock(struct net *net, u_int8_t af,
 	module_put(found->me);
  out:
 	mutex_unlock(&xt[af].mutex);
-	return NULL;
+	return ERR_PTR(-ENOENT);
+}
+
+struct xt_table *xt_request_find_table_lock(struct net *net, u_int8_t af,
+					    const char *name)
+{
+	struct xt_table *t = xt_find_table_lock(net, af, name);
+
+#ifdef CONFIG_MODULE
+	if (IS_ERR(t)) {
+		int err = request_module("%stable_%s", xt_prefix[af], name);
+		if (err)
+			return ERR_PTR(err);
+		t = xt_find_table_lock(net, af, name);
+	}
+#endif
+
+	return t;
 }
-EXPORT_SYMBOL_GPL(xt_find_table_lock);
+EXPORT_SYMBOL_GPL(xt_request_find_table_lock);
 
 void xt_table_unlock(struct xt_table *table)
 {
-- 
2.13.6

