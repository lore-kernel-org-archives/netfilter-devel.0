From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [netfilter-core] ipt_MASQUERADE.c
Date: Sun, 26 Oct 2003 18:20:53 +1100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031026072447.787382C017@lists.samba.org>
References: <LAW12-F23D8cAYVb5aQ000083f2@hotmail.com>
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: =?iso-8859-1?B?UGFibG8gQW5kculzIE1hcnRpa2lhbg==?= <pablomartikian@hotmail.com>
In-reply-to: Your message of "Thu, 23 Oct 2003 20:29:17 +0200."
             <LAW12-F23D8cAYVb5aQ000083f2@hotmail.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

In message <LAW12-F23D8cAYVb5aQ000083f2@hotmail.com> you write:
> Hi Rusty,
> 
> Thank you for the friendly answer.
> 
> My kernel version is 2.4.23-pre7, my iptables version is 1.2.7a. I never 
> used any patch-o-matic.
> 
> I just recompiled the kernel removing the second check inside the 
> ipt_MASQUERADE.c, which is the check for size.

Hmm, that won't quite work, unfortunately.

Looks like your userspace is compiled against a kernel with the PPTP
patch applied, which changes the size of union
ip_conntrack_manip_proto, and hence struct ip_nat_multi_range.  This
breaks on a kernel which doesn't the PPTP patch.

Where did you get iptables from?  Your distribution?

Guys, what do you think of this patch to allow us to sanely handle
these cases in the future?

Rusty.
--
  Anyone who quotes me in their sig is an idiot. -- Rusty Russell.

Name: Change iptables Targets and Matches to Take Whole Struct
Author: Rusty Russell
Status: Experimental

D: When passing iptables targets and matches to the kernel, userspace
D: includes a size parameter, which was designed to allow backwards
D: compatibility: you could extend a match by appending fields to the
D: data section.
D: 
D: Unfortunately, this size is not passed to the ->match and ->target
D: functions called on each packet, only the ->checkentry function called
D: on rule insertion.  So we've been bitten by ongoing backwards
D: compatibility problems.
D: 
D: The solution is simple: instead of passing the ->data pointer to
D: targets and matches, pass the whole structure, so it can access the
D: size field if it needs to.  This patch changes all the callers and
D: all the matches and targets: the transformation is fairly trivial.

diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .20382-linux-2.6.0-test9/include/linux/netfilter_ipv4/ip_tables.h .20382-linux-2.6.0-test9.updated/include/linux/netfilter_ipv4/ip_tables.h
--- .20382-linux-2.6.0-test9/include/linux/netfilter_ipv4/ip_tables.h	2003-09-22 10:08:39.000000000 +1000
+++ .20382-linux-2.6.0-test9.updated/include/linux/netfilter_ipv4/ip_tables.h	2003-10-26 17:44:35.000000000 +1100
@@ -353,7 +353,7 @@ struct ipt_match
 	int (*match)(const struct sk_buff *skb,
 		     const struct net_device *in,
 		     const struct net_device *out,
-		     const void *matchinfo,
+		     struct ipt_entry_match *match,
 		     int offset,
 		     int *hotdrop);
 
@@ -399,7 +399,7 @@ struct ipt_target
 			       const struct net_device *in,
 			       const struct net_device *out,
 			       unsigned int hooknum,
-			       const void *targinfo,
+			       const struct ipt_entry_target *target,
 			       void *userdata);
 
 	/* Set this to THIS_MODULE. */
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .20382-linux-2.6.0-test9/net/ipv4/netfilter/ip_nat_rule.c .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ip_nat_rule.c
--- .20382-linux-2.6.0-test9/net/ipv4/netfilter/ip_nat_rule.c	2003-10-09 18:03:03.000000000 +1000
+++ .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ip_nat_rule.c	2003-10-26 18:08:05.000000000 +1100
@@ -113,7 +113,7 @@ static unsigned int ipt_snat_target(stru
 				    const struct net_device *in,
 				    const struct net_device *out,
 				    unsigned int hooknum,
-				    const void *targinfo,
+				    const struct ipt_entry_target *target,
 				    void *userinfo)
 {
 	struct ip_conntrack *ct;
@@ -127,14 +127,14 @@ static unsigned int ipt_snat_target(stru
 	IP_NF_ASSERT(ct && (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED));
 	IP_NF_ASSERT(out);
 
-	return ip_nat_setup_info(ct, targinfo, hooknum);
+	return ip_nat_setup_info(ct, (void *)target->data, hooknum);
 }
 
 static unsigned int ipt_dnat_target(struct sk_buff **pskb,
 				    const struct net_device *in,
 				    const struct net_device *out,
 				    unsigned int hooknum,
-				    const void *targinfo,
+				    const struct ipt_entry_target *target,
 				    void *userinfo)
 {
 	struct ip_conntrack *ct;
@@ -152,7 +152,7 @@ static unsigned int ipt_dnat_target(stru
 	/* Connection must be valid and new. */
 	IP_NF_ASSERT(ct && (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED));
 
-	return ip_nat_setup_info(ct, targinfo, hooknum);
+	return ip_nat_setup_info(ct, (void *)target->data, hooknum);
 }
 
 static int ipt_snat_checkentry(const char *tablename,
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .20382-linux-2.6.0-test9/net/ipv4/netfilter/ip_tables.c .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ip_tables.c
--- .20382-linux-2.6.0-test9/net/ipv4/netfilter/ip_tables.c	2003-09-22 10:28:14.000000000 +1000
+++ .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ip_tables.c	2003-10-26 18:18:59.000000000 +1100
@@ -221,11 +221,11 @@ ipt_error(struct sk_buff **pskb,
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
@@ -239,7 +239,7 @@ int do_match(struct ipt_entry_match *m,
 	     int *hotdrop)
 {
 	/* Stop iteration if it doesn't match */
-	if (!m->u.kernel.match->match(skb, in, out, m->data, offset, hotdrop))
+	if (!m->u.kernel.match->match(skb, in, out, m, offset, hotdrop))
 		return 1;
 	else
 		return 0;
@@ -360,7 +360,7 @@ ipt_do_table(struct sk_buff **pskb,
 				verdict = t->u.kernel.target->target(pskb,
 								     in, out,
 								     hook,
-								     t->data,
+								     t,
 								     userdata);
 
 #ifdef CONFIG_NETFILTER_DEBUG
@@ -1481,12 +1481,12 @@ static int
 tcp_match(const struct sk_buff *skb,
 	  const struct net_device *in,
 	  const struct net_device *out,
-	  const void *matchinfo,
+	  struct ipt_entry_match *match,
 	  int offset,
 	  int *hotdrop)
 {
 	struct tcphdr tcph;
-	const struct ipt_tcp *tcpinfo = matchinfo;
+	const struct ipt_tcp *tcpinfo = (void *)match->data;
 
 	if (offset) {
 		/* To quote Alan:
@@ -1554,12 +1554,12 @@ static int
 udp_match(const struct sk_buff *skb,
 	  const struct net_device *in,
 	  const struct net_device *out,
-	  const void *matchinfo,
+	  struct ipt_entry_match *match,
 	  int offset,
 	  int *hotdrop)
 {
 	struct udphdr udph;
-	const struct ipt_udp *udpinfo = matchinfo;
+	const struct ipt_udp *udpinfo = (void *)match->data;
 
 	/* Must not be a fragment. */
 	if (offset)
@@ -1625,12 +1625,12 @@ static int
 icmp_match(const struct sk_buff *skb,
 	   const struct net_device *in,
 	   const struct net_device *out,
-	   const void *matchinfo,
+	   struct ipt_entry_match *match,
 	   int offset,
 	   int *hotdrop)
 {
 	struct icmphdr icmph;
-	const struct ipt_icmp *icmpinfo = matchinfo;
+	const struct ipt_icmp *icmpinfo = (void *)match->data;
 
 	/* Must not be a fragment. */
 	if (offset)
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .20382-linux-2.6.0-test9/net/ipv4/netfilter/ipt_CLASSIFY.c .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ipt_CLASSIFY.c
--- .20382-linux-2.6.0-test9/net/ipv4/netfilter/ipt_CLASSIFY.c	2003-09-22 10:28:14.000000000 +1000
+++ .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ipt_CLASSIFY.c	2003-10-26 17:45:56.000000000 +1100
@@ -20,10 +20,10 @@ target(struct sk_buff **pskb,
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
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .20382-linux-2.6.0-test9/net/ipv4/netfilter/ipt_DSCP.c .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ipt_DSCP.c
--- .20382-linux-2.6.0-test9/net/ipv4/netfilter/ipt_DSCP.c	2003-09-22 10:28:14.000000000 +1000
+++ .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ipt_DSCP.c	2003-10-26 17:47:23.000000000 +1100
@@ -26,10 +26,10 @@ target(struct sk_buff **pskb,
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
 
 
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .20382-linux-2.6.0-test9/net/ipv4/netfilter/ipt_ECN.c .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ipt_ECN.c
--- .20382-linux-2.6.0-test9/net/ipv4/netfilter/ipt_ECN.c	2003-09-22 10:28:14.000000000 +1000
+++ .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ipt_ECN.c	2003-10-26 17:50:16.000000000 +1100
@@ -87,10 +87,10 @@ target(struct sk_buff **pskb,
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
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .20382-linux-2.6.0-test9/net/ipv4/netfilter/ipt_LOG.c .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ipt_LOG.c
--- .20382-linux-2.6.0-test9/net/ipv4/netfilter/ipt_LOG.c	2003-09-22 10:28:14.000000000 +1000
+++ .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ipt_LOG.c	2003-10-26 17:50:29.000000000 +1100
@@ -320,10 +320,10 @@ ipt_log_target(struct sk_buff **pskb,
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
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .20382-linux-2.6.0-test9/net/ipv4/netfilter/ipt_MARK.c .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ipt_MARK.c
--- .20382-linux-2.6.0-test9/net/ipv4/netfilter/ipt_MARK.c	2003-09-22 10:28:14.000000000 +1000
+++ .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ipt_MARK.c	2003-10-26 17:50:34.000000000 +1100
@@ -16,10 +16,10 @@ target(struct sk_buff **pskb,
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
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .20382-linux-2.6.0-test9/net/ipv4/netfilter/ipt_MASQUERADE.c .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ipt_MASQUERADE.c
--- .20382-linux-2.6.0-test9/net/ipv4/netfilter/ipt_MASQUERADE.c	2003-09-29 10:26:10.000000000 +1000
+++ .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ipt_MASQUERADE.c	2003-10-26 17:50:41.000000000 +1100
@@ -64,7 +64,7 @@ masquerade_target(struct sk_buff **pskb,
 		  const struct net_device *in,
 		  const struct net_device *out,
 		  unsigned int hooknum,
-		  const void *targinfo,
+		  const struct ipt_entry_target *target,
 		  void *userinfo)
 {
 	struct ip_conntrack *ct;
@@ -85,7 +85,7 @@ masquerade_target(struct sk_buff **pskb,
 	IP_NF_ASSERT(ct && (ctinfo == IP_CT_NEW
 				  || ctinfo == IP_CT_RELATED));
 
-	mr = targinfo;
+	mr = (void *)target->data;
 
 	{
 		struct flowi fl = { .nl_u = { .ip4_u =
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .20382-linux-2.6.0-test9/net/ipv4/netfilter/ipt_NETMAP.c .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ipt_NETMAP.c
--- .20382-linux-2.6.0-test9/net/ipv4/netfilter/ipt_NETMAP.c	2003-09-22 10:28:14.000000000 +1000
+++ .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ipt_NETMAP.c	2003-10-26 17:50:51.000000000 +1100
@@ -61,13 +61,13 @@ target(struct sk_buff **pskb,
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
-	const struct ip_nat_multi_range *mr = targinfo;
+	const struct ip_nat_multi_range *mr = (void *)target->data;
 	struct ip_nat_multi_range newrange;
 
 	IP_NF_ASSERT(hooknum == NF_IP_PRE_ROUTING
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .20382-linux-2.6.0-test9/net/ipv4/netfilter/ipt_REDIRECT.c .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ipt_REDIRECT.c
--- .20382-linux-2.6.0-test9/net/ipv4/netfilter/ipt_REDIRECT.c	2003-09-22 10:28:14.000000000 +1000
+++ .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ipt_REDIRECT.c	2003-10-26 17:51:00.000000000 +1100
@@ -60,13 +60,13 @@ redirect_target(struct sk_buff **pskb,
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
-	const struct ip_nat_multi_range *mr = targinfo;
+	const struct ip_nat_multi_range *mr = (void *)target->data;
 	struct ip_nat_multi_range newrange;
 
 	IP_NF_ASSERT(hooknum == NF_IP_PRE_ROUTING
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .20382-linux-2.6.0-test9/net/ipv4/netfilter/ipt_REJECT.c .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ipt_REJECT.c
--- .20382-linux-2.6.0-test9/net/ipv4/netfilter/ipt_REJECT.c	2003-10-09 18:03:03.000000000 +1000
+++ .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ipt_REJECT.c	2003-10-26 17:51:04.000000000 +1100
@@ -355,10 +355,10 @@ static unsigned int reject(struct sk_buf
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
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .20382-linux-2.6.0-test9/net/ipv4/netfilter/ipt_SAME.c .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ipt_SAME.c
--- .20382-linux-2.6.0-test9/net/ipv4/netfilter/ipt_SAME.c	2003-09-22 10:28:14.000000000 +1000
+++ .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ipt_SAME.c	2003-10-26 17:51:24.000000000 +1100
@@ -138,13 +138,13 @@ same_target(struct sk_buff **pskb,
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
-	const struct ipt_same_info *mr = targinfo;
+	const struct ipt_same_info *mr = (void *)target->data;
 	struct ip_nat_multi_range newrange;
 	const struct ip_conntrack_tuple *t;
 
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .20382-linux-2.6.0-test9/net/ipv4/netfilter/ipt_TCPMSS.c .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ipt_TCPMSS.c
--- .20382-linux-2.6.0-test9/net/ipv4/netfilter/ipt_TCPMSS.c	2003-09-22 10:28:14.000000000 +1000
+++ .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ipt_TCPMSS.c	2003-10-26 17:51:32.000000000 +1100
@@ -43,10 +43,10 @@ ipt_tcpmss_target(struct sk_buff **pskb,
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
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .20382-linux-2.6.0-test9/net/ipv4/netfilter/ipt_TOS.c .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ipt_TOS.c
--- .20382-linux-2.6.0-test9/net/ipv4/netfilter/ipt_TOS.c	2003-09-22 10:28:14.000000000 +1000
+++ .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ipt_TOS.c	2003-10-26 17:51:41.000000000 +1100
@@ -16,10 +16,10 @@ target(struct sk_buff **pskb,
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
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .20382-linux-2.6.0-test9/net/ipv4/netfilter/ipt_ULOG.c .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ipt_ULOG.c
--- .20382-linux-2.6.0-test9/net/ipv4/netfilter/ipt_ULOG.c	2003-09-22 10:28:14.000000000 +1000
+++ .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ipt_ULOG.c	2003-10-26 17:51:57.000000000 +1100
@@ -156,13 +156,14 @@ static unsigned int ipt_ulog_target(stru
 				    const struct net_device *in,
 				    const struct net_device *out,
 				    unsigned int hooknum,
-				    const void *targinfo, void *userinfo)
+				    const struct ipt_entry_target *target,
+				    void *userinfo)
 {
 	ulog_buff_t *ub;
 	ulog_packet_msg_t *pm;
 	size_t size, copy_len;
 	struct nlmsghdr *nlh;
-	struct ipt_ulog_info *loginfo = (struct ipt_ulog_info *) targinfo;
+	struct ipt_ulog_info *loginfo = (struct ipt_ulog_info *)target->data;
 
 	/* ffs == find first bit set, necessary because userspace
 	 * is already shifting groupnumber, but we need unshifted.
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .20382-linux-2.6.0-test9/net/ipv4/netfilter/ipt_ah.c .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ipt_ah.c
--- .20382-linux-2.6.0-test9/net/ipv4/netfilter/ipt_ah.c	2003-09-22 10:28:14.000000000 +1000
+++ .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ipt_ah.c	2003-10-26 18:09:33.000000000 +1100
@@ -32,12 +32,12 @@ static int
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
-      const void *matchinfo,
+      struct ipt_entry_match *match,
       int offset,
       int *hotdrop)
 {
 	struct ip_auth_hdr ah;
-	const struct ipt_ah *ahinfo = matchinfo;
+	const struct ipt_ah *ahinfo = (void *)match->data;
 
 	/* Must not be a fragment. */
 	if (offset)
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .20382-linux-2.6.0-test9/net/ipv4/netfilter/ipt_conntrack.c .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ipt_conntrack.c
--- .20382-linux-2.6.0-test9/net/ipv4/netfilter/ipt_conntrack.c	2003-09-22 10:28:14.000000000 +1000
+++ .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ipt_conntrack.c	2003-10-26 18:10:23.000000000 +1100
@@ -16,11 +16,11 @@ static int
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
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .20382-linux-2.6.0-test9/net/ipv4/netfilter/ipt_dscp.c .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ipt_dscp.c
--- .20382-linux-2.6.0-test9/net/ipv4/netfilter/ipt_dscp.c	2003-09-22 10:28:14.000000000 +1000
+++ .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ipt_dscp.c	2003-10-26 18:10:23.000000000 +1100
@@ -18,10 +18,10 @@ MODULE_DESCRIPTION("iptables DSCP matchi
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
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .20382-linux-2.6.0-test9/net/ipv4/netfilter/ipt_ecn.c .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ipt_ecn.c
--- .20382-linux-2.6.0-test9/net/ipv4/netfilter/ipt_ecn.c	2003-09-22 10:28:14.000000000 +1000
+++ .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ipt_ecn.c	2003-10-26 18:10:23.000000000 +1100
@@ -61,10 +61,10 @@ static inline int match_tcp(const struct
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
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .20382-linux-2.6.0-test9/net/ipv4/netfilter/ipt_esp.c .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ipt_esp.c
--- .20382-linux-2.6.0-test9/net/ipv4/netfilter/ipt_esp.c	2003-09-22 10:28:14.000000000 +1000
+++ .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ipt_esp.c	2003-10-26 18:10:23.000000000 +1100
@@ -32,12 +32,12 @@ static int
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
-      const void *matchinfo,
+      struct ipt_entry_match *match,
       int offset,
       int *hotdrop)
 {
 	struct ip_esp_hdr esp;
-	const struct ipt_esp *espinfo = matchinfo;
+	const struct ipt_esp *espinfo = (void *)match->data;
 
 	/* Must not be a fragment. */
 	if (offset)
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .20382-linux-2.6.0-test9/net/ipv4/netfilter/ipt_helper.c .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ipt_helper.c
--- .20382-linux-2.6.0-test9/net/ipv4/netfilter/ipt_helper.c	2003-09-22 10:28:14.000000000 +1000
+++ .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ipt_helper.c	2003-10-26 18:08:31.000000000 +1100
@@ -30,11 +30,11 @@ static int
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
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .20382-linux-2.6.0-test9/net/ipv4/netfilter/ipt_iprange.c .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ipt_iprange.c
--- .20382-linux-2.6.0-test9/net/ipv4/netfilter/ipt_iprange.c	2003-09-22 10:28:14.000000000 +1000
+++ .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ipt_iprange.c	2003-10-26 18:10:23.000000000 +1100
@@ -25,10 +25,10 @@ static int
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
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .20382-linux-2.6.0-test9/net/ipv4/netfilter/ipt_length.c .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ipt_length.c
--- .20382-linux-2.6.0-test9/net/ipv4/netfilter/ipt_length.c	2003-09-22 10:08:42.000000000 +1000
+++ .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ipt_length.c	2003-10-26 18:10:23.000000000 +1100
@@ -13,11 +13,11 @@ static int
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
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .20382-linux-2.6.0-test9/net/ipv4/netfilter/ipt_limit.c .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ipt_limit.c
--- .20382-linux-2.6.0-test9/net/ipv4/netfilter/ipt_limit.c	2003-10-23 10:02:54.000000000 +1000
+++ .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ipt_limit.c	2003-10-26 18:10:23.000000000 +1100
@@ -60,11 +60,11 @@ static int
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
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .20382-linux-2.6.0-test9/net/ipv4/netfilter/ipt_mac.c .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ipt_mac.c
--- .20382-linux-2.6.0-test9/net/ipv4/netfilter/ipt_mac.c	2003-09-22 10:28:14.000000000 +1000
+++ .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ipt_mac.c	2003-10-26 18:10:23.000000000 +1100
@@ -14,11 +14,11 @@ static int
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
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .20382-linux-2.6.0-test9/net/ipv4/netfilter/ipt_mark.c .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ipt_mark.c
--- .20382-linux-2.6.0-test9/net/ipv4/netfilter/ipt_mark.c	2003-09-22 10:28:14.000000000 +1000
+++ .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ipt_mark.c	2003-10-26 18:10:23.000000000 +1100
@@ -13,11 +13,11 @@ static int
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
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .20382-linux-2.6.0-test9/net/ipv4/netfilter/ipt_multiport.c .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ipt_multiport.c
--- .20382-linux-2.6.0-test9/net/ipv4/netfilter/ipt_multiport.c	2003-09-22 10:28:14.000000000 +1000
+++ .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ipt_multiport.c	2003-10-26 18:10:23.000000000 +1100
@@ -41,12 +41,12 @@ static int
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
-      const void *matchinfo,
+      struct ipt_entry_match *match,
       int offset,
       int *hotdrop)
 {
 	u16 ports[2];
-	const struct ipt_multiport *multiinfo = matchinfo;
+	const struct ipt_multiport *multiinfo = (void *)match->data;
 
 	/* Must not be a fragment. */
 	if (offset)
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .20382-linux-2.6.0-test9/net/ipv4/netfilter/ipt_owner.c .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ipt_owner.c
--- .20382-linux-2.6.0-test9/net/ipv4/netfilter/ipt_owner.c	2003-10-23 10:02:54.000000000 +1000
+++ .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ipt_owner.c	2003-10-26 18:10:23.000000000 +1100
@@ -119,11 +119,11 @@ static int
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
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .20382-linux-2.6.0-test9/net/ipv4/netfilter/ipt_physdev.c .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ipt_physdev.c
--- .20382-linux-2.6.0-test9/net/ipv4/netfilter/ipt_physdev.c	2003-09-29 10:26:11.000000000 +1000
+++ .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ipt_physdev.c	2003-10-26 18:10:23.000000000 +1100
@@ -16,13 +16,13 @@ static int
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
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .20382-linux-2.6.0-test9/net/ipv4/netfilter/ipt_pkttype.c .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ipt_pkttype.c
--- .20382-linux-2.6.0-test9/net/ipv4/netfilter/ipt_pkttype.c	2003-09-22 10:08:42.000000000 +1000
+++ .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ipt_pkttype.c	2003-10-26 18:10:23.000000000 +1100
@@ -11,11 +11,11 @@ MODULE_LICENSE("GPL");
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
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .20382-linux-2.6.0-test9/net/ipv4/netfilter/ipt_recent.c .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ipt_recent.c
--- .20382-linux-2.6.0-test9/net/ipv4/netfilter/ipt_recent.c	2003-09-22 10:23:04.000000000 +1000
+++ .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ipt_recent.c	2003-10-26 18:14:13.000000000 +1100
@@ -99,7 +99,7 @@ static int
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
-      const void *matchinfo,
+      struct ipt_entry_match *match,
       int offset,
       int *hotdrop);
 
@@ -314,7 +314,9 @@ static int ip_recent_ctrl(struct file *f
 	skb->nh.iph->daddr = 0;
 	/* Clear ttl since we have no way of knowing it */
 	skb->nh.iph->ttl = 0;
-	match(skb,NULL,NULL,info,0,NULL);
+	/* We fake up a "struct ipt_entry_match" here, since we only use
+	   the data field anyway. */
+	match(skb,NULL,NULL,(void *)info-sizeof(struct ipt_entry_match),0,NULL);
 
 	kfree(skb->nh.iph);
 out_free_skb:
@@ -352,13 +354,13 @@ static int
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
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .20382-linux-2.6.0-test9/net/ipv4/netfilter/ipt_state.c .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ipt_state.c
--- .20382-linux-2.6.0-test9/net/ipv4/netfilter/ipt_state.c	2003-09-22 10:28:14.000000000 +1000
+++ .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ipt_state.c	2003-10-26 18:10:23.000000000 +1100
@@ -15,11 +15,11 @@ static int
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
 
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .20382-linux-2.6.0-test9/net/ipv4/netfilter/ipt_tcpmss.c .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ipt_tcpmss.c
--- .20382-linux-2.6.0-test9/net/ipv4/netfilter/ipt_tcpmss.c	2003-09-22 10:28:14.000000000 +1000
+++ .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ipt_tcpmss.c	2003-10-26 18:10:23.000000000 +1100
@@ -61,11 +61,11 @@ static int
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
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .20382-linux-2.6.0-test9/net/ipv4/netfilter/ipt_tos.c .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ipt_tos.c
--- .20382-linux-2.6.0-test9/net/ipv4/netfilter/ipt_tos.c	2003-09-22 10:28:14.000000000 +1000
+++ .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ipt_tos.c	2003-10-26 18:10:23.000000000 +1100
@@ -12,11 +12,11 @@ static int
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
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .20382-linux-2.6.0-test9/net/ipv4/netfilter/ipt_ttl.c .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ipt_ttl.c
--- .20382-linux-2.6.0-test9/net/ipv4/netfilter/ipt_ttl.c	2003-09-22 10:08:42.000000000 +1000
+++ .20382-linux-2.6.0-test9.updated/net/ipv4/netfilter/ipt_ttl.c	2003-10-26 18:10:22.000000000 +1100
@@ -18,10 +18,10 @@ MODULE_DESCRIPTION("IP tables TTL matchi
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
