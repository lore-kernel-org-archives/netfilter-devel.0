From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH NF_CONNTRACK 2/9]: unify *_CT_DIR_* in {ip, nf}_conntrack
Date: Tue, 22 Mar 2005 22:44:55 +0900 (JST)
Message-ID: <200503221345.j2MDiuxu013930@toshiba.co.jp>
References: <200503221343.j2MDhHDS012937@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Tue_Mar_22_22:44:55_2005_468)--"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
To: yasuyuki.kozakai@toshiba.co.jp
In-Reply-To: <200503221343.j2MDhHDS012937@toshiba.co.jp>
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

----Next_Part(Tue_Mar_22_22:44:55_2005_468)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Sorry, I'm tired ? :(

From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Date: Tue, 22 Mar 2005 22:43:17 +0900 (JST)

> 
> This patch unifies common enum {ip,nf}_conntrack_dir.
> 
> Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
> 
> -----------------------------------------------------------------
> Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>
> 
> 
> 

----Next_Part(Tue_Mar_22_22:44:55_2005_468)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="02-defs-dir.patch"

diff -Nur linux-2.6.11-nfct-defs-core/include/linux/netfilter/nf_conntrack.h linux-2.6.11-nfct-defs-tuple/include/linux/netfilter/nf_conntrack.h
--- linux-2.6.11-nfct-defs-core/include/linux/netfilter/nf_conntrack.h	2005-03-22 15:55:58.000000000 +0900
+++ linux-2.6.11-nfct-defs-tuple/include/linux/netfilter/nf_conntrack.h	2005-03-22 16:29:10.000000000 +0900
@@ -75,7 +75,7 @@
 
 	/* XXX should I move this to the tail ? - Y.K */
 	/* These are my tuples; original and reply */
-	struct nf_conntrack_tuple_hash tuplehash[NF_CT_DIR_MAX];
+	struct nf_conntrack_tuple_hash tuplehash[IP_CT_DIR_MAX];
 
 	/* Have we seen traffic both ways yet? (bitset) */
 	unsigned long status;
@@ -85,7 +85,7 @@
 
 #ifdef CONFIG_NF_CT_ACCT
 	/* Accounting Information (same cache line as other written members) */
-	struct ip_conntrack_counter counters[NF_CT_DIR_MAX];
+	struct ip_conntrack_counter counters[IP_CT_DIR_MAX];
 #endif
 	/* If we were expected by an expectation, this will be it */
 	struct nf_conn *master;
diff -Nur linux-2.6.11-nfct-defs-core/include/linux/netfilter/nf_conntrack_ftp.h linux-2.6.11-nfct-defs-tuple/include/linux/netfilter/nf_conntrack_ftp.h
--- linux-2.6.11-nfct-defs-core/include/linux/netfilter/nf_conntrack_ftp.h	2005-03-22 15:44:10.000000000 +0900
+++ linux-2.6.11-nfct-defs-tuple/include/linux/netfilter/nf_conntrack_ftp.h	2005-03-22 16:29:10.000000000 +0900
@@ -40,9 +40,9 @@
 /* This structure exists only once per master */
 struct nf_ct_ftp_master {
 	/* Valid seq positions for cmd matching after newline */
-	u_int32_t seq_aft_nl[NF_CT_DIR_MAX][NUM_SEQ_TO_REMEMBER];
+	u_int32_t seq_aft_nl[IP_CT_DIR_MAX][NUM_SEQ_TO_REMEMBER];
 	/* 0 means seq_match_aft_nl not set */
-	int seq_aft_nl_num[NF_CT_DIR_MAX];
+	int seq_aft_nl_num[IP_CT_DIR_MAX];
 };
 
 struct nf_conntrack_expect;
diff -Nur linux-2.6.11-nfct-defs-core/include/linux/netfilter/nf_conntrack_sctp.h linux-2.6.11-nfct-defs-tuple/include/linux/netfilter/nf_conntrack_sctp.h
--- linux-2.6.11-nfct-defs-core/include/linux/netfilter/nf_conntrack_sctp.h	2005-03-22 15:44:10.000000000 +0900
+++ linux-2.6.11-nfct-defs-tuple/include/linux/netfilter/nf_conntrack_sctp.h	2005-03-22 16:29:10.000000000 +0900
@@ -23,8 +23,8 @@
 {
 	enum sctp_conntrack state;
 
-	u_int32_t vtag[NF_CT_DIR_MAX];
-	u_int32_t ttag[NF_CT_DIR_MAX];
+	u_int32_t vtag[IP_CT_DIR_MAX];
+	u_int32_t ttag[IP_CT_DIR_MAX];
 };
 
 #endif /* _NF_CONNTRACK_SCTP_H */
diff -Nur linux-2.6.11-nfct-defs-core/include/linux/netfilter/nf_conntrack_tuple.h linux-2.6.11-nfct-defs-tuple/include/linux/netfilter/nf_conntrack_tuple.h
--- linux-2.6.11-nfct-defs-core/include/linux/netfilter/nf_conntrack_tuple.h	2005-03-22 15:44:10.000000000 +0900
+++ linux-2.6.11-nfct-defs-tuple/include/linux/netfilter/nf_conntrack_tuple.h	2005-03-22 16:29:10.000000000 +0900
@@ -10,6 +10,8 @@
 #ifndef _NF_CONNTRACK_TUPLE_H
 #define _NF_CONNTRACK_TUPLE_H
 
+#include <linux/netfilter/nf_conntrack_tuple_common.h>
+
 /* A `tuple' is a structure containing the information to uniquely
   identify a connection.  ie. if two packets have the same tuple, they
   are in the same connection; if not, they are not.
@@ -108,13 +110,6 @@
 		       sizeof(u_int32_t)*NF_CT_TUPLE_L3SIZE);		\
         } while (0)
 
-enum nf_conntrack_dir
-{
-	NF_CT_DIR_ORIGINAL,
-	NF_CT_DIR_REPLY,
-	NF_CT_DIR_MAX
-};
-
 #ifdef __KERNEL__
 
 #define NF_CT_DUMP_TUPLE(tp)						    \
@@ -123,11 +118,9 @@
 	NIP6(*(struct in6_addr *)(tp)->src.u3.all), ntohs((tp)->src.u.all), \
 	NIP6(*(struct in6_addr *)(tp)->dst.u3.all), ntohs((tp)->dst.u.all))
 
-#define NFCTINFO2DIR(ctinfo) ((ctinfo) >= IP_CT_IS_REPLY ? NF_CT_DIR_REPLY : NF_CT_DIR_ORIGINAL)
-
 /* If we're the first tuple, it's the original dir. */
 #define NF_CT_DIRECTION(h)						\
-	((enum nf_conntrack_dir)(h)->tuple.dst.dir)
+	((enum ip_conntrack_dir)(h)->tuple.dst.dir)
 
 /* Connections have two entries in the hash table: one for each way */
 struct nf_conntrack_tuple_hash
diff -Nur linux-2.6.11-nfct-defs-core/include/linux/netfilter/nf_conntrack_tuple_common.h linux-2.6.11-nfct-defs-tuple/include/linux/netfilter/nf_conntrack_tuple_common.h
--- linux-2.6.11-nfct-defs-core/include/linux/netfilter/nf_conntrack_tuple_common.h	1970-01-01 09:00:00.000000000 +0900
+++ linux-2.6.11-nfct-defs-tuple/include/linux/netfilter/nf_conntrack_tuple_common.h	2005-03-22 16:29:10.000000000 +0900
@@ -0,0 +1,13 @@
+#ifndef _NF_CONNTRACK_TUPLE_COMMON_H
+#define _NF_CONNTRACK_TUPLE_COMMON_H
+
+enum ip_conntrack_dir
+{
+	IP_CT_DIR_ORIGINAL,
+	IP_CT_DIR_REPLY,
+	IP_CT_DIR_MAX
+};
+
+#define CTINFO2DIR(ctinfo) ((ctinfo) >= IP_CT_IS_REPLY ? IP_CT_DIR_REPLY : IP_CT_DIR_ORIGINAL)
+
+#endif /* _NF_CONNTRACK_TUPLE_COMMON_H */
diff -Nur linux-2.6.11-nfct-defs-core/include/linux/netfilter_ipv4/ip_conntrack_tuple.h linux-2.6.11-nfct-defs-tuple/include/linux/netfilter_ipv4/ip_conntrack_tuple.h
--- linux-2.6.11-nfct-defs-core/include/linux/netfilter_ipv4/ip_conntrack_tuple.h	2005-03-22 15:44:10.000000000 +0900
+++ linux-2.6.11-nfct-defs-tuple/include/linux/netfilter_ipv4/ip_conntrack_tuple.h	2005-03-22 16:33:32.000000000 +0900
@@ -1,6 +1,8 @@
 #ifndef _IP_CONNTRACK_TUPLE_H
 #define _IP_CONNTRACK_TUPLE_H
 
+#include <linux/netfilter/nf_conntrack_tuple_common.h>
+
 /* A `tuple' is a structure containing the information to uniquely
   identify a connection.  ie. if two packets have the same tuple, they
   are in the same connection; if not, they are not.
@@ -79,13 +81,6 @@
 		(tuple)->dst.u.all = 0;				\
 	} while (0)
 
-enum ip_conntrack_dir
-{
-	IP_CT_DIR_ORIGINAL,
-	IP_CT_DIR_REPLY,
-	IP_CT_DIR_MAX
-};
-
 #ifdef __KERNEL__
 
 #define DUMP_TUPLE(tp)						\
@@ -94,8 +89,6 @@
        NIPQUAD((tp)->src.ip), ntohs((tp)->src.u.all),		\
        NIPQUAD((tp)->dst.ip), ntohs((tp)->dst.u.all))
 
-#define CTINFO2DIR(ctinfo) ((ctinfo) >= IP_CT_IS_REPLY ? IP_CT_DIR_REPLY : IP_CT_DIR_ORIGINAL)
-
 /* If we're the first tuple, it's the original dir. */
 #define DIRECTION(h) ((enum ip_conntrack_dir)(h)->tuple.dst.dir)
 
diff -Nur linux-2.6.11-nfct-defs-core/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c linux-2.6.11-nfct-defs-tuple/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
--- linux-2.6.11-nfct-defs-core/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c	2005-03-22 15:44:10.000000000 +0900
+++ linux-2.6.11-nfct-defs-tuple/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c	2005-03-22 16:29:10.000000000 +0900
@@ -372,9 +372,9 @@
 		struct nf_conn *ct = tuplehash_to_ctrack(h);
 
 		sin.sin_family = AF_INET;
-		sin.sin_port = ct->tuplehash[NF_CT_DIR_ORIGINAL]
+		sin.sin_port = ct->tuplehash[IP_CT_DIR_ORIGINAL]
 			.tuple.dst.u.tcp.port;
-		sin.sin_addr.s_addr = ct->tuplehash[NF_CT_DIR_ORIGINAL]
+		sin.sin_addr.s_addr = ct->tuplehash[IP_CT_DIR_ORIGINAL]
 			.tuple.dst.u3.ip;
 
 		DEBUGP("SO_ORIGINAL_DST: %u.%u.%u.%u %u\n",
diff -Nur linux-2.6.11-nfct-defs-core/net/ipv4/netfilter/nf_conntrack_proto_icmp.c linux-2.6.11-nfct-defs-tuple/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
--- linux-2.6.11-nfct-defs-core/net/ipv4/netfilter/nf_conntrack_proto_icmp.c	2005-03-22 15:44:10.000000000 +0900
+++ linux-2.6.11-nfct-defs-tuple/net/ipv4/netfilter/nf_conntrack_proto_icmp.c	2005-03-22 16:29:10.000000000 +0900
@@ -103,7 +103,7 @@
            won't actually vanish as we still have skb, and del_timer
            means this will only run once even if count hits zero twice
            (theoretically possible with SMP) */
-	if (NFCTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY) {
+	if (CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY) {
 		if (atomic_dec_and_test(&ct->proto.icmp.count)
 		    && del_timer(&ct->timeout))
 			ct->timeout.function((unsigned long)ct);
diff -Nur linux-2.6.11-nfct-defs-core/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c linux-2.6.11-nfct-defs-tuple/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
--- linux-2.6.11-nfct-defs-core/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c	2005-03-22 15:44:10.000000000 +0900
+++ linux-2.6.11-nfct-defs-tuple/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c	2005-03-22 16:29:10.000000000 +0900
@@ -444,10 +444,10 @@
 		memset(&sin, 0, sizeof(sin));
 
 		sin.sin6_family = AF_INET6;
-		sin.sin6_port = ct->tuplehash[NF_CT_DIR_ORIGINAL]
+		sin.sin6_port = ct->tuplehash[IP_CT_DIR_ORIGINAL]
 				.tuple.dst.u.tcp.port;
 		ipv6_addr_copy(&sin.sin6_addr,
-			       (struct in6_addr *)ct->tuplehash[NF_CT_DIR_ORIGINAL].tuple.dst.u3.ip6);
+			       (struct in6_addr *)ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.u3.ip6);
 		/* FIXME: sin6_scope_id */
 
 		DEBUGP("IPV6 ORIGINAL_DST: %x:%x:%x:%x:%x:%x:%x:%x %u\n",
diff -Nur linux-2.6.11-nfct-defs-core/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c linux-2.6.11-nfct-defs-tuple/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
--- linux-2.6.11-nfct-defs-core/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c	2005-03-22 15:44:10.000000000 +0900
+++ linux-2.6.11-nfct-defs-tuple/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c	2005-03-22 16:29:10.000000000 +0900
@@ -106,7 +106,7 @@
            won't actually vanish as we still have skb, and del_timer
            means this will only run once even if count hits zero twice
            (theoretically possible with SMP) */
-	if (NFCTINFO2DIR(ctinfo) == NF_CT_DIR_REPLY) {
+	if (CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY) {
 		if (atomic_dec_and_test(&ct->proto.icmp.count)
 		    && del_timer(&ct->timeout))
 			ct->timeout.function((unsigned long)ct);
@@ -207,7 +207,7 @@
 		DEBUGP("icmpv6_error: no match\n");
 		return NF_ACCEPT;
 	} else {
-		if (NF_CT_DIRECTION(h) == NF_CT_DIR_REPLY)
+		if (NF_CT_DIRECTION(h) == IP_CT_DIR_REPLY)
 			*ctinfo += IP_CT_IS_REPLY;
 	}
 
diff -Nur linux-2.6.11-nfct-defs-core/net/netfilter/nf_conntrack_core.c linux-2.6.11-nfct-defs-tuple/net/netfilter/nf_conntrack_core.c
--- linux-2.6.11-nfct-defs-core/net/netfilter/nf_conntrack_core.c	2005-03-22 15:44:10.000000000 +0900
+++ linux-2.6.11-nfct-defs-tuple/net/netfilter/nf_conntrack_core.c	2005-03-22 16:29:10.000000000 +0900
@@ -339,7 +339,7 @@
 		return 0;
 
 	tuple->dst.protonum = protonum;
-	tuple->dst.dir = NF_CT_DIR_ORIGINAL;
+	tuple->dst.dir = IP_CT_DIR_ORIGINAL;
 
 	return protocol->pkt_to_tuple(skb, dataoff, tuple);
 }
@@ -437,10 +437,10 @@
 	DEBUGP("clean_from_lists(%p)\n", ct);
 	MUST_BE_WRITE_LOCKED(&nf_conntrack_lock);
 
-	ho = hash_conntrack(&ct->tuplehash[NF_CT_DIR_ORIGINAL].tuple);
-	hr = hash_conntrack(&ct->tuplehash[NF_CT_DIR_REPLY].tuple);
-	LIST_DELETE(&nf_conntrack_hash[ho], &ct->tuplehash[NF_CT_DIR_ORIGINAL]);
-	LIST_DELETE(&nf_conntrack_hash[hr], &ct->tuplehash[NF_CT_DIR_REPLY]);
+	ho = hash_conntrack(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
+	hr = hash_conntrack(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
+	LIST_DELETE(&nf_conntrack_hash[ho], &ct->tuplehash[IP_CT_DIR_ORIGINAL]);
+	LIST_DELETE(&nf_conntrack_hash[hr], &ct->tuplehash[IP_CT_DIR_REPLY]);
 
 	/* Destroy all pending expectations */
 	remove_expectations(ct);
@@ -460,12 +460,12 @@
 	/* To make sure we don't get any weird locking issues here:
 	 * destroy_conntrack() MUST NOT be called with a write lock
 	 * to nf_conntrack_lock!!! -HW */
-	l3proto = nf_ct_find_l3proto(ct->tuplehash[NF_CT_DIR_REPLY].tuple.src.l3num);
+	l3proto = nf_ct_find_l3proto(ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.l3num);
 	if (l3proto && l3proto->destroy)
 		l3proto->destroy(ct);
 
-	proto = nf_ct_find_proto(ct->tuplehash[NF_CT_DIR_REPLY].tuple.src.l3num,
-				 ct->tuplehash[NF_CT_DIR_REPLY].tuple.dst.protonum);
+	proto = nf_ct_find_proto(ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.l3num,
+				 ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.protonum);
 	if (proto && proto->destroy)
 		proto->destroy(ct);
 
@@ -481,8 +481,8 @@
 
 	/* We overload first tuple to link into unconfirmed list. */
 	if (!is_confirmed(ct)) {
-		BUG_ON(list_empty(&ct->tuplehash[NF_CT_DIR_ORIGINAL].list));
-		list_del(&ct->tuplehash[NF_CT_DIR_ORIGINAL].list);
+		BUG_ON(list_empty(&ct->tuplehash[IP_CT_DIR_ORIGINAL].list));
+		list_del(&ct->tuplehash[IP_CT_DIR_ORIGINAL].list);
 	}
 
 	NF_CT_STAT_INC(delete);
@@ -568,11 +568,11 @@
 	   ICMP/TCP RST packets in other direction.  Actual packet
 	   which created connection will be IP_CT_NEW or for an
 	   expected connection, IP_CT_RELATED. */
-	if (NFCTINFO2DIR(ctinfo) != NF_CT_DIR_ORIGINAL)
+	if (CTINFO2DIR(ctinfo) != IP_CT_DIR_ORIGINAL)
 		return NF_ACCEPT;
 
-	hash = hash_conntrack(&ct->tuplehash[NF_CT_DIR_ORIGINAL].tuple);
-	repl_hash = hash_conntrack(&ct->tuplehash[NF_CT_DIR_REPLY].tuple);
+	hash = hash_conntrack(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
+	repl_hash = hash_conntrack(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
 
 	/* We're not in hash table, and we refuse to set up related
 	   connections for unconfirmed conns.  But packet copies and
@@ -592,18 +592,18 @@
 	if (!LIST_FIND(&nf_conntrack_hash[hash],
 		       conntrack_tuple_cmp,
 		       struct nf_conntrack_tuple_hash *,
-		       &ct->tuplehash[NF_CT_DIR_ORIGINAL].tuple, NULL)
+		       &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple, NULL)
 	    && !LIST_FIND(&nf_conntrack_hash[repl_hash],
 			  conntrack_tuple_cmp,
 			  struct nf_conntrack_tuple_hash *,
-			  &ct->tuplehash[NF_CT_DIR_REPLY].tuple, NULL)) {
+			  &ct->tuplehash[IP_CT_DIR_REPLY].tuple, NULL)) {
 		/* Remove from unconfirmed list */
-		list_del(&ct->tuplehash[NF_CT_DIR_ORIGINAL].list);
+		list_del(&ct->tuplehash[IP_CT_DIR_ORIGINAL].list);
 
 		list_prepend(&nf_conntrack_hash[hash],
-			     &ct->tuplehash[NF_CT_DIR_ORIGINAL]);
+			     &ct->tuplehash[IP_CT_DIR_ORIGINAL]);
 		list_prepend(&nf_conntrack_hash[repl_hash],
-			     &ct->tuplehash[NF_CT_DIR_REPLY]);
+			     &ct->tuplehash[IP_CT_DIR_REPLY]);
 		/* Timer relative to confirmation time, not original
 		   setting time, otherwise we'd get timer wrap in
 		   weird delay cases. */
@@ -741,8 +741,8 @@
 
 	atomic_set(&conntrack->ct_general.use, 1);
 	conntrack->ct_general.destroy = destroy_conntrack;
-	conntrack->tuplehash[NF_CT_DIR_ORIGINAL].tuple = *tuple;
-	conntrack->tuplehash[NF_CT_DIR_REPLY].tuple = repl_tuple;
+	conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple = *tuple;
+	conntrack->tuplehash[IP_CT_DIR_REPLY].tuple = repl_tuple;
 	if (!protocol->new(conntrack, skb, dataoff)) {
 		free_conntrack(conntrack);
 		DEBUGP("init conntrack: can't track with proto module\n");
@@ -774,7 +774,7 @@
         }
 
 	/* Overload tuple linked list to put us in unconfirmed list. */
-	list_add(&conntrack->tuplehash[NF_CT_DIR_ORIGINAL].list, &unconfirmed);
+	list_add(&conntrack->tuplehash[IP_CT_DIR_ORIGINAL].list, &unconfirmed);
 
 	atomic_inc(&nf_conntrack_count);
 	WRITE_UNLOCK(&nf_conntrack_lock);
@@ -785,7 +785,7 @@
 		destroy_expect(exp);
 	}
 
-	return &conntrack->tuplehash[NF_CT_DIR_ORIGINAL];
+	return &conntrack->tuplehash[IP_CT_DIR_ORIGINAL];
 }
 
 /* On success, returns conntrack ptr, sets skb->nfct and ctinfo */
@@ -822,7 +822,7 @@
 	ct = tuplehash_to_ctrack(h);
 
 	/* It exists; we have (non-exclusive) reference. */
-	if (NF_CT_DIRECTION(h) == NF_CT_DIR_REPLY) {
+	if (NF_CT_DIRECTION(h) == IP_CT_DIR_REPLY) {
 		*ctinfo = IP_CT_ESTABLISHED + IP_CT_IS_REPLY;
 		/* Please set reply bit if this packet OK */
 		*set_reply = 1;
@@ -1088,7 +1088,7 @@
 	DEBUGP("Altering reply tuple of %p to ", conntrack);
 	NF_CT_DUMP_TUPLE(newreply);
 
-	conntrack->tuplehash[NF_CT_DIR_REPLY].tuple = *newreply;
+	conntrack->tuplehash[IP_CT_DIR_REPLY].tuple = *newreply;
 	if (!conntrack->master && conntrack->expecting == 0)
 		conntrack->helper = nf_ct_find_helper(newreply);
 	WRITE_UNLOCK(&nf_conntrack_lock);
@@ -1157,9 +1157,9 @@
 {
 #ifdef CONFIG_NF_CT_ACCT
 	if (skb) {
-		ct->counters[NFCTINFO2DIR(ctinfo)].packets++;
+		ct->counters[CTINFO2DIR(ctinfo)].packets++;
 		/* XXX totlen should be used ? - YK */
-		ct->counters[NFCTINFO2DIR(ctinfo)].bytes +=
+		ct->counters[CTINFO2DIR(ctinfo)].bytes +=
 			ntohs(skb->len - (unsigned int)(skb->nh.raw
 							- skb->data));
 	}
@@ -1198,7 +1198,7 @@
 
 	/* This ICMP is in reverse direction to the packet which caused it */
 	ct = nf_ct_get(skb, &ctinfo);
-	if (NFCTINFO2DIR(ctinfo) == NF_CT_DIR_ORIGINAL)
+	if (CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL)
 		ctinfo = IP_CT_RELATED + IP_CT_IS_REPLY;
 	else
 		ctinfo = IP_CT_RELATED;
diff -Nur linux-2.6.11-nfct-defs-core/net/netfilter/nf_conntrack_ftp.c linux-2.6.11-nfct-defs-tuple/net/netfilter/nf_conntrack_ftp.c
--- linux-2.6.11-nfct-defs-core/net/netfilter/nf_conntrack_ftp.c	2005-03-22 15:44:10.000000000 +0900
+++ linux-2.6.11-nfct-defs-tuple/net/netfilter/nf_conntrack_ftp.c	2005-03-22 16:29:10.000000000 +0900
@@ -68,7 +68,7 @@
 			     char);
 
 static struct ftp_search {
-	enum nf_conntrack_dir dir;
+	enum ip_conntrack_dir dir;
 	const char *pattern;
 	size_t plen;
 	char skip;
@@ -77,25 +77,25 @@
 	int (*getnum)(const char *, size_t, struct nf_conntrack_man *, char);
 } search[] = {
 	{
-		NF_CT_DIR_ORIGINAL,
+		IP_CT_DIR_ORIGINAL,
 		"PORT", sizeof("PORT") - 1, ' ', '\r',
 		NF_CT_FTP_PORT,
 		try_rfc959,
 	},
 	{
-		NF_CT_DIR_REPLY,
+		IP_CT_DIR_REPLY,
 		"227 ", sizeof("227 ") - 1, '(', ')',
 		NF_CT_FTP_PASV,
 		try_rfc959,
 	},
 	{
-		NF_CT_DIR_ORIGINAL,
+		IP_CT_DIR_ORIGINAL,
 		"EPRT", sizeof("EPRT") - 1, ' ', '\r',
 		NF_CT_FTP_EPRT,
 		try_eprt,
 	},
 	{
-		NF_CT_DIR_REPLY,
+		IP_CT_DIR_REPLY,
 		"229 ", sizeof("229 ") - 1, '(', ')',
 		NF_CT_FTP_EPSV,
 		try_epsv_response,
@@ -435,7 +435,7 @@
 	char *fb_ptr;
 	int ret;
 	u32 seq;
-	int dir = NFCTINFO2DIR(ctinfo);
+	int dir = CTINFO2DIR(ctinfo);
 	unsigned int matchlen, matchoff;
 	struct nf_ct_ftp_master *ct_ftp_info = &ct->help->ct_ftp_info;
 	struct nf_conntrack_expect *exp;
diff -Nur linux-2.6.11-nfct-defs-core/net/netfilter/nf_conntrack_proto_sctp.c linux-2.6.11-nfct-defs-tuple/net/netfilter/nf_conntrack_proto_sctp.c
--- linux-2.6.11-nfct-defs-core/net/netfilter/nf_conntrack_proto_sctp.c	2005-03-22 15:44:10.000000000 +0900
+++ linux-2.6.11-nfct-defs-tuple/net/netfilter/nf_conntrack_proto_sctp.c	2005-03-22 16:29:10.000000000 +0900
@@ -260,7 +260,7 @@
 	return 0;
 }
 
-static int new_state(enum nf_conntrack_dir dir,
+static int new_state(enum ip_conntrack_dir dir,
 		     enum sctp_conntrack cur_state,
 		     int chunk_type)
 {
@@ -344,7 +344,7 @@
 		&& !test_bit(SCTP_CID_COOKIE_ECHO, (void *)map)
 		&& !test_bit(SCTP_CID_ABORT, (void *)map)
 		&& !test_bit(SCTP_CID_SHUTDOWN_ACK, (void *)map)
-		&& (sh->vtag != conntrack->proto.sctp.vtag[NFCTINFO2DIR(ctinfo)])) {
+		&& (sh->vtag != conntrack->proto.sctp.vtag[CTINFO2DIR(ctinfo)])) {
 		DEBUGP("Verification tag check failed\n");
 		return -1;
 	}
@@ -362,36 +362,36 @@
 			}
 		} else if (sch->type == SCTP_CID_ABORT) {
 			/* Sec 8.5.1 (B) */
-			if (!(sh->vtag == conntrack->proto.sctp.vtag[NFCTINFO2DIR(ctinfo)])
+			if (!(sh->vtag == conntrack->proto.sctp.vtag[CTINFO2DIR(ctinfo)])
 				&& !(sh->vtag == conntrack->proto.sctp.vtag
-							[1 - NFCTINFO2DIR(ctinfo)])) {
+							[1 - CTINFO2DIR(ctinfo)])) {
 				WRITE_UNLOCK(&sctp_lock);
 				return -1;
 			}
 		} else if (sch->type == SCTP_CID_SHUTDOWN_COMPLETE) {
 			/* Sec 8.5.1 (C) */
-			if (!(sh->vtag == conntrack->proto.sctp.vtag[NFCTINFO2DIR(ctinfo)])
+			if (!(sh->vtag == conntrack->proto.sctp.vtag[CTINFO2DIR(ctinfo)])
 				&& !(sh->vtag == conntrack->proto.sctp.vtag
-							[1 - NFCTINFO2DIR(ctinfo)] 
+							[1 - CTINFO2DIR(ctinfo)] 
 					&& (sch->flags & 1))) {
 				WRITE_UNLOCK(&sctp_lock);
 				return -1;
 			}
 		} else if (sch->type == SCTP_CID_COOKIE_ECHO) {
 			/* Sec 8.5.1 (D) */
-			if (!(sh->vtag == conntrack->proto.sctp.vtag[NFCTINFO2DIR(ctinfo)])) {
+			if (!(sh->vtag == conntrack->proto.sctp.vtag[CTINFO2DIR(ctinfo)])) {
 				WRITE_UNLOCK(&sctp_lock);
 				return -1;
 			}
 		}
 
 		oldsctpstate = conntrack->proto.sctp.state;
-		newconntrack = new_state(NFCTINFO2DIR(ctinfo), oldsctpstate, sch->type);
+		newconntrack = new_state(CTINFO2DIR(ctinfo), oldsctpstate, sch->type);
 
 		/* Invalid */
 		if (newconntrack == SCTP_CONNTRACK_MAX) {
 			DEBUGP("nf_conntrack_sctp: Invalid dir=%i ctype=%u conntrack=%u\n",
-			       NFCTINFO2DIR(ctinfo), sch->type, oldsctpstate);
+			       CTINFO2DIR(ctinfo), sch->type, oldsctpstate);
 			WRITE_UNLOCK(&sctp_lock);
 			return -1;
 		}
@@ -408,8 +408,8 @@
 					return -1;
 			}
 			DEBUGP("Setting vtag %x for dir %d\n", 
-					ih->init_tag, !NFCTINFO2DIR(ctinfo));
-			conntrack->proto.sctp.vtag[!NFCTINFO2DIR(ctinfo)] = ih->init_tag;
+					ih->init_tag, !CTINFO2DIR(ctinfo));
+			conntrack->proto.sctp.vtag[!CTINFO2DIR(ctinfo)] = ih->init_tag;
 		}
 
 		conntrack->proto.sctp.state = newconntrack;
@@ -419,7 +419,7 @@
 	nf_ct_refresh_acct(conntrack, ctinfo, skb, *sctp_timeouts[newconntrack]);
 
 	if (oldsctpstate == SCTP_CONNTRACK_COOKIE_ECHOED
-		&& NFCTINFO2DIR(ctinfo) == NF_CT_DIR_REPLY
+		&& CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY
 		&& newconntrack == SCTP_CONNTRACK_ESTABLISHED) {
 		DEBUGP("Setting assured bit\n");
 		set_bit(IPS_ASSURED_BIT, &conntrack->status);
@@ -458,7 +458,7 @@
 	newconntrack = SCTP_CONNTRACK_MAX;
 	for_each_sctp_chunk (skb, sch, _sch, offset, dataoff, count) {
 		/* Don't need lock here: this conntrack not in circulation yet */
-		newconntrack = new_state(NF_CT_DIR_ORIGINAL, 
+		newconntrack = new_state(IP_CT_DIR_ORIGINAL, 
 					 SCTP_CONNTRACK_NONE, sch->type);
 
 		/* Invalid: delete conntrack */
@@ -480,7 +480,7 @@
 				DEBUGP("Setting vtag %x for new conn\n", 
 					ih->init_tag);
 
-				conntrack->proto.sctp.vtag[NF_CT_DIR_REPLY] = 
+				conntrack->proto.sctp.vtag[IP_CT_DIR_REPLY] = 
 								ih->init_tag;
 			} else {
 				/* Sec 8.5.1 (A) */
@@ -492,7 +492,7 @@
 		else {
 			DEBUGP("Setting vtag %x for new conn OOTB\n", 
 				sh->vtag);
-			conntrack->proto.sctp.vtag[NF_CT_DIR_REPLY] = sh->vtag;
+			conntrack->proto.sctp.vtag[IP_CT_DIR_REPLY] = sh->vtag;
 		}
 
 		conntrack->proto.sctp.state = newconntrack;
diff -Nur linux-2.6.11-nfct-defs-core/net/netfilter/nf_conntrack_proto_tcp.c linux-2.6.11-nfct-defs-tuple/net/netfilter/nf_conntrack_proto_tcp.c
--- linux-2.6.11-nfct-defs-core/net/netfilter/nf_conntrack_proto_tcp.c	2005-03-22 15:44:10.000000000 +0900
+++ linux-2.6.11-nfct-defs-tuple/net/netfilter/nf_conntrack_proto_tcp.c	2005-03-22 16:29:10.000000000 +0900
@@ -514,7 +514,7 @@
 }
 
 static int tcp_in_window(struct nf_ct_tcp *state, 
-                         enum nf_conntrack_dir dir,
+                         enum ip_conntrack_dir dir,
                          unsigned int *index,
                          const struct sk_buff *skb,
 			 unsigned int dataoff,
@@ -583,9 +583,9 @@
 			sender->td_maxend = end + sender->td_maxwin;
 		}
 	} else if (((state->state == TCP_CONNTRACK_SYN_SENT
-		     && dir == NF_CT_DIR_ORIGINAL)
+		     && dir == IP_CT_DIR_ORIGINAL)
 		   || (state->state == TCP_CONNTRACK_SYN_RECV
-		     && dir == NF_CT_DIR_REPLY))
+		     && dir == IP_CT_DIR_REPLY))
 		   && after(end, sender->td_end)) {
 		/*
 		 * RFC 793: "if a TCP is reinitialized ... then it need
@@ -886,7 +886,7 @@
 		      unsigned int hooknum)
 {
 	enum tcp_conntrack new_state, old_state;
-	enum nf_conntrack_dir dir;
+	enum ip_conntrack_dir dir;
 	struct tcphdr *th, _tcph;
 	unsigned long timeout;
 	unsigned int index;
@@ -896,7 +896,7 @@
 
 	WRITE_LOCK(&tcp_lock);
 	old_state = conntrack->proto.tcp.state;
-	dir = NFCTINFO2DIR(ctinfo);
+	dir = CTINFO2DIR(ctinfo);
 	index = get_conntrack_index(th);
 	new_state = tcp_conntracks[dir][index][old_state];
 
diff -Nur linux-2.6.11-nfct-defs-core/net/netfilter/nf_conntrack_standalone.c linux-2.6.11-nfct-defs-tuple/net/netfilter/nf_conntrack_standalone.c
--- linux-2.6.11-nfct-defs-core/net/netfilter/nf_conntrack_standalone.c	2005-03-22 15:44:10.000000000 +0900
+++ linux-2.6.11-nfct-defs-tuple/net/netfilter/nf_conntrack_standalone.c	2005-03-22 16:29:10.000000000 +0900
@@ -53,7 +53,7 @@
 
 static int kill_l3proto(struct nf_conn *i, void *data)
 {
-	return (i->tuplehash[NF_CT_DIR_ORIGINAL].tuple.src.l3num == 
+	return (i->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num == 
 			((struct nf_conntrack_l3proto *)data)->l3proto);
 }
 
@@ -61,9 +61,9 @@
 {
 	struct nf_conntrack_protocol *proto;
 	proto = (struct nf_conntrack_protocol *)data;
-	return (i->tuplehash[NF_CT_DIR_ORIGINAL].tuple.dst.protonum == 
+	return (i->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum == 
 			proto->proto) &&
-	       (i->tuplehash[NF_CT_DIR_ORIGINAL].tuple.src.l3num ==
+	       (i->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num ==
 			proto->l3proto);
 }
 
@@ -161,21 +161,21 @@
 	if (NF_CT_DIRECTION(hash))
 		return 0;
 
-	l3proto = nf_ct_find_l3proto(conntrack->tuplehash[NF_CT_DIR_ORIGINAL]
+	l3proto = nf_ct_find_l3proto(conntrack->tuplehash[IP_CT_DIR_ORIGINAL]
 				     .tuple.src.l3num);
 
 	NF_CT_ASSERT(l3proto);
-	proto = nf_ct_find_proto(conntrack->tuplehash[NF_CT_DIR_ORIGINAL]
+	proto = nf_ct_find_proto(conntrack->tuplehash[IP_CT_DIR_ORIGINAL]
 				 .tuple.src.l3num,
-				 conntrack->tuplehash[NF_CT_DIR_ORIGINAL]
+				 conntrack->tuplehash[IP_CT_DIR_ORIGINAL]
 				 .tuple.dst.protonum);
 	NF_CT_ASSERT(proto);
 
 	if (seq_printf(s, "%-8s %u %-8s %u %ld ",
 		       l3proto->name,
-		       conntrack->tuplehash[NF_CT_DIR_ORIGINAL].tuple.src.l3num,
+		       conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num,
 		       proto->name,
-		       conntrack->tuplehash[NF_CT_DIR_ORIGINAL].tuple.dst.protonum,
+		       conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum,
 		       timer_pending(&conntrack->timeout)
 		       ? (long)(conntrack->timeout.expires - jiffies)/HZ : 0) != 0)
 		return -ENOSPC;
@@ -186,22 +186,22 @@
 	if (proto->print_conntrack(s, conntrack))
 		return -ENOSPC;
 
-	if (print_tuple(s, &conntrack->tuplehash[NF_CT_DIR_ORIGINAL].tuple,
+	if (print_tuple(s, &conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
 			l3proto, proto))
 		return -ENOSPC;
 
-	if (seq_print_counters(s, &conntrack->counters[NF_CT_DIR_ORIGINAL]))
+	if (seq_print_counters(s, &conntrack->counters[IP_CT_DIR_ORIGINAL]))
 		return -ENOSPC;
 
 	if (!(test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)))
 		if (seq_printf(s, "[UNREPLIED] "))
 			return -ENOSPC;
 
-	if (print_tuple(s, &conntrack->tuplehash[NF_CT_DIR_REPLY].tuple,
+	if (print_tuple(s, &conntrack->tuplehash[IP_CT_DIR_REPLY].tuple,
 			l3proto, proto))
 		return -ENOSPC;
 
-	if (seq_print_counters(s, &conntrack->counters[NF_CT_DIR_REPLY]))
+	if (seq_print_counters(s, &conntrack->counters[IP_CT_DIR_REPLY]))
 		return -ENOSPC;
 
 	if (test_bit(IPS_ASSURED_BIT, &conntrack->status))

----Next_Part(Tue_Mar_22_22:44:55_2005_468)----
