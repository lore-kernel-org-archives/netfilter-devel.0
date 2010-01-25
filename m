From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 08/09]: netfilter: nf_conntrack: add support for "conntrack zones"
Date: Mon, 25 Jan 2010 16:37:43 +0100 (MET)
Message-ID: <20100125153742.15305.79058.sendpatchset@x2.localnet>
References: <20100125153732.15305.68011.sendpatchset@x2.localnet>
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45986 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589Ab0AYPhp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Jan 2010 10:37:45 -0500
In-Reply-To: <20100125153732.15305.68011.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 9a53ed59344fe3874d157257c80d7fb1c949a316
Author: Patrick McHardy <kaber@trash.net>
Date:   Mon Jan 25 16:21:52 2010 +0100

    netfilter: nf_conntrack: add support for "conntrack zones"
    
    Normally, each connection needs a unique identity. Conntrack zones allow
    to specify a numerical zone using the CT target, connections in different
    zones can use the same identity.
    
    Example:
    
    # assign connections between veth0 and veth1 to conntrack zone 1:
    
    iptables -t raw -I PREROUTING -i veth0 -j CT --zone 1
    iptables -t raw -I PREROUTING -i veth1 -j CT --zone 1
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/include/linux/netfilter/xt_CT.h b/include/linux/netfilter/xt_CT.h
index a4c1880..fe4ee76 100644
--- a/include/linux/netfilter/xt_CT.h
+++ b/include/linux/netfilter/xt_CT.h
@@ -5,6 +5,7 @@ struct xt_ct_target_info {
 	u_int32_t	ct_events;
 	u_int32_t	exp_events;
 	char		helper[16];
+	u_int16_t	zone;
 
 	/* Used internally by the kernel */
 	struct nf_conn	*ct __attribute__((aligned(8)));
diff --git a/include/net/ip.h b/include/net/ip.h
index 85108cf..61aface 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -336,8 +336,11 @@ enum ip_defrag_users {
 	IP_DEFRAG_LOCAL_DELIVER,
 	IP_DEFRAG_CALL_RA_CHAIN,
 	IP_DEFRAG_CONNTRACK_IN,
+	__IP_DEFRAG_CONNTRACK_IN_END	= IP_DEFRAG_CONNTRACK_IN + 0xffff,
 	IP_DEFRAG_CONNTRACK_OUT,
+	__IP_DEFRAG_CONNTRACK_OUT_END	= IP_DEFRAG_CONNTRACK_OUT + 0xffff,
 	IP_DEFRAG_CONNTRACK_BRIDGE_IN,
+	__IP_DEFRAG_CONNTRACK_BRIDGE_IN = IP_DEFRAG_CONNTRACK_BRIDGE_IN + 0xffff,
 	IP_DEFRAG_VS_IN,
 	IP_DEFRAG_VS_OUT,
 	IP_DEFRAG_VS_FWD
diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 299bbf5..db422f3 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -355,8 +355,11 @@ struct inet_frag_queue;
 enum ip6_defrag_users {
 	IP6_DEFRAG_LOCAL_DELIVER,
 	IP6_DEFRAG_CONNTRACK_IN,
+	__IP6_DEFRAG_CONNTRACK_IN	= IP6_DEFRAG_CONNTRACK_IN + 0xffff,
 	IP6_DEFRAG_CONNTRACK_OUT,
+	__IP6_DEFRAG_CONNTRACK_OUT	= IP6_DEFRAG_CONNTRACK_OUT + 0xffff,
 	IP6_DEFRAG_CONNTRACK_BRIDGE_IN,
+	__IP6_DEFRAG_CONNTRACK_BRIDGE_IN = IP6_DEFRAG_CONNTRACK_BRIDGE_IN + 0xffff,
 };
 
 struct ip6_create_arg {
diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index a0904ad..9488ac6 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -198,7 +198,8 @@ extern void *nf_ct_alloc_hashtable(unsigned int *sizep, int *vmalloced, int null
 extern void nf_ct_free_hashtable(void *hash, int vmalloced, unsigned int size);
 
 extern struct nf_conntrack_tuple_hash *
-__nf_conntrack_find(struct net *net, const struct nf_conntrack_tuple *tuple);
+__nf_conntrack_find(struct net *net, u16 zone,
+		    const struct nf_conntrack_tuple *tuple);
 
 extern void nf_conntrack_hash_insert(struct nf_conn *ct);
 extern void nf_ct_delete_from_lists(struct nf_conn *ct);
@@ -267,7 +268,7 @@ extern void
 nf_ct_iterate_cleanup(struct net *net, int (*iter)(struct nf_conn *i, void *data), void *data);
 extern void nf_conntrack_free(struct nf_conn *ct);
 extern struct nf_conn *
-nf_conntrack_alloc(struct net *net,
+nf_conntrack_alloc(struct net *net, u16 zone,
 		   const struct nf_conntrack_tuple *orig,
 		   const struct nf_conntrack_tuple *repl,
 		   gfp_t gfp);
diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index 5a449b4..dffde8e 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -49,7 +49,8 @@ nf_ct_invert_tuple(struct nf_conntrack_tuple *inverse,
 
 /* Find a connection corresponding to a tuple. */
 extern struct nf_conntrack_tuple_hash *
-nf_conntrack_find_get(struct net *net, const struct nf_conntrack_tuple *tuple);
+nf_conntrack_find_get(struct net *net, u16 zone,
+		      const struct nf_conntrack_tuple *tuple);
 
 extern int __nf_conntrack_confirm(struct sk_buff *skb);
 
diff --git a/include/net/netfilter/nf_conntrack_expect.h b/include/net/netfilter/nf_conntrack_expect.h
index 9a2b9cb..83c49f3 100644
--- a/include/net/netfilter/nf_conntrack_expect.h
+++ b/include/net/netfilter/nf_conntrack_expect.h
@@ -77,13 +77,16 @@ int nf_conntrack_expect_init(struct net *net);
 void nf_conntrack_expect_fini(struct net *net);
 
 struct nf_conntrack_expect *
-__nf_ct_expect_find(struct net *net, const struct nf_conntrack_tuple *tuple);
+__nf_ct_expect_find(struct net *net, u16 zone,
+		    const struct nf_conntrack_tuple *tuple);
 
 struct nf_conntrack_expect *
-nf_ct_expect_find_get(struct net *net, const struct nf_conntrack_tuple *tuple);
+nf_ct_expect_find_get(struct net *net, u16 zone,
+		      const struct nf_conntrack_tuple *tuple);
 
 struct nf_conntrack_expect *
-nf_ct_find_expectation(struct net *net, const struct nf_conntrack_tuple *tuple);
+nf_ct_find_expectation(struct net *net, u16 zone,
+		       const struct nf_conntrack_tuple *tuple);
 
 void nf_ct_unlink_expect(struct nf_conntrack_expect *exp);
 void nf_ct_remove_expectations(struct nf_conn *ct);
diff --git a/include/net/netfilter/nf_conntrack_extend.h b/include/net/netfilter/nf_conntrack_extend.h
index e192dc1..2d2a1f9 100644
--- a/include/net/netfilter/nf_conntrack_extend.h
+++ b/include/net/netfilter/nf_conntrack_extend.h
@@ -8,6 +8,7 @@ enum nf_ct_ext_id {
 	NF_CT_EXT_NAT,
 	NF_CT_EXT_ACCT,
 	NF_CT_EXT_ECACHE,
+	NF_CT_EXT_ZONE,
 	NF_CT_EXT_NUM,
 };
 
@@ -15,6 +16,7 @@ enum nf_ct_ext_id {
 #define NF_CT_EXT_NAT_TYPE struct nf_conn_nat
 #define NF_CT_EXT_ACCT_TYPE struct nf_conn_counter
 #define NF_CT_EXT_ECACHE_TYPE struct nf_conntrack_ecache
+#define NF_CT_EXT_ZONE_TYPE struct nf_conntrack_zone
 
 /* Extensions: optional stuff which isn't permanently in struct. */
 struct nf_ct_ext {
diff --git a/include/net/netfilter/nf_conntrack_zones.h b/include/net/netfilter/nf_conntrack_zones.h
new file mode 100644
index 0000000..31336d2
--- /dev/null
+++ b/include/net/netfilter/nf_conntrack_zones.h
@@ -0,0 +1,21 @@
+#ifndef _NF_CONNTRACK_ZONES_H
+#define _NF_CONNTRACK_ZONES_H
+
+#include <net/netfilter/nf_conntrack_extend.h>
+
+struct nf_conntrack_zone {
+	u16	id;
+};
+
+static inline u16 nf_ct_zone(const struct nf_conn *ct)
+{
+#ifdef CONFIG_NF_CONNTRACK_ZONES
+	struct nf_conntrack_zone *nf_ct_zone;
+	nf_ct_zone = nf_ct_ext_find(ct, NF_CT_EXT_ZONE);
+	if (nf_ct_zone)
+		return nf_ct_zone->id;
+#endif
+	return 0;
+}
+
+#endif /* _NF_CONNTRACK_ZONES_H */
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index d171b12..9c1560d 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -266,7 +266,7 @@ getorigdst(struct sock *sk, int optval, void __user *user, int *len)
 		return -EINVAL;
 	}
 
-	h = nf_conntrack_find_get(sock_net(sk), &tuple);
+	h = nf_conntrack_find_get(sock_net(sk), 0, &tuple);
 	if (h) {
 		struct sockaddr_in sin;
 		struct nf_conn *ct = nf_ct_tuplehash_to_ctrack(h);
diff --git a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
index 327826a..19c3d7f 100644
--- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
@@ -18,6 +18,7 @@
 #include <net/netfilter/nf_conntrack_tuple.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_core.h>
+#include <net/netfilter/nf_conntrack_zones.h>
 #include <net/netfilter/nf_log.h>
 
 static unsigned int nf_ct_icmp_timeout __read_mostly = 30*HZ;
@@ -114,13 +115,14 @@ static bool icmp_new(struct nf_conn *ct, const struct sk_buff *skb,
 
 /* Returns conntrack if it dealt with ICMP, and filled in skb fields */
 static int
-icmp_error_message(struct net *net, struct sk_buff *skb,
+icmp_error_message(struct net *net, struct nf_conn *tmpl, struct sk_buff *skb,
 		 enum ip_conntrack_info *ctinfo,
 		 unsigned int hooknum)
 {
 	struct nf_conntrack_tuple innertuple, origtuple;
 	const struct nf_conntrack_l4proto *innerproto;
 	const struct nf_conntrack_tuple_hash *h;
+	u16 zone = tmpl ? nf_ct_zone(tmpl) : 0;
 
 	NF_CT_ASSERT(skb->nfct == NULL);
 
@@ -146,7 +148,7 @@ icmp_error_message(struct net *net, struct sk_buff *skb,
 
 	*ctinfo = IP_CT_RELATED;
 
-	h = nf_conntrack_find_get(net, &innertuple);
+	h = nf_conntrack_find_get(net, zone, &innertuple);
 	if (!h) {
 		pr_debug("icmp_error_message: no match\n");
 		return -NF_ACCEPT;
@@ -209,7 +211,7 @@ icmp_error(struct net *net, struct nf_conn *tmpl,
 	    icmph->type != ICMP_REDIRECT)
 		return NF_ACCEPT;
 
-	return icmp_error_message(net, skb, ctinfo, hooknum);
+	return icmp_error_message(net, tmpl, skb, ctinfo, hooknum);
 }
 
 #if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
diff --git a/net/ipv4/netfilter/nf_defrag_ipv4.c b/net/ipv4/netfilter/nf_defrag_ipv4.c
index 331ead3..cecff07 100644
--- a/net/ipv4/netfilter/nf_defrag_ipv4.c
+++ b/net/ipv4/netfilter/nf_defrag_ipv4.c
@@ -16,6 +16,7 @@
 
 #include <linux/netfilter_bridge.h>
 #include <linux/netfilter_ipv4.h>
+#include <net/netfilter/nf_conntrack_zones.h>
 #include <net/netfilter/ipv4/nf_defrag_ipv4.h>
 
 /* Returns new sk_buff, or NULL */
@@ -38,15 +39,17 @@ static int nf_ct_ipv4_gather_frags(struct sk_buff *skb, u_int32_t user)
 static enum ip_defrag_users nf_ct_defrag_user(unsigned int hooknum,
 					      struct sk_buff *skb)
 {
+	u16 zone = 0;
+
 #ifdef CONFIG_BRIDGE_NETFILTER
 	if (skb->nf_bridge &&
 	    skb->nf_bridge->mask & BRNF_NF_BRIDGE_PREROUTING)
-		return IP_DEFRAG_CONNTRACK_BRIDGE_IN;
+		return IP_DEFRAG_CONNTRACK_BRIDGE_IN + zone;
 #endif
 	if (hooknum == NF_INET_PRE_ROUTING)
-		return IP_DEFRAG_CONNTRACK_IN;
+		return IP_DEFRAG_CONNTRACK_IN + zone;
 	else
-		return IP_DEFRAG_CONNTRACK_OUT;
+		return IP_DEFRAG_CONNTRACK_OUT + zone;
 }
 
 static unsigned int ipv4_conntrack_defrag(unsigned int hooknum,
diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
index fe1a644..64b9979 100644
--- a/net/ipv4/netfilter/nf_nat_core.c
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -30,6 +30,7 @@
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <net/netfilter/nf_conntrack_l3proto.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
+#include <net/netfilter/nf_conntrack_zones.h>
 
 static DEFINE_SPINLOCK(nf_nat_lock);
 
@@ -72,13 +73,13 @@ EXPORT_SYMBOL_GPL(nf_nat_proto_put);
 
 /* We keep an extra hash for each conntrack, for fast searching. */
 static inline unsigned int
-hash_by_src(const struct nf_conntrack_tuple *tuple)
+hash_by_src(const struct nf_conntrack_tuple *tuple, u16 zone)
 {
 	unsigned int hash;
 
 	/* Original src, to ensure we map it consistently if poss. */
 	hash = jhash_3words((__force u32)tuple->src.u3.ip,
-			    (__force u32)tuple->src.u.all,
+			    (__force u32)tuple->src.u.all ^ zone,
 			    tuple->dst.protonum, 0);
 	return ((u64)hash * nf_nat_htable_size) >> 32;
 }
@@ -142,12 +143,12 @@ same_src(const struct nf_conn *ct,
 
 /* Only called for SRC manip */
 static int
-find_appropriate_src(struct net *net,
+find_appropriate_src(struct net *net, u16 zone,
 		     const struct nf_conntrack_tuple *tuple,
 		     struct nf_conntrack_tuple *result,
 		     const struct nf_nat_range *range)
 {
-	unsigned int h = hash_by_src(tuple);
+	unsigned int h = hash_by_src(tuple, zone);
 	const struct nf_conn_nat *nat;
 	const struct nf_conn *ct;
 	const struct hlist_node *n;
@@ -155,7 +156,7 @@ find_appropriate_src(struct net *net,
 	rcu_read_lock();
 	hlist_for_each_entry_rcu(nat, n, &net->ipv4.nat_bysource[h], bysource) {
 		ct = nat->ct;
-		if (same_src(ct, tuple)) {
+		if (same_src(ct, tuple) && nf_ct_zone(ct) == zone) {
 			/* Copy source part from reply tuple. */
 			nf_ct_invert_tuplepr(result,
 				       &ct->tuplehash[IP_CT_DIR_REPLY].tuple);
@@ -178,7 +179,7 @@ find_appropriate_src(struct net *net,
    the ip with the lowest src-ip/dst-ip/proto usage.
 */
 static void
-find_best_ips_proto(struct nf_conntrack_tuple *tuple,
+find_best_ips_proto(u16 zone, struct nf_conntrack_tuple *tuple,
 		    const struct nf_nat_range *range,
 		    const struct nf_conn *ct,
 		    enum nf_nat_manip_type maniptype)
@@ -212,7 +213,7 @@ find_best_ips_proto(struct nf_conntrack_tuple *tuple,
 	maxip = ntohl(range->max_ip);
 	j = jhash_2words((__force u32)tuple->src.u3.ip,
 			 range->flags & IP_NAT_RANGE_PERSISTENT ?
-				0 : (__force u32)tuple->dst.u3.ip, 0);
+				0 : (__force u32)tuple->dst.u3.ip ^ zone, 0);
 	j = ((u64)j * (maxip - minip + 1)) >> 32;
 	*var_ipp = htonl(minip + j);
 }
@@ -232,6 +233,7 @@ get_unique_tuple(struct nf_conntrack_tuple *tuple,
 {
 	struct net *net = nf_ct_net(ct);
 	const struct nf_nat_protocol *proto;
+	u16 zone = nf_ct_zone(ct);
 
 	/* 1) If this srcip/proto/src-proto-part is currently mapped,
 	   and that same mapping gives a unique tuple within the given
@@ -242,7 +244,7 @@ get_unique_tuple(struct nf_conntrack_tuple *tuple,
 	   manips not an issue.  */
 	if (maniptype == IP_NAT_MANIP_SRC &&
 	    !(range->flags & IP_NAT_RANGE_PROTO_RANDOM)) {
-		if (find_appropriate_src(net, orig_tuple, tuple, range)) {
+		if (find_appropriate_src(net, zone, orig_tuple, tuple, range)) {
 			pr_debug("get_unique_tuple: Found current src map\n");
 			if (!nf_nat_used_tuple(tuple, ct))
 				return;
@@ -252,7 +254,7 @@ get_unique_tuple(struct nf_conntrack_tuple *tuple,
 	/* 2) Select the least-used IP/proto combination in the given
 	   range. */
 	*tuple = *orig_tuple;
-	find_best_ips_proto(tuple, range, ct, maniptype);
+	find_best_ips_proto(zone, tuple, range, ct, maniptype);
 
 	/* 3) The per-protocol part of the manip is made to map into
 	   the range to make a unique tuple. */
@@ -330,7 +332,8 @@ nf_nat_setup_info(struct nf_conn *ct,
 	if (have_to_hash) {
 		unsigned int srchash;
 
-		srchash = hash_by_src(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
+		srchash = hash_by_src(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
+				      nf_ct_zone(ct));
 		spin_lock_bh(&nf_nat_lock);
 		/* nf_conntrack_alter_reply might re-allocate exntension aera */
 		nat = nfct_nat(ct);
diff --git a/net/ipv4/netfilter/nf_nat_pptp.c b/net/ipv4/netfilter/nf_nat_pptp.c
index 9eb1710..4c06003 100644
--- a/net/ipv4/netfilter/nf_nat_pptp.c
+++ b/net/ipv4/netfilter/nf_nat_pptp.c
@@ -25,6 +25,7 @@
 #include <net/netfilter/nf_nat_rule.h>
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <net/netfilter/nf_conntrack_expect.h>
+#include <net/netfilter/nf_conntrack_zones.h>
 #include <linux/netfilter/nf_conntrack_proto_gre.h>
 #include <linux/netfilter/nf_conntrack_pptp.h>
 
@@ -74,7 +75,7 @@ static void pptp_nat_expected(struct nf_conn *ct,
 
 	pr_debug("trying to unexpect other dir: ");
 	nf_ct_dump_tuple_ip(&t);
-	other_exp = nf_ct_expect_find_get(net, &t);
+	other_exp = nf_ct_expect_find_get(net, nf_ct_zone(ct), &t);
 	if (other_exp) {
 		nf_ct_unexpect_related(other_exp);
 		nf_ct_expect_put(other_exp);
diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index 0956eba..b4e014f 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -27,6 +27,7 @@
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_l3proto.h>
 #include <net/netfilter/nf_conntrack_core.h>
+#include <net/netfilter/nf_conntrack_zones.h>
 #include <net/netfilter/ipv6/nf_conntrack_ipv6.h>
 #include <net/netfilter/nf_log.h>
 
@@ -191,15 +192,17 @@ out:
 static enum ip6_defrag_users nf_ct6_defrag_user(unsigned int hooknum,
 						struct sk_buff *skb)
 {
+	u16 zone = 0;
+
 #ifdef CONFIG_BRIDGE_NETFILTER
 	if (skb->nf_bridge &&
 	    skb->nf_bridge->mask & BRNF_NF_BRIDGE_PREROUTING)
-		return IP6_DEFRAG_CONNTRACK_BRIDGE_IN;
+		return IP6_DEFRAG_CONNTRACK_BRIDGE_IN + zone;
 #endif
 	if (hooknum == NF_INET_PRE_ROUTING)
-		return IP6_DEFRAG_CONNTRACK_IN;
+		return IP6_DEFRAG_CONNTRACK_IN + zone;
 	else
-		return IP6_DEFRAG_CONNTRACK_OUT;
+		return IP6_DEFRAG_CONNTRACK_OUT + zone;
 
 }
 
diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
index d772dc2..bb4f912 100644
--- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
@@ -23,6 +23,7 @@
 #include <net/netfilter/nf_conntrack_tuple.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_core.h>
+#include <net/netfilter/nf_conntrack_zones.h>
 #include <net/netfilter/ipv6/nf_conntrack_icmpv6.h>
 #include <net/netfilter/nf_log.h>
 
@@ -128,7 +129,7 @@ static bool icmpv6_new(struct nf_conn *ct, const struct sk_buff *skb,
 }
 
 static int
-icmpv6_error_message(struct net *net,
+icmpv6_error_message(struct net *net, struct nf_conn *tmpl,
 		     struct sk_buff *skb,
 		     unsigned int icmp6off,
 		     enum ip_conntrack_info *ctinfo,
@@ -137,6 +138,7 @@ icmpv6_error_message(struct net *net,
 	struct nf_conntrack_tuple intuple, origtuple;
 	const struct nf_conntrack_tuple_hash *h;
 	const struct nf_conntrack_l4proto *inproto;
+	u16 zone = tmpl ? nf_ct_zone(tmpl) : 0;
 
 	NF_CT_ASSERT(skb->nfct == NULL);
 
@@ -163,7 +165,7 @@ icmpv6_error_message(struct net *net,
 
 	*ctinfo = IP_CT_RELATED;
 
-	h = nf_conntrack_find_get(net, &intuple);
+	h = nf_conntrack_find_get(net, zone, &intuple);
 	if (!h) {
 		pr_debug("icmpv6_error: no match\n");
 		return -NF_ACCEPT;
@@ -216,7 +218,7 @@ icmpv6_error(struct net *net, struct nf_conn *tmpl,
 	if (icmp6h->icmp6_type >= 128)
 		return NF_ACCEPT;
 
-	return icmpv6_error_message(net, skb, dataoff, ctinfo, hooknum);
+	return icmpv6_error_message(net, tmpl, skb, dataoff, ctinfo, hooknum);
 }
 
 #if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 710a33b..f1d3883 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -83,6 +83,15 @@ config NF_CONNTRACK_SECMARK
 
 	  If unsure, say 'N'.
 
+config NF_CONNTRACK_ZONES
+	bool  'Connection tracking zones'
+	help
+	  This option enables support for connection tracking zones.
+	  Normally, each connection needs to have a unique identity.
+	  Connection tracking zones allow to have multiple connections
+	  using the same identity, as long as they are contained in
+	  different zones.
+
 config NF_CONNTRACK_EVENTS
 	bool "Connection tracking events"
 	depends on NETFILTER_ADVANCED
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index b8b52da..64900bc 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -41,6 +41,7 @@
 #include <net/netfilter/nf_conntrack_extend.h>
 #include <net/netfilter/nf_conntrack_acct.h>
 #include <net/netfilter/nf_conntrack_ecache.h>
+#include <net/netfilter/nf_conntrack_zones.h>
 #include <net/netfilter/nf_nat.h>
 #include <net/netfilter/nf_nat_core.h>
 
@@ -69,7 +70,7 @@ static int nf_conntrack_hash_rnd_initted;
 static unsigned int nf_conntrack_hash_rnd;
 
 static u_int32_t __hash_conntrack(const struct nf_conntrack_tuple *tuple,
-				  unsigned int size, unsigned int rnd)
+				  u16 zone, unsigned int size, unsigned int rnd)
 {
 	unsigned int n;
 	u_int32_t h;
@@ -80,15 +81,16 @@ static u_int32_t __hash_conntrack(const struct nf_conntrack_tuple *tuple,
 	 */
 	n = (sizeof(tuple->src) + sizeof(tuple->dst.u3)) / sizeof(u32);
 	h = jhash2((u32 *)tuple, n,
-		   rnd ^ (((__force __u16)tuple->dst.u.all << 16) |
-			  tuple->dst.protonum));
+		   zone ^ rnd ^ (((__force __u16)tuple->dst.u.all << 16) |
+				 tuple->dst.protonum));
 
 	return ((u64)h * size) >> 32;
 }
 
-static inline u_int32_t hash_conntrack(const struct nf_conntrack_tuple *tuple)
+static inline u_int32_t hash_conntrack(const struct nf_conntrack_tuple *tuple,
+				       u16 zone)
 {
-	return __hash_conntrack(tuple, nf_conntrack_htable_size,
+	return __hash_conntrack(tuple, zone, nf_conntrack_htable_size,
 				nf_conntrack_hash_rnd);
 }
 
@@ -292,11 +294,12 @@ static void death_by_timeout(unsigned long ul_conntrack)
  * - Caller must lock nf_conntrack_lock before calling this function
  */
 struct nf_conntrack_tuple_hash *
-__nf_conntrack_find(struct net *net, const struct nf_conntrack_tuple *tuple)
+__nf_conntrack_find(struct net *net, u16 zone,
+		    const struct nf_conntrack_tuple *tuple)
 {
 	struct nf_conntrack_tuple_hash *h;
 	struct hlist_nulls_node *n;
-	unsigned int hash = hash_conntrack(tuple);
+	unsigned int hash = hash_conntrack(tuple, zone);
 
 	/* Disable BHs the entire time since we normally need to disable them
 	 * at least once for the stats anyway.
@@ -304,7 +307,8 @@ __nf_conntrack_find(struct net *net, const struct nf_conntrack_tuple *tuple)
 	local_bh_disable();
 begin:
 	hlist_nulls_for_each_entry_rcu(h, n, &net->ct.hash[hash], hnnode) {
-		if (nf_ct_tuple_equal(tuple, &h->tuple)) {
+		if (nf_ct_tuple_equal(tuple, &h->tuple) &&
+		    nf_ct_zone(nf_ct_tuplehash_to_ctrack(h)) == zone) {
 			NF_CT_STAT_INC(net, found);
 			local_bh_enable();
 			return h;
@@ -326,21 +330,23 @@ EXPORT_SYMBOL_GPL(__nf_conntrack_find);
 
 /* Find a connection corresponding to a tuple. */
 struct nf_conntrack_tuple_hash *
-nf_conntrack_find_get(struct net *net, const struct nf_conntrack_tuple *tuple)
+nf_conntrack_find_get(struct net *net, u16 zone,
+		      const struct nf_conntrack_tuple *tuple)
 {
 	struct nf_conntrack_tuple_hash *h;
 	struct nf_conn *ct;
 
 	rcu_read_lock();
 begin:
-	h = __nf_conntrack_find(net, tuple);
+	h = __nf_conntrack_find(net, zone, tuple);
 	if (h) {
 		ct = nf_ct_tuplehash_to_ctrack(h);
 		if (unlikely(nf_ct_is_dying(ct) ||
 			     !atomic_inc_not_zero(&ct->ct_general.use)))
 			h = NULL;
 		else {
-			if (unlikely(!nf_ct_tuple_equal(tuple, &h->tuple))) {
+			if (unlikely(!nf_ct_tuple_equal(tuple, &h->tuple) ||
+				     nf_ct_zone(ct) != zone)) {
 				nf_ct_put(ct);
 				goto begin;
 			}
@@ -367,9 +373,11 @@ static void __nf_conntrack_hash_insert(struct nf_conn *ct,
 void nf_conntrack_hash_insert(struct nf_conn *ct)
 {
 	unsigned int hash, repl_hash;
+	u16 zone;
 
-	hash = hash_conntrack(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
-	repl_hash = hash_conntrack(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
+	zone = nf_ct_zone(ct);
+	hash = hash_conntrack(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple, zone);
+	repl_hash = hash_conntrack(&ct->tuplehash[IP_CT_DIR_REPLY].tuple, zone);
 
 	__nf_conntrack_hash_insert(ct, hash, repl_hash);
 }
@@ -386,6 +394,7 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 	struct hlist_nulls_node *n;
 	enum ip_conntrack_info ctinfo;
 	struct net *net;
+	u16 zone;
 
 	ct = nf_ct_get(skb, &ctinfo);
 	net = nf_ct_net(ct);
@@ -397,8 +406,9 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 	if (CTINFO2DIR(ctinfo) != IP_CT_DIR_ORIGINAL)
 		return NF_ACCEPT;
 
-	hash = hash_conntrack(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
-	repl_hash = hash_conntrack(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
+	zone = nf_ct_zone(ct);
+	hash = hash_conntrack(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple, zone);
+	repl_hash = hash_conntrack(&ct->tuplehash[IP_CT_DIR_REPLY].tuple, zone);
 
 	/* We're not in hash table, and we refuse to set up related
 	   connections for unconfirmed conns.  But packet copies and
@@ -417,11 +427,13 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 	   not in the hash.  If there is, we lost race. */
 	hlist_nulls_for_each_entry(h, n, &net->ct.hash[hash], hnnode)
 		if (nf_ct_tuple_equal(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
-				      &h->tuple))
+				      &h->tuple) &&
+		    zone == nf_ct_zone(nf_ct_tuplehash_to_ctrack(h)))
 			goto out;
 	hlist_nulls_for_each_entry(h, n, &net->ct.hash[repl_hash], hnnode)
 		if (nf_ct_tuple_equal(&ct->tuplehash[IP_CT_DIR_REPLY].tuple,
-				      &h->tuple))
+				      &h->tuple) &&
+		    zone == nf_ct_zone(nf_ct_tuplehash_to_ctrack(h)))
 			goto out;
 
 	/* Remove from unconfirmed list */
@@ -468,15 +480,19 @@ nf_conntrack_tuple_taken(const struct nf_conntrack_tuple *tuple,
 	struct net *net = nf_ct_net(ignored_conntrack);
 	struct nf_conntrack_tuple_hash *h;
 	struct hlist_nulls_node *n;
-	unsigned int hash = hash_conntrack(tuple);
+	struct nf_conn *ct;
+	u16 zone = nf_ct_zone(ignored_conntrack);
+	unsigned int hash = hash_conntrack(tuple, zone);
 
 	/* Disable BHs the entire time since we need to disable them at
 	 * least once for the stats anyway.
 	 */
 	rcu_read_lock_bh();
 	hlist_nulls_for_each_entry_rcu(h, n, &net->ct.hash[hash], hnnode) {
-		if (nf_ct_tuplehash_to_ctrack(h) != ignored_conntrack &&
-		    nf_ct_tuple_equal(tuple, &h->tuple)) {
+		ct = nf_ct_tuplehash_to_ctrack(h);
+		if (ct != ignored_conntrack &&
+		    nf_ct_tuple_equal(tuple, &h->tuple) &&
+		    nf_ct_zone(ct) == zone) {
 			NF_CT_STAT_INC(net, found);
 			rcu_read_unlock_bh();
 			return 1;
@@ -539,7 +555,7 @@ static noinline int early_drop(struct net *net, unsigned int hash)
 	return dropped;
 }
 
-struct nf_conn *nf_conntrack_alloc(struct net *net,
+struct nf_conn *nf_conntrack_alloc(struct net *net, u16 zone,
 				   const struct nf_conntrack_tuple *orig,
 				   const struct nf_conntrack_tuple *repl,
 				   gfp_t gfp)
@@ -557,7 +573,7 @@ struct nf_conn *nf_conntrack_alloc(struct net *net,
 
 	if (nf_conntrack_max &&
 	    unlikely(atomic_read(&net->ct.count) > nf_conntrack_max)) {
-		unsigned int hash = hash_conntrack(orig);
+		unsigned int hash = hash_conntrack(orig, zone);
 		if (!early_drop(net, hash)) {
 			atomic_dec(&net->ct.count);
 			if (net_ratelimit())
@@ -578,6 +594,7 @@ struct nf_conn *nf_conntrack_alloc(struct net *net,
 		atomic_dec(&net->ct.count);
 		return ERR_PTR(-ENOMEM);
 	}
+
 	/*
 	 * Let ct->tuplehash[IP_CT_DIR_ORIGINAL].hnnode.next
 	 * and ct->tuplehash[IP_CT_DIR_REPLY].hnnode.next unchanged.
@@ -594,13 +611,28 @@ struct nf_conn *nf_conntrack_alloc(struct net *net,
 #ifdef CONFIG_NET_NS
 	ct->ct_net = net;
 #endif
-
+#ifdef CONFIG_NF_CONNTRACK_ZONES
+	if (zone) {
+		struct nf_conntrack_zone *nf_ct_zone;
+
+		nf_ct_zone = nf_ct_ext_add(ct, NF_CT_EXT_ZONE, GFP_ATOMIC);
+		if (!nf_ct_zone)
+			goto out_free;
+		nf_ct_zone->id = zone;
+	}
+#endif
 	/*
 	 * changes to lookup keys must be done before setting refcnt to 1
 	 */
 	smp_wmb();
 	atomic_set(&ct->ct_general.use, 1);
 	return ct;
+
+#ifdef CONFIG_NF_CONNTRACK_ZONES
+out_free:
+	kmem_cache_free(nf_conntrack_cachep, ct);
+	return ERR_PTR(-ENOMEM);
+#endif
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_alloc);
 
@@ -630,13 +662,14 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
 	struct nf_conntrack_tuple repl_tuple;
 	struct nf_conntrack_ecache *ecache;
 	struct nf_conntrack_expect *exp;
+	u16 zone = tmpl ? nf_ct_zone(tmpl) : 0;
 
 	if (!nf_ct_invert_tuple(&repl_tuple, tuple, l3proto, l4proto)) {
 		pr_debug("Can't invert tuple.\n");
 		return NULL;
 	}
 
-	ct = nf_conntrack_alloc(net, tuple, &repl_tuple, GFP_ATOMIC);
+	ct = nf_conntrack_alloc(net, zone, tuple, &repl_tuple, GFP_ATOMIC);
 	if (IS_ERR(ct)) {
 		pr_debug("Can't allocate conntrack.\n");
 		return (struct nf_conntrack_tuple_hash *)ct;
@@ -656,7 +689,7 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
 			     GFP_ATOMIC);
 
 	spin_lock_bh(&nf_conntrack_lock);
-	exp = nf_ct_find_expectation(net, tuple);
+	exp = nf_ct_find_expectation(net, zone, tuple);
 	if (exp) {
 		pr_debug("conntrack: expectation arrives ct=%p exp=%p\n",
 			 ct, exp);
@@ -712,6 +745,7 @@ resolve_normal_ct(struct net *net, struct nf_conn *tmpl,
 	struct nf_conntrack_tuple tuple;
 	struct nf_conntrack_tuple_hash *h;
 	struct nf_conn *ct;
+	u16 zone = tmpl ? nf_ct_zone(tmpl) : 0;
 
 	if (!nf_ct_get_tuple(skb, skb_network_offset(skb),
 			     dataoff, l3num, protonum, &tuple, l3proto,
@@ -721,7 +755,7 @@ resolve_normal_ct(struct net *net, struct nf_conn *tmpl,
 	}
 
 	/* look for tuple match */
-	h = nf_conntrack_find_get(net, &tuple);
+	h = nf_conntrack_find_get(net, zone, &tuple);
 	if (!h) {
 		h = init_conntrack(net, tmpl, &tuple, l3proto, l4proto,
 				   skb, dataoff);
@@ -957,6 +991,12 @@ bool __nf_ct_kill_acct(struct nf_conn *ct,
 }
 EXPORT_SYMBOL_GPL(__nf_ct_kill_acct);
 
+static struct nf_ct_ext_type nf_ct_zone_extend __read_mostly = {
+	.len	= sizeof(struct nf_conntrack_zone),
+	.align	= __alignof__(struct nf_conntrack_zone),
+	.id	= NF_CT_EXT_ZONE,
+};
+
 #if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
 
 #include <linux/netfilter/nfnetlink.h>
@@ -1134,6 +1174,9 @@ static void nf_conntrack_cleanup_init_net(void)
 {
 	nf_conntrack_helper_fini();
 	nf_conntrack_proto_fini();
+#ifdef CONFIG_NF_CONNTRACK_ZONES
+	nf_ct_extend_unregister(&nf_ct_zone_extend);
+#endif
 	kmem_cache_destroy(nf_conntrack_cachep);
 }
 
@@ -1212,6 +1255,7 @@ int nf_conntrack_set_hashsize(const char *val, struct kernel_param *kp)
 	int rnd;
 	struct hlist_nulls_head *hash, *old_hash;
 	struct nf_conntrack_tuple_hash *h;
+	struct nf_conn *ct;
 
 	/* On boot, we can set this without any fancy locking. */
 	if (!nf_conntrack_htable_size)
@@ -1239,8 +1283,10 @@ int nf_conntrack_set_hashsize(const char *val, struct kernel_param *kp)
 		while (!hlist_nulls_empty(&init_net.ct.hash[i])) {
 			h = hlist_nulls_entry(init_net.ct.hash[i].first,
 					struct nf_conntrack_tuple_hash, hnnode);
+			ct = nf_ct_tuplehash_to_ctrack(h);
 			hlist_nulls_del_rcu(&h->hnnode);
-			bucket = __hash_conntrack(&h->tuple, hashsize, rnd);
+			bucket = __hash_conntrack(&h->tuple, nf_ct_zone(ct),
+						  hashsize, rnd);
 			hlist_nulls_add_head_rcu(&h->hnnode, &hash[bucket]);
 		}
 	}
@@ -1307,8 +1353,17 @@ static int nf_conntrack_init_init_net(void)
 	if (ret < 0)
 		goto err_helper;
 
+#ifdef CONFIG_NF_CONNTRACK_ZONES
+	ret = nf_ct_extend_register(&nf_ct_zone_extend);
+	if (ret < 0)
+		goto err_extend;
+#endif
 	return 0;
 
+#ifdef CONFIG_NF_CONNTRACK_ZONES
+err_extend:
+	nf_conntrack_helper_fini();
+#endif
 err_helper:
 	nf_conntrack_proto_fini();
 err_proto:
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index fdf5d2a..b3052cb 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -27,6 +27,7 @@
 #include <net/netfilter/nf_conntrack_expect.h>
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <net/netfilter/nf_conntrack_tuple.h>
+#include <net/netfilter/nf_conntrack_zones.h>
 
 unsigned int nf_ct_expect_hsize __read_mostly;
 EXPORT_SYMBOL_GPL(nf_ct_expect_hsize);
@@ -84,7 +85,8 @@ static unsigned int nf_ct_expect_dst_hash(const struct nf_conntrack_tuple *tuple
 }
 
 struct nf_conntrack_expect *
-__nf_ct_expect_find(struct net *net, const struct nf_conntrack_tuple *tuple)
+__nf_ct_expect_find(struct net *net, u16 zone,
+		    const struct nf_conntrack_tuple *tuple)
 {
 	struct nf_conntrack_expect *i;
 	struct hlist_node *n;
@@ -95,7 +97,8 @@ __nf_ct_expect_find(struct net *net, const struct nf_conntrack_tuple *tuple)
 
 	h = nf_ct_expect_dst_hash(tuple);
 	hlist_for_each_entry_rcu(i, n, &net->ct.expect_hash[h], hnode) {
-		if (nf_ct_tuple_mask_cmp(tuple, &i->tuple, &i->mask))
+		if (nf_ct_tuple_mask_cmp(tuple, &i->tuple, &i->mask) &&
+		    nf_ct_zone(i->master) == zone)
 			return i;
 	}
 	return NULL;
@@ -104,12 +107,13 @@ EXPORT_SYMBOL_GPL(__nf_ct_expect_find);
 
 /* Just find a expectation corresponding to a tuple. */
 struct nf_conntrack_expect *
-nf_ct_expect_find_get(struct net *net, const struct nf_conntrack_tuple *tuple)
+nf_ct_expect_find_get(struct net *net, u16 zone,
+		      const struct nf_conntrack_tuple *tuple)
 {
 	struct nf_conntrack_expect *i;
 
 	rcu_read_lock();
-	i = __nf_ct_expect_find(net, tuple);
+	i = __nf_ct_expect_find(net, zone, tuple);
 	if (i && !atomic_inc_not_zero(&i->use))
 		i = NULL;
 	rcu_read_unlock();
@@ -121,7 +125,8 @@ EXPORT_SYMBOL_GPL(nf_ct_expect_find_get);
 /* If an expectation for this connection is found, it gets delete from
  * global list then returned. */
 struct nf_conntrack_expect *
-nf_ct_find_expectation(struct net *net, const struct nf_conntrack_tuple *tuple)
+nf_ct_find_expectation(struct net *net, u16 zone,
+		       const struct nf_conntrack_tuple *tuple)
 {
 	struct nf_conntrack_expect *i, *exp = NULL;
 	struct hlist_node *n;
@@ -133,7 +138,8 @@ nf_ct_find_expectation(struct net *net, const struct nf_conntrack_tuple *tuple)
 	h = nf_ct_expect_dst_hash(tuple);
 	hlist_for_each_entry(i, n, &net->ct.expect_hash[h], hnode) {
 		if (!(i->flags & NF_CT_EXPECT_INACTIVE) &&
-		    nf_ct_tuple_mask_cmp(tuple, &i->tuple, &i->mask)) {
+		    nf_ct_tuple_mask_cmp(tuple, &i->tuple, &i->mask) &&
+		    nf_ct_zone(i->master) == zone) {
 			exp = i;
 			break;
 		}
@@ -204,7 +210,8 @@ static inline int expect_matches(const struct nf_conntrack_expect *a,
 {
 	return a->master == b->master && a->class == b->class &&
 		nf_ct_tuple_equal(&a->tuple, &b->tuple) &&
-		nf_ct_tuple_mask_equal(&a->mask, &b->mask);
+		nf_ct_tuple_mask_equal(&a->mask, &b->mask) &&
+		nf_ct_zone(a->master) == nf_ct_zone(b->master);
 }
 
 /* Generally a bad idea to call this: could have matched already. */
diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
index 6636949..a1c8dd9 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -29,6 +29,7 @@
 #include <net/netfilter/nf_conntrack_expect.h>
 #include <net/netfilter/nf_conntrack_ecache.h>
 #include <net/netfilter/nf_conntrack_helper.h>
+#include <net/netfilter/nf_conntrack_zones.h>
 #include <linux/netfilter/nf_conntrack_h323.h>
 
 /* Parameters */
@@ -1216,7 +1217,7 @@ static struct nf_conntrack_expect *find_expect(struct nf_conn *ct,
 	tuple.dst.u.tcp.port = port;
 	tuple.dst.protonum = IPPROTO_TCP;
 
-	exp = __nf_ct_expect_find(net, &tuple);
+	exp = __nf_ct_expect_find(net, nf_ct_zone(ct), &tuple);
 	if (exp && exp->master == ct)
 		return exp;
 	return NULL;
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 09044f9..1dcd7a0 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -796,7 +796,7 @@ ctnetlink_del_conntrack(struct sock *ctnl, struct sk_buff *skb,
 	if (err < 0)
 		return err;
 
-	h = nf_conntrack_find_get(net, &tuple);
+	h = nf_conntrack_find_get(net, 0, &tuple);
 	if (!h)
 		return -ENOENT;
 
@@ -857,7 +857,7 @@ ctnetlink_get_conntrack(struct sock *ctnl, struct sk_buff *skb,
 	if (err < 0)
 		return err;
 
-	h = nf_conntrack_find_get(net, &tuple);
+	h = nf_conntrack_find_get(net, 0, &tuple);
 	if (!h)
 		return -ENOENT;
 
@@ -1194,7 +1194,7 @@ ctnetlink_create_conntrack(struct net *net,
 	int err = -EINVAL;
 	struct nf_conntrack_helper *helper;
 
-	ct = nf_conntrack_alloc(net, otuple, rtuple, GFP_ATOMIC);
+	ct = nf_conntrack_alloc(net, 0, otuple, rtuple, GFP_ATOMIC);
 	if (IS_ERR(ct))
 		return ERR_PTR(-ENOMEM);
 
@@ -1298,7 +1298,7 @@ ctnetlink_create_conntrack(struct net *net,
 		if (err < 0)
 			goto err2;
 
-		master_h = nf_conntrack_find_get(net, &master);
+		master_h = nf_conntrack_find_get(net, 0, &master);
 		if (master_h == NULL) {
 			err = -ENOENT;
 			goto err2;
@@ -1347,9 +1347,9 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
 
 	spin_lock_bh(&nf_conntrack_lock);
 	if (cda[CTA_TUPLE_ORIG])
-		h = __nf_conntrack_find(net, &otuple);
+		h = __nf_conntrack_find(net, 0, &otuple);
 	else if (cda[CTA_TUPLE_REPLY])
-		h = __nf_conntrack_find(net, &rtuple);
+		h = __nf_conntrack_find(net, 0, &rtuple);
 
 	if (h == NULL) {
 		err = -ENOENT;
@@ -1678,7 +1678,7 @@ ctnetlink_get_expect(struct sock *ctnl, struct sk_buff *skb,
 	if (err < 0)
 		return err;
 
-	exp = nf_ct_expect_find_get(net, &tuple);
+	exp = nf_ct_expect_find_get(net, 0, &tuple);
 	if (!exp)
 		return -ENOENT;
 
@@ -1734,7 +1734,7 @@ ctnetlink_del_expect(struct sock *ctnl, struct sk_buff *skb,
 			return err;
 
 		/* bump usage count to 2 */
-		exp = nf_ct_expect_find_get(net, &tuple);
+		exp = nf_ct_expect_find_get(net, 0, &tuple);
 		if (!exp)
 			return -ENOENT;
 
@@ -1819,7 +1819,7 @@ ctnetlink_create_expect(struct net *net, const struct nlattr * const cda[],
 		return err;
 
 	/* Look for master conntrack of this expectation */
-	h = nf_conntrack_find_get(net, &master_tuple);
+	h = nf_conntrack_find_get(net, 0, &master_tuple);
 	if (!h)
 		return -ENOENT;
 	ct = nf_ct_tuplehash_to_ctrack(h);
@@ -1876,7 +1876,7 @@ ctnetlink_new_expect(struct sock *ctnl, struct sk_buff *skb,
 		return err;
 
 	spin_lock_bh(&nf_conntrack_lock);
-	exp = __nf_ct_expect_find(net, &tuple);
+	exp = __nf_ct_expect_find(net, 0, &tuple);
 
 	if (!exp) {
 		spin_unlock_bh(&nf_conntrack_lock);
diff --git a/net/netfilter/nf_conntrack_pptp.c b/net/netfilter/nf_conntrack_pptp.c
index 3807ac7..0889448 100644
--- a/net/netfilter/nf_conntrack_pptp.c
+++ b/net/netfilter/nf_conntrack_pptp.c
@@ -28,6 +28,7 @@
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack_helper.h>
+#include <net/netfilter/nf_conntrack_zones.h>
 #include <linux/netfilter/nf_conntrack_proto_gre.h>
 #include <linux/netfilter/nf_conntrack_pptp.h>
 
@@ -123,7 +124,7 @@ static void pptp_expectfn(struct nf_conn *ct,
 		pr_debug("trying to unexpect other dir: ");
 		nf_ct_dump_tuple(&inv_t);
 
-		exp_other = nf_ct_expect_find_get(net, &inv_t);
+		exp_other = nf_ct_expect_find_get(net, nf_ct_zone(ct), &inv_t);
 		if (exp_other) {
 			/* delete other expectation.  */
 			pr_debug("found\n");
@@ -136,17 +137,18 @@ static void pptp_expectfn(struct nf_conn *ct,
 	rcu_read_unlock();
 }
 
-static int destroy_sibling_or_exp(struct net *net,
+static int destroy_sibling_or_exp(struct net *net, struct nf_conn *ct,
 				  const struct nf_conntrack_tuple *t)
 {
 	const struct nf_conntrack_tuple_hash *h;
 	struct nf_conntrack_expect *exp;
 	struct nf_conn *sibling;
+	u16 zone = nf_ct_zone(ct);
 
 	pr_debug("trying to timeout ct or exp for tuple ");
 	nf_ct_dump_tuple(t);
 
-	h = nf_conntrack_find_get(net, t);
+	h = nf_conntrack_find_get(net, zone, t);
 	if (h)  {
 		sibling = nf_ct_tuplehash_to_ctrack(h);
 		pr_debug("setting timeout of conntrack %p to 0\n", sibling);
@@ -157,7 +159,7 @@ static int destroy_sibling_or_exp(struct net *net,
 		nf_ct_put(sibling);
 		return 1;
 	} else {
-		exp = nf_ct_expect_find_get(net, t);
+		exp = nf_ct_expect_find_get(net, zone, t);
 		if (exp) {
 			pr_debug("unexpect_related of expect %p\n", exp);
 			nf_ct_unexpect_related(exp);
@@ -182,7 +184,7 @@ static void pptp_destroy_siblings(struct nf_conn *ct)
 	t.dst.protonum = IPPROTO_GRE;
 	t.src.u.gre.key = help->help.ct_pptp_info.pns_call_id;
 	t.dst.u.gre.key = help->help.ct_pptp_info.pac_call_id;
-	if (!destroy_sibling_or_exp(net, &t))
+	if (!destroy_sibling_or_exp(net, ct, &t))
 		pr_debug("failed to timeout original pns->pac ct/exp\n");
 
 	/* try reply (pac->pns) tuple */
@@ -190,7 +192,7 @@ static void pptp_destroy_siblings(struct nf_conn *ct)
 	t.dst.protonum = IPPROTO_GRE;
 	t.src.u.gre.key = help->help.ct_pptp_info.pac_call_id;
 	t.dst.u.gre.key = help->help.ct_pptp_info.pns_call_id;
-	if (!destroy_sibling_or_exp(net, &t))
+	if (!destroy_sibling_or_exp(net, ct, &t))
 		pr_debug("failed to timeout reply pac->pns ct/exp\n");
 }
 
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 4b57216..3b5efc9 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -22,6 +22,7 @@
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack_expect.h>
 #include <net/netfilter/nf_conntrack_helper.h>
+#include <net/netfilter/nf_conntrack_zones.h>
 #include <linux/netfilter/nf_conntrack_sip.h>
 
 MODULE_LICENSE("GPL");
@@ -777,7 +778,7 @@ static int set_expected_rtp_rtcp(struct sk_buff *skb,
 
 	rcu_read_lock();
 	do {
-		exp = __nf_ct_expect_find(net, &tuple);
+		exp = __nf_ct_expect_find(net, nf_ct_zone(ct), &tuple);
 
 		if (!exp || exp->master == ct ||
 		    nfct_help(exp->master)->helper != nfct_help(ct)->helper ||
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 028aba6..4e7dd4f 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -26,6 +26,7 @@
 #include <net/netfilter/nf_conntrack_expect.h>
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <net/netfilter/nf_conntrack_acct.h>
+#include <net/netfilter/nf_conntrack_zones.h>
 
 MODULE_LICENSE("GPL");
 
@@ -171,6 +172,11 @@ static int ct_seq_show(struct seq_file *s, void *v)
 		goto release;
 #endif
 
+#ifdef CONFIG_NF_CONNTRACK_ZONES
+	if (seq_printf(s, "zone=%u ", nf_ct_zone(ct)))
+		goto release;
+#endif
+
 	if (seq_printf(s, "use=%u\n", atomic_read(&ct->ct_general.use)))
 		goto release;
 
diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
index 55e0713..86a6300 100644
--- a/net/netfilter/xt_CT.c
+++ b/net/netfilter/xt_CT.c
@@ -16,6 +16,7 @@
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <net/netfilter/nf_conntrack_ecache.h>
+#include <net/netfilter/nf_conntrack_zones.h>
 
 static unsigned int xt_ct_target(struct sk_buff *skb,
 				 const struct xt_target_param *par)
@@ -57,11 +58,15 @@ static bool xt_ct_tg_check(const struct xt_tgchk_param *par)
 	struct nf_conn *ct;
 	u8 proto;
 
+#ifndef CONFIG_NF_CONNTRACK_ZONES
+	if (info->zone)
+		goto err1;
+#endif
 	if (nf_ct_l3proto_try_module_get(par->family) < 0)
 		goto err1;
 
 	memset(&t, 0, sizeof(t));
-	ct = nf_conntrack_alloc(par->net, &t, &t, GFP_KERNEL);
+	ct = nf_conntrack_alloc(par->net, info->zone, &t, &t, GFP_KERNEL);
 	if (IS_ERR(ct))
 		goto err2;
 
diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
index 0d9d18e..0c0cebe 100644
--- a/net/netfilter/xt_connlimit.c
+++ b/net/netfilter/xt_connlimit.c
@@ -114,7 +114,7 @@ static int count_them(struct net *net,
 
 	/* check the saved connections */
 	list_for_each_entry_safe(conn, tmp, hash, list) {
-		found    = nf_conntrack_find_get(net, &conn->tuple);
+		found    = nf_conntrack_find_get(net, 0, &conn->tuple);
 		found_ct = NULL;
 
 		if (found != NULL)
