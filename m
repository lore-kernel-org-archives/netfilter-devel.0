From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 5/18] Netfilter:  Don't try too hard to NAT to unique tuple
Date: Wed, 05 Jan 2005 14:32:20 +1100
Message-ID: <1104895940.20582.64.camel@localhost.localdomain>
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

Name: Don't try too hard to NAT to unique tuple
Status: Tested under nfsim
Depends: Netfilter/remove-multiple-ranges.patch.gz
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

On NF_IP_LOCAL_OUT or NF_IP_PRE_ROUTING, if destination NAT is not
sufficient to create a unique tuple, we try changing the source port
as well.  However, this is also not strictly necessary: if the tuple
is not unique, we will also try to change the source on the
NF_IP_POST_ROUTING hook.

When we finally confirm the connection, if the tuple is still not
unique the packet will be dropped (this is required anyway as we could
race: the conntrack is not placed in the hash until the packet is
about to leave the box anyway).

In fact, we only need best effort *everywhere*.

This patch rips that code out to see what breaks.

Index: linux-2.6.10-rc3-bk6-Netfilter/net/ipv4/netfilter/ip_nat_core.c
===================================================================
--- linux-2.6.10-rc3-bk6-Netfilter.orig/net/ipv4/netfilter/ip_nat_core.c	2004-12-13 12:03:17.488291256 +1100
+++ linux-2.6.10-rc3-bk6-Netfilter/net/ipv4/netfilter/ip_nat_core.c	2004-12-13 12:03:18.092199448 +1100
@@ -181,7 +181,7 @@
 
 /* If it's really a local destination manip, it may need to do a
    source manip too. */
-static int
+static void
 do_extra_mangle(u_int32_t var_ip, u_int32_t *other_ipp)
 {
 	struct flowi fl = { .nl_u = { .ip4_u = { .daddr = var_ip } } };
@@ -191,12 +191,11 @@
 	if (ip_route_output_key(&rt, &fl) != 0) {
 		DEBUGP("do_extra_mangle: Can't get route to %u.%u.%u.%u\n",
 		       NIPQUAD(var_ip));
-		return 0;
+		return;
 	}
 
 	*other_ipp = rt->rt_src;
 	ip_rt_put(rt);
-	return 1;
 }
 
 /* Simple way to iterate through all. */
@@ -237,14 +236,14 @@
    1-65535, we don't do pro-rata allocation based on ports; we choose
    the ip with the lowest src-ip/dst-ip/proto usage.
 */
-static int
+static void
 find_best_ips_proto(struct ip_conntrack_tuple *tuple,
 		    const struct ip_nat_range *range,
 		    const struct ip_conntrack *conntrack,
 		    unsigned int hooknum)
 {
 	unsigned int best_score = 0xFFFFFFFF;
-	struct ip_conntrack_tuple best_tuple;
+	struct ip_conntrack_tuple best_tuple = *tuple;
 	u_int32_t *var_ipp, *other_ipp, saved_ip, orig_dstip;
 	static unsigned int randomness;
 	/* Host order */
@@ -281,15 +280,8 @@
 		*other_ipp = saved_ip;
 
 		if (hooknum == NF_IP_LOCAL_OUT
-		    && *var_ipp != orig_dstip
-		    && !do_extra_mangle(*var_ipp, other_ipp)) {
-			DEBUGP("Range %u %u.%u.%u.%u rt failed!\n",
-			       i, NIPQUAD(*var_ipp));
-			/* Can't route?  This whole range part is
-			 * probably screwed, but keep trying
-			 * anyway. */
-			continue;
-		}
+		    && *var_ipp != orig_dstip)
+			do_extra_mangle(*var_ipp, other_ipp);
 
 		/* Count how many others map onto this. */
 		score = count_maps(tuple->src.ip, tuple->dst.ip,
@@ -298,23 +290,18 @@
 			/* Optimization: doesn't get any better than
 			   this. */
 			if (score == 0)
-				return 1;
+				return;
 
 			best_score = score;
 			best_tuple = *tuple;
 		}
 	}
-
-	if (best_score == 0xFFFFFFFF)
-		return 0;
-
 	*tuple = best_tuple;
-	return 1;
 }
 
 /* Fast version doesn't iterate through hash chains, but only handles
    common case of single IP address (null NAT, masquerade) */
-static int
+static void
 find_best_ips_proto_fast(struct ip_conntrack_tuple *tuple,
 			 const struct ip_nat_range *range,
 			 const struct ip_conntrack *conntrack,
@@ -322,10 +309,12 @@
 {
 	/* Leave IP address alone if we're not to map IP addresses. */
 	if (!(range->flags & IP_NAT_RANGE_MAP_IPS))
-		return 1;
+		return;
 
-	if (range->min_ip != range->max_ip)
-		return find_best_ips_proto(tuple, range, conntrack, hooknum);
+	if (range->min_ip != range->max_ip) {
+		find_best_ips_proto(tuple, range, conntrack, hooknum);
+		return;
+	}
 
 	if (HOOK2MANIP(hooknum) == IP_NAT_MANIP_SRC)
 		tuple->src.ip = range->min_ip;
@@ -333,16 +322,20 @@
 		/* Only do extra mangle when required (breaks socket
 		   binding) */
 		if (tuple->dst.ip != range->min_ip
-		    && hooknum == NF_IP_LOCAL_OUT
-		    && !do_extra_mangle(range->min_ip, &tuple->src.ip))
-			return 0;
+		    && hooknum == NF_IP_LOCAL_OUT)
+			do_extra_mangle(range->min_ip, &tuple->src.ip);
+		else
 		tuple->dst.ip = range->min_ip;
 	}
-
-	return 1;
 }
 
-static int
+/* Manipulate the tuple into the range given.  For NF_IP_POST_ROUTING,
+ * we change the source to map into the range.  For NF_IP_PRE_ROUTING
+ * and NF_IP_LOCAL_OUT, we change the destination to map into the
+ * range.  It might not be possible to get a unique tuple, but we try.
+ * At worst (or if we race), we will end up with a final duplicate in
+ * __ip_conntrack_confirm and drop the packet. */
+static void
 get_unique_tuple(struct ip_conntrack_tuple *tuple,
 		 const struct ip_conntrack_tuple *orig_tuple,
 		 const struct ip_nat_range *range,
@@ -363,15 +356,14 @@
 		if (find_appropriate_src(orig_tuple, tuple, range)) {
 			DEBUGP("get_unique_tuple: Found current src map\n");
 			if (!ip_nat_used_tuple(tuple, conntrack))
-				return 1;
+				return;
 		}
 	}
 
 	/* 2) Select the least-used IP/proto combination in the given
 	   range. */
 	*tuple = *orig_tuple;
-	if (!find_best_ips_proto_fast(tuple, range, conntrack, hooknum))
-		return 0;
+	find_best_ips_proto_fast(tuple, range, conntrack, hooknum);
 
 	/* 3) The per-protocol part of the manip is made to map into
 	   the range to make a unique tuple. */
@@ -381,30 +373,10 @@
 	     || proto->in_range(tuple, HOOK2MANIP(hooknum),
 				&range->min, &range->max))
 	    && !ip_nat_used_tuple(tuple, conntrack))
-		return 1;
+		return;
 
-	if (proto->unique_tuple(tuple, range, HOOK2MANIP(hooknum), conntrack)){
-		/* Must be unique. */
-		IP_NF_ASSERT(!ip_nat_used_tuple(tuple, conntrack));
-		return 1;
-	}
-
-	if (HOOK2MANIP(hooknum) == IP_NAT_MANIP_DST) {
-		/* Try implicit source NAT; protocol may be able to
-		   play with ports to make it unique. */
-		struct ip_nat_range r
-			= { IP_NAT_RANGE_MAP_IPS, 
-			    tuple->src.ip, tuple->src.ip, { 0 }, { 0 } };
-		DEBUGP("Trying implicit mapping\n");
-		if (proto->unique_tuple(tuple, &r, IP_NAT_MANIP_SRC,
-					conntrack)) {
-			/* Must be unique. */
-			IP_NF_ASSERT(!ip_nat_used_tuple(tuple, conntrack));
-			return 1;
-		}
-		DEBUGP("Protocol can't get unique tuple %u.\n", hooknum);
-	}
-	return 0;
+	/* Last change: get protocol to try to obtain unique tuple. */
+	proto->unique_tuple(tuple, range, HOOK2MANIP(hooknum), conntrack);
 }
 
 /* Where to manip the reply packets (will be reverse manip). */
@@ -467,11 +439,7 @@
 	}
 #endif
 
-	if (!get_unique_tuple(&new_tuple, &orig_tp, range,conntrack,hooknum)) {
-		DEBUGP("ip_nat_setup_info: Can't get unique for %p.\n",
-		       conntrack);
-		return NF_DROP;
-	}
+	get_unique_tuple(&new_tuple, &orig_tp, range, conntrack, hooknum);
 
 	/* We now have two tuples (SRCIP/SRCPT/DSTIP/DSTPT):
 	   the original (A/B/C/D') and the mangled one (E/F/G/H').
