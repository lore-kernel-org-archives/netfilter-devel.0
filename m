From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 59/64]: Parenthesize macro parameters
Date: Tue, 18 Dec 2007 00:47:33 +0100 (MET)
Message-ID: <20071217234733.23601.9839.sendpatchset@localhost.localdomain>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39063 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933215AbXLQXrf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:47:35 -0500
In-Reply-To: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: Parenthesize macro parameters

Parenthesize macro parameters.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit d1c627416f8e9632c67483522e7e2dbbebc89fe1
tree b576b31f12002e9f9dec8680850ca435461e3a51
parent 3cecb3726340f00f0c6e08804fff5b552fe9feef
author Jan Engelhardt <jengelh@computergmbh.de> Mon, 17 Dec 2007 14:58:54 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 18 Dec 2007 00:25:00 +0100

 net/ipv4/netfilter/arp_tables.c         |    3 ++-
 net/ipv4/netfilter/ip_tables.c          |    3 ++-
 net/ipv4/netfilter/nf_nat_snmp_basic.c  |    2 +-
 net/ipv6/netfilter/ip6_tables.c         |    2 +-
 net/netfilter/nf_conntrack_h323_asn1.c  |    8 ++++----
 net/netfilter/nf_conntrack_netlink.c    |    2 +-
 net/netfilter/nf_conntrack_proto_sctp.c |    8 ++++----
 net/netfilter/xt_conntrack.c            |    3 ++-
 net/netfilter/xt_policy.c               |    2 +-
 net/netfilter/xt_string.c               |    2 +-
 10 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index ad2da6d..b4a810c 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -84,7 +84,7 @@ static inline int arp_packet_match(const struct arphdr *arphdr,
 	__be32 src_ipaddr, tgt_ipaddr;
 	int i, ret;
 
-#define FWINV(bool,invflg) ((bool) ^ !!(arpinfo->invflags & invflg))
+#define FWINV(bool, invflg) ((bool) ^ !!(arpinfo->invflags & (invflg)))
 
 	if (FWINV((arphdr->ar_op & arpinfo->arpop_mask) != arpinfo->arpop,
 		  ARPT_INV_ARPOP)) {
@@ -180,6 +180,7 @@ static inline int arp_packet_match(const struct arphdr *arphdr,
 	}
 
 	return 1;
+#undef FWINV
 }
 
 static inline int arp_checkentry(const struct arpt_arp *arp)
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 271f6a5..f5b66ec 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -85,7 +85,7 @@ ip_packet_match(const struct iphdr *ip,
 	size_t i;
 	unsigned long ret;
 
-#define FWINV(bool,invflg) ((bool) ^ !!(ipinfo->invflags & invflg))
+#define FWINV(bool, invflg) ((bool) ^ !!(ipinfo->invflags & (invflg)))
 
 	if (FWINV((ip->saddr&ipinfo->smsk.s_addr) != ipinfo->src.s_addr,
 		  IPT_INV_SRCIP)
@@ -216,6 +216,7 @@ unconditional(const struct ipt_ip *ip)
 			return 0;
 
 	return 1;
+#undef FWINV
 }
 
 #if defined(CONFIG_NETFILTER_XT_TARGET_TRACE) || \
diff --git a/net/ipv4/netfilter/nf_nat_snmp_basic.c b/net/ipv4/netfilter/nf_nat_snmp_basic.c
index 03709d6..07f2a49 100644
--- a/net/ipv4/netfilter/nf_nat_snmp_basic.c
+++ b/net/ipv4/netfilter/nf_nat_snmp_basic.c
@@ -60,7 +60,7 @@ MODULE_ALIAS("ip_nat_snmp_basic");
 
 #define SNMP_PORT 161
 #define SNMP_TRAP_PORT 162
-#define NOCT1(n) (*(u8 *)n)
+#define NOCT1(n) (*(u8 *)(n))
 
 static int debug;
 static DEFINE_SPINLOCK(snmp_lock);
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index bb50d0e..4ed16d2 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -102,7 +102,7 @@ ip6_packet_match(const struct sk_buff *skb,
 	unsigned long ret;
 	const struct ipv6hdr *ipv6 = ipv6_hdr(skb);
 
-#define FWINV(bool,invflg) ((bool) ^ !!(ip6info->invflags & invflg))
+#define FWINV(bool, invflg) ((bool) ^ !!(ip6info->invflags & (invflg)))
 
 	if (FWINV(ipv6_masked_addr_cmp(&ipv6->saddr, &ip6info->smsk,
 				       &ip6info->src), IP6T_INV_SRCIP)
diff --git a/net/netfilter/nf_conntrack_h323_asn1.c b/net/netfilter/nf_conntrack_h323_asn1.c
index a869403..ff66fba 100644
--- a/net/netfilter/nf_conntrack_h323_asn1.c
+++ b/net/netfilter/nf_conntrack_h323_asn1.c
@@ -100,10 +100,10 @@ typedef struct {
 } bitstr_t;
 
 /* Tool Functions */
-#define INC_BIT(bs) if((++bs->bit)>7){bs->cur++;bs->bit=0;}
-#define INC_BITS(bs,b) if((bs->bit+=b)>7){bs->cur+=bs->bit>>3;bs->bit&=7;}
-#define BYTE_ALIGN(bs) if(bs->bit){bs->cur++;bs->bit=0;}
-#define CHECK_BOUND(bs,n) if(bs->cur+(n)>bs->end)return(H323_ERROR_BOUND)
+#define INC_BIT(bs) if((++(bs)->bit)>7){(bs)->cur++;(bs)->bit=0;}
+#define INC_BITS(bs,b) if(((bs)->bit+=(b))>7){(bs)->cur+=(bs)->bit>>3;(bs)->bit&=7;}
+#define BYTE_ALIGN(bs) if((bs)->bit){(bs)->cur++;(bs)->bit=0;}
+#define CHECK_BOUND(bs,n) if((bs)->cur+(n)>(bs)->end)return(H323_ERROR_BOUND)
 static unsigned get_len(bitstr_t * bs);
 static unsigned get_bit(bitstr_t * bs);
 static unsigned get_bits(bitstr_t * bs, unsigned b);
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 3a065f4..d93d58d 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -534,7 +534,7 @@ static int ctnetlink_done(struct netlink_callback *cb)
 	return 0;
 }
 
-#define L3PROTO(ct) ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num
+#define L3PROTO(ct) (ct)->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num
 
 static int
 ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 2246123..9296fd2 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -186,10 +186,10 @@ static int sctp_print_conntrack(struct seq_file *s,
 }
 
 #define for_each_sctp_chunk(skb, sch, _sch, offset, dataoff, count)	\
-for (offset = dataoff + sizeof(sctp_sctphdr_t), count = 0;		\
-	offset < skb->len &&						\
-	(sch = skb_header_pointer(skb, offset, sizeof(_sch), &_sch));	\
-	offset += (ntohs(sch->length) + 3) & ~3, count++)
+for ((offset) = (dataoff) + sizeof(sctp_sctphdr_t), (count) = 0;	\
+	(offset) < (skb)->len &&					\
+	((sch) = skb_header_pointer((skb), (offset), sizeof(_sch), &(_sch)));	\
+	(offset) += (ntohs((sch)->length) + 3) & ~3, (count)++)
 
 /* Some validity checks to make sure the chunks are fine */
 static int do_basic_checks(struct nf_conn *conntrack,
diff --git a/net/netfilter/xt_conntrack.c b/net/netfilter/xt_conntrack.c
index 8c1d448..3f8bfba 100644
--- a/net/netfilter/xt_conntrack.c
+++ b/net/netfilter/xt_conntrack.c
@@ -32,7 +32,7 @@ conntrack_mt(const struct sk_buff *skb, const struct net_device *in,
 
 	ct = nf_ct_get(skb, &ctinfo);
 
-#define FWINV(bool,invflg) ((bool) ^ !!(sinfo->invflags & invflg))
+#define FWINV(bool, invflg) ((bool) ^ !!(sinfo->invflags & (invflg)))
 
 	if (ct == &nf_conntrack_untracked)
 		statebit = XT_CONNTRACK_STATE_UNTRACKED;
@@ -108,6 +108,7 @@ conntrack_mt(const struct sk_buff *skb, const struct net_device *in,
 			return false;
 	}
 	return true;
+#undef FWINV
 }
 
 static bool
diff --git a/net/netfilter/xt_policy.c b/net/netfilter/xt_policy.c
index 5a017b8..46ee7e8 100644
--- a/net/netfilter/xt_policy.c
+++ b/net/netfilter/xt_policy.c
@@ -38,7 +38,7 @@ match_xfrm_state(const struct xfrm_state *x, const struct xt_policy_elem *e,
 		 unsigned short family)
 {
 #define MATCH_ADDR(x,y,z)	(!e->match.x ||			       \
-				 (xt_addr_cmp(&e->x, &e->y, z, family) \
+				 (xt_addr_cmp(&e->x, &e->y, (z), family) \
 				  ^ e->invert.x))
 #define MATCH(x,y)		(!e->match.x || ((e->x == (y)) ^ e->invert.x))
 
diff --git a/net/netfilter/xt_string.c b/net/netfilter/xt_string.c
index 9028784..aff7a11 100644
--- a/net/netfilter/xt_string.c
+++ b/net/netfilter/xt_string.c
@@ -37,7 +37,7 @@ string_mt(const struct sk_buff *skb, const struct net_device *in,
 			     != UINT_MAX) ^ conf->invert;
 }
 
-#define STRING_TEXT_PRIV(m) ((struct xt_string_info *) m)
+#define STRING_TEXT_PRIV(m) ((struct xt_string_info *)(m))
 
 static bool
 string_mt_check(const char *tablename, const void *ip,
