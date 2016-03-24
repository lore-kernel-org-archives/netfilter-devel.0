From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf] netfilter: x_tables: enforce nul-terminated table name from getsockopt GET_ENTRIES
Date: Thu, 24 Mar 2016 21:29:53 +0100
Message-ID: <1458851393-3896-1-git-send-email-pablo@netfilter.org>
Cc: sploving1@gmail.com, eric.dumazet@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58195 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239AbcCXUaE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Mar 2016 16:30:04 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id AF8D780B14
	for <netfilter-devel@vger.kernel.org>; Thu, 24 Mar 2016 21:29:59 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 5B61928D252
	for <netfilter-devel@vger.kernel.org>; Thu, 24 Mar 2016 21:30:00 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 65112AD8B
	for <netfilter-devel@vger.kernel.org>; Thu, 24 Mar 2016 21:29:58 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Make sure the table names via getsockopt GET_ENTRIES is nul-terminated
in ebtables and all the x_tables variants and their respective compat
code. Uncovered by KASAN.

Reported-by: Baozeng Ding <sploving1@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/netfilter/ebtables.c | 4 ++++
 net/ipv4/netfilter/arp_tables.c | 2 ++
 net/ipv4/netfilter/ip_tables.c  | 2 ++
 net/ipv6/netfilter/ip6_tables.c | 2 ++
 4 files changed, 10 insertions(+)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 67b2e27..8570bc7 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1521,6 +1521,8 @@ static int do_ebt_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
 	if (copy_from_user(&tmp, user, sizeof(tmp)))
 		return -EFAULT;
 
+	tmp.name[sizeof(tmp.name) - 1] = '\0';
+
 	t = find_table_lock(net, tmp.name, &ret, &ebt_mutex);
 	if (!t)
 		return ret;
@@ -2332,6 +2334,8 @@ static int compat_do_ebt_get_ctl(struct sock *sk, int cmd,
 	if (copy_from_user(&tmp, user, sizeof(tmp)))
 		return -EFAULT;
 
+	tmp.name[sizeof(tmp.name) - 1] = '\0';
+
 	t = find_table_lock(net, tmp.name, &ret, &ebt_mutex);
 	if (!t)
 		return ret;
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index a2002ff..06e9fb7 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -960,6 +960,7 @@ static int get_entries(struct net *net, struct arpt_get_entries __user *uptr,
 			 sizeof(struct arpt_get_entries) + get.size);
 		return -EINVAL;
 	}
+	get.name[sizeof(get.name) - 1] = '\0';
 
 	t = xt_find_table_lock(net, NFPROTO_ARP, get.name);
 	if (!IS_ERR_OR_NULL(t)) {
@@ -1654,6 +1655,7 @@ static int compat_get_entries(struct net *net,
 			 *len, sizeof(get) + get.size);
 		return -EINVAL;
 	}
+	get.name[sizeof(get.name) - 1] = '\0';
 
 	xt_compat_lock(NFPROTO_ARP);
 	t = xt_find_table_lock(net, NFPROTO_ARP, get.name);
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 45b1d97..4642dc2 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1146,6 +1146,7 @@ get_entries(struct net *net, struct ipt_get_entries __user *uptr,
 			 *len, sizeof(get) + get.size);
 		return -EINVAL;
 	}
+	get.name[sizeof(get.name) - 1] = '\0';
 
 	t = xt_find_table_lock(net, AF_INET, get.name);
 	if (!IS_ERR_OR_NULL(t)) {
@@ -1925,6 +1926,7 @@ compat_get_entries(struct net *net, struct compat_ipt_get_entries __user *uptr,
 			 *len, sizeof(get) + get.size);
 		return -EINVAL;
 	}
+	get.name[sizeof(get.name) - 1] = '\0';
 
 	xt_compat_lock(AF_INET);
 	t = xt_find_table_lock(net, AF_INET, get.name);
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 85c0942..db47815 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1158,6 +1158,7 @@ get_entries(struct net *net, struct ip6t_get_entries __user *uptr,
 			 *len, sizeof(get) + get.size);
 		return -EINVAL;
 	}
+	get.name[sizeof(get.name) - 1] = '\0';
 
 	t = xt_find_table_lock(net, AF_INET6, get.name);
 	if (!IS_ERR_OR_NULL(t)) {
@@ -1934,6 +1935,7 @@ compat_get_entries(struct net *net, struct compat_ip6t_get_entries __user *uptr,
 			 *len, sizeof(get) + get.size);
 		return -EINVAL;
 	}
+	get.name[sizeof(get.name) - 1] = '\0';
 
 	xt_compat_lock(AF_INET6);
 	t = xt_find_table_lock(net, AF_INET6, get.name);
-- 
2.1.4

