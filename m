From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 17/69]: ip6_tables: netns preparation
Date: Wed, 30 Jan 2008 21:17:18 +0100 (MET)
Message-ID: <20080130201716.29874.24115.sendpatchset@localhost.localdomain>
References: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60671 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933465AbYA3URT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:17:19 -0500
In-Reply-To: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: ip6_tables: netns preparation

* Propagate netns from userspace down to xt_find_table_lock()
* Register ip6 tables in netns (modules still use init_net)

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 9b50679c5240114dfca105cd2f7e9df0d187eded
tree ba5e0ad150b5efffa8cc57c44e45f435682d9ea3
parent 4885531d4b5ac7058b8d2414d6f6404eba84d0e8
author Alexey Dobriyan <adobriyan@sw.ru> Tue, 29 Jan 2008 16:21:59 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 30 Jan 2008 15:04:16 +0100

 include/linux/netfilter_ipv6/ip6_tables.h |    3 +-
 net/ipv6/netfilter/ip6_tables.c           |   51 +++++++++++++++--------------
 net/ipv6/netfilter/ip6table_filter.c      |    2 +
 net/ipv6/netfilter/ip6table_mangle.c      |    2 +
 net/ipv6/netfilter/ip6table_raw.c         |    2 +
 5 files changed, 32 insertions(+), 28 deletions(-)

diff --git a/include/linux/netfilter_ipv6/ip6_tables.h b/include/linux/netfilter_ipv6/ip6_tables.h
index f716c75..f2507dc 100644
--- a/include/linux/netfilter_ipv6/ip6_tables.h
+++ b/include/linux/netfilter_ipv6/ip6_tables.h
@@ -305,7 +305,8 @@ ip6t_get_target(struct ip6t_entry *e)
 #include <linux/init.h>
 extern void ip6t_init(void) __init;
 
-extern struct xt_table *ip6t_register_table(struct xt_table *table,
+extern struct xt_table *ip6t_register_table(struct net *net,
+					    struct xt_table *table,
 					    const struct ip6t_replace *repl);
 extern void ip6t_unregister_table(struct xt_table *table);
 extern unsigned int ip6t_do_table(struct sk_buff *skb,
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index b89f133..2453dfd 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1118,7 +1118,7 @@ static int compat_table_info(const struct xt_table_info *info,
 }
 #endif
 
-static int get_info(void __user *user, int *len, int compat)
+static int get_info(struct net *net, void __user *user, int *len, int compat)
 {
 	char name[IP6T_TABLE_MAXNAMELEN];
 	struct xt_table *t;
@@ -1138,7 +1138,7 @@ static int get_info(void __user *user, int *len, int compat)
 	if (compat)
 		xt_compat_lock(AF_INET6);
 #endif
-	t = try_then_request_module(xt_find_table_lock(&init_net, AF_INET6, name),
+	t = try_then_request_module(xt_find_table_lock(net, AF_INET6, name),
 				    "ip6table_%s", name);
 	if (t && !IS_ERR(t)) {
 		struct ip6t_getinfo info;
@@ -1178,7 +1178,7 @@ static int get_info(void __user *user, int *len, int compat)
 }
 
 static int
-get_entries(struct ip6t_get_entries __user *uptr, int *len)
+get_entries(struct net *net, struct ip6t_get_entries __user *uptr, int *len)
 {
 	int ret;
 	struct ip6t_get_entries get;
@@ -1196,7 +1196,7 @@ get_entries(struct ip6t_get_entries __user *uptr, int *len)
 		return -EINVAL;
 	}
 
-	t = xt_find_table_lock(&init_net, AF_INET6, get.name);
+	t = xt_find_table_lock(net, AF_INET6, get.name);
 	if (t && !IS_ERR(t)) {
 		struct xt_table_info *private = t->private;
 		duprintf("t->private->number = %u\n", private->number);
@@ -1217,7 +1217,7 @@ get_entries(struct ip6t_get_entries __user *uptr, int *len)
 }
 
 static int
-__do_replace(const char *name, unsigned int valid_hooks,
+__do_replace(struct net *net, const char *name, unsigned int valid_hooks,
 	     struct xt_table_info *newinfo, unsigned int num_counters,
 	     void __user *counters_ptr)
 {
@@ -1235,7 +1235,7 @@ __do_replace(const char *name, unsigned int valid_hooks,
 		goto out;
 	}
 
-	t = try_then_request_module(xt_find_table_lock(&init_net, AF_INET6, name),
+	t = try_then_request_module(xt_find_table_lock(net, AF_INET6, name),
 				    "ip6table_%s", name);
 	if (!t || IS_ERR(t)) {
 		ret = t ? PTR_ERR(t) : -ENOENT;
@@ -1288,7 +1288,7 @@ __do_replace(const char *name, unsigned int valid_hooks,
 }
 
 static int
-do_replace(void __user *user, unsigned int len)
+do_replace(struct net *net, void __user *user, unsigned int len)
 {
 	int ret;
 	struct ip6t_replace tmp;
@@ -1322,7 +1322,7 @@ do_replace(void __user *user, unsigned int len)
 
 	duprintf("ip_tables: Translated table\n");
 
-	ret = __do_replace(tmp.name, tmp.valid_hooks, newinfo,
+	ret = __do_replace(net, tmp.name, tmp.valid_hooks, newinfo,
 			   tmp.num_counters, tmp.counters);
 	if (ret)
 		goto free_newinfo_untrans;
@@ -1358,7 +1358,8 @@ add_counter_to_entry(struct ip6t_entry *e,
 }
 
 static int
-do_add_counters(void __user *user, unsigned int len, int compat)
+do_add_counters(struct net *net, void __user *user, unsigned int len,
+		int compat)
 {
 	unsigned int i;
 	struct xt_counters_info tmp;
@@ -1410,7 +1411,7 @@ do_add_counters(void __user *user, unsigned int len, int compat)
 		goto free;
 	}
 
-	t = xt_find_table_lock(&init_net, AF_INET6, name);
+	t = xt_find_table_lock(net, AF_INET6, name);
 	if (!t || IS_ERR(t)) {
 		ret = t ? PTR_ERR(t) : -ENOENT;
 		goto free;
@@ -1815,7 +1816,7 @@ out_unlock:
 }
 
 static int
-compat_do_replace(void __user *user, unsigned int len)
+compat_do_replace(struct net *net, void __user *user, unsigned int len)
 {
 	int ret;
 	struct compat_ip6t_replace tmp;
@@ -1852,7 +1853,7 @@ compat_do_replace(void __user *user, unsigned int len)
 
 	duprintf("compat_do_replace: Translated table\n");
 
-	ret = __do_replace(tmp.name, tmp.valid_hooks, newinfo,
+	ret = __do_replace(net, tmp.name, tmp.valid_hooks, newinfo,
 			   tmp.num_counters, compat_ptr(tmp.counters));
 	if (ret)
 		goto free_newinfo_untrans;
@@ -1876,11 +1877,11 @@ compat_do_ip6t_set_ctl(struct sock *sk, int cmd, void __user *user,
 
 	switch (cmd) {
 	case IP6T_SO_SET_REPLACE:
-		ret = compat_do_replace(user, len);
+		ret = compat_do_replace(sk->sk_net, user, len);
 		break;
 
 	case IP6T_SO_SET_ADD_COUNTERS:
-		ret = do_add_counters(user, len, 1);
+		ret = do_add_counters(sk->sk_net, user, len, 1);
 		break;
 
 	default:
@@ -1929,7 +1930,8 @@ compat_copy_entries_to_user(unsigned int total_size, struct xt_table *table,
 }
 
 static int
-compat_get_entries(struct compat_ip6t_get_entries __user *uptr, int *len)
+compat_get_entries(struct net *net, struct compat_ip6t_get_entries __user *uptr,
+		   int *len)
 {
 	int ret;
 	struct compat_ip6t_get_entries get;
@@ -1950,7 +1952,7 @@ compat_get_entries(struct compat_ip6t_get_entries __user *uptr, int *len)
 	}
 
 	xt_compat_lock(AF_INET6);
-	t = xt_find_table_lock(&init_net, AF_INET6, get.name);
+	t = xt_find_table_lock(net, AF_INET6, get.name);
 	if (t && !IS_ERR(t)) {
 		struct xt_table_info *private = t->private;
 		struct xt_table_info info;
@@ -1986,10 +1988,10 @@ compat_do_ip6t_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
 
 	switch (cmd) {
 	case IP6T_SO_GET_INFO:
-		ret = get_info(user, len, 1);
+		ret = get_info(sk->sk_net, user, len, 1);
 		break;
 	case IP6T_SO_GET_ENTRIES:
-		ret = compat_get_entries(user, len);
+		ret = compat_get_entries(sk->sk_net, user, len);
 		break;
 	default:
 		ret = do_ip6t_get_ctl(sk, cmd, user, len);
@@ -2008,11 +2010,11 @@ do_ip6t_set_ctl(struct sock *sk, int cmd, void __user *user, unsigned int len)
 
 	switch (cmd) {
 	case IP6T_SO_SET_REPLACE:
-		ret = do_replace(user, len);
+		ret = do_replace(sk->sk_net, user, len);
 		break;
 
 	case IP6T_SO_SET_ADD_COUNTERS:
-		ret = do_add_counters(user, len, 0);
+		ret = do_add_counters(sk->sk_net, user, len, 0);
 		break;
 
 	default:
@@ -2033,11 +2035,11 @@ do_ip6t_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
 
 	switch (cmd) {
 	case IP6T_SO_GET_INFO:
-		ret = get_info(user, len, 0);
+		ret = get_info(sk->sk_net, user, len, 0);
 		break;
 
 	case IP6T_SO_GET_ENTRIES:
-		ret = get_entries(user, len);
+		ret = get_entries(sk->sk_net, user, len);
 		break;
 
 	case IP6T_SO_GET_REVISION_MATCH:
@@ -2074,7 +2076,8 @@ do_ip6t_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
 	return ret;
 }
 
-struct xt_table *ip6t_register_table(struct xt_table *table, const struct ip6t_replace *repl)
+struct xt_table *ip6t_register_table(struct net *net, struct xt_table *table,
+				     const struct ip6t_replace *repl)
 {
 	int ret;
 	struct xt_table_info *newinfo;
@@ -2101,7 +2104,7 @@ struct xt_table *ip6t_register_table(struct xt_table *table, const struct ip6t_r
 	if (ret != 0)
 		goto out_free;
 
-	new_table = xt_register_table(&init_net, table, &bootstrap, newinfo);
+	new_table = xt_register_table(net, table, &bootstrap, newinfo);
 	if (IS_ERR(new_table)) {
 		ret = PTR_ERR(new_table);
 		goto out_free;
diff --git a/net/ipv6/netfilter/ip6table_filter.c b/net/ipv6/netfilter/ip6table_filter.c
index bffd67f..d0bf71d 100644
--- a/net/ipv6/netfilter/ip6table_filter.c
+++ b/net/ipv6/netfilter/ip6table_filter.c
@@ -132,7 +132,7 @@ static int __init ip6table_filter_init(void)
 	initial_table.entries[1].target.verdict = -forward - 1;
 
 	/* Register table */
-	packet_filter = ip6t_register_table(&__packet_filter, &initial_table.repl);
+	packet_filter = ip6t_register_table(&init_net, &__packet_filter, &initial_table.repl);
 	if (IS_ERR(packet_filter))
 		return PTR_ERR(packet_filter);
 
diff --git a/net/ipv6/netfilter/ip6table_mangle.c b/net/ipv6/netfilter/ip6table_mangle.c
index 63d334d..abdfece 100644
--- a/net/ipv6/netfilter/ip6table_mangle.c
+++ b/net/ipv6/netfilter/ip6table_mangle.c
@@ -164,7 +164,7 @@ static int __init ip6table_mangle_init(void)
 	int ret;
 
 	/* Register table */
-	packet_mangler = ip6t_register_table(&__packet_mangler, &initial_table.repl);
+	packet_mangler = ip6t_register_table(&init_net, &__packet_mangler, &initial_table.repl);
 	if (IS_ERR(packet_mangler))
 		return PTR_ERR(packet_mangler);
 
diff --git a/net/ipv6/netfilter/ip6table_raw.c b/net/ipv6/netfilter/ip6table_raw.c
index 7f55b23..12acd63 100644
--- a/net/ipv6/netfilter/ip6table_raw.c
+++ b/net/ipv6/netfilter/ip6table_raw.c
@@ -77,7 +77,7 @@ static int __init ip6table_raw_init(void)
 	int ret;
 
 	/* Register table */
-	packet_raw = ip6t_register_table(&__packet_raw, &initial_table.repl);
+	packet_raw = ip6t_register_table(&init_net, &__packet_raw, &initial_table.repl);
 	if (IS_ERR(packet_raw))
 		return PTR_ERR(packet_raw);
 
