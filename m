From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 4/5] Remove do_extra_mangle
Date: Thu, 18 Nov 2004 16:45:21 +1100
Message-ID: <1100756722.5865.55.camel@localhost.localdomain>
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

Name: Remove do_extra_mangle: double NAT on LOCAL_OUT
Status: Untested
Depends: Netfilter/remove-multiple-ranges.patch.gz
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

On NF_IP_LOCAL_OUT, when destination NAT changes the destination
interface, we also change the source address, so the packet is the
same as if it were generated to go that way in the first place.  This
is not strictly necessary, I believe.

This patch rips that code out to see what breaks.

Index: linux-2.6.10-rc2-bk1-Netfilter/net/ipv4/netfilter/ip_nat_core.c
===================================================================
--- linux-2.6.10-rc2-bk1-Netfilter.orig/net/ipv4/netfilter/ip_nat_core.c	2004-11-18 15:26:41.905792496 +1100
+++ linux-2.6.10-rc2-bk1-Netfilter/net/ipv4/netfilter/ip_nat_core.c	2004-11-18 15:58:37.821529032 +1100
@@ -179,27 +179,6 @@
 	return 0;
 }
 
-#ifdef CONFIG_IP_NF_NAT_LOCAL
-/* If it's really a local destination manip, it may need to do a
-   source manip too. */
-static void
-do_extra_mangle(u_int32_t var_ip, u_int32_t *other_ipp)
-{
-	struct flowi fl = { .nl_u = { .ip4_u = { .daddr = var_ip } } };
-	struct rtable *rt;
-
-	/* FIXME: IPTOS_TOS(iph->tos) --RR */
-	if (ip_route_output_key(&rt, &fl) != 0) {
-		DEBUGP("do_extra_mangle: Can't get route to %u.%u.%u.%u\n",
-		       NIPQUAD(var_ip));
-		return;
-	}
-
-	*other_ipp = rt->rt_src;
-	ip_rt_put(rt);
-}
-#endif
-
 /* Simple way to iterate through all. */
 static inline int fake_cmp(const struct ip_conntrack *ct,
 			   u_int32_t src, u_int32_t dst, u_int16_t protonum,
@@ -246,30 +225,32 @@
 {
 	unsigned int best_score = 0xFFFFFFFF;
 	struct ip_conntrack_tuple best_tuple = *tuple;
-	u_int32_t *var_ipp, *other_ipp, saved_ip, orig_dstip;
+	u_int32_t *var_ipp;
 	static unsigned int randomness;
 	/* Host order */
 	u_int32_t minip, maxip, j;
 
-	if (HOOK2MANIP(hooknum) == IP_NAT_MANIP_SRC) {
+	/* No IP mapping?  Do nothing. */
+	if (!(range->flags & IP_NAT_RANGE_MAP_IPS))
+		return;
+
+	if (HOOK2MANIP(hooknum) == IP_NAT_MANIP_SRC)
 		var_ipp = &tuple->src.ip;
-		saved_ip = tuple->dst.ip;
-		other_ipp = &tuple->dst.ip;
-	} else {
+	else
 		var_ipp = &tuple->dst.ip;
-		saved_ip = tuple->src.ip;
-		other_ipp = &tuple->src.ip;
+
+	/* Fast path: only one choice. */
+	if (range->min_ip == range->max_ip) {
+		*var_ipp = range->min_ip;
+		return;
 	}
-	/* Don't do do_extra_mangle unless necessary (overrides
-           explicit socket bindings, for example) */
-	orig_dstip = tuple->dst.ip;
-
-	if (range->flags & IP_NAT_RANGE_MAP_IPS) {
-		minip = ntohl(range->min_ip);
-		maxip = ntohl(range->max_ip);
-	} else
-		minip = maxip = ntohl(*var_ipp);
 
+	minip = ntohl(range->min_ip);
+	maxip = ntohl(range->max_ip);
+
+	/* FIXME: use hash of ips like ipt_SAME, not randomness.
+	   This way same pairs get same IP: think Internet Banking.
+	 */
 	randomness++;
 	for (j = 0; j < maxip - minip + 1; j++) {
 		unsigned int score;
@@ -277,16 +258,6 @@
 		*var_ipp = htonl(minip + (randomness + j) 
 				 % (maxip - minip + 1));
 
-		/* Reset the other ip in case it was mangled by
-		 * do_extra_mangle last time. */
-		*other_ipp = saved_ip;
-
-#ifdef CONFIG_IP_NF_NAT_LOCAL
-		if (hooknum == NF_IP_LOCAL_OUT
-		    && *var_ipp != orig_dstip)
-			do_extra_mangle(*var_ipp, other_ipp);
-#endif
-
 		/* Count how many others map onto this. */
 		score = count_maps(tuple->src.ip, tuple->dst.ip,
 				   tuple->dst.protonum, conntrack);
@@ -303,38 +274,6 @@
 	*tuple = best_tuple;
 }
 
-/* Fast version doesn't iterate through hash chains, but only handles
-   common case of single IP address (null NAT, masquerade) */
-static void
-find_best_ips_proto_fast(struct ip_conntrack_tuple *tuple,
-			 const struct ip_nat_range *range,
-			 const struct ip_conntrack *conntrack,
-			 unsigned int hooknum)
-{
-	/* Leave IP address alone if we're not to map IP addresses. */
-	if (!(range->flags & IP_NAT_RANGE_MAP_IPS))
-		return;
-
-	if (range->min_ip != range->max_ip) {
-		find_best_ips_proto(tuple, range, conntrack, hooknum);
-		return;
-	}
-
-	if (HOOK2MANIP(hooknum) == IP_NAT_MANIP_SRC)
-		tuple->src.ip = range->min_ip;
-	else {
-		/* Only do extra mangle when required (breaks socket
-		   binding) */
-#ifdef CONFIG_IP_NF_NAT_LOCAL
-		if (tuple->dst.ip != range->min_ip
-		    && hooknum == NF_IP_LOCAL_OUT)
-			do_extra_mangle(range->min_ip, &tuple->src.ip);
-		else
-#endif
-		tuple->dst.ip = range->min_ip;
-	}
-}
-
 /* Manipulate the tuple into the range given.  For NF_IP_POST_ROUTING,
  * we change the source to map into the range.  For NF_IP_PRE_ROUTING
  * and NF_IP_LOCAL_OUT, we change the destination to map into the
@@ -369,7 +308,7 @@
 	/* 2) Select the least-used IP/proto combination in the given
 	   range. */
 	*tuple = *orig_tuple;
-	find_best_ips_proto_fast(tuple, range, conntrack, hooknum);
+	find_best_ips_proto(tuple, range, conntrack, hooknum);
 
 	/* 3) The per-protocol part of the manip is made to map into
 	   the range to make a unique tuple. */
@@ -470,6 +409,9 @@
 
 	/* Has source changed?. */
 	if (!ip_ct_tuple_src_equal(&new_tuple, &orig_tp)) {
+		IP_NF_ASSERT(HOOK2MANIP(hooknum) == IP_NAT_MANIP_SRC);
+		IP_NF_ASSERT(ip_ct_tuple_dst_equal(&new_tuple, &orig_tp));
+
 		/* In this direction, a source manip. */
 		info->manips[info->num_manips++] =
 			((struct ip_nat_info_manip)
@@ -488,6 +430,8 @@
 
 	/* Has destination changed? */
 	if (!ip_ct_tuple_dst_equal(&new_tuple, &orig_tp)) {
+		IP_NF_ASSERT(HOOK2MANIP(hooknum) == IP_NAT_MANIP_DST);
+
 		/* In this direction, a destination manip */
 		info->manips[info->num_manips++] =
 			((struct ip_nat_info_manip)

-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
