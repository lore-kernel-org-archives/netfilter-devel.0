From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 5/5] Remove randomness from IP selection
Date: Thu, 18 Nov 2004 16:46:35 +1100
Message-ID: <1100756795.5865.57.camel@localhost.localdomain>
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

Name: Remove Randomness in Selecting NAT IP Address
Status: Untested
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

We currently choose a "random" IP address to NAT to, where we have a
range.  Martin Josefsson pointed out that he uses the SAME target in
iptables because changing IP addresses breaks Internet banking sites
(among others) which assume the customer will be coming from a
consistent IP address.

In fact, we spend a fair bit of effort trying to balance the number of
connections we NAT to each IP address.  We can come pretty damn close
just hashing the source and destination IP addresses, and it has the
consistency property which is so desirable, as well as being faster.


Index: linux-2.6.10-rc2-bk1-Netfilter/net/ipv4/netfilter/ip_nat_core.c
===================================================================
--- linux-2.6.10-rc2-bk1-Netfilter.orig/net/ipv4/netfilter/ip_nat_core.c	2004-11-18 16:06:33.375233880 +1100
+++ linux-2.6.10-rc2-bk1-Netfilter/net/ipv4/netfilter/ip_nat_core.c	2004-11-18 16:14:53.245242088 +1100
@@ -20,6 +20,7 @@
 #include <net/tcp.h>  /* For tcp_prot in getorigdst */
 #include <linux/icmp.h>
 #include <linux/udp.h>
+#include <linux/jhash.h>
 
 #define ASSERT_READ_LOCK(x) MUST_BE_READ_LOCKED(&ip_nat_lock)
 #define ASSERT_WRITE_LOCK(x) MUST_BE_WRITE_LOCKED(&ip_nat_lock)
@@ -47,7 +48,6 @@
 static unsigned int ip_nat_htable_size;
 
 static struct list_head *bysource;
-static struct list_head *byipsproto;
 struct ip_nat_protocol *ip_nat_protos[MAX_IP_NAT_PROTO];
 
 
@@ -87,7 +87,6 @@
 
 	WRITE_LOCK(&ip_nat_lock);
 	list_del(&info->bysource);
-	list_del(&info->byipsproto);
 	WRITE_UNLOCK(&ip_nat_lock);
 }
 
@@ -179,38 +178,6 @@
 	return 0;
 }
 
-/* Simple way to iterate through all. */
-static inline int fake_cmp(const struct ip_conntrack *ct,
-			   u_int32_t src, u_int32_t dst, u_int16_t protonum,
-			   unsigned int *score, const struct ip_conntrack *ct2)
-{
-	/* Compare backwards: we're dealing with OUTGOING tuples, and
-           inside the conntrack is the REPLY tuple.  Don't count this
-           conntrack. */
-	if (ct != ct2
-	    && ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.ip == dst
-	    && ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip == src
-	    && (ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.protonum == protonum))
-		(*score)++;
-	return 0;
-}
-
-static inline unsigned int
-count_maps(u_int32_t src, u_int32_t dst, u_int16_t protonum,
-	   const struct ip_conntrack *conntrack)
-{
-	struct ip_conntrack *ct;
-	unsigned int score = 0;
-	unsigned int h;
-
-	MUST_BE_READ_LOCKED(&ip_nat_lock);
-	h = hash_by_ipsproto(src, dst, protonum);
-	list_for_each_entry(ct, &byipsproto[h], nat.info.byipsproto)
-		fake_cmp(ct, src, dst, protonum, &score, conntrack);
-
-	return score;
-}
-
 /* For [FUTURE] fragmentation handling, we want the least-used
    src-ip/dst-ip/proto triple.  Fairness doesn't come into it.  Thus
    if the range specifies 1.2.3.4 ports 10000-10005 and 1.2.3.5 ports
@@ -223,10 +190,7 @@
 		    const struct ip_conntrack *conntrack,
 		    unsigned int hooknum)
 {
-	unsigned int best_score = 0xFFFFFFFF;
-	struct ip_conntrack_tuple best_tuple = *tuple;
 	u_int32_t *var_ipp;
-	static unsigned int randomness;
 	/* Host order */
 	u_int32_t minip, maxip, j;
 
@@ -245,33 +209,16 @@
 		return;
 	}
 
+	/* Hashing source and destination IPs gives a fairly even
+	 * spread in practice (if there are a small number of IPs
+	 * involved, there usually aren't that many connections
+	 * anyway).  The consistency means that servers see the same
+	 * client coming from the same IP (some Internet Backing sites
+	 * like this), even across reboots. */
 	minip = ntohl(range->min_ip);
 	maxip = ntohl(range->max_ip);
-
-	/* FIXME: use hash of ips like ipt_SAME, not randomness.
-	   This way same pairs get same IP: think Internet Banking.
-	 */
-	randomness++;
-	for (j = 0; j < maxip - minip + 1; j++) {
-		unsigned int score;
-
-		*var_ipp = htonl(minip + (randomness + j) 
-				 % (maxip - minip + 1));
-
-		/* Count how many others map onto this. */
-		score = count_maps(tuple->src.ip, tuple->dst.ip,
-				   tuple->dst.protonum, conntrack);
-		if (score < best_score) {
-			/* Optimization: doesn't get any better than
-			   this. */
-			if (score == 0)
-				return;
-
-			best_score = score;
-			best_tuple = *tuple;
-		}
-	}
-	*tuple = best_tuple;
+	j = jhash_2words(tuple->src.ip, tuple->dst.ip, 0);
+	*var_ipp = htonl(minip + j % (maxip - minip + 1));
 }
 
 /* Manipulate the tuple into the range given.  For NF_IP_POST_ROUTING,
@@ -472,19 +419,8 @@
 			      .tuple.src,
 			      conntrack->tuplehash[IP_CT_DIR_ORIGINAL]
 			      .tuple.dst.protonum);
-	/* We place packet as seen OUTGOUNG in byips_proto hash
-           (ie. reverse dst and src of reply packet. */
-	unsigned int ipsprotohash
-		= hash_by_ipsproto(conntrack->tuplehash[IP_CT_DIR_REPLY]
-				   .tuple.dst.ip,
-				   conntrack->tuplehash[IP_CT_DIR_REPLY]
-				   .tuple.src.ip,
-				   conntrack->tuplehash[IP_CT_DIR_REPLY]
-				   .tuple.dst.protonum);
-
 	MUST_BE_WRITE_LOCKED(&ip_nat_lock);
 	list_move(&info->bysource, &bysource[srchash]);
-	list_move(&info->byipsproto, &byipsproto[ipsprotohash]);
 }
 
 void place_in_hashes(struct ip_conntrack *conntrack,
@@ -495,19 +431,8 @@
 			      .tuple.src,
 			      conntrack->tuplehash[IP_CT_DIR_ORIGINAL]
 			      .tuple.dst.protonum);
-	/* We place packet as seen OUTGOUNG in byips_proto hash
-           (ie. reverse dst and src of reply packet. */
-	unsigned int ipsprotohash
-		= hash_by_ipsproto(conntrack->tuplehash[IP_CT_DIR_REPLY]
-				   .tuple.dst.ip,
-				   conntrack->tuplehash[IP_CT_DIR_REPLY]
-				   .tuple.src.ip,
-				   conntrack->tuplehash[IP_CT_DIR_REPLY]
-				   .tuple.dst.protonum);
-
 	MUST_BE_WRITE_LOCKED(&ip_nat_lock);
 	list_add(&info->bysource, &bysource[srchash]);
-	list_add(&info->byipsproto, &byipsproto[ipsprotohash]);
 }
 
 /* Returns true if succeeded. */
@@ -785,11 +710,9 @@
 	ip_nat_htable_size = ip_conntrack_htable_size;
 
 	/* One vmalloc for both hash tables */
-	bysource = vmalloc(sizeof(struct list_head) * ip_nat_htable_size*2);
-	if (!bysource) {
+	bysource = vmalloc(sizeof(struct list_head) * ip_nat_htable_size);
+	if (!bysource)
 		return -ENOMEM;
-	}
-	byipsproto = bysource + ip_nat_htable_size;
 
 	/* Sew in builtin protocols. */
 	WRITE_LOCK(&ip_nat_lock);
@@ -802,7 +725,6 @@
 
 	for (i = 0; i < ip_nat_htable_size; i++) {
 		INIT_LIST_HEAD(&bysource[i]);
-		INIT_LIST_HEAD(&byipsproto[i]);
 	}
 
 	/* FIXME: Man, this is a hack.  <SIGH> */
Index: linux-2.6.10-rc2-bk1-Netfilter/include/linux/netfilter_ipv4/ip_nat.h
===================================================================
--- linux-2.6.10-rc2-bk1-Netfilter.orig/include/linux/netfilter_ipv4/ip_nat.h	2004-11-18 14:58:02.105241920 +1100
+++ linux-2.6.10-rc2-bk1-Netfilter/include/linux/netfilter_ipv4/ip_nat.h	2004-11-18 16:14:25.020532896 +1100
@@ -91,7 +91,7 @@
 	/* Manipulations to be done on this conntrack. */
 	struct ip_nat_info_manip manips[IP_NAT_MAX_MANIPS];
 
-	struct list_head bysource, byipsproto;
+	struct list_head bysource;
 
 	/* Helper (NULL if none). */
 	struct ip_nat_helper *helper;

-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
