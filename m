From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 09/10] netfilter: ipset: styles warned by checkpatch.pl fixed
Date: Mon, 24 Nov 2014 21:46:51 +0100
Message-ID: <1416862012-31139-10-git-send-email-kadlec@blackhole.kfki.hu>
References: <1416862012-31139-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:49174 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169AbaKXUqA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Nov 2014 15:46:00 -0500
In-Reply-To: <1416862012-31139-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 include/linux/netfilter/ipset/ip_set.h       |  7 ++++---
 net/netfilter/ipset/ip_set_core.c            | 11 ++++++++---
 net/netfilter/ipset/ip_set_hash_ipportnet.c  |  2 ++
 net/netfilter/ipset/ip_set_hash_net.c        |  4 +++-
 net/netfilter/ipset/ip_set_hash_netiface.c   |  2 ++
 net/netfilter/ipset/ip_set_hash_netnet.c     |  2 ++
 net/netfilter/ipset/ip_set_hash_netport.c    |  2 ++
 net/netfilter/ipset/ip_set_hash_netportnet.c |  2 ++
 net/netfilter/xt_set.c                       |  7 +++++++
 net/sched/em_ipset.c                         |  5 ++++-
 10 files changed, 36 insertions(+), 8 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index 418d360..b0cfe42 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -325,6 +325,7 @@ ip_set_update_counter(struct ip_set_counter *counter,
 /* RCU-safe assign value */
 #define IP_SET_RCU_ASSIGN(ptr, value)	\
 do {					\
+	/* Safe assign numeric types */ \
 	smp_wmb();			\
 	*(ptr) = value;			\
 } while (0)
@@ -383,10 +384,10 @@ ip_set_put_skbinfo(struct sk_buff *skb, struct ip_set_skbinfo *skbinfo)
 			      cpu_to_be64((u64)skbmark << 32 |
 					  skbmarkmask))) ||
 	       (skbprio &&
-	        nla_put_net32(skb, IPSET_ATTR_SKBPRIO,
+		nla_put_net32(skb, IPSET_ATTR_SKBPRIO,
 			      cpu_to_be32(skbprio))) ||
 	       (skbqueue &&
-	        nla_put_net16(skb, IPSET_ATTR_SKBQUEUE,
+		nla_put_net16(skb, IPSET_ATTR_SKBQUEUE,
 			     cpu_to_be16(skbqueue)));
 
 }
@@ -585,7 +586,7 @@ ip_set_put_extensions(struct sk_buff *skb, const struct ip_set *set,
 
 		if (nla_put_net32(skb, IPSET_ATTR_TIMEOUT,
 			htonl(active ? ip_set_timeout_get(timeout)
-				: *timeout)))
+			      : *timeout)))
 			return -EMSGSIZE;
 	}
 	if (SET_WITH_COUNTER(set) &&
diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 9fb2610..957ec91 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -390,6 +390,7 @@ ip_set_get_extensions(struct ip_set *set, struct nlattr *tb[],
 		      struct ip_set_ext *ext)
 {
 	u64 fullmark;
+
 	if (tb[IPSET_ATTR_TIMEOUT]) {
 		if (!(set->extensions & IPSET_EXT_TIMEOUT))
 			return -IPSET_ERR_TIMEOUT;
@@ -903,7 +904,7 @@ ip_set_create(struct sock *ctnl, struct sk_buff *skb,
 			/* Wraparound */
 			goto cleanup;
 
-		list = kzalloc(sizeof(struct ip_set *) * i, GFP_KERNEL);
+		list = kcalloc(i, sizeof(struct ip_set *), GFP_KERNEL);
 		if (!list)
 			goto cleanup;
 		/* nfnl mutex is held, both lists are valid */
@@ -1179,6 +1180,7 @@ static int
 ip_set_dump_done(struct netlink_callback *cb)
 {
 	struct ip_set_net *inst = (struct ip_set_net *)cb->args[IPSET_CB_NET];
+
 	if (cb->args[IPSET_CB_ARG0]) {
 		pr_debug("release set %s\n",
 			 ip_set(inst, cb->args[IPSET_CB_INDEX])->name);
@@ -1216,7 +1218,7 @@ dump_init(struct netlink_callback *cb, struct ip_set_net *inst)
 
 	/* cb->args[IPSET_CB_NET]:	net namespace
 	 *         [IPSET_CB_DUMP]:	dump single set/all sets
-	 *         [IPSET_CB_INDEX]: 	set index
+	 *         [IPSET_CB_INDEX]:	set index
 	 *         [IPSET_CB_ARG0]:	type specific
 	 */
 
@@ -1235,6 +1237,7 @@ dump_init(struct netlink_callback *cb, struct ip_set_net *inst)
 
 	if (cda[IPSET_ATTR_FLAGS]) {
 		u32 f = ip_set_get_h32(cda[IPSET_ATTR_FLAGS]);
+
 		dump_type |= (f << 16);
 	}
 	cb->args[IPSET_CB_NET] = (unsigned long)inst;
@@ -1864,6 +1867,7 @@ ip_set_sockfn_get(struct sock *sk, int optval, void __user *user, int *len)
 	if (*op < IP_SET_OP_VERSION) {
 		/* Check the version at the beginning of operations */
 		struct ip_set_req_version *req_version = data;
+
 		if (req_version->version != IPSET_PROTOCOL) {
 			ret = -EPROTO;
 			goto done;
@@ -1965,7 +1969,7 @@ ip_set_net_init(struct net *net)
 	if (inst->ip_set_max >= IPSET_INVALID_ID)
 		inst->ip_set_max = IPSET_INVALID_ID - 1;
 
-	list = kzalloc(sizeof(struct ip_set *) * inst->ip_set_max, GFP_KERNEL);
+	list = kcalloc(inst->ip_set_max, sizeof(struct ip_set *), GFP_KERNEL);
 	if (!list)
 		return -ENOMEM;
 	inst->is_deleted = 0;
@@ -2003,6 +2007,7 @@ static int __init
 ip_set_init(void)
 {
 	int ret = nfnetlink_subsys_register(&ip_set_netlink_subsys);
+
 	if (ret != 0) {
 		pr_err("ip_set: cannot register with nfnetlink.\n");
 		return ret;
diff --git a/net/netfilter/ipset/ip_set_hash_ipportnet.c b/net/netfilter/ipset/ip_set_hash_ipportnet.c
index b6012ad..3d07f93 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportnet.c
@@ -224,6 +224,7 @@ hash_ipportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 	if (tb[IPSET_ATTR_CADT_FLAGS]) {
 		u32 cadt_flags = ip_set_get_h32(tb[IPSET_ATTR_CADT_FLAGS]);
+
 		if (cadt_flags & IPSET_FLAG_NOMATCH)
 			flags |= (IPSET_FLAG_NOMATCH << 16);
 	}
@@ -485,6 +486,7 @@ hash_ipportnet6_uadt(struct ip_set *set, struct nlattr *tb[],
 
 	if (tb[IPSET_ATTR_CADT_FLAGS]) {
 		u32 cadt_flags = ip_set_get_h32(tb[IPSET_ATTR_CADT_FLAGS]);
+
 		if (cadt_flags & IPSET_FLAG_NOMATCH)
 			flags |= (IPSET_FLAG_NOMATCH << 16);
 	}
diff --git a/net/netfilter/ipset/ip_set_hash_net.c b/net/netfilter/ipset/ip_set_hash_net.c
index 6b3ac10..cb95064 100644
--- a/net/netfilter/ipset/ip_set_hash_net.c
+++ b/net/netfilter/ipset/ip_set_hash_net.c
@@ -173,6 +173,7 @@ hash_net4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 	if (tb[IPSET_ATTR_CADT_FLAGS]) {
 		u32 cadt_flags = ip_set_get_h32(tb[IPSET_ATTR_CADT_FLAGS]);
+
 		if (cadt_flags & IPSET_FLAG_NOMATCH)
 			flags |= (IPSET_FLAG_NOMATCH << 16);
 	}
@@ -180,7 +181,7 @@ hash_net4_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (adt == IPSET_TEST || !tb[IPSET_ATTR_IP_TO]) {
 		e.ip = htonl(ip & ip_set_hostmask(e.cidr));
 		ret = adtfn(set, &e, &ext, &ext, flags);
-		return ip_set_enomatch(ret, flags, adt, set) ? -ret:
+		return ip_set_enomatch(ret, flags, adt, set) ? -ret :
 		       ip_set_eexist(ret, flags) ? 0 : ret;
 	}
 
@@ -348,6 +349,7 @@ hash_net6_uadt(struct ip_set *set, struct nlattr *tb[],
 
 	if (tb[IPSET_ATTR_CADT_FLAGS]) {
 		u32 cadt_flags = ip_set_get_h32(tb[IPSET_ATTR_CADT_FLAGS]);
+
 		if (cadt_flags & IPSET_FLAG_NOMATCH)
 			flags |= (IPSET_FLAG_NOMATCH << 16);
 	}
diff --git a/net/netfilter/ipset/ip_set_hash_netiface.c b/net/netfilter/ipset/ip_set_hash_netiface.c
index d8a53ec..d7bdb06 100644
--- a/net/netfilter/ipset/ip_set_hash_netiface.c
+++ b/net/netfilter/ipset/ip_set_hash_netiface.c
@@ -218,6 +218,7 @@ hash_netiface4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 	if (tb[IPSET_ATTR_CADT_FLAGS]) {
 		u32 cadt_flags = ip_set_get_h32(tb[IPSET_ATTR_CADT_FLAGS]);
+
 		if (cadt_flags & IPSET_FLAG_PHYSDEV)
 			e.physdev = 1;
 		if (cadt_flags & IPSET_FLAG_NOMATCH)
@@ -433,6 +434,7 @@ hash_netiface6_uadt(struct ip_set *set, struct nlattr *tb[],
 
 	if (tb[IPSET_ATTR_CADT_FLAGS]) {
 		u32 cadt_flags = ip_set_get_h32(tb[IPSET_ATTR_CADT_FLAGS]);
+
 		if (cadt_flags & IPSET_FLAG_PHYSDEV)
 			e.physdev = 1;
 		if (cadt_flags & IPSET_FLAG_NOMATCH)
diff --git a/net/netfilter/ipset/ip_set_hash_netnet.c b/net/netfilter/ipset/ip_set_hash_netnet.c
index ea8772a..ea4d06b 100644
--- a/net/netfilter/ipset/ip_set_hash_netnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netnet.c
@@ -204,6 +204,7 @@ hash_netnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 	if (tb[IPSET_ATTR_CADT_FLAGS]) {
 		u32 cadt_flags = ip_set_get_h32(tb[IPSET_ATTR_CADT_FLAGS]);
+
 		if (cadt_flags & IPSET_FLAG_NOMATCH)
 			flags |= (IPSET_FLAG_NOMATCH << 16);
 	}
@@ -432,6 +433,7 @@ hash_netnet6_uadt(struct ip_set *set, struct nlattr *tb[],
 
 	if (tb[IPSET_ATTR_CADT_FLAGS]) {
 		u32 cadt_flags = ip_set_get_h32(tb[IPSET_ATTR_CADT_FLAGS]);
+
 		if (cadt_flags & IPSET_FLAG_NOMATCH)
 			flags |= (IPSET_FLAG_NOMATCH << 16);
 	}
diff --git a/net/netfilter/ipset/ip_set_hash_netport.c b/net/netfilter/ipset/ip_set_hash_netport.c
index c0ddb58..bc7a1c2 100644
--- a/net/netfilter/ipset/ip_set_hash_netport.c
+++ b/net/netfilter/ipset/ip_set_hash_netport.c
@@ -215,6 +215,7 @@ hash_netport4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 	if (tb[IPSET_ATTR_CADT_FLAGS]) {
 		u32 cadt_flags = ip_set_get_h32(tb[IPSET_ATTR_CADT_FLAGS]);
+
 		if (cadt_flags & IPSET_FLAG_NOMATCH)
 			flags |= (IPSET_FLAG_NOMATCH << 16);
 	}
@@ -436,6 +437,7 @@ hash_netport6_uadt(struct ip_set *set, struct nlattr *tb[],
 
 	if (tb[IPSET_ATTR_CADT_FLAGS]) {
 		u32 cadt_flags = ip_set_get_h32(tb[IPSET_ATTR_CADT_FLAGS]);
+
 		if (cadt_flags & IPSET_FLAG_NOMATCH)
 			flags |= (IPSET_FLAG_NOMATCH << 16);
 	}
diff --git a/net/netfilter/ipset/ip_set_hash_netportnet.c b/net/netfilter/ipset/ip_set_hash_netportnet.c
index bfaa94c..f98d3f6 100644
--- a/net/netfilter/ipset/ip_set_hash_netportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netportnet.c
@@ -239,6 +239,7 @@ hash_netportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 	if (tb[IPSET_ATTR_CADT_FLAGS]) {
 		u32 cadt_flags = ip_set_get_h32(tb[IPSET_ATTR_CADT_FLAGS]);
+
 		if (cadt_flags & IPSET_FLAG_NOMATCH)
 			flags |= (IPSET_FLAG_NOMATCH << 16);
 	}
@@ -515,6 +516,7 @@ hash_netportnet6_uadt(struct ip_set *set, struct nlattr *tb[],
 
 	if (tb[IPSET_ATTR_CADT_FLAGS]) {
 		u32 cadt_flags = ip_set_get_h32(tb[IPSET_ATTR_CADT_FLAGS]);
+
 		if (cadt_flags & IPSET_FLAG_NOMATCH)
 			flags |= (IPSET_FLAG_NOMATCH << 16);
 	}
diff --git a/net/netfilter/xt_set.c b/net/netfilter/xt_set.c
index c3f2638..e9dcd81 100644
--- a/net/netfilter/xt_set.c
+++ b/net/netfilter/xt_set.c
@@ -52,6 +52,7 @@ static bool
 set_match_v0(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_set_info_match_v0 *info = par->matchinfo;
+
 	ADT_OPT(opt, par->family, info->match_set.u.compat.dim,
 		info->match_set.u.compat.flags, 0, UINT_MAX);
 
@@ -114,6 +115,7 @@ static bool
 set_match_v1(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_set_info_match_v1 *info = par->matchinfo;
+
 	ADT_OPT(opt, par->family, info->match_set.dim,
 		info->match_set.flags, 0, UINT_MAX);
 
@@ -178,6 +180,7 @@ static bool
 set_match_v3(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_set_info_match_v3 *info = par->matchinfo;
+
 	ADT_OPT(opt, par->family, info->match_set.dim,
 		info->match_set.flags, info->flags, UINT_MAX);
 	int ret;
@@ -252,6 +255,7 @@ static unsigned int
 set_target_v0(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct xt_set_info_target_v0 *info = par->targinfo;
+
 	ADT_OPT(add_opt, par->family, info->add_set.u.compat.dim,
 		info->add_set.u.compat.flags, 0, UINT_MAX);
 	ADT_OPT(del_opt, par->family, info->del_set.u.compat.dim,
@@ -324,6 +328,7 @@ static unsigned int
 set_target_v1(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct xt_set_info_target_v1 *info = par->targinfo;
+
 	ADT_OPT(add_opt, par->family, info->add_set.dim,
 		info->add_set.flags, 0, UINT_MAX);
 	ADT_OPT(del_opt, par->family, info->del_set.dim,
@@ -392,6 +397,7 @@ static unsigned int
 set_target_v2(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct xt_set_info_target_v2 *info = par->targinfo;
+
 	ADT_OPT(add_opt, par->family, info->add_set.dim,
 		info->add_set.flags, info->flags, info->timeout);
 	ADT_OPT(del_opt, par->family, info->del_set.dim,
@@ -418,6 +424,7 @@ static unsigned int
 set_target_v3(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct xt_set_info_target_v3 *info = par->targinfo;
+
 	ADT_OPT(add_opt, par->family, info->add_set.dim,
 		info->add_set.flags, info->flags, info->timeout);
 	ADT_OPT(del_opt, par->family, info->del_set.dim,
diff --git a/net/sched/em_ipset.c b/net/sched/em_ipset.c
index 5b4a4ef..c3dba5e 100644
--- a/net/sched/em_ipset.c
+++ b/net/sched/em_ipset.c
@@ -44,6 +44,7 @@ static int em_ipset_change(struct net *net, void *data, int data_len,
 static void em_ipset_destroy(struct tcf_ematch *em)
 {
 	const struct xt_set_info *set = (const void *) em->data;
+
 	if (set) {
 		ip_set_nfnl_put(em->net, set->index);
 		kfree((void *) em->data);
@@ -70,7 +71,9 @@ static int em_ipset_match(struct sk_buff *skb, struct tcf_ematch *em,
 		acpar.family = NFPROTO_IPV6;
 		if (!pskb_network_may_pull(skb, sizeof(struct ipv6hdr)))
 			return 0;
-		/* doesn't call ipv6_find_hdr() because ipset doesn't use thoff, yet */
+		/* doesn't call ipv6_find_hdr() because ipset doesn't use
+		 * thoff, yet
+		 */
 		acpar.thoff = sizeof(struct ipv6hdr);
 		break;
 	default:
-- 
1.8.5.1

