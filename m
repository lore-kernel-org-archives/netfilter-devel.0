From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 3/3]: nf_conntrack: Introduces nf_ct_get_tuplepr and uses it
Date: Thu, 12 Jul 2007 00:08:10 +0900 (JST)
Message-ID: <200707111508.l6BF8BsH012805@toshiba.co.jp>
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


nf_ct_get_tuple() requires the offset to transport header and that bothers
callers such as icmp[v6] l4proto modules. This introduces new function
to simplify them.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
---
 include/net/netfilter/nf_conntrack.h           |    4 ++
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |   32 ++++--------------
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |   42 ++++-------------------
 net/netfilter/nf_conntrack_core.c              |   30 +++++++++++++++++
 4 files changed, 49 insertions(+), 59 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index d4f02eb..810020e 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -186,6 +186,10 @@ extern void nf_conntrack_hash_insert(struct nf_conn *ct);
 
 extern void nf_conntrack_flush(void);
 
+extern int nf_ct_get_tuplepr(const struct sk_buff *skb,
+			     unsigned int nhoff,
+			     u_int16_t l3num,
+			     struct nf_conntrack_tuple *tuple);
 extern int nf_ct_invert_tuplepr(struct nf_conntrack_tuple *inverse,
 				const struct nf_conntrack_tuple *orig);
 
diff --git a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
index 0fe8fb0..b8b7999 100644
--- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
@@ -136,40 +136,22 @@ icmp_error_message(struct sk_buff *skb,
 		 unsigned int hooknum)
 {
 	struct nf_conntrack_tuple innertuple, origtuple;
-	struct {
-		struct icmphdr icmp;
-		struct iphdr ip;
-	} _in, *inside;
 	struct nf_conntrack_l4proto *innerproto;
 	struct nf_conntrack_tuple_hash *h;
-	int dataoff;
 
 	NF_CT_ASSERT(skb->nfct == NULL);
 
-	/* Not enough header? */
-	inside = skb_header_pointer(skb, ip_hdrlen(skb), sizeof(_in), &_in);
-	if (inside == NULL)
-		return -NF_ACCEPT;
-
-	/* Ignore ICMP's containing fragments (shouldn't happen) */
-	if (inside->ip.frag_off & htons(IP_OFFSET)) {
-		pr_debug("icmp_error_message: fragment of proto %u\n",
-			 inside->ip.protocol);
+	/* Are they talking about one of our connections? */
+	if (!nf_ct_get_tuplepr(skb,
+			       skb_network_offset(skb) + ip_hdrlen(skb)
+						       + sizeof(struct icmphdr),
+			       PF_INET, &origtuple)) {
+		pr_debug("icmp_error_message: failed to get tuple\n");
 		return -NF_ACCEPT;
 	}
 
 	/* rcu_read_lock()ed by nf_hook_slow */
-	innerproto = __nf_ct_l4proto_find(PF_INET, inside->ip.protocol);
-
-	dataoff = ip_hdrlen(skb) + sizeof(inside->icmp);
-	/* Are they talking about one of our connections? */
-	if (!nf_ct_get_tuple(skb, dataoff, dataoff + inside->ip.ihl*4, PF_INET,
-			     inside->ip.protocol, &origtuple,
-			     &nf_conntrack_l3proto_ipv4, innerproto)) {
-		pr_debug("icmp_error_message: ! get_tuple p=%u",
-			 inside->ip.protocol);
-		return -NF_ACCEPT;
-	}
+	innerproto = __nf_ct_l4proto_find(PF_INET, origtuple.dst.protonum);
 
 	/* Ordinarily, we'd expect the inverted tupleproto, but it's
 	   been preserved inside the ICMP. */
diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
index 9defc7e..0fca7e8 100644
--- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
@@ -136,49 +136,23 @@ icmpv6_error_message(struct sk_buff *skb,
 {
 	struct nf_conntrack_tuple intuple, origtuple;
 	struct nf_conntrack_tuple_hash *h;
-	struct icmp6hdr _hdr, *hp;
-	unsigned int inip6off;
 	struct nf_conntrack_l4proto *inproto;
-	u_int8_t inprotonum;
-	unsigned int inprotoff;
 
 	NF_CT_ASSERT(skb->nfct == NULL);
 
-	hp = skb_header_pointer(skb, icmp6off, sizeof(_hdr), &_hdr);
-	if (hp == NULL) {
-		pr_debug("icmpv6_error: Can't get ICMPv6 hdr.\n");
-		return -NF_ACCEPT;
-	}
-
-	inip6off = icmp6off + sizeof(_hdr);
-	if (skb_copy_bits(skb, inip6off+offsetof(struct ipv6hdr, nexthdr),
-			  &inprotonum, sizeof(inprotonum)) != 0) {
-		pr_debug("icmpv6_error: Can't get nexthdr in inner IPv6 "
-			 "header.\n");
-		return -NF_ACCEPT;
-	}
-	inprotoff = nf_ct_ipv6_skip_exthdr(skb,
-					   inip6off + sizeof(struct ipv6hdr),
-					   &inprotonum,
-					   skb->len - inip6off
-						    - sizeof(struct ipv6hdr));
-
-	if ((inprotoff > skb->len) || (inprotonum == NEXTHDR_FRAGMENT)) {
-		pr_debug("icmpv6_error: Can't get protocol header in ICMPv6 "
-			 "payload.\n");
-		return -NF_ACCEPT;
-	}
-
-	/* rcu_read_lock()ed by nf_hook_slow */
-	inproto = __nf_ct_l4proto_find(PF_INET6, inprotonum);
-
 	/* Are they talking about one of our connections? */
-	if (!nf_ct_get_tuple(skb, inip6off, inprotoff, PF_INET6, inprotonum,
-			     &origtuple, &nf_conntrack_l3proto_ipv6, inproto)) {
+	if (!nf_ct_get_tuplepr(skb,
+			       skb_network_offset(skb)
+				+ sizeof(struct ipv6hdr)
+				+ sizeof(struct icmp6hdr),
+			       PF_INET6, &origtuple)) {
 		pr_debug("icmpv6_error: Can't get tuple\n");
 		return -NF_ACCEPT;
 	}
 
+	/* rcu_read_lock()ed by nf_hook_slow */
+	inproto = __nf_ct_l4proto_find(PF_INET6, origtuple.dst.protonum);
+
 	/* Ordinarily, we'd expect the inverted tupleproto, but it's
 	   been preserved inside the ICMP. */
 	if (!nf_ct_invert_tuple(&intuple, &origtuple,
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 5b194e3..8cce814 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -113,6 +113,36 @@ nf_ct_get_tuple(const struct sk_buff *skb,
 }
 EXPORT_SYMBOL_GPL(nf_ct_get_tuple);
 
+int nf_ct_get_tuplepr(const struct sk_buff *skb,
+		      unsigned int nhoff,
+		      u_int16_t l3num,
+		      struct nf_conntrack_tuple *tuple)
+{
+	struct nf_conntrack_l3proto *l3proto;
+	struct nf_conntrack_l4proto *l4proto;
+	unsigned int protoff;
+	u_int8_t protonum;
+	int ret;
+
+	rcu_read_lock();
+
+	l3proto = __nf_ct_l3proto_find(l3num);
+	ret = l3proto->get_l4proto(skb, nhoff, &protoff, &protonum);
+	if (ret != NF_ACCEPT) {
+		rcu_read_unlock();
+		return 0;
+	}
+
+	l4proto = __nf_ct_l4proto_find(l3num, protonum);
+
+	ret = nf_ct_get_tuple(skb, nhoff, protoff, l3num, protonum, tuple,
+			      l3proto, l4proto);
+
+	rcu_read_unlock();
+	return ret;
+}
+EXPORT_SYMBOL_GPL(nf_ct_get_tuplepr);
+
 int
 nf_ct_invert_tuple(struct nf_conntrack_tuple *inverse,
 		   const struct nf_conntrack_tuple *orig,
-- 
1.5.2.2
