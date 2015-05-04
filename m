From: Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH nf-next] netfilter: conntrack: add support for flextuples
Date: Mon,  4 May 2015 12:23:41 +0200
Message-ID: <776b8819c85c83088478b933a35691133055347a.1430733932.git.daniel@iogearbox.net>
Cc: netfilter-devel@vger.kernel.org,
	Daniel Borkmann <daniel@iogearbox.net>,
	Thomas Graf <tgraf@suug.ch>,
	Madhu Challa <challa@noironetworks.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:38106 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbbEDKXr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 May 2015 06:23:47 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds support for the possibility of doing NAT with
conflicting IP address/ports tuples from multiple, isolated
tenants, represented as network namespaces and netfilter zones.
For such internal VRFs, traffic is directed to a single or shared
pool of public IP address/port range for the external/public VRF.

Or in other words, this allows for doing NAT *between* VRFs
instead of *inside* VRFs without requiring each tenant to NAT
twice or to use its own dedicated IP address to SNAT to, also
with the side effect to not requiring to expose a unique marker
per tenant in the data center to the public.

Simplified example scheme:

  +--- VRF A ---+  +--- CT Zone 1 --------+
  | 10.1.1.1/8  +--+ 10.1.1.1 ESTABLISHED |
  +-------------+  +--+-------------------+
                      |
                   +--+--+
                   | L3  +-SNAT-[20.1.1.1:20000-40000]--eth0
                   +--+--+
                      |
  +-- VRF B ----+  +--- CT Zone 2 --------+
  | 10.1.1.1/8  +--+ 10.1.1.1 ESTABLISHED |
  +-------------+  +----------------------+

VRF A and VRF B are two tenants, e.g. represented as a network
namespace. The connection state for each VRF is tracked separately
to implement differing policies, and thus results in one zone per
VRF. The operator does L3 between VRFs using any kind of L3 routing
entity. The NAT is being done in a separate zone so that global
policies can apply here that are tenant-independant.

The connection tracking table is a natural fit for this and the
VRF context is preserved in the flow by using a mark, which offers
high flexibility and can be configured/set based on any criteria.
The ability to selectively include the mark into the tuple match
for a particular direction, we call flextuple.

With the help of flextuples, we can implement the conflicting
IP address/ports tuples in the NAT zone; simplified example and
path traversal explanation:

  iptables -t nat -A POSTROUTING -o <dev> -j SNAT --to <IP>
  iptables -t raw -A PREROUTING -j CT --flextuple ORIGINAL

  iptables -t mangle -A PREROUTING -m conntrack --ctdir ORIGINAL -j CONNMARK --save-mark
  iptables -t mangle -A POSTROUTING -m conntrack --ctdir REPLY -j CONNMARK --restore-mark

  +--- VRF A ---+  +--- CT Zone 1 --------+
  | 10.1.1.1/8  +--+ 10.1.1.1 ESTABLISHED |
  +-------------+  +--+-------------------+
                      | v-- mark=A
                   +--+--+      +-- CT Zone 0 -(rev-mapping)-+
                   |  L3 +-SNAT-| <-- 10.1.1.1:20000, mark=A |
                   +--+--+      | <-- 10.1.1.1:20000, mark=B |
                      |         +----------------------------+
                      | ^-- mark=B
  +-- VRF B ----+  +--- CT Zone 2 --------+
  | 10.1.1.1/8  +--+ 10.1.1.1 ESTABLISHED |
  +-------------+  +----------------------+

The packet traversal for the outgoing direction, starting from
VRF A, is passing through the dedicated CT zone 1, where VRF A
specific firewalling policies apply, and are then being passed to
the L3 forwarder.

Based on the port/dev, the skb is marked with a unique tenant id
and directs the packets to the SNAT zone, where the conntracker
stores the skb->mark in the ct->mark and matches original traffic
on the flextuple.

A unique entry for reply traffic with the public IP/port mapping
is created. When reverse NAT'ing is being done, the ct->mark is
stored back into the skb->mark per above rule, and pushed back to
the L3 entity that knows to which tenant to forward the skb with
help of mark-based routing.

The implementation is rather straight forward, the only requirement
is to support generic flextuples infrastructure for the connection
tracker, no changes to NAT need to be done.

For the connection tracker, the flextuple direction is configured
through the jump target in the raw table, and will store the flag
in a ct template, which is being picked up when a real connection
is created, so that this can be determined by the matcher.

For users not configuring a flextuple, there's no change in
behaviour. Moreover, usage of flextuples does not have an increase
in the memory footprint for a connection tracking entry.

Joint work with Thomas Graf and Madhu Challa, also thanks to
Florian Westphal for input.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Thomas Graf <tgraf@suug.ch>
Signed-off-by: Madhu Challa <challa@noironetworks.com>
---
 include/net/netfilter/nf_conntrack.h               | 24 ++++++++++++++
 include/net/netfilter/nf_conntrack_core.h          |  2 +-
 include/uapi/linux/netfilter/nf_conntrack_common.h |  7 ++++
 include/uapi/linux/netfilter/xt_CT.h               |  7 +++-
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c     |  3 +-
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c       |  2 +-
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c     |  3 +-
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c     |  2 +-
 net/netfilter/ipvs/ip_vs_nfct.c                    |  2 +-
 net/netfilter/nf_conntrack_core.c                  | 37 +++++++++++++++-------
 net/netfilter/nf_conntrack_netlink.c               | 14 ++++----
 net/netfilter/nf_conntrack_pptp.c                  |  2 +-
 net/netfilter/xt_CT.c                              |  5 +++
 net/netfilter/xt_connlimit.c                       | 17 +++++-----
 net/sched/act_connmark.c                           |  3 +-
 15 files changed, 94 insertions(+), 36 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 095433b..6d67ab4 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -51,6 +51,8 @@ union nf_conntrack_expect_proto {
 
 struct nf_conntrack_helper;
 
+#define NF_CT_DEFAULT_MARK		0
+
 /* Must be kept in sync with the classes defined by helpers */
 #define NF_CT_MAX_EXPECT_CLASSES	4
 
@@ -277,6 +279,28 @@ static inline int nf_ct_is_untracked(const struct nf_conn *ct)
 	return test_bit(IPS_UNTRACKED_BIT, &ct->status);
 }
 
+static inline bool nf_ct_is_flextuple(const struct nf_conn *ct,
+				      const enum ip_conntrack_dir dir)
+{
+	switch (dir) {
+	case IP_CT_DIR_ORIGINAL:
+		return test_bit(IPS_ORIG_FLEXTUPLE_BIT, &ct->status);
+	case IP_CT_DIR_REPLY:
+		return test_bit(IPS_REPL_FLEXTUPLE_BIT, &ct->status);
+	default:
+		return false;
+	}
+}
+
+static inline void nf_ct_init_flextuple(const struct nf_conn *tmpl,
+					struct nf_conn *ct)
+{
+	if (test_bit(IPS_ORIG_FLEXTUPLE_BIT, &tmpl->status))
+		__set_bit(IPS_ORIG_FLEXTUPLE_BIT, &ct->status);
+	if (test_bit(IPS_REPL_FLEXTUPLE_BIT, &tmpl->status))
+		__set_bit(IPS_REPL_FLEXTUPLE_BIT, &ct->status);
+}
+
 /* Packet is received from loopback */
 static inline bool nf_is_loopback_packet(const struct sk_buff *skb)
 {
diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index f2f0fa3..b4fd6c6 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -52,7 +52,7 @@ bool nf_ct_invert_tuple(struct nf_conntrack_tuple *inverse,
 
 /* Find a connection corresponding to a tuple. */
 struct nf_conntrack_tuple_hash *
-nf_conntrack_find_get(struct net *net, u16 zone,
+nf_conntrack_find_get(struct net *net, u16 zone, u32 mark,
 		      const struct nf_conntrack_tuple *tuple);
 
 int __nf_conntrack_confirm(struct sk_buff *skb);
diff --git a/include/uapi/linux/netfilter/nf_conntrack_common.h b/include/uapi/linux/netfilter/nf_conntrack_common.h
index 319f471..b242948 100644
--- a/include/uapi/linux/netfilter/nf_conntrack_common.h
+++ b/include/uapi/linux/netfilter/nf_conntrack_common.h
@@ -91,6 +91,13 @@ enum ip_conntrack_status {
 	/* Conntrack got a helper explicitly attached via CT target. */
 	IPS_HELPER_BIT = 13,
 	IPS_HELPER = (1 << IPS_HELPER_BIT),
+
+	/* Entry is a flexible conntrack tuple match with mark */
+	IPS_ORIG_FLEXTUPLE_BIT = 14,
+	IPS_ORIG_FLEXTUPLE = (1 << IPS_ORIG_FLEXTUPLE_BIT),
+
+	IPS_REPL_FLEXTUPLE_BIT = 15,
+	IPS_REPL_FLEXTUPLE = (1 << IPS_REPL_FLEXTUPLE_BIT),
 };
 
 /* Connection tracking event types */
diff --git a/include/uapi/linux/netfilter/xt_CT.h b/include/uapi/linux/netfilter/xt_CT.h
index 5a688c1..5b3bff6 100644
--- a/include/uapi/linux/netfilter/xt_CT.h
+++ b/include/uapi/linux/netfilter/xt_CT.h
@@ -6,7 +6,12 @@
 enum {
 	XT_CT_NOTRACK		= 1 << 0,
 	XT_CT_NOTRACK_ALIAS	= 1 << 1,
-	XT_CT_MASK		= XT_CT_NOTRACK | XT_CT_NOTRACK_ALIAS,
+	XT_CT_FLEX_ORIG		= 1 << 2,
+	XT_CT_FLEX_REPL		= 1 << 3,
+
+	/* Full option mask */
+	XT_CT_MASK		= XT_CT_NOTRACK | XT_CT_NOTRACK_ALIAS |
+				  XT_CT_FLEX_ORIG | XT_CT_FLEX_REPL,
 };
 
 struct xt_ct_target_info {
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index 30ad955..13280fb 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -280,7 +280,8 @@ getorigdst(struct sock *sk, int optval, void __user *user, int *len)
 		return -EINVAL;
 	}
 
-	h = nf_conntrack_find_get(sock_net(sk), NF_CT_DEFAULT_ZONE, &tuple);
+	h = nf_conntrack_find_get(sock_net(sk), NF_CT_DEFAULT_ZONE,
+				  NF_CT_DEFAULT_MARK, &tuple);
 	if (h) {
 		struct sockaddr_in sin;
 		struct nf_conn *ct = nf_ct_tuplehash_to_ctrack(h);
diff --git a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
index 80d5554..4fc1e83 100644
--- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
@@ -160,7 +160,7 @@ icmp_error_message(struct net *net, struct nf_conn *tmpl, struct sk_buff *skb,
 
 	*ctinfo = IP_CT_RELATED;
 
-	h = nf_conntrack_find_get(net, zone, &innertuple);
+	h = nf_conntrack_find_get(net, zone, skb->mark, &innertuple);
 	if (!h) {
 		pr_debug("icmp_error_message: no match\n");
 		return -NF_ACCEPT;
diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index 4ba0c34..21af1a7 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -251,7 +251,8 @@ ipv6_getorigdst(struct sock *sk, int optval, void __user *user, int *len)
 	if (*len < 0 || (unsigned int) *len < sizeof(sin6))
 		return -EINVAL;
 
-	h = nf_conntrack_find_get(sock_net(sk), NF_CT_DEFAULT_ZONE, &tuple);
+	h = nf_conntrack_find_get(sock_net(sk), NF_CT_DEFAULT_ZONE,
+				  NF_CT_DEFAULT_MARK, &tuple);
 	if (!h) {
 		pr_debug("IP6T_SO_ORIGINAL_DST: Can't find %pI6c/%u-%pI6c/%u.\n",
 			 &tuple.src.u3.ip6, ntohs(tuple.src.u.tcp.port),
diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
index 90388d6..9d0a4ce 100644
--- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
@@ -177,7 +177,7 @@ icmpv6_error_message(struct net *net, struct nf_conn *tmpl,
 
 	*ctinfo = IP_CT_RELATED;
 
-	h = nf_conntrack_find_get(net, zone, &intuple);
+	h = nf_conntrack_find_get(net, zone, skb->mark, &intuple);
 	if (!h) {
 		pr_debug("icmpv6_error: no match\n");
 		return -NF_ACCEPT;
diff --git a/net/netfilter/ipvs/ip_vs_nfct.c b/net/netfilter/ipvs/ip_vs_nfct.c
index 5882bbf..f27fc79 100644
--- a/net/netfilter/ipvs/ip_vs_nfct.c
+++ b/net/netfilter/ipvs/ip_vs_nfct.c
@@ -275,7 +275,7 @@ void ip_vs_conn_drop_conntrack(struct ip_vs_conn *cp)
 		__func__, ARG_TUPLE(&tuple), ARG_CONN(cp));
 
 	h = nf_conntrack_find_get(ip_vs_conn_net(cp), NF_CT_DEFAULT_ZONE,
-				  &tuple);
+				  NF_CT_DEFAULT_MARK, &tuple);
 	if (h) {
 		ct = nf_ct_tuplehash_to_ctrack(h);
 		/* Show what happens instead of calling nf_ct_kill() */
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 13fad86..6d15ee0 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -385,19 +385,29 @@ static void death_by_timeout(unsigned long ul_conntrack)
 	nf_ct_delete((struct nf_conn *)ul_conntrack, 0, 0);
 }
 
+static inline bool nf_ct_probe_flex(const struct nf_conn *ct,
+				    enum ip_conntrack_dir dir, u32 mark)
+{
+	return nf_ct_is_flextuple(ct, dir) ? ct->mark == mark : true;
+}
+
 static inline bool
 nf_ct_key_equal(struct nf_conntrack_tuple_hash *h,
 			const struct nf_conntrack_tuple *tuple,
-			u16 zone)
+			u16 zone, u32 mark)
 {
 	struct nf_conn *ct = nf_ct_tuplehash_to_ctrack(h);
 
 	/* A conntrack can be recreated with the equal tuple,
-	 * so we need to check that the conntrack is confirmed
+	 * so we need to check that the conntrack is confirmed.
+	 *
+	 * Probing for direction-based flex-tuple is last in
+	 * order to filter out most mismatches first.
 	 */
 	return nf_ct_tuple_equal(tuple, &h->tuple) &&
-		nf_ct_zone(ct) == zone &&
-		nf_ct_is_confirmed(ct);
+	       nf_ct_zone(ct) == zone &&
+	       nf_ct_is_confirmed(ct) &&
+	       nf_ct_probe_flex(ct, NF_CT_DIRECTION(h), mark);
 }
 
 /*
@@ -406,7 +416,7 @@ nf_ct_key_equal(struct nf_conntrack_tuple_hash *h,
  *   and recheck nf_ct_tuple_equal(tuple, &h->tuple)
  */
 static struct nf_conntrack_tuple_hash *
-____nf_conntrack_find(struct net *net, u16 zone,
+____nf_conntrack_find(struct net *net, u16 zone, u32 mark,
 		      const struct nf_conntrack_tuple *tuple, u32 hash)
 {
 	struct nf_conntrack_tuple_hash *h;
@@ -419,7 +429,7 @@ ____nf_conntrack_find(struct net *net, u16 zone,
 	local_bh_disable();
 begin:
 	hlist_nulls_for_each_entry_rcu(h, n, &net->ct.hash[bucket], hnnode) {
-		if (nf_ct_key_equal(h, tuple, zone)) {
+		if (nf_ct_key_equal(h, tuple, zone, mark)) {
 			NF_CT_STAT_INC(net, found);
 			local_bh_enable();
 			return h;
@@ -442,7 +452,7 @@ begin:
 
 /* Find a connection corresponding to a tuple. */
 static struct nf_conntrack_tuple_hash *
-__nf_conntrack_find_get(struct net *net, u16 zone,
+__nf_conntrack_find_get(struct net *net, u16 zone, u32 mark,
 			const struct nf_conntrack_tuple *tuple, u32 hash)
 {
 	struct nf_conntrack_tuple_hash *h;
@@ -450,14 +460,14 @@ __nf_conntrack_find_get(struct net *net, u16 zone,
 
 	rcu_read_lock();
 begin:
-	h = ____nf_conntrack_find(net, zone, tuple, hash);
+	h = ____nf_conntrack_find(net, zone, mark, tuple, hash);
 	if (h) {
 		ct = nf_ct_tuplehash_to_ctrack(h);
 		if (unlikely(nf_ct_is_dying(ct) ||
 			     !atomic_inc_not_zero(&ct->ct_general.use)))
 			h = NULL;
 		else {
-			if (unlikely(!nf_ct_key_equal(h, tuple, zone))) {
+			if (unlikely(!nf_ct_key_equal(h, tuple, zone, mark))) {
 				nf_ct_put(ct);
 				goto begin;
 			}
@@ -469,10 +479,10 @@ begin:
 }
 
 struct nf_conntrack_tuple_hash *
-nf_conntrack_find_get(struct net *net, u16 zone,
+nf_conntrack_find_get(struct net *net, u16 zone, u32 mark,
 		      const struct nf_conntrack_tuple *tuple)
 {
-	return __nf_conntrack_find_get(net, zone, tuple,
+	return __nf_conntrack_find_get(net, zone, mark, tuple,
 				       hash_conntrack_raw(tuple, zone));
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_find_get);
@@ -920,6 +930,9 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
 		nfct_synproxy_ext_add(ct);
 	}
 
+	if (tmpl)
+		nf_ct_init_flextuple(tmpl, ct);
+
 	timeout_ext = tmpl ? nf_ct_timeout_find(tmpl) : NULL;
 	if (timeout_ext)
 		timeouts = NF_CT_TIMEOUT_EXT_DATA(timeout_ext);
@@ -1019,7 +1032,7 @@ resolve_normal_ct(struct net *net, struct nf_conn *tmpl,
 
 	/* look for tuple match */
 	hash = hash_conntrack_raw(&tuple, zone);
-	h = __nf_conntrack_find_get(net, zone, &tuple, hash);
+	h = __nf_conntrack_find_get(net, zone, skb->mark, &tuple, hash);
 	if (!h) {
 		h = init_conntrack(net, tmpl, &tuple, l3proto, l4proto,
 				   skb, dataoff, hash);
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index d1c2394..03265d21 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1078,7 +1078,7 @@ ctnetlink_del_conntrack(struct sock *ctnl, struct sk_buff *skb,
 	if (err < 0)
 		return err;
 
-	h = nf_conntrack_find_get(net, zone, &tuple);
+	h = nf_conntrack_find_get(net, zone, NF_CT_DEFAULT_MARK, &tuple);
 	if (!h)
 		return -ENOENT;
 
@@ -1147,7 +1147,7 @@ ctnetlink_get_conntrack(struct sock *ctnl, struct sk_buff *skb,
 	if (err < 0)
 		return err;
 
-	h = nf_conntrack_find_get(net, zone, &tuple);
+	h = nf_conntrack_find_get(net, zone, NF_CT_DEFAULT_MARK, &tuple);
 	if (!h)
 		return -ENOENT;
 
@@ -1765,7 +1765,7 @@ ctnetlink_create_conntrack(struct net *net, u16 zone,
 		if (err < 0)
 			goto err2;
 
-		master_h = nf_conntrack_find_get(net, zone, &master);
+		master_h = nf_conntrack_find_get(net, zone, NF_CT_DEFAULT_MARK, &master);
 		if (master_h == NULL) {
 			err = -ENOENT;
 			goto err2;
@@ -1824,9 +1824,9 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
 	}
 
 	if (cda[CTA_TUPLE_ORIG])
-		h = nf_conntrack_find_get(net, zone, &otuple);
+		h = nf_conntrack_find_get(net, zone, NF_CT_DEFAULT_MARK, &otuple);
 	else if (cda[CTA_TUPLE_REPLY])
-		h = nf_conntrack_find_get(net, zone, &rtuple);
+		h = nf_conntrack_find_get(net, zone, NF_CT_DEFAULT_MARK, &rtuple);
 
 	if (h == NULL) {
 		err = -ENOENT;
@@ -2628,7 +2628,7 @@ static int ctnetlink_dump_exp_ct(struct sock *ctnl, struct sk_buff *skb,
 			return err;
 	}
 
-	h = nf_conntrack_find_get(net, zone, &tuple);
+	h = nf_conntrack_find_get(net, zone, NF_CT_DEFAULT_MARK, &tuple);
 	if (!h)
 		return -ENOENT;
 
@@ -2960,7 +2960,7 @@ ctnetlink_create_expect(struct net *net, u16 zone,
 		return err;
 
 	/* Look for master conntrack of this expectation */
-	h = nf_conntrack_find_get(net, zone, &master_tuple);
+	h = nf_conntrack_find_get(net, zone, NF_CT_DEFAULT_MARK, &master_tuple);
 	if (!h)
 		return -ENOENT;
 	ct = nf_ct_tuplehash_to_ctrack(h);
diff --git a/net/netfilter/nf_conntrack_pptp.c b/net/netfilter/nf_conntrack_pptp.c
index 825c3e3..ce965af 100644
--- a/net/netfilter/nf_conntrack_pptp.c
+++ b/net/netfilter/nf_conntrack_pptp.c
@@ -150,7 +150,7 @@ static int destroy_sibling_or_exp(struct net *net, struct nf_conn *ct,
 	pr_debug("trying to timeout ct or exp for tuple ");
 	nf_ct_dump_tuple(t);
 
-	h = nf_conntrack_find_get(net, zone, t);
+	h = nf_conntrack_find_get(net, zone, ct->mark, t);
 	if (h)  {
 		sibling = nf_ct_tuplehash_to_ctrack(h);
 		pr_debug("setting timeout of conntrack %p to 0\n", sibling);
diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
index 75747ae..b1d9b27 100644
--- a/net/netfilter/xt_CT.c
+++ b/net/netfilter/xt_CT.c
@@ -228,6 +228,11 @@ static int xt_ct_tg_check(const struct xt_tgchk_param *par,
 			goto err3;
 	}
 
+	if (info->flags & XT_CT_FLEX_ORIG)
+		set_bit(IPS_ORIG_FLEXTUPLE_BIT, &ct->status);
+	if (info->flags & XT_CT_FLEX_REPL)
+		set_bit(IPS_REPL_FLEXTUPLE_BIT, &ct->status);
+
 	nf_conntrack_tmpl_insert(par->net, ct);
 out:
 	info->ct = ct;
diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
index 29ba621..2fa6551 100644
--- a/net/netfilter/xt_connlimit.c
+++ b/net/netfilter/xt_connlimit.c
@@ -134,7 +134,7 @@ static bool add_hlist(struct hlist_head *head,
 static unsigned int check_hlist(struct net *net,
 				struct hlist_head *head,
 				const struct nf_conntrack_tuple *tuple,
-				u16 zone,
+				u16 zone, u32 mark,
 				bool *addit)
 {
 	const struct nf_conntrack_tuple_hash *found;
@@ -148,7 +148,7 @@ static unsigned int check_hlist(struct net *net,
 
 	/* check the saved connections */
 	hlist_for_each_entry_safe(conn, n, head, node) {
-		found = nf_conntrack_find_get(net, zone, &conn->tuple);
+		found = nf_conntrack_find_get(net, zone, mark, &conn->tuple);
 		if (found == NULL) {
 			hlist_del(&conn->node);
 			kmem_cache_free(connlimit_conn_cachep, conn);
@@ -201,7 +201,7 @@ static unsigned int
 count_tree(struct net *net, struct rb_root *root,
 	   const struct nf_conntrack_tuple *tuple,
 	   const union nf_inet_addr *addr, const union nf_inet_addr *mask,
-	   u8 family, u16 zone)
+	   u8 family, u16 zone, u32 mark)
 {
 	struct xt_connlimit_rb *gc_nodes[CONNLIMIT_GC_MAX_NODES];
 	struct rb_node **rbnode, *parent;
@@ -229,7 +229,8 @@ count_tree(struct net *net, struct rb_root *root,
 		} else {
 			/* same source network -> be counted! */
 			unsigned int count;
-			count = check_hlist(net, &rbconn->hhead, tuple, zone, &addit);
+			count = check_hlist(net, &rbconn->hhead, tuple, zone,
+					    mark, &addit);
 
 			tree_nodes_free(root, gc_nodes, gc_count);
 			if (!addit)
@@ -245,7 +246,7 @@ count_tree(struct net *net, struct rb_root *root,
 			continue;
 
 		/* only used for GC on hhead, retval and 'addit' ignored */
-		check_hlist(net, &rbconn->hhead, tuple, zone, &addit);
+		check_hlist(net, &rbconn->hhead, tuple, zone, mark, &addit);
 		if (hlist_empty(&rbconn->hhead))
 			gc_nodes[gc_count++] = rbconn;
 	}
@@ -290,7 +291,7 @@ static int count_them(struct net *net,
 		      const struct nf_conntrack_tuple *tuple,
 		      const union nf_inet_addr *addr,
 		      const union nf_inet_addr *mask,
-		      u_int8_t family, u16 zone)
+		      u_int8_t family, u16 zone, u32 mark)
 {
 	struct rb_root *root;
 	int count;
@@ -306,7 +307,7 @@ static int count_them(struct net *net,
 
 	spin_lock_bh(&xt_connlimit_locks[hash % CONNLIMIT_LOCK_SLOTS]);
 
-	count = count_tree(net, root, tuple, addr, mask, family, zone);
+	count = count_tree(net, root, tuple, addr, mask, family, zone, mark);
 
 	spin_unlock_bh(&xt_connlimit_locks[hash % CONNLIMIT_LOCK_SLOTS]);
 
@@ -346,7 +347,7 @@ connlimit_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	}
 
 	connections = count_them(net, info->data, tuple_ptr, &addr,
-	                         &info->mask, par->family, zone);
+	                         &info->mask, par->family, zone, skb->mark);
 	if (connections == 0)
 		/* kmalloc failed, drop it entirely */
 		goto hotdrop;
diff --git a/net/sched/act_connmark.c b/net/sched/act_connmark.c
index 8e47251..a0385f3 100644
--- a/net/sched/act_connmark.c
+++ b/net/sched/act_connmark.c
@@ -71,7 +71,8 @@ static int tcf_connmark(struct sk_buff *skb, const struct tc_action *a,
 			       proto, &tuple))
 		goto out;
 
-	thash = nf_conntrack_find_get(dev_net(skb->dev), ca->zone, &tuple);
+	thash = nf_conntrack_find_get(dev_net(skb->dev), ca->zone,
+				      skb->mark, &tuple);
 	if (!thash)
 		goto out;
 
-- 
1.9.3

