From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 1/2] net: netfilter: prepare conntrack for consistent invalid packet handling
Date: Fri,  6 Apr 2012 16:57:32 +0200
Message-ID: <1333724253-32261-2-git-send-email-kadlec@blackhole.kfki.hu>
References: <1333724253-32261-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:43915 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754491Ab2DFO5m (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Apr 2012 10:57:42 -0400
In-Reply-To: <1333724253-32261-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add the net struct as argument to nf_ct_get_tuplepr and get_l4proto
in order to be able to check the setting of nf_conntrack_log_invalid.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 include/net/netfilter/nf_conntrack.h           |    3 ++-
 include/net/netfilter/nf_conntrack_l3proto.h   |    5 +++--
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    3 ++-
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |    2 +-
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |    3 ++-
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |    2 +-
 net/netfilter/nf_conntrack_core.c              |    9 +++++----
 net/netfilter/nf_conntrack_l3proto_generic.c   |    3 ++-
 net/netfilter/xt_connlimit.c                   |    2 +-
 9 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index ab86036..4e6af0a 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -215,7 +215,8 @@ extern void nf_ct_insert_dying_list(struct nf_conn *ct);
 
 extern void nf_conntrack_flush_report(struct net *net, u32 pid, int report);
 
-extern bool nf_ct_get_tuplepr(const struct sk_buff *skb,
+extern bool nf_ct_get_tuplepr(const struct net *net,
+			      const struct sk_buff *skb,
 			      unsigned int nhoff, u_int16_t l3num,
 			      struct nf_conntrack_tuple *tuple);
 extern bool nf_ct_invert_tuplepr(struct nf_conntrack_tuple *inverse,
diff --git a/include/net/netfilter/nf_conntrack_l3proto.h b/include/net/netfilter/nf_conntrack_l3proto.h
index e8010f4..eddb720 100644
--- a/include/net/netfilter/nf_conntrack_l3proto.h
+++ b/include/net/netfilter/nf_conntrack_l3proto.h
@@ -46,8 +46,9 @@ struct nf_conntrack_l3proto {
 	 *	*dataoff: offset of protocol header (TCP, UDP,...) in skb
 	 *	*protonum: protocol number
 	 */
-	int (*get_l4proto)(const struct sk_buff *skb, unsigned int nhoff,
-			   unsigned int *dataoff, u_int8_t *protonum);
+	int (*get_l4proto)(const struct net *net, const struct sk_buff *skb,
+			   unsigned int nhoff, unsigned int *dataoff,
+			   u_int8_t *protonum);
 
 	int (*tuple_to_nlattr)(struct sk_buff *skb,
 			       const struct nf_conntrack_tuple *t);
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index 6a5f038..af7cdc7 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -66,7 +66,8 @@ static int ipv4_print_tuple(struct seq_file *s,
 			  &tuple->src.u3.ip, &tuple->dst.u3.ip);
 }
 
-static int ipv4_get_l4proto(const struct sk_buff *skb, unsigned int nhoff,
+static int ipv4_get_l4proto(const struct net *net,
+			    const struct sk_buff *skb, unsigned int nhoff,
 			    unsigned int *dataoff, u_int8_t *protonum)
 {
 	const struct iphdr *iph;
diff --git a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
index ab5b27a..21ca0e9 100644
--- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
@@ -127,7 +127,7 @@ icmp_error_message(struct net *net, struct nf_conn *tmpl, struct sk_buff *skb,
 	NF_CT_ASSERT(skb->nfct == NULL);
 
 	/* Are they talking about one of our connections? */
-	if (!nf_ct_get_tuplepr(skb,
+	if (!nf_ct_get_tuplepr(net, skb,
 			       skb_network_offset(skb) + ip_hdrlen(skb)
 						       + sizeof(struct icmphdr),
 			       PF_INET, &origtuple)) {
diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index 4111050..c65c060 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -116,7 +116,8 @@ static int nf_ct_ipv6_skip_exthdr(const struct sk_buff *skb, int start,
 	return start;
 }
 
-static int ipv6_get_l4proto(const struct sk_buff *skb, unsigned int nhoff,
+static int ipv6_get_l4proto(const struct net *net,
+			    const struct sk_buff *skb, unsigned int nhoff,
 			    unsigned int *dataoff, u_int8_t *protonum)
 {
 	unsigned int extoff = nhoff + sizeof(struct ipv6hdr);
diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
index 7c05e7e..d87c868 100644
--- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
@@ -143,7 +143,7 @@ icmpv6_error_message(struct net *net, struct nf_conn *tmpl,
 	NF_CT_ASSERT(skb->nfct == NULL);
 
 	/* Are they talking about one of our connections? */
-	if (!nf_ct_get_tuplepr(skb,
+	if (!nf_ct_get_tuplepr(net, skb,
 			       skb_network_offset(skb)
 				+ sizeof(struct ipv6hdr)
 				+ sizeof(struct icmp6hdr),
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index ed86a3b..180f443 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -128,8 +128,9 @@ nf_ct_get_tuple(const struct sk_buff *skb,
 }
 EXPORT_SYMBOL_GPL(nf_ct_get_tuple);
 
-bool nf_ct_get_tuplepr(const struct sk_buff *skb, unsigned int nhoff,
-		       u_int16_t l3num, struct nf_conntrack_tuple *tuple)
+bool nf_ct_get_tuplepr(const struct net *net, const struct sk_buff *skb,
+		       unsigned int nhoff, u_int16_t l3num,
+		       struct nf_conntrack_tuple *tuple)
 {
 	struct nf_conntrack_l3proto *l3proto;
 	struct nf_conntrack_l4proto *l4proto;
@@ -140,7 +141,7 @@ bool nf_ct_get_tuplepr(const struct sk_buff *skb, unsigned int nhoff,
 	rcu_read_lock();
 
 	l3proto = __nf_ct_l3proto_find(l3num);
-	ret = l3proto->get_l4proto(skb, nhoff, &protoff, &protonum);
+	ret = l3proto->get_l4proto(net, skb, nhoff, &protoff, &protonum);
 	if (ret != NF_ACCEPT) {
 		rcu_read_unlock();
 		return false;
@@ -926,7 +927,7 @@ nf_conntrack_in(struct net *net, u_int8_t pf, unsigned int hooknum,
 
 	/* rcu_read_lock()ed by nf_hook_slow */
 	l3proto = __nf_ct_l3proto_find(pf);
-	ret = l3proto->get_l4proto(skb, skb_network_offset(skb),
+	ret = l3proto->get_l4proto(net, skb, skb_network_offset(skb),
 				   &dataoff, &protonum);
 	if (ret <= 0) {
 		pr_debug("not prepared to track yet or error occurred\n");
diff --git a/net/netfilter/nf_conntrack_l3proto_generic.c b/net/netfilter/nf_conntrack_l3proto_generic.c
index e7eb807..ebed8db 100644
--- a/net/netfilter/nf_conntrack_l3proto_generic.c
+++ b/net/netfilter/nf_conntrack_l3proto_generic.c
@@ -55,7 +55,8 @@ static int generic_print_tuple(struct seq_file *s,
 	return 0;
 }
 
-static int generic_get_l4proto(const struct sk_buff *skb, unsigned int nhoff,
+static int generic_get_l4proto(const struct net *net,
+			       const struct sk_buff *skb, unsigned int nhoff,
 			       unsigned int *dataoff, u_int8_t *protonum)
 {
 	/* Never track !!! */
diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
index c6d5a83..36baf0e 100644
--- a/net/netfilter/xt_connlimit.c
+++ b/net/netfilter/xt_connlimit.c
@@ -188,7 +188,7 @@ connlimit_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	ct = nf_ct_get(skb, &ctinfo);
 	if (ct != NULL)
 		tuple_ptr = &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
-	else if (!nf_ct_get_tuplepr(skb, skb_network_offset(skb),
+	else if (!nf_ct_get_tuplepr(net, skb, skb_network_offset(skb),
 				    par->family, &tuple))
 		goto hotdrop;
 
-- 
1.7.0.4

