From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 04/20]: nf_conntrack: endian annotations
Date: Sat,  2 Dec 2006 15:49:42 +0100 (MET)
Message-ID: <20061202145247.1381.49105.sendpatchset@localhost.localdomain>
References: <20061202145241.1381.88698.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20061202145241.1381.88698.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: nf_conntrack: endian annotations

Resync with Al Viro's ip_conntrack annotations and fix a missed
spot in ip_nat_proto_icmp.c.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 3dc28b1e6e6e9e4f9064ab33fa57b56ccb9a7a67
tree 1230abd39b6ace1910a53c3881ba412ad4811469
parent fd155ea4144ef3b1d15705284b9513b42870e363
author Patrick McHardy <kaber@trash.net> Sat, 02 Dec 2006 15:33:56 +0100
committer Patrick McHardy <kaber@trash.net> Sat, 02 Dec 2006 15:33:56 +0100

 include/net/netfilter/nf_conntrack_tuple.h     |   18 ++++++------
 net/ipv4/netfilter/ip_nat_proto_icmp.c         |    4 +--
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    8 ++---
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |    2 +
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |    2 +
 net/ipv6/netfilter/nf_conntrack_reasm.c        |   26 ++++++++---------
 net/netfilter/nf_conntrack_core.c              |    6 +---
 net/netfilter/nf_conntrack_ftp.c               |   10 +++---
 net/netfilter/nf_conntrack_netlink.c           |   37 ++++++++++++------------
 net/netfilter/nf_conntrack_proto_sctp.c        |    2 +
 net/netfilter/nf_conntrack_proto_tcp.c         |    8 ++---
 11 files changed, 58 insertions(+), 65 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_tuple.h b/include/net/netfilter/nf_conntrack_tuple.h
index 530ef1f..be9dc9a 100644
--- a/include/net/netfilter/nf_conntrack_tuple.h
+++ b/include/net/netfilter/nf_conntrack_tuple.h
@@ -26,8 +26,8 @@ #define NF_CT_TUPLE_L3SIZE	4
    network order! */
 union nf_conntrack_man_l3proto {
 	u_int32_t all[NF_CT_TUPLE_L3SIZE];
-	u_int32_t ip;
-	u_int32_t ip6[4];
+	__be32 ip;
+	__be32 ip6[4];
 };
 
 /* The protocol-specific manipulable parts of the tuple: always in
@@ -38,16 +38,16 @@ union nf_conntrack_man_proto
 	u_int16_t all;
 
 	struct {
-		u_int16_t port;
+		__be16 port;
 	} tcp;
 	struct {
-		u_int16_t port;
+		__be16 port;
 	} udp;
 	struct {
-		u_int16_t id;
+		__be16 id;
 	} icmp;
 	struct {
-		u_int16_t port;
+		__be16 port;
 	} sctp;
 };
 
@@ -77,16 +77,16 @@ struct nf_conntrack_tuple
 			u_int16_t all;
 
 			struct {
-				u_int16_t port;
+				__be16 port;
 			} tcp;
 			struct {
-				u_int16_t port;
+				__be16 port;
 			} udp;
 			struct {
 				u_int8_t type, code;
 			} icmp;
 			struct {
-				u_int16_t port;
+				__be16 port;
 			} sctp;
 		} u;
 
diff --git a/net/ipv4/netfilter/ip_nat_proto_icmp.c b/net/ipv4/netfilter/ip_nat_proto_icmp.c
index 75266fe..fb716ed 100644
--- a/net/ipv4/netfilter/ip_nat_proto_icmp.c
+++ b/net/ipv4/netfilter/ip_nat_proto_icmp.c
@@ -24,8 +24,8 @@ icmp_in_range(const struct ip_conntrack_
 	      const union ip_conntrack_manip_proto *min,
 	      const union ip_conntrack_manip_proto *max)
 {
-	return (tuple->src.u.icmp.id >= min->icmp.id
-		&& tuple->src.u.icmp.id <= max->icmp.id);
+	return ntohs(tuple->src.u.icmp.id) >= ntohs(min->icmp.id) &&
+	       ntohs(tuple->src.u.icmp.id) <= ntohs(max->icmp.id);
 }
 
 static int
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index f24e872..2b73e3e 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -41,7 +41,7 @@ #endif
 static int ipv4_pkt_to_tuple(const struct sk_buff *skb, unsigned int nhoff,
 			     struct nf_conntrack_tuple *tuple)
 {
-	u_int32_t _addrs[2], *ap;
+	__be32 _addrs[2], *ap;
 	ap = skb_header_pointer(skb, nhoff + offsetof(struct iphdr, saddr),
 				sizeof(u_int32_t) * 2, _addrs);
 	if (ap == NULL)
@@ -410,10 +410,8 @@ static int ipv4_nfattr_to_tuple(struct n
 	if (nfattr_bad_size(tb, CTA_IP_MAX, cta_min_ip))
 		return -EINVAL;
 
-	t->src.u3.ip =
-		*(u_int32_t *)NFA_DATA(tb[CTA_IP_V4_SRC-1]);
-	t->dst.u3.ip =
-		*(u_int32_t *)NFA_DATA(tb[CTA_IP_V4_DST-1]);
+	t->src.u3.ip = *(__be32 *)NFA_DATA(tb[CTA_IP_V4_SRC-1]);
+	t->dst.u3.ip = *(__be32 *)NFA_DATA(tb[CTA_IP_V4_DST-1]);
 
 	return 0;
 }
diff --git a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
index 46aa44a..d25002f 100644
--- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
@@ -311,7 +311,7 @@ static int icmp_nfattr_to_tuple(struct n
 	tuple->dst.u.icmp.code =
 			*(u_int8_t *)NFA_DATA(tb[CTA_PROTO_ICMP_CODE-1]);
 	tuple->src.u.icmp.id =
-			*(u_int16_t *)NFA_DATA(tb[CTA_PROTO_ICMP_ID-1]);
+			*(__be16 *)NFA_DATA(tb[CTA_PROTO_ICMP_ID-1]);
 
 	if (tuple->dst.u.icmp.type >= sizeof(invmap)
 	    || !invmap[tuple->dst.u.icmp.type])
diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
index 1e8e700..3905cac 100644
--- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
@@ -287,7 +287,7 @@ static int icmpv6_nfattr_to_tuple(struct
 	tuple->dst.u.icmp.code =
 			*(u_int8_t *)NFA_DATA(tb[CTA_PROTO_ICMPV6_CODE-1]);
 	tuple->src.u.icmp.id =
-			*(u_int16_t *)NFA_DATA(tb[CTA_PROTO_ICMPV6_ID-1]);
+			*(__be16 *)NFA_DATA(tb[CTA_PROTO_ICMPV6_ID-1]);
 
 	if (tuple->dst.u.icmp.type < 128
 	    || tuple->dst.u.icmp.type - 128 >= sizeof(invmap)
diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index bf93c1e..37e5fca 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -72,7 +72,7 @@ struct nf_ct_frag6_queue
 	struct hlist_node	list;
 	struct list_head	lru_list;	/* lru list member	*/
 
-	__u32			id;		/* fragment id		*/
+	__be32			id;		/* fragment id		*/
 	struct in6_addr		saddr;
 	struct in6_addr		daddr;
 
@@ -115,28 +115,28 @@ static __inline__ void fq_unlink(struct 
 	write_unlock(&nf_ct_frag6_lock);
 }
 
-static unsigned int ip6qhashfn(u32 id, struct in6_addr *saddr,
+static unsigned int ip6qhashfn(__be32 id, struct in6_addr *saddr,
 			       struct in6_addr *daddr)
 {
 	u32 a, b, c;
 
-	a = saddr->s6_addr32[0];
-	b = saddr->s6_addr32[1];
-	c = saddr->s6_addr32[2];
+	a = (__force u32)saddr->s6_addr32[0];
+	b = (__force u32)saddr->s6_addr32[1];
+	c = (__force u32)saddr->s6_addr32[2];
 
 	a += JHASH_GOLDEN_RATIO;
 	b += JHASH_GOLDEN_RATIO;
 	c += nf_ct_frag6_hash_rnd;
 	__jhash_mix(a, b, c);
 
-	a += saddr->s6_addr32[3];
-	b += daddr->s6_addr32[0];
-	c += daddr->s6_addr32[1];
+	a += (__force u32)saddr->s6_addr32[3];
+	b += (__force u32)daddr->s6_addr32[0];
+	c += (__force u32)daddr->s6_addr32[1];
 	__jhash_mix(a, b, c);
 
-	a += daddr->s6_addr32[2];
-	b += daddr->s6_addr32[3];
-	c += id;
+	a += (__force u32)daddr->s6_addr32[2];
+	b += (__force u32)daddr->s6_addr32[3];
+	c += (__force u32)id;
 	__jhash_mix(a, b, c);
 
 	return c & (FRAG6Q_HASHSZ - 1);
@@ -338,7 +338,7 @@ #endif
 
 
 static struct nf_ct_frag6_queue *
-nf_ct_frag6_create(unsigned int hash, u32 id, struct in6_addr *src,				   struct in6_addr *dst)
+nf_ct_frag6_create(unsigned int hash, __be32 id, struct in6_addr *src,				   struct in6_addr *dst)
 {
 	struct nf_ct_frag6_queue *fq;
 
@@ -366,7 +366,7 @@ oom:
 }
 
 static __inline__ struct nf_ct_frag6_queue *
-fq_find(u32 id, struct in6_addr *src, struct in6_addr *dst)
+fq_find(__be32 id, struct in6_addr *src, struct in6_addr *dst)
 {
 	struct nf_ct_frag6_queue *fq;
 	struct hlist_node *n;
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index a672806..a401b1e 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -936,10 +936,8 @@ int nf_ct_port_nfattr_to_tuple(struct nf
 	if (nfattr_bad_size(tb, CTA_PROTO_MAX, cta_min_proto))
 		return -EINVAL;
 
-	t->src.u.tcp.port =
-		*(u_int16_t *)NFA_DATA(tb[CTA_PROTO_SRC_PORT-1]);
-	t->dst.u.tcp.port =
-		*(u_int16_t *)NFA_DATA(tb[CTA_PROTO_DST_PORT-1]);
+	t->src.u.tcp.port = *(__be16 *)NFA_DATA(tb[CTA_PROTO_SRC_PORT-1]);
+	t->dst.u.tcp.port = *(__be16 *)NFA_DATA(tb[CTA_PROTO_DST_PORT-1]);
 
 	return 0;
 }
diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index 2d23501..fdac52b 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -173,7 +173,7 @@ static int try_rfc959(const char *data, 
 
 /* Grab port: number up to delimiter */
 static int get_port(const char *data, int start, size_t dlen, char delim,
-		    u_int16_t *port)
+		    __be16 *port)
 {
 	u_int16_t tmp_port = 0;
 	int i;
@@ -502,12 +502,12 @@ static int help(struct sk_buff **pskb,
 			       .u = { .tcp = { 0 }},
 			     },
 		      .dst = { .protonum = 0xFF,
-			       .u = { .tcp = { 0xFFFF }},
+			       .u = { .tcp = { __constant_htons(0xFFFF) }},
 			     },
 		    };
 	if (cmd.l3num == PF_INET) {
-		exp->mask.src.u3.ip = 0xFFFFFFFF;
-		exp->mask.dst.u3.ip = 0xFFFFFFFF;
+		exp->mask.src.u3.ip = htonl(0xFFFFFFFF);
+		exp->mask.dst.u3.ip = htonl(0xFFFFFFFF);
 	} else {
 		memset(exp->mask.src.u3.ip6, 0xFF,
 		       sizeof(exp->mask.src.u3.ip6));
@@ -588,7 +588,7 @@ static int __init nf_conntrack_ftp_init(
 			ftp[i][j].tuple.src.u.tcp.port = htons(ports[i]);
 			ftp[i][j].tuple.dst.protonum = IPPROTO_TCP;
 			ftp[i][j].mask.src.l3num = 0xFFFF;
-			ftp[i][j].mask.src.u.tcp.port = 0xFFFF;
+			ftp[i][j].mask.src.u.tcp.port = htons(0xFFFF);
 			ftp[i][j].mask.dst.protonum = 0xFF;
 			ftp[i][j].max_expected = 1;
 			ftp[i][j].timeout = 5 * 60;	/* 5 Minutes */
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index e3a7204..a693d3b 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -113,7 +113,7 @@ ctnetlink_dump_tuples(struct sk_buff *sk
 static inline int
 ctnetlink_dump_status(struct sk_buff *skb, const struct nf_conn *ct)
 {
-	u_int32_t status = htonl((u_int32_t) ct->status);
+	__be32 status = htonl((u_int32_t) ct->status);
 	NFA_PUT(skb, CTA_STATUS, sizeof(status), &status);
 	return 0;
 
@@ -125,7 +125,7 @@ static inline int
 ctnetlink_dump_timeout(struct sk_buff *skb, const struct nf_conn *ct)
 {
 	long timeout_l = ct->timeout.expires - jiffies;
-	u_int32_t timeout;
+	__be32 timeout;
 
 	if (timeout_l < 0)
 		timeout = 0;
@@ -196,7 +196,7 @@ ctnetlink_dump_counters(struct sk_buff *
 {
 	enum ctattr_type type = dir ? CTA_COUNTERS_REPLY: CTA_COUNTERS_ORIG;
 	struct nfattr *nest_count = NFA_NEST(skb, type);
-	u_int32_t tmp;
+	__be32 tmp;
 
 	tmp = htonl(ct->counters[dir].packets);
 	NFA_PUT(skb, CTA_COUNTERS32_PACKETS, sizeof(u_int32_t), &tmp);
@@ -219,7 +219,7 @@ #ifdef CONFIG_NF_CONNTRACK_MARK
 static inline int
 ctnetlink_dump_mark(struct sk_buff *skb, const struct nf_conn *ct)
 {
-	u_int32_t mark = htonl(ct->mark);
+	__be32 mark = htonl(ct->mark);
 
 	NFA_PUT(skb, CTA_MARK, sizeof(u_int32_t), &mark);
 	return 0;
@@ -234,7 +234,7 @@ #endif
 static inline int
 ctnetlink_dump_id(struct sk_buff *skb, const struct nf_conn *ct)
 {
-	u_int32_t id = htonl(ct->id);
+	__be32 id = htonl(ct->id);
 	NFA_PUT(skb, CTA_ID, sizeof(u_int32_t), &id);
 	return 0;
 
@@ -245,7 +245,7 @@ nfattr_failure:
 static inline int
 ctnetlink_dump_use(struct sk_buff *skb, const struct nf_conn *ct)
 {
-	u_int32_t use = htonl(atomic_read(&ct->ct_general.use));
+	__be32 use = htonl(atomic_read(&ct->ct_general.use));
 	
 	NFA_PUT(skb, CTA_USE, sizeof(u_int32_t), &use);
 	return 0;
@@ -610,12 +610,12 @@ ctnetlink_parse_nat(struct nfattr *nat,
 		return -EINVAL;
 
 	if (tb[CTA_NAT_MINIP-1])
-		range->min_ip = *(u_int32_t *)NFA_DATA(tb[CTA_NAT_MINIP-1]);
+		range->min_ip = *(__be32 *)NFA_DATA(tb[CTA_NAT_MINIP-1]);
 
 	if (!tb[CTA_NAT_MAXIP-1])
 		range->max_ip = range->min_ip;
 	else
-		range->max_ip = *(u_int32_t *)NFA_DATA(tb[CTA_NAT_MAXIP-1]);
+		range->max_ip = *(__be32 *)NFA_DATA(tb[CTA_NAT_MAXIP-1]);
 
 	if (range->min_ip)
 		range->flags |= IP_NAT_RANGE_MAP_IPS;
@@ -688,7 +688,7 @@ ctnetlink_del_conntrack(struct sock *ctn
 	ct = nf_ct_tuplehash_to_ctrack(h);
 	
 	if (cda[CTA_ID-1]) {
-		u_int32_t id = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_ID-1]));
+		u_int32_t id = ntohl(*(__be32 *)NFA_DATA(cda[CTA_ID-1]));
 		if (ct->id != id) {
 			nf_ct_put(ct);
 			return -ENOENT;
@@ -781,7 +781,7 @@ static inline int
 ctnetlink_change_status(struct nf_conn *ct, struct nfattr *cda[])
 {
 	unsigned long d;
-	unsigned status = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_STATUS-1]));
+	unsigned int status = ntohl(*(__be32 *)NFA_DATA(cda[CTA_STATUS-1]));
 	d = ct->status ^ status;
 
 	if (d & (IPS_EXPECTED|IPS_CONFIRMED|IPS_DYING))
@@ -880,7 +880,7 @@ ctnetlink_change_helper(struct nf_conn *
 static inline int
 ctnetlink_change_timeout(struct nf_conn *ct, struct nfattr *cda[])
 {
-	u_int32_t timeout = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_TIMEOUT-1]));
+	u_int32_t timeout = ntohl(*(__be32 *)NFA_DATA(cda[CTA_TIMEOUT-1]));
 	
 	if (!del_timer(&ct->timeout))
 		return -ETIME;
@@ -942,7 +942,7 @@ ctnetlink_change_conntrack(struct nf_con
 
 #if defined(CONFIG_NF_CONNTRACK_MARK)
 	if (cda[CTA_MARK-1])
-		ct->mark = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_MARK-1]));
+		ct->mark = ntohl(*(__be32 *)NFA_DATA(cda[CTA_MARK-1]));
 #endif
 
 	return 0;
@@ -963,7 +963,7 @@ ctnetlink_create_conntrack(struct nfattr
 
 	if (!cda[CTA_TIMEOUT-1])
 		goto err;
-	ct->timeout.expires = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_TIMEOUT-1]));
+	ct->timeout.expires = ntohl(*(__be32 *)NFA_DATA(cda[CTA_TIMEOUT-1]));
 
 	ct->timeout.expires = jiffies + ct->timeout.expires * HZ;
 	ct->status |= IPS_CONFIRMED;
@@ -982,7 +982,7 @@ ctnetlink_create_conntrack(struct nfattr
 
 #if defined(CONFIG_NF_CONNTRACK_MARK)
 	if (cda[CTA_MARK-1])
-		ct->mark = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_MARK-1]));
+		ct->mark = ntohl(*(__be32 *)NFA_DATA(cda[CTA_MARK-1]));
 #endif
 
 	help = nfct_help(ct);
@@ -1117,8 +1117,8 @@ ctnetlink_exp_dump_expect(struct sk_buff
                           const struct nf_conntrack_expect *exp)
 {
 	struct nf_conn *master = exp->master;
-	u_int32_t timeout = htonl((exp->timeout.expires - jiffies) / HZ);
-	u_int32_t id = htonl(exp->id);
+	__be32 timeout = htonl((exp->timeout.expires - jiffies) / HZ);
+	__be32 id = htonl(exp->id);
 
 	if (ctnetlink_exp_dump_tuple(skb, &exp->tuple, CTA_EXPECT_TUPLE) < 0)
 		goto nfattr_failure;
@@ -1296,7 +1296,7 @@ ctnetlink_get_expect(struct sock *ctnl, 
 		return -ENOENT;
 
 	if (cda[CTA_EXPECT_ID-1]) {
-		u_int32_t id = *(u_int32_t *)NFA_DATA(cda[CTA_EXPECT_ID-1]);
+		__be32 id = *(__be32 *)NFA_DATA(cda[CTA_EXPECT_ID-1]);
 		if (exp->id != ntohl(id)) {
 			nf_conntrack_expect_put(exp);
 			return -ENOENT;
@@ -1351,8 +1351,7 @@ ctnetlink_del_expect(struct sock *ctnl, 
 			return -ENOENT;
 
 		if (cda[CTA_EXPECT_ID-1]) {
-			u_int32_t id = 
-				*(u_int32_t *)NFA_DATA(cda[CTA_EXPECT_ID-1]);
+			__be32 id = *(__be32 *)NFA_DATA(cda[CTA_EXPECT_ID-1]);
 			if (exp->id != ntohl(id)) {
 				nf_conntrack_expect_put(exp);
 				return -ENOENT;
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 7c64b9c..02b9323 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -217,7 +217,7 @@ #define for_each_sctp_chunk(skb, sch, _s
 for (offset = dataoff + sizeof(sctp_sctphdr_t), count = 0;		\
 	offset < skb->len &&						\
 	(sch = skb_header_pointer(skb, offset, sizeof(_sch), &_sch));	\
-	offset += (htons(sch->length) + 3) & ~3, count++)
+	offset += (ntohs(sch->length) + 3) & ~3, count++)
 
 /* Some validity checks to make sure the chunks are fine */
 static int do_basic_checks(struct nf_conn *conntrack,
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index d99c7c4..71f492f 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -474,8 +474,8 @@ static void tcp_sack(const struct sk_buf
 
 	/* Fast path for timestamp-only option */
 	if (length == TCPOLEN_TSTAMP_ALIGNED*4
-	    && *(__u32 *)ptr ==
-	        __constant_ntohl((TCPOPT_NOP << 24) 
+	    && *(__be32 *)ptr ==
+	        __constant_htonl((TCPOPT_NOP << 24)
 	        		 | (TCPOPT_NOP << 16)
 	        		 | (TCPOPT_TIMESTAMP << 8)
 	        		 | TCPOLEN_TIMESTAMP))
@@ -506,9 +506,7 @@ static void tcp_sack(const struct sk_buf
 			    	for (i = 0;
 			    	     i < (opsize - TCPOLEN_SACK_BASE);
 			    	     i += TCPOLEN_SACK_PERBLOCK) {
-					memcpy(&tmp, (__u32 *)(ptr + i) + 1,
-					       sizeof(__u32));
-					tmp = ntohl(tmp);
+				     	tmp = ntohl(*((__be32 *)(ptr+i)+1));
 
 					if (after(tmp, *sack))
 						*sack = tmp;
