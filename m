From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH] Change matches and targets to take structs
Date: Tue, 23 Nov 2004 15:03:49 +1100
Message-ID: <1101182629.4842.28.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
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

Feedback welcome; sooner this goes in the sooner we can change iptables
to allow size differences for newer targets/matches (I have a patch
somewhere for that, too).  Then we can add features to targets & matches
without having to rename them!

Name: Change iptables Targets and Matches to Take Whole Struct
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Status: Compiled on 2.6.10-rc2-bk6

When passing iptables targets and matches to the kernel, userspace
includes a size parameter, which was designed to allow backwards
compatibility: you could extend a match by appending fields to the
data section.

Unfortunately, this size is not passed to the ->match and ->target
functions called on each packet, only the ->checkentry function called
on rule insertion.  So we've been bitten by ongoing backwards
compatibility problems.

The solution is simple: instead of passing the ->data pointer to
targets and matches, pass the whole structure, so it can access the
size field if it needs to.  This patch changes all the callers and
all the matches and targets: the transformation is fairly trivial.

Index: linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_MASQUERADE.c
===================================================================
--- linux-2.6.10-rc2-bk6-Netfilter.orig/net/ipv4/netfilter/ipt_MASQUERADE.c	2004-11-22 12:18:42.000000000 +1100
+++ linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_MASQUERADE.c	2004-11-22 12:19:53.000000000 +1100
@@ -74,7 +74,7 @@
 		  const struct net_device *in,
 		  const struct net_device *out,
 		  unsigned int hooknum,
-		  const void *targinfo,
+		  const struct ipt_entry_target *target,
 		  void *userinfo)
 {
 	struct ip_conntrack *ct;
@@ -95,7 +95,7 @@
 	IP_NF_ASSERT(ct && (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED
 	                    || ctinfo == IP_CT_RELATED + IP_CT_IS_REPLY));
 
-	mr = targinfo;
+	mr = (void *)target->data;
 	rt = (struct rtable *)(*pskb)->dst;
 	newsrc = inet_select_addr(out, rt->rt_gateway, RT_SCOPE_UNIVERSE);
 	if (!newsrc) {
Index: linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_tcpmss.c
===================================================================
--- linux-2.6.10-rc2-bk6-Netfilter.orig/net/ipv4/netfilter/ipt_tcpmss.c	2004-11-16 15:30:12.000000000 +1100
+++ linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_tcpmss.c	2004-11-22 12:19:53.000000000 +1100
@@ -77,11 +77,11 @@
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
-      const void *matchinfo,
+      struct ipt_entry_match *match,
       int offset,
       int *hotdrop)
 {
-	const struct ipt_tcpmss_match_info *info = matchinfo;
+	const struct ipt_tcpmss_match_info *info = (void *)match->data;
 
 	return mssoption_match(info->mss_min, info->mss_max, skb,
 			       info->invert, hotdrop);
Index: linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_ECN.c
===================================================================
--- linux-2.6.10-rc2-bk6-Netfilter.orig/net/ipv4/netfilter/ipt_ECN.c	2004-11-16 15:30:12.000000000 +1100
+++ linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_ECN.c	2004-11-22 12:19:53.000000000 +1100
@@ -98,10 +98,10 @@
        const struct net_device *in,
        const struct net_device *out,
        unsigned int hooknum,
-       const void *targinfo,
+       const struct ipt_entry_target *target,
        void *userinfo)
 {
-	const struct ipt_ECN_info *einfo = targinfo;
+	const struct ipt_ECN_info *einfo = (void *)target->data;
 
 	if (einfo->operation & IPT_ECN_OP_SET_IP)
 		if (!set_ect_ip(pskb, einfo))
Index: linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_multiport.c
===================================================================
--- linux-2.6.10-rc2-bk6-Netfilter.orig/net/ipv4/netfilter/ipt_multiport.c	2004-10-19 14:34:25.000000000 +1000
+++ linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_multiport.c	2004-11-22 12:19:53.000000000 +1100
@@ -50,12 +50,12 @@
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
-      const void *matchinfo,
+      struct ipt_entry_match *match,
       int offset,
       int *hotdrop)
 {
 	u16 _ports[2], *pptr;
-	const struct ipt_multiport *multiinfo = matchinfo;
+	const struct ipt_multiport *multiinfo = (void *)match->data;
 
 	/* Must not be a fragment. */
 	if (offset)
Index: linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_REJECT.c
===================================================================
--- linux-2.6.10-rc2-bk6-Netfilter.orig/net/ipv4/netfilter/ipt_REJECT.c	2004-11-22 12:12:04.000000000 +1100
+++ linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_REJECT.c	2004-11-22 12:19:53.000000000 +1100
@@ -356,10 +356,10 @@
 			   const struct net_device *in,
 			   const struct net_device *out,
 			   unsigned int hooknum,
-			   const void *targinfo,
+			   const struct ipt_entry_target *target,
 			   void *userinfo)
 {
-	const struct ipt_reject_info *reject = targinfo;
+	const struct ipt_reject_info *reject = (void *)target->data;
 
 	/* Our naive response construction doesn't deal with IP
            options, and probably shouldn't try. */
Index: linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_realm.c
===================================================================
--- linux-2.6.10-rc2-bk6-Netfilter.orig/net/ipv4/netfilter/ipt_realm.c	2004-09-28 16:22:19.000000000 +1000
+++ linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_realm.c	2004-11-22 12:19:54.000000000 +1100
@@ -25,11 +25,11 @@
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
-      const void *matchinfo,
+      struct ipt_entry_match *match,
       int offset,
       int *hotdrop)
 {
-	const struct ipt_realm_info *info = matchinfo;
+	const struct ipt_realm_info *info = (void *)match->data;
 	struct dst_entry *dst = skb->dst;
     
 	return (info->id == (dst->tclassid & info->mask)) ^ info->invert;
Index: linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_CLUSTERIP.c
===================================================================
--- linux-2.6.10-rc2-bk6-Netfilter.orig/net/ipv4/netfilter/ipt_CLUSTERIP.c	2004-11-16 15:30:12.000000000 +1100
+++ linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_CLUSTERIP.c	2004-11-22 15:42:57.418236384 +1100
@@ -313,10 +313,10 @@
        const struct net_device *in,
        const struct net_device *out,
        unsigned int hooknum,
-       const void *targinfo,
+       const struct ipt_entry_target *target,
        void *userinfo)
 {
-	const struct ipt_clusterip_tgt_info *cipinfo = targinfo;
+	const struct ipt_clusterip_tgt_info *cipinfo = (void *)target->data;
 	enum ip_conntrack_info ctinfo;
 	struct ip_conntrack *ct = ip_conntrack_get((*pskb), &ctinfo);
 	u_int32_t hash;
Index: linux-2.6.10-rc2-bk6-Netfilter/include/linux/netfilter_ipv4/ip_tables.h
===================================================================
--- linux-2.6.10-rc2-bk6-Netfilter.orig/include/linux/netfilter_ipv4/ip_tables.h	2004-11-16 15:30:07.000000000 +1100
+++ linux-2.6.10-rc2-bk6-Netfilter/include/linux/netfilter_ipv4/ip_tables.h	2004-11-22 12:19:54.000000000 +1100
@@ -354,7 +354,7 @@
 	int (*match)(const struct sk_buff *skb,
 		     const struct net_device *in,
 		     const struct net_device *out,
-		     const void *matchinfo,
+		     struct ipt_entry_match *match,
 		     int offset,
 		     int *hotdrop);
 
@@ -400,7 +400,7 @@
 			       const struct net_device *in,
 			       const struct net_device *out,
 			       unsigned int hooknum,
-			       const void *targinfo,
+			       const struct ipt_entry_target *target,
 			       void *userdata);
 
 	/* Set this to THIS_MODULE. */
Index: linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_iprange.c
===================================================================
--- linux-2.6.10-rc2-bk6-Netfilter.orig/net/ipv4/netfilter/ipt_iprange.c	2004-02-18 23:54:37.000000000 +1100
+++ linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_iprange.c	2004-11-22 12:19:54.000000000 +1100
@@ -27,10 +27,10 @@
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
-      const void *matchinfo,
+      struct ipt_entry_match *match,
       int offset, int *hotdrop)
 {
-	const struct ipt_iprange_info *info = matchinfo;
+	const struct ipt_iprange_info *info = (void *)match->data;
 	const struct iphdr *iph = skb->nh.iph;
 
 	if (info->flags & IPRANGE_SRC) {
Index: linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ip_tables.c
===================================================================
--- linux-2.6.10-rc2-bk6-Netfilter.orig/net/ipv4/netfilter/ip_tables.c	2004-11-22 12:12:04.000000000 +1100
+++ linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ip_tables.c	2004-11-22 12:19:54.000000000 +1100
@@ -224,11 +224,11 @@
 	  const struct net_device *in,
 	  const struct net_device *out,
 	  unsigned int hooknum,
-	  const void *targinfo,
+	  const struct ipt_entry_target *target,
 	  void *userinfo)
 {
 	if (net_ratelimit())
-		printk("ip_tables: error: `%s'\n", (char *)targinfo);
+		printk("ip_tables: error: `%s'\n", target->data);
 
 	return NF_DROP;
 }
@@ -242,7 +242,7 @@
 	     int *hotdrop)
 {
 	/* Stop iteration if it doesn't match */
-	if (!m->u.kernel.match->match(skb, in, out, m->data, offset, hotdrop))
+	if (!m->u.kernel.match->match(skb, in, out, m, offset, hotdrop))
 		return 1;
 	else
 		return 0;
@@ -363,7 +363,7 @@
 				verdict = t->u.kernel.target->target(pskb,
 								     in, out,
 								     hook,
-								     t->data,
+								     t,
 								     userdata);
 
 #ifdef CONFIG_NETFILTER_DEBUG
@@ -1502,12 +1502,12 @@
 tcp_match(const struct sk_buff *skb,
 	  const struct net_device *in,
 	  const struct net_device *out,
-	  const void *matchinfo,
+	  struct ipt_entry_match *match,
 	  int offset,
 	  int *hotdrop)
 {
 	struct tcphdr _tcph, *th;
-	const struct ipt_tcp *tcpinfo = matchinfo;
+	const struct ipt_tcp *tcpinfo = (void *)match->data;
 
 	if (offset) {
 		/* To quote Alan:
@@ -1583,12 +1583,12 @@
 udp_match(const struct sk_buff *skb,
 	  const struct net_device *in,
 	  const struct net_device *out,
-	  const void *matchinfo,
+	  struct ipt_entry_match *match,
 	  int offset,
 	  int *hotdrop)
 {
 	struct udphdr _udph, *uh;
-	const struct ipt_udp *udpinfo = matchinfo;
+	const struct ipt_udp *udpinfo = (void *)match->data;
 
 	/* Must not be a fragment. */
 	if (offset)
@@ -1656,12 +1656,12 @@
 icmp_match(const struct sk_buff *skb,
 	   const struct net_device *in,
 	   const struct net_device *out,
-	   const void *matchinfo,
+	   struct ipt_entry_match *match,
 	   int offset,
 	   int *hotdrop)
 {
 	struct icmphdr _icmph, *ic;
-	const struct ipt_icmp *icmpinfo = matchinfo;
+	const struct ipt_icmp *icmpinfo = (void *)match->data;
 
 	/* Must not be a fragment. */
 	if (offset)
Index: linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_NETMAP.c
===================================================================
--- linux-2.6.10-rc2-bk6-Netfilter.orig/net/ipv4/netfilter/ipt_NETMAP.c	2004-11-22 12:18:42.000000000 +1100
+++ linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_NETMAP.c	2004-11-22 12:19:54.000000000 +1100
@@ -66,13 +66,13 @@
        const struct net_device *in,
        const struct net_device *out,
        unsigned int hooknum,
-       const void *targinfo,
+       const struct ipt_entry_target *target,
        void *userinfo)
 {
 	struct ip_conntrack *ct;
 	enum ip_conntrack_info ctinfo;
 	u_int32_t new_ip, netmask;
-	const struct ip_nat_multi_range_compat *mr = targinfo;
+	const struct ip_nat_multi_range_compat *mr = (void *)target->data;
 	struct ip_nat_range newrange;
 
 	IP_NF_ASSERT(hooknum == NF_IP_PRE_ROUTING
Index: linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_connmark.c
===================================================================
--- linux-2.6.10-rc2-bk6-Netfilter.orig/net/ipv4/netfilter/ipt_connmark.c	2004-11-22 15:07:50.876479408 +1100
+++ linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_connmark.c	2004-11-22 15:08:09.357669840 +1100
@@ -34,11 +34,11 @@
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
-      const void *matchinfo,
+      struct ipt_entry_match *match,
       int offset,
       int *hotdrop)
 {
-	const struct ipt_connmark_info *info = matchinfo;
+	const struct ipt_connmark_info *info = (void *)match->data;
 	enum ip_conntrack_info ctinfo;
 	struct ip_conntrack *ct = ip_conntrack_get((struct sk_buff *)skb, &ctinfo);
 	if (!ct)
Index: linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_sctp.c
===================================================================
--- linux-2.6.10-rc2-bk6-Netfilter.orig/net/ipv4/netfilter/ipt_sctp.c	2004-10-19 14:34:25.000000000 +1000
+++ linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_sctp.c	2004-11-22 12:19:54.000000000 +1100
@@ -116,14 +116,14 @@
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
-      const void *matchinfo,
+      struct ipt_entry_match *match,
       int offset,
       int *hotdrop)
 {
 	const struct ipt_sctp_info *info;
 	sctp_sctphdr_t _sh, *sh;
 
-	info = (const struct ipt_sctp_info *)matchinfo;
+	info = (const struct ipt_sctp_info *)match->data;
 
 	if (offset) {
 		duprintf("Dropping non-first fragment.. FIXME\n");
Index: linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_REDIRECT.c
===================================================================
--- linux-2.6.10-rc2-bk6-Netfilter.orig/net/ipv4/netfilter/ipt_REDIRECT.c	2004-11-22 12:18:42.000000000 +1100
+++ linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_REDIRECT.c	2004-11-22 12:19:54.000000000 +1100
@@ -68,13 +68,13 @@
 		const struct net_device *in,
 		const struct net_device *out,
 		unsigned int hooknum,
-		const void *targinfo,
+		const struct ipt_entry_target *target,
 		void *userinfo)
 {
 	struct ip_conntrack *ct;
 	enum ip_conntrack_info ctinfo;
 	u_int32_t newdst;
-	const struct ip_nat_multi_range_compat *mr = targinfo;
+	const struct ip_nat_multi_range_compat *mr = (void *)target->data;
 	struct ip_nat_range newrange;
 
 	IP_NF_ASSERT(hooknum == NF_IP_PRE_ROUTING
Index: linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_MARK.c
===================================================================
--- linux-2.6.10-rc2-bk6-Netfilter.orig/net/ipv4/netfilter/ipt_MARK.c	2004-02-18 23:54:37.000000000 +1100
+++ linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_MARK.c	2004-11-22 12:19:54.000000000 +1100
@@ -24,10 +24,10 @@
        const struct net_device *in,
        const struct net_device *out,
        unsigned int hooknum,
-       const void *targinfo,
+       const struct ipt_entry_target *target,
        void *userinfo)
 {
-	const struct ipt_mark_target_info *markinfo = targinfo;
+	const struct ipt_mark_target_info *markinfo = (void *)target->data;
 
 	if((*pskb)->nfmark != markinfo->mark) {
 		(*pskb)->nfmark = markinfo->mark;
Index: linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_ttl.c
===================================================================
--- linux-2.6.10-rc2-bk6-Netfilter.orig/net/ipv4/netfilter/ipt_ttl.c	2004-02-18 23:54:37.000000000 +1100
+++ linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_ttl.c	2004-11-22 12:19:54.000000000 +1100
@@ -20,10 +20,10 @@
 MODULE_LICENSE("GPL");
 
 static int match(const struct sk_buff *skb, const struct net_device *in,
-		 const struct net_device *out, const void *matchinfo,
+		 const struct net_device *out, struct ipt_entry_match *match,
 		 int offset, int *hotdrop)
 {
-	const struct ipt_ttl_info *info = matchinfo;
+	const struct ipt_ttl_info *info = (void *)match->data;
 
 	switch (info->mode) {
 		case IPT_TTL_EQ:
Index: linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_owner.c
===================================================================
--- linux-2.6.10-rc2-bk6-Netfilter.orig/net/ipv4/netfilter/ipt_owner.c	2004-09-28 16:22:19.000000000 +1000
+++ linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_owner.c	2004-11-22 12:19:54.000000000 +1100
@@ -124,11 +124,11 @@
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
-      const void *matchinfo,
+      struct ipt_entry_match *match,
       int offset,
       int *hotdrop)
 {
-	const struct ipt_owner_info *info = matchinfo;
+	const struct ipt_owner_info *info = (void *)match->data;
 
 	if (!skb->sk || !skb->sk->sk_socket || !skb->sk->sk_socket->file)
 		return 0;
Index: linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_SAME.c
===================================================================
--- linux-2.6.10-rc2-bk6-Netfilter.orig/net/ipv4/netfilter/ipt_SAME.c	2004-11-22 12:18:42.000000000 +1100
+++ linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_SAME.c	2004-11-22 12:19:54.000000000 +1100
@@ -143,13 +143,13 @@
 		const struct net_device *in,
 		const struct net_device *out,
 		unsigned int hooknum,
-		const void *targinfo,
+		const struct ipt_entry_target *target,
 		void *userinfo)
 {
 	struct ip_conntrack *ct;
 	enum ip_conntrack_info ctinfo;
 	u_int32_t tmpip, aindex, new_ip;
-	const struct ipt_same_info *same = targinfo;
+	const struct ipt_same_info *same = (void *)target->data;
 	struct ip_nat_range newrange;
 	const struct ip_conntrack_tuple *t;
 
Index: linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_mark.c
===================================================================
--- linux-2.6.10-rc2-bk6-Netfilter.orig/net/ipv4/netfilter/ipt_mark.c	2004-02-18 23:54:37.000000000 +1100
+++ linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_mark.c	2004-11-22 12:19:54.000000000 +1100
@@ -21,11 +21,11 @@
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
-      const void *matchinfo,
+      struct ipt_entry_match *match,
       int offset,
       int *hotdrop)
 {
-	const struct ipt_mark_info *info = matchinfo;
+	const struct ipt_mark_info *info = (void *)match->data;
 
 	return ((skb->nfmark & info->mask) == info->mark) ^ info->invert;
 }
Index: linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_ULOG.c
===================================================================
--- linux-2.6.10-rc2-bk6-Netfilter.orig/net/ipv4/netfilter/ipt_ULOG.c	2004-11-16 15:30:12.000000000 +1100
+++ linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_ULOG.c	2004-11-22 12:19:54.000000000 +1100
@@ -295,9 +295,10 @@
 				    const struct net_device *in,
 				    const struct net_device *out,
 				    unsigned int hooknum,
-				    const void *targinfo, void *userinfo)
+				    const struct ipt_entry_target *target,
+				    void *userinfo)
 {
-	struct ipt_ulog_info *loginfo = (struct ipt_ulog_info *) targinfo;
+	struct ipt_ulog_info *loginfo = (struct ipt_ulog_info *)target->data;
 
 	ipt_ulog_packet(hooknum, *pskb, in, out, loginfo, NULL);
  
Index: linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_CONNMARK.c
===================================================================
--- linux-2.6.10-rc2-bk6-Netfilter.orig/net/ipv4/netfilter/ipt_CONNMARK.c	2004-11-16 15:30:12.000000000 +1100
+++ linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_CONNMARK.c	2004-11-22 15:42:43.481355112 +1100
@@ -36,10 +36,10 @@
        const struct net_device *in,
        const struct net_device *out,
        unsigned int hooknum,
-       const void *targinfo,
+       const struct ipt_entry_target *target,
        void *userinfo)
 {
-	const struct ipt_connmark_target_info *markinfo = targinfo;
+	const struct ipt_connmark_target_info *markinfo = (void *)target->data;
 	unsigned long diff;
 	unsigned long nfmark;
 	unsigned long newmark;
Index: linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_DSCP.c
===================================================================
--- linux-2.6.10-rc2-bk6-Netfilter.orig/net/ipv4/netfilter/ipt_DSCP.c	2004-02-18 23:54:37.000000000 +1100
+++ linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_DSCP.c	2004-11-22 12:19:54.000000000 +1100
@@ -29,10 +29,10 @@
        const struct net_device *in,
        const struct net_device *out,
        unsigned int hooknum,
-       const void *targinfo,
+       const struct ipt_entry_target *target,
        void *userinfo)
 {
-	const struct ipt_DSCP_info *dinfo = targinfo;
+	const struct ipt_DSCP_info *dinfo = (void *)target->data;
 	u_int8_t sh_dscp = ((dinfo->dscp << IPT_DSCP_SHIFT) & IPT_DSCP_MASK);
 
 
Index: linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_tos.c
===================================================================
--- linux-2.6.10-rc2-bk6-Netfilter.orig/net/ipv4/netfilter/ipt_tos.c	2004-02-18 23:54:37.000000000 +1100
+++ linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_tos.c	2004-11-22 12:19:54.000000000 +1100
@@ -21,11 +21,11 @@
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
-      const void *matchinfo,
+      struct ipt_entry_match *match,
       int offset,
       int *hotdrop)
 {
-	const struct ipt_tos_info *info = matchinfo;
+	const struct ipt_tos_info *info = (void *)match->data;
 
 	return (skb->nh.iph->tos == info->tos) ^ info->invert;
 }
Index: linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_state.c
===================================================================
--- linux-2.6.10-rc2-bk6-Netfilter.orig/net/ipv4/netfilter/ipt_state.c	2004-10-19 14:34:25.000000000 +1000
+++ linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_state.c	2004-11-22 12:19:54.000000000 +1100
@@ -22,11 +22,11 @@
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
-      const void *matchinfo,
+      struct ipt_entry_match *match,
       int offset,
       int *hotdrop)
 {
-	const struct ipt_state_info *sinfo = matchinfo;
+	const struct ipt_state_info *sinfo = (void *)match->data;
 	enum ip_conntrack_info ctinfo;
 	unsigned int statebit;
 
Index: linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_recent.c
===================================================================
--- linux-2.6.10-rc2-bk6-Netfilter.orig/net/ipv4/netfilter/ipt_recent.c	2004-11-16 15:30:12.000000000 +1100
+++ linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_recent.c	2004-11-22 12:19:54.000000000 +1100
@@ -102,7 +102,7 @@
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
-      const void *matchinfo,
+      struct ipt_entry_match *match,
       int offset,
       int *hotdrop);
 
@@ -317,7 +317,9 @@
 	skb->nh.iph->daddr = 0;
 	/* Clear ttl since we have no way of knowing it */
 	skb->nh.iph->ttl = 0;
-	match(skb,NULL,NULL,info,0,NULL);
+	/* We fake up a "struct ipt_entry_match" here, since we only use
+	   the data field anyway. */
+	match(skb,NULL,NULL,(void *)info-sizeof(struct ipt_entry_match),0,NULL);
 
 	kfree(skb->nh.iph);
 out_free_skb:
@@ -355,13 +357,13 @@
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
-      const void *matchinfo,
+      struct ipt_entry_match *match,
       int offset,
       int *hotdrop)
 {
 	int pkt_count, hits_found, ans;
 	unsigned long now;
-	const struct ipt_recent_info *info = matchinfo;
+	const struct ipt_recent_info *info = (void *)match->data;
 	u_int32_t addr = 0, time_temp;
 	u_int8_t ttl = skb->nh.iph->ttl;
 	int *hash_table;
Index: linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ip_nat_rule.c
===================================================================
--- linux-2.6.10-rc2-bk6-Netfilter.orig/net/ipv4/netfilter/ip_nat_rule.c	2004-11-22 12:18:42.000000000 +1100
+++ linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ip_nat_rule.c	2004-11-22 12:19:54.000000000 +1100
@@ -121,12 +121,12 @@
 				    const struct net_device *in,
 				    const struct net_device *out,
 				    unsigned int hooknum,
-				    const void *targinfo,
+				    const struct ipt_entry_target *target,
 				    void *userinfo)
 {
 	struct ip_conntrack *ct;
 	enum ip_conntrack_info ctinfo;
-	const struct ip_nat_multi_range_compat *mr = targinfo;
+	const struct ip_nat_multi_range_compat *mr = (void *)target->data;
 
 	IP_NF_ASSERT(hooknum == NF_IP_POST_ROUTING);
 
@@ -144,12 +144,12 @@
 				    const struct net_device *in,
 				    const struct net_device *out,
 				    unsigned int hooknum,
-				    const void *targinfo,
+				    const struct ipt_entry_target *target,
 				    void *userinfo)
 {
 	struct ip_conntrack *ct;
 	enum ip_conntrack_info ctinfo;
-	const struct ip_nat_multi_range_compat *mr = targinfo;
+	const struct ip_nat_multi_range_compat *mr = (void *)target->data;
 
 #ifdef CONFIG_IP_NF_NAT_LOCAL
 	IP_NF_ASSERT(hooknum == NF_IP_PRE_ROUTING
Index: linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_TOS.c
===================================================================
--- linux-2.6.10-rc2-bk6-Netfilter.orig/net/ipv4/netfilter/ipt_TOS.c	2004-02-18 23:54:37.000000000 +1100
+++ linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_TOS.c	2004-11-22 12:19:54.000000000 +1100
@@ -25,10 +25,10 @@
        const struct net_device *in,
        const struct net_device *out,
        unsigned int hooknum,
-       const void *targinfo,
+       const struct ipt_entry_target *target,
        void *userinfo)
 {
-	const struct ipt_tos_target_info *tosinfo = targinfo;
+	const struct ipt_tos_target_info *tosinfo = (void *)target->data;
 
 	if (((*pskb)->nh.iph->tos & IPTOS_TOS_MASK) != tosinfo->tos) {
 		u_int16_t diffs[2];
Index: linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_esp.c
===================================================================
--- linux-2.6.10-rc2-bk6-Netfilter.orig/net/ipv4/netfilter/ipt_esp.c	2004-10-19 14:34:25.000000000 +1000
+++ linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_esp.c	2004-11-22 12:19:54.000000000 +1100
@@ -40,12 +40,12 @@
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
-      const void *matchinfo,
+      struct ipt_entry_match *match,
       int offset,
       int *hotdrop)
 {
 	struct ip_esp_hdr _esp, *eh;
-	const struct ipt_esp *espinfo = matchinfo;
+	const struct ipt_esp *espinfo = (void *)match->data;
 
 	/* Must not be a fragment. */
 	if (offset)
Index: linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_helper.c
===================================================================
--- linux-2.6.10-rc2-bk6-Netfilter.orig/net/ipv4/netfilter/ipt_helper.c	2004-10-19 14:34:25.000000000 +1000
+++ linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_helper.c	2004-11-22 12:19:54.000000000 +1100
@@ -33,11 +33,11 @@
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
-      const void *matchinfo,
+      struct ipt_entry_match *match,
       int offset,
       int *hotdrop)
 {
-	const struct ipt_helper_info *info = matchinfo;
+	const struct ipt_helper_info *info = (void *)match->data;
 	struct ip_conntrack_expect *exp;
 	struct ip_conntrack *ct;
 	enum ip_conntrack_info ctinfo;
Index: linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_dscp.c
===================================================================
--- linux-2.6.10-rc2-bk6-Netfilter.orig/net/ipv4/netfilter/ipt_dscp.c	2004-02-18 23:54:37.000000000 +1100
+++ linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_dscp.c	2004-11-22 12:19:54.000000000 +1100
@@ -20,10 +20,10 @@
 MODULE_LICENSE("GPL");
 
 static int match(const struct sk_buff *skb, const struct net_device *in,
-		 const struct net_device *out, const void *matchinfo,
+		 const struct net_device *out, struct ipt_entry_match *match,
 		 int offset, int *hotdrop)
 {
-	const struct ipt_dscp_info *info = matchinfo;
+	const struct ipt_dscp_info *info = (void *)match->data;
 	const struct iphdr *iph = skb->nh.iph;
 
 	u_int8_t sh_dscp = ((info->dscp << IPT_DSCP_SHIFT) & IPT_DSCP_MASK);
Index: linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_TCPMSS.c
===================================================================
--- linux-2.6.10-rc2-bk6-Netfilter.orig/net/ipv4/netfilter/ipt_TCPMSS.c	2004-06-17 08:49:54.000000000 +1000
+++ linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_TCPMSS.c	2004-11-22 12:19:54.000000000 +1100
@@ -48,10 +48,10 @@
 		  const struct net_device *in,
 		  const struct net_device *out,
 		  unsigned int hooknum,
-		  const void *targinfo,
+		  const struct ipt_entry_target *target,
 		  void *userinfo)
 {
-	const struct ipt_tcpmss_info *tcpmssinfo = targinfo;
+	const struct ipt_tcpmss_info *tcpmssinfo = (void *)target->data;
 	struct tcphdr *tcph;
 	struct iphdr *iph;
 	u_int16_t tcplen, newtotlen, oldval, newmss;
Index: linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_comment.c
===================================================================
--- linux-2.6.10-rc2-bk6-Netfilter.orig/net/ipv4/netfilter/ipt_comment.c	2004-11-22 15:05:54.737135272 +1100
+++ linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_comment.c	2004-11-22 15:06:11.881528928 +1100
@@ -17,7 +17,7 @@
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
-      const void *matchinfo,
+      struct ipt_entry_match *match,
       int offset,
       int *hotdrop)
 {
Index: linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_conntrack.c
===================================================================
--- linux-2.6.10-rc2-bk6-Netfilter.orig/net/ipv4/netfilter/ipt_conntrack.c	2004-10-19 14:34:25.000000000 +1000
+++ linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_conntrack.c	2004-11-22 12:19:54.000000000 +1100
@@ -22,11 +22,11 @@
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
-      const void *matchinfo,
+      struct ipt_entry_match *match,
       int offset,
       int *hotdrop)
 {
-	const struct ipt_conntrack_info *sinfo = matchinfo;
+	const struct ipt_conntrack_info *sinfo = (void *)match->data;
 	struct ip_conntrack *ct;
 	enum ip_conntrack_info ctinfo;
 	unsigned int statebit;
Index: linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_limit.c
===================================================================
--- linux-2.6.10-rc2-bk6-Netfilter.orig/net/ipv4/netfilter/ipt_limit.c	2004-02-18 23:54:37.000000000 +1100
+++ linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_limit.c	2004-11-22 12:19:54.000000000 +1100
@@ -66,11 +66,11 @@
 ipt_limit_match(const struct sk_buff *skb,
 		const struct net_device *in,
 		const struct net_device *out,
-		const void *matchinfo,
+		struct ipt_entry_match *match,
 		int offset,
 		int *hotdrop)
 {
-	struct ipt_rateinfo *r = ((struct ipt_rateinfo *)matchinfo)->master;
+	struct ipt_rateinfo *r = ((struct ipt_rateinfo *)match->data)->master;
 	unsigned long now = jiffies;
 
 	spin_lock_bh(&limit_lock);
Index: linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_LOG.c
===================================================================
--- linux-2.6.10-rc2-bk6-Netfilter.orig/net/ipv4/netfilter/ipt_LOG.c	2004-10-19 14:34:25.000000000 +1000
+++ linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_LOG.c	2004-11-22 12:19:54.000000000 +1100
@@ -393,10 +393,10 @@
 	       const struct net_device *in,
 	       const struct net_device *out,
 	       unsigned int hooknum,
-	       const void *targinfo,
+	       const struct ipt_entry_target *target,
 	       void *userinfo)
 {
-	const struct ipt_log_info *loginfo = targinfo;
+	const struct ipt_log_info *loginfo = (void *)target->data;
 	char level_string[4] = "< >";
 
 	level_string[1] = '0' + (loginfo->level % 8);
Index: linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_mac.c
===================================================================
--- linux-2.6.10-rc2-bk6-Netfilter.orig/net/ipv4/netfilter/ipt_mac.c	2004-10-19 14:34:25.000000000 +1000
+++ linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_mac.c	2004-11-22 12:19:54.000000000 +1100
@@ -23,11 +23,11 @@
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
-      const void *matchinfo,
+      struct ipt_entry_match *match,
       int offset,
       int *hotdrop)
 {
-    const struct ipt_mac_info *info = matchinfo;
+    const struct ipt_mac_info *info = (void *)match->data;
 
     /* Is mac pointer valid? */
     return (skb->mac.raw >= skb->head
Index: linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_CLASSIFY.c
===================================================================
--- linux-2.6.10-rc2-bk6-Netfilter.orig/net/ipv4/netfilter/ipt_CLASSIFY.c	2004-09-28 16:22:19.000000000 +1000
+++ linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_CLASSIFY.c	2004-11-22 12:19:54.000000000 +1100
@@ -27,10 +27,10 @@
        const struct net_device *in,
        const struct net_device *out,
        unsigned int hooknum,
-       const void *targinfo,
+       const struct ipt_entry_target *target,
        void *userinfo)
 {
-	const struct ipt_classify_target_info *clinfo = targinfo;
+	const struct ipt_classify_target_info *clinfo = (void *)target->data;
 
 	if((*pskb)->priority != clinfo->priority) {
 		(*pskb)->priority = clinfo->priority;
Index: linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_physdev.c
===================================================================
--- linux-2.6.10-rc2-bk6-Netfilter.orig/net/ipv4/netfilter/ipt_physdev.c	2004-02-18 23:54:37.000000000 +1100
+++ linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_physdev.c	2004-11-22 12:19:54.000000000 +1100
@@ -24,13 +24,13 @@
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
-      const void *matchinfo,
+      struct ipt_entry_match *match,
       int offset,
       int *hotdrop)
 {
 	int i;
 	static const char nulldevname[IFNAMSIZ];
-	const struct ipt_physdev_info *info = matchinfo;
+	const struct ipt_physdev_info *info = (void *)match->data;
 	unsigned int ret;
 	const char *indev, *outdev;
 	struct nf_bridge_info *nf_bridge;
Index: linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_ecn.c
===================================================================
--- linux-2.6.10-rc2-bk6-Netfilter.orig/net/ipv4/netfilter/ipt_ecn.c	2004-10-19 14:34:25.000000000 +1000
+++ linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_ecn.c	2004-11-22 12:19:54.000000000 +1100
@@ -66,10 +66,10 @@
 }
 
 static int match(const struct sk_buff *skb, const struct net_device *in,
-		 const struct net_device *out, const void *matchinfo,
+		 const struct net_device *out, struct ipt_entry_match *match,
 		 int offset, int *hotdrop)
 {
-	const struct ipt_ecn_info *info = matchinfo;
+	const struct ipt_ecn_info *info = (void *)match->data;
 
 	if (info->operation & IPT_ECN_OP_MATCH_IP)
 		if (!match_ip(skb, info))
Index: linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_length.c
===================================================================
--- linux-2.6.10-rc2-bk6-Netfilter.orig/net/ipv4/netfilter/ipt_length.c	2004-02-18 23:54:37.000000000 +1100
+++ linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_length.c	2004-11-22 12:19:54.000000000 +1100
@@ -20,11 +20,11 @@
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
-      const void *matchinfo,
+      struct ipt_entry_match *match,
       int offset,
       int *hotdrop)
 {
-	const struct ipt_length_info *info = matchinfo;
+	const struct ipt_length_info *info = (void *)match->data;
 	u_int16_t pktlen = ntohs(skb->nh.iph->tot_len);
 	
 	return (pktlen >= info->min && pktlen <= info->max) ^ info->invert;
Index: linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_pkttype.c
===================================================================
--- linux-2.6.10-rc2-bk6-Netfilter.orig/net/ipv4/netfilter/ipt_pkttype.c	2004-02-18 23:54:37.000000000 +1100
+++ linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_pkttype.c	2004-11-22 12:19:54.000000000 +1100
@@ -20,11 +20,11 @@
 static int match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
-      const void *matchinfo,
+      struct ipt_entry_match *match,
       int offset,
       int *hotdrop)
 {
-    const struct ipt_pkttype_info *info = matchinfo;
+    const struct ipt_pkttype_info *info = (void *)match->data;
 
     return (skb->pkt_type == info->pkttype) ^ info->invert;
 }
Index: linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_ah.c
===================================================================
--- linux-2.6.10-rc2-bk6-Netfilter.orig/net/ipv4/netfilter/ipt_ah.c	2004-10-19 14:34:25.000000000 +1000
+++ linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_ah.c	2004-11-22 12:19:54.000000000 +1100
@@ -39,12 +39,12 @@
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
-      const void *matchinfo,
+      struct ipt_entry_match *match,
       int offset,
       int *hotdrop)
 {
 	struct ip_auth_hdr _ahdr, *ah;
-	const struct ipt_ah *ahinfo = matchinfo;
+	const struct ipt_ah *ahinfo = (void *)match->data;
 
 	/* Must not be a fragment. */
 	if (offset)
Index: linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_hashlimit.c
===================================================================
--- linux-2.6.10-rc2-bk6-Netfilter.orig/net/ipv4/netfilter/ipt_hashlimit.c	2004-11-22 15:08:21.992749016 +1100
+++ linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_hashlimit.c	2004-11-22 15:08:39.146141304 +1100
@@ -422,12 +422,12 @@
 hashlimit_match(const struct sk_buff *skb,
 		const struct net_device *in,
 		const struct net_device *out,
-		const void *matchinfo,
+		struct ipt_entry_match *match,
 		int offset,
 		int *hotdrop)
 {
 	struct ipt_hashlimit_info *r = 
-		((struct ipt_hashlimit_info *)matchinfo)->u.master;
+		((struct ipt_hashlimit_info *)match->data)->u.master;
 	struct ipt_hashlimit_htable *hinfo = r->hinfo;
 	unsigned long now = jiffies;
 	struct dsthash_ent *dh;
Index: linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_addrtype.c
===================================================================
--- linux-2.6.10-rc2-bk6-Netfilter.orig/net/ipv4/netfilter/ipt_addrtype.c	2004-09-28 16:22:19.000000000 +1000
+++ linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_addrtype.c	2004-11-22 12:19:54.000000000 +1100
@@ -28,10 +28,10 @@
 }
 
 static int match(const struct sk_buff *skb, const struct net_device *in,
-		 const struct net_device *out, const void *matchinfo,
+		 const struct net_device *out, struct ipt_entry_match *match,
 		 int offset, int *hotdrop)
 {
-	const struct ipt_addrtype_info *info = matchinfo;
+	const struct ipt_addrtype_info *info = (void *)match->data;
 	const struct iphdr *iph = skb->nh.iph;
 	int ret = 1;
 
Index: linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_NOTRACK.c
===================================================================
--- linux-2.6.10-rc2-bk6-Netfilter.orig/net/ipv4/netfilter/ipt_NOTRACK.c	2004-10-19 14:34:25.000000000 +1000
+++ linux-2.6.10-rc2-bk6-Netfilter/net/ipv4/netfilter/ipt_NOTRACK.c	2004-11-22 12:19:54.000000000 +1100
@@ -12,7 +12,7 @@
        const struct net_device *in,
        const struct net_device *out,
        unsigned int hooknum,
-       const void *targinfo,
+       const struct ipt_entry_target *target,
        void *userinfo)
 {
 	/* Previously seen (loopback)? Ignore. */

-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
