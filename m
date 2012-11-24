From: pablo@netfilter.org
Subject: [PATCH] netfilter: move ipv6_find_hdr to net/ipv6/netfilter.c and rename it
Date: Sun, 25 Nov 2012 00:07:18 +0100
Message-ID: <1353798438-6331-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48407 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752587Ab2KXXHf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 24 Nov 2012 18:07:35 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

IPVS uses ipv6_find_hdr, but this function is defined in ip6_tables.c,
to avoid such a dependency, move the function definition to the
generic IPv6 netfilter infrastructure.

This patch also renames the function to nf_ip6_find_hdr.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter_ipv6.h            |    8 +++
 include/linux/netfilter_ipv6/ip6_tables.h |    9 ---
 include/net/ip_vs.h                       |   16 ++---
 net/ipv6/netfilter.c                      |  103 ++++++++++++++++++++++++++++
 net/ipv6/netfilter/ip6_tables.c           |  105 +----------------------------
 net/ipv6/netfilter/ip6t_ah.c              |    2 +-
 net/ipv6/netfilter/ip6t_frag.c            |    2 +-
 net/ipv6/netfilter/ip6t_hbh.c             |    2 +-
 net/ipv6/netfilter/ip6t_rt.c              |    2 +-
 net/netfilter/ipvs/ip_vs_core.c           |   14 ++--
 net/netfilter/xt_HMARK.c                  |   12 ++--
 net/netfilter/xt_TPROXY.c                 |    2 +-
 net/netfilter/xt_socket.c                 |    2 +-
 net/sched/em_ipset.c                      |    2 +-
 14 files changed, 141 insertions(+), 140 deletions(-)

diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
index 98ffb54..0fd7433 100644
--- a/include/linux/netfilter_ipv6.h
+++ b/include/linux/netfilter_ipv6.h
@@ -12,6 +12,14 @@
 
 #ifdef CONFIG_NETFILTER
 extern int ip6_route_me_harder(struct sk_buff *skb);
+
+enum {
+	NF_IP6_F_FRAG  = (1 << 0),
+	NF_IP6_F_AUTH  = (1 << 1),
+};
+
+extern int nf_ip6_find_hdr(const struct sk_buff *skb, unsigned int *offset,
+			   int target, unsigned short *fragoff, int *flags);
 extern __sum16 nf_ip6_checksum(struct sk_buff *skb, unsigned int hook,
 				    unsigned int dataoff, u_int8_t protocol);
 
diff --git a/include/linux/netfilter_ipv6/ip6_tables.h b/include/linux/netfilter_ipv6/ip6_tables.h
index 5f84c62..610208b 100644
--- a/include/linux/netfilter_ipv6/ip6_tables.h
+++ b/include/linux/netfilter_ipv6/ip6_tables.h
@@ -47,15 +47,6 @@ ip6t_ext_hdr(u8 nexthdr)
 	       (nexthdr == IPPROTO_DSTOPTS);
 }
 
-enum {
-	IP6T_FH_F_FRAG	= (1 << 0),
-	IP6T_FH_F_AUTH	= (1 << 1),
-};
-
-/* find specified header and get offset to it */
-extern int ipv6_find_hdr(const struct sk_buff *skb, unsigned int *offset,
-			 int target, unsigned short *fragoff, int *fragflg);
-
 #ifdef CONFIG_COMPAT
 #include <net/compat.h>
 
diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index 68c69d5..d9b63d3 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -171,18 +171,18 @@ ip_vs_fill_iph_skb(int af, const struct sk_buff *skb, struct ip_vs_iphdr *iphdr)
 			(struct ipv6hdr *)skb_network_header(skb);
 		iphdr->saddr.in6 = iph->saddr;
 		iphdr->daddr.in6 = iph->daddr;
-		/* ipv6_find_hdr() updates len, flags, thoff_reasm */
+		/* nf_ip6_find_hdr() updates len, flags, thoff_reasm */
 		iphdr->thoff_reasm = 0;
 		iphdr->len	 = 0;
 		iphdr->flags	 = 0;
-		iphdr->protocol  = ipv6_find_hdr(skb, &iphdr->len, -1,
-						 &iphdr->fragoffs,
-						 &iphdr->flags);
+		iphdr->protocol  = nf_ip6_find_hdr(skb, &iphdr->len, -1,
+						   &iphdr->fragoffs,
+						   &iphdr->flags);
 		/* get proto from re-assembled packet and it's offset */
 		if (skb_nfct_reasm(skb))
-			iphdr->protocol = ipv6_find_hdr(skb_nfct_reasm(skb),
-							&iphdr->thoff_reasm,
-							-1, NULL, NULL);
+			iphdr->protocol = nf_ip6_find_hdr(skb_nfct_reasm(skb),
+							  &iphdr->thoff_reasm,
+							  -1, NULL, NULL);
 
 	} else
 #endif
@@ -198,7 +198,7 @@ ip_vs_fill_iph_skb(int af, const struct sk_buff *skb, struct ip_vs_iphdr *iphdr)
 }
 
 /* This function is a faster version of ip_vs_fill_iph_skb().
- * Where we only populate {s,d}addr (and avoid calling ipv6_find_hdr()).
+ * Where we only populate {s,d}addr (and avoid calling nf_ip6_find_hdr()).
  * This is used by the some of the ip_vs_*_schedule() functions.
  * (Mostly done to avoid ABI breakage of external schedulers)
  */
diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index 429089c..d25f2d9 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -60,6 +60,109 @@ int ip6_route_me_harder(struct sk_buff *skb)
 EXPORT_SYMBOL(ip6_route_me_harder);
 
 /*
+ * find the offset to specified header or the protocol number of last header
+ * if target < 0. "last header" is transport protocol header, ESP, or
+ * "No next header".
+ *
+ * Note that *offset is used as input/output parameter. an if it is not zero,
+ * then it must be a valid offset to an inner IPv6 header. This can be used
+ * to explore inner IPv6 header, eg. ICMPv6 error messages.
+ *
+ * If target header is found, its offset is set in *offset and return protocol
+ * number. Otherwise, return -1.
+ *
+ * If the first fragment doesn't contain the final protocol header or
+ * NEXTHDR_NONE it is considered invalid.
+ *
+ * Note that non-1st fragment is special case that "the protocol number
+ * of last header" is "next header" field in Fragment header. In this case,
+ * *offset is meaningless and fragment offset is stored in *fragoff if fragoff
+ * isn't NULL.
+ *
+ * if flags is not NULL and it's a fragment, then the frag flag NF_IP6_F_FRAG
+ * will be set. If it's an AH header, the NF_IP6_F_AUTH flag is set and
+ * target < 0, then this function will stop at the AH header.
+ */
+int nf_ip6_find_hdr(const struct sk_buff *skb, unsigned int *offset,
+		    int target, unsigned short *fragoff, int *flags)
+{
+	unsigned int start = skb_network_offset(skb) + sizeof(struct ipv6hdr);
+	u8 nexthdr = ipv6_hdr(skb)->nexthdr;
+	unsigned int len;
+
+	if (fragoff)
+		*fragoff = 0;
+
+	if (*offset) {
+		struct ipv6hdr _ip6, *ip6;
+
+		ip6 = skb_header_pointer(skb, *offset, sizeof(_ip6), &_ip6);
+		if (!ip6 || (ip6->version != 6)) {
+			printk(KERN_ERR "IPv6 header not found\n");
+			return -EBADMSG;
+		}
+		start = *offset + sizeof(struct ipv6hdr);
+		nexthdr = ip6->nexthdr;
+	}
+	len = skb->len - start;
+
+	while (nexthdr != target) {
+		struct ipv6_opt_hdr _hdr, *hp;
+		unsigned int hdrlen;
+
+		if ((!ipv6_ext_hdr(nexthdr)) || nexthdr == NEXTHDR_NONE) {
+			if (target < 0)
+				break;
+			return -ENOENT;
+		}
+
+		hp = skb_header_pointer(skb, start, sizeof(_hdr), &_hdr);
+		if (hp == NULL)
+			return -EBADMSG;
+		if (nexthdr == NEXTHDR_FRAGMENT) {
+			unsigned short _frag_off;
+			__be16 *fp;
+
+			if (flags)	/* Indicate that this is a fragment */
+				*flags |= NF_IP6_F_FRAG;
+			fp = skb_header_pointer(skb,
+						start+offsetof(struct frag_hdr,
+							       frag_off),
+						sizeof(_frag_off),
+						&_frag_off);
+			if (fp == NULL)
+				return -EBADMSG;
+
+			_frag_off = ntohs(*fp) & ~0x7;
+			if (_frag_off) {
+				if (target < 0 &&
+				    ((!ipv6_ext_hdr(hp->nexthdr)) ||
+				     hp->nexthdr == NEXTHDR_NONE)) {
+					if (fragoff)
+						*fragoff = _frag_off;
+					return hp->nexthdr;
+				}
+				return -ENOENT;
+			}
+			hdrlen = 8;
+		} else if (nexthdr == NEXTHDR_AUTH) {
+			if (flags && (*flags & NF_IP6_F_AUTH) && (target < 0))
+				break;
+			hdrlen = (hp->hdrlen + 2) << 2;
+		} else
+			hdrlen = ipv6_optlen(hp);
+
+		nexthdr = hp->nexthdr;
+		len -= hdrlen;
+		start += hdrlen;
+	}
+
+	*offset = start;
+	return nexthdr;
+}
+EXPORT_SYMBOL(nf_ip6_find_hdr);
+
+/*
  * Extra routing may needed on local out, as the QUEUE target never
  * returns control to the table.
  */
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 10ce76a..5f63480 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -133,7 +133,7 @@ ip6_packet_match(const struct sk_buff *skb,
 		int protohdr;
 		unsigned short _frag_off;
 
-		protohdr = ipv6_find_hdr(skb, protoff, -1, &_frag_off, NULL);
+		protohdr = nf_ip6_find_hdr(skb, protoff, -1, &_frag_off, NULL);
 		if (protohdr < 0) {
 			if (_frag_off == 0)
 				*hotdrop = true;
@@ -2271,112 +2271,9 @@ static void __exit ip6_tables_fini(void)
 	unregister_pernet_subsys(&ip6_tables_net_ops);
 }
 
-/*
- * find the offset to specified header or the protocol number of last header
- * if target < 0. "last header" is transport protocol header, ESP, or
- * "No next header".
- *
- * Note that *offset is used as input/output parameter. an if it is not zero,
- * then it must be a valid offset to an inner IPv6 header. This can be used
- * to explore inner IPv6 header, eg. ICMPv6 error messages.
- *
- * If target header is found, its offset is set in *offset and return protocol
- * number. Otherwise, return -1.
- *
- * If the first fragment doesn't contain the final protocol header or
- * NEXTHDR_NONE it is considered invalid.
- *
- * Note that non-1st fragment is special case that "the protocol number
- * of last header" is "next header" field in Fragment header. In this case,
- * *offset is meaningless and fragment offset is stored in *fragoff if fragoff
- * isn't NULL.
- *
- * if flags is not NULL and it's a fragment, then the frag flag IP6T_FH_F_FRAG
- * will be set. If it's an AH header, the IP6T_FH_F_AUTH flag is set and
- * target < 0, then this function will stop at the AH header.
- */
-int ipv6_find_hdr(const struct sk_buff *skb, unsigned int *offset,
-		  int target, unsigned short *fragoff, int *flags)
-{
-	unsigned int start = skb_network_offset(skb) + sizeof(struct ipv6hdr);
-	u8 nexthdr = ipv6_hdr(skb)->nexthdr;
-	unsigned int len;
-
-	if (fragoff)
-		*fragoff = 0;
-
-	if (*offset) {
-		struct ipv6hdr _ip6, *ip6;
-
-		ip6 = skb_header_pointer(skb, *offset, sizeof(_ip6), &_ip6);
-		if (!ip6 || (ip6->version != 6)) {
-			printk(KERN_ERR "IPv6 header not found\n");
-			return -EBADMSG;
-		}
-		start = *offset + sizeof(struct ipv6hdr);
-		nexthdr = ip6->nexthdr;
-	}
-	len = skb->len - start;
-
-	while (nexthdr != target) {
-		struct ipv6_opt_hdr _hdr, *hp;
-		unsigned int hdrlen;
-
-		if ((!ipv6_ext_hdr(nexthdr)) || nexthdr == NEXTHDR_NONE) {
-			if (target < 0)
-				break;
-			return -ENOENT;
-		}
-
-		hp = skb_header_pointer(skb, start, sizeof(_hdr), &_hdr);
-		if (hp == NULL)
-			return -EBADMSG;
-		if (nexthdr == NEXTHDR_FRAGMENT) {
-			unsigned short _frag_off;
-			__be16 *fp;
-
-			if (flags)	/* Indicate that this is a fragment */
-				*flags |= IP6T_FH_F_FRAG;
-			fp = skb_header_pointer(skb,
-						start+offsetof(struct frag_hdr,
-							       frag_off),
-						sizeof(_frag_off),
-						&_frag_off);
-			if (fp == NULL)
-				return -EBADMSG;
-
-			_frag_off = ntohs(*fp) & ~0x7;
-			if (_frag_off) {
-				if (target < 0 &&
-				    ((!ipv6_ext_hdr(hp->nexthdr)) ||
-				     hp->nexthdr == NEXTHDR_NONE)) {
-					if (fragoff)
-						*fragoff = _frag_off;
-					return hp->nexthdr;
-				}
-				return -ENOENT;
-			}
-			hdrlen = 8;
-		} else if (nexthdr == NEXTHDR_AUTH) {
-			if (flags && (*flags & IP6T_FH_F_AUTH) && (target < 0))
-				break;
-			hdrlen = (hp->hdrlen + 2) << 2;
-		} else
-			hdrlen = ipv6_optlen(hp);
-
-		nexthdr = hp->nexthdr;
-		len -= hdrlen;
-		start += hdrlen;
-	}
-
-	*offset = start;
-	return nexthdr;
-}
-
 EXPORT_SYMBOL(ip6t_register_table);
 EXPORT_SYMBOL(ip6t_unregister_table);
 EXPORT_SYMBOL(ip6t_do_table);
-EXPORT_SYMBOL(ipv6_find_hdr);
 
 module_init(ip6_tables_init);
 module_exit(ip6_tables_fini);
diff --git a/net/ipv6/netfilter/ip6t_ah.c b/net/ipv6/netfilter/ip6t_ah.c
index 04099ab..3cbcd06 100644
--- a/net/ipv6/netfilter/ip6t_ah.c
+++ b/net/ipv6/netfilter/ip6t_ah.c
@@ -45,7 +45,7 @@ static bool ah_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 	unsigned int hdrlen = 0;
 	int err;
 
-	err = ipv6_find_hdr(skb, &ptr, NEXTHDR_AUTH, NULL, NULL);
+	err = nf_ip6_find_hdr(skb, &ptr, NEXTHDR_AUTH, NULL, NULL);
 	if (err < 0) {
 		if (err != -ENOENT)
 			par->hotdrop = true;
diff --git a/net/ipv6/netfilter/ip6t_frag.c b/net/ipv6/netfilter/ip6t_frag.c
index 3b5735e..a4a44e5 100644
--- a/net/ipv6/netfilter/ip6t_frag.c
+++ b/net/ipv6/netfilter/ip6t_frag.c
@@ -43,7 +43,7 @@ frag_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 	unsigned int ptr = 0;
 	int err;
 
-	err = ipv6_find_hdr(skb, &ptr, NEXTHDR_FRAGMENT, NULL, NULL);
+	err = nf_ip6_find_hdr(skb, &ptr, NEXTHDR_FRAGMENT, NULL, NULL);
 	if (err < 0) {
 		if (err != -ENOENT)
 			par->hotdrop = true;
diff --git a/net/ipv6/netfilter/ip6t_hbh.c b/net/ipv6/netfilter/ip6t_hbh.c
index 01df142..6d3fdd0 100644
--- a/net/ipv6/netfilter/ip6t_hbh.c
+++ b/net/ipv6/netfilter/ip6t_hbh.c
@@ -60,7 +60,7 @@ hbh_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 	unsigned int optlen;
 	int err;
 
-	err = ipv6_find_hdr(skb, &ptr,
+	err = nf_ip6_find_hdr(skb, &ptr,
 			    (par->match == &hbh_mt6_reg[0]) ?
 			    NEXTHDR_HOP : NEXTHDR_DEST, NULL, NULL);
 	if (err < 0) {
diff --git a/net/ipv6/netfilter/ip6t_rt.c b/net/ipv6/netfilter/ip6t_rt.c
index 2c99b94..ba1dcb0 100644
--- a/net/ipv6/netfilter/ip6t_rt.c
+++ b/net/ipv6/netfilter/ip6t_rt.c
@@ -49,7 +49,7 @@ static bool rt_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 	const struct in6_addr *ap;
 	int err;
 
-	err = ipv6_find_hdr(skb, &ptr, NEXTHDR_ROUTING, NULL, NULL);
+	err = nf_ip6_find_hdr(skb, &ptr, NEXTHDR_ROUTING, NULL, NULL);
 	if (err < 0) {
 		if (err != -ENOENT)
 			par->hotdrop = true;
diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index fb45640..5d70338 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -728,12 +728,12 @@ void ip_vs_nat_icmp_v6(struct sk_buff *skb, struct ip_vs_protocol *pp,
 	struct ipv6hdr *ciph;
 	unsigned short fragoffs;
 
-	ipv6_find_hdr(skb, &icmp_offset, IPPROTO_ICMPV6, &fragoffs, NULL);
+	nf_ip6_find_hdr(skb, &icmp_offset, IPPROTO_ICMPV6, &fragoffs, NULL);
 	icmph = (struct icmp6hdr *)(skb_network_header(skb) + icmp_offset);
 	offs = icmp_offset + sizeof(struct icmp6hdr);
 	ciph = (struct ipv6hdr *)(skb_network_header(skb) + offs);
 
-	protocol = ipv6_find_hdr(skb, &offs, -1, &fragoffs, NULL);
+	protocol = nf_ip6_find_hdr(skb, &offs, -1, &fragoffs, NULL);
 
 	if (inout) {
 		iph->saddr = cp->vaddr.in6;
@@ -942,7 +942,7 @@ static int ip_vs_out_icmp_v6(struct sk_buff *skb, int *related,
 	/* Fragment header that is before ICMP header tells us that:
 	 * it's not an error message since they can't be fragmented.
 	 */
-	if (ipvsh->flags & IP6T_FH_F_FRAG)
+	if (ipvsh->flags & NF_IP6_F_FRAG)
 		return NF_DROP;
 
 	IP_VS_DBG(8, "Outgoing ICMPv6 (%d,%d) %pI6c->%pI6c\n",
@@ -957,7 +957,8 @@ static int ip_vs_out_icmp_v6(struct sk_buff *skb, int *related,
 	ciph.saddr.in6 = ip6h->saddr; /* conn_out_get() handles reverse order */
 	ciph.daddr.in6 = ip6h->daddr;
 	/* skip possible IPv6 exthdrs of contained IPv6 packet */
-	ciph.protocol = ipv6_find_hdr(skb, &ciph.len, -1, &ciph.fragoffs, NULL);
+	ciph.protocol = nf_ip6_find_hdr(skb, &ciph.len, -1, &ciph.fragoffs,
+					NULL);
 	if (ciph.protocol < 0)
 		return NF_ACCEPT; /* Contained IPv6 hdr looks wrong, ignore */
 
@@ -1475,7 +1476,7 @@ static int ip_vs_in_icmp_v6(struct sk_buff *skb, int *related,
 	/* Fragment header that is before ICMP header tells us that:
 	 * it's not an error message since they can't be fragmented.
 	 */
-	if (iph->flags & IP6T_FH_F_FRAG)
+	if (iph->flags & NF_IP6_F_FRAG)
 		return NF_DROP;
 
 	IP_VS_DBG(8, "Incoming ICMPv6 (%d,%d) %pI6c->%pI6c\n",
@@ -1491,7 +1492,8 @@ static int ip_vs_in_icmp_v6(struct sk_buff *skb, int *related,
 	ciph.saddr.in6 = ip6h->saddr; /* conn_in_get() handles reverse order */
 	ciph.daddr.in6 = ip6h->daddr;
 	/* skip possible IPv6 exthdrs of contained IPv6 packet */
-	ciph.protocol = ipv6_find_hdr(skb, &ciph.len, -1, &ciph.fragoffs, NULL);
+	ciph.protocol = nf_ip6_find_hdr(skb, &ciph.len, -1, &ciph.fragoffs,
+					NULL);
 	if (ciph.protocol < 0)
 		return NF_ACCEPT; /* Contained IPv6 hdr looks wrong, ignore */
 
diff --git a/net/netfilter/xt_HMARK.c b/net/netfilter/xt_HMARK.c
index 1686ca1..de8db44 100644
--- a/net/netfilter/xt_HMARK.c
+++ b/net/netfilter/xt_HMARK.c
@@ -167,17 +167,17 @@ hmark_pkt_set_htuple_ipv6(const struct sk_buff *skb, struct hmark_tuple *t,
 			  const struct xt_hmark_info *info)
 {
 	struct ipv6hdr *ip6, _ip6;
-	int flag = IP6T_FH_F_AUTH;
+	int flag = NF_IP6_F_AUTH;
 	unsigned int nhoff = 0;
 	u16 fragoff = 0;
 	int nexthdr;
 
 	ip6 = (struct ipv6hdr *) (skb->data + skb_network_offset(skb));
-	nexthdr = ipv6_find_hdr(skb, &nhoff, -1, &fragoff, &flag);
+	nexthdr = nf_ip6_find_hdr(skb, &nhoff, -1, &fragoff, &flag);
 	if (nexthdr < 0)
 		return 0;
 	/* No need to check for icmp errors on fragments */
-	if ((flag & IP6T_FH_F_FRAG) || (nexthdr != IPPROTO_ICMPV6))
+	if ((flag & NF_IP6_F_FRAG) || (nexthdr != IPPROTO_ICMPV6))
 		goto noicmp;
 	/* Use inner header in case of ICMP errors */
 	if (get_inner6_hdr(skb, &nhoff)) {
@@ -185,8 +185,8 @@ hmark_pkt_set_htuple_ipv6(const struct sk_buff *skb, struct hmark_tuple *t,
 		if (ip6 == NULL)
 			return -1;
 		/* If AH present, use SPI like in ESP. */
-		flag = IP6T_FH_F_AUTH;
-		nexthdr = ipv6_find_hdr(skb, &nhoff, -1, &fragoff, &flag);
+		flag = NF_IP6_F_AUTH;
+		nexthdr = nf_ip6_find_hdr(skb, &nhoff, -1, &fragoff, &flag);
 		if (nexthdr < 0)
 			return -1;
 	}
@@ -201,7 +201,7 @@ noicmp:
 	if (t->proto == IPPROTO_ICMPV6)
 		return 0;
 
-	if (flag & IP6T_FH_F_FRAG)
+	if (flag & NF_IP6_F_FRAG)
 		return 0;
 
 	hmark_set_tuple_ports(skb, nhoff, t, info);
diff --git a/net/netfilter/xt_TPROXY.c b/net/netfilter/xt_TPROXY.c
index d7f1953..a4e0028 100644
--- a/net/netfilter/xt_TPROXY.c
+++ b/net/netfilter/xt_TPROXY.c
@@ -285,7 +285,7 @@ tproxy_tg6_v1(struct sk_buff *skb, const struct xt_action_param *par)
 	int thoff = 0;
 	int tproto;
 
-	tproto = ipv6_find_hdr(skb, &thoff, -1, NULL, NULL);
+	tproto = nf_ip6_find_hdr(skb, &thoff, -1, NULL, NULL);
 	if (tproto < 0) {
 		pr_debug("unable to find transport header in IPv6 packet, dropping\n");
 		return NF_DROP;
diff --git a/net/netfilter/xt_socket.c b/net/netfilter/xt_socket.c
index 63b2bdb..4d3c2e4 100644
--- a/net/netfilter/xt_socket.c
+++ b/net/netfilter/xt_socket.c
@@ -266,7 +266,7 @@ socket_mt6_v1(const struct sk_buff *skb, struct xt_action_param *par)
 	int thoff = 0, uninitialized_var(tproto);
 	const struct xt_socket_mtinfo1 *info = (struct xt_socket_mtinfo1 *) par->matchinfo;
 
-	tproto = ipv6_find_hdr(skb, &thoff, -1, NULL, NULL);
+	tproto = nf_ip6_find_hdr(skb, &thoff, -1, NULL, NULL);
 	if (tproto < 0) {
 		pr_debug("unable to find transport header in IPv6 packet, dropping\n");
 		return NF_DROP;
diff --git a/net/sched/em_ipset.c b/net/sched/em_ipset.c
index 3130320..e5188c8 100644
--- a/net/sched/em_ipset.c
+++ b/net/sched/em_ipset.c
@@ -70,7 +70,7 @@ static int em_ipset_match(struct sk_buff *skb, struct tcf_ematch *em,
 		acpar.family = NFPROTO_IPV6;
 		if (!pskb_network_may_pull(skb, sizeof(struct ipv6hdr)))
 			return 0;
-		/* doesn't call ipv6_find_hdr() because ipset doesn't use thoff, yet */
+		/* doesn't call nf_ip6_find_hdr() because ipset doesn't use thoff, yet */
 		acpar.thoff = sizeof(struct ipv6hdr);
 		break;
 	default:
-- 
1.7.10.4

