From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 3/18] Netfilter:  Remove NAT to multiple ranges
Date: Wed, 05 Jan 2005 14:31:47 +1100
Message-ID: <1104895907.20582.62.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Linus Torvalds <torvalds@osdl.org>
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

Name: Remove NAT to multiple ranges
Status: Passes testsuite
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

The NAT code has the concept of multiple ranges: you can say "map this
connection onto IP 192.168.1.2 - 192.168.1.4, 192.168.1.7 ports
1024-65535, and 192.168.1.10".  I implemented this because we could.
But it's not actually *used* by many (any?) people, and you can
approximate this by a random match (from patch-o-matic) if you really
want to.  It adds complexity to the code.

Index: linux-2.6.10-bk6-Netfilter/net/ipv4/netfilter/ip_nat_core.c
===================================================================
--- linux-2.6.10-bk6-Netfilter.orig/net/ipv4/netfilter/ip_nat_core.c	2005-01-04 21:24:49.000000000 +1100
+++ linux-2.6.10-bk6-Netfilter/net/ipv4/netfilter/ip_nat_core.c	2005-01-04 22:11:47.519874168 +1100
@@ -119,29 +119,26 @@
 }
 
 /* If we source map this tuple so reply looks like reply_tuple, will
- * that meet the constraints of mr. */
+ * that meet the constraints of range. */
 static int
 in_range(const struct ip_conntrack_tuple *tuple,
-	 const struct ip_nat_multi_range *mr)
+	 const struct ip_nat_range *range)
 {
 	struct ip_nat_protocol *proto = ip_nat_find_proto(tuple->dst.protonum);
-	unsigned int i;
-
-	for (i = 0; i < mr->rangesize; i++) {
-		/* If we are supposed to map IPs, then we must be in the
-		   range specified. */
-		if (mr->range[i].flags & IP_NAT_RANGE_MAP_IPS) {
-			if (ntohl(tuple->src.ip) < ntohl(mr->range[i].min_ip)
-			    || (ntohl(tuple->src.ip)
-				> ntohl(mr->range[i].max_ip)))
-				continue;
-		}
 
-		if (!(mr->range[i].flags & IP_NAT_RANGE_PROTO_SPECIFIED)
-		    || proto->in_range(tuple, IP_NAT_MANIP_SRC,
-				       &mr->range[i].min, &mr->range[i].max))
-			return 1;
+	/* If we are supposed to map IPs, then we must be in the
+	   range specified, otherwise let this drag us onto a new src IP. */
+	if (range->flags & IP_NAT_RANGE_MAP_IPS) {
+		if (ntohl(tuple->src.ip) < ntohl(range->min_ip)
+		    || ntohl(tuple->src.ip) > ntohl(range->max_ip))
+			return 0;
 	}
+
+	if (!(range->flags & IP_NAT_RANGE_PROTO_SPECIFIED)
+	    || proto->in_range(tuple, IP_NAT_MANIP_SRC,
+			       &range->min, &range->max))
+		return 1;
+
 	return 0;
 }
 
@@ -161,7 +158,7 @@
 static int
 find_appropriate_src(const struct ip_conntrack_tuple *tuple,
 		     struct ip_conntrack_tuple *result,
-		     const struct ip_nat_multi_range *mr)
+		     const struct ip_nat_range *range)
 {
 	unsigned int h = hash_by_src(&tuple->src, tuple->dst.protonum);
 	struct ip_conntrack *ct;
@@ -175,7 +172,7 @@
 				       &ct->tuplehash[IP_CT_DIR_REPLY].tuple);
 			result->dst = tuple->dst;
 
-			if (in_range(result, mr))
+			if (in_range(result, range))
 				return 1;
 		}
 	}
@@ -239,25 +236,19 @@
    if the range specifies 1.2.3.4 ports 10000-10005 and 1.2.3.5 ports
    1-65535, we don't do pro-rata allocation based on ports; we choose
    the ip with the lowest src-ip/dst-ip/proto usage.
-
-   If an allocation then fails (eg. all 6 ports used in the 1.2.3.4
-   range), we eliminate that and try again.  This is not the most
-   efficient approach, but if you're worried about that, don't hand us
-   ranges you don't really have.  */
-static struct ip_nat_range *
+*/
+static int
 find_best_ips_proto(struct ip_conntrack_tuple *tuple,
-		    const struct ip_nat_multi_range *mr,
+		    const struct ip_nat_range *range,
 		    const struct ip_conntrack *conntrack,
 		    unsigned int hooknum)
 {
-	unsigned int i;
-	struct {
-		const struct ip_nat_range *range;
-		unsigned int score;
-		struct ip_conntrack_tuple tuple;
-	} best = { NULL,  0xFFFFFFFF };
+	unsigned int best_score = 0xFFFFFFFF;
+	struct ip_conntrack_tuple best_tuple;
 	u_int32_t *var_ipp, *other_ipp, saved_ip, orig_dstip;
 	static unsigned int randomness;
+	/* Host order */
+	u_int32_t minip, maxip, j;
 
 	if (HOOK2MANIP(hooknum) == IP_NAT_MANIP_SRC) {
 		var_ipp = &tuple->src.ip;
@@ -272,115 +263,94 @@
            explicit socket bindings, for example) */
 	orig_dstip = tuple->dst.ip;
 
-	IP_NF_ASSERT(mr->rangesize >= 1);
-	for (i = 0; i < mr->rangesize; i++) {
-		/* Host order */
-		u_int32_t minip, maxip, j;
+	if (range->flags & IP_NAT_RANGE_MAP_IPS) {
+		minip = ntohl(range->min_ip);
+		maxip = ntohl(range->max_ip);
+	} else
+		minip = maxip = ntohl(*var_ipp);
+
+	randomness++;
+	for (j = 0; j < maxip - minip + 1; j++) {
+		unsigned int score;
+
+		*var_ipp = htonl(minip + (randomness + j) 
+				 % (maxip - minip + 1));
 
-		/* Don't do ranges which are already eliminated. */
-		if (mr->range[i].flags & IP_NAT_RANGE_FULL) {
+		/* Reset the other ip in case it was mangled by
+		 * do_extra_mangle last time. */
+		*other_ipp = saved_ip;
+
+		if (hooknum == NF_IP_LOCAL_OUT
+		    && *var_ipp != orig_dstip
+		    && !do_extra_mangle(*var_ipp, other_ipp)) {
+			DEBUGP("Range %u %u.%u.%u.%u rt failed!\n",
+			       i, NIPQUAD(*var_ipp));
+			/* Can't route?  This whole range part is
+			 * probably screwed, but keep trying
+			 * anyway. */
 			continue;
 		}
 
-		if (mr->range[i].flags & IP_NAT_RANGE_MAP_IPS) {
-			minip = ntohl(mr->range[i].min_ip);
-			maxip = ntohl(mr->range[i].max_ip);
-		} else
-			minip = maxip = ntohl(*var_ipp);
-
-		randomness++;
-		for (j = 0; j < maxip - minip + 1; j++) {
-			unsigned int score;
-
-			*var_ipp = htonl(minip + (randomness + j) 
-					 % (maxip - minip + 1));
-
-			/* Reset the other ip in case it was mangled by
-			 * do_extra_mangle last time. */
-			*other_ipp = saved_ip;
-
-			if (hooknum == NF_IP_LOCAL_OUT
-			    && *var_ipp != orig_dstip
-			    && !do_extra_mangle(*var_ipp, other_ipp)) {
-				DEBUGP("Range %u %u.%u.%u.%u rt failed!\n",
-				       i, NIPQUAD(*var_ipp));
-				/* Can't route?  This whole range part is
-				 * probably screwed, but keep trying
-				 * anyway. */
-				continue;
-			}
+		/* Count how many others map onto this. */
+		score = count_maps(tuple->src.ip, tuple->dst.ip,
+				   tuple->dst.protonum, conntrack);
+		if (score < best_score) {
+			/* Optimization: doesn't get any better than
+			   this. */
+			if (score == 0)
+				return 1;
 
-			/* Count how many others map onto this. */
-			score = count_maps(tuple->src.ip, tuple->dst.ip,
-					   tuple->dst.protonum, conntrack);
-			if (score < best.score) {
-				/* Optimization: doesn't get any better than
-				   this. */
-				if (score == 0)
-					return (struct ip_nat_range *)
-						&mr->range[i];
-
-				best.score = score;
-				best.tuple = *tuple;
-				best.range = &mr->range[i];
-			}
+			best_score = score;
+			best_tuple = *tuple;
 		}
 	}
-	*tuple = best.tuple;
 
-	/* Discard const. */
-	return (struct ip_nat_range *)best.range;
+	if (best_score == 0xFFFFFFFF)
+		return 0;
+
+	*tuple = best_tuple;
+	return 1;
 }
 
 /* Fast version doesn't iterate through hash chains, but only handles
    common case of single IP address (null NAT, masquerade) */
-static struct ip_nat_range *
+static int
 find_best_ips_proto_fast(struct ip_conntrack_tuple *tuple,
-			 const struct ip_nat_multi_range *mr,
+			 const struct ip_nat_range *range,
 			 const struct ip_conntrack *conntrack,
 			 unsigned int hooknum)
 {
-	if (mr->rangesize != 1
-	    || (mr->range[0].flags & IP_NAT_RANGE_FULL)
-	    || ((mr->range[0].flags & IP_NAT_RANGE_MAP_IPS)
-		&& mr->range[0].min_ip != mr->range[0].max_ip))
-		return find_best_ips_proto(tuple, mr, conntrack, hooknum);
-
-	if (mr->range[0].flags & IP_NAT_RANGE_MAP_IPS) {
-		if (HOOK2MANIP(hooknum) == IP_NAT_MANIP_SRC)
-			tuple->src.ip = mr->range[0].min_ip;
-		else {
-			/* Only do extra mangle when required (breaks
-                           socket binding) */
-			if (tuple->dst.ip != mr->range[0].min_ip
-			    && hooknum == NF_IP_LOCAL_OUT
-			    && !do_extra_mangle(mr->range[0].min_ip,
-						&tuple->src.ip))
-				return NULL;
-			tuple->dst.ip = mr->range[0].min_ip;
-		}
+	/* Leave IP address alone if we're not to map IP addresses. */
+	if (!(range->flags & IP_NAT_RANGE_MAP_IPS))
+		return 1;
+
+	if (range->min_ip != range->max_ip)
+		return find_best_ips_proto(tuple, range, conntrack, hooknum);
+
+	if (HOOK2MANIP(hooknum) == IP_NAT_MANIP_SRC)
+		tuple->src.ip = range->min_ip;
+	else {
+		/* Only do extra mangle when required (breaks socket
+		   binding) */
+		if (tuple->dst.ip != range->min_ip
+		    && hooknum == NF_IP_LOCAL_OUT
+		    && !do_extra_mangle(range->min_ip, &tuple->src.ip))
+			return 0;
+		tuple->dst.ip = range->min_ip;
 	}
 
-	/* Discard const. */
-	return (struct ip_nat_range *)&mr->range[0];
+	return 1;
 }
 
 static int
 get_unique_tuple(struct ip_conntrack_tuple *tuple,
 		 const struct ip_conntrack_tuple *orig_tuple,
-		 const struct ip_nat_multi_range *mrr,
+		 const struct ip_nat_range *range,
 		 struct ip_conntrack *conntrack,
 		 unsigned int hooknum)
 {
 	struct ip_nat_protocol *proto
 		= ip_nat_find_proto(orig_tuple->dst.protonum);
-	struct ip_nat_range *rptr;
-	unsigned int i;
-	int ret;
-
-	/* We temporarily use flags for marking full parts, but we
-	   always clean up afterwards */
-	struct ip_nat_multi_range *mr = (void *)mrr;
 
 	/* 1) If this srcip/proto/src-proto-part is currently mapped,
 	   and that same mapping gives a unique tuple within the given
@@ -390,7 +360,7 @@
 	   So far, we don't do local source mappings, so multiple
 	   manips not an issue.  */
 	if (hooknum == NF_IP_POST_ROUTING) {
-		if (find_appropriate_src(orig_tuple, tuple, mr)) {
+		if (find_appropriate_src(orig_tuple, tuple, range)) {
 			DEBUGP("get_unique_tuple: Found current src map\n");
 			if (!ip_nat_used_tuple(tuple, conntrack))
 				return 1;
@@ -398,69 +368,43 @@
 	}
 
 	/* 2) Select the least-used IP/proto combination in the given
-	   range.
-	*/
+	   range. */
 	*tuple = *orig_tuple;
-	while ((rptr = find_best_ips_proto_fast(tuple, mr, conntrack, hooknum))
-	       != NULL) {
-		DEBUGP("Found best for "); DUMP_TUPLE(tuple);
-		/* 3) The per-protocol part of the manip is made to
-		   map into the range to make a unique tuple. */
-
-		/* Only bother mapping if it's not already in range
-		   and unique */
-		if ((!(rptr->flags & IP_NAT_RANGE_PROTO_SPECIFIED)
-		     || proto->in_range(tuple, HOOK2MANIP(hooknum),
-					&rptr->min, &rptr->max))
-		    && !ip_nat_used_tuple(tuple, conntrack)) {
-			ret = 1;
-			goto clear_fulls;
-		} else {
-			if (proto->unique_tuple(tuple, rptr,
-						HOOK2MANIP(hooknum),
-						conntrack)) {
-				/* Must be unique. */
-				IP_NF_ASSERT(!ip_nat_used_tuple(tuple,
-								conntrack));
-				ret = 1;
-				goto clear_fulls;
-			} else if (HOOK2MANIP(hooknum) == IP_NAT_MANIP_DST) {
-				/* Try implicit source NAT; protocol
-                                   may be able to play with ports to
-                                   make it unique. */
-				struct ip_nat_range r
-					= { IP_NAT_RANGE_MAP_IPS, 
-					    tuple->src.ip, tuple->src.ip,
-					    { 0 }, { 0 } };
-				DEBUGP("Trying implicit mapping\n");
-				if (proto->unique_tuple(tuple, &r,
-							IP_NAT_MANIP_SRC,
-							conntrack)) {
-					/* Must be unique. */
-					IP_NF_ASSERT(!ip_nat_used_tuple
-						     (tuple, conntrack));
-					ret = 1;
-					goto clear_fulls;
-				}
-			}
-			DEBUGP("Protocol can't get unique tuple %u.\n",
-			       hooknum);
-		}
-
-		/* Eliminate that from range, and try again. */
-		rptr->flags |= IP_NAT_RANGE_FULL;
-		*tuple = *orig_tuple;
-	}
-
-	ret = 0;
+	if (!find_best_ips_proto_fast(tuple, range, conntrack, hooknum))
+		return 0;
 
- clear_fulls:
-	/* Clear full flags. */
-	IP_NF_ASSERT(mr->rangesize >= 1);
-	for (i = 0; i < mr->rangesize; i++)
-		mr->range[i].flags &= ~IP_NAT_RANGE_FULL;
+	/* 3) The per-protocol part of the manip is made to map into
+	   the range to make a unique tuple. */
 
-	return ret;
+	/* Only bother mapping if it's not already in range and unique */
+	if ((!(range->flags & IP_NAT_RANGE_PROTO_SPECIFIED)
+	     || proto->in_range(tuple, HOOK2MANIP(hooknum),
+				&range->min, &range->max))
+	    && !ip_nat_used_tuple(tuple, conntrack))
+		return 1;
+
+	if (proto->unique_tuple(tuple, range, HOOK2MANIP(hooknum), conntrack)){
+		/* Must be unique. */
+		IP_NF_ASSERT(!ip_nat_used_tuple(tuple, conntrack));
+		return 1;
+	}
+
+	if (HOOK2MANIP(hooknum) == IP_NAT_MANIP_DST) {
+		/* Try implicit source NAT; protocol may be able to
+		   play with ports to make it unique. */
+		struct ip_nat_range r
+			= { IP_NAT_RANGE_MAP_IPS, 
+			    tuple->src.ip, tuple->src.ip, { 0 }, { 0 } };
+		DEBUGP("Trying implicit mapping\n");
+		if (proto->unique_tuple(tuple, &r, IP_NAT_MANIP_SRC,
+					conntrack)) {
+			/* Must be unique. */
+			IP_NF_ASSERT(!ip_nat_used_tuple(tuple, conntrack));
+			return 1;
+		}
+		DEBUGP("Protocol can't get unique tuple %u.\n", hooknum);
+	}
+	return 0;
 }
 
 /* Where to manip the reply packets (will be reverse manip). */
@@ -473,7 +417,7 @@
 
 unsigned int
 ip_nat_setup_info(struct ip_conntrack *conntrack,
-		  const struct ip_nat_multi_range *mr,
+		  const struct ip_nat_range *range,
 		  unsigned int hooknum)
 {
 	struct ip_conntrack_tuple new_tuple, inv_tuple, reply;
@@ -524,7 +468,7 @@
 #endif
 
 	do {
-		if (!get_unique_tuple(&new_tuple, &orig_tp, mr, conntrack,
+		if (!get_unique_tuple(&new_tuple, &orig_tp, range, conntrack,
 				      hooknum)) {
 			DEBUGP("ip_nat_setup_info: Can't get unique for %p.\n",
 			       conntrack);
Index: linux-2.6.10-bk6-Netfilter/net/ipv4/netfilter/ip_nat_rule.c
===================================================================
--- linux-2.6.10-bk6-Netfilter.orig/net/ipv4/netfilter/ip_nat_rule.c	2005-01-04 20:49:24.000000000 +1100
+++ linux-2.6.10-bk6-Netfilter/net/ipv4/netfilter/ip_nat_rule.c	2005-01-04 22:11:47.565867176 +1100
@@ -126,6 +126,7 @@
 {
 	struct ip_conntrack *ct;
 	enum ip_conntrack_info ctinfo;
+	const struct ip_nat_multi_range_compat *mr = targinfo;
 
 	IP_NF_ASSERT(hooknum == NF_IP_POST_ROUTING);
 
@@ -136,7 +137,7 @@
 	                    || ctinfo == IP_CT_RELATED + IP_CT_IS_REPLY));
 	IP_NF_ASSERT(out);
 
-	return ip_nat_setup_info(ct, targinfo, hooknum);
+	return ip_nat_setup_info(ct, &mr->range[0], hooknum);
 }
 
 static unsigned int ipt_dnat_target(struct sk_buff **pskb,
@@ -148,6 +149,7 @@
 {
 	struct ip_conntrack *ct;
 	enum ip_conntrack_info ctinfo;
+	const struct ip_nat_multi_range_compat *mr = targinfo;
 
 	IP_NF_ASSERT(hooknum == NF_IP_PRE_ROUTING
 		     || hooknum == NF_IP_LOCAL_OUT);
@@ -157,7 +159,7 @@
 	/* Connection must be valid and new. */
 	IP_NF_ASSERT(ct && (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED));
 
-	return ip_nat_setup_info(ct, targinfo, hooknum);
+	return ip_nat_setup_info(ct, &mr->range[0], hooknum);
 }
 
 static int ipt_snat_checkentry(const char *tablename,
@@ -166,17 +168,15 @@
 			       unsigned int targinfosize,
 			       unsigned int hook_mask)
 {
-	struct ip_nat_multi_range *mr = targinfo;
+	struct ip_nat_multi_range_compat *mr = targinfo;
 
 	/* Must be a valid range */
-	if (targinfosize < sizeof(struct ip_nat_multi_range)) {
-		DEBUGP("SNAT: Target size %u too small\n", targinfosize);
+	if (mr->rangesize != 1) {
+		printk("SNAT: multiple ranges no longer supported\n");
 		return 0;
 	}
 
-	if (targinfosize != IPT_ALIGN((sizeof(struct ip_nat_multi_range)
-				       + (sizeof(struct ip_nat_range)
-					  * (mr->rangesize - 1))))) {
+	if (targinfosize != sizeof(struct ip_nat_multi_range_compat)) {
 		DEBUGP("SNAT: Target size %u wrong for %u ranges\n",
 		       targinfosize, mr->rangesize);
 		return 0;
@@ -201,17 +201,15 @@
 			       unsigned int targinfosize,
 			       unsigned int hook_mask)
 {
-	struct ip_nat_multi_range *mr = targinfo;
+	struct ip_nat_multi_range_compat *mr = targinfo;
 
 	/* Must be a valid range */
-	if (targinfosize < sizeof(struct ip_nat_multi_range)) {
-		DEBUGP("DNAT: Target size %u too small\n", targinfosize);
+	if (mr->rangesize != 1) {
+		printk("DNAT: multiple ranges no longer supported\n");
 		return 0;
 	}
 
-	if (targinfosize != IPT_ALIGN((sizeof(struct ip_nat_multi_range)
-				       + (sizeof(struct ip_nat_range)
-					  * (mr->rangesize - 1))))) {
+	if (targinfosize != sizeof(struct ip_nat_multi_range_compat)) {
 		DEBUGP("DNAT: Target size %u wrong for %u ranges\n",
 		       targinfosize, mr->rangesize);
 		return 0;
@@ -244,12 +242,12 @@
 		= (HOOK2MANIP(hooknum) == IP_NAT_MANIP_SRC
 		   ? conntrack->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip
 		   : conntrack->tuplehash[IP_CT_DIR_REPLY].tuple.src.ip);
-	struct ip_nat_multi_range mr
-		= { 1, { { IP_NAT_RANGE_MAP_IPS, ip, ip, { 0 }, { 0 } } } };
+	struct ip_nat_range range
+		= { IP_NAT_RANGE_MAP_IPS, ip, ip, { 0 }, { 0 } };
 
 	DEBUGP("Allocating NULL binding for %p (%u.%u.%u.%u)\n", conntrack,
 	       NIPQUAD(ip));
-	return ip_nat_setup_info(conntrack, &mr, hooknum);
+	return ip_nat_setup_info(conntrack, &range, hooknum);
 }
 
 int ip_nat_rule_find(struct sk_buff **pskb,
Index: linux-2.6.10-bk6-Netfilter/include/linux/netfilter_ipv4/ip_nat.h
===================================================================
--- linux-2.6.10-bk6-Netfilter.orig/include/linux/netfilter_ipv4/ip_nat.h	2005-01-04 20:49:23.000000000 +1100
+++ linux-2.6.10-bk6-Netfilter/include/linux/netfilter_ipv4/ip_nat.h	2005-01-04 22:11:47.596862464 +1100
@@ -41,10 +41,10 @@
 	union ip_conntrack_manip_proto min, max;
 };
 
-/* A range consists of an array of 1 or more ip_nat_range */
-struct ip_nat_multi_range
+/* For backwards compat: don't use in modern code. */
+struct ip_nat_multi_range_compat
 {
-	unsigned int rangesize;
+	unsigned int rangesize; /* Must be 1. */
 
 	/* hangs off end. */
 	struct ip_nat_range range[1];
@@ -96,7 +96,7 @@
 
 /* Set up the info structure to map into this range. */
 extern unsigned int ip_nat_setup_info(struct ip_conntrack *conntrack,
-				      const struct ip_nat_multi_range *mr,
+				      const struct ip_nat_range *range,
 				      unsigned int hooknum);
 
 /* Is this tuple already taken? (not by us)*/
@@ -107,5 +107,7 @@
 extern u_int16_t ip_nat_cheat_check(u_int32_t oldvalinv,
 				    u_int32_t newval,
 				    u_int16_t oldcheck);
+#else  /* !__KERNEL__: iptables wants this to compile. */
+#define ip_nat_multi_range ip_nat_multi_range_compat
 #endif /*__KERNEL__*/
 #endif
Index: linux-2.6.10-bk6-Netfilter/net/ipv4/netfilter/ip_nat_ftp.c
===================================================================
--- linux-2.6.10-bk6-Netfilter.orig/net/ipv4/netfilter/ip_nat_ftp.c	2005-01-04 14:55:57.000000000 +1100
+++ linux-2.6.10-bk6-Netfilter/net/ipv4/netfilter/ip_nat_ftp.c	2005-01-04 22:11:47.614859728 +1100
@@ -44,7 +44,7 @@
 		 struct ip_conntrack *ct,
 		 struct ip_nat_info *info)
 {
-	struct ip_nat_multi_range mr;
+	struct ip_nat_range range;
 	u_int32_t newdstip, newsrcip, newip;
 	struct ip_ct_ftp_expect *exp_ftp_info;
 
@@ -80,20 +80,19 @@
 
 	DEBUGP("nat_expected: IP to %u.%u.%u.%u\n", NIPQUAD(newip));
 
-	mr.rangesize = 1;
 	/* We don't want to manip the per-protocol, just the IPs... */
-	mr.range[0].flags = IP_NAT_RANGE_MAP_IPS;
-	mr.range[0].min_ip = mr.range[0].max_ip = newip;
+	range.flags = IP_NAT_RANGE_MAP_IPS;
+	range.min_ip = range.max_ip = newip;
 
 	/* ... unless we're doing a MANIP_DST, in which case, make
 	   sure we map to the correct port */
 	if (HOOK2MANIP(hooknum) == IP_NAT_MANIP_DST) {
-		mr.range[0].flags |= IP_NAT_RANGE_PROTO_SPECIFIED;
-		mr.range[0].min = mr.range[0].max
+		range.flags |= IP_NAT_RANGE_PROTO_SPECIFIED;
+		range.min = range.max
 			= ((union ip_conntrack_manip_proto)
 				{ .tcp = { htons(exp_ftp_info->port) } });
 	}
-	return ip_nat_setup_info(ct, &mr, hooknum);
+	return ip_nat_setup_info(ct, &range, hooknum);
 }
 
 static int
Index: linux-2.6.10-bk6-Netfilter/net/ipv4/netfilter/ipt_REDIRECT.c
===================================================================
--- linux-2.6.10-bk6-Netfilter.orig/net/ipv4/netfilter/ipt_REDIRECT.c	2005-01-04 14:55:57.000000000 +1100
+++ linux-2.6.10-bk6-Netfilter/net/ipv4/netfilter/ipt_REDIRECT.c	2005-01-04 22:11:47.673850760 +1100
@@ -38,7 +38,7 @@
 	       unsigned int targinfosize,
 	       unsigned int hook_mask)
 {
-	const struct ip_nat_multi_range *mr = targinfo;
+	const struct ip_nat_multi_range_compat *mr = targinfo;
 
 	if (strcmp(tablename, "nat") != 0) {
 		DEBUGP("redirect_check: bad table `%s'.\n", table);
@@ -74,8 +74,8 @@
 	struct ip_conntrack *ct;
 	enum ip_conntrack_info ctinfo;
 	u_int32_t newdst;
-	const struct ip_nat_multi_range *mr = targinfo;
-	struct ip_nat_multi_range newrange;
+	const struct ip_nat_multi_range_compat *mr = targinfo;
+	struct ip_nat_range newrange;
 
 	IP_NF_ASSERT(hooknum == NF_IP_PRE_ROUTING
 		     || hooknum == NF_IP_LOCAL_OUT);
@@ -99,10 +99,10 @@
 	}
 
 	/* Transfer from original range. */
-	newrange = ((struct ip_nat_multi_range)
-		{ 1, { { mr->range[0].flags | IP_NAT_RANGE_MAP_IPS,
-			 newdst, newdst,
-			 mr->range[0].min, mr->range[0].max } } });
+	newrange = ((struct ip_nat_range)
+		{ mr->range[0].flags | IP_NAT_RANGE_MAP_IPS,
+		  newdst, newdst,
+		  mr->range[0].min, mr->range[0].max });
 
 	/* Hand modified range to generic setup. */
 	return ip_nat_setup_info(ct, &newrange, hooknum);
Index: linux-2.6.10-bk6-Netfilter/net/ipv4/netfilter/ip_nat_amanda.c
===================================================================
--- linux-2.6.10-bk6-Netfilter.orig/net/ipv4/netfilter/ip_nat_amanda.c	2005-01-04 14:55:57.000000000 +1100
+++ linux-2.6.10-bk6-Netfilter/net/ipv4/netfilter/ip_nat_amanda.c	2005-01-04 22:11:47.643855320 +1100
@@ -39,7 +39,7 @@
 {
 	struct ip_conntrack *master = master_ct(ct);
 	struct ip_ct_amanda_expect *exp_amanda_info;
-	struct ip_nat_multi_range mr;
+	struct ip_nat_range range;
 	u_int32_t newip;
 
 	IP_NF_ASSERT(info);
@@ -51,20 +51,19 @@
 	else
 		newip = master->tuplehash[IP_CT_DIR_REPLY].tuple.src.ip;
 
-	mr.rangesize = 1;
 	/* We don't want to manip the per-protocol, just the IPs. */
-	mr.range[0].flags = IP_NAT_RANGE_MAP_IPS;
-	mr.range[0].min_ip = mr.range[0].max_ip = newip;
+	range.flags = IP_NAT_RANGE_MAP_IPS;
+	range.min_ip = range.max_ip = newip;
 
 	if (HOOK2MANIP(hooknum) == IP_NAT_MANIP_DST) {
 		exp_amanda_info = &ct->master->help.exp_amanda_info;
-		mr.range[0].flags |= IP_NAT_RANGE_PROTO_SPECIFIED;
-		mr.range[0].min = mr.range[0].max
+		range.flags |= IP_NAT_RANGE_PROTO_SPECIFIED;
+		range.min = range.max
 			= ((union ip_conntrack_manip_proto)
 				{ .udp = { htons(exp_amanda_info->port) } });
 	}
 
-	return ip_nat_setup_info(ct, &mr, hooknum);
+	return ip_nat_setup_info(ct, &range, hooknum);
 }
 
 static int amanda_data_fixup(struct ip_conntrack *ct,
Index: linux-2.6.10-bk6-Netfilter/net/ipv4/netfilter/ip_nat_tftp.c
===================================================================
--- linux-2.6.10-bk6-Netfilter.orig/net/ipv4/netfilter/ip_nat_tftp.c	2005-01-04 14:55:57.000000000 +1100
+++ linux-2.6.10-bk6-Netfilter/net/ipv4/netfilter/ip_nat_tftp.c	2005-01-04 22:11:47.675850456 +1100
@@ -107,7 +107,7 @@
 	const struct ip_conntrack *master = ct->master->expectant;
 	const struct ip_conntrack_tuple *orig = 
 			&master->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
-	struct ip_nat_multi_range mr;
+	struct ip_nat_range range;
 #if 0
 	const struct ip_conntrack_tuple *repl =
 			&master->tuplehash[IP_CT_DIR_REPLY].tuple;
@@ -124,21 +124,19 @@
 	IP_NF_ASSERT(master);
 	IP_NF_ASSERT(!(info->initialized & (1 << HOOK2MANIP(hooknum))));
 
-	mr.rangesize = 1;
-	mr.range[0].flags = IP_NAT_RANGE_MAP_IPS;
+	range.flags = IP_NAT_RANGE_MAP_IPS;
 
 	if (HOOK2MANIP(hooknum) == IP_NAT_MANIP_SRC) {
-		mr.range[0].min_ip = mr.range[0].max_ip = orig->dst.ip; 
+		range.min_ip = range.max_ip = orig->dst.ip; 
 		DEBUGP("orig: %u.%u.%u.%u:%u <-> %u.%u.%u.%u:%u "
 			"newsrc: %u.%u.%u.%u\n",
                         NIPQUAD((*pskb)->nh.iph->saddr), ntohs(uh->source),
  			NIPQUAD((*pskb)->nh.iph->daddr), ntohs(uh->dest),
 			NIPQUAD(orig->dst.ip));
 	} else {
-		mr.range[0].min_ip = mr.range[0].max_ip = orig->src.ip;
-		mr.range[0].min.udp.port = mr.range[0].max.udp.port = 
-							orig->src.u.udp.port;
-		mr.range[0].flags |= IP_NAT_RANGE_PROTO_SPECIFIED;
+		range.min_ip = range.max_ip = orig->src.ip;
+		range.min.udp.port = range.max.udp.port = orig->src.u.udp.port;
+		range.flags |= IP_NAT_RANGE_PROTO_SPECIFIED;
 
 		DEBUGP("orig: %u.%u.%u.%u:%u <-> %u.%u.%u.%u:%u "
 			"newdst: %u.%u.%u.%u:%u\n",
@@ -147,7 +145,7 @@
                         NIPQUAD(orig->src.ip), ntohs(orig->src.u.udp.port));
 	}
 
-	return ip_nat_setup_info(ct,&mr,hooknum);
+	return ip_nat_setup_info(ct, &range, hooknum);
 }
 
 static struct ip_nat_helper tftp[MAX_PORTS];
Index: linux-2.6.10-bk6-Netfilter/net/ipv4/netfilter/ip_nat_irc.c
===================================================================
--- linux-2.6.10-bk6-Netfilter.orig/net/ipv4/netfilter/ip_nat_irc.c	2005-01-04 14:55:57.000000000 +1100
+++ linux-2.6.10-bk6-Netfilter/net/ipv4/netfilter/ip_nat_irc.c	2005-01-04 22:11:47.677850152 +1100
@@ -53,7 +53,7 @@
 		 struct ip_conntrack *ct,
 		 struct ip_nat_info *info)
 {
-	struct ip_nat_multi_range mr;
+	struct ip_nat_range range;
 	u_int32_t newdstip, newsrcip, newip;
 
 	struct ip_conntrack *master = master_ct(ct);
@@ -77,12 +77,11 @@
 
 	DEBUGP("nat_expected: IP to %u.%u.%u.%u\n", NIPQUAD(newip));
 
-	mr.rangesize = 1;
 	/* We don't want to manip the per-protocol, just the IPs. */
-	mr.range[0].flags = IP_NAT_RANGE_MAP_IPS;
-	mr.range[0].min_ip = mr.range[0].max_ip = newip;
+	range.flags = IP_NAT_RANGE_MAP_IPS;
+	range.min_ip = range.max_ip = newip;
 
-	return ip_nat_setup_info(ct, &mr, hooknum);
+	return ip_nat_setup_info(ct, &range, hooknum);
 }
 
 static int irc_data_fixup(const struct ip_ct_irc_expect *exp_irc_info,
Index: linux-2.6.10-bk6-Netfilter/net/ipv4/netfilter/ipt_NETMAP.c
===================================================================
--- linux-2.6.10-bk6-Netfilter.orig/net/ipv4/netfilter/ipt_NETMAP.c	2005-01-04 14:55:57.000000000 +1100
+++ linux-2.6.10-bk6-Netfilter/net/ipv4/netfilter/ipt_NETMAP.c	2005-01-04 22:11:47.678850000 +1100
@@ -36,7 +36,7 @@
       unsigned int targinfosize,
       unsigned int hook_mask)
 {
-	const struct ip_nat_multi_range *mr = targinfo;
+	const struct ip_nat_multi_range_compat *mr = targinfo;
 
 	if (strcmp(tablename, "nat") != 0) {
 		DEBUGP(MODULENAME":check: bad table `%s'.\n", tablename);
@@ -72,8 +72,8 @@
 	struct ip_conntrack *ct;
 	enum ip_conntrack_info ctinfo;
 	u_int32_t new_ip, netmask;
-	const struct ip_nat_multi_range *mr = targinfo;
-	struct ip_nat_multi_range newrange;
+	const struct ip_nat_multi_range_compat *mr = targinfo;
+	struct ip_nat_range newrange;
 
 	IP_NF_ASSERT(hooknum == NF_IP_PRE_ROUTING
 		     || hooknum == NF_IP_POST_ROUTING);
@@ -87,10 +87,10 @@
 		new_ip = (*pskb)->nh.iph->saddr & ~netmask;
 	new_ip |= mr->range[0].min_ip & netmask;
 
-	newrange = ((struct ip_nat_multi_range)
-	{ 1, { { mr->range[0].flags | IP_NAT_RANGE_MAP_IPS,
-		 new_ip, new_ip,
-		 mr->range[0].min, mr->range[0].max } } });
+	newrange = ((struct ip_nat_range)
+		{ mr->range[0].flags | IP_NAT_RANGE_MAP_IPS,
+		  new_ip, new_ip,
+		  mr->range[0].min, mr->range[0].max });
 
 	/* Hand modified range to generic setup. */
 	return ip_nat_setup_info(ct, &newrange, hooknum);
Index: linux-2.6.10-bk6-Netfilter/net/ipv4/netfilter/ipt_MASQUERADE.c
===================================================================
--- linux-2.6.10-bk6-Netfilter.orig/net/ipv4/netfilter/ipt_MASQUERADE.c	2005-01-04 21:30:37.023446712 +1100
+++ linux-2.6.10-bk6-Netfilter/net/ipv4/netfilter/ipt_MASQUERADE.c	2005-01-04 22:11:47.677850152 +1100
@@ -43,7 +43,7 @@
 		 unsigned int targinfosize,
 		 unsigned int hook_mask)
 {
-	const struct ip_nat_multi_range *mr = targinfo;
+	const struct ip_nat_multi_range_compat *mr = targinfo;
 
 	if (strcmp(tablename, "nat") != 0) {
 		DEBUGP("masquerade_check: bad table `%s'.\n", tablename);
@@ -79,8 +79,8 @@
 {
 	struct ip_conntrack *ct;
 	enum ip_conntrack_info ctinfo;
-	const struct ip_nat_multi_range *mr;
-	struct ip_nat_multi_range newrange;
+	const struct ip_nat_multi_range_compat *mr;
+	struct ip_nat_range newrange;
 	struct rtable *rt;
 	u_int32_t newsrc;
 
@@ -108,10 +108,10 @@
 	WRITE_UNLOCK(&masq_lock);
 
 	/* Transfer from original range. */
-	newrange = ((struct ip_nat_multi_range)
-		{ 1, { { mr->range[0].flags | IP_NAT_RANGE_MAP_IPS,
-			 newsrc, newsrc,
-			 mr->range[0].min, mr->range[0].max } } });
+	newrange = ((struct ip_nat_range)
+		{ mr->range[0].flags | IP_NAT_RANGE_MAP_IPS,
+		  newsrc, newsrc,
+		  mr->range[0].min, mr->range[0].max });
 
 	/* Hand modified range to generic setup. */
 	return ip_nat_setup_info(ct, &newrange, hooknum);
Index: linux-2.6.10-bk6-Netfilter/net/ipv4/netfilter/ipt_SAME.c
===================================================================
--- linux-2.6.10-bk6-Netfilter.orig/net/ipv4/netfilter/ipt_SAME.c	2005-01-04 14:55:57.000000000 +1100
+++ linux-2.6.10-bk6-Netfilter/net/ipv4/netfilter/ipt_SAME.c	2005-01-04 22:11:47.680849696 +1100
@@ -149,8 +149,8 @@
 	struct ip_conntrack *ct;
 	enum ip_conntrack_info ctinfo;
 	u_int32_t tmpip, aindex, new_ip;
-	const struct ipt_same_info *mr = targinfo;
-	struct ip_nat_multi_range newrange;
+	const struct ipt_same_info *same = targinfo;
+	struct ip_nat_range newrange;
 	const struct ip_conntrack_tuple *t;
 
 	IP_NF_ASSERT(hooknum == NF_IP_PRE_ROUTING ||
@@ -161,17 +161,17 @@
 
 	/* Base new source on real src ip and optionally dst ip,
 	   giving some hope for consistency across reboots.
-	   Here we calculate the index in mr->iparray which
+	   Here we calculate the index in same->iparray which
 	   holds the ipaddress we should use */
 	
 	tmpip = ntohl(t->src.ip);
 
-	if (!(mr->info & IPT_SAME_NODST))
+	if (!(same->info & IPT_SAME_NODST))
 		tmpip += ntohl(t->dst.ip);
 	
-	aindex = tmpip % mr->ipnum;
-		
-	new_ip = htonl(mr->iparray[aindex]);
+	aindex = tmpip % same->ipnum;
+
+	new_ip = htonl(same->iparray[aindex]);
 
 	DEBUGP("ipt_SAME: src=%u.%u.%u.%u dst=%u.%u.%u.%u, "
 			"new src=%u.%u.%u.%u\n",
@@ -179,10 +179,10 @@
 			NIPQUAD(new_ip));
 
 	/* Transfer from original range. */
-	newrange = ((struct ip_nat_multi_range)
-		{ 1, { { mr->range[0].flags | IP_NAT_RANGE_MAP_IPS,
-			 new_ip, new_ip,
-			 mr->range[0].min, mr->range[0].max } } });
+	newrange = ((struct ip_nat_range)
+		{ same->range[0].flags, new_ip, new_ip,
+		  /* FIXME: Use ports from correct range! */
+		  same->range[0].min, same->range[0].max });
 
 	/* Hand modified range to generic setup. */
 	return ip_nat_setup_info(ct, &newrange, hooknum);
