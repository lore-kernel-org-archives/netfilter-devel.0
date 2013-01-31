From: pablo@netfilter.org
Subject: [v2] netfilter: nfnetlink: add mutex per subsystem
Date: Fri,  1 Feb 2013 00:22:59 +0100
Message-ID: <1359674579-3330-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from slan-550-85.anhosting.com ([209.236.71.68]:40425 "EHLO
	slan-550-85.anhosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab3AaXXI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jan 2013 18:23:08 -0500
Received: from 180.82.78.188.dynamic.jazztel.es ([188.78.82.180]:47364 helo=localhost.localdomain)
	by slan-550-85.anhosting.com with esmtpa (Exim 4.80)
	(envelope-from <pablo@netfilter.org>)
	id 1U13TG-000CUp-TB
	for netfilter-devel@vger.kernel.org; Thu, 31 Jan 2013 16:23:07 -0700
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

This patch replaces the global lock to one lock per subsystem.
The per-subsystem lock avoids that processes operating
with different subsystems are synchronized.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nfnetlink.h  |    4 +--
 net/netfilter/ipset/ip_set_core.c    |   26 ++++++++---------
 net/netfilter/nf_conntrack_netlink.c |   12 ++++----
 net/netfilter/nf_tables_api.c        |   48 +++++++++++++++----------------
 net/netfilter/nfnetlink.c            |   52 +++++++++++++++++++++-------------
 5 files changed, 77 insertions(+), 65 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink.h b/include/linux/netfilter/nfnetlink.h
index 4966dde..ecbb8e4 100644
--- a/include/linux/netfilter/nfnetlink.h
+++ b/include/linux/netfilter/nfnetlink.h
@@ -34,8 +34,8 @@ extern int nfnetlink_send(struct sk_buff *skb, struct net *net, u32 pid, unsigne
 extern int nfnetlink_set_err(struct net *net, u32 pid, u32 group, int error);
 extern int nfnetlink_unicast(struct sk_buff *skb, struct net *net, u_int32_t pid, int flags);
 
-extern void nfnl_lock(void);
-extern void nfnl_unlock(void);
+extern void nfnl_lock(__u8 subsys_id);
+extern void nfnl_unlock(__u8 subsys_id);
 
 #define MODULE_ALIAS_NFNL_SUBSYS(subsys) \
 	MODULE_ALIAS("nfnetlink-subsys-" __stringify(subsys))
diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 778465f..0e77cbb 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -81,14 +81,14 @@ find_set_type(const char *name, u8 family, u8 revision)
 static bool
 load_settype(const char *name)
 {
-	nfnl_unlock();
+	nfnl_unlock(NFNL_SUBSYS_IPSET);
 	pr_debug("try to load ip_set_%s\n", name);
 	if (request_module("ip_set_%s", name) < 0) {
 		pr_warning("Can't find ip_set type %s\n", name);
-		nfnl_lock();
+		nfnl_lock(NFNL_SUBSYS_IPSET);
 		return false;
 	}
-	nfnl_lock();
+	nfnl_lock(NFNL_SUBSYS_IPSET);
 	return true;
 }
 
@@ -504,9 +504,9 @@ ip_set_nfnl_get(const char *name)
 	struct ip_set *s;
 	ip_set_id_t index;
 
-	nfnl_lock();
+	nfnl_lock(NFNL_SUBSYS_IPSET);
 	index = ip_set_get_byname(name, &s);
-	nfnl_unlock();
+	nfnl_unlock(NFNL_SUBSYS_IPSET);
 
 	return index;
 }
@@ -524,12 +524,12 @@ ip_set_nfnl_get_byindex(ip_set_id_t index)
 	if (index > ip_set_max)
 		return IPSET_INVALID_ID;
 
-	nfnl_lock();
+	nfnl_lock(NFNL_SUBSYS_IPSET);
 	if (ip_set_list[index])
 		__ip_set_get(index);
 	else
 		index = IPSET_INVALID_ID;
-	nfnl_unlock();
+	nfnl_unlock(NFNL_SUBSYS_IPSET);
 
 	return index;
 }
@@ -545,9 +545,9 @@ EXPORT_SYMBOL_GPL(ip_set_nfnl_get_byindex);
 void
 ip_set_nfnl_put(ip_set_id_t index)
 {
-	nfnl_lock();
+	nfnl_lock(NFNL_SUBSYS_IPSET);
 	ip_set_put_byindex(index);
-	nfnl_unlock();
+	nfnl_unlock(NFNL_SUBSYS_IPSET);
 }
 EXPORT_SYMBOL_GPL(ip_set_nfnl_put);
 
@@ -1690,9 +1690,9 @@ ip_set_sockfn_get(struct sock *sk, int optval, void __user *user, int *len)
 			goto done;
 		}
 		req_get->set.name[IPSET_MAXNAMELEN - 1] = '\0';
-		nfnl_lock();
+		nfnl_lock(NFNL_SUBSYS_IPSET);
 		req_get->set.index = find_set_id(req_get->set.name);
-		nfnl_unlock();
+		nfnl_unlock(NFNL_SUBSYS_IPSET);
 		goto copy;
 	}
 	case IP_SET_OP_GET_BYINDEX: {
@@ -1703,12 +1703,12 @@ ip_set_sockfn_get(struct sock *sk, int optval, void __user *user, int *len)
 			ret = -EINVAL;
 			goto done;
 		}
-		nfnl_lock();
+		nfnl_lock(NFNL_SUBSYS_IPSET);
 		strncpy(req_get->set.name,
 			ip_set_list[req_get->set.index]
 				? ip_set_list[req_get->set.index]->name : "",
 			IPSET_MAXNAMELEN);
-		nfnl_unlock();
+		nfnl_unlock(NFNL_SUBSYS_IPSET);
 		goto copy;
 	}
 	default:
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 7bbfb3d..37e29d0 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1102,13 +1102,13 @@ ctnetlink_parse_nat_setup(struct nf_conn *ct,
 	if (!parse_nat_setup) {
 #ifdef CONFIG_MODULES
 		rcu_read_unlock();
-		nfnl_unlock();
+		nfnl_unlock(NFNL_SUBSYS_CTNETLINK);
 		if (request_module("nf-nat") < 0) {
-			nfnl_lock();
+			nfnl_lock(NFNL_SUBSYS_CTNETLINK);
 			rcu_read_lock();
 			return -EOPNOTSUPP;
 		}
-		nfnl_lock();
+		nfnl_lock(NFNL_SUBSYS_CTNETLINK);
 		rcu_read_lock();
 		if (nfnetlink_parse_nat_setup_hook)
 			return -EAGAIN;
@@ -1120,13 +1120,13 @@ ctnetlink_parse_nat_setup(struct nf_conn *ct,
 	if (err == -EAGAIN) {
 #ifdef CONFIG_MODULES
 		rcu_read_unlock();
-		nfnl_unlock();
+		nfnl_unlock(NFNL_SUBSYS_CTNETLINK);
 		if (request_module("nf-nat-%u", nf_ct_l3num(ct)) < 0) {
-			nfnl_lock();
+			nfnl_lock(NFNL_SUBSYS_CTNETLINK);
 			rcu_read_lock();
 			return -EOPNOTSUPP;
 		}
-		nfnl_lock();
+		nfnl_lock(NFNL_SUBSYS_CTNETLINK);
 		rcu_read_lock();
 #else
 		err = -EOPNOTSUPP;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 7fc8d51..b5625ef 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -34,9 +34,9 @@ static LIST_HEAD(nf_tables_expressions);
 int nft_register_afinfo(struct net *net, struct nft_af_info *afi)
 {
 	INIT_LIST_HEAD(&afi->tables);
-	nfnl_lock();
+	nfnl_lock(NFNL_SUBSYS_NFTABLES);
 	list_add_tail(&afi->list, &net->nft.af_info);
-	nfnl_unlock();
+	nfnl_unlock(NFNL_SUBSYS_NFTABLES);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(nft_register_afinfo);
@@ -50,9 +50,9 @@ EXPORT_SYMBOL_GPL(nft_register_afinfo);
  */
 void nft_unregister_afinfo(struct nft_af_info *afi)
 {
-	nfnl_lock();
+	nfnl_lock(NFNL_SUBSYS_NFTABLES);
 	list_del(&afi->list);
-	nfnl_unlock();
+	nfnl_unlock(NFNL_SUBSYS_NFTABLES);
 }
 EXPORT_SYMBOL_GPL(nft_unregister_afinfo);
 
@@ -77,9 +77,9 @@ nf_tables_afinfo_lookup(struct net *net, int family, bool autoload)
 		return afi;
 #ifdef CONFIG_MODULES
 	if (autoload) {
-		nfnl_unlock();
+		nfnl_unlock(NFNL_SUBSYS_NFTABLES);
 		request_module("nft-afinfo-%u", family);
-		nfnl_lock();
+		nfnl_lock(NFNL_SUBSYS_NFTABLES);
 		afi = nft_afinfo_lookup(net, family);
 		if (afi != NULL)
 			return ERR_PTR(-EAGAIN);
@@ -147,10 +147,10 @@ static int nf_tables_chain_type_lookup(const struct nft_af_info *afi,
 	type = __nf_tables_chain_type_lookup(afi->family, nla);
 #ifdef CONFIG_MODULES
 	if (type < 0 && autoload) {
-		nfnl_unlock();
+		nfnl_unlock(NFNL_SUBSYS_NFTABLES);
 		request_module("nft-chain-%u-%*.s", afi->family,
 			       nla_len(nla)-1, (const char *)nla_data(nla));
-		nfnl_lock();
+		nfnl_lock(NFNL_SUBSYS_NFTABLES);
 		type = __nf_tables_chain_type_lookup(afi->family, nla);
 	}
 #endif
@@ -456,7 +456,7 @@ int nft_register_chain_type(struct nf_chain_type *ctype)
 {
 	int err = 0;
 
-	nfnl_lock();
+	nfnl_lock(NFNL_SUBSYS_NFTABLES);
 	if (chain_type[ctype->family][ctype->type] != NULL) {
 		err = -EBUSY;
 		goto out;
@@ -467,17 +467,17 @@ int nft_register_chain_type(struct nf_chain_type *ctype)
 
 	chain_type[ctype->family][ctype->type] = ctype;
 out:
-	nfnl_unlock();
+	nfnl_unlock(NFNL_SUBSYS_NFTABLES);
 	return err;
 }
 EXPORT_SYMBOL_GPL(nft_register_chain_type);
 
 void nft_unregister_chain_type(struct nf_chain_type *ctype)
 {
-	nfnl_lock();
+	nfnl_lock(NFNL_SUBSYS_NFTABLES);
 	chain_type[ctype->family][ctype->type] = NULL;
 	module_put(ctype->me);
-	nfnl_unlock();
+	nfnl_unlock(NFNL_SUBSYS_NFTABLES);
 }
 EXPORT_SYMBOL_GPL(nft_unregister_chain_type);
 
@@ -1063,9 +1063,9 @@ static void nft_ctx_init(struct nft_ctx *ctx,
  */
 int nft_register_expr(struct nft_expr_type *type)
 {
-	nfnl_lock();
+	nfnl_lock(NFNL_SUBSYS_NFTABLES);
 	list_add_tail(&type->list, &nf_tables_expressions);
-	nfnl_unlock();
+	nfnl_unlock(NFNL_SUBSYS_NFTABLES);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(nft_register_expr);
@@ -1078,9 +1078,9 @@ EXPORT_SYMBOL_GPL(nft_register_expr);
  */
 void nft_unregister_expr(struct nft_expr_type *type)
 {
-	nfnl_lock();
+	nfnl_lock(NFNL_SUBSYS_NFTABLES);
 	list_del(&type->list);
-	nfnl_unlock();
+	nfnl_unlock(NFNL_SUBSYS_NFTABLES);
 }
 EXPORT_SYMBOL_GPL(nft_unregister_expr);
 
@@ -1108,10 +1108,10 @@ static const struct nft_expr_type *nft_expr_type_get(struct nlattr *nla)
 
 #ifdef CONFIG_MODULES
 	if (type == NULL) {
-		nfnl_unlock();
+		nfnl_unlock(NFNL_SUBSYS_NFTABLES);
 		request_module("nft-expr-%.*s",
 			       nla_len(nla), (char *)nla_data(nla));
-		nfnl_lock();
+		nfnl_lock(NFNL_SUBSYS_NFTABLES);
 		if (__nft_expr_type_get(nla))
 			return ERR_PTR(-EAGAIN);
 	}
@@ -1814,18 +1814,18 @@ static LIST_HEAD(nf_tables_set_ops);
 
 int nft_register_set(struct nft_set_ops *ops)
 {
-	nfnl_lock();
+	nfnl_lock(NFNL_SUBSYS_NFTABLES);
 	list_add_tail(&ops->list, &nf_tables_set_ops);
-	nfnl_unlock();
+	nfnl_unlock(NFNL_SUBSYS_NFTABLES);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(nft_register_set);
 
 void nft_unregister_set(struct nft_set_ops *ops)
 {
-	nfnl_lock();
+	nfnl_lock(NFNL_SUBSYS_NFTABLES);
 	list_del(&ops->list);
-	nfnl_unlock();
+	nfnl_unlock(NFNL_SUBSYS_NFTABLES);
 }
 EXPORT_SYMBOL_GPL(nft_unregister_set);
 
@@ -1836,9 +1836,9 @@ static const struct nft_set_ops *nft_select_set_ops(const struct nlattr * const
 
 #ifdef CONFIG_MODULES
 	if (list_empty(&nf_tables_set_ops)) {
-		nfnl_unlock();
+		nfnl_unlock(NFNL_SUBSYS_NFTABLES);
 		request_module("nft-set");
-		nfnl_lock();
+		nfnl_lock(NFNL_SUBSYS_NFTABLES);
 		if (!list_empty(&nf_tables_set_ops))
 			return ERR_PTR(-EAGAIN);
 	}
diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index ffb92c0..3ff7c79 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -36,8 +36,10 @@ MODULE_ALIAS_NET_PF_PROTO(PF_NETLINK, NETLINK_NETFILTER);
 
 static char __initdata nfversion[] = "0.30";
 
-static const struct nfnetlink_subsystem __rcu *subsys_table[NFNL_SUBSYS_COUNT];
-static DEFINE_MUTEX(nfnl_mutex);
+static struct {
+	struct mutex				mutex;
+	const struct nfnetlink_subsystem __rcu	*subsys;
+} table[NFNL_SUBSYS_COUNT];
 
 static const int nfnl_group2type[NFNLGRP_MAX+1] = {
 	[NFNLGRP_CONNTRACK_NEW]		= NFNL_SUBSYS_CTNETLINK,
@@ -48,27 +50,32 @@ static const int nfnl_group2type[NFNLGRP_MAX+1] = {
 	[NFNLGRP_CONNTRACK_EXP_DESTROY] = NFNL_SUBSYS_CTNETLINK_EXP,
 };
 
-void nfnl_lock(void)
+void nfnl_lock(__u8 subsys_id)
 {
-	mutex_lock(&nfnl_mutex);
+	mutex_lock(&table[subsys_id].mutex);
 }
 EXPORT_SYMBOL_GPL(nfnl_lock);
 
-void nfnl_unlock(void)
+void nfnl_unlock(__u8 subsys_id)
 {
-	mutex_unlock(&nfnl_mutex);
+	mutex_unlock(&table[subsys_id].mutex);
 }
 EXPORT_SYMBOL_GPL(nfnl_unlock);
 
+static struct mutex *nfnl_get_lock(__u8 subsys_id)
+{
+	return &table[subsys_id].mutex;
+}
+
 int nfnetlink_subsys_register(const struct nfnetlink_subsystem *n)
 {
-	nfnl_lock();
-	if (subsys_table[n->subsys_id]) {
-		nfnl_unlock();
+	nfnl_lock(n->subsys_id);
+	if (table[n->subsys_id].subsys) {
+		nfnl_unlock(n->subsys_id);
 		return -EBUSY;
 	}
-	rcu_assign_pointer(subsys_table[n->subsys_id], n);
-	nfnl_unlock();
+	rcu_assign_pointer(table[n->subsys_id].subsys, n);
+	nfnl_unlock(n->subsys_id);
 
 	return 0;
 }
@@ -76,9 +83,9 @@ EXPORT_SYMBOL_GPL(nfnetlink_subsys_register);
 
 int nfnetlink_subsys_unregister(const struct nfnetlink_subsystem *n)
 {
-	nfnl_lock();
-	subsys_table[n->subsys_id] = NULL;
-	nfnl_unlock();
+	nfnl_lock(n->subsys_id);
+	table[n->subsys_id].subsys = NULL;
+	nfnl_unlock(n->subsys_id);
 	synchronize_rcu();
 	return 0;
 }
@@ -91,7 +98,7 @@ static inline const struct nfnetlink_subsystem *nfnetlink_get_subsys(u_int16_t t
 	if (subsys_id >= NFNL_SUBSYS_COUNT)
 		return NULL;
 
-	return rcu_dereference(subsys_table[subsys_id]);
+	return rcu_dereference(table[subsys_id].subsys);
 }
 
 static inline const struct nfnl_callback *
@@ -175,6 +182,7 @@ replay:
 		struct nlattr *cda[ss->cb[cb_id].attr_count + 1];
 		struct nlattr *attr = (void *)nlh + min_len;
 		int attrlen = nlh->nlmsg_len - min_len;
+		__u8 subsys_id = NFNL_SUBSYS_ID(type);
 
 		err = nla_parse(cda, ss->cb[cb_id].attr_count,
 				attr, attrlen, ss->cb[cb_id].policy);
@@ -189,10 +197,9 @@ replay:
 			rcu_read_unlock();
 		} else {
 			rcu_read_unlock();
-			nfnl_lock();
-			if (rcu_dereference_protected(
-					subsys_table[NFNL_SUBSYS_ID(type)],
-					lockdep_is_held(&nfnl_mutex)) != ss ||
+			nfnl_lock(subsys_id);
+			if (rcu_dereference_protected(table[subsys_id].subsys,
+				lockdep_is_held(nfnl_get_lock(subsys_id))) != ss ||
 			    nfnetlink_find_client(type, ss) != nc)
 				err = -EAGAIN;
 			else if (nc->call)
@@ -200,7 +207,7 @@ replay:
 						   (const struct nlattr **)cda);
 			else
 				err = -EINVAL;
-			nfnl_unlock();
+			nfnl_unlock(subsys_id);
 		}
 		if (err == -EAGAIN)
 			goto replay;
@@ -267,6 +274,11 @@ static struct pernet_operations nfnetlink_net_ops = {
 
 static int __init nfnetlink_init(void)
 {
+	int i;
+
+	for (i=0; i<NFNL_SUBSYS_COUNT; i++)
+		mutex_init(&table[i].mutex);
+
 	pr_info("Netfilter messages via NETLINK v%s.\n", nfversion);
 	return register_pernet_subsys(&nfnetlink_net_ops);
 }
-- 
1.7.10.4

