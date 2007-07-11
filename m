From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 2/3]: nf_conntrack: Makes l3proto->prepare() generic and
 renames it
Date: Thu, 12 Jul 2007 00:07:56 +0900 (JST)
Message-ID: <200707111507.l6BF7vca021444@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: jengelh@computergmbh.de
To: kaber@trash.net, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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


The icmp[v6] l4proto modules parse headers in ICMP[v6] error to get tuple.
But they have to find the offset to transport protocol header before that.
Their processings are almost same as prepare() of l3proto modules.
This makes prepare() more generic to simplify icmp[v6] l4proto module
later.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
---
 include/net/netfilter/ipv6/nf_conntrack_ipv6.h |    2 +-
 include/net/netfilter/nf_conntrack_l3proto.h   |    6 ++--
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |   23 ++++++++++++--------
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |   27 ++++++++++++++---------
 net/netfilter/nf_conntrack_core.c              |    5 ++-
 net/netfilter/nf_conntrack_l3proto_generic.c   |    7 ++---
 6 files changed, 40 insertions(+), 30 deletions(-)

diff --git a/include/net/netfilter/ipv6/nf_conntrack_ipv6.h b/include/net/netfilter/ipv6/nf_conntrack_ipv6.h
index b4b6049..5a89659 100644
--- a/include/net/netfilter/ipv6/nf_conntrack_ipv6.h
+++ b/include/net/netfilter/ipv6/nf_conntrack_ipv6.h
@@ -7,7 +7,7 @@ extern struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp6;
 extern struct nf_conntrack_l4proto nf_conntrack_l4proto_udp6;
 extern struct nf_conntrack_l4proto nf_conntrack_l4proto_icmpv6;
 
-extern int nf_ct_ipv6_skip_exthdr(struct sk_buff *skb, int start,
+extern int nf_ct_ipv6_skip_exthdr(const struct sk_buff *skb, int start,
 				  u8 *nexthdrp, int len);
 
 extern int nf_ct_frag6_init(void);
diff --git a/include/net/netfilter/nf_conntrack_l3proto.h b/include/net/netfilter/nf_conntrack_l3proto.h
index 890752d..e3708a6 100644
--- a/include/net/netfilter/nf_conntrack_l3proto.h
+++ b/include/net/netfilter/nf_conntrack_l3proto.h
@@ -58,11 +58,11 @@ struct nf_conntrack_l3proto
 
 	/*
 	 * Called before tracking. 
-	 *	*dataoff: offset of protocol header (TCP, UDP,...) in *pskb
+	 *	*dataoff: offset of protocol header (TCP, UDP,...) in skb
 	 *	*protonum: protocol number
 	 */
-	int (*prepare)(struct sk_buff **pskb, unsigned int hooknum,
-		       unsigned int *dataoff, u_int8_t *protonum);
+	int (*get_l4proto)(const struct sk_buff *skb, unsigned int nhoff,
+			   unsigned int *dataoff, u_int8_t *protonum);
 
 	int (*tuple_to_nfattr)(struct sk_buff *skb,
 			       const struct nf_conntrack_tuple *t);
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index 3c56299..ee29f4e 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -78,21 +78,26 @@ nf_ct_ipv4_gather_frags(struct sk_buff *skb, u_int32_t user)
 	return skb;
 }
 
-static int
-ipv4_prepare(struct sk_buff **pskb, unsigned int hooknum, unsigned int *dataoff,
-	     u_int8_t *protonum)
+static int ipv4_get_l4proto(const struct sk_buff *skb, unsigned int nhoff,
+			    unsigned int *dataoff, u_int8_t *protonum)
 {
+	struct iphdr _iph, *iph;
+
+	iph = skb_header_pointer(skb, nhoff, sizeof(_iph), &_iph);
+	if (iph == NULL)
+		return -NF_DROP;
+
 	/* Never happen */
-	if (ip_hdr(*pskb)->frag_off & htons(IP_OFFSET)) {
+	if (iph->frag_off & htons(IP_OFFSET)) {
 		if (net_ratelimit()) {
-			printk(KERN_ERR "ipv4_prepare: Frag of proto %u (hook=%u)\n",
-			ip_hdr(*pskb)->protocol, hooknum);
+			printk(KERN_ERR "ipv4_get_l4proto: Frag of proto %u\n",
+			iph->protocol);
 		}
 		return -NF_DROP;
 	}
 
-	*dataoff = skb_network_offset(*pskb) + ip_hdrlen(*pskb);
-	*protonum = ip_hdr(*pskb)->protocol;
+	*dataoff = nhoff + (iph->ihl << 2);
+	*protonum = iph->protocol;
 
 	return NF_ACCEPT;
 }
@@ -407,7 +412,7 @@ struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv4 = {
 	.invert_tuple	 = ipv4_invert_tuple,
 	.print_tuple	 = ipv4_print_tuple,
 	.print_conntrack = ipv4_print_conntrack,
-	.prepare	 = ipv4_prepare,
+	.get_l4proto	 = ipv4_get_l4proto,
 #if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
 	.tuple_to_nfattr = ipv4_tuple_to_nfattr,
 	.nfattr_to_tuple = ipv4_nfattr_to_tuple,
diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index b5c4bb5..9b7eaaa 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -86,7 +86,7 @@ static int ipv6_print_conntrack(struct seq_file *s,
  *        - Note also special handling of AUTH header. Thanks to IPsec wizards.
  */
 
-int nf_ct_ipv6_skip_exthdr(struct sk_buff *skb, int start, u8 *nexthdrp,
+int nf_ct_ipv6_skip_exthdr(const struct sk_buff *skb, int start, u8 *nexthdrp,
 			   int len)
 {
 	u8 nexthdr = *nexthdrp;
@@ -117,19 +117,24 @@ int nf_ct_ipv6_skip_exthdr(struct sk_buff *skb, int start, u8 *nexthdrp,
 	return start;
 }
 
-static int
-ipv6_prepare(struct sk_buff **pskb, unsigned int hooknum, unsigned int *dataoff,
-	     u_int8_t *protonum)
+static int ipv6_get_l4proto(const struct sk_buff *skb, unsigned int nhoff,
+			    unsigned int *dataoff, u_int8_t *protonum)
 {
-	unsigned int extoff = (u8 *)(ipv6_hdr(*pskb) + 1) - (*pskb)->data;
-	unsigned char pnum = ipv6_hdr(*pskb)->nexthdr;
-	int protoff = nf_ct_ipv6_skip_exthdr(*pskb, extoff, &pnum,
-					     (*pskb)->len - extoff);
+	unsigned int extoff = nhoff + sizeof(struct ipv6hdr);
+	unsigned char pnum;
+	int protoff;
+
+	if (skb_copy_bits(skb, nhoff + offsetof(struct ipv6hdr, nexthdr),
+			  &pnum, sizeof(pnum)) != 0) {
+		pr_debug("ip6_conntrack_core: can't get nexthdr\n");
+		return -NF_ACCEPT;
+	}
+	protoff = nf_ct_ipv6_skip_exthdr(skb, extoff, &pnum, skb->len - extoff);
 	/*
-	 * (protoff == (*pskb)->len) mean that the packet doesn't have no data
+	 * (protoff == skb->len) mean that the packet doesn't have no data
 	 * except of IPv6 & ext headers. but it's tracked anyway. - YK
 	 */
-	if ((protoff < 0) || (protoff > (*pskb)->len)) {
+	if ((protoff < 0) || (protoff > skb->len)) {
 		pr_debug("ip6_conntrack_core: can't find proto in pkt\n");
 		return -NF_ACCEPT;
 	}
@@ -375,7 +380,7 @@ struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv6 = {
 	.invert_tuple		= ipv6_invert_tuple,
 	.print_tuple		= ipv6_print_tuple,
 	.print_conntrack	= ipv6_print_conntrack,
-	.prepare		= ipv6_prepare,
+	.get_l4proto		= ipv6_get_l4proto,
 #if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
 	.tuple_to_nfattr	= ipv6_tuple_to_nfattr,
 	.nfattr_to_tuple	= ipv6_nfattr_to_tuple,
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index b730413..5b194e3 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -622,8 +622,9 @@ nf_conntrack_in(int pf, unsigned int hooknum, struct sk_buff **pskb)
 
 	/* rcu_read_lock()ed by nf_hook_slow */
 	l3proto = __nf_ct_l3proto_find((u_int16_t)pf);
-
-	if ((ret = l3proto->prepare(pskb, hooknum, &dataoff, &protonum)) <= 0) {
+	ret = l3proto->get_l4proto(*pskb, skb_network_offset(*pskb),
+				   &dataoff, &protonum);
+	if (ret <= 0) {
 		pr_debug("not prepared to track yet or error occured\n");
 		NF_CT_STAT_INC_ATOMIC(error);
 		NF_CT_STAT_INC_ATOMIC(invalid);
diff --git a/net/netfilter/nf_conntrack_l3proto_generic.c b/net/netfilter/nf_conntrack_l3proto_generic.c
index b1bfa20..0691642 100644
--- a/net/netfilter/nf_conntrack_l3proto_generic.c
+++ b/net/netfilter/nf_conntrack_l3proto_generic.c
@@ -61,9 +61,8 @@ static int generic_print_conntrack(struct seq_file *s,
 	return 0;
 }
 
-static int
-generic_prepare(struct sk_buff **pskb, unsigned int hooknum,
-		unsigned int *dataoff, u_int8_t *protonum)
+static int generic_get_l4proto(const struct sk_buff *skb, unsigned int nhoff,
+			       unsigned int *dataoff, u_int8_t *protonum)
 {
 	/* Never track !!! */
 	return -NF_ACCEPT;
@@ -77,6 +76,6 @@ struct nf_conntrack_l3proto nf_conntrack_l3proto_generic = {
 	.invert_tuple	 = generic_invert_tuple,
 	.print_tuple	 = generic_print_tuple,
 	.print_conntrack = generic_print_conntrack,
-	.prepare	 = generic_prepare,
+	.get_l4proto	 = generic_get_l4proto,
 };
 EXPORT_SYMBOL_GPL(nf_conntrack_l3proto_generic);
-- 
1.5.2.2
