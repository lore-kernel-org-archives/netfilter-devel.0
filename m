From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf-next RFC 3/5] netfilter: make each ct helper belong to a specific netns
Date: Sun,  4 Jun 2017 23:25:07 +0800
Message-ID: <1496589909-56730-4-git-send-email-zlpnobody@163.com>
References: <1496589909-56730-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-18.163.com ([220.181.12.18]:51436 "EHLO m12-18.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751218AbdFDPZv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 4 Jun 2017 11:25:51 -0400
In-Reply-To: <1496589909-56730-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

This is the first part to support net namespace for ct helpers.
When we register a ct helper, we will store the related netns.

So later, we can only find the ct helper belong to a specified
netns, i.e. we will add "struct net *" parameter to these
ct_helper_find functions and filter the cthelper by netns.

Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 include/net/netfilter/nf_conntrack_helper.h | 13 ++++++-
 include/net/netns/conntrack.h               |  2 +
 net/netfilter/nf_conntrack_helper.c         | 57 ++++++++++++++++++++---------
 net/netfilter/nf_conntrack_netlink.c        | 15 +++++---
 net/netfilter/nft_ct.c                      | 12 ++++--
 net/netfilter/xt_CT.c                       |  3 +-
 net/openvswitch/conntrack.c                 |  7 ++--
 7 files changed, 76 insertions(+), 33 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index 991b6d0..7ac67c4 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -26,6 +26,8 @@ enum nf_ct_helper_flags {
 struct nf_conntrack_helper {
 	struct hlist_node hnode;	/* Internal use. */
 
+	possible_net_t net;
+
 	char name[NF_CT_HELPER_NAME_LEN]; /* name of the module */
 	refcount_t refcnt;
 	struct module *me;		/* pointer to self */
@@ -75,10 +77,17 @@ struct nf_conn_help {
 #define NF_CT_HELPER_BUILD_BUG_ON(structsize) \
 	BUILD_BUG_ON((structsize) > FIELD_SIZEOF(struct nf_conn_help, data))
 
-struct nf_conntrack_helper *__nf_conntrack_helper_find(const char *name,
+static inline struct net *nf_ct_helper_net(struct nf_conntrack_helper *helper)
+{
+	return read_pnet(&helper->net);
+}
+
+struct nf_conntrack_helper *__nf_conntrack_helper_find(struct net *net,
+						       const char *name,
 						       u16 l3num, u8 protonum);
 
-struct nf_conntrack_helper *nf_conntrack_helper_try_module_get(const char *name,
+struct nf_conntrack_helper *nf_conntrack_helper_try_module_get(struct net *net,
+							       const char *name,
 							       u16 l3num,
 							       u8 protonum);
 void nf_conntrack_helper_put(struct nf_conntrack_helper *helper);
diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
index 17724c6..244b794 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -111,6 +111,8 @@ struct netns_ct {
 	int			sysctl_tstamp;
 	int			sysctl_checksum;
 
+	unsigned int		nf_ct_helper_count;
+
 	struct ct_pcpu __percpu *pcpu_lists;
 	struct ip_conntrack_stat __percpu *stat;
 	struct nf_ct_event_notifier __rcu *nf_conntrack_event_cb;
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 9a52788..3f3eeb9 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -36,7 +36,6 @@ struct hlist_head *nf_ct_helper_hash __read_mostly;
 EXPORT_SYMBOL_GPL(nf_ct_helper_hash);
 unsigned int nf_ct_helper_hsize __read_mostly;
 EXPORT_SYMBOL_GPL(nf_ct_helper_hsize);
-static unsigned int nf_ct_helper_count __read_mostly;
 
 static bool nf_ct_auto_assign_helper __read_mostly = false;
 module_param_named(nf_conntrack_helper, nf_ct_auto_assign_helper, bool, 0644);
@@ -106,24 +105,33 @@ static void nf_conntrack_helper_fini_sysctl(struct net *net)
 
 /* Stupid hash, but collision free for the default registrations of the
  * helpers currently in the kernel. */
-static unsigned int helper_hash(const struct nf_conntrack_tuple *tuple)
+static unsigned int helper_hash(struct net *net,
+				const struct nf_conntrack_tuple *tuple)
 {
-	return (((tuple->src.l3num << 8) | tuple->dst.protonum) ^
-		(__force __u16)tuple->src.u.all) % nf_ct_helper_hsize;
+	unsigned int hash;
+
+	hash = ((tuple->src.l3num << 8) | tuple->dst.protonum) ^
+	       (__force __u16)tuple->src.u.all;
+	hash ^= net_hash_mix(net);
+
+	return hash % nf_ct_helper_hsize;
 }
 
 static struct nf_conntrack_helper *
-__nf_ct_helper_find(const struct nf_conntrack_tuple *tuple)
+__nf_ct_helper_find(struct net *net, const struct nf_conntrack_tuple *tuple)
 {
 	struct nf_conntrack_helper *helper;
 	struct nf_conntrack_tuple_mask mask = { .src.u.all = htons(0xFFFF) };
 	unsigned int h;
 
-	if (!nf_ct_helper_count)
+	if (!net->ct.nf_ct_helper_count)
 		return NULL;
 
-	h = helper_hash(tuple);
+	h = helper_hash(net, tuple);
 	hlist_for_each_entry_rcu(helper, &nf_ct_helper_hash[h], hnode) {
+		if (!net_eq(net, nf_ct_helper_net(helper)))
+			continue;
+
 		if (nf_ct_tuple_src_mask_cmp(tuple, &helper->tuple, &mask))
 			return helper;
 	}
@@ -131,13 +139,17 @@ __nf_ct_helper_find(const struct nf_conntrack_tuple *tuple)
 }
 
 struct nf_conntrack_helper *
-__nf_conntrack_helper_find(const char *name, u16 l3num, u8 protonum)
+__nf_conntrack_helper_find(struct net *net, const char *name,
+			   u16 l3num, u8 protonum)
 {
 	struct nf_conntrack_helper *h;
 	unsigned int i;
 
 	for (i = 0; i < nf_ct_helper_hsize; i++) {
 		hlist_for_each_entry_rcu(h, &nf_ct_helper_hash[i], hnode) {
+			if (!net_eq(net, nf_ct_helper_net(h)))
+				continue;
+
 			if (strcmp(h->name, name))
 				continue;
 
@@ -154,19 +166,21 @@ __nf_conntrack_helper_find(const char *name, u16 l3num, u8 protonum)
 EXPORT_SYMBOL_GPL(__nf_conntrack_helper_find);
 
 struct nf_conntrack_helper *
-nf_conntrack_helper_try_module_get(const char *name, u16 l3num, u8 protonum)
+nf_conntrack_helper_try_module_get(struct net *net, const char *name,
+				   u16 l3num, u8 protonum)
 {
 	struct nf_conntrack_helper *h;
 
 	rcu_read_lock();
 
-	h = __nf_conntrack_helper_find(name, l3num, protonum);
+	h = __nf_conntrack_helper_find(net, name, l3num, protonum);
 #ifdef CONFIG_MODULES
 	if (h == NULL) {
 		rcu_read_unlock();
 		if (request_module("nfct-helper-%s", name) == 0) {
 			rcu_read_lock();
-			h = __nf_conntrack_helper_find(name, l3num, protonum);
+			h = __nf_conntrack_helper_find(net, name, l3num,
+						       protonum);
 		} else {
 			return h;
 		}
@@ -213,7 +227,8 @@ nf_ct_lookup_helper(struct nf_conn *ct, struct net *net)
 	if (!net->ct.sysctl_auto_assign_helper) {
 		if (net->ct.auto_assign_helper_warned)
 			return NULL;
-		if (!__nf_ct_helper_find(&ct->tuplehash[IP_CT_DIR_REPLY].tuple))
+		if (!__nf_ct_helper_find(net,
+					 &ct->tuplehash[IP_CT_DIR_REPLY].tuple))
 			return NULL;
 		pr_info("nf_conntrack: default automatic helper assignment "
 			"has been turned off for security reasons and CT-based "
@@ -223,7 +238,7 @@ nf_ct_lookup_helper(struct nf_conn *ct, struct net *net)
 		return NULL;
 	}
 
-	return __nf_ct_helper_find(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
+	return __nf_ct_helper_find(net, &ct->tuplehash[IP_CT_DIR_REPLY].tuple);
 }
 
 
@@ -395,7 +410,7 @@ int nf_conntrack_helper_register(struct net *net,
 				 struct nf_conntrack_helper *me)
 {
 	struct nf_conntrack_tuple_mask mask = { .src.u.all = htons(0xFFFF) };
-	unsigned int h = helper_hash(&me->tuple);
+	unsigned int h = helper_hash(net, &me->tuple);
 	struct nf_conntrack_helper *cur;
 	int ret = 0, i;
 
@@ -412,6 +427,9 @@ int nf_conntrack_helper_register(struct net *net,
 	mutex_lock(&nf_ct_helper_mutex);
 	for (i = 0; i < nf_ct_helper_hsize; i++) {
 		hlist_for_each_entry(cur, &nf_ct_helper_hash[i], hnode) {
+			if (!net_eq(net, nf_ct_helper_net(cur)))
+				continue;
+
 			if (!strcmp(cur->name, me->name) &&
 			    (cur->tuple.src.l3num == NFPROTO_UNSPEC ||
 			     cur->tuple.src.l3num == me->tuple.src.l3num) &&
@@ -425,6 +443,9 @@ int nf_conntrack_helper_register(struct net *net,
 	/* avoid unpredictable behaviour for auto_assign_helper */
 	if (!(me->flags & NF_CT_HELPER_F_USERSPACE)) {
 		hlist_for_each_entry(cur, &nf_ct_helper_hash[h], hnode) {
+			if (!net_eq(net, nf_ct_helper_net(cur)))
+				continue;
+
 			if (nf_ct_tuple_src_mask_cmp(&cur->tuple, &me->tuple,
 						     &mask)) {
 				ret = -EEXIST;
@@ -432,9 +453,11 @@ int nf_conntrack_helper_register(struct net *net,
 			}
 		}
 	}
+
+	write_pnet(&me->net, net);
 	refcount_set(&me->refcnt, 1);
 	hlist_add_head_rcu(&me->hnode, &nf_ct_helper_hash[h]);
-	nf_ct_helper_count++;
+	net->ct.nf_ct_helper_count++;
 out:
 	mutex_unlock(&nf_ct_helper_mutex);
 	return ret;
@@ -453,7 +476,7 @@ void nf_conntrack_helper_unregister(struct net *net,
 
 	mutex_lock(&nf_ct_helper_mutex);
 	hlist_del_rcu(&me->hnode);
-	nf_ct_helper_count--;
+	net->ct.nf_ct_helper_count--;
 	mutex_unlock(&nf_ct_helper_mutex);
 
 	/* Make sure every nothing is still using the helper unless its a
@@ -476,7 +499,7 @@ void nf_conntrack_helper_unregister(struct net *net,
 	}
 	spin_unlock_bh(&nf_conntrack_expect_lock);
 
-	nf_ct_iterate_destroy(unhelp, me);
+	nf_ct_iterate_cleanup_net(net, unhelp, me, 0, 0);
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_helper_unregister);
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index e1eca47..a7c25b9 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1529,7 +1529,8 @@ static int ctnetlink_change_helper(struct nf_conn *ct,
 	}
 
 	rcu_read_lock();
-	helper = __nf_conntrack_helper_find(helpname, nf_ct_l3num(ct),
+	helper = __nf_conntrack_helper_find(nf_ct_net(ct),
+					    helpname, nf_ct_l3num(ct),
 					    nf_ct_protonum(ct));
 	if (helper == NULL) {
 		rcu_read_unlock();
@@ -1777,7 +1778,8 @@ ctnetlink_create_conntrack(struct net *net,
  		if (err < 0)
 			goto err2;
 
-		helper = __nf_conntrack_helper_find(helpname, nf_ct_l3num(ct),
+		helper = __nf_conntrack_helper_find(net,
+						    helpname, nf_ct_l3num(ct),
 						    nf_ct_protonum(ct));
 		if (helper == NULL) {
 			rcu_read_unlock();
@@ -1788,7 +1790,7 @@ ctnetlink_create_conntrack(struct net *net,
 			}
 
 			rcu_read_lock();
-			helper = __nf_conntrack_helper_find(helpname,
+			helper = __nf_conntrack_helper_find(net, helpname,
 							    nf_ct_l3num(ct),
 							    nf_ct_protonum(ct));
 			if (helper) {
@@ -2409,7 +2411,8 @@ ctnetlink_glue_attach_expect(const struct nlattr *attr, struct nf_conn *ct,
 	if (cda[CTA_EXPECT_HELP_NAME]) {
 		const char *helpname = nla_data(cda[CTA_EXPECT_HELP_NAME]);
 
-		helper = __nf_conntrack_helper_find(helpname, nf_ct_l3num(ct),
+		helper = __nf_conntrack_helper_find(nf_ct_net(ct),
+						    helpname, nf_ct_l3num(ct),
 						    nf_ct_protonum(ct));
 		if (helper == NULL)
 			return -EOPNOTSUPP;
@@ -3145,7 +3148,7 @@ ctnetlink_create_expect(struct net *net,
 	if (cda[CTA_EXPECT_HELP_NAME]) {
 		const char *helpname = nla_data(cda[CTA_EXPECT_HELP_NAME]);
 
-		helper = __nf_conntrack_helper_find(helpname, u3,
+		helper = __nf_conntrack_helper_find(net, helpname, u3,
 						    nf_ct_protonum(ct));
 		if (helper == NULL) {
 			rcu_read_unlock();
@@ -3155,7 +3158,7 @@ ctnetlink_create_expect(struct net *net,
 				goto err_ct;
 			}
 			rcu_read_lock();
-			helper = __nf_conntrack_helper_find(helpname, u3,
+			helper = __nf_conntrack_helper_find(net, helpname, u3,
 							    nf_ct_protonum(ct));
 			if (helper) {
 				err = -EAGAIN;
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 1678e9e..e7e0bfd 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -789,22 +789,26 @@ static int nft_ct_helper_obj_init(const struct nft_ctx *ctx,
 		if (ctx->afi->family == NFPROTO_IPV6)
 			return -EINVAL;
 
-		help4 = nf_conntrack_helper_try_module_get(name, family,
+		help4 = nf_conntrack_helper_try_module_get(ctx->net,
+							   name, family,
 							   priv->l4proto);
 		break;
 	case NFPROTO_IPV6:
 		if (ctx->afi->family == NFPROTO_IPV4)
 			return -EINVAL;
 
-		help6 = nf_conntrack_helper_try_module_get(name, family,
+		help6 = nf_conntrack_helper_try_module_get(ctx->net,
+							   name, family,
 							   priv->l4proto);
 		break;
 	case NFPROTO_NETDEV: /* fallthrough */
 	case NFPROTO_BRIDGE: /* same */
 	case NFPROTO_INET:
-		help4 = nf_conntrack_helper_try_module_get(name, NFPROTO_IPV4,
+		help4 = nf_conntrack_helper_try_module_get(ctx->net,
+							   name, NFPROTO_IPV4,
 							   priv->l4proto);
-		help6 = nf_conntrack_helper_try_module_get(name, NFPROTO_IPV6,
+		help6 = nf_conntrack_helper_try_module_get(ctx->net,
+							   name, NFPROTO_IPV6,
 							   priv->l4proto);
 		break;
 	default:
diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
index 623ef37..6775b3e 100644
--- a/net/netfilter/xt_CT.c
+++ b/net/netfilter/xt_CT.c
@@ -87,7 +87,8 @@ xt_ct_set_helper(struct nf_conn *ct, const char *helper_name,
 		return -ENOENT;
 	}
 
-	helper = nf_conntrack_helper_try_module_get(helper_name, par->family,
+	helper = nf_conntrack_helper_try_module_get(par->net,
+						    helper_name, par->family,
 						    proto);
 	if (helper == NULL) {
 		pr_info("No such helper \"%s\"\n", helper_name);
diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 08679eb..3ae1194 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -1108,13 +1108,14 @@ int ovs_ct_execute(struct net *net, struct sk_buff *skb,
 	return err;
 }
 
-static int ovs_ct_add_helper(struct ovs_conntrack_info *info, const char *name,
+static int ovs_ct_add_helper(struct net *net,
+			     struct ovs_conntrack_info *info, const char *name,
 			     const struct sw_flow_key *key, bool log)
 {
 	struct nf_conntrack_helper *helper;
 	struct nf_conn_help *help;
 
-	helper = nf_conntrack_helper_try_module_get(name, info->family,
+	helper = nf_conntrack_helper_try_module_get(net, name, info->family,
 						    key->ip.proto);
 	if (!helper) {
 		OVS_NLERR(log, "Unknown helper \"%s\"", name);
@@ -1447,7 +1448,7 @@ int ovs_ct_copy_action(struct net *net, const struct nlattr *attr,
 	nf_conntrack_get(&ct_info.ct->ct_general);
 
 	if (helper) {
-		err = ovs_ct_add_helper(&ct_info, helper, key, log);
+		err = ovs_ct_add_helper(net, &ct_info, helper, key, log);
 		if (err)
 			goto err_free_ct;
 	}
-- 
2.5.5


