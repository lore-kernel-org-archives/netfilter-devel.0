From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 29/51] netfilter: add NAT support for shifted portmap ranges
Date: Mon,  7 May 2018 00:46:47 +0200
Message-ID: <20180506224709.29100-30-pablo@netfilter.org>
References: <20180506224709.29100-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180506224709.29100-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Thierry Du Tre <thierry@dtsystems.be>

This is a patch proposal to support shifted ranges in portmaps.  (i.e. tcp/udp
incoming port 5000-5100 on WAN redirected to LAN 192.168.1.5:2000-2100)

Currently DNAT only works for single port or identical port ranges.  (i.e.
ports 5000-5100 on WAN interface redirected to a LAN host while original
destination port is not altered) When different port ranges are configured,
either 'random' mode should be used, or else all incoming connections are
mapped onto the first port in the redirect range. (in described example
WAN:5000-5100 will all be mapped to 192.168.1.5:2000)

This patch introduces a new mode indicated by flag NF_NAT_RANGE_PROTO_OFFSET
which uses a base port value to calculate an offset with the destination port
present in the incoming stream. That offset is then applied as index within the
redirect port range (index modulo rangewidth to handle range overflow).

In described example the base port would be 5000. An incoming stream with
destination port 5004 would result in an offset value 4 which means that the
NAT'ed stream will be using destination port 2004.

Other possibilities include deterministic mapping of larger or multiple ranges
to a smaller range : WAN:5000-5999 -> LAN:5000-5099 (maps WAN port 5*xx to port
51xx)

This patch does not change any current behavior. It just adds new NAT proto
range functionality which must be selected via the specific flag when intended
to use.

A patch for iptables (libipt_DNAT.c + libip6t_DNAT.c) will also be proposed
which makes this functionality immediately available.

Signed-off-by: Thierry Du Tre <thierry@dtsystems.be>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/ipv4/nf_nat_masquerade.h |  2 +-
 include/net/netfilter/ipv6/nf_nat_masquerade.h |  2 +-
 include/net/netfilter/nf_nat.h                 |  2 +-
 include/net/netfilter/nf_nat_l3proto.h         |  4 +-
 include/net/netfilter/nf_nat_l4proto.h         |  8 +--
 include/net/netfilter/nf_nat_redirect.h        |  2 +-
 include/uapi/linux/netfilter/nf_nat.h          | 12 ++++-
 net/ipv4/netfilter/ipt_MASQUERADE.c            |  2 +-
 net/ipv4/netfilter/nf_nat_h323.c               |  4 +-
 net/ipv4/netfilter/nf_nat_l3proto_ipv4.c       |  4 +-
 net/ipv4/netfilter/nf_nat_masquerade_ipv4.c    |  4 +-
 net/ipv4/netfilter/nf_nat_pptp.c               |  2 +-
 net/ipv4/netfilter/nf_nat_proto_gre.c          |  2 +-
 net/ipv4/netfilter/nf_nat_proto_icmp.c         |  2 +-
 net/ipv4/netfilter/nft_masq_ipv4.c             |  2 +-
 net/ipv6/netfilter/ip6t_MASQUERADE.c           |  2 +-
 net/ipv6/netfilter/nf_nat_l3proto_ipv6.c       |  4 +-
 net/ipv6/netfilter/nf_nat_masquerade_ipv6.c    |  4 +-
 net/ipv6/netfilter/nf_nat_proto_icmpv6.c       |  2 +-
 net/ipv6/netfilter/nft_masq_ipv6.c             |  2 +-
 net/ipv6/netfilter/nft_redir_ipv6.c            |  2 +-
 net/netfilter/nf_nat_core.c                    | 27 +++++-----
 net/netfilter/nf_nat_helper.c                  |  2 +-
 net/netfilter/nf_nat_proto_common.c            |  9 ++--
 net/netfilter/nf_nat_proto_dccp.c              |  2 +-
 net/netfilter/nf_nat_proto_sctp.c              |  2 +-
 net/netfilter/nf_nat_proto_tcp.c               |  2 +-
 net/netfilter/nf_nat_proto_udp.c               |  4 +-
 net/netfilter/nf_nat_proto_unknown.c           |  2 +-
 net/netfilter/nf_nat_redirect.c                |  6 +--
 net/netfilter/nf_nat_sip.c                     |  2 +-
 net/netfilter/nft_nat.c                        |  2 +-
 net/netfilter/xt_NETMAP.c                      |  8 +--
 net/netfilter/xt_REDIRECT.c                    |  2 +-
 net/netfilter/xt_nat.c                         | 72 +++++++++++++++++++++++---
 net/openvswitch/conntrack.c                    |  4 +-
 36 files changed, 145 insertions(+), 71 deletions(-)

diff --git a/include/net/netfilter/ipv4/nf_nat_masquerade.h b/include/net/netfilter/ipv4/nf_nat_masquerade.h
index ebd869473603..cd24be4c4a99 100644
--- a/include/net/netfilter/ipv4/nf_nat_masquerade.h
+++ b/include/net/netfilter/ipv4/nf_nat_masquerade.h
@@ -6,7 +6,7 @@
 
 unsigned int
 nf_nat_masquerade_ipv4(struct sk_buff *skb, unsigned int hooknum,
-		       const struct nf_nat_range *range,
+		       const struct nf_nat_range2 *range,
 		       const struct net_device *out);
 
 void nf_nat_masquerade_ipv4_register_notifier(void);
diff --git a/include/net/netfilter/ipv6/nf_nat_masquerade.h b/include/net/netfilter/ipv6/nf_nat_masquerade.h
index 1ed4f2631ed6..0c3b5ebf0bb8 100644
--- a/include/net/netfilter/ipv6/nf_nat_masquerade.h
+++ b/include/net/netfilter/ipv6/nf_nat_masquerade.h
@@ -3,7 +3,7 @@
 #define _NF_NAT_MASQUERADE_IPV6_H_
 
 unsigned int
-nf_nat_masquerade_ipv6(struct sk_buff *skb, const struct nf_nat_range *range,
+nf_nat_masquerade_ipv6(struct sk_buff *skb, const struct nf_nat_range2 *range,
 		       const struct net_device *out);
 void nf_nat_masquerade_ipv6_register_notifier(void);
 void nf_nat_masquerade_ipv6_unregister_notifier(void);
diff --git a/include/net/netfilter/nf_nat.h b/include/net/netfilter/nf_nat.h
index 207a467e7ca6..da3d601cadee 100644
--- a/include/net/netfilter/nf_nat.h
+++ b/include/net/netfilter/nf_nat.h
@@ -39,7 +39,7 @@ struct nf_conn_nat {
 
 /* Set up the info structure to map into this range. */
 unsigned int nf_nat_setup_info(struct nf_conn *ct,
-			       const struct nf_nat_range *range,
+			       const struct nf_nat_range2 *range,
 			       enum nf_nat_manip_type maniptype);
 
 extern unsigned int nf_nat_alloc_null_binding(struct nf_conn *ct,
diff --git a/include/net/netfilter/nf_nat_l3proto.h b/include/net/netfilter/nf_nat_l3proto.h
index ce7c2b4e64bb..ac47098a61dc 100644
--- a/include/net/netfilter/nf_nat_l3proto.h
+++ b/include/net/netfilter/nf_nat_l3proto.h
@@ -7,7 +7,7 @@ struct nf_nat_l3proto {
 	u8	l3proto;
 
 	bool	(*in_range)(const struct nf_conntrack_tuple *t,
-			    const struct nf_nat_range *range);
+			    const struct nf_nat_range2 *range);
 
 	u32 	(*secure_port)(const struct nf_conntrack_tuple *t, __be16);
 
@@ -33,7 +33,7 @@ struct nf_nat_l3proto {
 				  struct flowi *fl);
 
 	int	(*nlattr_to_range)(struct nlattr *tb[],
-				   struct nf_nat_range *range);
+				   struct nf_nat_range2 *range);
 };
 
 int nf_nat_l3proto_register(const struct nf_nat_l3proto *);
diff --git a/include/net/netfilter/nf_nat_l4proto.h b/include/net/netfilter/nf_nat_l4proto.h
index 67835ff8a2d9..b4d6b29bca62 100644
--- a/include/net/netfilter/nf_nat_l4proto.h
+++ b/include/net/netfilter/nf_nat_l4proto.h
@@ -34,12 +34,12 @@ struct nf_nat_l4proto {
 	 */
 	void (*unique_tuple)(const struct nf_nat_l3proto *l3proto,
 			     struct nf_conntrack_tuple *tuple,
-			     const struct nf_nat_range *range,
+			     const struct nf_nat_range2 *range,
 			     enum nf_nat_manip_type maniptype,
 			     const struct nf_conn *ct);
 
 	int (*nlattr_to_range)(struct nlattr *tb[],
-			       struct nf_nat_range *range);
+			       struct nf_nat_range2 *range);
 };
 
 /* Protocol registration. */
@@ -72,11 +72,11 @@ bool nf_nat_l4proto_in_range(const struct nf_conntrack_tuple *tuple,
 
 void nf_nat_l4proto_unique_tuple(const struct nf_nat_l3proto *l3proto,
 				 struct nf_conntrack_tuple *tuple,
-				 const struct nf_nat_range *range,
+				 const struct nf_nat_range2 *range,
 				 enum nf_nat_manip_type maniptype,
 				 const struct nf_conn *ct, u16 *rover);
 
 int nf_nat_l4proto_nlattr_to_range(struct nlattr *tb[],
-				   struct nf_nat_range *range);
+				   struct nf_nat_range2 *range);
 
 #endif /*_NF_NAT_L4PROTO_H*/
diff --git a/include/net/netfilter/nf_nat_redirect.h b/include/net/netfilter/nf_nat_redirect.h
index 5ddabb08c472..c129aacc8ae8 100644
--- a/include/net/netfilter/nf_nat_redirect.h
+++ b/include/net/netfilter/nf_nat_redirect.h
@@ -7,7 +7,7 @@ nf_nat_redirect_ipv4(struct sk_buff *skb,
 		     const struct nf_nat_ipv4_multi_range_compat *mr,
 		     unsigned int hooknum);
 unsigned int
-nf_nat_redirect_ipv6(struct sk_buff *skb, const struct nf_nat_range *range,
+nf_nat_redirect_ipv6(struct sk_buff *skb, const struct nf_nat_range2 *range,
 		     unsigned int hooknum);
 
 #endif /* _NF_NAT_REDIRECT_H_ */
diff --git a/include/uapi/linux/netfilter/nf_nat.h b/include/uapi/linux/netfilter/nf_nat.h
index a33000da7229..4a95c0db14d4 100644
--- a/include/uapi/linux/netfilter/nf_nat.h
+++ b/include/uapi/linux/netfilter/nf_nat.h
@@ -10,6 +10,7 @@
 #define NF_NAT_RANGE_PROTO_RANDOM		(1 << 2)
 #define NF_NAT_RANGE_PERSISTENT			(1 << 3)
 #define NF_NAT_RANGE_PROTO_RANDOM_FULLY		(1 << 4)
+#define NF_NAT_RANGE_PROTO_OFFSET		(1 << 5)
 
 #define NF_NAT_RANGE_PROTO_RANDOM_ALL		\
 	(NF_NAT_RANGE_PROTO_RANDOM | NF_NAT_RANGE_PROTO_RANDOM_FULLY)
@@ -17,7 +18,7 @@
 #define NF_NAT_RANGE_MASK					\
 	(NF_NAT_RANGE_MAP_IPS | NF_NAT_RANGE_PROTO_SPECIFIED |	\
 	 NF_NAT_RANGE_PROTO_RANDOM | NF_NAT_RANGE_PERSISTENT |	\
-	 NF_NAT_RANGE_PROTO_RANDOM_FULLY)
+	 NF_NAT_RANGE_PROTO_RANDOM_FULLY | NF_NAT_RANGE_PROTO_OFFSET)
 
 struct nf_nat_ipv4_range {
 	unsigned int			flags;
@@ -40,4 +41,13 @@ struct nf_nat_range {
 	union nf_conntrack_man_proto	max_proto;
 };
 
+struct nf_nat_range2 {
+	unsigned int			flags;
+	union nf_inet_addr		min_addr;
+	union nf_inet_addr		max_addr;
+	union nf_conntrack_man_proto	min_proto;
+	union nf_conntrack_man_proto	max_proto;
+	union nf_conntrack_man_proto	base_proto;
+};
+
 #endif /* _NETFILTER_NF_NAT_H */
diff --git a/net/ipv4/netfilter/ipt_MASQUERADE.c b/net/ipv4/netfilter/ipt_MASQUERADE.c
index a03e4e7ef5f9..ce1512b02cb2 100644
--- a/net/ipv4/netfilter/ipt_MASQUERADE.c
+++ b/net/ipv4/netfilter/ipt_MASQUERADE.c
@@ -47,7 +47,7 @@ static int masquerade_tg_check(const struct xt_tgchk_param *par)
 static unsigned int
 masquerade_tg(struct sk_buff *skb, const struct xt_action_param *par)
 {
-	struct nf_nat_range range;
+	struct nf_nat_range2 range;
 	const struct nf_nat_ipv4_multi_range_compat *mr;
 
 	mr = par->targinfo;
diff --git a/net/ipv4/netfilter/nf_nat_h323.c b/net/ipv4/netfilter/nf_nat_h323.c
index ac8342dcb55e..4e6b53ab6c33 100644
--- a/net/ipv4/netfilter/nf_nat_h323.c
+++ b/net/ipv4/netfilter/nf_nat_h323.c
@@ -395,7 +395,7 @@ static int nat_h245(struct sk_buff *skb, struct nf_conn *ct,
 static void ip_nat_q931_expect(struct nf_conn *new,
 			       struct nf_conntrack_expect *this)
 {
-	struct nf_nat_range range;
+	struct nf_nat_range2 range;
 
 	if (this->tuple.src.u3.ip != 0) {	/* Only accept calls from GK */
 		nf_nat_follow_master(new, this);
@@ -497,7 +497,7 @@ static int nat_q931(struct sk_buff *skb, struct nf_conn *ct,
 static void ip_nat_callforwarding_expect(struct nf_conn *new,
 					 struct nf_conntrack_expect *this)
 {
-	struct nf_nat_range range;
+	struct nf_nat_range2 range;
 
 	/* This must be a fresh one. */
 	BUG_ON(new->status & IPS_NAT_DONE_MASK);
diff --git a/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c b/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
index f7ff6a364d7b..4346336cee4c 100644
--- a/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
@@ -63,7 +63,7 @@ static void nf_nat_ipv4_decode_session(struct sk_buff *skb,
 #endif /* CONFIG_XFRM */
 
 static bool nf_nat_ipv4_in_range(const struct nf_conntrack_tuple *t,
-				 const struct nf_nat_range *range)
+				 const struct nf_nat_range2 *range)
 {
 	return ntohl(t->src.u3.ip) >= ntohl(range->min_addr.ip) &&
 	       ntohl(t->src.u3.ip) <= ntohl(range->max_addr.ip);
@@ -143,7 +143,7 @@ static void nf_nat_ipv4_csum_recalc(struct sk_buff *skb,
 
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 static int nf_nat_ipv4_nlattr_to_range(struct nlattr *tb[],
-				       struct nf_nat_range *range)
+				       struct nf_nat_range2 *range)
 {
 	if (tb[CTA_NAT_V4_MINIP]) {
 		range->min_addr.ip = nla_get_be32(tb[CTA_NAT_V4_MINIP]);
diff --git a/net/ipv4/netfilter/nf_nat_masquerade_ipv4.c b/net/ipv4/netfilter/nf_nat_masquerade_ipv4.c
index 0c366aad89cb..f538c5001547 100644
--- a/net/ipv4/netfilter/nf_nat_masquerade_ipv4.c
+++ b/net/ipv4/netfilter/nf_nat_masquerade_ipv4.c
@@ -24,13 +24,13 @@
 
 unsigned int
 nf_nat_masquerade_ipv4(struct sk_buff *skb, unsigned int hooknum,
-		       const struct nf_nat_range *range,
+		       const struct nf_nat_range2 *range,
 		       const struct net_device *out)
 {
 	struct nf_conn *ct;
 	struct nf_conn_nat *nat;
 	enum ip_conntrack_info ctinfo;
-	struct nf_nat_range newrange;
+	struct nf_nat_range2 newrange;
 	const struct rtable *rt;
 	__be32 newsrc, nh;
 
diff --git a/net/ipv4/netfilter/nf_nat_pptp.c b/net/ipv4/netfilter/nf_nat_pptp.c
index 8a69363b4884..5d259a12e25f 100644
--- a/net/ipv4/netfilter/nf_nat_pptp.c
+++ b/net/ipv4/netfilter/nf_nat_pptp.c
@@ -48,7 +48,7 @@ static void pptp_nat_expected(struct nf_conn *ct,
 	struct nf_conntrack_tuple t = {};
 	const struct nf_ct_pptp_master *ct_pptp_info;
 	const struct nf_nat_pptp *nat_pptp_info;
-	struct nf_nat_range range;
+	struct nf_nat_range2 range;
 	struct nf_conn_nat *nat;
 
 	nat = nf_ct_nat_ext_add(ct);
diff --git a/net/ipv4/netfilter/nf_nat_proto_gre.c b/net/ipv4/netfilter/nf_nat_proto_gre.c
index edf05002d674..00fda6331ce5 100644
--- a/net/ipv4/netfilter/nf_nat_proto_gre.c
+++ b/net/ipv4/netfilter/nf_nat_proto_gre.c
@@ -41,7 +41,7 @@ MODULE_DESCRIPTION("Netfilter NAT protocol helper module for GRE");
 static void
 gre_unique_tuple(const struct nf_nat_l3proto *l3proto,
 		 struct nf_conntrack_tuple *tuple,
-		 const struct nf_nat_range *range,
+		 const struct nf_nat_range2 *range,
 		 enum nf_nat_manip_type maniptype,
 		 const struct nf_conn *ct)
 {
diff --git a/net/ipv4/netfilter/nf_nat_proto_icmp.c b/net/ipv4/netfilter/nf_nat_proto_icmp.c
index 7b98baa13ede..6d7cf1d79baf 100644
--- a/net/ipv4/netfilter/nf_nat_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_nat_proto_icmp.c
@@ -30,7 +30,7 @@ icmp_in_range(const struct nf_conntrack_tuple *tuple,
 static void
 icmp_unique_tuple(const struct nf_nat_l3proto *l3proto,
 		  struct nf_conntrack_tuple *tuple,
-		  const struct nf_nat_range *range,
+		  const struct nf_nat_range2 *range,
 		  enum nf_nat_manip_type maniptype,
 		  const struct nf_conn *ct)
 {
diff --git a/net/ipv4/netfilter/nft_masq_ipv4.c b/net/ipv4/netfilter/nft_masq_ipv4.c
index f18677277119..f1193e1e928a 100644
--- a/net/ipv4/netfilter/nft_masq_ipv4.c
+++ b/net/ipv4/netfilter/nft_masq_ipv4.c
@@ -21,7 +21,7 @@ static void nft_masq_ipv4_eval(const struct nft_expr *expr,
 			       const struct nft_pktinfo *pkt)
 {
 	struct nft_masq *priv = nft_expr_priv(expr);
-	struct nf_nat_range range;
+	struct nf_nat_range2 range;
 
 	memset(&range, 0, sizeof(range));
 	range.flags = priv->flags;
diff --git a/net/ipv6/netfilter/ip6t_MASQUERADE.c b/net/ipv6/netfilter/ip6t_MASQUERADE.c
index 92c0047e7e33..491f808e356a 100644
--- a/net/ipv6/netfilter/ip6t_MASQUERADE.c
+++ b/net/ipv6/netfilter/ip6t_MASQUERADE.c
@@ -29,7 +29,7 @@ masquerade_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 
 static int masquerade_tg6_checkentry(const struct xt_tgchk_param *par)
 {
-	const struct nf_nat_range *range = par->targinfo;
+	const struct nf_nat_range2 *range = par->targinfo;
 
 	if (range->flags & NF_NAT_RANGE_MAP_IPS)
 		return -EINVAL;
diff --git a/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c b/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c
index 6b7f075f811f..56d75eb5448f 100644
--- a/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c
@@ -62,7 +62,7 @@ static void nf_nat_ipv6_decode_session(struct sk_buff *skb,
 #endif
 
 static bool nf_nat_ipv6_in_range(const struct nf_conntrack_tuple *t,
-				 const struct nf_nat_range *range)
+				 const struct nf_nat_range2 *range)
 {
 	return ipv6_addr_cmp(&t->src.u3.in6, &range->min_addr.in6) >= 0 &&
 	       ipv6_addr_cmp(&t->src.u3.in6, &range->max_addr.in6) <= 0;
@@ -151,7 +151,7 @@ static void nf_nat_ipv6_csum_recalc(struct sk_buff *skb,
 
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 static int nf_nat_ipv6_nlattr_to_range(struct nlattr *tb[],
-				       struct nf_nat_range *range)
+				       struct nf_nat_range2 *range)
 {
 	if (tb[CTA_NAT_V6_MINIP]) {
 		nla_memcpy(&range->min_addr.ip6, tb[CTA_NAT_V6_MINIP],
diff --git a/net/ipv6/netfilter/nf_nat_masquerade_ipv6.c b/net/ipv6/netfilter/nf_nat_masquerade_ipv6.c
index 98f61fcb9108..9dfc2b90c362 100644
--- a/net/ipv6/netfilter/nf_nat_masquerade_ipv6.c
+++ b/net/ipv6/netfilter/nf_nat_masquerade_ipv6.c
@@ -26,14 +26,14 @@
 static atomic_t v6_worker_count;
 
 unsigned int
-nf_nat_masquerade_ipv6(struct sk_buff *skb, const struct nf_nat_range *range,
+nf_nat_masquerade_ipv6(struct sk_buff *skb, const struct nf_nat_range2 *range,
 		       const struct net_device *out)
 {
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn_nat *nat;
 	struct in6_addr src;
 	struct nf_conn *ct;
-	struct nf_nat_range newrange;
+	struct nf_nat_range2 newrange;
 
 	ct = nf_ct_get(skb, &ctinfo);
 	WARN_ON(!(ct && (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED ||
diff --git a/net/ipv6/netfilter/nf_nat_proto_icmpv6.c b/net/ipv6/netfilter/nf_nat_proto_icmpv6.c
index 57593b00c5b4..d9bf42ba44fa 100644
--- a/net/ipv6/netfilter/nf_nat_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_nat_proto_icmpv6.c
@@ -32,7 +32,7 @@ icmpv6_in_range(const struct nf_conntrack_tuple *tuple,
 static void
 icmpv6_unique_tuple(const struct nf_nat_l3proto *l3proto,
 		    struct nf_conntrack_tuple *tuple,
-		    const struct nf_nat_range *range,
+		    const struct nf_nat_range2 *range,
 		    enum nf_nat_manip_type maniptype,
 		    const struct nf_conn *ct)
 {
diff --git a/net/ipv6/netfilter/nft_masq_ipv6.c b/net/ipv6/netfilter/nft_masq_ipv6.c
index 4146536e9c15..dd0122f3cffe 100644
--- a/net/ipv6/netfilter/nft_masq_ipv6.c
+++ b/net/ipv6/netfilter/nft_masq_ipv6.c
@@ -22,7 +22,7 @@ static void nft_masq_ipv6_eval(const struct nft_expr *expr,
 			       const struct nft_pktinfo *pkt)
 {
 	struct nft_masq *priv = nft_expr_priv(expr);
-	struct nf_nat_range range;
+	struct nf_nat_range2 range;
 
 	memset(&range, 0, sizeof(range));
 	range.flags = priv->flags;
diff --git a/net/ipv6/netfilter/nft_redir_ipv6.c b/net/ipv6/netfilter/nft_redir_ipv6.c
index a27e424f690d..74269865acc8 100644
--- a/net/ipv6/netfilter/nft_redir_ipv6.c
+++ b/net/ipv6/netfilter/nft_redir_ipv6.c
@@ -22,7 +22,7 @@ static void nft_redir_ipv6_eval(const struct nft_expr *expr,
 				const struct nft_pktinfo *pkt)
 {
 	struct nft_redir *priv = nft_expr_priv(expr);
-	struct nf_nat_range range;
+	struct nf_nat_range2 range;
 
 	memset(&range, 0, sizeof(range));
 	if (priv->sreg_proto_min) {
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 617693ff9f4c..37b3c9913b08 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -157,7 +157,7 @@ EXPORT_SYMBOL(nf_nat_used_tuple);
 static int in_range(const struct nf_nat_l3proto *l3proto,
 		    const struct nf_nat_l4proto *l4proto,
 		    const struct nf_conntrack_tuple *tuple,
-		    const struct nf_nat_range *range)
+		    const struct nf_nat_range2 *range)
 {
 	/* If we are supposed to map IPs, then we must be in the
 	 * range specified, otherwise let this drag us onto a new src IP.
@@ -194,7 +194,7 @@ find_appropriate_src(struct net *net,
 		     const struct nf_nat_l4proto *l4proto,
 		     const struct nf_conntrack_tuple *tuple,
 		     struct nf_conntrack_tuple *result,
-		     const struct nf_nat_range *range)
+		     const struct nf_nat_range2 *range)
 {
 	unsigned int h = hash_by_src(net, tuple);
 	const struct nf_conn *ct;
@@ -224,7 +224,7 @@ find_appropriate_src(struct net *net,
 static void
 find_best_ips_proto(const struct nf_conntrack_zone *zone,
 		    struct nf_conntrack_tuple *tuple,
-		    const struct nf_nat_range *range,
+		    const struct nf_nat_range2 *range,
 		    const struct nf_conn *ct,
 		    enum nf_nat_manip_type maniptype)
 {
@@ -298,7 +298,7 @@ find_best_ips_proto(const struct nf_conntrack_zone *zone,
 static void
 get_unique_tuple(struct nf_conntrack_tuple *tuple,
 		 const struct nf_conntrack_tuple *orig_tuple,
-		 const struct nf_nat_range *range,
+		 const struct nf_nat_range2 *range,
 		 struct nf_conn *ct,
 		 enum nf_nat_manip_type maniptype)
 {
@@ -349,9 +349,10 @@ get_unique_tuple(struct nf_conntrack_tuple *tuple,
 	/* Only bother mapping if it's not already in range and unique */
 	if (!(range->flags & NF_NAT_RANGE_PROTO_RANDOM_ALL)) {
 		if (range->flags & NF_NAT_RANGE_PROTO_SPECIFIED) {
-			if (l4proto->in_range(tuple, maniptype,
-					      &range->min_proto,
-					      &range->max_proto) &&
+			if (!(range->flags & NF_NAT_RANGE_PROTO_OFFSET) &&
+			    l4proto->in_range(tuple, maniptype,
+			          &range->min_proto,
+			          &range->max_proto) &&
 			    (range->min_proto.all == range->max_proto.all ||
 			     !nf_nat_used_tuple(tuple, ct)))
 				goto out;
@@ -360,7 +361,7 @@ get_unique_tuple(struct nf_conntrack_tuple *tuple,
 		}
 	}
 
-	/* Last change: get protocol to try to obtain unique tuple. */
+	/* Last chance: get protocol to try to obtain unique tuple. */
 	l4proto->unique_tuple(l3proto, tuple, range, maniptype, ct);
 out:
 	rcu_read_unlock();
@@ -381,7 +382,7 @@ EXPORT_SYMBOL_GPL(nf_ct_nat_ext_add);
 
 unsigned int
 nf_nat_setup_info(struct nf_conn *ct,
-		  const struct nf_nat_range *range,
+		  const struct nf_nat_range2 *range,
 		  enum nf_nat_manip_type maniptype)
 {
 	struct net *net = nf_ct_net(ct);
@@ -459,7 +460,7 @@ __nf_nat_alloc_null_binding(struct nf_conn *ct, enum nf_nat_manip_type manip)
 		(manip == NF_NAT_MANIP_SRC ?
 		ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u3 :
 		ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.u3);
-	struct nf_nat_range range = {
+	struct nf_nat_range2 range = {
 		.flags		= NF_NAT_RANGE_MAP_IPS,
 		.min_addr	= ip,
 		.max_addr	= ip,
@@ -702,7 +703,7 @@ static const struct nla_policy protonat_nla_policy[CTA_PROTONAT_MAX+1] = {
 
 static int nfnetlink_parse_nat_proto(struct nlattr *attr,
 				     const struct nf_conn *ct,
-				     struct nf_nat_range *range)
+				     struct nf_nat_range2 *range)
 {
 	struct nlattr *tb[CTA_PROTONAT_MAX+1];
 	const struct nf_nat_l4proto *l4proto;
@@ -730,7 +731,7 @@ static const struct nla_policy nat_nla_policy[CTA_NAT_MAX+1] = {
 
 static int
 nfnetlink_parse_nat(const struct nlattr *nat,
-		    const struct nf_conn *ct, struct nf_nat_range *range,
+		    const struct nf_conn *ct, struct nf_nat_range2 *range,
 		    const struct nf_nat_l3proto *l3proto)
 {
 	struct nlattr *tb[CTA_NAT_MAX+1];
@@ -758,7 +759,7 @@ nfnetlink_parse_nat_setup(struct nf_conn *ct,
 			  enum nf_nat_manip_type manip,
 			  const struct nlattr *attr)
 {
-	struct nf_nat_range range;
+	struct nf_nat_range2 range;
 	const struct nf_nat_l3proto *l3proto;
 	int err;
 
diff --git a/net/netfilter/nf_nat_helper.c b/net/netfilter/nf_nat_helper.c
index 607a373379b4..99606baedda4 100644
--- a/net/netfilter/nf_nat_helper.c
+++ b/net/netfilter/nf_nat_helper.c
@@ -191,7 +191,7 @@ EXPORT_SYMBOL(nf_nat_mangle_udp_packet);
 void nf_nat_follow_master(struct nf_conn *ct,
 			  struct nf_conntrack_expect *exp)
 {
-	struct nf_nat_range range;
+	struct nf_nat_range2 range;
 
 	/* This must be a fresh one. */
 	BUG_ON(ct->status & IPS_NAT_DONE_MASK);
diff --git a/net/netfilter/nf_nat_proto_common.c b/net/netfilter/nf_nat_proto_common.c
index 7d7466dbf663..5d849d835561 100644
--- a/net/netfilter/nf_nat_proto_common.c
+++ b/net/netfilter/nf_nat_proto_common.c
@@ -36,7 +36,7 @@ EXPORT_SYMBOL_GPL(nf_nat_l4proto_in_range);
 
 void nf_nat_l4proto_unique_tuple(const struct nf_nat_l3proto *l3proto,
 				 struct nf_conntrack_tuple *tuple,
-				 const struct nf_nat_range *range,
+				 const struct nf_nat_range2 *range,
 				 enum nf_nat_manip_type maniptype,
 				 const struct nf_conn *ct,
 				 u16 *rover)
@@ -83,6 +83,8 @@ void nf_nat_l4proto_unique_tuple(const struct nf_nat_l3proto *l3proto,
 						  : tuple->src.u.all);
 	} else if (range->flags & NF_NAT_RANGE_PROTO_RANDOM_FULLY) {
 		off = prandom_u32();
+	} else if (range->flags & NF_NAT_RANGE_PROTO_OFFSET) {
+		off = (ntohs(*portptr) - ntohs(range->base_proto.all));
 	} else {
 		off = *rover;
 	}
@@ -91,7 +93,8 @@ void nf_nat_l4proto_unique_tuple(const struct nf_nat_l3proto *l3proto,
 		*portptr = htons(min + off % range_size);
 		if (++i != range_size && nf_nat_used_tuple(tuple, ct))
 			continue;
-		if (!(range->flags & NF_NAT_RANGE_PROTO_RANDOM_ALL))
+		if (!(range->flags & (NF_NAT_RANGE_PROTO_RANDOM_ALL|
+					NF_NAT_RANGE_PROTO_OFFSET)))
 			*rover = off;
 		return;
 	}
@@ -100,7 +103,7 @@ EXPORT_SYMBOL_GPL(nf_nat_l4proto_unique_tuple);
 
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 int nf_nat_l4proto_nlattr_to_range(struct nlattr *tb[],
-				   struct nf_nat_range *range)
+				   struct nf_nat_range2 *range)
 {
 	if (tb[CTA_PROTONAT_PORT_MIN]) {
 		range->min_proto.all = nla_get_be16(tb[CTA_PROTONAT_PORT_MIN]);
diff --git a/net/netfilter/nf_nat_proto_dccp.c b/net/netfilter/nf_nat_proto_dccp.c
index 269fcd5dc34c..67ea0d83aa5a 100644
--- a/net/netfilter/nf_nat_proto_dccp.c
+++ b/net/netfilter/nf_nat_proto_dccp.c
@@ -23,7 +23,7 @@ static u_int16_t dccp_port_rover;
 static void
 dccp_unique_tuple(const struct nf_nat_l3proto *l3proto,
 		  struct nf_conntrack_tuple *tuple,
-		  const struct nf_nat_range *range,
+		  const struct nf_nat_range2 *range,
 		  enum nf_nat_manip_type maniptype,
 		  const struct nf_conn *ct)
 {
diff --git a/net/netfilter/nf_nat_proto_sctp.c b/net/netfilter/nf_nat_proto_sctp.c
index c57ee3240b1d..1c5d9b65fbba 100644
--- a/net/netfilter/nf_nat_proto_sctp.c
+++ b/net/netfilter/nf_nat_proto_sctp.c
@@ -17,7 +17,7 @@ static u_int16_t nf_sctp_port_rover;
 static void
 sctp_unique_tuple(const struct nf_nat_l3proto *l3proto,
 		  struct nf_conntrack_tuple *tuple,
-		  const struct nf_nat_range *range,
+		  const struct nf_nat_range2 *range,
 		  enum nf_nat_manip_type maniptype,
 		  const struct nf_conn *ct)
 {
diff --git a/net/netfilter/nf_nat_proto_tcp.c b/net/netfilter/nf_nat_proto_tcp.c
index 4f8820fc5148..f15fcd475f98 100644
--- a/net/netfilter/nf_nat_proto_tcp.c
+++ b/net/netfilter/nf_nat_proto_tcp.c
@@ -23,7 +23,7 @@ static u16 tcp_port_rover;
 static void
 tcp_unique_tuple(const struct nf_nat_l3proto *l3proto,
 		 struct nf_conntrack_tuple *tuple,
-		 const struct nf_nat_range *range,
+		 const struct nf_nat_range2 *range,
 		 enum nf_nat_manip_type maniptype,
 		 const struct nf_conn *ct)
 {
diff --git a/net/netfilter/nf_nat_proto_udp.c b/net/netfilter/nf_nat_proto_udp.c
index edd4a77dc09a..5790f70a83b2 100644
--- a/net/netfilter/nf_nat_proto_udp.c
+++ b/net/netfilter/nf_nat_proto_udp.c
@@ -22,7 +22,7 @@ static u16 udp_port_rover;
 static void
 udp_unique_tuple(const struct nf_nat_l3proto *l3proto,
 		 struct nf_conntrack_tuple *tuple,
-		 const struct nf_nat_range *range,
+		 const struct nf_nat_range2 *range,
 		 enum nf_nat_manip_type maniptype,
 		 const struct nf_conn *ct)
 {
@@ -100,7 +100,7 @@ static bool udplite_manip_pkt(struct sk_buff *skb,
 static void
 udplite_unique_tuple(const struct nf_nat_l3proto *l3proto,
 		     struct nf_conntrack_tuple *tuple,
-		     const struct nf_nat_range *range,
+		     const struct nf_nat_range2 *range,
 		     enum nf_nat_manip_type maniptype,
 		     const struct nf_conn *ct)
 {
diff --git a/net/netfilter/nf_nat_proto_unknown.c b/net/netfilter/nf_nat_proto_unknown.c
index 6e494d584412..c5db3e251232 100644
--- a/net/netfilter/nf_nat_proto_unknown.c
+++ b/net/netfilter/nf_nat_proto_unknown.c
@@ -27,7 +27,7 @@ static bool unknown_in_range(const struct nf_conntrack_tuple *tuple,
 
 static void unknown_unique_tuple(const struct nf_nat_l3proto *l3proto,
 				 struct nf_conntrack_tuple *tuple,
-				 const struct nf_nat_range *range,
+				 const struct nf_nat_range2 *range,
 				 enum nf_nat_manip_type maniptype,
 				 const struct nf_conn *ct)
 {
diff --git a/net/netfilter/nf_nat_redirect.c b/net/netfilter/nf_nat_redirect.c
index 25b06b959118..7c4bb0a773ca 100644
--- a/net/netfilter/nf_nat_redirect.c
+++ b/net/netfilter/nf_nat_redirect.c
@@ -36,7 +36,7 @@ nf_nat_redirect_ipv4(struct sk_buff *skb,
 	struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
 	__be32 newdst;
-	struct nf_nat_range newrange;
+	struct nf_nat_range2 newrange;
 
 	WARN_ON(hooknum != NF_INET_PRE_ROUTING &&
 		hooknum != NF_INET_LOCAL_OUT);
@@ -82,10 +82,10 @@ EXPORT_SYMBOL_GPL(nf_nat_redirect_ipv4);
 static const struct in6_addr loopback_addr = IN6ADDR_LOOPBACK_INIT;
 
 unsigned int
-nf_nat_redirect_ipv6(struct sk_buff *skb, const struct nf_nat_range *range,
+nf_nat_redirect_ipv6(struct sk_buff *skb, const struct nf_nat_range2 *range,
 		     unsigned int hooknum)
 {
-	struct nf_nat_range newrange;
+	struct nf_nat_range2 newrange;
 	struct in6_addr newdst;
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct;
diff --git a/net/netfilter/nf_nat_sip.c b/net/netfilter/nf_nat_sip.c
index 791fac4fd745..1f3086074981 100644
--- a/net/netfilter/nf_nat_sip.c
+++ b/net/netfilter/nf_nat_sip.c
@@ -316,7 +316,7 @@ static void nf_nat_sip_seq_adjust(struct sk_buff *skb, unsigned int protoff,
 static void nf_nat_sip_expected(struct nf_conn *ct,
 				struct nf_conntrack_expect *exp)
 {
-	struct nf_nat_range range;
+	struct nf_nat_range2 range;
 
 	/* This must be a fresh one. */
 	BUG_ON(ct->status & IPS_NAT_DONE_MASK);
diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index 1f36954c2ba9..c15807d10b91 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -43,7 +43,7 @@ static void nft_nat_eval(const struct nft_expr *expr,
 	const struct nft_nat *priv = nft_expr_priv(expr);
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct = nf_ct_get(pkt->skb, &ctinfo);
-	struct nf_nat_range range;
+	struct nf_nat_range2 range;
 
 	memset(&range, 0, sizeof(range));
 	if (priv->sreg_addr_min) {
diff --git a/net/netfilter/xt_NETMAP.c b/net/netfilter/xt_NETMAP.c
index 58aa9dd3c5b7..1d437875e15a 100644
--- a/net/netfilter/xt_NETMAP.c
+++ b/net/netfilter/xt_NETMAP.c
@@ -21,8 +21,8 @@
 static unsigned int
 netmap_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 {
-	const struct nf_nat_range *range = par->targinfo;
-	struct nf_nat_range newrange;
+	const struct nf_nat_range2 *range = par->targinfo;
+	struct nf_nat_range2 newrange;
 	struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
 	union nf_inet_addr new_addr, netmask;
@@ -56,7 +56,7 @@ netmap_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 
 static int netmap_tg6_checkentry(const struct xt_tgchk_param *par)
 {
-	const struct nf_nat_range *range = par->targinfo;
+	const struct nf_nat_range2 *range = par->targinfo;
 
 	if (!(range->flags & NF_NAT_RANGE_MAP_IPS))
 		return -EINVAL;
@@ -75,7 +75,7 @@ netmap_tg4(struct sk_buff *skb, const struct xt_action_param *par)
 	enum ip_conntrack_info ctinfo;
 	__be32 new_ip, netmask;
 	const struct nf_nat_ipv4_multi_range_compat *mr = par->targinfo;
-	struct nf_nat_range newrange;
+	struct nf_nat_range2 newrange;
 
 	WARN_ON(xt_hooknum(par) != NF_INET_PRE_ROUTING &&
 		xt_hooknum(par) != NF_INET_POST_ROUTING &&
diff --git a/net/netfilter/xt_REDIRECT.c b/net/netfilter/xt_REDIRECT.c
index 98a4c6d4f1cb..5ce9461e979c 100644
--- a/net/netfilter/xt_REDIRECT.c
+++ b/net/netfilter/xt_REDIRECT.c
@@ -36,7 +36,7 @@ redirect_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 
 static int redirect_tg6_checkentry(const struct xt_tgchk_param *par)
 {
-	const struct nf_nat_range *range = par->targinfo;
+	const struct nf_nat_range2 *range = par->targinfo;
 
 	if (range->flags & NF_NAT_RANGE_MAP_IPS)
 		return -EINVAL;
diff --git a/net/netfilter/xt_nat.c b/net/netfilter/xt_nat.c
index bdb689cdc829..8af9707f8789 100644
--- a/net/netfilter/xt_nat.c
+++ b/net/netfilter/xt_nat.c
@@ -37,11 +37,12 @@ static void xt_nat_destroy(const struct xt_tgdtor_param *par)
 	nf_ct_netns_put(par->net, par->family);
 }
 
-static void xt_nat_convert_range(struct nf_nat_range *dst,
+static void xt_nat_convert_range(struct nf_nat_range2 *dst,
 				 const struct nf_nat_ipv4_range *src)
 {
 	memset(&dst->min_addr, 0, sizeof(dst->min_addr));
 	memset(&dst->max_addr, 0, sizeof(dst->max_addr));
+	memset(&dst->base_proto, 0, sizeof(dst->base_proto));
 
 	dst->flags	 = src->flags;
 	dst->min_addr.ip = src->min_ip;
@@ -54,7 +55,7 @@ static unsigned int
 xt_snat_target_v0(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct nf_nat_ipv4_multi_range_compat *mr = par->targinfo;
-	struct nf_nat_range range;
+	struct nf_nat_range2 range;
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct;
 
@@ -71,7 +72,7 @@ static unsigned int
 xt_dnat_target_v0(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct nf_nat_ipv4_multi_range_compat *mr = par->targinfo;
-	struct nf_nat_range range;
+	struct nf_nat_range2 range;
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct;
 
@@ -86,7 +87,8 @@ xt_dnat_target_v0(struct sk_buff *skb, const struct xt_action_param *par)
 static unsigned int
 xt_snat_target_v1(struct sk_buff *skb, const struct xt_action_param *par)
 {
-	const struct nf_nat_range *range = par->targinfo;
+	const struct nf_nat_range *range_v1 = par->targinfo;
+	struct nf_nat_range2 range;
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct;
 
@@ -95,13 +97,49 @@ xt_snat_target_v1(struct sk_buff *skb, const struct xt_action_param *par)
 		 (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED ||
 		  ctinfo == IP_CT_RELATED_REPLY)));
 
-	return nf_nat_setup_info(ct, range, NF_NAT_MANIP_SRC);
+	memcpy(&range, range_v1, sizeof(*range_v1));
+	memset(&range.base_proto, 0, sizeof(range.base_proto));
+
+	return nf_nat_setup_info(ct, &range, NF_NAT_MANIP_SRC);
 }
 
 static unsigned int
 xt_dnat_target_v1(struct sk_buff *skb, const struct xt_action_param *par)
 {
-	const struct nf_nat_range *range = par->targinfo;
+	const struct nf_nat_range *range_v1 = par->targinfo;
+	struct nf_nat_range2 range;
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn *ct;
+
+	ct = nf_ct_get(skb, &ctinfo);
+	WARN_ON(!(ct != NULL &&
+		 (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED)));
+
+	memcpy(&range, range_v1, sizeof(*range_v1));
+	memset(&range.base_proto, 0, sizeof(range.base_proto));
+
+	return nf_nat_setup_info(ct, &range, NF_NAT_MANIP_DST);
+}
+
+static unsigned int
+xt_snat_target_v2(struct sk_buff *skb, const struct xt_action_param *par)
+{
+	const struct nf_nat_range2 *range = par->targinfo;
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn *ct;
+
+	ct = nf_ct_get(skb, &ctinfo);
+	WARN_ON(!(ct != NULL &&
+		 (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED ||
+		  ctinfo == IP_CT_RELATED_REPLY)));
+
+	return nf_nat_setup_info(ct, range, NF_NAT_MANIP_SRC);
+}
+
+static unsigned int
+xt_dnat_target_v2(struct sk_buff *skb, const struct xt_action_param *par)
+{
+	const struct nf_nat_range2 *range = par->targinfo;
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct;
 
@@ -163,6 +201,28 @@ static struct xt_target xt_nat_target_reg[] __read_mostly = {
 				  (1 << NF_INET_LOCAL_OUT),
 		.me		= THIS_MODULE,
 	},
+	{
+		.name		= "SNAT",
+		.revision	= 2,
+		.checkentry	= xt_nat_checkentry,
+		.destroy	= xt_nat_destroy,
+		.target		= xt_snat_target_v2,
+		.targetsize	= sizeof(struct nf_nat_range2),
+		.table		= "nat",
+		.hooks		= (1 << NF_INET_POST_ROUTING) |
+				  (1 << NF_INET_LOCAL_IN),
+		.me		= THIS_MODULE,
+	},
+	{
+		.name		= "DNAT",
+		.revision	= 2,
+		.target		= xt_dnat_target_v2,
+		.targetsize	= sizeof(struct nf_nat_range2),
+		.table		= "nat",
+		.hooks		= (1 << NF_INET_PRE_ROUTING) |
+				  (1 << NF_INET_LOCAL_OUT),
+		.me		= THIS_MODULE,
+	},
 };
 
 static int __init xt_nat_init(void)
diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index c5904f629091..02fc343feb66 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -72,7 +72,7 @@ struct ovs_conntrack_info {
 	struct md_mark mark;
 	struct md_labels labels;
 #ifdef CONFIG_NF_NAT_NEEDED
-	struct nf_nat_range range;  /* Only present for SRC NAT and DST NAT. */
+	struct nf_nat_range2 range;  /* Only present for SRC NAT and DST NAT. */
 #endif
 };
 
@@ -710,7 +710,7 @@ static bool skb_nfct_cached(struct net *net,
  */
 static int ovs_ct_nat_execute(struct sk_buff *skb, struct nf_conn *ct,
 			      enum ip_conntrack_info ctinfo,
-			      const struct nf_nat_range *range,
+			      const struct nf_nat_range2 *range,
 			      enum nf_nat_manip_type maniptype)
 {
 	int hooknum, nh_off, err = NF_ACCEPT;
-- 
2.11.0
