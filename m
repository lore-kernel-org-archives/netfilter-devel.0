From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 17/33] netfilter: conntrack: avoid unneeded nf_conntrack_l4proto lookups
Date: Tue, 29 Jan 2019 00:57:34 +0100
Message-ID: <20190128235750.18412-18-pablo@netfilter.org>
References: <20190128235750.18412-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190128235750.18412-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

after removal of the packet and invert function pointers, several
places do not need to lookup the l4proto structure anymore.

Remove those lookups.
The function nf_ct_invert_tuplepr becomes redundant, replace
it with nf_ct_invert_tuple everywhere.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack.h      |  2 --
 include/net/netfilter/nf_conntrack_core.h |  3 +-
 net/ipv4/netfilter/nf_nat_l3proto_ipv4.c  |  2 +-
 net/ipv6/netfilter/nf_nat_l3proto_ipv6.c  |  2 +-
 net/netfilter/nf_conntrack_core.c         | 53 ++++++-------------------------
 net/netfilter/nf_conntrack_pptp.c         |  2 +-
 net/netfilter/nf_conntrack_proto_icmp.c   |  6 +---
 net/netfilter/nf_conntrack_proto_icmpv6.c |  6 +---
 net/netfilter/nf_nat_core.c               | 12 +++----
 net/openvswitch/conntrack.c               |  2 +-
 10 files changed, 22 insertions(+), 68 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 249d0a5b12b8..b5aac5ae5129 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -187,8 +187,6 @@ bool nf_ct_delete(struct nf_conn *ct, u32 pid, int report);
 bool nf_ct_get_tuplepr(const struct sk_buff *skb, unsigned int nhoff,
 		       u_int16_t l3num, struct net *net,
 		       struct nf_conntrack_tuple *tuple);
-bool nf_ct_invert_tuplepr(struct nf_conntrack_tuple *inverse,
-			  const struct nf_conntrack_tuple *orig);
 
 void __nf_ct_refresh_acct(struct nf_conn *ct, enum ip_conntrack_info ctinfo,
 			  const struct sk_buff *skb,
diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index afc9b3620473..235c182022b2 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -39,8 +39,7 @@ void nf_conntrack_init_end(void);
 void nf_conntrack_cleanup_end(void);
 
 bool nf_ct_invert_tuple(struct nf_conntrack_tuple *inverse,
-			const struct nf_conntrack_tuple *orig,
-			const struct nf_conntrack_l4proto *l4proto);
+			const struct nf_conntrack_tuple *orig);
 
 /* Find a connection corresponding to a tuple. */
 struct nf_conntrack_tuple_hash *
diff --git a/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c b/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
index 2687db015b6f..e26165af45cb 100644
--- a/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
@@ -214,7 +214,7 @@ int nf_nat_icmp_reply_translation(struct sk_buff *skb,
 	}
 
 	/* Change outer to look like the reply to an incoming packet */
-	nf_ct_invert_tuplepr(&target, &ct->tuplehash[!dir].tuple);
+	nf_ct_invert_tuple(&target, &ct->tuplehash[!dir].tuple);
 	if (!nf_nat_ipv4_manip_pkt(skb, 0, &target, manip))
 		return 0;
 
diff --git a/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c b/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c
index 23022447eb49..9c914db44bec 100644
--- a/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c
@@ -225,7 +225,7 @@ int nf_nat_icmpv6_reply_translation(struct sk_buff *skb,
 						     skb->len - hdrlen, 0));
 	}
 
-	nf_ct_invert_tuplepr(&target, &ct->tuplehash[!dir].tuple);
+	nf_ct_invert_tuple(&target, &ct->tuplehash[!dir].tuple);
 	if (!nf_nat_ipv6_manip_pkt(skb, 0, &target, manip))
 		return 0;
 
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 264074f04615..728d2b5bdb1a 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -229,8 +229,7 @@ nf_ct_get_tuple(const struct sk_buff *skb,
 		u_int16_t l3num,
 		u_int8_t protonum,
 		struct net *net,
-		struct nf_conntrack_tuple *tuple,
-		const struct nf_conntrack_l4proto *l4proto)
+		struct nf_conntrack_tuple *tuple)
 {
 	unsigned int size;
 	const __be32 *ap;
@@ -374,33 +373,20 @@ bool nf_ct_get_tuplepr(const struct sk_buff *skb, unsigned int nhoff,
 		       u_int16_t l3num,
 		       struct net *net, struct nf_conntrack_tuple *tuple)
 {
-	const struct nf_conntrack_l4proto *l4proto;
 	u8 protonum;
 	int protoff;
-	int ret;
-
-	rcu_read_lock();
 
 	protoff = get_l4proto(skb, nhoff, l3num, &protonum);
-	if (protoff <= 0) {
-		rcu_read_unlock();
+	if (protoff <= 0)
 		return false;
-	}
 
-	l4proto = __nf_ct_l4proto_find(protonum);
-
-	ret = nf_ct_get_tuple(skb, nhoff, protoff, l3num, protonum, net, tuple,
-			      l4proto);
-
-	rcu_read_unlock();
-	return ret;
+	return nf_ct_get_tuple(skb, nhoff, protoff, l3num, protonum, net, tuple);
 }
 EXPORT_SYMBOL_GPL(nf_ct_get_tuplepr);
 
 bool
 nf_ct_invert_tuple(struct nf_conntrack_tuple *inverse,
-		   const struct nf_conntrack_tuple *orig,
-		   const struct nf_conntrack_l4proto *l4proto)
+		   const struct nf_conntrack_tuple *orig)
 {
 	memset(inverse, 0, sizeof(*inverse));
 
@@ -1354,7 +1340,6 @@ EXPORT_SYMBOL_GPL(nf_conntrack_free);
 static noinline struct nf_conntrack_tuple_hash *
 init_conntrack(struct net *net, struct nf_conn *tmpl,
 	       const struct nf_conntrack_tuple *tuple,
-	       const struct nf_conntrack_l4proto *l4proto,
 	       struct sk_buff *skb,
 	       unsigned int dataoff, u32 hash)
 {
@@ -1367,7 +1352,7 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
 	struct nf_conn_timeout *timeout_ext;
 	struct nf_conntrack_zone tmp;
 
-	if (!nf_ct_invert_tuple(&repl_tuple, tuple, l4proto)) {
+	if (!nf_ct_invert_tuple(&repl_tuple, tuple)) {
 		pr_debug("Can't invert tuple.\n");
 		return NULL;
 	}
@@ -1449,7 +1434,6 @@ resolve_normal_ct(struct nf_conn *tmpl,
 		  struct sk_buff *skb,
 		  unsigned int dataoff,
 		  u_int8_t protonum,
-		  const struct nf_conntrack_l4proto *l4proto,
 		  const struct nf_hook_state *state)
 {
 	const struct nf_conntrack_zone *zone;
@@ -1462,7 +1446,7 @@ resolve_normal_ct(struct nf_conn *tmpl,
 
 	if (!nf_ct_get_tuple(skb, skb_network_offset(skb),
 			     dataoff, state->pf, protonum, state->net,
-			     &tuple, l4proto)) {
+			     &tuple)) {
 		pr_debug("Can't get tuple\n");
 		return 0;
 	}
@@ -1472,7 +1456,7 @@ resolve_normal_ct(struct nf_conn *tmpl,
 	hash = hash_conntrack_raw(&tuple, state->net);
 	h = __nf_conntrack_find_get(state->net, zone, &tuple, hash);
 	if (!h) {
-		h = init_conntrack(state->net, tmpl, &tuple, l4proto,
+		h = init_conntrack(state->net, tmpl, &tuple,
 				   skb, dataoff, hash);
 		if (!h)
 			return 0;
@@ -1592,7 +1576,6 @@ static int nf_conntrack_handle_packet(struct nf_conn *ct,
 unsigned int
 nf_conntrack_in(struct sk_buff *skb, const struct nf_hook_state *state)
 {
-	const struct nf_conntrack_l4proto *l4proto;
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct, *tmpl;
 	u_int8_t protonum;
@@ -1619,8 +1602,6 @@ nf_conntrack_in(struct sk_buff *skb, const struct nf_hook_state *state)
 		goto out;
 	}
 
-	l4proto = __nf_ct_l4proto_find(protonum);
-
 	if (protonum == IPPROTO_ICMP || protonum == IPPROTO_ICMPV6) {
 		ret = nf_conntrack_handle_icmp(tmpl, skb, dataoff,
 					       protonum, state);
@@ -1634,7 +1615,7 @@ nf_conntrack_in(struct sk_buff *skb, const struct nf_hook_state *state)
 	}
 repeat:
 	ret = resolve_normal_ct(tmpl, skb, dataoff,
-				protonum, l4proto, state);
+				protonum, state);
 	if (ret < 0) {
 		/* Too stressed to deal. */
 		NF_CT_STAT_INC_ATOMIC(state->net, drop);
@@ -1681,19 +1662,6 @@ nf_conntrack_in(struct sk_buff *skb, const struct nf_hook_state *state)
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_in);
 
-bool nf_ct_invert_tuplepr(struct nf_conntrack_tuple *inverse,
-			  const struct nf_conntrack_tuple *orig)
-{
-	bool ret;
-
-	rcu_read_lock();
-	ret = nf_ct_invert_tuple(inverse, orig,
-				 __nf_ct_l4proto_find(orig->dst.protonum));
-	rcu_read_unlock();
-	return ret;
-}
-EXPORT_SYMBOL_GPL(nf_ct_invert_tuplepr);
-
 /* Alter reply tuple (maybe alter helper).  This is for NAT, and is
    implicitly racy: see __nf_conntrack_confirm */
 void nf_conntrack_alter_reply(struct nf_conn *ct,
@@ -1824,7 +1792,6 @@ static void nf_conntrack_attach(struct sk_buff *nskb, const struct sk_buff *skb)
 
 static int nf_conntrack_update(struct net *net, struct sk_buff *skb)
 {
-	const struct nf_conntrack_l4proto *l4proto;
 	struct nf_conntrack_tuple_hash *h;
 	struct nf_conntrack_tuple tuple;
 	enum ip_conntrack_info ctinfo;
@@ -1845,10 +1812,8 @@ static int nf_conntrack_update(struct net *net, struct sk_buff *skb)
 	if (dataoff <= 0)
 		return -1;
 
-	l4proto = nf_ct_l4proto_find_get(l4num);
-
 	if (!nf_ct_get_tuple(skb, skb_network_offset(skb), dataoff, l3num,
-			     l4num, net, &tuple, l4proto))
+			     l4num, net, &tuple))
 		return -1;
 
 	if (ct->status & IPS_SRC_NAT) {
diff --git a/net/netfilter/nf_conntrack_pptp.c b/net/netfilter/nf_conntrack_pptp.c
index 11562f2a08bb..976f1dcb97f0 100644
--- a/net/netfilter/nf_conntrack_pptp.c
+++ b/net/netfilter/nf_conntrack_pptp.c
@@ -121,7 +121,7 @@ static void pptp_expectfn(struct nf_conn *ct,
 		struct nf_conntrack_expect *exp_other;
 
 		/* obviously this tuple inversion only works until you do NAT */
-		nf_ct_invert_tuplepr(&inv_t, &exp->tuple);
+		nf_ct_invert_tuple(&inv_t, &exp->tuple);
 		pr_debug("trying to unexpect other dir: ");
 		nf_ct_dump_tuple(&inv_t);
 
diff --git a/net/netfilter/nf_conntrack_proto_icmp.c b/net/netfilter/nf_conntrack_proto_icmp.c
index d28c1d7633b2..1007efae741d 100644
--- a/net/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/netfilter/nf_conntrack_proto_icmp.c
@@ -109,7 +109,6 @@ icmp_error_message(struct nf_conn *tmpl, struct sk_buff *skb,
 		   const struct nf_hook_state *state)
 {
 	struct nf_conntrack_tuple innertuple, origtuple;
-	const struct nf_conntrack_l4proto *innerproto;
 	const struct nf_conntrack_tuple_hash *h;
 	const struct nf_conntrack_zone *zone;
 	enum ip_conntrack_info ctinfo;
@@ -127,12 +126,9 @@ icmp_error_message(struct nf_conn *tmpl, struct sk_buff *skb,
 		return -NF_ACCEPT;
 	}
 
-	/* rcu_read_lock()ed by nf_hook_thresh */
-	innerproto = __nf_ct_l4proto_find(origtuple.dst.protonum);
-
 	/* Ordinarily, we'd expect the inverted tupleproto, but it's
 	   been preserved inside the ICMP. */
-	if (!nf_ct_invert_tuple(&innertuple, &origtuple, innerproto)) {
+	if (!nf_ct_invert_tuple(&innertuple, &origtuple)) {
 		pr_debug("icmp_error_message: no match\n");
 		return -NF_ACCEPT;
 	}
diff --git a/net/netfilter/nf_conntrack_proto_icmpv6.c b/net/netfilter/nf_conntrack_proto_icmpv6.c
index 2910dcdea134..6c93c091a8dd 100644
--- a/net/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/netfilter/nf_conntrack_proto_icmpv6.c
@@ -130,7 +130,6 @@ icmpv6_error_message(struct net *net, struct nf_conn *tmpl,
 {
 	struct nf_conntrack_tuple intuple, origtuple;
 	const struct nf_conntrack_tuple_hash *h;
-	const struct nf_conntrack_l4proto *inproto;
 	enum ip_conntrack_info ctinfo;
 	struct nf_conntrack_zone tmp;
 
@@ -146,12 +145,9 @@ icmpv6_error_message(struct net *net, struct nf_conn *tmpl,
 		return -NF_ACCEPT;
 	}
 
-	/* rcu_read_lock()ed by nf_hook_thresh */
-	inproto = __nf_ct_l4proto_find(origtuple.dst.protonum);
-
 	/* Ordinarily, we'd expect the inverted tupleproto, but it's
 	   been preserved inside the ICMP. */
-	if (!nf_ct_invert_tuple(&intuple, &origtuple, inproto)) {
+	if (!nf_ct_invert_tuple(&intuple, &origtuple)) {
 		pr_debug("icmpv6_error: Can't invert tuple\n");
 		return -NF_ACCEPT;
 	}
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index d159e9e7835b..44f97b3a215a 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -158,7 +158,7 @@ nf_nat_used_tuple(const struct nf_conntrack_tuple *tuple,
 	 */
 	struct nf_conntrack_tuple reply;
 
-	nf_ct_invert_tuplepr(&reply, tuple);
+	nf_ct_invert_tuple(&reply, tuple);
 	return nf_conntrack_tuple_taken(&reply, ignored_conntrack);
 }
 EXPORT_SYMBOL(nf_nat_used_tuple);
@@ -253,7 +253,7 @@ find_appropriate_src(struct net *net,
 		    net_eq(net, nf_ct_net(ct)) &&
 		    nf_ct_zone_equal(ct, zone, IP_CT_DIR_ORIGINAL)) {
 			/* Copy source part from reply tuple. */
-			nf_ct_invert_tuplepr(result,
+			nf_ct_invert_tuple(result,
 				       &ct->tuplehash[IP_CT_DIR_REPLY].tuple);
 			result->dst = tuple->dst;
 
@@ -560,8 +560,8 @@ nf_nat_setup_info(struct nf_conn *ct,
 	 * manipulations (future optimization: if num_manips == 0,
 	 * orig_tp = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple)
 	 */
-	nf_ct_invert_tuplepr(&curr_tuple,
-			     &ct->tuplehash[IP_CT_DIR_REPLY].tuple);
+	nf_ct_invert_tuple(&curr_tuple,
+			   &ct->tuplehash[IP_CT_DIR_REPLY].tuple);
 
 	get_unique_tuple(&new_tuple, &curr_tuple, range, ct, maniptype);
 
@@ -569,7 +569,7 @@ nf_nat_setup_info(struct nf_conn *ct,
 		struct nf_conntrack_tuple reply;
 
 		/* Alter conntrack table so will recognize replies. */
-		nf_ct_invert_tuplepr(&reply, &new_tuple);
+		nf_ct_invert_tuple(&reply, &new_tuple);
 		nf_conntrack_alter_reply(ct, &reply);
 
 		/* Non-atomic: we own this at the moment. */
@@ -640,7 +640,7 @@ static unsigned int nf_nat_manip_pkt(struct sk_buff *skb, struct nf_conn *ct,
 	struct nf_conntrack_tuple target;
 
 	/* We are aiming to look like inverse of other direction. */
-	nf_ct_invert_tuplepr(&target, &ct->tuplehash[!dir].tuple);
+	nf_ct_invert_tuple(&target, &ct->tuplehash[!dir].tuple);
 
 	l3proto = __nf_nat_l3proto_find(target.src.l3num);
 	if (!l3proto->manip_pkt(skb, 0, &target, mtype))
diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index cd94f925495a..35884f836260 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -622,7 +622,7 @@ ovs_ct_find_existing(struct net *net, const struct nf_conntrack_zone *zone,
 	if (natted) {
 		struct nf_conntrack_tuple inverse;
 
-		if (!nf_ct_invert_tuplepr(&inverse, &tuple)) {
+		if (!nf_ct_invert_tuple(&inverse, &tuple)) {
 			pr_debug("ovs_ct_find_existing: Inversion failed!\n");
 			return NULL;
 		}
-- 
2.11.0
