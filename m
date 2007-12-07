From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH] Parenthesize macro parameters
Date: Fri, 7 Dec 2007 03:59:08 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0712070358330.1262@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:35312 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407AbXLGC7K (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 6 Dec 2007 21:59:10 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Parenthesize macro parameters.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
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

Index: linux-2.6/net/ipv4/netfilter/arp_tables.c
===================================================================
--- linux-2.6.orig/net/ipv4/netfilter/arp_tables.c
+++ linux-2.6/net/ipv4/netfilter/arp_tables.c
@@ -83,7 +83,7 @@ static inline int arp_packet_match(const
 	__be32 src_ipaddr, tgt_ipaddr;
 	int i, ret;
 
-#define FWINV(bool,invflg) ((bool) ^ !!(arpinfo->invflags & invflg))
+#define FWINV(bool, invflg) ((bool) ^ !!(arpinfo->invflags & (invflg)))
 
 	if (FWINV((arphdr->ar_op & arpinfo->arpop_mask) != arpinfo->arpop,
 		  ARPT_INV_ARPOP)) {
@@ -179,6 +179,7 @@ static inline int arp_packet_match(const
 	}
 
 	return 1;
+#undef FWINV
 }
 
 static inline int arp_checkentry(const struct arpt_arp *arp)
Index: linux-2.6/net/ipv4/netfilter/ip_tables.c
===================================================================
--- linux-2.6.orig/net/ipv4/netfilter/ip_tables.c
+++ linux-2.6/net/ipv4/netfilter/ip_tables.c
@@ -84,7 +84,7 @@ ip_packet_match(const struct iphdr *ip,
 	size_t i;
 	unsigned long ret;
 
-#define FWINV(bool,invflg) ((bool) ^ !!(ipinfo->invflags & invflg))
+#define FWINV(bool, invflg) ((bool) ^ !!(ipinfo->invflags & (invflg)))
 
 	if (FWINV((ip->saddr&ipinfo->smsk.s_addr) != ipinfo->src.s_addr,
 		  IPT_INV_SRCIP)
@@ -150,6 +150,7 @@ ip_packet_match(const struct iphdr *ip,
 	}
 
 	return 1;
+#undef FWINV
 }
 
 static inline bool
Index: linux-2.6/net/ipv4/netfilter/nf_nat_snmp_basic.c
===================================================================
--- linux-2.6.orig/net/ipv4/netfilter/nf_nat_snmp_basic.c
+++ linux-2.6/net/ipv4/netfilter/nf_nat_snmp_basic.c
@@ -60,7 +60,7 @@ MODULE_ALIAS("ip_nat_snmp_basic");
 
 #define SNMP_PORT 161
 #define SNMP_TRAP_PORT 162
-#define NOCT1(n) (*(u8 *)n)
+#define NOCT1(n) (*(u8 *)(n))
 
 static int debug;
 static DEFINE_SPINLOCK(snmp_lock);
Index: linux-2.6/net/ipv6/netfilter/ip6_tables.c
===================================================================
--- linux-2.6.orig/net/ipv6/netfilter/ip6_tables.c
+++ linux-2.6/net/ipv6/netfilter/ip6_tables.c
@@ -108,7 +108,7 @@ ip6_packet_match(const struct sk_buff *s
 	unsigned long ret;
 	const struct ipv6hdr *ipv6 = ipv6_hdr(skb);
 
-#define FWINV(bool,invflg) ((bool) ^ !!(ip6info->invflags & invflg))
+#define FWINV(bool, invflg) ((bool) ^ !!(ip6info->invflags & (invflg)))
 
 	if (FWINV(ipv6_masked_addr_cmp(&ipv6->saddr, &ip6info->smsk,
 				       &ip6info->src), IP6T_INV_SRCIP)
Index: linux-2.6/net/netfilter/nf_conntrack_h323_asn1.c
===================================================================
--- linux-2.6.orig/net/netfilter/nf_conntrack_h323_asn1.c
+++ linux-2.6/net/netfilter/nf_conntrack_h323_asn1.c
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
Index: linux-2.6/net/netfilter/nf_conntrack_netlink.c
===================================================================
--- linux-2.6.orig/net/netfilter/nf_conntrack_netlink.c
+++ linux-2.6/net/netfilter/nf_conntrack_netlink.c
@@ -444,7 +444,7 @@ static int ctnetlink_done(struct netlink
 	return 0;
 }
 
-#define L3PROTO(ct) ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num
+#define L3PROTO(ct) (ct)->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num
 
 static int
 ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
Index: linux-2.6/net/netfilter/nf_conntrack_proto_sctp.c
===================================================================
--- linux-2.6.orig/net/netfilter/nf_conntrack_proto_sctp.c
+++ linux-2.6/net/netfilter/nf_conntrack_proto_sctp.c
@@ -186,10 +186,10 @@ static int sctp_print_conntrack(struct s
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
Index: linux-2.6/net/netfilter/xt_conntrack.c
===================================================================
--- linux-2.6.orig/net/netfilter/xt_conntrack.c
+++ linux-2.6/net/netfilter/xt_conntrack.c
@@ -32,7 +32,7 @@ conntrack_mt(const struct sk_buff *skb, 
 
 	ct = nf_ct_get(skb, &ctinfo);
 
-#define FWINV(bool,invflg) ((bool) ^ !!(sinfo->invflags & invflg))
+#define FWINV(bool, invflg) ((bool) ^ !!(sinfo->invflags & (invflg)))
 
 	if (ct == &nf_conntrack_untracked)
 		statebit = XT_CONNTRACK_STATE_UNTRACKED;
@@ -108,6 +108,7 @@ conntrack_mt(const struct sk_buff *skb, 
 			return false;
 	}
 	return true;
+#undef FWINV
 }
 
 static bool
Index: linux-2.6/net/netfilter/xt_policy.c
===================================================================
--- linux-2.6.orig/net/netfilter/xt_policy.c
+++ linux-2.6/net/netfilter/xt_policy.c
@@ -38,7 +38,7 @@ match_xfrm_state(const struct xfrm_state
 		 unsigned short family)
 {
 #define MATCH_ADDR(x,y,z)	(!e->match.x ||			       \
-				 (xt_addr_cmp(&e->x, &e->y, z, family) \
+				 (xt_addr_cmp(&e->x, &e->y, (z), family) \
 				  ^ e->invert.x))
 #define MATCH(x,y)		(!e->match.x || ((e->x == (y)) ^ e->invert.x))
 
Index: linux-2.6/net/netfilter/xt_string.c
===================================================================
--- linux-2.6.orig/net/netfilter/xt_string.c
+++ linux-2.6/net/netfilter/xt_string.c
@@ -37,7 +37,7 @@ string_mt(const struct sk_buff *skb, con
 			     != UINT_MAX) ^ conf->invert;
 }
 
-#define STRING_TEXT_PRIV(m) ((struct xt_string_info *) m)
+#define STRING_TEXT_PRIV(m) ((struct xt_string_info *)(m))
 
 static bool
 string_mt_check(const char *tablename, const void *ip,

