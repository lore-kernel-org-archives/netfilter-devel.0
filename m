From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH NF_CONNTRACK 1/9]: unify common symbols of {ip,nf}_conntrack
Date: Tue, 22 Mar 2005 22:39:09 +0900 (JST)
Message-ID: <200503221339.j2MDdA17010499@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Tue_Mar_22_22:39:09_2005_897)--"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
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

----Next_Part(Tue_Mar_22_22:39:09_2005_897)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


This patch unifies common enums/flags in {ip,nf}_conntrack.h

Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>

Regards,

-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>

----Next_Part(Tue_Mar_22_22:39:09_2005_897)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="01-defs-core.patch"

diff -Nur linux-2.6.11-nfct/include/linux/netfilter/nf_conntrack.h linux-2.6.11-nfct-defs-core/include/linux/netfilter/nf_conntrack.h
--- linux-2.6.11-nfct/include/linux/netfilter/nf_conntrack.h	2005-03-18 01:38:18.000000000 +0900
+++ linux-2.6.11-nfct-defs-core/include/linux/netfilter/nf_conntrack.h	2005-03-22 15:55:58.000000000 +0900
@@ -12,44 +12,7 @@
 #ifndef _NF_CONNTRACK_H
 #define _NF_CONNTRACK_H
 
-enum nf_conntrack_info
-{
-	/* Part of an established connection (either direction). */
-	NF_CT_ESTABLISHED,
-
-	/* Like NEW, but related to an existing connection, or ICMP error
-	   (in either direction). */
-	NF_CT_RELATED,
-
-	/* Started a new connection to track (only
-           NF_CT_DIR_ORIGINAL); may be a retransmission. */
-	NF_CT_NEW,
-
-	/* >= this indicates reply direction */
-	NF_CT_IS_REPLY,
-
-	/* Number of distinct NF_CT types (no NEW in reply dirn). */
-	NF_CT_NUMBER = NF_CT_IS_REPLY * 2 - 1
-};
-
-/* Bitset representing status of connection. */
-enum nf_conntrack_status {
-	/* It's an expected connection: bit 0 set.  This bit never changed */
-	NF_S_EXPECTED_BIT = 0,
-	NF_S_EXPECTED = (1 << NF_S_EXPECTED_BIT),
-
-	/* We've seen packets both ways: bit 1 set.  Can be set, not unset. */
-	NF_S_SEEN_REPLY_BIT = 1,
-	NF_S_SEEN_REPLY = (1 << NF_S_SEEN_REPLY_BIT),
-
-	/* Conntrack should never be early-expired. */
-	NF_S_ASSURED_BIT = 2,
-	NF_S_ASSURED = (1 << NF_S_ASSURED_BIT),
-
-	/* Connection is confirmed: originating packet has left box */
-	NF_S_CONFIRMED_BIT = 3,
-	NF_S_CONFIRMED = (1 << NF_S_CONFIRMED_BIT),
-};
+#include <linux/netfilter/nf_conntrack_common.h>
 
 #ifdef __KERNEL__
 #include <linux/config.h>
@@ -101,12 +64,6 @@
 #define NF_CT_ASSERT(x)
 #endif
 
-struct nf_conntrack_counter
-{
-	u_int64_t packets;
-	u_int64_t bytes;
-};
-
 struct nf_conntrack_helper;
 
 #include <linux/netfilter/ipv4/nf_conntrack_ipv4.h>
@@ -128,7 +85,7 @@
 
 #ifdef CONFIG_NF_CT_ACCT
 	/* Accounting Information (same cache line as other written members) */
-	struct nf_conntrack_counter counters[NF_CT_DIR_MAX];
+	struct ip_conntrack_counter counters[NF_CT_DIR_MAX];
 #endif
 	/* If we were expected by an expectation, this will be it */
 	struct nf_conn *master;
@@ -184,7 +141,7 @@
 	 * expected connection the way the recipient expects. */
 	union nf_conntrack_manip_proto saved_proto;
 	/* Direction relative to the master connection. */
-	enum nf_conntrack_dir dir;
+	enum ip_conntrack_dir dir;
 #endif
 };
 
@@ -211,7 +168,7 @@
 
 /* Return conntrack_info and tuple hash for given skb. */
 static inline struct nf_conn *
-nf_ct_get(struct sk_buff *skb, enum nf_conntrack_info *ctinfo)
+nf_ct_get(struct sk_buff *skb, enum ip_conntrack_info *ctinfo)
 {
 	*ctinfo = skb->nfctinfo;
 	return (struct nf_conn *)skb->nfct;
@@ -228,7 +185,7 @@
 
 /* Refresh conntrack for this many jiffies */
 extern void nf_ct_refresh_acct(struct nf_conn *ct,
-			       enum nf_conntrack_info ctinfo,
+			       enum ip_conntrack_info ctinfo,
 			       const struct sk_buff *skb,
 			       unsigned long extra_jiffies);
 
@@ -248,30 +205,11 @@
 /* It's confirmed if it is, or has been in the hash table. */
 static inline int is_confirmed(struct nf_conn *ct)
 {
-	return test_bit(NF_S_CONFIRMED_BIT, &ct->status);
+	return test_bit(IPS_CONFIRMED_BIT, &ct->status);
 }
 
 extern unsigned int nf_conntrack_htable_size;
 
-struct nf_conntrack_stat
-{
-	unsigned int searched;
-	unsigned int found;
-	unsigned int new;
-	unsigned int invalid;
-	unsigned int ignore;
-	unsigned int delete;
-	unsigned int delete_list;
-	unsigned int insert;
-	unsigned int insert_failed;
-	unsigned int drop;
-	unsigned int early_drop;
-	unsigned int error;
-	unsigned int expect_new;
-	unsigned int expect_create;
-	unsigned int expect_delete;
-};
-
 #define NF_CT_STAT_INC(count) (__get_cpu_var(nf_conntrack_stat).count++)
 
 /* eg. PROVIDES_CONNTRACK(ftp); */
diff -Nur linux-2.6.11-nfct/include/linux/netfilter/nf_conntrack_common.h linux-2.6.11-nfct-defs-core/include/linux/netfilter/nf_conntrack_common.h
--- linux-2.6.11-nfct/include/linux/netfilter/nf_conntrack_common.h	1970-01-01 09:00:00.000000000 +0900
+++ linux-2.6.11-nfct-defs-core/include/linux/netfilter/nf_conntrack_common.h	2005-03-22 15:57:47.000000000 +0900
@@ -0,0 +1,98 @@
+#ifndef _NF_CONNTRACK_COMMON_H
+#define _NF_CONNTRACK_COMMON_H
+/* Connection state tracking for netfilter.  This is separated from,
+   but required by, the NAT layer; it can also be used by an iptables
+   extension. */
+enum ip_conntrack_info
+{
+	/* Part of an established connection (either direction). */
+	IP_CT_ESTABLISHED,
+
+	/* Like NEW, but related to an existing connection, or ICMP error
+	   (in either direction). */
+	IP_CT_RELATED,
+
+	/* Started a new connection to track (only
+           IP_CT_DIR_ORIGINAL); may be a retransmission. */
+	IP_CT_NEW,
+
+	/* >= this indicates reply direction */
+	IP_CT_IS_REPLY,
+
+	/* Number of distinct IP_CT types (no NEW in reply dirn). */
+	IP_CT_NUMBER = IP_CT_IS_REPLY * 2 - 1
+};
+
+/* Bitset representing status of connection. */
+enum ip_conntrack_status {
+	/* It's an expected connection: bit 0 set.  This bit never changed */
+	IPS_EXPECTED_BIT = 0,
+	IPS_EXPECTED = (1 << IPS_EXPECTED_BIT),
+
+	/* We've seen packets both ways: bit 1 set.  Can be set, not unset. */
+	IPS_SEEN_REPLY_BIT = 1,
+	IPS_SEEN_REPLY = (1 << IPS_SEEN_REPLY_BIT),
+
+	/* Conntrack should never be early-expired. */
+	IPS_ASSURED_BIT = 2,
+	IPS_ASSURED = (1 << IPS_ASSURED_BIT),
+
+	/* Connection is confirmed: originating packet has left box */
+	IPS_CONFIRMED_BIT = 3,
+	IPS_CONFIRMED = (1 << IPS_CONFIRMED_BIT),
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
+
+	/* Connection needs TCP sequence adjusted. */
+	IPS_SEQ_ADJUST_BIT = 6,
+	IPS_SEQ_ADJUST = (1 << IPS_SEQ_ADJUST_BIT),
+
+	/* NAT initialization bits. */
+	IPS_SRC_NAT_DONE_BIT = 7,
+	IPS_SRC_NAT_DONE = (1 << IPS_SRC_NAT_DONE_BIT),
+
+	IPS_DST_NAT_DONE_BIT = 8,
+	IPS_DST_NAT_DONE = (1 << IPS_DST_NAT_DONE_BIT),
+
+	/* Both together */
+	IPS_NAT_DONE_MASK = (IPS_DST_NAT_DONE | IPS_SRC_NAT_DONE),
+};
+
+#ifdef __KERNEL__
+struct ip_conntrack_counter
+{
+	u_int64_t packets;
+	u_int64_t bytes;
+};
+
+struct ip_conntrack_stat
+{
+	unsigned int searched;
+	unsigned int found;
+	unsigned int new;
+	unsigned int invalid;
+	unsigned int ignore;
+	unsigned int delete;
+	unsigned int delete_list;
+	unsigned int insert;
+	unsigned int insert_failed;
+	unsigned int drop;
+	unsigned int early_drop;
+	unsigned int error;
+	unsigned int expect_new;
+	unsigned int expect_create;
+	unsigned int expect_delete;
+};
+
+#endif /* __KERNEL__ */
+
+#endif /* _NF_CONNTRACK_COMMON_H */
diff -Nur linux-2.6.11-nfct/include/linux/netfilter/nf_conntrack_ftp.h linux-2.6.11-nfct-defs-core/include/linux/netfilter/nf_conntrack_ftp.h
--- linux-2.6.11-nfct/include/linux/netfilter/nf_conntrack_ftp.h	2005-03-18 00:39:24.000000000 +0900
+++ linux-2.6.11-nfct-defs-core/include/linux/netfilter/nf_conntrack_ftp.h	2005-03-22 15:44:10.000000000 +0900
@@ -50,7 +50,7 @@
 /* For NAT to hook in when we find a packet which describes what other
  * connection we should expect. */
 extern unsigned int (*nf_nat_ftp_hook)(struct sk_buff **pskb,
-				       enum nf_conntrack_info ctinfo,
+				       enum ip_conntrack_info ctinfo,
 				       enum nf_ct_ftp_type type,
 				       unsigned int matchoff,
 				       unsigned int matchlen,
diff -Nur linux-2.6.11-nfct/include/linux/netfilter/nf_conntrack_helper.h linux-2.6.11-nfct-defs-core/include/linux/netfilter/nf_conntrack_helper.h
--- linux-2.6.11-nfct/include/linux/netfilter/nf_conntrack_helper.h	2005-03-18 00:39:24.000000000 +0900
+++ linux-2.6.11-nfct-defs-core/include/linux/netfilter/nf_conntrack_helper.h	2005-03-22 15:44:10.000000000 +0900
@@ -32,7 +32,7 @@
 	int (*help)(struct sk_buff **pskb,
 		    unsigned int protoff,
 		    struct nf_conn *ct,
-		    enum nf_conntrack_info conntrackinfo);
+		    enum ip_conntrack_info conntrackinfo);
 };
 
 extern int nf_conntrack_helper_register(struct nf_conntrack_helper *);
diff -Nur linux-2.6.11-nfct/include/linux/netfilter/nf_conntrack_l3proto.h linux-2.6.11-nfct-defs-core/include/linux/netfilter/nf_conntrack_l3proto.h
--- linux-2.6.11-nfct/include/linux/netfilter/nf_conntrack_l3proto.h	2005-03-18 00:39:24.000000000 +0900
+++ linux-2.6.11-nfct-defs-core/include/linux/netfilter/nf_conntrack_l3proto.h	2005-03-22 15:44:10.000000000 +0900
@@ -49,7 +49,7 @@
 	/* Returns verdict for packet, or -1 for invalid. */
 	int (*packet)(struct nf_conn *conntrack,
 		      const struct sk_buff *skb,
-		      enum nf_conntrack_info ctinfo);
+		      enum ip_conntrack_info ctinfo);
 
 	/*
 	 * Called when a new connection for this protocol found;
diff -Nur linux-2.6.11-nfct/include/linux/netfilter/nf_conntrack_protocol.h linux-2.6.11-nfct-defs-core/include/linux/netfilter/nf_conntrack_protocol.h
--- linux-2.6.11-nfct/include/linux/netfilter/nf_conntrack_protocol.h	2005-03-18 00:39:24.000000000 +0900
+++ linux-2.6.11-nfct-defs-core/include/linux/netfilter/nf_conntrack_protocol.h	2005-03-22 15:44:10.000000000 +0900
@@ -50,7 +50,7 @@
 	int (*packet)(struct nf_conn *conntrack,
 		      const struct sk_buff *skb,
 		      unsigned int dataoff,
-		      enum nf_conntrack_info ctinfo,
+		      enum ip_conntrack_info ctinfo,
 		      int pf,
 		      unsigned int hooknum);
 
@@ -63,7 +63,7 @@
 	void (*destroy)(struct nf_conn *conntrack);
 
 	int (*error)(struct sk_buff *skb, unsigned int dataoff,
-		     enum nf_conntrack_info *ctinfo,
+		     enum ip_conntrack_info *ctinfo,
 		     int pf, unsigned int hooknum);
 
 	/* Module (if any) which this is connected to. */
diff -Nur linux-2.6.11-nfct/include/linux/netfilter/nf_conntrack_tuple.h linux-2.6.11-nfct-defs-core/include/linux/netfilter/nf_conntrack_tuple.h
--- linux-2.6.11-nfct/include/linux/netfilter/nf_conntrack_tuple.h	2005-03-18 00:39:24.000000000 +0900
+++ linux-2.6.11-nfct-defs-core/include/linux/netfilter/nf_conntrack_tuple.h	2005-03-22 15:44:10.000000000 +0900
@@ -123,7 +123,7 @@
 	NIP6(*(struct in6_addr *)(tp)->src.u3.all), ntohs((tp)->src.u.all), \
 	NIP6(*(struct in6_addr *)(tp)->dst.u3.all), ntohs((tp)->dst.u.all))
 
-#define NFCTINFO2DIR(ctinfo) ((ctinfo) >= NF_CT_IS_REPLY ? NF_CT_DIR_REPLY : NF_CT_DIR_ORIGINAL)
+#define NFCTINFO2DIR(ctinfo) ((ctinfo) >= IP_CT_IS_REPLY ? NF_CT_DIR_REPLY : NF_CT_DIR_ORIGINAL)
 
 /* If we're the first tuple, it's the original dir. */
 #define NF_CT_DIRECTION(h)						\
diff -Nur linux-2.6.11-nfct/include/linux/netfilter_ipv4/ip_conntrack.h linux-2.6.11-nfct-defs-core/include/linux/netfilter_ipv4/ip_conntrack.h
--- linux-2.6.11-nfct/include/linux/netfilter_ipv4/ip_conntrack.h	2005-03-22 11:45:55.000000000 +0900
+++ linux-2.6.11-nfct-defs-core/include/linux/netfilter_ipv4/ip_conntrack.h	2005-03-22 15:44:10.000000000 +0900
@@ -1,71 +1,7 @@
 #ifndef _IP_CONNTRACK_H
 #define _IP_CONNTRACK_H
-/* Connection state tracking for netfilter.  This is separated from,
-   but required by, the NAT layer; it can also be used by an iptables
-   extension. */
-enum ip_conntrack_info
-{
-	/* Part of an established connection (either direction). */
-	IP_CT_ESTABLISHED,
-
-	/* Like NEW, but related to an existing connection, or ICMP error
-	   (in either direction). */
-	IP_CT_RELATED,
-
-	/* Started a new connection to track (only
-           IP_CT_DIR_ORIGINAL); may be a retransmission. */
-	IP_CT_NEW,
-
-	/* >= this indicates reply direction */
-	IP_CT_IS_REPLY,
-
-	/* Number of distinct IP_CT types (no NEW in reply dirn). */
-	IP_CT_NUMBER = IP_CT_IS_REPLY * 2 - 1
-};
-
-/* Bitset representing status of connection. */
-enum ip_conntrack_status {
-	/* It's an expected connection: bit 0 set.  This bit never changed */
-	IPS_EXPECTED_BIT = 0,
-	IPS_EXPECTED = (1 << IPS_EXPECTED_BIT),
-
-	/* We've seen packets both ways: bit 1 set.  Can be set, not unset. */
-	IPS_SEEN_REPLY_BIT = 1,
-	IPS_SEEN_REPLY = (1 << IPS_SEEN_REPLY_BIT),
-
-	/* Conntrack should never be early-expired. */
-	IPS_ASSURED_BIT = 2,
-	IPS_ASSURED = (1 << IPS_ASSURED_BIT),
-
-	/* Connection is confirmed: originating packet has left box */
-	IPS_CONFIRMED_BIT = 3,
-	IPS_CONFIRMED = (1 << IPS_CONFIRMED_BIT),
-
-	/* Connection needs src nat in orig dir.  This bit never changed. */
-	IPS_SRC_NAT_BIT = 4,
-	IPS_SRC_NAT = (1 << IPS_SRC_NAT_BIT),
-
-	/* Connection needs dst nat in orig dir.  This bit never changed. */
-	IPS_DST_NAT_BIT = 5,
-	IPS_DST_NAT = (1 << IPS_DST_NAT_BIT),
-
-	/* Both together. */
-	IPS_NAT_MASK = (IPS_DST_NAT | IPS_SRC_NAT),
-
-	/* Connection needs TCP sequence adjusted. */
-	IPS_SEQ_ADJUST_BIT = 6,
-	IPS_SEQ_ADJUST = (1 << IPS_SEQ_ADJUST_BIT),
-
-	/* NAT initialization bits. */
-	IPS_SRC_NAT_DONE_BIT = 7,
-	IPS_SRC_NAT_DONE = (1 << IPS_SRC_NAT_DONE_BIT),
-
-	IPS_DST_NAT_DONE_BIT = 8,
-	IPS_DST_NAT_DONE = (1 << IPS_DST_NAT_DONE_BIT),
 
-	/* Both together */
-	IPS_NAT_DONE_MASK = (IPS_DST_NAT_DONE | IPS_SRC_NAT_DONE),
-};
+#include <linux/netfilter/nf_conntrack_common.h>
 
 #ifdef __KERNEL__
 #include <linux/config.h>
@@ -122,12 +58,6 @@
 #define IP_NF_ASSERT(x)
 #endif
 
-struct ip_conntrack_counter
-{
-	u_int64_t packets;
-	u_int64_t bytes;
-};
-
 struct ip_conntrack_helper;
 
 struct ip_conntrack
@@ -279,25 +209,6 @@
 
 extern unsigned int ip_conntrack_htable_size;
  
-struct ip_conntrack_stat
-{
-	unsigned int searched;
-	unsigned int found;
-	unsigned int new;
-	unsigned int invalid;
-	unsigned int ignore;
-	unsigned int delete;
-	unsigned int delete_list;
-	unsigned int insert;
-	unsigned int insert_failed;
-	unsigned int drop;
-	unsigned int early_drop;
-	unsigned int error;
-	unsigned int expect_new;
-	unsigned int expect_create;
-	unsigned int expect_delete;
-};
-
 #define CONNTRACK_STAT_INC(count) (__get_cpu_var(ip_conntrack_stat).count++)
 
 #ifdef CONFIG_IP_NF_NAT_NEEDED
diff -Nur linux-2.6.11-nfct/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c linux-2.6.11-nfct-defs-core/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
--- linux-2.6.11-nfct/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c	2005-03-18 00:39:24.000000000 +0900
+++ linux-2.6.11-nfct-defs-core/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c	2005-03-22 15:44:10.000000000 +0900
@@ -155,7 +155,7 @@
 				 int (*okfn)(struct sk_buff *))
 {
 	struct nf_conn *ct;
-	enum nf_conntrack_info ctinfo;
+	enum ip_conntrack_info ctinfo;
 
 	/* This is where we call the helper: as the packet goes out. */
 	ct = nf_ct_get(*pskb, &ctinfo);
diff -Nur linux-2.6.11-nfct/net/ipv4/netfilter/nf_conntrack_proto_icmp.c linux-2.6.11-nfct-defs-core/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
--- linux-2.6.11-nfct/net/ipv4/netfilter/nf_conntrack_proto_icmp.c	2005-03-18 00:39:24.000000000 +0900
+++ linux-2.6.11-nfct-defs-core/net/ipv4/netfilter/nf_conntrack_proto_icmp.c	2005-03-22 15:44:10.000000000 +0900
@@ -95,7 +95,7 @@
 static int icmp_packet(struct nf_conn *ct,
 		       const struct sk_buff *skb,
 		       unsigned int dataoff,
-		       enum nf_conntrack_info ctinfo,
+		       enum ip_conntrack_info ctinfo,
 		       int pf,
 		       unsigned int hooknum)
 {
@@ -103,7 +103,7 @@
            won't actually vanish as we still have skb, and del_timer
            means this will only run once even if count hits zero twice
            (theoretically possible with SMP) */
-	if (NFCTINFO2DIR(ctinfo) == NF_CT_DIR_REPLY) {
+	if (NFCTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY) {
 		if (atomic_dec_and_test(&ct->proto.icmp.count)
 		    && del_timer(&ct->timeout))
 			ct->timeout.function((unsigned long)ct);
@@ -141,7 +141,7 @@
 /* Returns conntrack if it dealt with ICMP, and filled in skb fields */
 static int
 icmp_error_message(struct sk_buff *skb,
-                 enum nf_conntrack_info *ctinfo,
+                 enum ip_conntrack_info *ctinfo,
                  unsigned int hooknum)
 {
 	struct nf_conntrack_tuple innertuple, origtuple;
@@ -186,7 +186,7 @@
 		return NF_ACCEPT;
 	}
 
-	*ctinfo = NF_CT_RELATED;
+	*ctinfo = IP_CT_RELATED;
 
 	h = nf_conntrack_find_get(&innertuple, NULL);
 	if (!h) {
@@ -202,11 +202,11 @@
 		}
 
 		/* Reverse direction from that found */
-		if (NF_CT_DIRECTION(h) == NF_CT_DIR_REPLY)
-			*ctinfo += NF_CT_IS_REPLY;
+		if (NF_CT_DIRECTION(h) == IP_CT_DIR_REPLY)
+			*ctinfo += IP_CT_IS_REPLY;
 	} else {
-		if (NF_CT_DIRECTION(h) == NF_CT_DIR_REPLY)
-			*ctinfo += NF_CT_IS_REPLY;
+		if (NF_CT_DIRECTION(h) == IP_CT_DIR_REPLY)
+			*ctinfo += IP_CT_IS_REPLY;
 	}
 
         /* Update skb to refer to this connection */
@@ -218,7 +218,7 @@
 /* Small and modified version of icmp_rcv */
 static int
 icmp_error(struct sk_buff *skb, unsigned int dataoff,
-	   enum nf_conntrack_info *ctinfo, int pf, unsigned int hooknum)
+	   enum ip_conntrack_info *ctinfo, int pf, unsigned int hooknum)
 {
 	struct icmphdr _ih, *icmph;
 
diff -Nur linux-2.6.11-nfct/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c linux-2.6.11-nfct-defs-core/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
--- linux-2.6.11-nfct/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c	2005-03-18 00:39:24.000000000 +0900
+++ linux-2.6.11-nfct-defs-core/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c	2005-03-22 15:44:10.000000000 +0900
@@ -44,7 +44,7 @@
 #define DEBUGP(format, args...)
 #endif
 
-DECLARE_PER_CPU(struct nf_conntrack_stat, nf_conntrack_stat);
+DECLARE_PER_CPU(struct ip_conntrack_stat, nf_conntrack_stat);
 
 static int ipv6_pkt_to_tuple(const struct sk_buff *skb, unsigned int nhoff,
 			     struct nf_conntrack_tuple *tuple)
@@ -183,7 +183,7 @@
 				 int (*okfn)(struct sk_buff *))
 {
 	struct nf_conn *ct;
-	enum nf_conntrack_info ctinfo;
+	enum ip_conntrack_info ctinfo;
 
 	/* This is where we call the helper: as the packet goes out. */
 	ct = nf_ct_get(*pskb, &ctinfo);
diff -Nur linux-2.6.11-nfct/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c linux-2.6.11-nfct-defs-core/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
--- linux-2.6.11-nfct/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c	2005-03-18 00:39:24.000000000 +0900
+++ linux-2.6.11-nfct-defs-core/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c	2005-03-22 15:44:10.000000000 +0900
@@ -98,7 +98,7 @@
 static int icmpv6_packet(struct nf_conn *ct,
 		       const struct sk_buff *skb,
 		       unsigned int dataoff,
-		       enum nf_conntrack_info ctinfo,
+		       enum ip_conntrack_info ctinfo,
 		       int pf,
 		       unsigned int hooknum)
 {
@@ -146,7 +146,7 @@
 static int
 icmpv6_error_message(struct sk_buff *skb,
 		     unsigned int icmp6off,
-		     enum nf_conntrack_info *ctinfo,
+		     enum ip_conntrack_info *ctinfo,
 		     unsigned int hooknum)
 {
 	struct nf_conntrack_tuple intuple, origtuple;
@@ -200,7 +200,7 @@
 		return NF_ACCEPT;
 	}
 
-	*ctinfo = NF_CT_RELATED;
+	*ctinfo = IP_CT_RELATED;
 
 	h = nf_conntrack_find_get(&intuple, NULL);
 	if (!h) {
@@ -208,7 +208,7 @@
 		return NF_ACCEPT;
 	} else {
 		if (NF_CT_DIRECTION(h) == NF_CT_DIR_REPLY)
-			*ctinfo += NF_CT_IS_REPLY;
+			*ctinfo += IP_CT_IS_REPLY;
 	}
 
 	/* Update skb to refer to this connection */
@@ -219,7 +219,7 @@
 
 static int
 icmpv6_error(struct sk_buff *skb, unsigned int dataoff,
-	     enum nf_conntrack_info *ctinfo, int pf, unsigned int hooknum)
+	     enum ip_conntrack_info *ctinfo, int pf, unsigned int hooknum)
 {
 	struct icmp6hdr _ih, *icmp6h;
 
diff -Nur linux-2.6.11-nfct/net/netfilter/nf_conntrack_core.c linux-2.6.11-nfct-defs-core/net/netfilter/nf_conntrack_core.c
--- linux-2.6.11-nfct/net/netfilter/nf_conntrack_core.c	2005-03-18 00:39:24.000000000 +0900
+++ linux-2.6.11-nfct-defs-core/net/netfilter/nf_conntrack_core.c	2005-03-22 15:44:10.000000000 +0900
@@ -81,7 +81,7 @@
 static LIST_HEAD(unconfirmed);
 static int nf_conntrack_vmalloc;
 
-DEFINE_PER_CPU(struct nf_conntrack_stat, nf_conntrack_stat);
+DEFINE_PER_CPU(struct ip_conntrack_stat, nf_conntrack_stat);
 EXPORT_PER_CPU_SYMBOL(nf_conntrack_stat);
 
 /*
@@ -560,14 +560,14 @@
 {
 	unsigned int hash, repl_hash;
 	struct nf_conn *ct;
-	enum nf_conntrack_info ctinfo;
+	enum ip_conntrack_info ctinfo;
 
 	ct = nf_ct_get(*pskb, &ctinfo);
 
 	/* ipt_REJECT uses nf_conntrack_attach to attach related
 	   ICMP/TCP RST packets in other direction.  Actual packet
-	   which created connection will be NF_CT_NEW or for an
-	   expected connection, NF_CT_RELATED. */
+	   which created connection will be IP_CT_NEW or for an
+	   expected connection, IP_CT_RELATED. */
 	if (NFCTINFO2DIR(ctinfo) != NF_CT_DIR_ORIGINAL)
 		return NF_ACCEPT;
 
@@ -610,7 +610,7 @@
 		ct->timeout.expires += jiffies;
 		add_timer(&ct->timeout);
 		atomic_inc(&ct->ct_general.use);
-		set_bit(NF_S_CONFIRMED_BIT, &ct->status);
+		set_bit(IPS_CONFIRMED_BIT, &ct->status);
 		NF_CT_STAT_INC(insert);
 		WRITE_UNLOCK(&nf_conntrack_lock);
 		return NF_ACCEPT;
@@ -640,7 +640,7 @@
    connection.  Too bad: we're in trouble anyway. */
 static inline int unreplied(const struct nf_conntrack_tuple_hash *i)
 {
-	return !(test_bit(NF_S_ASSURED_BIT, &tuplehash_to_ctrack(i)->status));
+	return !(test_bit(IPS_ASSURED_BIT, &tuplehash_to_ctrack(i)->status));
 }
 
 static int early_drop(struct list_head *chain)
@@ -760,7 +760,7 @@
 		DEBUGP("conntrack: expectation arrives ct=%p exp=%p\n",
 			conntrack, exp);
 		/* Welcome, Mr. Bond.  We've been expecting you... */
-		__set_bit(NF_S_EXPECTED_BIT, &conntrack->status);
+		__set_bit(IPS_EXPECTED_BIT, &conntrack->status);
 		conntrack->master = exp->master;
 #if CONFIG_NF_CONNTRACK_MARK
 		conntrack->mark = exp->master->mark;
@@ -797,7 +797,7 @@
 		  struct nf_conntrack_l3proto *l3proto,
 		  struct nf_conntrack_protocol *proto,
 		  int *set_reply,
-		  enum nf_conntrack_info *ctinfo)
+		  enum ip_conntrack_info *ctinfo)
 {
 	struct nf_conntrack_tuple tuple;
 	struct nf_conntrack_tuple_hash *h;
@@ -823,20 +823,20 @@
 
 	/* It exists; we have (non-exclusive) reference. */
 	if (NF_CT_DIRECTION(h) == NF_CT_DIR_REPLY) {
-		*ctinfo = NF_CT_ESTABLISHED + NF_CT_IS_REPLY;
+		*ctinfo = IP_CT_ESTABLISHED + IP_CT_IS_REPLY;
 		/* Please set reply bit if this packet OK */
 		*set_reply = 1;
 	} else {
 		/* Once we've had two way comms, always ESTABLISHED. */
-		if (test_bit(NF_S_SEEN_REPLY_BIT, &ct->status)) {
+		if (test_bit(IPS_SEEN_REPLY_BIT, &ct->status)) {
 			DEBUGP("nf_conntrack_in: normal packet for %p\n", ct);
-			*ctinfo = NF_CT_ESTABLISHED;
-		} else if (test_bit(NF_S_EXPECTED_BIT, &ct->status)) {
+			*ctinfo = IP_CT_ESTABLISHED;
+		} else if (test_bit(IPS_EXPECTED_BIT, &ct->status)) {
 			DEBUGP("nf_conntrack_in: related packet for %p\n", ct);
-			*ctinfo = NF_CT_RELATED;
+			*ctinfo = IP_CT_RELATED;
 		} else {
 			DEBUGP("nf_conntrack_in: new packet for %p\n", ct);
-			*ctinfo = NF_CT_NEW;
+			*ctinfo = IP_CT_NEW;
 		}
 		*set_reply = 0;
 	}
@@ -849,7 +849,7 @@
 nf_conntrack_in(int pf, unsigned int hooknum, struct sk_buff **pskb)
 {
 	struct nf_conn *ct;
-	enum nf_conntrack_info ctinfo;
+	enum ip_conntrack_info ctinfo;
 	struct nf_conntrack_l3proto *l3proto;
 	struct nf_conntrack_protocol *proto;
 	unsigned int dataoff;
@@ -909,7 +909,7 @@
 	}
 
 	if (set_reply)
-		set_bit(NF_S_SEEN_REPLY_BIT, &ct->status);
+		set_bit(IPS_SEEN_REPLY_BIT, &ct->status);
 
 	return ret;
 }
@@ -1152,7 +1152,7 @@
 }
 
 static inline void ct_add_counters(struct nf_conn *ct,
-				   enum nf_conntrack_info ctinfo,
+				   enum ip_conntrack_info ctinfo,
 				   const struct sk_buff *skb)
 {
 #ifdef CONFIG_NF_CT_ACCT
@@ -1168,7 +1168,7 @@
 
 /* Refresh conntrack for this many jiffies and do accounting (if skb != NULL) */
 void nf_ct_refresh_acct(struct nf_conn *ct,
-			enum nf_conntrack_info ctinfo,
+			enum ip_conntrack_info ctinfo,
 			const struct sk_buff *skb,
 			unsigned long extra_jiffies)
 {
@@ -1194,14 +1194,14 @@
 void __nf_conntrack_attach(struct sk_buff *nskb, struct sk_buff *skb)
 {
 	struct nf_conn *ct;
-	enum nf_conntrack_info ctinfo;
+	enum ip_conntrack_info ctinfo;
 
 	/* This ICMP is in reverse direction to the packet which caused it */
 	ct = nf_ct_get(skb, &ctinfo);
 	if (NFCTINFO2DIR(ctinfo) == NF_CT_DIR_ORIGINAL)
-		ctinfo = NF_CT_RELATED + NF_CT_IS_REPLY;
+		ctinfo = IP_CT_RELATED + IP_CT_IS_REPLY;
 	else
-		ctinfo = NF_CT_RELATED;
+		ctinfo = IP_CT_RELATED;
 
 	/* Attach to new skbuff, and increment count */
 	nskb->nfct = &ct->ct_general;
@@ -1377,7 +1377,7 @@
 	    - to never be deleted, not in any hashes */
 	atomic_set(&nf_conntrack_untracked.ct_general.use, 1);
 	/*  - and look it like as a confirmed connection */
-	set_bit(NF_S_CONFIRMED_BIT, &nf_conntrack_untracked.status);
+	set_bit(IPS_CONFIRMED_BIT, &nf_conntrack_untracked.status);
 
 	return ret;
 
diff -Nur linux-2.6.11-nfct/net/netfilter/nf_conntrack_ftp.c linux-2.6.11-nfct-defs-core/net/netfilter/nf_conntrack_ftp.c
--- linux-2.6.11-nfct/net/netfilter/nf_conntrack_ftp.c	2005-03-18 00:39:24.000000000 +0900
+++ linux-2.6.11-nfct-defs-core/net/netfilter/nf_conntrack_ftp.c	2005-03-22 15:44:10.000000000 +0900
@@ -48,7 +48,7 @@
 module_param(loose, int, 0600);
 
 unsigned int (*nf_nat_ftp_hook)(struct sk_buff **pskb,
-				enum nf_conntrack_info ctinfo,
+				enum ip_conntrack_info ctinfo,
 				enum nf_ct_ftp_type type,
 				unsigned int matchoff,
 				unsigned int matchlen,
@@ -428,7 +428,7 @@
 static int help(struct sk_buff **pskb,
 		unsigned int protoff,
 		struct nf_conn *ct,
-		enum nf_conntrack_info ctinfo)
+		enum ip_conntrack_info ctinfo)
 {
 	unsigned int dataoff, datalen;
 	struct tcphdr _tcph, *th;
@@ -445,8 +445,8 @@
 	int found = 0, ends_in_nl;
 
 	/* Until there's been traffic both ways, don't look in packets. */
-	if (ctinfo != NF_CT_ESTABLISHED
-	    && ctinfo != NF_CT_ESTABLISHED+NF_CT_IS_REPLY) {
+	if (ctinfo != IP_CT_ESTABLISHED
+	    && ctinfo != IP_CT_ESTABLISHED+IP_CT_IS_REPLY) {
 		DEBUGP("ftp: Conntrackinfo = %u\n", ctinfo);
 		return NF_ACCEPT;
 	}
diff -Nur linux-2.6.11-nfct/net/netfilter/nf_conntrack_proto_generic.c linux-2.6.11-nfct-defs-core/net/netfilter/nf_conntrack_proto_generic.c
--- linux-2.6.11-nfct/net/netfilter/nf_conntrack_proto_generic.c	2005-03-18 00:39:24.000000000 +0900
+++ linux-2.6.11-nfct-defs-core/net/netfilter/nf_conntrack_proto_generic.c	2005-03-22 15:44:10.000000000 +0900
@@ -56,7 +56,7 @@
 static int packet(struct nf_conn *conntrack,
 		  const struct sk_buff *skb,
 		  unsigned int dataoff,
-		  enum nf_conntrack_info ctinfo,
+		  enum ip_conntrack_info ctinfo,
 		  int pf,
 		  unsigned int hooknum)
 {
diff -Nur linux-2.6.11-nfct/net/netfilter/nf_conntrack_proto_sctp.c linux-2.6.11-nfct-defs-core/net/netfilter/nf_conntrack_proto_sctp.c
--- linux-2.6.11-nfct/net/netfilter/nf_conntrack_proto_sctp.c	2005-03-18 00:39:24.000000000 +0900
+++ linux-2.6.11-nfct-defs-core/net/netfilter/nf_conntrack_proto_sctp.c	2005-03-22 15:44:10.000000000 +0900
@@ -318,7 +318,7 @@
 static int sctp_packet(struct nf_conn *conntrack,
 		       const struct sk_buff *skb,
 		       unsigned int dataoff,
-		       enum nf_conntrack_info ctinfo,
+		       enum ip_conntrack_info ctinfo,
 		       int pf,
 		       unsigned int hooknum)
 {
@@ -422,7 +422,7 @@
 		&& NFCTINFO2DIR(ctinfo) == NF_CT_DIR_REPLY
 		&& newconntrack == SCTP_CONNTRACK_ESTABLISHED) {
 		DEBUGP("Setting assured bit\n");
-		set_bit(NF_S_ASSURED_BIT, &conntrack->status);
+		set_bit(IPS_ASSURED_BIT, &conntrack->status);
 	}
 
 	return NF_ACCEPT;
diff -Nur linux-2.6.11-nfct/net/netfilter/nf_conntrack_proto_tcp.c linux-2.6.11-nfct-defs-core/net/netfilter/nf_conntrack_proto_tcp.c
--- linux-2.6.11-nfct/net/netfilter/nf_conntrack_proto_tcp.c	2005-03-18 00:39:24.000000000 +0900
+++ linux-2.6.11-nfct-defs-core/net/netfilter/nf_conntrack_proto_tcp.c	2005-03-22 15:44:10.000000000 +0900
@@ -788,7 +788,7 @@
 /* Protect conntrack agaist broken packets. Code taken from ipt_unclean.c.  */
 static int tcp_error(struct sk_buff *skb,
 		     unsigned int dataoff,
-		     enum nf_conntrack_info *ctinfo,
+		     enum ip_conntrack_info *ctinfo,
 		     int pf,
 		     unsigned int hooknum,
 		     int(*csum)(const struct sk_buff *,unsigned int))
@@ -861,7 +861,7 @@
 
 static int tcp_error4(struct sk_buff *skb,
 		      unsigned int dataoff,
-		      enum nf_conntrack_info *ctinfo,
+		      enum ip_conntrack_info *ctinfo,
 		      int pf,
 		      unsigned int hooknum)
 {
@@ -870,7 +870,7 @@
 
 static int tcp_error6(struct sk_buff *skb,
 		      unsigned int dataoff,
-		      enum nf_conntrack_info *ctinfo,
+		      enum ip_conntrack_info *ctinfo,
 		      int pf,
 		      unsigned int hooknum)
 {
@@ -881,7 +881,7 @@
 static int tcp_packet(struct nf_conn *conntrack,
 		      const struct sk_buff *skb,
 		      unsigned int dataoff,
-		      enum nf_conntrack_info ctinfo,
+		      enum ip_conntrack_info ctinfo,
 		      int pf,
 		      unsigned int hooknum)
 {
@@ -958,9 +958,9 @@
 		break;
 	case TCP_CONNTRACK_CLOSE:
 		if (index == TCP_RST_SET
-		    && ((test_bit(NF_S_SEEN_REPLY_BIT, &conntrack->status)
+		    && ((test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)
 		         && conntrack->proto.tcp.last_index <= TCP_SYNACK_SET)
-			|| (!test_bit(NF_S_ASSURED_BIT, &conntrack->status)
+			|| (!test_bit(IPS_ASSURED_BIT, &conntrack->status)
 			 && conntrack->proto.tcp.last_index == TCP_ACK_SET))
 		    && after(ntohl(th->ack_seq),
 		    	     conntrack->proto.tcp.last_seq)) {
@@ -1003,7 +1003,7 @@
 		  ? nf_ct_tcp_timeout_max_retrans : *tcp_timeouts[new_state];
 	WRITE_UNLOCK(&tcp_lock);
 
-	if (!test_bit(NF_S_SEEN_REPLY_BIT, &conntrack->status)) {
+	if (!test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)) {
 		/* If only reply is a RST, we can consider ourselves not to
 		   have an established connection: this is a fairly common
 		   problem case, so we can delete the conntrack
@@ -1014,14 +1014,14 @@
 							    conntrack);
 			return NF_ACCEPT;
 		}
-	} else if (!test_bit(NF_S_ASSURED_BIT, &conntrack->status)
+	} else if (!test_bit(IPS_ASSURED_BIT, &conntrack->status)
 		   && (old_state == TCP_CONNTRACK_SYN_RECV
 		       || old_state == TCP_CONNTRACK_ESTABLISHED)
 		   && new_state == TCP_CONNTRACK_ESTABLISHED) {
 		/* Set ASSURED if we see see valid ack in ESTABLISHED 
 		   after SYN_RECV or a valid answer for a picked up 
 		   connection. */
-			set_bit(NF_S_ASSURED_BIT, &conntrack->status);
+			set_bit(IPS_ASSURED_BIT, &conntrack->status);
 	}
 	nf_ct_refresh_acct(conntrack, ctinfo, skb, timeout);
 
diff -Nur linux-2.6.11-nfct/net/netfilter/nf_conntrack_proto_udp.c linux-2.6.11-nfct-defs-core/net/netfilter/nf_conntrack_proto_udp.c
--- linux-2.6.11-nfct/net/netfilter/nf_conntrack_proto_udp.c	2005-03-18 00:39:24.000000000 +0900
+++ linux-2.6.11-nfct-defs-core/net/netfilter/nf_conntrack_proto_udp.c	2005-03-22 15:44:10.000000000 +0900
@@ -73,17 +73,17 @@
 static int udp_packet(struct nf_conn *conntrack,
 		      const struct sk_buff *skb,
 		      unsigned int dataoff,
-		      enum nf_conntrack_info ctinfo,
+		      enum ip_conntrack_info ctinfo,
 		      int pf,
 		      unsigned int hooknum)
 {
 	/* If we've seen traffic both ways, this is some kind of UDP
 	   stream.  Extend timeout. */
-	if (test_bit(NF_S_SEEN_REPLY_BIT, &conntrack->status)) {
+	if (test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)) {
 		nf_ct_refresh_acct(conntrack, ctinfo, skb,
 				   nf_ct_udp_timeout_stream);
 		/* Also, more likely to be important, and not a probe */
-		set_bit(NF_S_ASSURED_BIT, &conntrack->status);
+		set_bit(IPS_ASSURED_BIT, &conntrack->status);
 	} else
 		nf_ct_refresh_acct(conntrack, ctinfo, skb, nf_ct_udp_timeout);
 
@@ -98,7 +98,7 @@
 }
 
 static int udp_error(struct sk_buff *skb, unsigned int dataoff,
-		     enum nf_conntrack_info *ctinfo,
+		     enum ip_conntrack_info *ctinfo,
 		     int pf,
 		     unsigned int hooknum,
 		     int (*csum)(const struct sk_buff *, unsigned int))
@@ -164,7 +164,7 @@
 
 static int udp_error4(struct sk_buff *skb,
 		      unsigned int dataoff,
-		      enum nf_conntrack_info *ctinfo,
+		      enum ip_conntrack_info *ctinfo,
 		      int pf,
 		      unsigned int hooknum)
 {
@@ -173,7 +173,7 @@
 
 static int udp_error6(struct sk_buff *skb,
 		      unsigned int dataoff,
-		      enum nf_conntrack_info *ctinfo,
+		      enum ip_conntrack_info *ctinfo,
 		      int pf,
 		      unsigned int hooknum)
 {
diff -Nur linux-2.6.11-nfct/net/netfilter/nf_conntrack_standalone.c linux-2.6.11-nfct-defs-core/net/netfilter/nf_conntrack_standalone.c
--- linux-2.6.11-nfct/net/netfilter/nf_conntrack_standalone.c	2005-03-18 00:39:24.000000000 +0900
+++ linux-2.6.11-nfct-defs-core/net/netfilter/nf_conntrack_standalone.c	2005-03-22 15:44:10.000000000 +0900
@@ -49,7 +49,7 @@
 MODULE_LICENSE("GPL");
 
 extern atomic_t nf_conntrack_count;
-DECLARE_PER_CPU(struct nf_conntrack_stat, nf_conntrack_stat);
+DECLARE_PER_CPU(struct ip_conntrack_stat, nf_conntrack_stat);
 
 static int kill_l3proto(struct nf_conn *i, void *data)
 {
@@ -79,7 +79,7 @@
 #ifdef CONFIG_NF_CT_ACCT
 static unsigned int
 seq_print_counters(struct seq_file *s,
-		   const struct nf_conntrack_counter *counter)
+		   const struct ip_conntrack_counter *counter)
 {
 	return seq_printf(s, "packets=%llu bytes=%llu ",
 			  (unsigned long long)counter->packets,
@@ -193,7 +193,7 @@
 	if (seq_print_counters(s, &conntrack->counters[NF_CT_DIR_ORIGINAL]))
 		return -ENOSPC;
 
-	if (!(test_bit(NF_S_SEEN_REPLY_BIT, &conntrack->status)))
+	if (!(test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)))
 		if (seq_printf(s, "[UNREPLIED] "))
 			return -ENOSPC;
 
@@ -204,7 +204,7 @@
 	if (seq_print_counters(s, &conntrack->counters[NF_CT_DIR_REPLY]))
 		return -ENOSPC;
 
-	if (test_bit(NF_S_ASSURED_BIT, &conntrack->status))
+	if (test_bit(IPS_ASSURED_BIT, &conntrack->status))
 		if (seq_printf(s, "[ASSURED] "))
 			return -ENOSPC;
 
@@ -370,7 +370,7 @@
 static int ct_cpu_seq_show(struct seq_file *seq, void *v)
 {
 	unsigned int nr_conntracks = atomic_read(&nf_conntrack_count);
-	struct nf_conntrack_stat *st = v;
+	struct ip_conntrack_stat *st = v;
 
 	if (v == SEQ_START_TOKEN) {
 		seq_printf(seq, "entries  searched found new invalid ignore delete delete_list insert insert_failed drop early_drop icmp_error  expect_new expect_create expect_delete\n");

----Next_Part(Tue_Mar_22_22:39:09_2005_897)----
