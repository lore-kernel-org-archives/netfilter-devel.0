From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 4/12]: kill struct ip_nat_hash
Date: Tue, 21 Sep 2004 05:22:16 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <414F9E68.2080101@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090603060805020009090408"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@redhat.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------090603060805020009090408
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

ChangeSet@1.1935.1.4, 2004-09-19 00:05:29+02:00, kaber@coreworks.de
  [NETFILTER]: kill struct ip_nat_hash, saves two pointers per conntrack
 
  The back-pointer is not needed when using list.h macros.
 
  Signed-off-by: Patrick McHardy <kaber@trash.net>



--------------090603060805020009090408
Content-Type: text/x-patch;
 name="04.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="04.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/09/19 00:05:29+02:00 kaber@coreworks.de 
#   [NETFILTER]: kill struct ip_nat_hash, saves two pointers per conntrack
#   
#   The back-pointer is not needed when using list.h macros.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_nat_core.c
#   2004/09/19 00:05:03+02:00 kaber@coreworks.de +27 -46
#   [NETFILTER]: kill struct ip_nat_hash, saves two pointers per conntrack
#   
#   The back-pointer is not needed when using list.h macros.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# include/linux/netfilter_ipv4/ip_nat.h
#   2004/09/19 00:05:03+02:00 kaber@coreworks.de +1 -10
#   [NETFILTER]: kill struct ip_nat_hash, saves two pointers per conntrack
#   
#   The back-pointer is not needed when using list.h macros.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/include/linux/netfilter_ipv4/ip_nat.h b/include/linux/netfilter_ipv4/ip_nat.h
--- a/include/linux/netfilter_ipv4/ip_nat.h	2004-09-20 11:57:31 +02:00
+++ b/include/linux/netfilter_ipv4/ip_nat.h	2004-09-20 11:57:31 +02:00
@@ -80,15 +80,6 @@
 /* Protects NAT hash tables, and NAT-private part of conntracks. */
 DECLARE_RWLOCK_EXTERN(ip_nat_lock);
 
-/* Hashes for by-source and IP/protocol. */
-struct ip_nat_hash
-{
-	struct list_head list;
-
-	/* conntrack we're embedded in: NULL if not in hash. */
-	struct ip_conntrack *conntrack;
-};
-
 /* The structure embedded in the conntrack structure. */
 struct ip_nat_info
 {
@@ -100,7 +91,7 @@
 	/* Manipulations to be done on this conntrack. */
 	struct ip_nat_info_manip manips[IP_NAT_MAX_MANIPS];
 
-	struct ip_nat_hash bysource, byipsproto;
+	struct list_head bysource, byipsproto;
 
 	/* Helper (NULL if none). */
 	struct ip_nat_helper *helper;
diff -Nru a/net/ipv4/netfilter/ip_nat_core.c b/net/ipv4/netfilter/ip_nat_core.c
--- a/net/ipv4/netfilter/ip_nat_core.c	2004-09-20 11:57:31 +02:00
+++ b/net/ipv4/netfilter/ip_nat_core.c	2004-09-20 11:57:31 +02:00
@@ -77,9 +77,6 @@
 	if (!info->initialized)
 		return;
 
-	IP_NF_ASSERT(info->bysource.conntrack);
-	IP_NF_ASSERT(info->byipsproto.conntrack);
-
 	hs = hash_by_src(&conn->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src,
 	                 conn->tuplehash[IP_CT_DIR_ORIGINAL]
 	                 .tuple.dst.protonum);
@@ -90,8 +87,8 @@
 	                      .tuple.dst.protonum);
 
 	WRITE_LOCK(&ip_nat_lock);
-	LIST_DELETE(&bysource[hs], &info->bysource);
-	LIST_DELETE(&byipsproto[hp], &info->byipsproto);
+	list_del(&info->bysource);
+	list_del(&info->byipsproto);
 	WRITE_UNLOCK(&ip_nat_lock);
 }
 
@@ -171,20 +168,18 @@
 }
 
 static inline int
-src_cmp(const struct ip_nat_hash *i,
+src_cmp(const struct ip_conntrack *ct,
 	const struct ip_conntrack_tuple *tuple,
 	const struct ip_nat_multi_range *mr)
 {
-	return (i->conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum
+	return (ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum
 		== tuple->dst.protonum
-		&& i->conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip
+		&& ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip
 		== tuple->src.ip
-		&& i->conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u.all
+		&& ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u.all
 		== tuple->src.u.all
 		&& in_range(tuple,
-			    &i->conntrack->tuplehash[IP_CT_DIR_ORIGINAL]
-			    .tuple.src,
-			    mr));
+			    &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src, mr));
 }
 
 /* Only called for SRC manip */
@@ -193,14 +188,13 @@
 		     const struct ip_nat_multi_range *mr)
 {
 	unsigned int h = hash_by_src(&tuple->src, tuple->dst.protonum);
-	struct ip_nat_hash *i;
+	struct ip_conntrack *ct;
 
 	MUST_BE_READ_LOCKED(&ip_nat_lock);
-	i = LIST_FIND(&bysource[h], src_cmp, struct ip_nat_hash *, tuple, mr);
-	if (i)
-		return &i->conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src;
-	else
-		return NULL;
+	list_for_each_entry(ct, &bysource[h], nat.info.bysource)
+		if (src_cmp(ct, tuple, mr))
+			return &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src;
+	return NULL;
 }
 
 #ifdef CONFIG_IP_NF_NAT_LOCAL
@@ -226,19 +220,17 @@
 #endif
 
 /* Simple way to iterate through all. */
-static inline int fake_cmp(const struct ip_nat_hash *i,
+static inline int fake_cmp(const struct ip_conntrack *ct,
 			   u_int32_t src, u_int32_t dst, u_int16_t protonum,
-			   unsigned int *score,
-			   const struct ip_conntrack *conntrack)
+			   unsigned int *score, const struct ip_conntrack *ct2)
 {
 	/* Compare backwards: we're dealing with OUTGOING tuples, and
            inside the conntrack is the REPLY tuple.  Don't count this
            conntrack. */
-	if (i->conntrack != conntrack
-	    && i->conntrack->tuplehash[IP_CT_DIR_REPLY].tuple.src.ip == dst
-	    && i->conntrack->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip == src
-	    && (i->conntrack->tuplehash[IP_CT_DIR_REPLY].tuple.dst.protonum
-		== protonum))
+	if (ct != ct2
+	    && ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.ip == dst
+	    && ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip == src
+	    && (ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.protonum == protonum))
 		(*score)++;
 	return 0;
 }
@@ -247,13 +239,14 @@
 count_maps(u_int32_t src, u_int32_t dst, u_int16_t protonum,
 	   const struct ip_conntrack *conntrack)
 {
+	struct ip_conntrack *ct;
 	unsigned int score = 0;
 	unsigned int h;
 
 	MUST_BE_READ_LOCKED(&ip_nat_lock);
 	h = hash_by_ipsproto(src, dst, protonum);
-	LIST_FIND(&byipsproto[h], fake_cmp, struct ip_nat_hash *,
-	          src, dst, protonum, &score, conntrack);
+	list_for_each_entry(ct, &byipsproto[h], nat.info.byipsproto)
+		fake_cmp(ct, src, dst, protonum, &score, conntrack);
 
 	return score;
 }
@@ -640,12 +633,10 @@
 	/* It's done. */
 	info->initialized |= (1 << HOOK2MANIP(hooknum));
 
-	if (in_hashes) {
-		IP_NF_ASSERT(info->bysource.conntrack);
+	if (in_hashes)
 		replace_in_hashes(conntrack, info);
-	} else {
+	else
 		place_in_hashes(conntrack, info);
-	}
 
 	return NF_ACCEPT;
 }
@@ -669,14 +660,9 @@
 				   conntrack->tuplehash[IP_CT_DIR_REPLY]
 				   .tuple.dst.protonum);
 
-	IP_NF_ASSERT(info->bysource.conntrack == conntrack);
 	MUST_BE_WRITE_LOCKED(&ip_nat_lock);
-
-	list_del(&info->bysource.list);
-	list_del(&info->byipsproto.list);
-
-	list_prepend(&bysource[srchash], &info->bysource);
-	list_prepend(&byipsproto[ipsprotohash], &info->byipsproto);
+	list_move(&info->bysource, &bysource[srchash]);
+	list_move(&info->byipsproto, &byipsproto[ipsprotohash]);
 }
 
 void place_in_hashes(struct ip_conntrack *conntrack,
@@ -697,14 +683,9 @@
 				   conntrack->tuplehash[IP_CT_DIR_REPLY]
 				   .tuple.dst.protonum);
 
-	IP_NF_ASSERT(!info->bysource.conntrack);
-
 	MUST_BE_WRITE_LOCKED(&ip_nat_lock);
-	info->byipsproto.conntrack = conntrack;
-	info->bysource.conntrack = conntrack;
-
-	list_prepend(&bysource[srchash], &info->bysource);
-	list_prepend(&byipsproto[ipsprotohash], &info->byipsproto);
+	list_add(&info->bysource, &bysource[srchash]);
+	list_add(&info->byipsproto, &byipsproto[ipsprotohash]);
 }
 
 /* Returns true if succeeded. */

--------------090603060805020009090408--
