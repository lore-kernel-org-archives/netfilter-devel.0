From: Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH nf-next v2 1/3] netfilter: nf_conntrack: push zone object into functions
Date: Sat, 11 Jul 2015 03:14:05 +0200
Message-ID: <3a45e81237cd8248a025dc772a9dd9ef17c73b1b.1436574843.git.daniel@iogearbox.net>
References: <cover.1436574843.git.daniel@iogearbox.net>
Cc: tgraf@suug.ch, challa@noironetworks.com,
	netfilter-devel@vger.kernel.org,
	Daniel Borkmann <daniel@iogearbox.net>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:41796 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbbGKGNm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 11 Jul 2015 02:13:42 -0400
In-Reply-To: <cover.1436574843.git.daniel@iogearbox.net>
In-Reply-To: <cover.1436574843.git.daniel@iogearbox.net>
References: <cover.1436574843.git.daniel@iogearbox.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch replaces the zone id which is pushed down into functions
with the actual zone object. It's a bigger one-time change, but
needed for later on extending zones with a direction parameter, and
thus decoupling this additional information from all call-sites.

It was suggested during NFWS to let the nf_ct_zone() helper store
the meta data on the stack as we currently do, but in a similar
fashion as skb_header_pointer() does, so we can avoid keeping track
of the object lifetime. In general, dealing directly with the object
also facilitates for adding other possible meta data in future.

No functional changes in this patch.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 include/net/netfilter/nf_conntrack.h           |  6 +-
 include/net/netfilter/nf_conntrack_core.h      |  3 +-
 include/net/netfilter/nf_conntrack_expect.h    | 11 +++-
 include/net/netfilter/nf_conntrack_zones.h     | 44 +++++++++++---
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |  4 +-
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |  3 +-
 net/ipv4/netfilter/nf_defrag_ipv4.c            | 18 +++---
 net/ipv4/netfilter/nf_nat_pptp.c               |  3 +-
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |  3 +-
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |  4 +-
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c      | 19 +++---
 net/netfilter/ipvs/ip_vs_nfct.c                |  5 +-
 net/netfilter/nf_conntrack_core.c              | 74 ++++++++++++++---------
 net/netfilter/nf_conntrack_expect.c            | 22 ++++---
 net/netfilter/nf_conntrack_h323_main.c         |  4 +-
 net/netfilter/nf_conntrack_netlink.c           | 84 ++++++++++++++------------
 net/netfilter/nf_conntrack_pptp.c              |  7 ++-
 net/netfilter/nf_conntrack_sip.c               |  3 +-
 net/netfilter/nf_conntrack_standalone.c        | 19 ++++--
 net/netfilter/nf_nat_core.c                    | 22 ++++---
 net/netfilter/nf_synproxy_core.c               |  6 +-
 net/netfilter/xt_CT.c                          |  5 +-
 net/netfilter/xt_connlimit.c                   | 13 ++--
 net/sched/act_connmark.c                       |  4 +-
 24 files changed, 245 insertions(+), 141 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 095433b..1a6d28c 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -250,8 +250,12 @@ void nf_ct_untracked_status_or(unsigned long bits);
 void nf_ct_iterate_cleanup(struct net *net,
 			   int (*iter)(struct nf_conn *i, void *data),
 			   void *data, u32 portid, int report);
+
+struct nf_conntrack_zone;
+
 void nf_conntrack_free(struct nf_conn *ct);
-struct nf_conn *nf_conntrack_alloc(struct net *net, u16 zone,
+struct nf_conn *nf_conntrack_alloc(struct net *net,
+				   const struct nf_conntrack_zone *zone,
 				   const struct nf_conntrack_tuple *orig,
 				   const struct nf_conntrack_tuple *repl,
 				   gfp_t gfp);
diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index f2f0fa3..c03f9c4 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -52,7 +52,8 @@ bool nf_ct_invert_tuple(struct nf_conntrack_tuple *inverse,
 
 /* Find a connection corresponding to a tuple. */
 struct nf_conntrack_tuple_hash *
-nf_conntrack_find_get(struct net *net, u16 zone,
+nf_conntrack_find_get(struct net *net,
+		      const struct nf_conntrack_zone *zone,
 		      const struct nf_conntrack_tuple *tuple);
 
 int __nf_conntrack_confirm(struct sk_buff *skb);
diff --git a/include/net/netfilter/nf_conntrack_expect.h b/include/net/netfilter/nf_conntrack_expect.h
index 3f3aecb..dce56f0 100644
--- a/include/net/netfilter/nf_conntrack_expect.h
+++ b/include/net/netfilter/nf_conntrack_expect.h
@@ -4,7 +4,9 @@
 
 #ifndef _NF_CONNTRACK_EXPECT_H
 #define _NF_CONNTRACK_EXPECT_H
+
 #include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_zones.h>
 
 extern unsigned int nf_ct_expect_hsize;
 extern unsigned int nf_ct_expect_max;
@@ -76,15 +78,18 @@ int nf_conntrack_expect_init(void);
 void nf_conntrack_expect_fini(void);
 
 struct nf_conntrack_expect *
-__nf_ct_expect_find(struct net *net, u16 zone,
+__nf_ct_expect_find(struct net *net,
+		    const struct nf_conntrack_zone *zone,
 		    const struct nf_conntrack_tuple *tuple);
 
 struct nf_conntrack_expect *
-nf_ct_expect_find_get(struct net *net, u16 zone,
+nf_ct_expect_find_get(struct net *net,
+		      const struct nf_conntrack_zone *zone,
 		      const struct nf_conntrack_tuple *tuple);
 
 struct nf_conntrack_expect *
-nf_ct_find_expectation(struct net *net, u16 zone,
+nf_ct_find_expectation(struct net *net,
+		       const struct nf_conntrack_zone *zone,
 		       const struct nf_conntrack_tuple *tuple);
 
 void nf_ct_unlink_expect_report(struct nf_conntrack_expect *exp,
diff --git a/include/net/netfilter/nf_conntrack_zones.h b/include/net/netfilter/nf_conntrack_zones.h
index 034efe8..f1ea385 100644
--- a/include/net/netfilter/nf_conntrack_zones.h
+++ b/include/net/netfilter/nf_conntrack_zones.h
@@ -3,23 +3,51 @@
 
 #define NF_CT_DEFAULT_ZONE	0
 
-#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
 #include <net/netfilter/nf_conntrack_extend.h>
 
 struct nf_conntrack_zone {
 	u16	id;
 };
 
-static inline u16 nf_ct_zone(const struct nf_conn *ct)
+static __always_inline
+struct nf_conntrack_zone *nf_ct_zone_dflt(struct nf_conntrack_zone *ptr)
 {
+	ptr->id = NF_CT_DEFAULT_ZONE;
+	return ptr;
+}
+
+static __always_inline
+struct nf_conntrack_zone *nf_ct_zone_get(const struct nf_conntrack_zone *zone,
+					 struct nf_conntrack_zone *ptr)
+{
+	ptr->id = zone->id;
+	return ptr;
+}
+
+static inline struct nf_conntrack_zone *
+nf_ct_zone(const struct nf_conn *ct, struct nf_conntrack_zone *ptr)
+{
+	const struct nf_conntrack_zone *zone = NULL;
+
 #ifdef CONFIG_NF_CONNTRACK_ZONES
-	struct nf_conntrack_zone *nf_ct_zone;
-	nf_ct_zone = nf_ct_ext_find(ct, NF_CT_EXT_ZONE);
-	if (nf_ct_zone)
-		return nf_ct_zone->id;
+	zone = nf_ct_ext_find(ct, NF_CT_EXT_ZONE);
 #endif
-	return NF_CT_DEFAULT_ZONE;
+	return zone ? nf_ct_zone_get(zone, ptr) : nf_ct_zone_dflt(ptr);
 }
 
-#endif /* CONFIG_NF_CONNTRACK || CONFIG_NF_CONNTRACK_MODULE */
+static inline struct nf_conntrack_zone *
+nf_ct_zone_tmpl(const struct nf_conn *tmpl, struct nf_conntrack_zone *ptr)
+{
+	return tmpl ? nf_ct_zone(tmpl, ptr) : nf_ct_zone_dflt(ptr);
+}
+
+static inline bool nf_ct_zone_equal(const struct nf_conn *ct_a,
+				    const struct nf_conntrack_zone *b)
+{
+	struct nf_conntrack_zone zone_a, *a = nf_ct_zone(ct_a, &zone_a);
+
+	return a->id == b->id;
+}
+#endif /* IS_ENABLED(CONFIG_NF_CONNTRACK) */
 #endif /* _NF_CONNTRACK_ZONES_H */
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index 30ad955..2501341 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -259,6 +259,7 @@ getorigdst(struct sock *sk, int optval, void __user *user, int *len)
 	const struct inet_sock *inet = inet_sk(sk);
 	const struct nf_conntrack_tuple_hash *h;
 	struct nf_conntrack_tuple tuple;
+	struct nf_conntrack_zone zone;
 
 	memset(&tuple, 0, sizeof(tuple));
 	tuple.src.u3.ip = inet->inet_rcv_saddr;
@@ -280,7 +281,8 @@ getorigdst(struct sock *sk, int optval, void __user *user, int *len)
 		return -EINVAL;
 	}
 
-	h = nf_conntrack_find_get(sock_net(sk), NF_CT_DEFAULT_ZONE, &tuple);
+	h = nf_conntrack_find_get(sock_net(sk), nf_ct_zone_dflt(&zone),
+				  &tuple);
 	if (h) {
 		struct sockaddr_in sin;
 		struct nf_conn *ct = nf_ct_tuplehash_to_ctrack(h);
diff --git a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
index 80d5554..75f7860 100644
--- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
@@ -134,9 +134,10 @@ icmp_error_message(struct net *net, struct nf_conn *tmpl, struct sk_buff *skb,
 	struct nf_conntrack_tuple innertuple, origtuple;
 	const struct nf_conntrack_l4proto *innerproto;
 	const struct nf_conntrack_tuple_hash *h;
-	u16 zone = tmpl ? nf_ct_zone(tmpl) : NF_CT_DEFAULT_ZONE;
+	struct nf_conntrack_zone *zone, __zone;
 
 	NF_CT_ASSERT(skb->nfct == NULL);
+	zone = nf_ct_zone_tmpl(tmpl, &__zone);
 
 	/* Are they talking about one of our connections? */
 	if (!nf_ct_get_tuplepr(skb,
diff --git a/net/ipv4/netfilter/nf_defrag_ipv4.c b/net/ipv4/netfilter/nf_defrag_ipv4.c
index c88b7d4..e63f069 100644
--- a/net/ipv4/netfilter/nf_defrag_ipv4.c
+++ b/net/ipv4/netfilter/nf_defrag_ipv4.c
@@ -43,22 +43,24 @@ static int nf_ct_ipv4_gather_frags(struct sk_buff *skb, u_int32_t user)
 static enum ip_defrag_users nf_ct_defrag_user(unsigned int hooknum,
 					      struct sk_buff *skb)
 {
-	u16 zone = NF_CT_DEFAULT_ZONE;
-
+	u16 zone_id = NF_CT_DEFAULT_ZONE;
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
-	if (skb->nfct)
-		zone = nf_ct_zone((struct nf_conn *)skb->nfct);
-#endif
+	if (skb->nfct) {
+		struct nf_conntrack_zone *zone, __zone;
 
+		zone = nf_ct_zone((struct nf_conn *)skb->nfct, &__zone);
+		zone_id = zone->id;
+	}
+#endif
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
 	if (skb->nf_bridge &&
 	    skb->nf_bridge->mask & BRNF_NF_BRIDGE_PREROUTING)
-		return IP_DEFRAG_CONNTRACK_BRIDGE_IN + zone;
+		return IP_DEFRAG_CONNTRACK_BRIDGE_IN + zone_id;
 #endif
 	if (hooknum == NF_INET_PRE_ROUTING)
-		return IP_DEFRAG_CONNTRACK_IN + zone;
+		return IP_DEFRAG_CONNTRACK_IN + zone_id;
 	else
-		return IP_DEFRAG_CONNTRACK_OUT + zone;
+		return IP_DEFRAG_CONNTRACK_OUT + zone_id;
 }
 
 static unsigned int ipv4_conntrack_defrag(const struct nf_hook_ops *ops,
diff --git a/net/ipv4/netfilter/nf_nat_pptp.c b/net/ipv4/netfilter/nf_nat_pptp.c
index 657d230..fa52705 100644
--- a/net/ipv4/netfilter/nf_nat_pptp.c
+++ b/net/ipv4/netfilter/nf_nat_pptp.c
@@ -48,6 +48,7 @@ static void pptp_nat_expected(struct nf_conn *ct,
 	struct nf_conntrack_tuple t;
 	const struct nf_ct_pptp_master *ct_pptp_info;
 	const struct nf_nat_pptp *nat_pptp_info;
+	struct nf_conntrack_zone zone;
 	struct nf_nat_range range;
 
 	ct_pptp_info = nfct_help_data(master);
@@ -76,7 +77,7 @@ static void pptp_nat_expected(struct nf_conn *ct,
 
 	pr_debug("trying to unexpect other dir: ");
 	nf_ct_dump_tuple_ip(&t);
-	other_exp = nf_ct_expect_find_get(net, nf_ct_zone(ct), &t);
+	other_exp = nf_ct_expect_find_get(net, nf_ct_zone(ct, &zone), &t);
 	if (other_exp) {
 		nf_ct_unexpect_related(other_exp);
 		nf_ct_expect_put(other_exp);
diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index 4ba0c34..10b4b8d 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -235,6 +235,7 @@ ipv6_getorigdst(struct sock *sk, int optval, void __user *user, int *len)
 	const struct inet_sock *inet = inet_sk(sk);
 	const struct ipv6_pinfo *inet6 = inet6_sk(sk);
 	const struct nf_conntrack_tuple_hash *h;
+	struct nf_conntrack_zone zone;
 	struct sockaddr_in6 sin6;
 	struct nf_conntrack_tuple tuple = { .src.l3num = NFPROTO_IPV6 };
 	struct nf_conn *ct;
@@ -251,7 +252,7 @@ ipv6_getorigdst(struct sock *sk, int optval, void __user *user, int *len)
 	if (*len < 0 || (unsigned int) *len < sizeof(sin6))
 		return -EINVAL;
 
-	h = nf_conntrack_find_get(sock_net(sk), NF_CT_DEFAULT_ZONE, &tuple);
+	h = nf_conntrack_find_get(sock_net(sk), nf_ct_zone_dflt(&zone), &tuple);
 	if (!h) {
 		pr_debug("IP6T_SO_ORIGINAL_DST: Can't find %pI6c/%u-%pI6c/%u.\n",
 			 &tuple.src.u3.ip6, ntohs(tuple.src.u.tcp.port),
diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
index 90388d6..d5ad71f 100644
--- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
@@ -150,7 +150,7 @@ icmpv6_error_message(struct net *net, struct nf_conn *tmpl,
 	struct nf_conntrack_tuple intuple, origtuple;
 	const struct nf_conntrack_tuple_hash *h;
 	const struct nf_conntrack_l4proto *inproto;
-	u16 zone = tmpl ? nf_ct_zone(tmpl) : NF_CT_DEFAULT_ZONE;
+	struct nf_conntrack_zone zone;
 
 	NF_CT_ASSERT(skb->nfct == NULL);
 
@@ -177,7 +177,7 @@ icmpv6_error_message(struct net *net, struct nf_conn *tmpl,
 
 	*ctinfo = IP_CT_RELATED;
 
-	h = nf_conntrack_find_get(net, zone, &intuple);
+	h = nf_conntrack_find_get(net, nf_ct_zone_tmpl(tmpl, &zone), &intuple);
 	if (!h) {
 		pr_debug("icmpv6_error: no match\n");
 		return -NF_ACCEPT;
diff --git a/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c b/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
index a45db0b..16f0b1f 100644
--- a/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
+++ b/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
@@ -33,23 +33,24 @@
 static enum ip6_defrag_users nf_ct6_defrag_user(unsigned int hooknum,
 						struct sk_buff *skb)
 {
-	u16 zone = NF_CT_DEFAULT_ZONE;
-
+	u16 zone_id = NF_CT_DEFAULT_ZONE;
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
-	if (skb->nfct)
-		zone = nf_ct_zone((struct nf_conn *)skb->nfct);
-#endif
+	if (skb->nfct) {
+		struct nf_conntrack_zone *zone, __zone;
 
+		zone = nf_ct_zone((struct nf_conn *)skb->nfct, &__zone);
+		zone_id = zone->id;
+	}
+#endif
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
 	if (skb->nf_bridge &&
 	    skb->nf_bridge->mask & BRNF_NF_BRIDGE_PREROUTING)
-		return IP6_DEFRAG_CONNTRACK_BRIDGE_IN + zone;
+		return IP6_DEFRAG_CONNTRACK_BRIDGE_IN + zone_id;
 #endif
 	if (hooknum == NF_INET_PRE_ROUTING)
-		return IP6_DEFRAG_CONNTRACK_IN + zone;
+		return IP6_DEFRAG_CONNTRACK_IN + zone_id;
 	else
-		return IP6_DEFRAG_CONNTRACK_OUT + zone;
-
+		return IP6_DEFRAG_CONNTRACK_OUT + zone_id;
 }
 
 static unsigned int ipv6_defrag(const struct nf_hook_ops *ops,
diff --git a/net/netfilter/ipvs/ip_vs_nfct.c b/net/netfilter/ipvs/ip_vs_nfct.c
index 5882bbf..98d6b5b 100644
--- a/net/netfilter/ipvs/ip_vs_nfct.c
+++ b/net/netfilter/ipvs/ip_vs_nfct.c
@@ -256,8 +256,9 @@ EXPORT_SYMBOL(ip_vs_nfct_expect_related);
 void ip_vs_conn_drop_conntrack(struct ip_vs_conn *cp)
 {
 	struct nf_conntrack_tuple_hash *h;
-	struct nf_conn *ct;
 	struct nf_conntrack_tuple tuple;
+	struct nf_conntrack_zone zone;
+	struct nf_conn *ct;
 
 	if (!cp->cport)
 		return;
@@ -274,7 +275,7 @@ void ip_vs_conn_drop_conntrack(struct ip_vs_conn *cp)
 		" for conn " FMT_CONN "\n",
 		__func__, ARG_TUPLE(&tuple), ARG_CONN(cp));
 
-	h = nf_conntrack_find_get(ip_vs_conn_net(cp), NF_CT_DEFAULT_ZONE,
+	h = nf_conntrack_find_get(ip_vs_conn_net(cp), nf_ct_zone_dflt(&zone),
 				  &tuple);
 	if (h) {
 		ct = nf_ct_tuplehash_to_ctrack(h);
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 13fad86..f4274f9 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -126,7 +126,8 @@ EXPORT_PER_CPU_SYMBOL(nf_conntrack_untracked);
 unsigned int nf_conntrack_hash_rnd __read_mostly;
 EXPORT_SYMBOL_GPL(nf_conntrack_hash_rnd);
 
-static u32 hash_conntrack_raw(const struct nf_conntrack_tuple *tuple, u16 zone)
+static u32 hash_conntrack_raw(const struct nf_conntrack_tuple *tuple,
+			      const struct nf_conntrack_zone *zone)
 {
 	unsigned int n;
 
@@ -135,7 +136,7 @@ static u32 hash_conntrack_raw(const struct nf_conntrack_tuple *tuple, u16 zone)
 	 * three bytes manually.
 	 */
 	n = (sizeof(tuple->src) + sizeof(tuple->dst.u3)) / sizeof(u32);
-	return jhash2((u32 *)tuple, n, zone ^ nf_conntrack_hash_rnd ^
+	return jhash2((u32 *)tuple, n, zone->id ^ nf_conntrack_hash_rnd ^
 		      (((__force __u16)tuple->dst.u.all << 16) |
 		      tuple->dst.protonum));
 }
@@ -151,12 +152,14 @@ static u32 hash_bucket(u32 hash, const struct net *net)
 }
 
 static u_int32_t __hash_conntrack(const struct nf_conntrack_tuple *tuple,
-				  u16 zone, unsigned int size)
+				  const struct nf_conntrack_zone *zone,
+				  unsigned int size)
 {
 	return __hash_bucket(hash_conntrack_raw(tuple, zone), size);
 }
 
-static inline u_int32_t hash_conntrack(const struct net *net, u16 zone,
+static inline u_int32_t hash_conntrack(const struct net *net,
+				       const struct nf_conntrack_zone *zone,
 				       const struct nf_conntrack_tuple *tuple)
 {
 	return __hash_conntrack(tuple, zone, net->ct.htable_size);
@@ -327,11 +330,12 @@ destroy_conntrack(struct nf_conntrack *nfct)
 
 static void nf_ct_delete_from_lists(struct nf_conn *ct)
 {
+	struct nf_conntrack_zone *zone, __zone;
 	struct net *net = nf_ct_net(ct);
 	unsigned int hash, reply_hash;
-	u16 zone = nf_ct_zone(ct);
 	unsigned int sequence;
 
+	zone = nf_ct_zone(ct, &__zone);
 	nf_ct_helper_destroy(ct);
 
 	local_bh_disable();
@@ -387,8 +391,8 @@ static void death_by_timeout(unsigned long ul_conntrack)
 
 static inline bool
 nf_ct_key_equal(struct nf_conntrack_tuple_hash *h,
-			const struct nf_conntrack_tuple *tuple,
-			u16 zone)
+		const struct nf_conntrack_tuple *tuple,
+		const struct nf_conntrack_zone *zone)
 {
 	struct nf_conn *ct = nf_ct_tuplehash_to_ctrack(h);
 
@@ -396,8 +400,8 @@ nf_ct_key_equal(struct nf_conntrack_tuple_hash *h,
 	 * so we need to check that the conntrack is confirmed
 	 */
 	return nf_ct_tuple_equal(tuple, &h->tuple) &&
-		nf_ct_zone(ct) == zone &&
-		nf_ct_is_confirmed(ct);
+	       nf_ct_zone_equal(ct, zone) &&
+	       nf_ct_is_confirmed(ct);
 }
 
 /*
@@ -406,7 +410,7 @@ nf_ct_key_equal(struct nf_conntrack_tuple_hash *h,
  *   and recheck nf_ct_tuple_equal(tuple, &h->tuple)
  */
 static struct nf_conntrack_tuple_hash *
-____nf_conntrack_find(struct net *net, u16 zone,
+____nf_conntrack_find(struct net *net, const struct nf_conntrack_zone *zone,
 		      const struct nf_conntrack_tuple *tuple, u32 hash)
 {
 	struct nf_conntrack_tuple_hash *h;
@@ -442,7 +446,7 @@ begin:
 
 /* Find a connection corresponding to a tuple. */
 static struct nf_conntrack_tuple_hash *
-__nf_conntrack_find_get(struct net *net, u16 zone,
+__nf_conntrack_find_get(struct net *net, const struct nf_conntrack_zone *zone,
 			const struct nf_conntrack_tuple *tuple, u32 hash)
 {
 	struct nf_conntrack_tuple_hash *h;
@@ -469,7 +473,7 @@ begin:
 }
 
 struct nf_conntrack_tuple_hash *
-nf_conntrack_find_get(struct net *net, u16 zone,
+nf_conntrack_find_get(struct net *net, const struct nf_conntrack_zone *zone,
 		      const struct nf_conntrack_tuple *tuple)
 {
 	return __nf_conntrack_find_get(net, zone, tuple,
@@ -492,16 +496,16 @@ static void __nf_conntrack_hash_insert(struct nf_conn *ct,
 int
 nf_conntrack_hash_check_insert(struct nf_conn *ct)
 {
+	struct nf_conntrack_zone *zone, __zone;
 	struct net *net = nf_ct_net(ct);
 	unsigned int hash, reply_hash;
 	struct nf_conntrack_tuple_hash *h;
 	struct hlist_nulls_node *n;
-	u16 zone;
 	unsigned int sequence;
 
-	zone = nf_ct_zone(ct);
-
+	zone = nf_ct_zone(ct, &__zone);
 	local_bh_disable();
+
 	do {
 		sequence = read_seqcount_begin(&net->ct.generation);
 		hash = hash_conntrack(net, zone,
@@ -514,12 +518,12 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
 	hlist_nulls_for_each_entry(h, n, &net->ct.hash[hash], hnnode)
 		if (nf_ct_tuple_equal(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
 				      &h->tuple) &&
-		    zone == nf_ct_zone(nf_ct_tuplehash_to_ctrack(h)))
+		    nf_ct_zone_equal(nf_ct_tuplehash_to_ctrack(h), zone))
 			goto out;
 	hlist_nulls_for_each_entry(h, n, &net->ct.hash[reply_hash], hnnode)
 		if (nf_ct_tuple_equal(&ct->tuplehash[IP_CT_DIR_REPLY].tuple,
 				      &h->tuple) &&
-		    zone == nf_ct_zone(nf_ct_tuplehash_to_ctrack(h)))
+		    nf_ct_zone_equal(nf_ct_tuplehash_to_ctrack(h), zone))
 			goto out;
 
 	add_timer(&ct->timeout);
@@ -566,6 +570,7 @@ EXPORT_SYMBOL_GPL(nf_conntrack_tmpl_insert);
 int
 __nf_conntrack_confirm(struct sk_buff *skb)
 {
+	struct nf_conntrack_zone *zone, __zone;
 	unsigned int hash, reply_hash;
 	struct nf_conntrack_tuple_hash *h;
 	struct nf_conn *ct;
@@ -574,7 +579,6 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 	struct hlist_nulls_node *n;
 	enum ip_conntrack_info ctinfo;
 	struct net *net;
-	u16 zone;
 	unsigned int sequence;
 
 	ct = nf_ct_get(skb, &ctinfo);
@@ -587,7 +591,7 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 	if (CTINFO2DIR(ctinfo) != IP_CT_DIR_ORIGINAL)
 		return NF_ACCEPT;
 
-	zone = nf_ct_zone(ct);
+	zone = nf_ct_zone(ct, &__zone);
 	local_bh_disable();
 
 	do {
@@ -627,12 +631,12 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 	hlist_nulls_for_each_entry(h, n, &net->ct.hash[hash], hnnode)
 		if (nf_ct_tuple_equal(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
 				      &h->tuple) &&
-		    zone == nf_ct_zone(nf_ct_tuplehash_to_ctrack(h)))
+		    nf_ct_zone_equal(nf_ct_tuplehash_to_ctrack(h), zone))
 			goto out;
 	hlist_nulls_for_each_entry(h, n, &net->ct.hash[reply_hash], hnnode)
 		if (nf_ct_tuple_equal(&ct->tuplehash[IP_CT_DIR_REPLY].tuple,
 				      &h->tuple) &&
-		    zone == nf_ct_zone(nf_ct_tuplehash_to_ctrack(h)))
+		    nf_ct_zone_equal(nf_ct_tuplehash_to_ctrack(h), zone))
 			goto out;
 
 	/* Timer relative to confirmation time, not original
@@ -685,11 +689,14 @@ nf_conntrack_tuple_taken(const struct nf_conntrack_tuple *tuple,
 			 const struct nf_conn *ignored_conntrack)
 {
 	struct net *net = nf_ct_net(ignored_conntrack);
+	struct nf_conntrack_zone *zone, __zone;
 	struct nf_conntrack_tuple_hash *h;
 	struct hlist_nulls_node *n;
 	struct nf_conn *ct;
-	u16 zone = nf_ct_zone(ignored_conntrack);
-	unsigned int hash = hash_conntrack(net, zone, tuple);
+	unsigned int hash;
+
+	zone = nf_ct_zone(ignored_conntrack, &__zone);
+	hash = hash_conntrack(net, zone, tuple);
 
 	/* Disable BHs the entire time since we need to disable them at
 	 * least once for the stats anyway.
@@ -699,7 +706,7 @@ nf_conntrack_tuple_taken(const struct nf_conntrack_tuple *tuple,
 		ct = nf_ct_tuplehash_to_ctrack(h);
 		if (ct != ignored_conntrack &&
 		    nf_ct_tuple_equal(tuple, &h->tuple) &&
-		    nf_ct_zone(ct) == zone) {
+		    nf_ct_zone_equal(ct, zone)) {
 			NF_CT_STAT_INC(net, found);
 			rcu_read_unlock_bh();
 			return 1;
@@ -788,7 +795,8 @@ void init_nf_conntrack_hash_rnd(void)
 }
 
 static struct nf_conn *
-__nf_conntrack_alloc(struct net *net, u16 zone,
+__nf_conntrack_alloc(struct net *net,
+		     const struct nf_conntrack_zone *zone,
 		     const struct nf_conntrack_tuple *orig,
 		     const struct nf_conntrack_tuple *repl,
 		     gfp_t gfp, u32 hash)
@@ -842,7 +850,7 @@ __nf_conntrack_alloc(struct net *net, u16 zone,
 		nf_ct_zone = nf_ct_ext_add(ct, NF_CT_EXT_ZONE, GFP_ATOMIC);
 		if (!nf_ct_zone)
 			goto out_free;
-		nf_ct_zone->id = zone;
+		nf_ct_zone->id = zone->id;
 	}
 #endif
 	/* Because we use RCU lookups, we set ct_general.use to zero before
@@ -859,7 +867,8 @@ out_free:
 #endif
 }
 
-struct nf_conn *nf_conntrack_alloc(struct net *net, u16 zone,
+struct nf_conn *nf_conntrack_alloc(struct net *net,
+				   const struct nf_conntrack_zone *zone,
 				   const struct nf_conntrack_tuple *orig,
 				   const struct nf_conntrack_tuple *repl,
 				   gfp_t gfp)
@@ -901,7 +910,7 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
 	struct nf_conntrack_tuple repl_tuple;
 	struct nf_conntrack_ecache *ecache;
 	struct nf_conntrack_expect *exp = NULL;
-	u16 zone = tmpl ? nf_ct_zone(tmpl) : NF_CT_DEFAULT_ZONE;
+	struct nf_conntrack_zone *zone, __zone;
 	struct nf_conn_timeout *timeout_ext;
 	unsigned int *timeouts;
 
@@ -910,6 +919,7 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
 		return NULL;
 	}
 
+	zone = nf_ct_zone_tmpl(tmpl, &__zone);
 	ct = __nf_conntrack_alloc(net, zone, tuple, &repl_tuple, GFP_ATOMIC,
 				  hash);
 	if (IS_ERR(ct))
@@ -1004,10 +1014,10 @@ resolve_normal_ct(struct net *net, struct nf_conn *tmpl,
 		  int *set_reply,
 		  enum ip_conntrack_info *ctinfo)
 {
+	struct nf_conntrack_zone *zone, __zone;
 	struct nf_conntrack_tuple tuple;
 	struct nf_conntrack_tuple_hash *h;
 	struct nf_conn *ct;
-	u16 zone = tmpl ? nf_ct_zone(tmpl) : NF_CT_DEFAULT_ZONE;
 	u32 hash;
 
 	if (!nf_ct_get_tuple(skb, skb_network_offset(skb),
@@ -1018,6 +1028,7 @@ resolve_normal_ct(struct net *net, struct nf_conn *tmpl,
 	}
 
 	/* look for tuple match */
+	zone = nf_ct_zone_tmpl(tmpl, &__zone);
 	hash = hash_conntrack_raw(&tuple, zone);
 	h = __nf_conntrack_find_get(net, zone, &tuple, hash);
 	if (!h) {
@@ -1572,11 +1583,14 @@ int nf_conntrack_set_hashsize(const char *val, struct kernel_param *kp)
 
 	for (i = 0; i < init_net.ct.htable_size; i++) {
 		while (!hlist_nulls_empty(&init_net.ct.hash[i])) {
+			struct nf_conntrack_zone zone;
+
 			h = hlist_nulls_entry(init_net.ct.hash[i].first,
 					struct nf_conntrack_tuple_hash, hnnode);
+
 			ct = nf_ct_tuplehash_to_ctrack(h);
 			hlist_nulls_del_rcu(&h->hnnode);
-			bucket = __hash_conntrack(&h->tuple, nf_ct_zone(ct),
+			bucket = __hash_conntrack(&h->tuple, nf_ct_zone(ct, &zone),
 						  hashsize);
 			hlist_nulls_add_head_rcu(&h->hnnode, &hash[bucket]);
 		}
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 7a17070..1cc3074 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -88,7 +88,8 @@ static unsigned int nf_ct_expect_dst_hash(const struct nf_conntrack_tuple *tuple
 }
 
 struct nf_conntrack_expect *
-__nf_ct_expect_find(struct net *net, u16 zone,
+__nf_ct_expect_find(struct net *net,
+		    const struct nf_conntrack_zone *zone,
 		    const struct nf_conntrack_tuple *tuple)
 {
 	struct nf_conntrack_expect *i;
@@ -100,16 +101,18 @@ __nf_ct_expect_find(struct net *net, u16 zone,
 	h = nf_ct_expect_dst_hash(tuple);
 	hlist_for_each_entry_rcu(i, &net->ct.expect_hash[h], hnode) {
 		if (nf_ct_tuple_mask_cmp(tuple, &i->tuple, &i->mask) &&
-		    nf_ct_zone(i->master) == zone)
+		    nf_ct_zone_equal(i->master, zone))
 			return i;
 	}
+
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(__nf_ct_expect_find);
 
 /* Just find a expectation corresponding to a tuple. */
 struct nf_conntrack_expect *
-nf_ct_expect_find_get(struct net *net, u16 zone,
+nf_ct_expect_find_get(struct net *net,
+		      const struct nf_conntrack_zone *zone,
 		      const struct nf_conntrack_tuple *tuple)
 {
 	struct nf_conntrack_expect *i;
@@ -127,7 +130,8 @@ EXPORT_SYMBOL_GPL(nf_ct_expect_find_get);
 /* If an expectation for this connection is found, it gets delete from
  * global list then returned. */
 struct nf_conntrack_expect *
-nf_ct_find_expectation(struct net *net, u16 zone,
+nf_ct_find_expectation(struct net *net,
+		       const struct nf_conntrack_zone *zone,
 		       const struct nf_conntrack_tuple *tuple)
 {
 	struct nf_conntrack_expect *i, *exp = NULL;
@@ -140,7 +144,7 @@ nf_ct_find_expectation(struct net *net, u16 zone,
 	hlist_for_each_entry(i, &net->ct.expect_hash[h], hnode) {
 		if (!(i->flags & NF_CT_EXPECT_INACTIVE) &&
 		    nf_ct_tuple_mask_cmp(tuple, &i->tuple, &i->mask) &&
-		    nf_ct_zone(i->master) == zone) {
+		    nf_ct_zone_equal(i->master, zone)) {
 			exp = i;
 			break;
 		}
@@ -225,10 +229,12 @@ static inline int expect_clash(const struct nf_conntrack_expect *a,
 static inline int expect_matches(const struct nf_conntrack_expect *a,
 				 const struct nf_conntrack_expect *b)
 {
+	struct nf_conntrack_zone b_zone;
+
 	return a->master == b->master && a->class == b->class &&
-		nf_ct_tuple_equal(&a->tuple, &b->tuple) &&
-		nf_ct_tuple_mask_equal(&a->mask, &b->mask) &&
-		nf_ct_zone(a->master) == nf_ct_zone(b->master);
+	       nf_ct_tuple_equal(&a->tuple, &b->tuple) &&
+	       nf_ct_tuple_mask_equal(&a->mask, &b->mask) &&
+	       nf_ct_zone_equal(a->master, nf_ct_zone(b->master, &b_zone));
 }
 
 /* Generally a bad idea to call this: could have matched already. */
diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
index 9511af0..33c3cca 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -1259,6 +1259,7 @@ static struct nf_conntrack_expect *find_expect(struct nf_conn *ct,
 	struct net *net = nf_ct_net(ct);
 	struct nf_conntrack_expect *exp;
 	struct nf_conntrack_tuple tuple;
+	struct nf_conntrack_zone zone;
 
 	memset(&tuple.src.u3, 0, sizeof(tuple.src.u3));
 	tuple.src.u.tcp.port = 0;
@@ -1266,9 +1267,10 @@ static struct nf_conntrack_expect *find_expect(struct nf_conn *ct,
 	tuple.dst.u.tcp.port = port;
 	tuple.dst.protonum = IPPROTO_TCP;
 
-	exp = __nf_ct_expect_find(net, nf_ct_zone(ct), &tuple);
+	exp = __nf_ct_expect_find(net, nf_ct_zone(ct, &zone), &tuple);
 	if (exp && exp->master == ct)
 		return exp;
+
 	return NULL;
 }
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index d1c2394..2458daa 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -458,6 +458,7 @@ static int
 ctnetlink_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 		    struct nf_conn *ct)
 {
+	struct nf_conntrack_zone *zone, __zone;
 	struct nlmsghdr *nlh;
 	struct nfgenmsg *nfmsg;
 	struct nlattr *nest_parms;
@@ -487,8 +488,9 @@ ctnetlink_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 		goto nla_put_failure;
 	nla_nest_end(skb, nest_parms);
 
-	if (nf_ct_zone(ct) &&
-	    nla_put_be16(skb, CTA_ZONE, htons(nf_ct_zone(ct))))
+	zone = nf_ct_zone(ct, &__zone);
+	if (zone->id != NF_CT_DEFAULT_ZONE &&
+	    nla_put_be16(skb, CTA_ZONE, htons(zone->id)))
 		goto nla_put_failure;
 
 	if (ctnetlink_dump_status(skb, ct) < 0 ||
@@ -609,6 +611,7 @@ ctnetlink_nlmsg_size(const struct nf_conn *ct)
 static int
 ctnetlink_conntrack_event(unsigned int events, struct nf_ct_event *item)
 {
+	struct nf_conntrack_zone *zone, __zone;
 	struct net *net;
 	struct nlmsghdr *nlh;
 	struct nfgenmsg *nfmsg;
@@ -669,8 +672,9 @@ ctnetlink_conntrack_event(unsigned int events, struct nf_ct_event *item)
 		goto nla_put_failure;
 	nla_nest_end(skb, nest_parms);
 
-	if (nf_ct_zone(ct) &&
-	    nla_put_be16(skb, CTA_ZONE, htons(nf_ct_zone(ct))))
+	zone = nf_ct_zone(ct, &__zone);
+	if (zone->id != NF_CT_DEFAULT_ZONE &&
+	    nla_put_be16(skb, CTA_ZONE, htons(zone->id)))
 		goto nla_put_failure;
 
 	if (ctnetlink_dump_id(skb, ct) < 0)
@@ -965,17 +969,18 @@ ctnetlink_parse_tuple(const struct nlattr * const cda[],
 }
 
 static int
-ctnetlink_parse_zone(const struct nlattr *attr, u16 *zone)
+ctnetlink_parse_zone(const struct nlattr *attr,
+		     struct nf_conntrack_zone *zone)
 {
-	if (attr)
+	zone->id = NF_CT_DEFAULT_ZONE;
+
 #ifdef CONFIG_NF_CONNTRACK_ZONES
-		*zone = ntohs(nla_get_be16(attr));
+	if (attr)
+		zone->id = ntohs(nla_get_be16(attr));
 #else
+	if (attr)
 		return -EOPNOTSUPP;
 #endif
-	else
-		*zone = 0;
-
 	return 0;
 }
 
@@ -1058,7 +1063,7 @@ ctnetlink_del_conntrack(struct sock *ctnl, struct sk_buff *skb,
 	struct nf_conn *ct;
 	struct nfgenmsg *nfmsg = nlmsg_data(nlh);
 	u_int8_t u3 = nfmsg->nfgen_family;
-	u16 zone;
+	struct nf_conntrack_zone zone;
 	int err;
 
 	err = ctnetlink_parse_zone(cda[CTA_ZONE], &zone);
@@ -1078,7 +1083,7 @@ ctnetlink_del_conntrack(struct sock *ctnl, struct sk_buff *skb,
 	if (err < 0)
 		return err;
 
-	h = nf_conntrack_find_get(net, zone, &tuple);
+	h = nf_conntrack_find_get(net, &zone, &tuple);
 	if (!h)
 		return -ENOENT;
 
@@ -1112,7 +1117,7 @@ ctnetlink_get_conntrack(struct sock *ctnl, struct sk_buff *skb,
 	struct sk_buff *skb2 = NULL;
 	struct nfgenmsg *nfmsg = nlmsg_data(nlh);
 	u_int8_t u3 = nfmsg->nfgen_family;
-	u16 zone;
+	struct nf_conntrack_zone zone;
 	int err;
 
 	if (nlh->nlmsg_flags & NLM_F_DUMP) {
@@ -1147,7 +1152,7 @@ ctnetlink_get_conntrack(struct sock *ctnl, struct sk_buff *skb,
 	if (err < 0)
 		return err;
 
-	h = nf_conntrack_find_get(net, zone, &tuple);
+	h = nf_conntrack_find_get(net, &zone, &tuple);
 	if (!h)
 		return -ENOENT;
 
@@ -1645,7 +1650,8 @@ ctnetlink_change_conntrack(struct nf_conn *ct,
 }
 
 static struct nf_conn *
-ctnetlink_create_conntrack(struct net *net, u16 zone,
+ctnetlink_create_conntrack(struct net *net,
+			   const struct nf_conntrack_zone *zone,
 			   const struct nlattr * const cda[],
 			   struct nf_conntrack_tuple *otuple,
 			   struct nf_conntrack_tuple *rtuple,
@@ -1804,7 +1810,7 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
 	struct nfgenmsg *nfmsg = nlmsg_data(nlh);
 	struct nf_conn *ct;
 	u_int8_t u3 = nfmsg->nfgen_family;
-	u16 zone;
+	struct nf_conntrack_zone zone;
 	int err;
 
 	err = ctnetlink_parse_zone(cda[CTA_ZONE], &zone);
@@ -1824,9 +1830,9 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
 	}
 
 	if (cda[CTA_TUPLE_ORIG])
-		h = nf_conntrack_find_get(net, zone, &otuple);
+		h = nf_conntrack_find_get(net, &zone, &otuple);
 	else if (cda[CTA_TUPLE_REPLY])
-		h = nf_conntrack_find_get(net, zone, &rtuple);
+		h = nf_conntrack_find_get(net, &zone, &rtuple);
 
 	if (h == NULL) {
 		err = -ENOENT;
@@ -1836,7 +1842,7 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
 			if (!cda[CTA_TUPLE_ORIG] || !cda[CTA_TUPLE_REPLY])
 				return -EINVAL;
 
-			ct = ctnetlink_create_conntrack(net, zone, cda, &otuple,
+			ct = ctnetlink_create_conntrack(net, &zone, cda, &otuple,
 							&rtuple, u3);
 			if (IS_ERR(ct))
 				return PTR_ERR(ct);
@@ -2091,6 +2097,7 @@ ctnetlink_nfqueue_build_size(const struct nf_conn *ct)
 static int
 ctnetlink_nfqueue_build(struct sk_buff *skb, struct nf_conn *ct)
 {
+	struct nf_conntrack_zone *zone, __zone;
 	struct nlattr *nest_parms;
 
 	rcu_read_lock();
@@ -2108,10 +2115,10 @@ ctnetlink_nfqueue_build(struct sk_buff *skb, struct nf_conn *ct)
 		goto nla_put_failure;
 	nla_nest_end(skb, nest_parms);
 
-	if (nf_ct_zone(ct)) {
-		if (nla_put_be16(skb, CTA_ZONE, htons(nf_ct_zone(ct))))
-			goto nla_put_failure;
-	}
+	zone = nf_ct_zone(ct, &__zone);
+	if (zone->id != NF_CT_DEFAULT_ZONE &&
+	    nla_put_be16(skb, CTA_ZONE, htons(zone->id)))
+		goto nla_put_failure;
 
 	if (ctnetlink_dump_id(skb, ct) < 0)
 		goto nla_put_failure;
@@ -2612,7 +2619,7 @@ static int ctnetlink_dump_exp_ct(struct sock *ctnl, struct sk_buff *skb,
 	struct nf_conntrack_tuple tuple;
 	struct nf_conntrack_tuple_hash *h;
 	struct nf_conn *ct;
-	u16 zone = 0;
+	struct nf_conntrack_zone zone;
 	struct netlink_dump_control c = {
 		.dump = ctnetlink_exp_ct_dump_table,
 		.done = ctnetlink_exp_done,
@@ -2622,13 +2629,11 @@ static int ctnetlink_dump_exp_ct(struct sock *ctnl, struct sk_buff *skb,
 	if (err < 0)
 		return err;
 
-	if (cda[CTA_EXPECT_ZONE]) {
-		err = ctnetlink_parse_zone(cda[CTA_EXPECT_ZONE], &zone);
-		if (err < 0)
-			return err;
-	}
+	err = ctnetlink_parse_zone(cda[CTA_EXPECT_ZONE], &zone);
+	if (err < 0)
+		return err;
 
-	h = nf_conntrack_find_get(net, zone, &tuple);
+	h = nf_conntrack_find_get(net, &zone, &tuple);
 	if (!h)
 		return -ENOENT;
 
@@ -2652,7 +2657,7 @@ ctnetlink_get_expect(struct sock *ctnl, struct sk_buff *skb,
 	struct sk_buff *skb2;
 	struct nfgenmsg *nfmsg = nlmsg_data(nlh);
 	u_int8_t u3 = nfmsg->nfgen_family;
-	u16 zone;
+	struct nf_conntrack_zone zone;
 	int err;
 
 	if (nlh->nlmsg_flags & NLM_F_DUMP) {
@@ -2681,7 +2686,7 @@ ctnetlink_get_expect(struct sock *ctnl, struct sk_buff *skb,
 	if (err < 0)
 		return err;
 
-	exp = nf_ct_expect_find_get(net, zone, &tuple);
+	exp = nf_ct_expect_find_get(net, &zone, &tuple);
 	if (!exp)
 		return -ENOENT;
 
@@ -2732,8 +2737,8 @@ ctnetlink_del_expect(struct sock *ctnl, struct sk_buff *skb,
 	struct nfgenmsg *nfmsg = nlmsg_data(nlh);
 	struct hlist_node *next;
 	u_int8_t u3 = nfmsg->nfgen_family;
+	struct nf_conntrack_zone zone;
 	unsigned int i;
-	u16 zone;
 	int err;
 
 	if (cda[CTA_EXPECT_TUPLE]) {
@@ -2747,7 +2752,7 @@ ctnetlink_del_expect(struct sock *ctnl, struct sk_buff *skb,
 			return err;
 
 		/* bump usage count to 2 */
-		exp = nf_ct_expect_find_get(net, zone, &tuple);
+		exp = nf_ct_expect_find_get(net, &zone, &tuple);
 		if (!exp)
 			return -ENOENT;
 
@@ -2937,7 +2942,8 @@ err_out:
 }
 
 static int
-ctnetlink_create_expect(struct net *net, u16 zone,
+ctnetlink_create_expect(struct net *net,
+			const struct nf_conntrack_zone *zone,
 			const struct nlattr * const cda[],
 			u_int8_t u3, u32 portid, int report)
 {
@@ -3016,7 +3022,7 @@ ctnetlink_new_expect(struct sock *ctnl, struct sk_buff *skb,
 	struct nf_conntrack_expect *exp;
 	struct nfgenmsg *nfmsg = nlmsg_data(nlh);
 	u_int8_t u3 = nfmsg->nfgen_family;
-	u16 zone;
+	struct nf_conntrack_zone zone;
 	int err;
 
 	if (!cda[CTA_EXPECT_TUPLE]
@@ -3033,14 +3039,12 @@ ctnetlink_new_expect(struct sock *ctnl, struct sk_buff *skb,
 		return err;
 
 	spin_lock_bh(&nf_conntrack_expect_lock);
-	exp = __nf_ct_expect_find(net, zone, &tuple);
-
+	exp = __nf_ct_expect_find(net, &zone, &tuple);
 	if (!exp) {
 		spin_unlock_bh(&nf_conntrack_expect_lock);
 		err = -ENOENT;
 		if (nlh->nlmsg_flags & NLM_F_CREATE) {
-			err = ctnetlink_create_expect(net, zone, cda,
-						      u3,
+			err = ctnetlink_create_expect(net, &zone, cda, u3,
 						      NETLINK_CB(skb).portid,
 						      nlmsg_report(nlh));
 		}
diff --git a/net/netfilter/nf_conntrack_pptp.c b/net/netfilter/nf_conntrack_pptp.c
index 825c3e3..36fa572 100644
--- a/net/netfilter/nf_conntrack_pptp.c
+++ b/net/netfilter/nf_conntrack_pptp.c
@@ -120,13 +120,15 @@ static void pptp_expectfn(struct nf_conn *ct,
 	else {
 		struct nf_conntrack_tuple inv_t;
 		struct nf_conntrack_expect *exp_other;
+		struct nf_conntrack_zone zone;
 
 		/* obviously this tuple inversion only works until you do NAT */
 		nf_ct_invert_tuplepr(&inv_t, &exp->tuple);
 		pr_debug("trying to unexpect other dir: ");
 		nf_ct_dump_tuple(&inv_t);
 
-		exp_other = nf_ct_expect_find_get(net, nf_ct_zone(ct), &inv_t);
+		exp_other = nf_ct_expect_find_get(net, nf_ct_zone(ct, &zone),
+						  &inv_t);
 		if (exp_other) {
 			/* delete other expectation.  */
 			pr_debug("found\n");
@@ -143,13 +145,14 @@ static int destroy_sibling_or_exp(struct net *net, struct nf_conn *ct,
 				  const struct nf_conntrack_tuple *t)
 {
 	const struct nf_conntrack_tuple_hash *h;
+	struct nf_conntrack_zone *zone, __zone;
 	struct nf_conntrack_expect *exp;
 	struct nf_conn *sibling;
-	u16 zone = nf_ct_zone(ct);
 
 	pr_debug("trying to timeout ct or exp for tuple ");
 	nf_ct_dump_tuple(t);
 
+	zone = nf_ct_zone(ct, &__zone);
 	h = nf_conntrack_find_get(net, zone, t);
 	if (h)  {
 		sibling = nf_ct_tuplehash_to_ctrack(h);
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 885b4ab..525a8c5 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -888,8 +888,9 @@ static int set_expected_rtp_rtcp(struct sk_buff *skb, unsigned int protoff,
 
 	rcu_read_lock();
 	do {
-		exp = __nf_ct_expect_find(net, nf_ct_zone(ct), &tuple);
+		struct nf_conntrack_zone zone;
 
+		exp = __nf_ct_expect_find(net, nf_ct_zone(ct, &zone), &tuple);
 		if (!exp || exp->master == ct ||
 		    nfct_help(exp->master)->helper != nfct_help(ct)->helper ||
 		    exp->class != class)
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index fc823fa..a02e582 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -140,6 +140,19 @@ static inline void ct_show_secctx(struct seq_file *s, const struct nf_conn *ct)
 }
 #endif
 
+#ifdef CONFIG_NF_CONNTRACK_ZONES
+static void ct_show_zone(struct seq_file *s, const struct nf_conn *ct)
+{
+	struct nf_conntrack_zone __zone, *zone = nf_ct_zone(ct, &__zone);
+
+	seq_printf(s, "zone=%u ", zone->id);
+}
+#else
+static inline void ct_show_zone(struct seq_file *s, const struct nf_conn *ct)
+{
+}
+#endif
+
 #ifdef CONFIG_NF_CONNTRACK_TIMESTAMP
 static void ct_show_delta_time(struct seq_file *s, const struct nf_conn *ct)
 {
@@ -228,11 +241,7 @@ static int ct_seq_show(struct seq_file *s, void *v)
 #endif
 
 	ct_show_secctx(s, ct);
-
-#ifdef CONFIG_NF_CONNTRACK_ZONES
-	seq_printf(s, "zone=%u ", nf_ct_zone(ct));
-#endif
-
+	ct_show_zone(s, ct);
 	ct_show_delta_time(s, ct);
 
 	seq_printf(s, "use=%u\n", atomic_read(&ct->ct_general.use));
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 4e0b478..253f74c 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -118,14 +118,15 @@ EXPORT_SYMBOL(nf_xfrm_me_harder);
 
 /* We keep an extra hash for each conntrack, for fast searching. */
 static inline unsigned int
-hash_by_src(const struct net *net, u16 zone,
+hash_by_src(const struct net *net,
+	    const struct nf_conntrack_zone *zone,
 	    const struct nf_conntrack_tuple *tuple)
 {
 	unsigned int hash;
 
 	/* Original src, to ensure we map it consistently if poss. */
 	hash = jhash2((u32 *)&tuple->src, sizeof(tuple->src) / sizeof(u32),
-		      tuple->dst.protonum ^ zone ^ nf_conntrack_hash_rnd);
+		      tuple->dst.protonum ^ zone->id ^ nf_conntrack_hash_rnd);
 
 	return reciprocal_scale(hash, net->ct.nat_htable_size);
 }
@@ -185,7 +186,8 @@ same_src(const struct nf_conn *ct,
 
 /* Only called for SRC manip */
 static int
-find_appropriate_src(struct net *net, u16 zone,
+find_appropriate_src(struct net *net,
+		     const struct nf_conntrack_zone *zone,
 		     const struct nf_nat_l3proto *l3proto,
 		     const struct nf_nat_l4proto *l4proto,
 		     const struct nf_conntrack_tuple *tuple,
@@ -198,7 +200,7 @@ find_appropriate_src(struct net *net, u16 zone,
 
 	hlist_for_each_entry_rcu(nat, &net->ct.nat_bysource[h], bysource) {
 		ct = nat->ct;
-		if (same_src(ct, tuple) && nf_ct_zone(ct) == zone) {
+		if (same_src(ct, tuple) && nf_ct_zone_equal(ct, zone)) {
 			/* Copy source part from reply tuple. */
 			nf_ct_invert_tuplepr(result,
 				       &ct->tuplehash[IP_CT_DIR_REPLY].tuple);
@@ -218,7 +220,8 @@ find_appropriate_src(struct net *net, u16 zone,
  * the ip with the lowest src-ip/dst-ip/proto usage.
  */
 static void
-find_best_ips_proto(u16 zone, struct nf_conntrack_tuple *tuple,
+find_best_ips_proto(const struct nf_conntrack_zone *zone,
+		    struct nf_conntrack_tuple *tuple,
 		    const struct nf_nat_range *range,
 		    const struct nf_conn *ct,
 		    enum nf_nat_manip_type maniptype)
@@ -258,7 +261,7 @@ find_best_ips_proto(u16 zone, struct nf_conntrack_tuple *tuple,
 	 */
 	j = jhash2((u32 *)&tuple->src.u3, sizeof(tuple->src.u3) / sizeof(u32),
 		   range->flags & NF_NAT_RANGE_PERSISTENT ?
-			0 : (__force u32)tuple->dst.u3.all[max] ^ zone);
+			0 : (__force u32)tuple->dst.u3.all[max] ^ zone->id);
 
 	full_range = false;
 	for (i = 0; i <= max; i++) {
@@ -297,10 +300,12 @@ get_unique_tuple(struct nf_conntrack_tuple *tuple,
 		 struct nf_conn *ct,
 		 enum nf_nat_manip_type maniptype)
 {
+	struct nf_conntrack_zone *zone, __zone;
 	const struct nf_nat_l3proto *l3proto;
 	const struct nf_nat_l4proto *l4proto;
 	struct net *net = nf_ct_net(ct);
-	u16 zone = nf_ct_zone(ct);
+
+	zone = nf_ct_zone(ct, &__zone);
 
 	rcu_read_lock();
 	l3proto = __nf_nat_l3proto_find(orig_tuple->src.l3num);
@@ -418,9 +423,10 @@ nf_nat_setup_info(struct nf_conn *ct,
 	}
 
 	if (maniptype == NF_NAT_MANIP_SRC) {
+		struct nf_conntrack_zone zone;
 		unsigned int srchash;
 
-		srchash = hash_by_src(net, nf_ct_zone(ct),
+		srchash = hash_by_src(net, nf_ct_zone(ct, &zone),
 				      &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
 		spin_lock_bh(&nf_nat_lock);
 		/* nf_conntrack_alter_reply might re-allocate extension aera */
diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index 789feea..c78fee7 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -17,10 +17,12 @@
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_tcpudp.h>
 #include <linux/netfilter/xt_SYNPROXY.h>
+
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_extend.h>
 #include <net/netfilter/nf_conntrack_seqadj.h>
 #include <net/netfilter/nf_conntrack_synproxy.h>
+#include <net/netfilter/nf_conntrack_zones.h>
 
 int synproxy_net_id;
 EXPORT_SYMBOL_GPL(synproxy_net_id);
@@ -349,12 +351,14 @@ static void __net_exit synproxy_proc_exit(struct net *net)
 static int __net_init synproxy_net_init(struct net *net)
 {
 	struct synproxy_net *snet = synproxy_pernet(net);
+	struct nf_conntrack_zone zone;
 	struct nf_conntrack_tuple t;
 	struct nf_conn *ct;
 	int err = -ENOMEM;
 
 	memset(&t, 0, sizeof(t));
-	ct = nf_conntrack_alloc(net, 0, &t, &t, GFP_KERNEL);
+	ct = nf_conntrack_alloc(net, nf_ct_zone_dflt(&zone),
+				&t, &t, GFP_KERNEL);
 	if (IS_ERR(ct)) {
 		err = PTR_ERR(ct);
 		goto err1;
diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
index 75747ae..e2d7b55 100644
--- a/net/netfilter/xt_CT.c
+++ b/net/netfilter/xt_CT.c
@@ -184,6 +184,7 @@ out:
 static int xt_ct_tg_check(const struct xt_tgchk_param *par,
 			  struct xt_ct_target_info_v1 *info)
 {
+	struct nf_conntrack_zone zone;
 	struct nf_conntrack_tuple t;
 	struct nf_conn *ct;
 	int ret = -EOPNOTSUPP;
@@ -203,7 +204,9 @@ static int xt_ct_tg_check(const struct xt_tgchk_param *par,
 		goto err1;
 
 	memset(&t, 0, sizeof(t));
-	ct = nf_conntrack_alloc(par->net, info->zone, &t, &t, GFP_KERNEL);
+	zone.id = info->zone;
+
+	ct = nf_conntrack_alloc(par->net, &zone, &t, &t, GFP_KERNEL);
 	ret = PTR_ERR(ct);
 	if (IS_ERR(ct))
 		goto err2;
diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
index 29ba621..ed94663 100644
--- a/net/netfilter/xt_connlimit.c
+++ b/net/netfilter/xt_connlimit.c
@@ -134,7 +134,7 @@ static bool add_hlist(struct hlist_head *head,
 static unsigned int check_hlist(struct net *net,
 				struct hlist_head *head,
 				const struct nf_conntrack_tuple *tuple,
-				u16 zone,
+				const struct nf_conntrack_zone *zone,
 				bool *addit)
 {
 	const struct nf_conntrack_tuple_hash *found;
@@ -201,7 +201,7 @@ static unsigned int
 count_tree(struct net *net, struct rb_root *root,
 	   const struct nf_conntrack_tuple *tuple,
 	   const union nf_inet_addr *addr, const union nf_inet_addr *mask,
-	   u8 family, u16 zone)
+	   u8 family, const struct nf_conntrack_zone *zone)
 {
 	struct xt_connlimit_rb *gc_nodes[CONNLIMIT_GC_MAX_NODES];
 	struct rb_node **rbnode, *parent;
@@ -290,7 +290,8 @@ static int count_them(struct net *net,
 		      const struct nf_conntrack_tuple *tuple,
 		      const union nf_inet_addr *addr,
 		      const union nf_inet_addr *mask,
-		      u_int8_t family, u16 zone)
+		      u_int8_t family,
+		      const struct nf_conntrack_zone *zone)
 {
 	struct rb_root *root;
 	int count;
@@ -321,15 +322,17 @@ connlimit_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	union nf_inet_addr addr;
 	struct nf_conntrack_tuple tuple;
 	const struct nf_conntrack_tuple *tuple_ptr = &tuple;
+	struct nf_conntrack_zone *zone, __zone;
 	enum ip_conntrack_info ctinfo;
 	const struct nf_conn *ct;
 	unsigned int connections;
-	u16 zone = NF_CT_DEFAULT_ZONE;
+
+	zone = nf_ct_zone_dflt(&__zone);
 
 	ct = nf_ct_get(skb, &ctinfo);
 	if (ct != NULL) {
 		tuple_ptr = &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
-		zone = nf_ct_zone(ct);
+		zone = nf_ct_zone(ct, &__zone);
 	} else if (!nf_ct_get_tuplepr(skb, skb_network_offset(skb),
 				    par->family, &tuple)) {
 		goto hotdrop;
diff --git a/net/sched/act_connmark.c b/net/sched/act_connmark.c
index 295d14b..179c1f8 100644
--- a/net/sched/act_connmark.c
+++ b/net/sched/act_connmark.c
@@ -37,6 +37,7 @@ static int tcf_connmark(struct sk_buff *skb, const struct tc_action *a,
 	struct nf_conntrack_tuple tuple;
 	enum ip_conntrack_info ctinfo;
 	struct tcf_connmark_info *ca = a->priv;
+	struct nf_conntrack_zone zone;
 	struct nf_conn *c;
 	int proto;
 
@@ -70,7 +71,8 @@ static int tcf_connmark(struct sk_buff *skb, const struct tc_action *a,
 			       proto, &tuple))
 		goto out;
 
-	thash = nf_conntrack_find_get(dev_net(skb->dev), ca->zone, &tuple);
+	zone.id = ca->zone;
+	thash = nf_conntrack_find_get(dev_net(skb->dev), &zone, &tuple);
 	if (!thash)
 		goto out;
 
-- 
1.9.3

