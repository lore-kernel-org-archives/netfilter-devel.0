From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 6/8] Netfilter:  Remove remaining multirange related code
Date: Tue, 11 Jan 2005 21:22:30 +1100
Message-ID: <1105438950.19331.32.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
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

Name: Remove remaining multirange related code
Status: Tested under nfsim
From: KOVACS Krisztian <hidden@sch.bme.hu>

  Hi Rusty,

Your recent patch which removed the byipsproto hash left some unused
code around. The following patch cleans up that. I'm not sure it's
correct, but please take a look at it.

Index: linux-2.6.10-bk12-Netfilter/net/ipv4/netfilter/ip_nat_core.c
===================================================================
--- linux-2.6.10-bk12-Netfilter.orig/net/ipv4/netfilter/ip_nat_core.c	2005-01-11 14:35:00.327472200 +1100
+++ linux-2.6.10-bk12-Netfilter/net/ipv4/netfilter/ip_nat_core.c	2005-01-11 14:43:43.458944128 +1100
@@ -51,15 +51,7 @@
 struct ip_nat_protocol *ip_nat_protos[MAX_IP_NAT_PROTO];
 

-/* We keep extra hashes for each conntrack, for fast searching. */
-static inline size_t
-hash_by_ipsproto(u_int32_t src, u_int32_t dst, u_int16_t proto)
-{
-	/* Modified src and dst, to ensure we don't create two
-           identical streams. */
-	return (src + dst + proto) % ip_nat_htable_size;
-}
-
+/* We keep an extra hash for each conntrack, for fast searching. */
 static inline size_t
 hash_by_src(const struct ip_conntrack_manip *manip, u_int16_t proto)
 {
@@ -71,7 +63,7 @@
 static void ip_nat_cleanup_conntrack(struct ip_conntrack *conn)
 {
 	struct ip_nat_info *info = &conn->nat.info;
-	unsigned int hs, hp;
+	unsigned int hs;
 
 	if (!info->initialized)
 		return;
@@ -80,11 +72,6 @@
 	                 conn->tuplehash[IP_CT_DIR_ORIGINAL]
 	                 .tuple.dst.protonum);
 
-	hp = hash_by_ipsproto(conn->tuplehash[IP_CT_DIR_REPLY].tuple.src.ip,
-	                      conn->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip,
-	                      conn->tuplehash[IP_CT_DIR_REPLY]
-	                      .tuple.dst.protonum);
-
 	WRITE_LOCK(&ip_nat_lock);
 	list_del(&info->bysource);
 	WRITE_UNLOCK(&ip_nat_lock);
@@ -336,15 +323,13 @@
 	DUMP_TUPLE(&orig_tp);
 	DEBUGP("Range %p: ", mr);
 	for (i = 0; i < mr->rangesize; i++) {
-		DEBUGP("%u:%s%s%s %u.%u.%u.%u - %u.%u.%u.%u %u - %u\n",
+		DEBUGP("%u:%s%s %u.%u.%u.%u - %u.%u.%u.%u %u - %u\n",
 		       i,
 		       (mr->range[i].flags & IP_NAT_RANGE_MAP_IPS)
 		       ? " MAP_IPS" : "",
 		       (mr->range[i].flags
 			& IP_NAT_RANGE_PROTO_SPECIFIED)
 		       ? " PROTO_SPECIFIED" : "",
-		       (mr->range[i].flags & IP_NAT_RANGE_FULL)
-		       ? " FULL" : "",
 		       NIPQUAD(mr->range[i].min_ip),
 		       NIPQUAD(mr->range[i].max_ip),
 		       mr->range[i].min.all,
Index: linux-2.6.10-bk12-Netfilter/include/linux/netfilter_ipv4/ip_nat.h
===================================================================
--- linux-2.6.10-bk12-Netfilter.orig/include/linux/netfilter_ipv4/ip_nat.h	2005-01-11 14:22:04.951347288 +1100
+++ linux-2.6.10-bk12-Netfilter/include/linux/netfilter_ipv4/ip_nat.h	2005-01-11 14:43:43.459943976 +1100
@@ -16,8 +16,6 @@
 
 #define IP_NAT_RANGE_MAP_IPS 1
 #define IP_NAT_RANGE_PROTO_SPECIFIED 2
-/* Used internally by get_unique_tuple(). */
-#define IP_NAT_RANGE_FULL 4
 
 /* NAT sequence number modifications */
 struct ip_nat_seq {
@@ -51,7 +49,7 @@
 };
 
 /* Worst case: local-out manip + 1 post-routing, and reverse dirn. */
-#define IP_NAT_MAX_MANIPS (2*3)
+#define IP_NAT_MAX_MANIPS (2*2)
 
 struct ip_nat_info_manip
 {
