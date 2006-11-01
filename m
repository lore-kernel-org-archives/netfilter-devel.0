From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: [PATCH 06/11] Rename struct nf_conntrack_protocol
Date: Wed, 01 Nov 2006 22:08:51 +0100
Message-ID: <20061101210913.910411244@wlug.westbo.se>
References: <20061101210845.337590368@wlug.westbo.se>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline; filename=nf_conntrack-l4proto
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

Rename 'struct nf_conntrack_protocol' to 'struct nf_conntrack_l4proto' in order
to help distinguish it from 'struct nf_conntrack_l3proto'. It gets rather
confusing with 'nf_conntrack_protocol'.

Signed-off-by: Martin Josefsson <gandalf@wlug.westbo.se>

---
 include/net/netfilter/nf_conntrack_core.h      |   10 -
 include/net/netfilter/nf_conntrack_l3proto.h   |    4 
 include/net/netfilter/nf_conntrack_l4proto.h   |  129 +++++++++++++++++++++++++
 include/net/netfilter/nf_conntrack_protocol.h  |  129 -------------------------
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |   26 ++---
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |   12 +-
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |   26 ++---
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |   12 +-
 net/netfilter/nf_conntrack_core.c              |   46 ++++----
 net/netfilter/nf_conntrack_ecache.c            |    2 
 net/netfilter/nf_conntrack_expect.c            |    2 
 net/netfilter/nf_conntrack_helper.c            |    2 
 net/netfilter/nf_conntrack_l3proto_generic.c   |    4 
 net/netfilter/nf_conntrack_netlink.c           |   54 +++++-----
 net/netfilter/nf_conntrack_proto.c             |   72 ++++++-------
 net/netfilter/nf_conntrack_proto_generic.c     |    6 -
 net/netfilter/nf_conntrack_proto_sctp.c        |   26 ++---
 net/netfilter/nf_conntrack_proto_tcp.c         |   14 +-
 net/netfilter/nf_conntrack_proto_udp.c         |   14 +-
 net/netfilter/nf_conntrack_standalone.c        |   28 ++---
 20 files changed, 309 insertions(+), 309 deletions(-)

Index: linux-2.6.19-rc3-git4.quilt/include/net/netfilter/nf_conntrack_core.h
===================================================================
--- linux-2.6.19-rc3-git4.quilt.orig/include/net/netfilter/nf_conntrack_core.h	2006-11-01 21:39:49.000000000 +0100
+++ linux-2.6.19-rc3-git4.quilt/include/net/netfilter/nf_conntrack_core.h	2006-11-01 21:40:01.000000000 +0100
@@ -14,7 +14,7 @@
 
 #include <linux/netfilter.h>
 #include <net/netfilter/nf_conntrack_l3proto.h>
-#include <net/netfilter/nf_conntrack_protocol.h>
+#include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_ecache.h>
 
 /* This header is used to share core functionality between the
@@ -32,7 +32,7 @@ extern struct nf_conntrack_l3proto *nf_c
 /* Like above, but you already have conntrack read lock. */
 extern struct nf_conntrack_l3proto *__nf_ct_find_l3proto(u_int16_t l3proto);
 
-struct nf_conntrack_protocol;
+struct nf_conntrack_l4proto;
 
 extern int
 nf_ct_get_tuple(const struct sk_buff *skb,
@@ -42,13 +42,13 @@ nf_ct_get_tuple(const struct sk_buff *sk
 		u_int8_t protonum,
 		struct nf_conntrack_tuple *tuple,
 		const struct nf_conntrack_l3proto *l3proto,
-		const struct nf_conntrack_protocol *protocol);
+		const struct nf_conntrack_l4proto *l4proto);
 
 extern int
 nf_ct_invert_tuple(struct nf_conntrack_tuple *inverse,
 		   const struct nf_conntrack_tuple *orig,
 		   const struct nf_conntrack_l3proto *l3proto,
-		   const struct nf_conntrack_protocol *protocol);
+		   const struct nf_conntrack_l4proto *l4proto);
 
 /* Find a connection corresponding to a tuple. */
 extern struct nf_conntrack_tuple_hash *
@@ -76,7 +76,7 @@ extern void __nf_conntrack_attach(struct
 int
 print_tuple(struct seq_file *s, const struct nf_conntrack_tuple *tuple,
 	    struct nf_conntrack_l3proto *l3proto,
-	    struct nf_conntrack_protocol *proto);
+	    struct nf_conntrack_l4proto *proto);
 
 extern struct list_head *nf_conntrack_hash;
 extern struct list_head nf_conntrack_expect_list;
Index: linux-2.6.19-rc3-git4.quilt/include/net/netfilter/nf_conntrack_l3proto.h
===================================================================
--- linux-2.6.19-rc3-git4.quilt.orig/include/net/netfilter/nf_conntrack_l3proto.h	2006-11-01 21:38:54.000000000 +0100
+++ linux-2.6.19-rc3-git4.quilt/include/net/netfilter/nf_conntrack_l3proto.h	2006-11-01 21:40:01.000000000 +0100
@@ -96,13 +96,13 @@ extern void nf_ct_l3proto_put(struct nf_
 /* Existing built-in protocols */
 extern struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv4;
 extern struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv6;
-extern struct nf_conntrack_l3proto nf_conntrack_generic_l3proto;
+extern struct nf_conntrack_l3proto nf_conntrack_l3proto_generic;
 
 static inline struct nf_conntrack_l3proto *
 __nf_ct_l3proto_find(u_int16_t l3proto)
 {
 	if (unlikely(l3proto >= AF_MAX))
-		return &nf_conntrack_generic_l3proto;
+		return &nf_conntrack_l3proto_generic;
 	return nf_ct_l3protos[l3proto];
 }
 
Index: linux-2.6.19-rc3-git4.quilt/include/net/netfilter/nf_conntrack_l4proto.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.19-rc3-git4.quilt/include/net/netfilter/nf_conntrack_l4proto.h	2006-11-01 21:40:01.000000000 +0100
@@ -0,0 +1,129 @@
+/*
+ * Header for use in defining a given L4 protocol for connection tracking.
+ *
+ * 16 Dec 2003: Yasuyuki Kozakai @USAGI <yasuyuki.kozakai@toshiba.co.jp>
+ *	- generalized L3 protocol dependent part.
+ *
+ * Derived from include/linux/netfiter_ipv4/ip_conntrack_protcol.h
+ */
+
+#ifndef _NF_CONNTRACK_L4PROTO_H
+#define _NF_CONNTRACK_L4PROTO_H
+#include <net/netfilter/nf_conntrack.h>
+
+struct seq_file;
+struct nfattr;
+
+struct nf_conntrack_l4proto
+{
+	/* Next pointer. */
+	struct list_head list;
+
+	/* L3 Protocol number. */
+	u_int16_t l3proto;
+
+	/* L4 Protocol number. */
+	u_int8_t l4proto;
+
+	/* Protocol name */
+	const char *name;
+
+	/* Try to fill in the third arg: dataoff is offset past network protocol
+           hdr.  Return true if possible. */
+	int (*pkt_to_tuple)(const struct sk_buff *skb,
+			    unsigned int dataoff,
+			    struct nf_conntrack_tuple *tuple);
+
+	/* Invert the per-proto part of the tuple: ie. turn xmit into reply.
+	 * Some packets can't be inverted: return 0 in that case.
+	 */
+	int (*invert_tuple)(struct nf_conntrack_tuple *inverse,
+			    const struct nf_conntrack_tuple *orig);
+
+	/* Print out the per-protocol part of the tuple. Return like seq_* */
+	int (*print_tuple)(struct seq_file *s,
+			   const struct nf_conntrack_tuple *);
+
+	/* Print out the private part of the conntrack. */
+	int (*print_conntrack)(struct seq_file *s, const struct nf_conn *);
+
+	/* Returns verdict for packet, or -1 for invalid. */
+	int (*packet)(struct nf_conn *conntrack,
+		      const struct sk_buff *skb,
+		      unsigned int dataoff,
+		      enum ip_conntrack_info ctinfo,
+		      int pf,
+		      unsigned int hooknum);
+
+	/* Called when a new connection for this protocol found;
+	 * returns TRUE if it's OK.  If so, packet() called next. */
+	int (*new)(struct nf_conn *conntrack, const struct sk_buff *skb,
+		   unsigned int dataoff);
+
+	/* Called when a conntrack entry is destroyed */
+	void (*destroy)(struct nf_conn *conntrack);
+
+	int (*error)(struct sk_buff *skb, unsigned int dataoff,
+		     enum ip_conntrack_info *ctinfo,
+		     int pf, unsigned int hooknum);
+
+	/* convert protoinfo to nfnetink attributes */
+	int (*to_nfattr)(struct sk_buff *skb, struct nfattr *nfa,
+			 const struct nf_conn *ct);
+
+	/* convert nfnetlink attributes to protoinfo */
+	int (*from_nfattr)(struct nfattr *tb[], struct nf_conn *ct);
+
+	int (*tuple_to_nfattr)(struct sk_buff *skb,
+			       const struct nf_conntrack_tuple *t);
+	int (*nfattr_to_tuple)(struct nfattr *tb[],
+			       struct nf_conntrack_tuple *t);
+
+	/* Module (if any) which this is connected to. */
+	struct module *me;
+};
+
+/* Existing built-in protocols */
+extern struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp6;
+extern struct nf_conntrack_l4proto nf_conntrack_l4proto_udp4;
+extern struct nf_conntrack_l4proto nf_conntrack_l4proto_udp6;
+extern struct nf_conntrack_l4proto nf_conntrack_l4proto_generic;
+
+#define MAX_NF_CT_PROTO 256
+extern struct nf_conntrack_l4proto **nf_ct_protos[PF_MAX];
+
+extern struct nf_conntrack_l4proto *
+__nf_ct_l4proto_find(u_int16_t l3proto, u_int8_t l4proto);
+
+extern struct nf_conntrack_l4proto *
+nf_ct_l4proto_find_get(u_int16_t l3proto, u_int8_t protocol);
+
+extern void nf_ct_l4proto_put(struct nf_conntrack_l4proto *p);
+
+/* Protocol registration. */
+extern int nf_conntrack_l4proto_register(struct nf_conntrack_l4proto *proto);
+extern void nf_conntrack_l4proto_unregister(struct nf_conntrack_l4proto *proto);
+
+/* Generic netlink helpers */
+extern int nf_ct_port_tuple_to_nfattr(struct sk_buff *skb,
+				      const struct nf_conntrack_tuple *tuple);
+extern int nf_ct_port_nfattr_to_tuple(struct nfattr *tb[],
+				      struct nf_conntrack_tuple *t);
+
+/* Log invalid packets */
+extern unsigned int nf_ct_log_invalid;
+
+#ifdef CONFIG_SYSCTL
+#ifdef DEBUG_INVALID_PACKETS
+#define LOG_INVALID(proto) \
+	(nf_ct_log_invalid == (proto) || nf_ct_log_invalid == IPPROTO_RAW)
+#else
+#define LOG_INVALID(proto) \
+	((nf_ct_log_invalid == (proto) || nf_ct_log_invalid == IPPROTO_RAW) \
+	 && net_ratelimit())
+#endif
+#else
+#define LOG_INVALID(proto) 0
+#endif /* CONFIG_SYSCTL */
+
+#endif /*_NF_CONNTRACK_PROTOCOL_H*/
Index: linux-2.6.19-rc3-git4.quilt/include/net/netfilter/nf_conntrack_protocol.h
===================================================================
--- linux-2.6.19-rc3-git4.quilt.orig/include/net/netfilter/nf_conntrack_protocol.h	2006-11-01 21:38:55.000000000 +0100
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,129 +0,0 @@
-/*
- * Header for use in defining a given protocol for connection tracking.
- *
- * 16 Dec 2003: Yasuyuki Kozakai @USAGI <yasuyuki.kozakai@toshiba.co.jp>
- *	- generalized L3 protocol dependent part.
- *
- * Derived from include/linux/netfiter_ipv4/ip_conntrack_protcol.h
- */
-
-#ifndef _NF_CONNTRACK_PROTOCOL_H
-#define _NF_CONNTRACK_PROTOCOL_H
-#include <net/netfilter/nf_conntrack.h>
-
-struct seq_file;
-struct nfattr;
-
-struct nf_conntrack_protocol
-{
-	/* Next pointer. */
-	struct list_head list;
-
-	/* L3 Protocol number. */
-	u_int16_t l3proto;
-
-	/* Protocol number. */
-	u_int8_t proto;
-
-	/* Protocol name */
-	const char *name;
-
-	/* Try to fill in the third arg: dataoff is offset past network protocol
-           hdr.  Return true if possible. */
-	int (*pkt_to_tuple)(const struct sk_buff *skb,
-			    unsigned int dataoff,
-			    struct nf_conntrack_tuple *tuple);
-
-	/* Invert the per-proto part of the tuple: ie. turn xmit into reply.
-	 * Some packets can't be inverted: return 0 in that case.
-	 */
-	int (*invert_tuple)(struct nf_conntrack_tuple *inverse,
-			    const struct nf_conntrack_tuple *orig);
-
-	/* Print out the per-protocol part of the tuple. Return like seq_* */
-	int (*print_tuple)(struct seq_file *s,
-			   const struct nf_conntrack_tuple *);
-
-	/* Print out the private part of the conntrack. */
-	int (*print_conntrack)(struct seq_file *s, const struct nf_conn *);
-
-	/* Returns verdict for packet, or -1 for invalid. */
-	int (*packet)(struct nf_conn *conntrack,
-		      const struct sk_buff *skb,
-		      unsigned int dataoff,
-		      enum ip_conntrack_info ctinfo,
-		      int pf,
-		      unsigned int hooknum);
-
-	/* Called when a new connection for this protocol found;
-	 * returns TRUE if it's OK.  If so, packet() called next. */
-	int (*new)(struct nf_conn *conntrack, const struct sk_buff *skb,
-		   unsigned int dataoff);
-
-	/* Called when a conntrack entry is destroyed */
-	void (*destroy)(struct nf_conn *conntrack);
-
-	int (*error)(struct sk_buff *skb, unsigned int dataoff,
-		     enum ip_conntrack_info *ctinfo,
-		     int pf, unsigned int hooknum);
-
-	/* convert protoinfo to nfnetink attributes */
-	int (*to_nfattr)(struct sk_buff *skb, struct nfattr *nfa,
-			 const struct nf_conn *ct);
-
-	/* convert nfnetlink attributes to protoinfo */
-	int (*from_nfattr)(struct nfattr *tb[], struct nf_conn *ct);
-
-	int (*tuple_to_nfattr)(struct sk_buff *skb,
-			       const struct nf_conntrack_tuple *t);
-	int (*nfattr_to_tuple)(struct nfattr *tb[],
-			       struct nf_conntrack_tuple *t);
-
-	/* Module (if any) which this is connected to. */
-	struct module *me;
-};
-
-/* Existing built-in protocols */
-extern struct nf_conntrack_protocol nf_conntrack_protocol_tcp6;
-extern struct nf_conntrack_protocol nf_conntrack_protocol_udp4;
-extern struct nf_conntrack_protocol nf_conntrack_protocol_udp6;
-extern struct nf_conntrack_protocol nf_conntrack_generic_protocol;
-
-#define MAX_NF_CT_PROTO 256
-extern struct nf_conntrack_protocol **nf_ct_protos[PF_MAX];
-
-extern struct nf_conntrack_protocol *
-__nf_ct_proto_find(u_int16_t l3proto, u_int8_t protocol);
-
-extern struct nf_conntrack_protocol *
-nf_ct_proto_find_get(u_int16_t l3proto, u_int8_t protocol);
-
-extern void nf_ct_proto_put(struct nf_conntrack_protocol *p);
-
-/* Protocol registration. */
-extern int nf_conntrack_protocol_register(struct nf_conntrack_protocol *proto);
-extern void nf_conntrack_protocol_unregister(struct nf_conntrack_protocol *proto);
-
-/* Generic netlink helpers */
-extern int nf_ct_port_tuple_to_nfattr(struct sk_buff *skb,
-				      const struct nf_conntrack_tuple *tuple);
-extern int nf_ct_port_nfattr_to_tuple(struct nfattr *tb[],
-				      struct nf_conntrack_tuple *t);
-
-/* Log invalid packets */
-extern unsigned int nf_ct_log_invalid;
-
-#ifdef CONFIG_SYSCTL
-#ifdef DEBUG_INVALID_PACKETS
-#define LOG_INVALID(proto) \
-	(nf_ct_log_invalid == (proto) || nf_ct_log_invalid == IPPROTO_RAW)
-#else
-#define LOG_INVALID(proto) \
-	((nf_ct_log_invalid == (proto) || nf_ct_log_invalid == IPPROTO_RAW) \
-	 && net_ratelimit())
-#endif
-#else
-#define LOG_INVALID(proto) 0
-#endif /* CONFIG_SYSCTL */
-
-#endif /*_NF_CONNTRACK_PROTOCOL_H*/
Index: linux-2.6.19-rc3-git4.quilt/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
===================================================================
--- linux-2.6.19-rc3-git4.quilt.orig/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c	2006-11-01 21:38:54.000000000 +0100
+++ linux-2.6.19-rc3-git4.quilt/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c	2006-11-01 21:40:01.000000000 +0100
@@ -27,7 +27,7 @@
 #include <linux/netfilter_ipv4.h>
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_helper.h>
-#include <net/netfilter/nf_conntrack_protocol.h>
+#include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_l3proto.h>
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/ipv4/nf_conntrack_ipv4.h>
@@ -429,9 +429,9 @@ struct nf_conntrack_l3proto nf_conntrack
 	.me		 = THIS_MODULE,
 };
 
-extern struct nf_conntrack_protocol nf_conntrack_protocol_tcp4;
-extern struct nf_conntrack_protocol nf_conntrack_protocol_udp4;
-extern struct nf_conntrack_protocol nf_conntrack_protocol_icmp;
+extern struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp4;
+extern struct nf_conntrack_l4proto nf_conntrack_l4proto_udp4;
+extern struct nf_conntrack_l4proto nf_conntrack_l4proto_icmp;
 
 MODULE_ALIAS("nf_conntrack-" __stringify(AF_INET));
 MODULE_LICENSE("GPL");
@@ -448,19 +448,19 @@ static int __init nf_conntrack_l3proto_i
 		return ret;
 	}
 
-	ret = nf_conntrack_protocol_register(&nf_conntrack_protocol_tcp4);
+	ret = nf_conntrack_l4proto_register(&nf_conntrack_l4proto_tcp4);
 	if (ret < 0) {
 		printk("nf_conntrack_ipv4: can't register tcp.\n");
 		goto cleanup_sockopt;
 	}
 
-	ret = nf_conntrack_protocol_register(&nf_conntrack_protocol_udp4);
+	ret = nf_conntrack_l4proto_register(&nf_conntrack_l4proto_udp4);
 	if (ret < 0) {
 		printk("nf_conntrack_ipv4: can't register udp.\n");
 		goto cleanup_tcp;
 	}
 
-	ret = nf_conntrack_protocol_register(&nf_conntrack_protocol_icmp);
+	ret = nf_conntrack_l4proto_register(&nf_conntrack_l4proto_icmp);
 	if (ret < 0) {
 		printk("nf_conntrack_ipv4: can't register icmp.\n");
 		goto cleanup_udp;
@@ -495,11 +495,11 @@ static int __init nf_conntrack_l3proto_i
  cleanup_ipv4:
 	nf_conntrack_l3proto_unregister(&nf_conntrack_l3proto_ipv4);
  cleanup_icmp:
-	nf_conntrack_protocol_unregister(&nf_conntrack_protocol_icmp);
+	nf_conntrack_l4proto_unregister(&nf_conntrack_l4proto_icmp);
  cleanup_udp:
-	nf_conntrack_protocol_unregister(&nf_conntrack_protocol_udp4);
+	nf_conntrack_l4proto_unregister(&nf_conntrack_l4proto_udp4);
  cleanup_tcp:
-	nf_conntrack_protocol_unregister(&nf_conntrack_protocol_tcp4);
+	nf_conntrack_l4proto_unregister(&nf_conntrack_l4proto_tcp4);
  cleanup_sockopt:
 	nf_unregister_sockopt(&so_getorigdst);
 	return ret;
@@ -513,9 +513,9 @@ static void __exit nf_conntrack_l3proto_
 #endif
 	nf_unregister_hooks(ipv4_conntrack_ops, ARRAY_SIZE(ipv4_conntrack_ops));
 	nf_conntrack_l3proto_unregister(&nf_conntrack_l3proto_ipv4);
-	nf_conntrack_protocol_unregister(&nf_conntrack_protocol_icmp);
-	nf_conntrack_protocol_unregister(&nf_conntrack_protocol_udp4);
-	nf_conntrack_protocol_unregister(&nf_conntrack_protocol_tcp4);
+	nf_conntrack_l4proto_unregister(&nf_conntrack_l4proto_icmp);
+	nf_conntrack_l4proto_unregister(&nf_conntrack_l4proto_udp4);
+	nf_conntrack_l4proto_unregister(&nf_conntrack_l4proto_tcp4);
 	nf_unregister_sockopt(&so_getorigdst);
 }
 
Index: linux-2.6.19-rc3-git4.quilt/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
===================================================================
--- linux-2.6.19-rc3-git4.quilt.orig/net/ipv4/netfilter/nf_conntrack_proto_icmp.c	2006-11-01 21:38:55.000000000 +0100
+++ linux-2.6.19-rc3-git4.quilt/net/ipv4/netfilter/nf_conntrack_proto_icmp.c	2006-11-01 21:40:01.000000000 +0100
@@ -22,7 +22,7 @@
 #include <net/checksum.h>
 #include <linux/netfilter_ipv4.h>
 #include <net/netfilter/nf_conntrack_tuple.h>
-#include <net/netfilter/nf_conntrack_protocol.h>
+#include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_core.h>
 
 unsigned long nf_ct_icmp_timeout __read_mostly = 30*HZ;
@@ -152,7 +152,7 @@ icmp_error_message(struct sk_buff *skb,
 		struct icmphdr icmp;
 		struct iphdr ip;
 	} _in, *inside;
-	struct nf_conntrack_protocol *innerproto;
+	struct nf_conntrack_l4proto *innerproto;
 	struct nf_conntrack_tuple_hash *h;
 	int dataoff;
 
@@ -170,7 +170,7 @@ icmp_error_message(struct sk_buff *skb,
 		return -NF_ACCEPT;
 	}
 
-	innerproto = __nf_ct_proto_find(PF_INET, inside->ip.protocol);
+	innerproto = __nf_ct_l4proto_find(PF_INET, inside->ip.protocol);
 	dataoff = skb->nh.iph->ihl*4 + sizeof(inside->icmp);
 	/* Are they talking about one of our connections? */
 	if (!nf_ct_get_tuple(skb, dataoff, dataoff + inside->ip.ihl*4, PF_INET,
@@ -321,11 +321,11 @@ static int icmp_nfattr_to_tuple(struct n
 }
 #endif
 
-struct nf_conntrack_protocol nf_conntrack_protocol_icmp =
+struct nf_conntrack_l4proto nf_conntrack_l4proto_icmp =
 {
 	.list			= { NULL, NULL },
 	.l3proto		= PF_INET,
-	.proto			= IPPROTO_ICMP,
+	.l4proto		= IPPROTO_ICMP,
 	.name			= "icmp",
 	.pkt_to_tuple		= icmp_pkt_to_tuple,
 	.invert_tuple		= icmp_invert_tuple,
@@ -343,4 +343,4 @@ struct nf_conntrack_protocol nf_conntrac
 #endif
 };
 
-EXPORT_SYMBOL(nf_conntrack_protocol_icmp);
+EXPORT_SYMBOL(nf_conntrack_l4proto_icmp);
Index: linux-2.6.19-rc3-git4.quilt/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
===================================================================
--- linux-2.6.19-rc3-git4.quilt.orig/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c	2006-11-01 21:38:54.000000000 +0100
+++ linux-2.6.19-rc3-git4.quilt/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c	2006-11-01 21:40:01.000000000 +0100
@@ -33,7 +33,7 @@
 #include <linux/netfilter_ipv6.h>
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_helper.h>
-#include <net/netfilter/nf_conntrack_protocol.h>
+#include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_l3proto.h>
 #include <net/netfilter/nf_conntrack_core.h>
 
@@ -458,9 +458,9 @@ struct nf_conntrack_l3proto nf_conntrack
 	.me			= THIS_MODULE,
 };
 
-extern struct nf_conntrack_protocol nf_conntrack_protocol_tcp6;
-extern struct nf_conntrack_protocol nf_conntrack_protocol_udp6;
-extern struct nf_conntrack_protocol nf_conntrack_protocol_icmpv6;
+extern struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp6;
+extern struct nf_conntrack_l4proto nf_conntrack_l4proto_udp6;
+extern struct nf_conntrack_l4proto nf_conntrack_l4proto_icmpv6;
 extern int nf_ct_frag6_init(void);
 extern void nf_ct_frag6_cleanup(void);
 
@@ -479,19 +479,19 @@ static int __init nf_conntrack_l3proto_i
 		printk("nf_conntrack_ipv6: can't initialize frag6.\n");
 		return ret;
 	}
-	ret = nf_conntrack_protocol_register(&nf_conntrack_protocol_tcp6);
+	ret = nf_conntrack_l4proto_register(&nf_conntrack_l4proto_tcp6);
 	if (ret < 0) {
 		printk("nf_conntrack_ipv6: can't register tcp.\n");
 		goto cleanup_frag6;
 	}
 
-	ret = nf_conntrack_protocol_register(&nf_conntrack_protocol_udp6);
+	ret = nf_conntrack_l4proto_register(&nf_conntrack_l4proto_udp6);
 	if (ret < 0) {
 		printk("nf_conntrack_ipv6: can't register udp.\n");
 		goto cleanup_tcp;
 	}
 
-	ret = nf_conntrack_protocol_register(&nf_conntrack_protocol_icmpv6);
+	ret = nf_conntrack_l4proto_register(&nf_conntrack_l4proto_icmpv6);
 	if (ret < 0) {
 		printk("nf_conntrack_ipv6: can't register icmpv6.\n");
 		goto cleanup_udp;
@@ -527,11 +527,11 @@ static int __init nf_conntrack_l3proto_i
  cleanup_ipv6:
 	nf_conntrack_l3proto_unregister(&nf_conntrack_l3proto_ipv6);
  cleanup_icmpv6:
-	nf_conntrack_protocol_unregister(&nf_conntrack_protocol_icmpv6);
+	nf_conntrack_l4proto_unregister(&nf_conntrack_l4proto_icmpv6);
  cleanup_udp:
-	nf_conntrack_protocol_unregister(&nf_conntrack_protocol_udp6);
+	nf_conntrack_l4proto_unregister(&nf_conntrack_l4proto_udp6);
  cleanup_tcp:
-	nf_conntrack_protocol_unregister(&nf_conntrack_protocol_tcp6);
+	nf_conntrack_l4proto_unregister(&nf_conntrack_l4proto_tcp6);
  cleanup_frag6:
 	nf_ct_frag6_cleanup();
 	return ret;
@@ -545,9 +545,9 @@ static void __exit nf_conntrack_l3proto_
 #endif
 	nf_unregister_hooks(ipv6_conntrack_ops, ARRAY_SIZE(ipv6_conntrack_ops));
 	nf_conntrack_l3proto_unregister(&nf_conntrack_l3proto_ipv6);
-	nf_conntrack_protocol_unregister(&nf_conntrack_protocol_icmpv6);
-	nf_conntrack_protocol_unregister(&nf_conntrack_protocol_udp6);
-	nf_conntrack_protocol_unregister(&nf_conntrack_protocol_tcp6);
+	nf_conntrack_l4proto_unregister(&nf_conntrack_l4proto_icmpv6);
+	nf_conntrack_l4proto_unregister(&nf_conntrack_l4proto_udp6);
+	nf_conntrack_l4proto_unregister(&nf_conntrack_l4proto_tcp6);
 	nf_ct_frag6_cleanup();
 }
 
Index: linux-2.6.19-rc3-git4.quilt/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
===================================================================
--- linux-2.6.19-rc3-git4.quilt.orig/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c	2006-11-01 21:38:55.000000000 +0100
+++ linux-2.6.19-rc3-git4.quilt/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c	2006-11-01 21:40:01.000000000 +0100
@@ -29,7 +29,7 @@
 #include <linux/seq_file.h>
 #include <linux/netfilter_ipv6.h>
 #include <net/netfilter/nf_conntrack_tuple.h>
-#include <net/netfilter/nf_conntrack_protocol.h>
+#include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/ipv6/nf_conntrack_icmpv6.h>
 
@@ -155,7 +155,7 @@ icmpv6_error_message(struct sk_buff *skb
 	struct nf_conntrack_tuple_hash *h;
 	struct icmp6hdr _hdr, *hp;
 	unsigned int inip6off;
-	struct nf_conntrack_protocol *inproto;
+	struct nf_conntrack_l4proto *inproto;
 	u_int8_t inprotonum;
 	unsigned int inprotoff;
 
@@ -185,7 +185,7 @@ icmpv6_error_message(struct sk_buff *skb
 		return -NF_ACCEPT;
 	}
 
-	inproto = __nf_ct_proto_find(PF_INET6, inprotonum);
+	inproto = __nf_ct_l4proto_find(PF_INET6, inprotonum);
 
 	/* Are they talking about one of our connections? */
 	if (!nf_ct_get_tuple(skb, inip6off, inprotoff, PF_INET6, inprotonum,
@@ -301,10 +301,10 @@ static int icmpv6_nfattr_to_tuple(struct
 }
 #endif
 
-struct nf_conntrack_protocol nf_conntrack_protocol_icmpv6 =
+struct nf_conntrack_l4proto nf_conntrack_l4proto_icmpv6 =
 {
 	.l3proto		= PF_INET6,
-	.proto			= IPPROTO_ICMPV6,
+	.l4proto		= IPPROTO_ICMPV6,
 	.name			= "icmpv6",
 	.pkt_to_tuple		= icmpv6_pkt_to_tuple,
 	.invert_tuple		= icmpv6_invert_tuple,
@@ -320,4 +320,4 @@ struct nf_conntrack_protocol nf_conntrac
 #endif
 };
 
-EXPORT_SYMBOL(nf_conntrack_protocol_icmpv6);
+EXPORT_SYMBOL(nf_conntrack_l4proto_icmpv6);
Index: linux-2.6.19-rc3-git4.quilt/net/netfilter/nf_conntrack_core.c
===================================================================
--- linux-2.6.19-rc3-git4.quilt.orig/net/netfilter/nf_conntrack_core.c	2006-11-01 21:39:51.000000000 +0100
+++ linux-2.6.19-rc3-git4.quilt/net/netfilter/nf_conntrack_core.c	2006-11-01 21:40:01.000000000 +0100
@@ -54,7 +54,7 @@
 
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_l3proto.h>
-#include <net/netfilter/nf_conntrack_protocol.h>
+#include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_expect.h>
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <net/netfilter/nf_conntrack_core.h>
@@ -256,7 +256,7 @@ nf_ct_get_tuple(const struct sk_buff *sk
 		u_int8_t protonum,
 		struct nf_conntrack_tuple *tuple,
 		const struct nf_conntrack_l3proto *l3proto,
-		const struct nf_conntrack_protocol *protocol)
+		const struct nf_conntrack_l4proto *l4proto)
 {
 	NF_CT_TUPLE_U_BLANK(tuple);
 
@@ -267,14 +267,14 @@ nf_ct_get_tuple(const struct sk_buff *sk
 	tuple->dst.protonum = protonum;
 	tuple->dst.dir = IP_CT_DIR_ORIGINAL;
 
-	return protocol->pkt_to_tuple(skb, dataoff, tuple);
+	return l4proto->pkt_to_tuple(skb, dataoff, tuple);
 }
 
 int
 nf_ct_invert_tuple(struct nf_conntrack_tuple *inverse,
 		   const struct nf_conntrack_tuple *orig,
 		   const struct nf_conntrack_l3proto *l3proto,
-		   const struct nf_conntrack_protocol *protocol)
+		   const struct nf_conntrack_l4proto *l4proto)
 {
 	NF_CT_TUPLE_U_BLANK(inverse);
 
@@ -285,7 +285,7 @@ nf_ct_invert_tuple(struct nf_conntrack_t
 	inverse->dst.dir = !orig->dst.dir;
 
 	inverse->dst.protonum = orig->dst.protonum;
-	return protocol->invert_tuple(inverse, orig);
+	return l4proto->invert_tuple(inverse, orig);
 }
 
 static void
@@ -305,7 +305,7 @@ destroy_conntrack(struct nf_conntrack *n
 {
 	struct nf_conn *ct = (struct nf_conn *)nfct;
 	struct nf_conntrack_l3proto *l3proto;
-	struct nf_conntrack_protocol *proto;
+	struct nf_conntrack_l4proto *l4proto;
 
 	DEBUGP("destroy_conntrack(%p)\n", ct);
 	NF_CT_ASSERT(atomic_read(&nfct->use) == 0);
@@ -321,9 +321,9 @@ destroy_conntrack(struct nf_conntrack *n
 	if (l3proto && l3proto->destroy)
 		l3proto->destroy(ct);
 
-	proto = __nf_ct_proto_find(ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.l3num, ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.protonum);
-	if (proto && proto->destroy)
-		proto->destroy(ct);
+	l4proto = __nf_ct_l4proto_find(ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.l3num, ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.protonum);
+	if (l4proto && l4proto->destroy)
+		l4proto->destroy(ct);
 
 	if (nf_conntrack_destroyed)
 		nf_conntrack_destroyed(ct);
@@ -653,7 +653,7 @@ void nf_conntrack_free(struct nf_conn *c
 static struct nf_conntrack_tuple_hash *
 init_conntrack(const struct nf_conntrack_tuple *tuple,
 	       struct nf_conntrack_l3proto *l3proto,
-	       struct nf_conntrack_protocol *protocol,
+	       struct nf_conntrack_l4proto *l4proto,
 	       struct sk_buff *skb,
 	       unsigned int dataoff)
 {
@@ -661,7 +661,7 @@ init_conntrack(const struct nf_conntrack
 	struct nf_conntrack_tuple repl_tuple;
 	struct nf_conntrack_expect *exp;
 
-	if (!nf_ct_invert_tuple(&repl_tuple, tuple, l3proto, protocol)) {
+	if (!nf_ct_invert_tuple(&repl_tuple, tuple, l3proto, l4proto)) {
 		DEBUGP("Can't invert tuple.\n");
 		return NULL;
 	}
@@ -672,7 +672,7 @@ init_conntrack(const struct nf_conntrack
 		return (struct nf_conntrack_tuple_hash *)conntrack;
 	}
 
-	if (!protocol->new(conntrack, skb, dataoff)) {
+	if (!l4proto->new(conntrack, skb, dataoff)) {
 		nf_conntrack_free(conntrack);
 		DEBUGP("init conntrack: can't track with proto module\n");
 		return NULL;
@@ -719,7 +719,7 @@ resolve_normal_ct(struct sk_buff *skb,
 		  u_int16_t l3num,
 		  u_int8_t protonum,
 		  struct nf_conntrack_l3proto *l3proto,
-		  struct nf_conntrack_protocol *proto,
+		  struct nf_conntrack_l4proto *l4proto,
 		  int *set_reply,
 		  enum ip_conntrack_info *ctinfo)
 {
@@ -729,7 +729,7 @@ resolve_normal_ct(struct sk_buff *skb,
 
 	if (!nf_ct_get_tuple(skb, (unsigned int)(skb->nh.raw - skb->data),
 			     dataoff, l3num, protonum, &tuple, l3proto,
-			     proto)) {
+			     l4proto)) {
 		DEBUGP("resolve_normal_ct: Can't get tuple\n");
 		return NULL;
 	}
@@ -737,7 +737,7 @@ resolve_normal_ct(struct sk_buff *skb,
 	/* look for tuple match */
 	h = nf_conntrack_find_get(&tuple, NULL);
 	if (!h) {
-		h = init_conntrack(&tuple, l3proto, proto, skb, dataoff);
+		h = init_conntrack(&tuple, l3proto, l4proto, skb, dataoff);
 		if (!h)
 			return NULL;
 		if (IS_ERR(h))
@@ -775,7 +775,7 @@ nf_conntrack_in(int pf, unsigned int hoo
 	struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
 	struct nf_conntrack_l3proto *l3proto;
-	struct nf_conntrack_protocol *proto;
+	struct nf_conntrack_l4proto *l4proto;
 	unsigned int dataoff;
 	u_int8_t protonum;
 	int set_reply = 0;
@@ -793,19 +793,19 @@ nf_conntrack_in(int pf, unsigned int hoo
 		return -ret;
 	}
 
-	proto = __nf_ct_proto_find((u_int16_t)pf, protonum);
+	l4proto = __nf_ct_l4proto_find((u_int16_t)pf, protonum);
 
 	/* It may be an special packet, error, unclean...
 	 * inverse of the return code tells to the netfilter
 	 * core what to do with the packet. */
-	if (proto->error != NULL &&
-	    (ret = proto->error(*pskb, dataoff, &ctinfo, pf, hooknum)) <= 0) {
+	if (l4proto->error != NULL &&
+	    (ret = l4proto->error(*pskb, dataoff, &ctinfo, pf, hooknum)) <= 0) {
 		NF_CT_STAT_INC(error);
 		NF_CT_STAT_INC(invalid);
 		return -ret;
 	}
 
-	ct = resolve_normal_ct(*pskb, dataoff, pf, protonum, l3proto, proto,
+	ct = resolve_normal_ct(*pskb, dataoff, pf, protonum, l3proto, l4proto,
 			       &set_reply, &ctinfo);
 	if (!ct) {
 		/* Not valid part of a connection */
@@ -821,7 +821,7 @@ nf_conntrack_in(int pf, unsigned int hoo
 
 	NF_CT_ASSERT((*pskb)->nfct);
 
-	ret = proto->packet(ct, *pskb, dataoff, ctinfo, pf, hooknum);
+	ret = l4proto->packet(ct, *pskb, dataoff, ctinfo, pf, hooknum);
 	if (ret < 0) {
 		/* Invalid: inverse of the return code tells
 		 * the netfilter core what to do */
@@ -843,7 +843,7 @@ int nf_ct_invert_tuplepr(struct nf_connt
 {
 	return nf_ct_invert_tuple(inverse, orig,
 				  __nf_ct_l3proto_find(orig->src.l3num),
-				  __nf_ct_proto_find(orig->src.l3num,
+				  __nf_ct_l4proto_find(orig->src.l3num,
 						     orig->dst.protonum));
 }
 
@@ -1200,7 +1200,7 @@ int __init nf_conntrack_init(void)
 	/* Don't NEED lock here, but good form anyway. */
 	write_lock_bh(&nf_conntrack_lock);
         for (i = 0; i < PF_MAX; i++)
-		nf_ct_l3protos[i] = &nf_conntrack_generic_l3proto;
+		nf_ct_l3protos[i] = &nf_conntrack_l3proto_generic;
         write_unlock_bh(&nf_conntrack_lock);
 
 	/* For use by REJECT target */
Index: linux-2.6.19-rc3-git4.quilt/net/netfilter/nf_conntrack_l3proto_generic.c
===================================================================
--- linux-2.6.19-rc3-git4.quilt.orig/net/netfilter/nf_conntrack_l3proto_generic.c	2006-11-01 21:38:54.000000000 +0100
+++ linux-2.6.19-rc3-git4.quilt/net/netfilter/nf_conntrack_l3proto_generic.c	2006-11-01 21:40:01.000000000 +0100
@@ -26,7 +26,7 @@
 
 #include <linux/netfilter_ipv4.h>
 #include <net/netfilter/nf_conntrack.h>
-#include <net/netfilter/nf_conntrack_protocol.h>
+#include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_l3proto.h>
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/ipv4/nf_conntrack_ipv4.h>
@@ -84,7 +84,7 @@ static u_int32_t generic_get_features(co
 	return NF_CT_F_BASIC;
 }
 
-struct nf_conntrack_l3proto nf_conntrack_generic_l3proto = {
+struct nf_conntrack_l3proto nf_conntrack_l3proto_generic = {
 	.l3proto	 = PF_UNSPEC,
 	.name		 = "unknown",
 	.pkt_to_tuple	 = generic_pkt_to_tuple,
Index: linux-2.6.19-rc3-git4.quilt/net/netfilter/nf_conntrack_netlink.c
===================================================================
--- linux-2.6.19-rc3-git4.quilt.orig/net/netfilter/nf_conntrack_netlink.c	2006-11-01 21:39:47.000000000 +0100
+++ linux-2.6.19-rc3-git4.quilt/net/netfilter/nf_conntrack_netlink.c	2006-11-01 21:40:01.000000000 +0100
@@ -38,7 +38,7 @@
 #include <net/netfilter/nf_conntrack_expect.h>
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <net/netfilter/nf_conntrack_l3proto.h>
-#include <net/netfilter/nf_conntrack_protocol.h>
+#include <net/netfilter/nf_conntrack_l4proto.h>
 #include <linux/netfilter_ipv4/ip_nat_protocol.h>
 
 #include <linux/netfilter/nfnetlink.h>
@@ -51,15 +51,15 @@ static char __initdata version[] = "0.93
 static inline int
 ctnetlink_dump_tuples_proto(struct sk_buff *skb, 
 			    const struct nf_conntrack_tuple *tuple,
-			    struct nf_conntrack_protocol *proto)
+			    struct nf_conntrack_l4proto *l4proto)
 {
 	int ret = 0;
 	struct nfattr *nest_parms = NFA_NEST(skb, CTA_TUPLE_PROTO);
 
 	NFA_PUT(skb, CTA_PROTO_NUM, sizeof(u_int8_t), &tuple->dst.protonum);
 
-	if (likely(proto->tuple_to_nfattr))
-		ret = proto->tuple_to_nfattr(skb, tuple);
+	if (likely(l4proto->tuple_to_nfattr))
+		ret = l4proto->tuple_to_nfattr(skb, tuple);
 	
 	NFA_NEST_END(skb, nest_parms);
 
@@ -94,7 +94,7 @@ ctnetlink_dump_tuples(struct sk_buff *sk
 {
 	int ret;
 	struct nf_conntrack_l3proto *l3proto;
-	struct nf_conntrack_protocol *proto;
+	struct nf_conntrack_l4proto *l4proto;
 
 	l3proto = nf_ct_l3proto_find_get(tuple->src.l3num);
 	ret = ctnetlink_dump_tuples_ip(skb, tuple, l3proto);
@@ -103,9 +103,9 @@ ctnetlink_dump_tuples(struct sk_buff *sk
 	if (unlikely(ret < 0))
 		return ret;
 
-	proto = nf_ct_proto_find_get(tuple->src.l3num, tuple->dst.protonum);
-	ret = ctnetlink_dump_tuples_proto(skb, tuple, proto);
-	nf_ct_proto_put(proto);
+	l4proto = nf_ct_l4proto_find_get(tuple->src.l3num, tuple->dst.protonum);
+	ret = ctnetlink_dump_tuples_proto(skb, tuple, l4proto);
+	nf_ct_l4proto_put(l4proto);
 
 	return ret;
 }
@@ -142,20 +142,20 @@ nfattr_failure:
 static inline int
 ctnetlink_dump_protoinfo(struct sk_buff *skb, const struct nf_conn *ct)
 {
-	struct nf_conntrack_protocol *proto = nf_ct_proto_find_get(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num, ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum);
+	struct nf_conntrack_l4proto *l4proto = nf_ct_l4proto_find_get(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num, ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum);
 	struct nfattr *nest_proto;
 	int ret;
 
-	if (!proto->to_nfattr) {
-		nf_ct_proto_put(proto);
+	if (!l4proto->to_nfattr) {
+		nf_ct_l4proto_put(l4proto);
 		return 0;
 	}
 	
 	nest_proto = NFA_NEST(skb, CTA_PROTOINFO);
 
-	ret = proto->to_nfattr(skb, nest_proto, ct);
+	ret = l4proto->to_nfattr(skb, nest_proto, ct);
 
-	nf_ct_proto_put(proto);
+	nf_ct_l4proto_put(l4proto);
 
 	NFA_NEST_END(skb, nest_proto);
 
@@ -492,7 +492,7 @@ ctnetlink_parse_tuple_proto(struct nfatt
 			    struct nf_conntrack_tuple *tuple)
 {
 	struct nfattr *tb[CTA_PROTO_MAX];
-	struct nf_conntrack_protocol *proto;
+	struct nf_conntrack_l4proto *l4proto;
 	int ret = 0;
 
 	nfattr_parse_nested(tb, CTA_PROTO_MAX, attr);
@@ -504,12 +504,12 @@ ctnetlink_parse_tuple_proto(struct nfatt
 		return -EINVAL;
 	tuple->dst.protonum = *(u_int8_t *)NFA_DATA(tb[CTA_PROTO_NUM-1]);
 
-	proto = nf_ct_proto_find_get(tuple->src.l3num, tuple->dst.protonum);
+	l4proto = nf_ct_l4proto_find_get(tuple->src.l3num, tuple->dst.protonum);
 
-	if (likely(proto->nfattr_to_tuple))
-		ret = proto->nfattr_to_tuple(tb, tuple);
+	if (likely(l4proto->nfattr_to_tuple))
+		ret = l4proto->nfattr_to_tuple(tb, tuple);
 
-	nf_ct_proto_put(proto);
+	nf_ct_l4proto_put(l4proto);
 	
 	return ret;
 }
@@ -890,18 +890,18 @@ static inline int
 ctnetlink_change_protoinfo(struct nf_conn *ct, struct nfattr *cda[])
 {
 	struct nfattr *tb[CTA_PROTOINFO_MAX], *attr = cda[CTA_PROTOINFO-1];
-	struct nf_conntrack_protocol *proto;
+	struct nf_conntrack_l4proto *l4proto;
 	u_int16_t npt = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum;
 	u_int16_t l3num = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
 	int err = 0;
 
 	nfattr_parse_nested(tb, CTA_PROTOINFO_MAX, attr);
 
-	proto = nf_ct_proto_find_get(l3num, npt);
+	l4proto = nf_ct_l4proto_find_get(l3num, npt);
 
-	if (proto->from_nfattr)
-		err = proto->from_nfattr(tb, ct);
-	nf_ct_proto_put(proto); 
+	if (l4proto->from_nfattr)
+		err = l4proto->from_nfattr(tb, ct);
+	nf_ct_l4proto_put(l4proto);
 
 	return err;
 }
@@ -1073,7 +1073,7 @@ ctnetlink_exp_dump_mask(struct sk_buff *
 {
 	int ret;
 	struct nf_conntrack_l3proto *l3proto;
-	struct nf_conntrack_protocol *proto;
+	struct nf_conntrack_l4proto *l4proto;
 	struct nfattr *nest_parms = NFA_NEST(skb, CTA_EXPECT_MASK);
 
 	l3proto = nf_ct_l3proto_find_get(tuple->src.l3num);
@@ -1083,9 +1083,9 @@ ctnetlink_exp_dump_mask(struct sk_buff *
 	if (unlikely(ret < 0))
 		goto nfattr_failure;
 
-	proto = nf_ct_proto_find_get(tuple->src.l3num, tuple->dst.protonum);
-	ret = ctnetlink_dump_tuples_proto(skb, mask, proto);
-	nf_ct_proto_put(proto);
+	l4proto = nf_ct_l4proto_find_get(tuple->src.l3num, tuple->dst.protonum);
+	ret = ctnetlink_dump_tuples_proto(skb, mask, l4proto);
+	nf_ct_l4proto_put(l4proto);
 	if (unlikely(ret < 0))
 		goto nfattr_failure;
 
Index: linux-2.6.19-rc3-git4.quilt/net/netfilter/nf_conntrack_proto_generic.c
===================================================================
--- linux-2.6.19-rc3-git4.quilt.orig/net/netfilter/nf_conntrack_proto_generic.c	2006-11-01 21:38:54.000000000 +0100
+++ linux-2.6.19-rc3-git4.quilt/net/netfilter/nf_conntrack_proto_generic.c	2006-11-01 21:40:01.000000000 +0100
@@ -15,7 +15,7 @@
 #include <linux/sched.h>
 #include <linux/timer.h>
 #include <linux/netfilter.h>
-#include <net/netfilter/nf_conntrack_protocol.h>
+#include <net/netfilter/nf_conntrack_l4proto.h>
 
 unsigned int nf_ct_generic_timeout __read_mostly = 600*HZ;
 
@@ -71,10 +71,10 @@ static int new(struct nf_conn *conntrack
 	return 1;
 }
 
-struct nf_conntrack_protocol nf_conntrack_generic_protocol =
+struct nf_conntrack_l4proto nf_conntrack_l4proto_generic =
 {
 	.l3proto		= PF_UNSPEC,
-	.proto			= 0,
+	.l4proto		= 0,
 	.name			= "unknown",
 	.pkt_to_tuple		= generic_pkt_to_tuple,
 	.invert_tuple		= generic_invert_tuple,
Index: linux-2.6.19-rc3-git4.quilt/net/netfilter/nf_conntrack_proto_sctp.c
===================================================================
--- linux-2.6.19-rc3-git4.quilt.orig/net/netfilter/nf_conntrack_proto_sctp.c	2006-11-01 21:39:49.000000000 +0100
+++ linux-2.6.19-rc3-git4.quilt/net/netfilter/nf_conntrack_proto_sctp.c	2006-11-01 21:40:01.000000000 +0100
@@ -32,7 +32,7 @@
 #include <linux/interrupt.h>
 
 #include <net/netfilter/nf_conntrack.h>
-#include <net/netfilter/nf_conntrack_protocol.h>
+#include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_ecache.h>
 
 #if 0
@@ -509,9 +509,9 @@ static int sctp_new(struct nf_conn *conn
 	return 1;
 }
 
-struct nf_conntrack_protocol nf_conntrack_protocol_sctp4 = { 
+struct nf_conntrack_l4proto nf_conntrack_l4proto_sctp4 = {
 	.l3proto	 = PF_INET,
-	.proto 		 = IPPROTO_SCTP, 
+	.l4proto 	 = IPPROTO_SCTP,
 	.name 		 = "sctp",
 	.pkt_to_tuple 	 = sctp_pkt_to_tuple, 
 	.invert_tuple 	 = sctp_invert_tuple, 
@@ -523,9 +523,9 @@ struct nf_conntrack_protocol nf_conntrac
 	.me 		 = THIS_MODULE 
 };
 
-struct nf_conntrack_protocol nf_conntrack_protocol_sctp6 = { 
+struct nf_conntrack_l4proto nf_conntrack_l4proto_sctp6 = {
 	.l3proto	 = PF_INET6,
-	.proto 		 = IPPROTO_SCTP, 
+	.l4proto 	 = IPPROTO_SCTP,
 	.name 		 = "sctp",
 	.pkt_to_tuple 	 = sctp_pkt_to_tuple, 
 	.invert_tuple 	 = sctp_invert_tuple, 
@@ -625,14 +625,14 @@ int __init nf_conntrack_proto_sctp_init(
 {
 	int ret;
 
-	ret = nf_conntrack_protocol_register(&nf_conntrack_protocol_sctp4);
+	ret = nf_conntrack_l4proto_register(&nf_conntrack_l4proto_sctp4);
 	if (ret) {
-		printk("nf_conntrack_proto_sctp4: protocol register failed\n");
+		printk("nf_conntrack_l4proto_sctp4: protocol register failed\n");
 		goto out;
 	}
-	ret = nf_conntrack_protocol_register(&nf_conntrack_protocol_sctp6);
+	ret = nf_conntrack_l4proto_register(&nf_conntrack_l4proto_sctp6);
 	if (ret) {
-		printk("nf_conntrack_proto_sctp6: protocol register failed\n");
+		printk("nf_conntrack_l4proto_sctp6: protocol register failed\n");
 		goto cleanup_sctp4;
 	}
 
@@ -648,10 +648,10 @@ int __init nf_conntrack_proto_sctp_init(
 
 #ifdef CONFIG_SYSCTL
  cleanup:
-	nf_conntrack_protocol_unregister(&nf_conntrack_protocol_sctp6);
+	nf_conntrack_l4proto_unregister(&nf_conntrack_l4proto_sctp6);
 #endif
  cleanup_sctp4:
-	nf_conntrack_protocol_unregister(&nf_conntrack_protocol_sctp4);
+	nf_conntrack_l4proto_unregister(&nf_conntrack_l4proto_sctp4);
  out:
 	DEBUGP("SCTP conntrack module loading %s\n", 
 					ret ? "failed": "succeeded");
@@ -660,8 +660,8 @@ int __init nf_conntrack_proto_sctp_init(
 
 void __exit nf_conntrack_proto_sctp_fini(void)
 {
-	nf_conntrack_protocol_unregister(&nf_conntrack_protocol_sctp6);
-	nf_conntrack_protocol_unregister(&nf_conntrack_protocol_sctp4);
+	nf_conntrack_l4proto_unregister(&nf_conntrack_l4proto_sctp6);
+	nf_conntrack_l4proto_unregister(&nf_conntrack_l4proto_sctp4);
 #ifdef CONFIG_SYSCTL
  	unregister_sysctl_table(nf_ct_sysctl_header);
 #endif
Index: linux-2.6.19-rc3-git4.quilt/net/netfilter/nf_conntrack_proto_tcp.c
===================================================================
--- linux-2.6.19-rc3-git4.quilt.orig/net/netfilter/nf_conntrack_proto_tcp.c	2006-11-01 21:39:49.000000000 +0100
+++ linux-2.6.19-rc3-git4.quilt/net/netfilter/nf_conntrack_proto_tcp.c	2006-11-01 21:40:01.000000000 +0100
@@ -42,7 +42,7 @@
 #include <linux/netfilter_ipv4.h>
 #include <linux/netfilter_ipv6.h>
 #include <net/netfilter/nf_conntrack.h>
-#include <net/netfilter/nf_conntrack_protocol.h>
+#include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_ecache.h>
 
 #if 0
@@ -1169,10 +1169,10 @@ static int nfattr_to_tcp(struct nfattr *
 }
 #endif
   
-struct nf_conntrack_protocol nf_conntrack_protocol_tcp4 =
+struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp4 =
 {
 	.l3proto		= PF_INET,
-	.proto 			= IPPROTO_TCP,
+	.l4proto 		= IPPROTO_TCP,
 	.name 			= "tcp",
 	.pkt_to_tuple 		= tcp_pkt_to_tuple,
 	.invert_tuple 		= tcp_invert_tuple,
@@ -1190,10 +1190,10 @@ struct nf_conntrack_protocol nf_conntrac
 #endif
 };
 
-struct nf_conntrack_protocol nf_conntrack_protocol_tcp6 =
+struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp6 =
 {
 	.l3proto		= PF_INET6,
-	.proto 			= IPPROTO_TCP,
+	.l4proto 		= IPPROTO_TCP,
 	.name 			= "tcp",
 	.pkt_to_tuple 		= tcp_pkt_to_tuple,
 	.invert_tuple 		= tcp_invert_tuple,
@@ -1211,5 +1211,5 @@ struct nf_conntrack_protocol nf_conntrac
 #endif
 };
 
-EXPORT_SYMBOL(nf_conntrack_protocol_tcp4);
-EXPORT_SYMBOL(nf_conntrack_protocol_tcp6);
+EXPORT_SYMBOL(nf_conntrack_l4proto_tcp4);
+EXPORT_SYMBOL(nf_conntrack_l4proto_tcp6);
Index: linux-2.6.19-rc3-git4.quilt/net/netfilter/nf_conntrack_proto_udp.c
===================================================================
--- linux-2.6.19-rc3-git4.quilt.orig/net/netfilter/nf_conntrack_proto_udp.c	2006-11-01 21:39:49.000000000 +0100
+++ linux-2.6.19-rc3-git4.quilt/net/netfilter/nf_conntrack_proto_udp.c	2006-11-01 21:40:01.000000000 +0100
@@ -26,7 +26,7 @@
 #include <linux/netfilter.h>
 #include <linux/netfilter_ipv4.h>
 #include <linux/netfilter_ipv6.h>
-#include <net/netfilter/nf_conntrack_protocol.h>
+#include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_ecache.h>
 
 unsigned int nf_ct_udp_timeout __read_mostly = 30*HZ;
@@ -148,10 +148,10 @@ static int udp_error(struct sk_buff *skb
 	return NF_ACCEPT;
 }
 
-struct nf_conntrack_protocol nf_conntrack_protocol_udp4 =
+struct nf_conntrack_l4proto nf_conntrack_l4proto_udp4 =
 {
 	.l3proto		= PF_INET,
-	.proto			= IPPROTO_UDP,
+	.l4proto		= IPPROTO_UDP,
 	.name			= "udp",
 	.pkt_to_tuple		= udp_pkt_to_tuple,
 	.invert_tuple		= udp_invert_tuple,
@@ -167,10 +167,10 @@ struct nf_conntrack_protocol nf_conntrac
 #endif
 };
 
-struct nf_conntrack_protocol nf_conntrack_protocol_udp6 =
+struct nf_conntrack_l4proto nf_conntrack_l4proto_udp6 =
 {
 	.l3proto		= PF_INET6,
-	.proto			= IPPROTO_UDP,
+	.l4proto		= IPPROTO_UDP,
 	.name			= "udp",
 	.pkt_to_tuple		= udp_pkt_to_tuple,
 	.invert_tuple		= udp_invert_tuple,
@@ -186,5 +186,5 @@ struct nf_conntrack_protocol nf_conntrac
 #endif
 };
 
-EXPORT_SYMBOL(nf_conntrack_protocol_udp4);
-EXPORT_SYMBOL(nf_conntrack_protocol_udp6);
+EXPORT_SYMBOL(nf_conntrack_l4proto_udp4);
+EXPORT_SYMBOL(nf_conntrack_l4proto_udp6);
Index: linux-2.6.19-rc3-git4.quilt/net/netfilter/nf_conntrack_standalone.c
===================================================================
--- linux-2.6.19-rc3-git4.quilt.orig/net/netfilter/nf_conntrack_standalone.c	2006-11-01 21:39:50.000000000 +0100
+++ linux-2.6.19-rc3-git4.quilt/net/netfilter/nf_conntrack_standalone.c	2006-11-01 21:40:01.000000000 +0100
@@ -35,7 +35,7 @@
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack_l3proto.h>
-#include <net/netfilter/nf_conntrack_protocol.h>
+#include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_expect.h>
 #include <net/netfilter/nf_conntrack_helper.h>
 
@@ -54,9 +54,9 @@ DECLARE_PER_CPU(struct ip_conntrack_stat
 int
 print_tuple(struct seq_file *s, const struct nf_conntrack_tuple *tuple,
 	    struct nf_conntrack_l3proto *l3proto,
-	    struct nf_conntrack_protocol *proto)
+	    struct nf_conntrack_l4proto *l4proto)
 {
-	return l3proto->print_tuple(s, tuple) || proto->print_tuple(s, tuple);
+	return l3proto->print_tuple(s, tuple) || l4proto->print_tuple(s, tuple);
 }
 
 #ifdef CONFIG_NF_CT_ACCT
@@ -135,7 +135,7 @@ static int ct_seq_show(struct seq_file *
 	const struct nf_conntrack_tuple_hash *hash = v;
 	const struct nf_conn *conntrack = nf_ct_tuplehash_to_ctrack(hash);
 	struct nf_conntrack_l3proto *l3proto;
-	struct nf_conntrack_protocol *proto;
+	struct nf_conntrack_l4proto *l4proto;
 
 	ASSERT_READ_LOCK(&nf_conntrack_lock);
 	NF_CT_ASSERT(conntrack);
@@ -148,7 +148,7 @@ static int ct_seq_show(struct seq_file *
 				       .tuple.src.l3num);
 
 	NF_CT_ASSERT(l3proto);
-	proto = __nf_ct_proto_find(conntrack->tuplehash[IP_CT_DIR_ORIGINAL]
+	l4proto = __nf_ct_l4proto_find(conntrack->tuplehash[IP_CT_DIR_ORIGINAL]
 				   .tuple.src.l3num,
 				   conntrack->tuplehash[IP_CT_DIR_ORIGINAL]
 				   .tuple.dst.protonum);
@@ -157,7 +157,7 @@ static int ct_seq_show(struct seq_file *
 	if (seq_printf(s, "%-8s %u %-8s %u %ld ",
 		       l3proto->name,
 		       conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num,
-		       proto->name,
+		       l4proto->name,
 		       conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum,
 		       timer_pending(&conntrack->timeout)
 		       ? (long)(conntrack->timeout.expires - jiffies)/HZ : 0) != 0)
@@ -166,11 +166,11 @@ static int ct_seq_show(struct seq_file *
 	if (l3proto->print_conntrack(s, conntrack))
 		return -ENOSPC;
 
-	if (proto->print_conntrack(s, conntrack))
+	if (l4proto->print_conntrack(s, conntrack))
 		return -ENOSPC;
 
 	if (print_tuple(s, &conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
-			l3proto, proto))
+			l3proto, l4proto))
 		return -ENOSPC;
 
 	if (seq_print_counters(s, &conntrack->counters[IP_CT_DIR_ORIGINAL]))
@@ -181,7 +181,7 @@ static int ct_seq_show(struct seq_file *
 			return -ENOSPC;
 
 	if (print_tuple(s, &conntrack->tuplehash[IP_CT_DIR_REPLY].tuple,
-			l3proto, proto))
+			l3proto, l4proto))
 		return -ENOSPC;
 
 	if (seq_print_counters(s, &conntrack->counters[IP_CT_DIR_REPLY]))
@@ -655,8 +655,8 @@ EXPORT_SYMBOL(nf_ct_l3proto_try_module_g
 EXPORT_SYMBOL(nf_ct_l3proto_module_put);
 EXPORT_SYMBOL(nf_conntrack_l3proto_register);
 EXPORT_SYMBOL(nf_conntrack_l3proto_unregister);
-EXPORT_SYMBOL(nf_conntrack_protocol_register);
-EXPORT_SYMBOL(nf_conntrack_protocol_unregister);
+EXPORT_SYMBOL(nf_conntrack_l4proto_register);
+EXPORT_SYMBOL(nf_conntrack_l4proto_unregister);
 EXPORT_SYMBOL(nf_ct_invert_tuplepr);
 EXPORT_SYMBOL(nf_conntrack_destroyed);
 EXPORT_SYMBOL(need_conntrack);
@@ -665,9 +665,9 @@ EXPORT_SYMBOL(nf_conntrack_helper_unregi
 EXPORT_SYMBOL(nf_ct_iterate_cleanup);
 EXPORT_SYMBOL(__nf_ct_refresh_acct);
 EXPORT_SYMBOL(nf_ct_protos);
-EXPORT_SYMBOL(__nf_ct_proto_find);
-EXPORT_SYMBOL(nf_ct_proto_find_get);
-EXPORT_SYMBOL(nf_ct_proto_put);
+EXPORT_SYMBOL(__nf_ct_l4proto_find);
+EXPORT_SYMBOL(nf_ct_l4proto_find_get);
+EXPORT_SYMBOL(nf_ct_l4proto_put);
 EXPORT_SYMBOL(nf_ct_l3proto_find_get);
 EXPORT_SYMBOL(nf_ct_l3proto_put);
 EXPORT_SYMBOL(nf_ct_l3protos);
Index: linux-2.6.19-rc3-git4.quilt/net/netfilter/nf_conntrack_expect.c
===================================================================
--- linux-2.6.19-rc3-git4.quilt.orig/net/netfilter/nf_conntrack_expect.c	2006-11-01 21:39:47.000000000 +0100
+++ linux-2.6.19-rc3-git4.quilt/net/netfilter/nf_conntrack_expect.c	2006-11-01 21:40:01.000000000 +0100
@@ -338,7 +338,7 @@ static int exp_seq_show(struct seq_file 
 		   expect->tuple.dst.protonum);
 	print_tuple(s, &expect->tuple,
 		    __nf_ct_l3proto_find(expect->tuple.src.l3num),
-		    __nf_ct_proto_find(expect->tuple.src.l3num,
+		    __nf_ct_l4proto_find(expect->tuple.src.l3num,
 				       expect->tuple.dst.protonum));
 	return seq_putc(s, '\n');
 }
Index: linux-2.6.19-rc3-git4.quilt/net/netfilter/nf_conntrack_helper.c
===================================================================
--- linux-2.6.19-rc3-git4.quilt.orig/net/netfilter/nf_conntrack_helper.c	2006-11-01 21:39:51.000000000 +0100
+++ linux-2.6.19-rc3-git4.quilt/net/netfilter/nf_conntrack_helper.c	2006-11-01 21:40:01.000000000 +0100
@@ -26,7 +26,7 @@
 
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_l3proto.h>
-#include <net/netfilter/nf_conntrack_protocol.h>
+#include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <net/netfilter/nf_conntrack_core.h>
 
Index: linux-2.6.19-rc3-git4.quilt/net/netfilter/nf_conntrack_ecache.c
===================================================================
--- linux-2.6.19-rc3-git4.quilt.orig/net/netfilter/nf_conntrack_ecache.c	2006-11-01 21:39:49.000000000 +0100
+++ linux-2.6.19-rc3-git4.quilt/net/netfilter/nf_conntrack_ecache.c	2006-11-01 21:40:01.000000000 +0100
@@ -22,7 +22,7 @@
 
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_l3proto.h>
-#include <net/netfilter/nf_conntrack_protocol.h>
+#include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_expect.h>
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <net/netfilter/nf_conntrack_core.h>
Index: linux-2.6.19-rc3-git4.quilt/net/netfilter/nf_conntrack_proto.c
===================================================================
--- linux-2.6.19-rc3-git4.quilt.orig/net/netfilter/nf_conntrack_proto.c	2006-11-01 21:39:50.000000000 +0100
+++ linux-2.6.19-rc3-git4.quilt/net/netfilter/nf_conntrack_proto.c	2006-11-01 21:40:01.000000000 +0100
@@ -24,38 +24,38 @@
 
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_l3proto.h>
-#include <net/netfilter/nf_conntrack_protocol.h>
+#include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_core.h>
 
-struct nf_conntrack_protocol **nf_ct_protos[PF_MAX] __read_mostly;
+struct nf_conntrack_l4proto **nf_ct_protos[PF_MAX] __read_mostly;
 struct nf_conntrack_l3proto *nf_ct_l3protos[PF_MAX] __read_mostly;
 
-struct nf_conntrack_protocol *
-__nf_ct_proto_find(u_int16_t l3proto, u_int8_t protocol)
+struct nf_conntrack_l4proto *
+__nf_ct_l4proto_find(u_int16_t l3proto, u_int8_t l4proto)
 {
 	if (unlikely(l3proto >= AF_MAX || nf_ct_protos[l3proto] == NULL))
-		return &nf_conntrack_generic_protocol;
+		return &nf_conntrack_l4proto_generic;
 
-	return nf_ct_protos[l3proto][protocol];
+	return nf_ct_protos[l3proto][l4proto];
 }
 
 /* this is guaranteed to always return a valid protocol helper, since
  * it falls back to generic_protocol */
-struct nf_conntrack_protocol *
-nf_ct_proto_find_get(u_int16_t l3proto, u_int8_t protocol)
+struct nf_conntrack_l4proto *
+nf_ct_l4proto_find_get(u_int16_t l3proto, u_int8_t l4proto)
 {
-	struct nf_conntrack_protocol *p;
+	struct nf_conntrack_l4proto *p;
 
 	preempt_disable();
-	p = __nf_ct_proto_find(l3proto, protocol);
+	p = __nf_ct_l4proto_find(l3proto, l4proto);
 	if (!try_module_get(p->me))
-		p = &nf_conntrack_generic_protocol;
+		p = &nf_conntrack_l4proto_generic;
 	preempt_enable();
 
 	return p;
 }
 
-void nf_ct_proto_put(struct nf_conntrack_protocol *p)
+void nf_ct_l4proto_put(struct nf_conntrack_l4proto *p)
 {
 	module_put(p->me);
 }
@@ -68,7 +68,7 @@ nf_ct_l3proto_find_get(u_int16_t l3proto
 	preempt_disable();
 	p = __nf_ct_l3proto_find(l3proto);
 	if (!try_module_get(p->me))
-		p = &nf_conntrack_generic_l3proto;
+		p = &nf_conntrack_l3proto_generic;
 	preempt_enable();
 
 	return p;
@@ -86,7 +86,7 @@ nf_ct_l3proto_try_module_get(unsigned sh
 	struct nf_conntrack_l3proto *p;
 
 retry:	p = nf_ct_l3proto_find_get(l3proto);
-	if (p == &nf_conntrack_generic_l3proto) {
+	if (p == &nf_conntrack_l3proto_generic) {
 		ret = request_module("nf_conntrack-%d", l3proto);
 		if (!ret)
 			goto retry;
@@ -114,14 +114,14 @@ static int kill_l3proto(struct nf_conn *
 			((struct nf_conntrack_l3proto *)data)->l3proto);
 }
 
-static int kill_proto(struct nf_conn *i, void *data)
+static int kill_l4proto(struct nf_conn *i, void *data)
 {
-	struct nf_conntrack_protocol *proto;
-	proto = (struct nf_conntrack_protocol *)data;
+	struct nf_conntrack_l4proto *l4proto;
+	l4proto = (struct nf_conntrack_l4proto *)data;
 	return (i->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum ==
-			proto->proto) &&
+			l4proto->l4proto) &&
 	       (i->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num ==
-			proto->l3proto);
+			l4proto->l3proto);
 }
 
 int nf_conntrack_l3proto_register(struct nf_conntrack_l3proto *proto)
@@ -129,7 +129,7 @@ int nf_conntrack_l3proto_register(struct
 	int ret = 0;
 
 	write_lock_bh(&nf_conntrack_lock);
-	if (nf_ct_l3protos[proto->l3proto] != &nf_conntrack_generic_l3proto) {
+	if (nf_ct_l3protos[proto->l3proto] != &nf_conntrack_l3proto_generic) {
 		ret = -EBUSY;
 		goto out;
 	}
@@ -143,7 +143,7 @@ out:
 void nf_conntrack_l3proto_unregister(struct nf_conntrack_l3proto *proto)
 {
 	write_lock_bh(&nf_conntrack_lock);
-	nf_ct_l3protos[proto->l3proto] = &nf_conntrack_generic_l3proto;
+	nf_ct_l3protos[proto->l3proto] = &nf_conntrack_l3proto_generic;
 	write_unlock_bh(&nf_conntrack_lock);
 
 	/* Somebody could be still looking at the proto in bh. */
@@ -155,43 +155,43 @@ void nf_conntrack_l3proto_unregister(str
 
 /* FIXME: Allow NULL functions and sub in pointers to generic for
    them. --RR */
-int nf_conntrack_protocol_register(struct nf_conntrack_protocol *proto)
+int nf_conntrack_l4proto_register(struct nf_conntrack_l4proto *l4proto)
 {
 	int ret = 0;
 
 retry:
 	write_lock_bh(&nf_conntrack_lock);
-	if (nf_ct_protos[proto->l3proto]) {
-		if (nf_ct_protos[proto->l3proto][proto->proto]
-				!= &nf_conntrack_generic_protocol) {
+	if (nf_ct_protos[l4proto->l3proto]) {
+		if (nf_ct_protos[l4proto->l3proto][l4proto->l4proto]
+				!= &nf_conntrack_l4proto_generic) {
 			ret = -EBUSY;
 			goto out_unlock;
 		}
 	} else {
 		/* l3proto may be loaded latter. */
-		struct nf_conntrack_protocol **proto_array;
+		struct nf_conntrack_l4proto **proto_array;
 		int i;
 
 		write_unlock_bh(&nf_conntrack_lock);
 
-		proto_array = (struct nf_conntrack_protocol **)
+		proto_array = (struct nf_conntrack_l4proto **)
 				kmalloc(MAX_NF_CT_PROTO *
-					 sizeof(struct nf_conntrack_protocol *),
+					 sizeof(struct nf_conntrack_l4proto *),
 					GFP_KERNEL);
 		if (proto_array == NULL) {
 			ret = -ENOMEM;
 			goto out;
 		}
 		for (i = 0; i < MAX_NF_CT_PROTO; i++)
-			proto_array[i] = &nf_conntrack_generic_protocol;
+			proto_array[i] = &nf_conntrack_l4proto_generic;
 
 		write_lock_bh(&nf_conntrack_lock);
-		if (nf_ct_protos[proto->l3proto]) {
+		if (nf_ct_protos[l4proto->l3proto]) {
 			/* bad timing, but no problem */
 			write_unlock_bh(&nf_conntrack_lock);
 			kfree(proto_array);
 		} else {
-			nf_ct_protos[proto->l3proto] = proto_array;
+			nf_ct_protos[l4proto->l3proto] = proto_array;
 			write_unlock_bh(&nf_conntrack_lock);
 		}
 
@@ -202,7 +202,7 @@ retry:
 		goto retry;
 	}
 
-	nf_ct_protos[proto->l3proto][proto->proto] = proto;
+	nf_ct_protos[l4proto->l3proto][l4proto->l4proto] = l4proto;
 
 out_unlock:
 	write_unlock_bh(&nf_conntrack_lock);
@@ -210,16 +210,16 @@ out:
 	return ret;
 }
 
-void nf_conntrack_protocol_unregister(struct nf_conntrack_protocol *proto)
+void nf_conntrack_l4proto_unregister(struct nf_conntrack_l4proto *l4proto)
 {
 	write_lock_bh(&nf_conntrack_lock);
-	nf_ct_protos[proto->l3proto][proto->proto]
-		= &nf_conntrack_generic_protocol;
+	nf_ct_protos[l4proto->l3proto][l4proto->l4proto]
+		= &nf_conntrack_l4proto_generic;
 	write_unlock_bh(&nf_conntrack_lock);
 
 	/* Somebody could be still looking at the proto in bh. */
 	synchronize_net();
 
 	/* Remove all contrack entries for this protocol */
-	nf_ct_iterate_cleanup(kill_proto, proto);
+	nf_ct_iterate_cleanup(kill_l4proto, l4proto);
 }

--
/Martin
