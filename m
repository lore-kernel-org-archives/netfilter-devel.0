From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 8/11] Netfilter:  Remove manip array from conntrack entry
Date: Mon, 17 Jan 2005 16:46:06 +1100
Message-ID: <1105940766.3954.31.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
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

Name: Remove manip array from conntrack entry
Status: Tested under nfsim
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Original patch and multo bugfixes by Krisztian Kovacs.

Now NAT has been simplified, there is only one place to NAT each
packet.  That means we can intuit what to do by looking at the
difference between this packet and the reply we expect, getting rid of
the manips[] array in the connection tracking structure, which is 72
bytes.  Rework NAT to be based on "change this packet to make src/dst
look like this tuple".

1) Each protocol's manip_pkt takes a "struct ip_conntrack_manip",
   which is half (the source half) of a tuple.  Hand the whole desired
   tuple to the NAT code and have it use the "maniptype" arg to decide
   what part to copy.

2) Krisztian points out that we don't need the NAT lock to read the
   NAT information (or the tuples) as they never change once set, and
   while being set we have exclusive access.  A lock is only needed to
   deal with only remaining NAT list: the bysource hash.

3) We don't need to rehash for the bysource hash: it depends on the
   incoming packet, which we can't change.

4) Many NAT functions only need the maniptype they are to perform, not
   the actual hook, which makes the code clearer.

5) New status bits to indicate what NAT needs to be done.  We can
   always figure it out by inverting the tuple we expect in the other
   direction and comparing it, but this is faster.

6) Rename "do_bindings" to "nat_packet".

7) ICMP handing is vastly simplified: we unconditionally change to
   look the way we want.

Index: linux-2.6.11-rc1-bk4-Netfilter/net/ipv4/netfilter/ip_nat_core.c
===================================================================
--- linux-2.6.11-rc1-bk4-Netfilter.orig/net/ipv4/netfilter/ip_nat_core.c	2005-01-17 14:59:22.418742648 +1100
+++ linux-2.6.11-rc1-bk4-Netfilter/net/ipv4/netfilter/ip_nat_core.c	2005-01-17 14:59:29.654642624 +1100
@@ -42,7 +42,6 @@
 #endif
 
 DECLARE_RWLOCK(ip_nat_lock);
-DECLARE_RWLOCK_EXTERN(ip_conntrack_lock);
 
 /* Calculated at init based on memory size */
 static unsigned int ip_nat_htable_size;
@@ -52,26 +51,22 @@
 

 /* We keep an extra hash for each conntrack, for fast searching. */
-static inline size_t
-hash_by_src(const struct ip_conntrack_manip *manip, u_int16_t proto)
+static inline unsigned int
+hash_by_src(const struct ip_conntrack_tuple *tuple)
 {
 	/* Original src, to ensure we map it consistently if poss. */
-	return (manip->ip + manip->u.all + proto) % ip_nat_htable_size;
+	return jhash_3words(tuple->src.ip, tuple->src.u.all,
+			    tuple->dst.protonum, 0) % ip_nat_htable_size;
 }
 
 /* Noone using conntrack by the time this called. */
 static void ip_nat_cleanup_conntrack(struct ip_conntrack *conn)
 {
 	struct ip_nat_info *info = &conn->nat.info;
-	unsigned int hs;
 
 	if (!info->initialized)
 		return;
 
-	hs = hash_by_src(&conn->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src,
-	                 conn->tuplehash[IP_CT_DIR_ORIGINAL]
-	                 .tuple.dst.protonum);
-
 	WRITE_LOCK(&ip_nat_lock);
 	list_del(&info->bysource);
 	WRITE_UNLOCK(&ip_nat_lock);
@@ -104,25 +99,6 @@
 	return ip_conntrack_tuple_taken(&reply, ignored_conntrack);
 }
 
-/* Before 2.6.11 we did implicit source NAT if required. Warn about change. */
-static void warn_if_extra_mangle(u32 dstip, u32 srcip)
-{
-	static int warned = 0;
-	struct flowi fl = { .nl_u = { .ip4_u = { .daddr = dstip } } };
-	struct rtable *rt;
-
-	if (ip_route_output_key(&rt, &fl) != 0)
-		return;
-
-	if (rt->rt_src != srcip && !warned) {
-		printk("NAT: no longer support implicit source local NAT\n");
-		printk("NAT: packet src %u.%u.%u.%u -> dst %u.%u.%u.%u\n",
-		       NIPQUAD(srcip), NIPQUAD(dstip));
-		warned = 1;
-	}
-	ip_rt_put(rt);
-}
-
 /* If we source map this tuple so reply looks like reply_tuple, will
  * that meet the constraints of range. */
 static int
@@ -165,11 +141,10 @@
 		     struct ip_conntrack_tuple *result,
 		     const struct ip_nat_range *range)
 {
-	unsigned int h = hash_by_src(&tuple->src, tuple->dst.protonum);
+	unsigned int h = hash_by_src(tuple);
 	struct ip_conntrack *ct;
 
-	MUST_BE_READ_LOCKED(&ip_nat_lock);
-
+	READ_LOCK(&ip_nat_lock);
 	list_for_each_entry(ct, &bysource[h], nat.info.bysource) {
 		if (same_src(ct, tuple)) {
 			/* Copy source part from reply tuple. */
@@ -177,10 +152,13 @@
 				       &ct->tuplehash[IP_CT_DIR_REPLY].tuple);
 			result->dst = tuple->dst;
 
-			if (in_range(result, range))
+			if (in_range(result, range)) {
+				READ_UNLOCK(&ip_nat_lock);
 				return 1;
+			}
 		}
 	}
+	READ_UNLOCK(&ip_nat_lock);
 	return 0;
 }
 
@@ -194,7 +172,7 @@
 find_best_ips_proto(struct ip_conntrack_tuple *tuple,
 		    const struct ip_nat_range *range,
 		    const struct ip_conntrack *conntrack,
-		    unsigned int hooknum)
+		    enum ip_nat_manip_type maniptype)
 {
 	u_int32_t *var_ipp;
 	/* Host order */
@@ -204,7 +182,7 @@
 	if (!(range->flags & IP_NAT_RANGE_MAP_IPS))
 		return;
 
-	if (HOOK2MANIP(hooknum) == IP_NAT_MANIP_SRC)
+	if (maniptype == IP_NAT_MANIP_SRC)
 		var_ipp = &tuple->src.ip;
 	else
 		var_ipp = &tuple->dst.ip;
@@ -219,7 +197,7 @@
 	 * spread in practice (if there are a small number of IPs
 	 * involved, there usually aren't that many connections
 	 * anyway).  The consistency means that servers see the same
-	 * client coming from the same IP (some Internet Backing sites
+	 * client coming from the same IP (some Internet Banking sites
 	 * like this), even across reboots. */
 	minip = ntohl(range->min_ip);
 	maxip = ntohl(range->max_ip);
@@ -238,7 +216,7 @@
 		 const struct ip_conntrack_tuple *orig_tuple,
 		 const struct ip_nat_range *range,
 		 struct ip_conntrack *conntrack,
-		 unsigned int hooknum)
+		 enum ip_nat_manip_type maniptype)
 {
 	struct ip_nat_protocol *proto
 		= ip_nat_find_proto(orig_tuple->dst.protonum);
@@ -250,7 +228,7 @@
 	   This is only required for source (ie. NAT/masq) mappings.
 	   So far, we don't do local source mappings, so multiple
 	   manips not an issue.  */
-	if (hooknum == NF_IP_POST_ROUTING) {
+	if (maniptype == IP_NAT_MANIP_SRC) {
 		if (find_appropriate_src(orig_tuple, tuple, range)) {
 			DEBUGP("get_unique_tuple: Found current src map\n");
 			if (!ip_nat_used_tuple(tuple, conntrack))
@@ -261,56 +239,19 @@
 	/* 2) Select the least-used IP/proto combination in the given
 	   range. */
 	*tuple = *orig_tuple;
-	find_best_ips_proto(tuple, range, conntrack, hooknum);
-
-	if (hooknum == NF_IP_LOCAL_OUT && tuple->dst.ip != orig_tuple->dst.ip)
-		warn_if_extra_mangle(tuple->src.ip, tuple->dst.ip);
+	find_best_ips_proto(tuple, range, conntrack, maniptype);
 
 	/* 3) The per-protocol part of the manip is made to map into
 	   the range to make a unique tuple. */
 
 	/* Only bother mapping if it's not already in range and unique */
 	if ((!(range->flags & IP_NAT_RANGE_PROTO_SPECIFIED)
-	     || proto->in_range(tuple, HOOK2MANIP(hooknum),
-				&range->min, &range->max))
+	     || proto->in_range(tuple, maniptype, &range->min, &range->max))
 	    && !ip_nat_used_tuple(tuple, conntrack))
 		return;
 
 	/* Last change: get protocol to try to obtain unique tuple. */
-	proto->unique_tuple(tuple, range, HOOK2MANIP(hooknum), conntrack);
-}
-
-/* Where to manip the reply packets (will be reverse manip). */
-static unsigned int opposite_hook[NF_IP_NUMHOOKS]
-= { [NF_IP_PRE_ROUTING] = NF_IP_POST_ROUTING,
-    [NF_IP_POST_ROUTING] = NF_IP_PRE_ROUTING,
-    [NF_IP_LOCAL_OUT] = NF_IP_LOCAL_IN,
-    [NF_IP_LOCAL_IN] = NF_IP_LOCAL_OUT,
-};
-
-static void replace_in_hashes(struct ip_conntrack *conntrack,
-			      struct ip_nat_info *info)
-{
-	/* Source has changed, so replace in hashes. */
-	unsigned int srchash
-		= hash_by_src(&conntrack->tuplehash[IP_CT_DIR_ORIGINAL]
-			      .tuple.src,
-			      conntrack->tuplehash[IP_CT_DIR_ORIGINAL]
-			      .tuple.dst.protonum);
-	MUST_BE_WRITE_LOCKED(&ip_nat_lock);
-	list_move(&info->bysource, &bysource[srchash]);
-}
-
-static void place_in_hashes(struct ip_conntrack *conntrack,
-			    struct ip_nat_info *info)
-{
-	unsigned int srchash
-		= hash_by_src(&conntrack->tuplehash[IP_CT_DIR_ORIGINAL]
-			      .tuple.src,
-			      conntrack->tuplehash[IP_CT_DIR_ORIGINAL]
-			      .tuple.dst.protonum);
-	MUST_BE_WRITE_LOCKED(&ip_nat_lock);
-	list_add(&info->bysource, &bysource[srchash]);
+	proto->unique_tuple(tuple, range, maniptype, conntrack);
 }
 
 unsigned int
@@ -318,121 +259,53 @@
 		  const struct ip_nat_range *range,
 		  unsigned int hooknum)
 {
-	struct ip_conntrack_tuple new_tuple, inv_tuple, reply;
-	struct ip_conntrack_tuple orig_tp;
+	struct ip_conntrack_tuple curr_tuple, new_tuple;
 	struct ip_nat_info *info = &conntrack->nat.info;
-	int in_hashes = info->initialized;
+	int have_to_hash = !info->initialized;
+	enum ip_nat_manip_type maniptype = HOOK2MANIP(hooknum);
 
-	MUST_BE_WRITE_LOCKED(&ip_nat_lock);
 	IP_NF_ASSERT(hooknum == NF_IP_PRE_ROUTING
 		     || hooknum == NF_IP_POST_ROUTING
 		     || hooknum == NF_IP_LOCAL_IN
 		     || hooknum == NF_IP_LOCAL_OUT);
-	IP_NF_ASSERT(info->num_manips < IP_NAT_MAX_MANIPS);
-	IP_NF_ASSERT(!(info->initialized & (1 << HOOK2MANIP(hooknum))));
+	IP_NF_ASSERT(!(info->initialized & (1 << maniptype)));
 
 	/* What we've got will look like inverse of reply. Normally
 	   this is what is in the conntrack, except for prior
 	   manipulations (future optimization: if num_manips == 0,
 	   orig_tp =
 	   conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple) */
-	invert_tuplepr(&orig_tp,
+	invert_tuplepr(&curr_tuple,
 		       &conntrack->tuplehash[IP_CT_DIR_REPLY].tuple);
 
-#if 0
-	{
-	unsigned int i;
-
-	DEBUGP("Hook %u (%s), ", hooknum,
-	       HOOK2MANIP(hooknum)==IP_NAT_MANIP_SRC ? "SRC" : "DST");
-	DUMP_TUPLE(&orig_tp);
-	DEBUGP("Range %p: ", mr);
-	for (i = 0; i < mr->rangesize; i++) {
-		DEBUGP("%u:%s%s %u.%u.%u.%u - %u.%u.%u.%u %u - %u\n",
-		       i,
-		       (mr->range[i].flags & IP_NAT_RANGE_MAP_IPS)
-		       ? " MAP_IPS" : "",
-		       (mr->range[i].flags
-			& IP_NAT_RANGE_PROTO_SPECIFIED)
-		       ? " PROTO_SPECIFIED" : "",
-		       NIPQUAD(mr->range[i].min_ip),
-		       NIPQUAD(mr->range[i].max_ip),
-		       mr->range[i].min.all,
-		       mr->range[i].max.all);
-	}
-	}
-#endif
-
-	get_unique_tuple(&new_tuple, &orig_tp, range, conntrack, hooknum);
+	get_unique_tuple(&new_tuple, &curr_tuple, range, conntrack, maniptype);
 
-	/* We now have two tuples (SRCIP/SRCPT/DSTIP/DSTPT):
-	   the original (A/B/C/D') and the mangled one (E/F/G/H').
+	if (!ip_ct_tuple_equal(&new_tuple, &curr_tuple)) {
+		struct ip_conntrack_tuple reply;
 
-	   We're only allowed to work with the SRC per-proto
-	   part, so we create inverses of both to start, then
-	   derive the other fields we need.  */
-
-	/* Reply connection: simply invert the new tuple
-	   (G/H/E/F') */
-	invert_tuplepr(&reply, &new_tuple);
-
-	/* Alter conntrack table so will recognize replies. */
-	ip_conntrack_alter_reply(conntrack, &reply);
-
-	/* FIXME: We can simply used existing conntrack reply tuple
-           here --RR */
-	/* Create inverse of original: C/D/A/B' */
-	invert_tuplepr(&inv_tuple, &orig_tp);
-
-	/* Has source changed?. */
-	if (!ip_ct_tuple_src_equal(&new_tuple, &orig_tp)) {
-		IP_NF_ASSERT(HOOK2MANIP(hooknum) == IP_NAT_MANIP_SRC);
-		IP_NF_ASSERT(ip_ct_tuple_dst_equal(&new_tuple, &orig_tp));
-
-		/* In this direction, a source manip. */
-		info->manips[info->num_manips++] =
-			((struct ip_nat_info_manip)
-			 { IP_CT_DIR_ORIGINAL, hooknum,
-			   IP_NAT_MANIP_SRC, new_tuple.src });
-
-		IP_NF_ASSERT(info->num_manips < IP_NAT_MAX_MANIPS);
-
-		/* In the reverse direction, a destination manip. */
-		info->manips[info->num_manips++] =
-			((struct ip_nat_info_manip)
-			 { IP_CT_DIR_REPLY, opposite_hook[hooknum],
-			   IP_NAT_MANIP_DST, orig_tp.src });
-		IP_NF_ASSERT(info->num_manips <= IP_NAT_MAX_MANIPS);
-	}
-
-	/* Has destination changed? */
-	if (!ip_ct_tuple_dst_equal(&new_tuple, &orig_tp)) {
-		IP_NF_ASSERT(HOOK2MANIP(hooknum) == IP_NAT_MANIP_DST);
-
-		/* In this direction, a destination manip */
-		info->manips[info->num_manips++] =
-			((struct ip_nat_info_manip)
-			 { IP_CT_DIR_ORIGINAL, hooknum,
-			   IP_NAT_MANIP_DST, reply.src });
-
-		IP_NF_ASSERT(info->num_manips < IP_NAT_MAX_MANIPS);
-
-		/* In the reverse direction, a source manip. */
-		info->manips[info->num_manips++] =
-			((struct ip_nat_info_manip)
-			 { IP_CT_DIR_REPLY, opposite_hook[hooknum],
-			   IP_NAT_MANIP_SRC, inv_tuple.src });
-		IP_NF_ASSERT(info->num_manips <= IP_NAT_MAX_MANIPS);
+		/* Alter conntrack table so will recognize replies. */
+		invert_tuplepr(&reply, &new_tuple);
+		ip_conntrack_alter_reply(conntrack, &reply);
+
+		/* Non-atomic: we own this at the moment. */
+		if (maniptype == IP_NAT_MANIP_SRC)
+			conntrack->status |= IPS_SRC_NAT;
+		else
+			conntrack->status |= IPS_DST_NAT;
+	}
+
+	/* Place in source hash if this is the first time. */
+	if (have_to_hash) {
+		unsigned int srchash
+			= hash_by_src(&conntrack->tuplehash[IP_CT_DIR_ORIGINAL]
+				      .tuple);
+		WRITE_LOCK(&ip_nat_lock);
+		list_add(&info->bysource, &bysource[srchash]);
+		WRITE_UNLOCK(&ip_nat_lock);
 	}
 
 	/* It's done. */
-	info->initialized |= (1 << HOOK2MANIP(hooknum));
-
-	if (in_hashes)
-		replace_in_hashes(conntrack, info);
-	else
-		place_in_hashes(conntrack, info);
-
+	info->initialized |= (1 << maniptype);
 	return NF_ACCEPT;
 }
 
@@ -441,121 +314,95 @@
 manip_pkt(u_int16_t proto,
 	  struct sk_buff **pskb,
 	  unsigned int iphdroff,
-	  const struct ip_conntrack_manip *manip,
+	  const struct ip_conntrack_tuple *target,
 	  enum ip_nat_manip_type maniptype)
 {
 	struct iphdr *iph;
 
 	(*pskb)->nfcache |= NFC_ALTERED;
-	if (!skb_ip_make_writable(pskb, iphdroff+sizeof(*iph)))
+	if (!skb_ip_make_writable(pskb, iphdroff + sizeof(*iph)))
 		return 0;
 
 	iph = (void *)(*pskb)->data + iphdroff;
 
 	/* Manipulate protcol part. */
 	if (!ip_nat_find_proto(proto)->manip_pkt(pskb, iphdroff,
-	                                         manip, maniptype))
+	                                         target, maniptype))
 		return 0;
 
 	iph = (void *)(*pskb)->data + iphdroff;
 
 	if (maniptype == IP_NAT_MANIP_SRC) {
-		iph->check = ip_nat_cheat_check(~iph->saddr, manip->ip,
+		iph->check = ip_nat_cheat_check(~iph->saddr, target->src.ip,
 						iph->check);
-		iph->saddr = manip->ip;
+		iph->saddr = target->src.ip;
 	} else {
-		iph->check = ip_nat_cheat_check(~iph->daddr, manip->ip,
+		iph->check = ip_nat_cheat_check(~iph->daddr, target->dst.ip,
 						iph->check);
-		iph->daddr = manip->ip;
+		iph->daddr = target->dst.ip;
 	}
 	return 1;
 }
 
-/* Do packet manipulations according to binding. */
-unsigned int
-do_bindings(struct ip_conntrack *ct,
-	    enum ip_conntrack_info ctinfo,
-	    struct ip_nat_info *info,
-	    unsigned int hooknum,
-	    struct sk_buff **pskb)
+/* Do packet manipulations according to ip_nat_setup_info. */
+unsigned int nat_packet(struct ip_conntrack *ct,
+			enum ip_conntrack_info ctinfo,
+			unsigned int hooknum,
+			struct sk_buff **pskb)
 {
-	int i, ret = NF_ACCEPT;
 	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
-	int proto = (*pskb)->nh.iph->protocol;
+	unsigned long statusbit;
+	enum ip_nat_manip_type mtype = HOOK2MANIP(hooknum);
 
-	/* Need nat lock to protect against modification, but neither
-	   conntrack (referenced) and helper (deleted with
-	   synchronize_bh()) can vanish. */
-	READ_LOCK(&ip_nat_lock);
-	for (i = 0; i < info->num_manips; i++) {
-		if (info->manips[i].direction == dir
-		    && info->manips[i].hooknum == hooknum) {
-			DEBUGP("Mangling %p: %s to %u.%u.%u.%u %u\n",
-			       *pskb,
-			       info->manips[i].maniptype == IP_NAT_MANIP_SRC
-			       ? "SRC" : "DST",
-			       NIPQUAD(info->manips[i].manip.ip),
-			       htons(info->manips[i].manip.u.all));
-			if (!manip_pkt(proto, pskb, 0,
-				       &info->manips[i].manip,
-				       info->manips[i].maniptype)) {
-				READ_UNLOCK(&ip_nat_lock);
-				return NF_DROP;
-			}
-		}
-	}
-	READ_UNLOCK(&ip_nat_lock);
-
-	/* FIXME: NAT/conntrack helpers should set ctinfo &
-	 * CT_INFO_RESYNC on packets, so we don't have to adjust all
-	 * connections with conntrack helpers --RR */
+	/* FIXME: use a bit in status for this. */
 	if (ct->helper
-	    && proto == IPPROTO_TCP
+	    && ct->tuplehash[0].tuple.dst.protonum == IPPROTO_TCP
 	    && (hooknum == NF_IP_POST_ROUTING || hooknum == NF_IP_LOCAL_IN)) {
 		DEBUGP("ip_nat_core: adjusting sequence number\n");
 		/* future: put this in a l4-proto specific function,
 		 * and call this function here. */
 		if (!ip_nat_seq_adjust(pskb, ct, ctinfo))
-			ret = NF_DROP;
+			return NF_DROP;
 	}
 
-	return ret;
-}
+	if (mtype == IP_NAT_MANIP_SRC)
+		statusbit = IPS_SRC_NAT;
+	else
+		statusbit = IPS_DST_NAT;
 
-static inline int tuple_src_equal_dst(const struct ip_conntrack_tuple *t1,
-                                      const struct ip_conntrack_tuple *t2)
-{
-	if (t1->dst.protonum != t2->dst.protonum || t1->src.ip != t2->dst.ip)
-		return 0;
-	if (t1->dst.protonum != IPPROTO_ICMP)
-		return t1->src.u.all == t2->dst.u.all;
-	else {
-		struct ip_conntrack_tuple inv;
-
-		/* ICMP tuples are asymetric */
-		invert_tuplepr(&inv, t1);
-		return inv.src.u.all == t2->src.u.all &&
-		       inv.dst.u.all == t2->dst.u.all;
+	/* Invert if this is reply dir. */
+	if (dir == IP_CT_DIR_REPLY)
+		statusbit ^= IPS_NAT_MASK;
+
+	/* Non-atomic: these bits don't change. */
+	if (ct->status & statusbit) {
+		struct ip_conntrack_tuple target;
+
+		/* We are aiming to look like inverse of other direction. */
+		invert_tuplepr(&target, &ct->tuplehash[!dir].tuple);
+
+		if (!manip_pkt(target.dst.protonum, pskb, 0, &target, mtype))
+			return NF_DROP;
 	}
+	return NF_ACCEPT;
 }
 
-int
-icmp_reply_translation(struct sk_buff **pskb,
-		       struct ip_conntrack *conntrack,
-		       unsigned int hooknum,
-		       int dir)
+/* Dir is direction ICMP is coming from (opposite to packet it contains) */
+int icmp_reply_translation(struct sk_buff **pskb,
+			   struct ip_conntrack *ct,
+			   enum ip_nat_manip_type manip,
+			   enum ip_conntrack_dir dir)
 {
 	struct {
 		struct icmphdr icmp;
 		struct iphdr ip;
 	} *inside;
-	unsigned int i;
-	struct ip_nat_info *info = &conntrack->nat.info;
-	struct ip_conntrack_tuple *cttuple, innertuple;
-	int hdrlen;
+	struct ip_conntrack_tuple inner, target;
+	int hdrlen = (*pskb)->nh.iph->ihl * 4;
 
-	if (!skb_ip_make_writable(pskb,(*pskb)->nh.iph->ihl*4+sizeof(*inside)))
+	if (!skb_ip_make_writable(pskb, hdrlen + sizeof(*inside)))
 		return 0;
+
 	inside = (void *)(*pskb)->data + (*pskb)->nh.iph->ihl*4;
 
 	/* We're actually going to mangle it beyond trivial checksum
@@ -576,92 +423,51 @@
            confused... --RR */
 	if (inside->icmp.type == ICMP_REDIRECT) {
 		/* Don't care about races here. */
-		if (info->initialized
+		if (ct->nat.info.initialized
 		    != ((1 << IP_NAT_MANIP_SRC) | (1 << IP_NAT_MANIP_DST))
-		    || info->num_manips != 0)
+		    || (ct->status & IPS_NAT_MASK))
 			return 0;
 	}
 
-	DEBUGP("icmp_reply_translation: translating error %p hook %u dir %s\n",
-	       *pskb, hooknum, dir == IP_CT_DIR_ORIGINAL ? "ORIG" : "REPLY");
-	/* Note: May not be from a NAT'd host, but probably safest to
-	   do translation always as if it came from the host itself
-	   (even though a "host unreachable" coming from the host
-	   itself is a bit weird).
-
-	   More explanation: some people use NAT for anonymizing.
-	   Also, CERT recommends dropping all packets from private IP
-	   addresses (although ICMP errors from internal links with
-	   such addresses are not too uncommon, as Alan Cox points
-	   out) */
+	DEBUGP("icmp_reply_translation: translating error %p manp %u dir %s\n",
+	       *pskb, manip, dir == IP_CT_DIR_ORIGINAL ? "ORIG" : "REPLY");
 
 	if (!ip_ct_get_tuple(&inside->ip, *pskb, (*pskb)->nh.iph->ihl*4 +
 	                     sizeof(struct icmphdr) + inside->ip.ihl*4,
-	                     &innertuple,
-	                     ip_ct_find_proto(inside->ip.protocol)))
+	                     &inner, ip_ct_find_proto(inside->ip.protocol)))
 		return 0;
-	cttuple = &conntrack->tuplehash[dir].tuple;
 
-	READ_LOCK(&ip_nat_lock);
-	for (i = 0; i < info->num_manips; i++) {
-		DEBUGP("icmp_reply: manip %u dir %s hook %u\n",
-		       i, info->manips[i].direction == IP_CT_DIR_ORIGINAL ?
-		       "ORIG" : "REPLY", info->manips[i].hooknum);
-
-		if (info->manips[i].direction != dir)
-			continue;
-
-		/* Mapping the inner packet is just like a normal packet, except
-		 * it was never src/dst reversed, so where we would normally
-		 * apply a dst manip, we apply a src, and vice versa. */
-
-		/* Only true for forwarded packets, locally generated packets
-		 * never hit PRE_ROUTING, we need to apply their PRE_ROUTING
-		 * manips in LOCAL_OUT. */
-		if (hooknum == NF_IP_LOCAL_OUT &&
-		    info->manips[i].hooknum == NF_IP_PRE_ROUTING)
-			hooknum = info->manips[i].hooknum;
-
-		if (info->manips[i].hooknum != hooknum)
-			continue;
-
-		/* ICMP errors may be generated locally for packets that
-		 * don't have all NAT manips applied yet. Verify manips
-		 * have been applied before reversing them */
-		if (info->manips[i].maniptype == IP_NAT_MANIP_SRC) {
-			if (!tuple_src_equal_dst(cttuple, &innertuple))
-				continue;
-		} else {
-			if (!tuple_src_equal_dst(&innertuple, cttuple))
-				continue;
-		}
+	/* Change inner back to look like incoming packet.  We do the
+	   opposite manip on this hook to normal, because it might not
+	   pass all hooks (locally-generated ICMP).  Consider incoming
+	   packet: PREROUTING (DST manip), routing produces ICMP, goes
+	   through POSTROUTING (which must correct the DST manip). */
+	if (!manip_pkt(inside->ip.protocol, pskb,
+		       (*pskb)->nh.iph->ihl*4
+		       + sizeof(inside->icmp),
+		       &ct->tuplehash[!dir].tuple,
+		       !manip))
+		return 0;
 
-		DEBUGP("icmp_reply: inner %s -> %u.%u.%u.%u %u\n",
-		       info->manips[i].maniptype == IP_NAT_MANIP_SRC
-		       ? "DST" : "SRC", NIPQUAD(info->manips[i].manip.ip),
-		       ntohs(info->manips[i].manip.u.udp.port));
-		if (!manip_pkt(inside->ip.protocol, pskb,
-			       (*pskb)->nh.iph->ihl*4 + sizeof(inside->icmp),
-			       &info->manips[i].manip,
-			       !info->manips[i].maniptype))
-			goto unlock_fail;
-
-		/* Outer packet needs to have IP header NATed like
-                   it's a reply. */
-
-		/* Use mapping to map outer packet: 0 give no
-                          per-proto mapping */
-		DEBUGP("icmp_reply: outer %s -> %u.%u.%u.%u\n",
-		       info->manips[i].maniptype == IP_NAT_MANIP_SRC
-		       ? "SRC" : "DST", NIPQUAD(info->manips[i].manip.ip));
-		if (!manip_pkt(0, pskb, 0, &info->manips[i].manip,
-			       info->manips[i].maniptype))
-			goto unlock_fail;
-	}
-	READ_UNLOCK(&ip_nat_lock);
+	/* Change outer to look the reply to an incoming packet
+	 * (proto 0 means don't invert per-proto part). */
 
-	hdrlen = (*pskb)->nh.iph->ihl * 4;
+	/* Obviously, we need to NAT destination IP, but source IP
+	   should be NAT'ed only if it is from a NAT'd host.
 
+	   Explanation: some people use NAT for anonymizing.  Also,
+	   CERT recommends dropping all packets from private IP
+	   addresses (although ICMP errors from internal links with
+	   such addresses are not too uncommon, as Alan Cox points
+	   out) */
+	if (manip != IP_NAT_MANIP_SRC
+	    || ((*pskb)->nh.iph->saddr == ct->tuplehash[dir].tuple.src.ip)) {
+		invert_tuplepr(&target, &ct->tuplehash[!dir].tuple);
+		if (!manip_pkt(0, pskb, 0, &target, manip))
+			return 0;
+	}
+
+	/* Reloading "inside" here since manip_pkt inner. */
 	inside = (void *)(*pskb)->data + (*pskb)->nh.iph->ihl*4;
 
 	inside->icmp.checksum = 0;
@@ -669,10 +475,6 @@
 						       (*pskb)->len - hdrlen,
 						       0));
 	return 1;
-
- unlock_fail:
-	READ_UNLOCK(&ip_nat_lock);
-	return 0;
 }
 
 int __init ip_nat_init(void)
Index: linux-2.6.11-rc1-bk4-Netfilter/net/ipv4/netfilter/ip_nat_helper.c
===================================================================
--- linux-2.6.11-rc1-bk4-Netfilter.orig/net/ipv4/netfilter/ip_nat_helper.c	2005-01-17 14:59:22.419742496 +1100
+++ linux-2.6.11-rc1-bk4-Netfilter/net/ipv4/netfilter/ip_nat_helper.c	2005-01-17 14:59:29.654642624 +1100
@@ -405,46 +405,28 @@
 	return 1;
 }
 
-/* We look at the master's nat fields without ip_nat_lock.  This works
-   because the master's NAT must be fully initialized, because we
-   don't match expectations set up by unconfirmed connections.  We
-   can't grab the lock because we hold the ip_conntrack_lock, and that
-   would be backwards from other locking orders. */
-static void ip_nat_copy_manip(struct ip_nat_info *master,
-			      struct ip_conntrack_expect *exp,
-			      struct ip_conntrack *ct)
-{
-	struct ip_nat_range range;
-	unsigned int i;
-
-	range.flags = IP_NAT_RANGE_MAP_IPS;
-
-	/* Find what master is mapped to (if any), so we can do the same. */
-	for (i = 0; i < master->num_manips; i++) {
-		if (master->manips[i].direction != exp->dir)
-			continue;
-
-		range.min_ip = range.max_ip = master->manips[i].manip.ip;
-
-		/* If this is a DST manip, map port here to where it's
-		 * expected. */
-		if (master->manips[i].maniptype == IP_NAT_MANIP_DST) {
-			range.flags |= IP_NAT_RANGE_PROTO_SPECIFIED;
-			range.min = range.max = exp->saved_proto;
-		}
-		ip_nat_setup_info(ct, &range, master->manips[i].hooknum);
-	}
-}
-
 /* Setup NAT on this expected conntrack so it follows master. */
 /* If we fail to get a free NAT slot, we'll get dropped on confirm */
 void ip_nat_follow_master(struct ip_conntrack *ct,
-			  struct ip_conntrack_expect *this)
+			  struct ip_conntrack_expect *exp)
 {
-	struct ip_nat_info *master = &ct->master->nat.info;
+	struct ip_nat_range range;
 
 	/* This must be a fresh one. */
 	BUG_ON(ct->nat.info.initialized);
 
-	ip_nat_copy_manip(master, this, ct);
+	/* Change src to where master sends to */
+	range.flags = IP_NAT_RANGE_MAP_IPS;
+	range.min_ip = range.max_ip
+		= ct->master->tuplehash[!exp->dir].tuple.dst.ip;
+	/* hook doesn't matter, but it has to do source manip */
+	ip_nat_setup_info(ct, &range, NF_IP_POST_ROUTING);
+
+	/* For DST manip, map port here to where it's expected. */
+	range.flags = (IP_NAT_RANGE_MAP_IPS | IP_NAT_RANGE_PROTO_SPECIFIED);
+	range.min = range.max = exp->saved_proto;
+	range.min_ip = range.max_ip
+		= ct->master->tuplehash[!exp->dir].tuple.src.ip;
+	/* hook doesn't matter, but it has to do destination manip */
+	ip_nat_setup_info(ct, &range, NF_IP_PRE_ROUTING);
 }
Index: linux-2.6.11-rc1-bk4-Netfilter/net/ipv4/netfilter/ip_nat_rule.c
===================================================================
--- linux-2.6.11-rc1-bk4-Netfilter.orig/net/ipv4/netfilter/ip_nat_rule.c	2005-01-17 13:59:08.000000000 +1100
+++ linux-2.6.11-rc1-bk4-Netfilter/net/ipv4/netfilter/ip_nat_rule.c	2005-01-17 14:59:29.685637912 +1100
@@ -16,6 +16,7 @@
 #include <linux/skbuff.h>
 #include <linux/proc_fs.h>
 #include <net/checksum.h>
+#include <net/route.h>
 #include <linux/bitops.h>
 
 #define ASSERT_READ_LOCK(x) MUST_BE_READ_LOCKED(&ip_nat_lock)
@@ -120,6 +121,25 @@
 	return ip_nat_setup_info(ct, &mr->range[0], hooknum);
 }
 
+/* Before 2.6.11 we did implicit source NAT if required. Warn about change. */
+static void warn_if_extra_mangle(u32 dstip, u32 srcip)
+{
+	static int warned = 0;
+	struct flowi fl = { .nl_u = { .ip4_u = { .daddr = dstip } } };
+	struct rtable *rt;
+
+	if (ip_route_output_key(&rt, &fl) != 0)
+		return;
+
+	if (rt->rt_src != srcip && !warned) {
+		printk("NAT: no longer support implicit source local NAT\n");
+		printk("NAT: packet src %u.%u.%u.%u -> dst %u.%u.%u.%u\n",
+		       NIPQUAD(srcip), NIPQUAD(dstip));
+		warned = 1;
+	}
+	ip_rt_put(rt);
+}
+
 static unsigned int ipt_dnat_target(struct sk_buff **pskb,
 				    const struct net_device *in,
 				    const struct net_device *out,
@@ -139,6 +159,11 @@
 	/* Connection must be valid and new. */
 	IP_NF_ASSERT(ct && (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED));
 
+	if (hooknum == NF_IP_LOCAL_OUT
+	    && mr->range[0].flags & IP_NAT_RANGE_MAP_IPS)
+		warn_if_extra_mangle((*pskb)->nh.iph->daddr,
+				     mr->range[0].min_ip);
+
 	return ip_nat_setup_info(ct, &mr->range[0], hooknum);
 }
 
Index: linux-2.6.11-rc1-bk4-Netfilter/include/linux/netfilter_ipv4/ip_nat.h
===================================================================
--- linux-2.6.11-rc1-bk4-Netfilter.orig/include/linux/netfilter_ipv4/ip_nat.h	2005-01-17 14:59:21.158934168 +1100
+++ linux-2.6.11-rc1-bk4-Netfilter/include/linux/netfilter_ipv4/ip_nat.h	2005-01-17 14:59:29.685637912 +1100
@@ -48,42 +48,16 @@
 	struct ip_nat_range range[1];
 };
 
-/* Worst case: local-out manip + 1 post-routing, and reverse dirn. */
-#define IP_NAT_MAX_MANIPS (2*2)
-
-struct ip_nat_info_manip
-{
-	/* The direction. */
-	u_int8_t direction;
-
-	/* Which hook the manipulation happens on. */
-	u_int8_t hooknum;
-
-	/* The manipulation type. */
-	u_int8_t maniptype;
-
-	/* Manipulations to occur at each conntrack in this dirn. */
-	struct ip_conntrack_manip manip;
-};
-
 #ifdef __KERNEL__
 #include <linux/list.h>
 #include <linux/netfilter_ipv4/lockhelp.h>
 
-/* Protects NAT hash tables, and NAT-private part of conntracks. */
-DECLARE_RWLOCK_EXTERN(ip_nat_lock);
-
 /* The structure embedded in the conntrack structure. */
 struct ip_nat_info
 {
 	/* Set to zero when conntrack created: bitmask of maniptypes */
 	u_int16_t initialized;
 
-	u_int16_t num_manips;
-
-	/* Manipulations to be done on this conntrack. */
-	struct ip_nat_info_manip manips[IP_NAT_MAX_MANIPS];
-
 	struct list_head bysource;
 
 	/* Helper (NULL if none). */
Index: linux-2.6.11-rc1-bk4-Netfilter/include/linux/netfilter_ipv4/ip_conntrack.h
===================================================================
--- linux-2.6.11-rc1-bk4-Netfilter.orig/include/linux/netfilter_ipv4/ip_conntrack.h	2005-01-17 14:59:13.351121136 +1100
+++ linux-2.6.11-rc1-bk4-Netfilter/include/linux/netfilter_ipv4/ip_conntrack.h	2005-01-17 14:59:29.686637760 +1100
@@ -40,6 +40,17 @@
 	/* Connection is confirmed: originating packet has left box */
 	IPS_CONFIRMED_BIT = 3,
 	IPS_CONFIRMED = (1 << IPS_CONFIRMED_BIT),
+
+	/* Connection needs src nat in orig dir.  This bit never changed. */
+	IPS_SRC_NAT_BIT = 4,
+	IPS_SRC_NAT = (1 << IPS_SRC_NAT_BIT),
+
+	/* Connection needs dst nat in orig dir.  This bit never changed. */
+	IPS_DST_NAT_BIT = 5,
+	IPS_DST_NAT = (1 << IPS_DST_NAT_BIT),
+
+	/* Both together. */
+	IPS_NAT_MASK = (IPS_DST_NAT | IPS_SRC_NAT),
 };
 
 #ifdef __KERNEL__
Index: linux-2.6.11-rc1-bk4-Netfilter/net/ipv4/netfilter/ip_nat_proto_unknown.c
===================================================================
--- linux-2.6.11-rc1-bk4-Netfilter.orig/net/ipv4/netfilter/ip_nat_proto_unknown.c	2005-01-11 16:52:23.000000000 +1100
+++ linux-2.6.11-rc1-bk4-Netfilter/net/ipv4/netfilter/ip_nat_proto_unknown.c	2005-01-17 14:59:29.703635176 +1100
@@ -40,7 +40,7 @@
 static int
 unknown_manip_pkt(struct sk_buff **pskb,
 		  unsigned int iphdroff,
-		  const struct ip_conntrack_manip *manip,
+		  const struct ip_conntrack_tuple *tuple,
 		  enum ip_nat_manip_type maniptype)
 {
 	return 1;
Index: linux-2.6.11-rc1-bk4-Netfilter/net/ipv4/netfilter/ip_nat_standalone.c
===================================================================
--- linux-2.6.11-rc1-bk4-Netfilter.orig/net/ipv4/netfilter/ip_nat_standalone.c	2005-01-17 14:59:22.420742344 +1100
+++ linux-2.6.11-rc1-bk4-Netfilter/net/ipv4/netfilter/ip_nat_standalone.c	2005-01-17 14:59:29.704635024 +1100
@@ -106,7 +106,7 @@
 	case IP_CT_RELATED:
 	case IP_CT_RELATED+IP_CT_IS_REPLY:
 		if ((*pskb)->nh.iph->protocol == IPPROTO_ICMP) {
-			if (!icmp_reply_translation(pskb, ct, hooknum,
+			if (!icmp_reply_translation(pskb, ct, maniptype,
 						    CTINFO2DIR(ctinfo)))
 				return NF_DROP;
 			else
@@ -116,7 +116,6 @@
 	case IP_CT_NEW:
 		info = &ct->nat.info;
 
-		WRITE_LOCK(&ip_nat_lock);
 		/* Seen it before?  This can happen for loopback, retrans,
 		   or local packets.. */
 		if (!(info->initialized & (1 << maniptype))) {
@@ -131,14 +130,12 @@
 						       info);
 
 			if (ret != NF_ACCEPT) {
-				WRITE_UNLOCK(&ip_nat_lock);
 				return ret;
 			}
 		} else
 			DEBUGP("Already setup manip %s for ct %p\n",
 			       maniptype == IP_NAT_MANIP_SRC ? "SRC" : "DST",
 			       ct);
-		WRITE_UNLOCK(&ip_nat_lock);
 		break;
 
 	default:
@@ -149,7 +146,7 @@
 	}
 
 	IP_NF_ASSERT(info);
-	return do_bindings(ct, ctinfo, info, hooknum, pskb);
+	return nat_packet(ct, ctinfo, hooknum, pskb);
 }
 
 static unsigned int
Index: linux-2.6.11-rc1-bk4-Netfilter/net/ipv4/netfilter/ip_nat_proto_udp.c
===================================================================
--- linux-2.6.11-rc1-bk4-Netfilter.orig/net/ipv4/netfilter/ip_nat_proto_udp.c	2005-01-13 12:11:13.000000000 +1100
+++ linux-2.6.11-rc1-bk4-Netfilter/net/ipv4/netfilter/ip_nat_proto_udp.c	2005-01-17 14:59:29.715633352 +1100
@@ -84,34 +84,40 @@
 static int
 udp_manip_pkt(struct sk_buff **pskb,
 	      unsigned int iphdroff,
-	      const struct ip_conntrack_manip *manip,
+	      const struct ip_conntrack_tuple *tuple,
 	      enum ip_nat_manip_type maniptype)
 {
 	struct iphdr *iph = (struct iphdr *)((*pskb)->data + iphdroff);
 	struct udphdr *hdr;
 	unsigned int hdroff = iphdroff + iph->ihl*4;
-	u32 oldip, oldsrc = iph->saddr, olddst = iph->daddr;
-	u16 *portptr;
+	u32 oldip, newip;
+	u16 *portptr, newport;
 
 	if (!skb_ip_make_writable(pskb, hdroff + sizeof(*hdr)))
 		return 0;
 
-	hdr = (void *)(*pskb)->data + hdroff;
+	iph = (struct iphdr *)((*pskb)->data + iphdroff);
+	hdr = (struct udphdr *)((*pskb)->data + hdroff);
+
 	if (maniptype == IP_NAT_MANIP_SRC) {
 		/* Get rid of src ip and src pt */
-		oldip = oldsrc;
+		oldip = iph->saddr;
+		newip = tuple->src.ip;
+		newport = tuple->src.u.udp.port;
 		portptr = &hdr->source;
 	} else {
 		/* Get rid of dst ip and dst pt */
-		oldip = olddst;
+		oldip = iph->daddr;
+		newip = tuple->dst.ip;
+		newport = tuple->dst.u.udp.port;
 		portptr = &hdr->dest;
 	}
 	if (hdr->check) /* 0 is a special case meaning no checksum */
-		hdr->check = ip_nat_cheat_check(~oldip, manip->ip,
+		hdr->check = ip_nat_cheat_check(~oldip, newip,
 					ip_nat_cheat_check(*portptr ^ 0xFFFF,
-							   manip->u.udp.port,
+							   newport,
 							   hdr->check));
-	*portptr = manip->u.udp.port;
+	*portptr = newport;
 	return 1;
 }
 
Index: linux-2.6.11-rc1-bk4-Netfilter/net/ipv4/netfilter/ip_nat_proto_tcp.c
===================================================================
--- linux-2.6.11-rc1-bk4-Netfilter.orig/net/ipv4/netfilter/ip_nat_proto_tcp.c	2005-01-13 12:11:13.000000000 +1100
+++ linux-2.6.11-rc1-bk4-Netfilter/net/ipv4/netfilter/ip_nat_proto_tcp.c	2005-01-17 14:59:29.730631072 +1100
@@ -85,14 +85,14 @@
 static int
 tcp_manip_pkt(struct sk_buff **pskb,
 	      unsigned int iphdroff,
-	      const struct ip_conntrack_manip *manip,
+	      const struct ip_conntrack_tuple *tuple,
 	      enum ip_nat_manip_type maniptype)
 {
 	struct iphdr *iph = (struct iphdr *)((*pskb)->data + iphdroff);
 	struct tcphdr *hdr;
 	unsigned int hdroff = iphdroff + iph->ihl*4;
-	u32 oldip, oldsrc = iph->saddr, olddst = iph->daddr;
-	u16 *portptr, oldport;
+	u32 oldip, newip;
+	u16 *portptr, newport, oldport;
 	int hdrsize = 8; /* TCP connection tracking guarantees this much */
 
 	/* this could be a inner header returned in icmp packet; in such
@@ -104,27 +104,32 @@
 	if (!skb_ip_make_writable(pskb, hdroff + hdrsize))
 		return 0;
 
-	hdr = (void *)(*pskb)->data + hdroff;
+	iph = (struct iphdr *)((*pskb)->data + iphdroff);
+	hdr = (struct tcphdr *)((*pskb)->data + iph->ihl*4);
 
 	if (maniptype == IP_NAT_MANIP_SRC) {
 		/* Get rid of src ip and src pt */
-		oldip = oldsrc;
+		oldip = iph->saddr;
+		newip = tuple->src.ip;
+		newport = tuple->src.u.tcp.port;
 		portptr = &hdr->source;
 	} else {
 		/* Get rid of dst ip and dst pt */
-		oldip = olddst;
+		oldip = iph->daddr;
+		newip = tuple->dst.ip;
+		newport = tuple->dst.u.tcp.port;
 		portptr = &hdr->dest;
 	}
 
 	oldport = *portptr;
-	*portptr = manip->u.tcp.port;
+	*portptr = newport;
 
 	if (hdrsize < sizeof(*hdr))
 		return 1;
 
-	hdr->check = ip_nat_cheat_check(~oldip, manip->ip,
+	hdr->check = ip_nat_cheat_check(~oldip, newip,
 					ip_nat_cheat_check(oldport ^ 0xFFFF,
-							   manip->u.tcp.port,
+							   newport,
 							   hdr->check));
 	return 1;
 }
Index: linux-2.6.11-rc1-bk4-Netfilter/include/linux/netfilter_ipv4/ip_nat_protocol.h
===================================================================
--- linux-2.6.11-rc1-bk4-Netfilter.orig/include/linux/netfilter_ipv4/ip_nat_protocol.h	2005-01-17 14:59:22.467735200 +1100
+++ linux-2.6.11-rc1-bk4-Netfilter/include/linux/netfilter_ipv4/ip_nat_protocol.h	2005-01-17 14:59:29.730631072 +1100
@@ -15,11 +15,11 @@
 	/* Protocol number. */
 	unsigned int protonum;
 
-	/* Do a packet translation according to the ip_nat_proto_manip
-	 * and manip type.  Return true if succeeded. */
+	/* Translate a packet to the target according to manip type.
+	   Return true if succeeded. */
 	int (*manip_pkt)(struct sk_buff **pskb,
 			 unsigned int iphdroff,
-			 const struct ip_conntrack_manip *manip,
+			 const struct ip_conntrack_tuple *tuple,
 			 enum ip_nat_manip_type maniptype);
 
 	/* Is the manipable part of the tuple between min and max incl? */
Index: linux-2.6.11-rc1-bk4-Netfilter/net/ipv4/netfilter/ip_nat_proto_icmp.c
===================================================================
--- linux-2.6.11-rc1-bk4-Netfilter.orig/net/ipv4/netfilter/ip_nat_proto_icmp.c	2005-01-11 16:52:23.000000000 +1100
+++ linux-2.6.11-rc1-bk4-Netfilter/net/ipv4/netfilter/ip_nat_proto_icmp.c	2005-01-17 14:59:29.731630920 +1100
@@ -54,7 +54,7 @@
 static int
 icmp_manip_pkt(struct sk_buff **pskb,
 	       unsigned int iphdroff,
-	       const struct ip_conntrack_manip *manip,
+	       const struct ip_conntrack_tuple *tuple,
 	       enum ip_nat_manip_type maniptype)
 {
 	struct iphdr *iph = (struct iphdr *)((*pskb)->data + iphdroff);
@@ -64,12 +64,12 @@
 	if (!skb_ip_make_writable(pskb, hdroff + sizeof(*hdr)))
 		return 0;
 
-	hdr = (void *)(*pskb)->data + hdroff;
+	hdr = (struct icmphdr *)((*pskb)->data + hdroff);
 
 	hdr->checksum = ip_nat_cheat_check(hdr->un.echo.id ^ 0xFFFF,
-					    manip->u.icmp.id,
+					    tuple->src.u.icmp.id,
 					    hdr->checksum);
-	hdr->un.echo.id = manip->u.icmp.id;
+	hdr->un.echo.id = tuple->src.u.icmp.id;
 	return 1;
 }
 
Index: linux-2.6.11-rc1-bk4-Netfilter/include/linux/netfilter_ipv4/ip_nat_core.h
===================================================================
--- linux-2.6.11-rc1-bk4-Netfilter.orig/include/linux/netfilter_ipv4/ip_nat_core.h	2005-01-17 14:59:22.468735048 +1100
+++ linux-2.6.11-rc1-bk4-Netfilter/include/linux/netfilter_ipv4/ip_nat_core.h	2005-01-17 14:59:29.731630920 +1100
@@ -8,16 +8,13 @@
 extern int ip_nat_init(void);
 extern void ip_nat_cleanup(void);
 
-extern unsigned int do_bindings(struct ip_conntrack *ct,
-				enum ip_conntrack_info conntrackinfo,
-				struct ip_nat_info *info,
-				unsigned int hooknum,
-				struct sk_buff **pskb);
+extern unsigned int nat_packet(struct ip_conntrack *ct,
+			       enum ip_conntrack_info conntrackinfo,
+			       unsigned int hooknum,
+			       struct sk_buff **pskb);
 
 extern int icmp_reply_translation(struct sk_buff **pskb,
-				  struct ip_conntrack *conntrack,
-				  unsigned int hooknum,
-				  int dir);
-
-
+				  struct ip_conntrack *ct,
+				  enum ip_nat_manip_type manip,
+				  enum ip_conntrack_dir dir);
 #endif /* _IP_NAT_CORE_H */
