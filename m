From: Pablo Neira Ayuso <pablo@eurodev.net>
Subject: [RFC][PATCH] ctnetlink port to nf_conntrack take #3
Date: Mon, 05 Dec 2005 11:42:47 +0100
Message-ID: <439419A7.7040100@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050000040707000002080806"
Cc: Patrick McHardy <kaber@trash.net>,
	Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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

This is a multi-part message in MIME format.
--------------050000040707000002080806
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hi!

Attached the 3rd incarnation of the ctnetlink port to nf_conntrack, it
includes all recent Patrick's bugfixes and Yasuyuki's comments.

nf_conntrack_netlink.c is available at:
http://people.netfilter.org/pablo/nf_conntrack_netlink.c

-- 
Pablo

--------------050000040707000002080806
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index cc48256..64b82b7 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -94,6 +94,9 @@ struct nf_conn
 	/* Current number of expected connections */
 	unsigned int expecting;
 
+	/* Unique ID that identifies this conntrack*/
+	unsigned int id;
+
 	/* Helper. if any */
 	struct nf_conntrack_helper *helper;
 
@@ -140,6 +143,9 @@ struct nf_conntrack_expect
 	/* Usage count. */
 	atomic_t use;
 
+	/* Unique ID */
+	unsigned int id;
+
 	/* Flags */
 	unsigned int flags;
 
@@ -190,6 +196,31 @@ static inline void nf_ct_put(struct nf_c
 	nf_conntrack_put(&ct->ct_general);
 }
 
+extern struct nf_conntrack_tuple_hash *
+__nf_conntrack_find(const struct nf_conntrack_tuple *tuple,
+		    const struct nf_conn *ignored_conntrack);
+
+extern void nf_conntrack_hash_insert(struct nf_conn *ct);
+
+extern struct nf_conntrack_expect *
+__nf_conntrack_expect_find(const struct nf_conntrack_tuple *tuple);
+
+extern struct nf_conntrack_expect *
+nf_conntrack_expect_find(const struct nf_conntrack_tuple *tuple);
+
+extern void nf_ct_unlink_expect(struct nf_conntrack_expect *exp);
+
+extern void nf_ct_remove_expectations(struct nf_conn *ct);
+
+extern void nf_conntrack_flush(void);
+
+extern struct nf_conntrack_helper *
+nf_ct_helper_find_get( const struct nf_conntrack_tuple *tuple);
+extern void nf_ct_helper_put(struct nf_conntrack_helper *helper);
+
+extern struct nf_conntrack_helper *
+__nf_conntrack_helper_find_byname(const char *name);
+
 /* call to create an explicit dependency on nf_conntrack. */
 extern void need_nf_conntrack(void);
 
diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index 5a66b2a..86ec817 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -33,6 +33,8 @@ struct nf_conntrack_helper
 		    unsigned int protoff,
 		    struct nf_conn *ct,
 		    enum ip_conntrack_info conntrackinfo);
+
+	int (*to_nfattr)(struct sk_buff *skb, const struct nf_conn *ct);
 };
 
 extern int nf_conntrack_helper_register(struct nf_conntrack_helper *);
diff --git a/include/net/netfilter/nf_conntrack_l3proto.h b/include/net/netfilter/nf_conntrack_l3proto.h
index 01663e5..67856eb 100644
--- a/include/net/netfilter/nf_conntrack_l3proto.h
+++ b/include/net/netfilter/nf_conntrack_l3proto.h
@@ -14,6 +14,8 @@
 #include <linux/seq_file.h>
 #include <net/netfilter/nf_conntrack.h>
 
+struct nfattr;
+
 struct nf_conntrack_l3proto
 {
 	/* Next pointer. */
@@ -70,6 +72,12 @@ struct nf_conntrack_l3proto
 
 	u_int32_t (*get_features)(const struct nf_conntrack_tuple *tuple);
 
+	int (*tuple_to_nfattr)(struct sk_buff *skb,
+			       const struct nf_conntrack_tuple *t);
+
+	int (*nfattr_to_tuple)(struct nfattr *tb[],
+			       struct nf_conntrack_tuple *t);
+
 	/* Module (if any) which this is connected to. */
 	struct module *me;
 };
@@ -81,11 +89,16 @@ extern int nf_conntrack_l3proto_register
 extern void nf_conntrack_l3proto_unregister(struct nf_conntrack_l3proto *proto);
 
 static inline struct nf_conntrack_l3proto *
-nf_ct_find_l3proto(u_int16_t l3proto)
+__nf_ct_l3proto_find(u_int16_t l3proto)
 {
 	return nf_ct_l3protos[l3proto];
 }
 
+extern struct nf_conntrack_l3proto *
+nf_ct_l3proto_find_get(u_int16_t l3proto);
+
+extern void nf_ct_l3proto_put(struct nf_conntrack_l3proto *p);
+
 /* Existing built-in protocols */
 extern struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv4;
 extern struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv6;
diff --git a/include/net/netfilter/nf_conntrack_protocol.h b/include/net/netfilter/nf_conntrack_protocol.h
index b3afda3..1f33737 100644
--- a/include/net/netfilter/nf_conntrack_protocol.h
+++ b/include/net/netfilter/nf_conntrack_protocol.h
@@ -12,6 +12,7 @@
 #include <net/netfilter/nf_conntrack.h>
 
 struct seq_file;
+struct nfattr;
 
 struct nf_conntrack_protocol
 {
@@ -66,6 +67,18 @@ struct nf_conntrack_protocol
 		     enum ip_conntrack_info *ctinfo,
 		     int pf, unsigned int hooknum);
 
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
 	/* Module (if any) which this is connected to. */
 	struct module *me;
 };
@@ -80,12 +93,23 @@ extern struct nf_conntrack_protocol nf_c
 extern struct nf_conntrack_protocol **nf_ct_protos[PF_MAX];
 
 extern struct nf_conntrack_protocol *
-nf_ct_find_proto(u_int16_t l3proto, u_int8_t protocol);
+__nf_ct_proto_find(u_int16_t l3proto, u_int8_t protocol);
+
+extern struct nf_conntrack_protocol *
+nf_ct_proto_find_get(u_int16_t l3proto, u_int8_t protocol);
+
+extern void nf_ct_proto_put(struct nf_conntrack_protocol *p);
 
 /* Protocol registration. */
 extern int nf_conntrack_protocol_register(struct nf_conntrack_protocol *proto);
 extern void nf_conntrack_protocol_unregister(struct nf_conntrack_protocol *proto);
 
+/* Generic netlink helpers */
+extern int nf_ct_port_tuple_to_nfattr(struct sk_buff *skb,
+				      const struct nf_conntrack_tuple *tuple);
+extern int nf_ct_port_nfattr_to_tuple(struct nfattr *tb[],
+				      struct nf_conntrack_tuple *t);
+
 /* Log invalid packets */
 extern unsigned int nf_ct_log_invalid;
 
diff --git a/include/net/netfilter/nf_conntrack_tuple.h b/include/net/netfilter/nf_conntrack_tuple.h
diff --git a/net/ipv4/netfilter/ip_conntrack_netlink.c b/net/ipv4/netfilter/ip_conntrack_netlink.c
diff --git a/net/ipv4/netfilter/ip_conntrack_proto_icmp.c b/net/ipv4/netfilter/ip_conntrack_proto_icmp.c
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index 8202c1c..385867e 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -392,6 +392,48 @@ getorigdst(struct sock *sk, int optval, 
 	return -ENOENT;
 }
 
+#if defined(CONFIG_NF_CT_NETLINK) || \
+    defined(CONFIG_NF_CT_NETLINK_MODULE)
+
+#include <linux/netfilter/nfnetlink.h>
+#include <linux/netfilter/nfnetlink_conntrack.h>
+
+static int ipv4_tuple_to_nfattr(struct sk_buff *skb,
+				const struct nf_conntrack_tuple *tuple)
+{
+	NFA_PUT(skb, CTA_IP_V4_SRC, sizeof(u_int32_t),
+		&tuple->src.u3.ip);
+	NFA_PUT(skb, CTA_IP_V4_DST, sizeof(u_int32_t),
+		&tuple->dst.u3.ip);
+	return 0;
+
+nfattr_failure:
+	return -1;
+}
+
+static const size_t cta_min_ip[CTA_IP_MAX] = {
+	[CTA_IP_V4_SRC-1]       = sizeof(u_int32_t),
+	[CTA_IP_V4_DST-1]       = sizeof(u_int32_t),
+};
+
+static int ipv4_nfattr_to_tuple(struct nfattr *tb[],
+				struct nf_conntrack_tuple *t)
+{
+	if (!tb[CTA_IP_V4_SRC-1] || !tb[CTA_IP_V4_DST-1])
+		return -EINVAL;
+
+	if (nfattr_bad_size(tb, CTA_IP_MAX, cta_min_ip))
+		return -EINVAL;
+
+	t->src.u3.ip =
+		*(u_int32_t *)NFA_DATA(tb[CTA_IP_V4_SRC-1]);
+	t->dst.u3.ip =
+		*(u_int32_t *)NFA_DATA(tb[CTA_IP_V4_DST-1]);
+
+	return 0;
+}
+#endif
+
 static struct nf_sockopt_ops so_getorigdst = {
 	.pf		= PF_INET,
 	.get_optmin	= SO_ORIGINAL_DST,
@@ -408,6 +450,11 @@ struct nf_conntrack_l3proto nf_conntrack
 	.print_conntrack = ipv4_print_conntrack,
 	.prepare	 = ipv4_prepare,
 	.get_features	 = ipv4_get_features,
+#if defined(CONFIG_NF_CT_NETLINK) || \
+    defined(CONFIG_NF_CT_NETLINK_MODULE)
+	.tuple_to_nfattr = ipv4_tuple_to_nfattr,
+	.nfattr_to_tuple = ipv4_nfattr_to_tuple,
+#endif
 	.me		 = THIS_MODULE,
 };
 
diff --git a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
index 7ddb5c0..973e653 100644
--- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
@@ -116,16 +116,16 @@ static int icmp_packet(struct nf_conn *c
 	return NF_ACCEPT;
 }
 
+static u_int8_t valid_new[]
+	= { [ICMP_ECHO] = 1,
+	    [ICMP_TIMESTAMP] = 1,
+	    [ICMP_INFO_REQUEST] = 1,
+	    [ICMP_ADDRESS] = 1 };
+
 /* Called when a new connection for this protocol found. */
 static int icmp_new(struct nf_conn *conntrack,
 		    const struct sk_buff *skb, unsigned int dataoff)
 {
-	static u_int8_t valid_new[]
-		= { [ICMP_ECHO] = 1,
-		    [ICMP_TIMESTAMP] = 1,
-		    [ICMP_INFO_REQUEST] = 1,
-		    [ICMP_ADDRESS] = 1 };
-
 	if (conntrack->tuplehash[0].tuple.dst.u.icmp.type >= sizeof(valid_new)
 	    || !valid_new[conntrack->tuplehash[0].tuple.dst.u.icmp.type]) {
 		/* Can't create a new ICMP `conn' with this. */
@@ -168,7 +168,7 @@ icmp_error_message(struct sk_buff *skb,
 		return -NF_ACCEPT;
 	}
 
-	innerproto = nf_ct_find_proto(PF_INET, inside->ip.protocol);
+	innerproto = __nf_ct_proto_find(PF_INET, inside->ip.protocol);
 	dataoff = skb->nh.iph->ihl*4 + sizeof(inside->icmp);
 	/* Are they talking about one of our connections? */
 	if (!nf_ct_get_tuple(skb, dataoff, dataoff + inside->ip.ihl*4, PF_INET,
@@ -281,6 +281,60 @@ checksum_skipped:
 	return icmp_error_message(skb, ctinfo, hooknum);
 }
 
+#if defined(CONFIG_NF_CT_NETLINK) || \
+    defined(CONFIG_NF_CT_NETLINK_MODULE)
+
+#include <linux/netfilter/nfnetlink.h>
+#include <linux/netfilter/nfnetlink_conntrack.h>
+
+static int icmp_tuple_to_nfattr(struct sk_buff *skb,
+				const struct nf_conntrack_tuple *t)
+{
+	NFA_PUT(skb, CTA_PROTO_ICMP_ID, sizeof(u_int16_t),
+		&t->src.u.icmp.id);
+	NFA_PUT(skb, CTA_PROTO_ICMP_TYPE, sizeof(u_int8_t),
+		&t->dst.u.icmp.type);
+	NFA_PUT(skb, CTA_PROTO_ICMP_CODE, sizeof(u_int8_t),
+		&t->dst.u.icmp.code);
+
+	return 0;
+
+nfattr_failure:
+	return -1;
+}
+
+static const size_t cta_min_proto[CTA_PROTO_MAX] = {
+	[CTA_PROTO_ICMP_TYPE-1] = sizeof(u_int8_t),
+	[CTA_PROTO_ICMP_CODE-1] = sizeof(u_int8_t),
+	[CTA_PROTO_ICMP_ID-1]   = sizeof(u_int16_t)
+};
+
+static int icmp_nfattr_to_tuple(struct nfattr *tb[],
+				struct nf_conntrack_tuple *tuple)
+{
+	if (!tb[CTA_PROTO_ICMP_TYPE-1]
+	    || !tb[CTA_PROTO_ICMP_CODE-1]
+	    || !tb[CTA_PROTO_ICMP_ID-1])
+		return -EINVAL;
+
+	if (nfattr_bad_size(tb, CTA_PROTO_MAX, cta_min_proto))
+		return -EINVAL;
+
+	tuple->dst.u.icmp.type = 
+			*(u_int8_t *)NFA_DATA(tb[CTA_PROTO_ICMP_TYPE-1]);
+	tuple->dst.u.icmp.code =
+			*(u_int8_t *)NFA_DATA(tb[CTA_PROTO_ICMP_CODE-1]);
+	tuple->src.u.icmp.id =
+			*(u_int16_t *)NFA_DATA(tb[CTA_PROTO_ICMP_ID-1]);
+
+	if (tuple->dst.u.icmp.type >= sizeof(valid_new)
+	    || !valid_new[tuple->dst.u.icmp.type])
+		return -EINVAL;
+
+	return 0;
+}
+#endif
+
 struct nf_conntrack_protocol nf_conntrack_protocol_icmp =
 {
 	.list			= { NULL, NULL },
@@ -295,7 +349,12 @@ struct nf_conntrack_protocol nf_conntrac
 	.new			= icmp_new,
 	.error			= icmp_error,
 	.destroy		= NULL,
-	.me			= NULL
+	.me			= NULL,
+#if defined(CONFIG_NF_CT_NETLINK) || \
+    defined(CONFIG_NF_CT_NETLINK_MODULE)
+	.tuple_to_nfattr	= icmp_tuple_to_nfattr,
+	.nfattr_to_tuple	= icmp_nfattr_to_tuple,
+#endif
 };
 
 EXPORT_SYMBOL(nf_conntrack_protocol_icmp);
diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index 753a3ae..5b08699 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -401,6 +401,48 @@ static ctl_table nf_ct_net_table[] = {
 };
 #endif
 
+#if defined(CONFIG_NF_CT_NETLINK) || \
+    defined(CONFIG_NF_CT_NETLINK_MODULE)
+
+#include <linux/netfilter/nfnetlink.h>
+#include <linux/netfilter/nfnetlink_conntrack.h>
+
+static int ipv6_tuple_to_nfattr(struct sk_buff *skb,
+				const struct nf_conntrack_tuple *tuple)
+{
+	NFA_PUT(skb, CTA_IP_V6_SRC, sizeof(u_int32_t) * 4,
+		&tuple->src.u3.ip6);
+	NFA_PUT(skb, CTA_IP_V6_DST, sizeof(u_int32_t) * 4,
+		&tuple->dst.u3.ip6);
+	return 0;
+
+nfattr_failure:
+	return -1;
+}
+
+static const size_t cta_min_ip[CTA_IP_MAX] = {
+	[CTA_IP_V6_SRC-1]       = sizeof(u_int32_t)*4,
+	[CTA_IP_V6_DST-1]       = sizeof(u_int32_t)*4,
+};
+
+static int ipv6_nfattr_to_tuple(struct nfattr *tb[],
+				struct nf_conntrack_tuple *t)
+{
+	if (!tb[CTA_IP_V6_SRC-1] || !tb[CTA_IP_V6_DST-1])
+		return -EINVAL;
+
+	if (nfattr_bad_size(tb, CTA_IP_MAX, cta_min_ip))
+		return -EINVAL;
+
+	memcpy(&t->src.u3.ip6, NFA_DATA(tb[CTA_IP_V6_SRC-1]), 
+	       sizeof(u_int32_t) * 4);
+	memcpy(&t->dst.u3.ip6, NFA_DATA(tb[CTA_IP_V6_DST-1]),
+	       sizeof(u_int32_t) * 4);
+
+	return 0;
+}
+#endif
+
 struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv6 = {
 	.l3proto		= PF_INET6,
 	.name			= "ipv6",
@@ -410,6 +452,11 @@ struct nf_conntrack_l3proto nf_conntrack
 	.print_conntrack	= ipv6_print_conntrack,
 	.prepare		= ipv6_prepare,
 	.get_features		= ipv6_get_features,
+#if defined(CONFIG_NF_CT_NETLINK) || \
+    defined(CONFIG_NF_CT_NETLINK_MODULE)
+	.tuple_to_nfattr 	= ipv6_tuple_to_nfattr,
+	.nfattr_to_tuple 	= ipv6_nfattr_to_tuple,
+#endif
 	.me			= THIS_MODULE,
 };
 
diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
index c0f1da5..00574f7 100644
--- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
@@ -185,7 +185,7 @@ icmpv6_error_message(struct sk_buff *skb
 		return -NF_ACCEPT;
 	}
 
-	inproto = nf_ct_find_proto(PF_INET6, inprotonum);
+	inproto = __nf_ct_proto_find(PF_INET6, inprotonum);
 
 	/* Are they talking about one of our connections? */
 	if (!nf_ct_get_tuple(skb, inip6off, inprotoff, PF_INET6, inprotonum,
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index a84f922..d6a0b96 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -95,4 +95,11 @@ config NF_CONNTRACK_FTP
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config NF_CT_NETLINK
+	tristate 'Connection tracking netlink interface (EXPERIMENTAL)'
+	depends on EXPERIMENTAL && NF_CONNTRACK && NETFILTER_NETLINK
+	depends on NF_CONNTRACK!=y || NETFILTER_NETLINK!=m
+	help
+	  This option enables support for a netlink-based userspace interface
+
 endmenu
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 55f019a..cb21831 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -13,3 +13,6 @@ obj-$(CONFIG_NF_CONNTRACK_FTP) += nf_con
 
 # SCTP protocol connection tracking
 obj-$(CONFIG_NF_CT_PROTO_SCTP) += nf_conntrack_proto_sctp.o
+
+# netlink interface for nf_conntrack
+obj-$(CONFIG_NF_CT_NETLINK) += nf_conntrack_netlink.o
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 1da6783..f7cbeee 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -82,6 +82,8 @@ unsigned int nf_ct_log_invalid;
 static LIST_HEAD(unconfirmed);
 static int nf_conntrack_vmalloc;
 
+static unsigned int nf_conntrack_next_id = 1;
+static unsigned int nf_conntrack_expect_next_id = 1;
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
 struct notifier_block *nf_conntrack_chain;
 struct notifier_block *nf_conntrack_expect_chain;
@@ -184,7 +186,7 @@ DECLARE_MUTEX(nf_ct_cache_mutex);
 
 extern struct nf_conntrack_protocol nf_conntrack_generic_protocol;
 struct nf_conntrack_protocol *
-nf_ct_find_proto(u_int16_t l3proto, u_int8_t protocol)
+__nf_ct_proto_find(u_int16_t l3proto, u_int8_t protocol)
 {
 	if (unlikely(nf_ct_protos[l3proto] == NULL))
 		return &nf_conntrack_generic_protocol;
@@ -192,6 +194,50 @@ nf_ct_find_proto(u_int16_t l3proto, u_in
 	return nf_ct_protos[l3proto][protocol];
 }
 
+/* this is guaranteed to always return a valid protocol helper, since
+ * it falls back to generic_protocol */
+struct nf_conntrack_protocol *
+nf_ct_proto_find_get(u_int16_t l3proto, u_int8_t protocol)
+{
+	struct nf_conntrack_protocol *p;
+
+	preempt_disable();
+	p = __nf_ct_proto_find(l3proto, protocol);
+	if (p) {
+		if (!try_module_get(p->me))
+			p = &nf_conntrack_generic_protocol;
+	}
+	preempt_enable();
+	
+	return p;
+}
+
+void nf_ct_proto_put(struct nf_conntrack_protocol *p)
+{
+	module_put(p->me);
+}
+
+struct nf_conntrack_l3proto *
+nf_ct_l3proto_find_get(u_int16_t l3proto)
+{
+	struct nf_conntrack_l3proto *p;
+
+	preempt_disable();
+	p = __nf_ct_l3proto_find(l3proto);
+	if (p) {
+		if (!try_module_get(p->me))
+			p = &nf_conntrack_generic_l3proto;
+	}
+	preempt_enable();
+
+	return p;
+}
+
+void nf_ct_l3proto_put(struct nf_conntrack_l3proto *p)
+{
+	module_put(p->me);
+}
+
 static int nf_conntrack_hash_rnd_initted;
 static unsigned int nf_conntrack_hash_rnd;
 
@@ -384,7 +430,7 @@ nf_ct_invert_tuple(struct nf_conntrack_t
 }
 
 /* nf_conntrack_expect helper functions */
-static void nf_ct_unlink_expect(struct nf_conntrack_expect *exp)
+void nf_ct_unlink_expect(struct nf_conntrack_expect *exp)
 {
 	ASSERT_WRITE_LOCK(&nf_conntrack_lock);
 	NF_CT_ASSERT(!timer_pending(&exp->timeout));
@@ -404,6 +450,33 @@ static void expectation_timed_out(unsign
 	nf_conntrack_expect_put(exp);
 }
 
+struct nf_conntrack_expect *
+__nf_conntrack_expect_find(const struct nf_conntrack_tuple *tuple)
+{
+	struct nf_conntrack_expect *i;
+	
+	list_for_each_entry(i, &nf_conntrack_expect_list, list) {
+		if (nf_ct_tuple_mask_cmp(tuple, &i->tuple, &i->mask)) {
+			atomic_inc(&i->use);
+			return i;
+		}
+	}
+	return NULL;
+}
+
+/* Just find a expectation corresponding to a tuple. */
+struct nf_conntrack_expect *
+nf_conntrack_expect_find(const struct nf_conntrack_tuple *tuple)
+{
+	struct nf_conntrack_expect *i;
+	
+	read_lock_bh(&nf_conntrack_lock);
+	i = __nf_conntrack_expect_find(tuple);
+	read_unlock_bh(&nf_conntrack_lock);
+
+	return i;
+}
+
 /* If an expectation for this connection is found, it gets delete from
  * global list then returned. */
 static struct nf_conntrack_expect *
@@ -432,7 +505,7 @@ find_expectation(const struct nf_conntra
 }
 
 /* delete all expectations for this conntrack */
-static void remove_expectations(struct nf_conn *ct)
+void nf_ct_remove_expectations(struct nf_conn *ct)
 {
 	struct nf_conntrack_expect *i, *tmp;
 
@@ -462,7 +535,7 @@ clean_from_lists(struct nf_conn *ct)
 	LIST_DELETE(&nf_conntrack_hash[hr], &ct->tuplehash[IP_CT_DIR_REPLY]);
 
 	/* Destroy all pending expectations */
-	remove_expectations(ct);
+	nf_ct_remove_expectations(ct);
 }
 
 static void
@@ -482,12 +555,11 @@ destroy_conntrack(struct nf_conntrack *n
 	/* To make sure we don't get any weird locking issues here:
 	 * destroy_conntrack() MUST NOT be called with a write lock
 	 * to nf_conntrack_lock!!! -HW */
-	l3proto = nf_ct_find_l3proto(ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.l3num);
+	l3proto = __nf_ct_l3proto_find(ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.l3num);
 	if (l3proto && l3proto->destroy)
 		l3proto->destroy(ct);
 
-	proto = nf_ct_find_proto(ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.l3num,
-				 ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.protonum);
+	proto = __nf_ct_proto_find(ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.l3num, ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.protonum);
 	if (proto && proto->destroy)
 		proto->destroy(ct);
 
@@ -499,7 +571,7 @@ destroy_conntrack(struct nf_conntrack *n
 	 * except TFTP can create an expectation on the first packet,
 	 * before connection is in the list, so we need to clean here,
 	 * too. */
-	remove_expectations(ct);
+	nf_ct_remove_expectations(ct);
 
 	/* We overload first tuple to link into unconfirmed list. */
 	if (!nf_ct_is_confirmed(ct)) {
@@ -540,7 +612,7 @@ conntrack_tuple_cmp(const struct nf_conn
 		&& nf_ct_tuple_equal(tuple, &i->tuple);
 }
 
-static struct nf_conntrack_tuple_hash *
+struct nf_conntrack_tuple_hash *
 __nf_conntrack_find(const struct nf_conntrack_tuple *tuple,
 		    const struct nf_conn *ignored_conntrack)
 {
@@ -575,6 +647,29 @@ nf_conntrack_find_get(const struct nf_co
 	return h;
 }
 
+static void __nf_conntrack_hash_insert(struct nf_conn *ct,
+				       unsigned int hash,
+				       unsigned int repl_hash) 
+{
+	ct->id = ++nf_conntrack_next_id;
+	list_prepend(&nf_conntrack_hash[hash],
+		     &ct->tuplehash[IP_CT_DIR_ORIGINAL].list);
+	list_prepend(&nf_conntrack_hash[repl_hash],
+		     &ct->tuplehash[IP_CT_DIR_REPLY].list);
+}
+
+void nf_conntrack_hash_insert(struct nf_conn *ct)
+{
+	unsigned int hash, repl_hash;
+
+	hash = hash_conntrack(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
+	repl_hash = hash_conntrack(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
+
+	write_lock_bh(&nf_conntrack_lock);
+	__nf_conntrack_hash_insert(ct, hash, repl_hash);
+	write_unlock_bh(&nf_conntrack_lock);
+}
+
 /* Confirm a connection given skb; places it in hash table */
 int
 __nf_conntrack_confirm(struct sk_buff **pskb)
@@ -621,10 +716,7 @@ __nf_conntrack_confirm(struct sk_buff **
 		/* Remove from unconfirmed list */
 		list_del(&ct->tuplehash[IP_CT_DIR_ORIGINAL].list);
 
-		list_prepend(&nf_conntrack_hash[hash],
-			     &ct->tuplehash[IP_CT_DIR_ORIGINAL]);
-		list_prepend(&nf_conntrack_hash[repl_hash],
-			     &ct->tuplehash[IP_CT_DIR_REPLY]);
+		__nf_conntrack_hash_insert(ct, hash, repl_hash);
 		/* Timer relative to confirmation time, not original
 		   setting time, otherwise we'd get timer wrap in
 		   weird delay cases. */
@@ -708,13 +800,41 @@ static inline int helper_cmp(const struc
 }
 
 static struct nf_conntrack_helper *
-nf_ct_find_helper(const struct nf_conntrack_tuple *tuple)
+__nf_ct_helper_find(const struct nf_conntrack_tuple *tuple)
 {
 	return LIST_FIND(&helpers, helper_cmp,
 			 struct nf_conntrack_helper *,
 			 tuple);
 }
 
+struct nf_conntrack_helper *
+nf_ct_helper_find_get( const struct nf_conntrack_tuple *tuple)
+{
+	struct nf_conntrack_helper *helper;
+
+	/* need nf_conntrack_lock to assure that helper exists until
+	 * try_module_get() is called */
+	read_lock_bh(&nf_conntrack_lock);
+
+	helper = __nf_ct_helper_find(tuple);
+	if (helper) {
+		/* need to increase module usage count to assure helper will
+		 * not go away while the caller is e.g. busy putting a
+		 * conntrack in the hash that uses the helper */
+		if (!try_module_get(helper->me))
+			helper = NULL;
+	}
+
+	read_unlock_bh(&nf_conntrack_lock);
+
+	return helper;
+}
+
+void nf_ct_helper_put(struct nf_conntrack_helper *helper)
+{
+	module_put(helper->me);
+}
+
 static struct nf_conn *
 __nf_conntrack_alloc(const struct nf_conntrack_tuple *orig,
 		     const struct nf_conntrack_tuple *repl,
@@ -744,7 +864,7 @@ __nf_conntrack_alloc(const struct nf_con
 	/*  find features needed by this conntrack. */
 	features = l3proto->get_features(orig);
 	read_lock_bh(&nf_conntrack_lock);
-	if (nf_ct_find_helper(repl) != NULL)
+	if (__nf_ct_helper_find(repl) != NULL)
 		features |= NF_CT_F_HELP;
 	read_unlock_bh(&nf_conntrack_lock);
 
@@ -794,7 +914,7 @@ struct nf_conn *nf_conntrack_alloc(const
 {
 	struct nf_conntrack_l3proto *l3proto;
 
-	l3proto = nf_ct_find_l3proto(orig->src.l3num);
+	l3proto = __nf_ct_l3proto_find(orig->src.l3num);
 	return __nf_conntrack_alloc(orig, repl, l3proto);
 }
 
@@ -853,7 +973,7 @@ init_conntrack(const struct nf_conntrack
 		nf_conntrack_get(&conntrack->master->ct_general);
 		NF_CT_STAT_INC(expect_new);
 	} else {
-		conntrack->helper = nf_ct_find_helper(&repl_tuple);
+		conntrack->helper = __nf_ct_helper_find(&repl_tuple);
 
 		NF_CT_STAT_INC(new);
         }
@@ -947,13 +1067,13 @@ nf_conntrack_in(int pf, unsigned int hoo
 		return NF_ACCEPT;
 	}
 
-	l3proto = nf_ct_find_l3proto((u_int16_t)pf);
+	l3proto = __nf_ct_l3proto_find((u_int16_t)pf);
 	if ((ret = l3proto->prepare(pskb, hooknum, &dataoff, &protonum)) <= 0) {
 		DEBUGP("not prepared to track yet or error occured\n");
 		return -ret;
 	}
 
-	proto = nf_ct_find_proto((u_int16_t)pf, protonum);
+	proto = __nf_ct_proto_find((u_int16_t)pf, protonum);
 
 	/* It may be an special packet, error, unclean...
 	 * inverse of the return code tells to the netfilter
@@ -1002,9 +1122,9 @@ int nf_ct_invert_tuplepr(struct nf_connt
 			 const struct nf_conntrack_tuple *orig)
 {
 	return nf_ct_invert_tuple(inverse, orig,
-				  nf_ct_find_l3proto(orig->src.l3num),
-				  nf_ct_find_proto(orig->src.l3num,
-						   orig->dst.protonum));
+				  __nf_ct_l3proto_find(orig->src.l3num),
+				  __nf_ct_proto_find(orig->src.l3num,
+						     orig->dst.protonum));
 }
 
 /* Would two expected things clash? */
@@ -1096,6 +1216,7 @@ static void nf_conntrack_expect_insert(s
 	exp->timeout.expires = jiffies + exp->master->helper->timeout * HZ;
 	add_timer(&exp->timeout);
 
+	exp->id = ++nf_conntrack_expect_next_id;
 	atomic_inc(&exp->use);
 	NF_CT_STAT_INC(expect_create);
 }
@@ -1175,7 +1296,7 @@ void nf_conntrack_alter_reply(struct nf_
 
 	conntrack->tuplehash[IP_CT_DIR_REPLY].tuple = *newreply;
 	if (!conntrack->master && conntrack->expecting == 0)
-		conntrack->helper = nf_ct_find_helper(newreply);
+		conntrack->helper = __nf_ct_helper_find(newreply);
 	write_unlock_bh(&nf_conntrack_lock);
 }
 
@@ -1200,6 +1321,19 @@ int nf_conntrack_helper_register(struct 
 	return 0;
 }
 
+struct nf_conntrack_helper *
+__nf_conntrack_helper_find_byname(const char *name)
+{
+	struct nf_conntrack_helper *h;
+
+	list_for_each_entry(h, &helpers, list) {
+		if (!strcmp(h->name, name))
+			return h;
+	}
+
+	return NULL;
+}
+
 static inline int unhelp(struct nf_conntrack_tuple_hash *i,
 			 const struct nf_conntrack_helper *me)
 {
@@ -1283,6 +1417,51 @@ void __nf_ct_refresh_acct(struct nf_conn
 		nf_conntrack_event_cache(event, skb);
 }
 
+#if defined(CONFIG_NF_CT_NETLINK) || \
+    defined(CONFIG_NF_CT_NETLINK_MODULE)
+
+#include <linux/netfilter/nfnetlink.h>
+#include <linux/netfilter/nfnetlink_conntrack.h>
+
+/* Generic function for tcp/udp/sctp/dccp and alike. This needs to be
+ * in ip_conntrack_core, since we don't want the protocols to autoload
+ * or depend on ctnetlink */
+int nf_ct_port_tuple_to_nfattr(struct sk_buff *skb,
+			       const struct nf_conntrack_tuple *tuple)
+{
+	NFA_PUT(skb, CTA_PROTO_SRC_PORT, sizeof(u_int16_t),
+		&tuple->src.u.tcp.port);
+	NFA_PUT(skb, CTA_PROTO_DST_PORT, sizeof(u_int16_t),
+		&tuple->dst.u.tcp.port);
+	return 0;
+
+nfattr_failure:
+	return -1;
+}
+
+static const size_t cta_min_proto[CTA_PROTO_MAX] = {
+	[CTA_PROTO_SRC_PORT-1]  = sizeof(u_int16_t),
+	[CTA_PROTO_DST_PORT-1]  = sizeof(u_int16_t)
+};
+
+int nf_ct_port_nfattr_to_tuple(struct nfattr *tb[],
+			       struct nf_conntrack_tuple *t)
+{
+	if (!tb[CTA_PROTO_SRC_PORT-1] || !tb[CTA_PROTO_DST_PORT-1])
+		return -EINVAL;
+
+	if (nfattr_bad_size(tb, CTA_PROTO_MAX, cta_min_proto))
+		return -EINVAL;
+
+	t->src.u.tcp.port =
+		*(u_int16_t *)NFA_DATA(tb[CTA_PROTO_SRC_PORT-1]);
+	t->dst.u.tcp.port =
+		*(u_int16_t *)NFA_DATA(tb[CTA_PROTO_DST_PORT-1]);
+
+	return 0;
+}
+#endif
+
 /* Used by ipt_REJECT and ip6t_REJECT. */
 void __nf_conntrack_attach(struct sk_buff *nskb, struct sk_buff *skb)
 {
@@ -1365,6 +1544,11 @@ static void free_conntrack_hash(struct l
 			   get_order(sizeof(struct list_head) * size));
 }
 
+void nf_conntrack_flush()
+{
+	nf_ct_iterate_cleanup(kill_all, NULL);
+}
+
 /* Mishearing the voices in his head, our hero wonders how he's
    supposed to kill the mall. */
 void nf_conntrack_cleanup(void)
@@ -1378,7 +1562,7 @@ void nf_conntrack_cleanup(void)
 
 	nf_ct_event_cache_flush();
  i_see_dead_people:
-	nf_ct_iterate_cleanup(kill_all, NULL);
+	nf_conntrack_flush();
 	if (atomic_read(&nf_conntrack_count) != 0) {
 		schedule();
 		goto i_see_dead_people;
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 5a6fcf3..cb32d22 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1136,6 +1136,63 @@ static int tcp_new(struct nf_conn *connt
 		receiver->td_scale);
 	return 1;
 }
+
+#if defined(CONFIG_NF_CT_NETLINK) || \
+    defined(CONFIG_NF_CT_NETLINK_MODULE)
+
+#include <linux/netfilter/nfnetlink.h>
+#include <linux/netfilter/nfnetlink_conntrack.h>
+
+static int tcp_to_nfattr(struct sk_buff *skb, struct nfattr *nfa,
+			 const struct nf_conn *ct)
+{
+	struct nfattr *nest_parms;
+	
+	read_lock_bh(&tcp_lock);
+	nest_parms = NFA_NEST(skb, CTA_PROTOINFO_TCP);
+	NFA_PUT(skb, CTA_PROTOINFO_TCP_STATE, sizeof(u_int8_t),
+		&ct->proto.tcp.state);
+	read_unlock_bh(&tcp_lock);
+
+	NFA_NEST_END(skb, nest_parms);
+
+	return 0;
+
+nfattr_failure:
+	read_unlock_bh(&tcp_lock);
+	return -1;
+}
+
+static const size_t cta_min_tcp[CTA_PROTOINFO_TCP_MAX] = {
+	[CTA_PROTOINFO_TCP_STATE-1]	= sizeof(u_int8_t),
+};
+
+static int nfattr_to_tcp(struct nfattr *cda[], struct nf_conn *ct)
+{
+	struct nfattr *attr = cda[CTA_PROTOINFO_TCP-1];
+	struct nfattr *tb[CTA_PROTOINFO_TCP_MAX];
+
+	/* updates could not contain anything about the private
+	 * protocol info, in that case skip the parsing */
+	if (!attr)
+		return 0;
+
+        nfattr_parse_nested(tb, CTA_PROTOINFO_TCP_MAX, attr);
+
+	if (nfattr_bad_size(tb, CTA_PROTOINFO_TCP_MAX, cta_min_tcp))
+		return -EINVAL;
+
+	if (!tb[CTA_PROTOINFO_TCP_STATE-1])
+		return -EINVAL;
+
+	write_lock_bh(&tcp_lock);
+	ct->proto.tcp.state = 
+		*(u_int8_t *)NFA_DATA(tb[CTA_PROTOINFO_TCP_STATE-1]);
+	write_unlock_bh(&tcp_lock);
+
+	return 0;
+}
+#endif
   
 struct nf_conntrack_protocol nf_conntrack_protocol_tcp4 =
 {
@@ -1149,6 +1206,13 @@ struct nf_conntrack_protocol nf_conntrac
 	.packet 		= tcp_packet,
 	.new 			= tcp_new,
 	.error			= tcp_error4,
+#if defined(CONFIG_NF_CT_NETLINK) || \
+    defined(CONFIG_NF_CT_NETLINK_MODULE)
+	.to_nfattr		= tcp_to_nfattr,
+	.from_nfattr		= nfattr_to_tcp,
+	.tuple_to_nfattr	= nf_ct_port_tuple_to_nfattr,
+	.nfattr_to_tuple	= nf_ct_port_nfattr_to_tuple,
+#endif
 };
 
 struct nf_conntrack_protocol nf_conntrack_protocol_tcp6 =
@@ -1163,6 +1227,13 @@ struct nf_conntrack_protocol nf_conntrac
 	.packet 		= tcp_packet,
 	.new 			= tcp_new,
 	.error			= tcp_error6,
+#if defined(CONFIG_NF_CT_NETLINK) || \
+    defined(CONFIG_NF_CT_NETLINK_MODULE)
+	.to_nfattr		= tcp_to_nfattr,
+	.from_nfattr		= nfattr_to_tcp,
+	.tuple_to_nfattr	= nf_ct_port_tuple_to_nfattr,
+	.nfattr_to_tuple	= nf_ct_port_nfattr_to_tuple,
+#endif
 };
 
 EXPORT_SYMBOL(nf_conntrack_protocol_tcp4);
diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index 3cae7ce..1a592a5 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -196,6 +196,11 @@ struct nf_conntrack_protocol nf_conntrac
 	.packet			= udp_packet,
 	.new			= udp_new,
 	.error			= udp_error4,
+#if defined(CONFIG_NF_CT_NETLINK) || \
+    defined(CONFIG_NF_CT_NETLINK_MODULE)
+	.tuple_to_nfattr	= nf_ct_port_tuple_to_nfattr,
+	.nfattr_to_tuple	= nf_ct_port_nfattr_to_tuple,
+#endif
 };
 
 struct nf_conntrack_protocol nf_conntrack_protocol_udp6 =
@@ -210,6 +215,11 @@ struct nf_conntrack_protocol nf_conntrac
 	.packet			= udp_packet,
 	.new			= udp_new,
 	.error			= udp_error6,
+#if defined(CONFIG_NF_CT_NETLINK) || \
+    defined(CONFIG_NF_CT_NETLINK_MODULE)
+	.tuple_to_nfattr	= nf_ct_port_tuple_to_nfattr,
+	.nfattr_to_tuple	= nf_ct_port_nfattr_to_tuple,
+#endif
 };
 
 EXPORT_SYMBOL(nf_conntrack_protocol_udp4);
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 5af381f..4c82f37 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -161,14 +161,14 @@ static int ct_seq_show(struct seq_file *
 	if (NF_CT_DIRECTION(hash))
 		return 0;
 
-	l3proto = nf_ct_find_l3proto(conntrack->tuplehash[IP_CT_DIR_ORIGINAL]
-				     .tuple.src.l3num);
+	l3proto = __nf_ct_l3proto_find(conntrack->tuplehash[IP_CT_DIR_ORIGINAL]
+				       .tuple.src.l3num);
 
 	NF_CT_ASSERT(l3proto);
-	proto = nf_ct_find_proto(conntrack->tuplehash[IP_CT_DIR_ORIGINAL]
-				 .tuple.src.l3num,
-				 conntrack->tuplehash[IP_CT_DIR_ORIGINAL]
-				 .tuple.dst.protonum);
+	proto = __nf_ct_proto_find(conntrack->tuplehash[IP_CT_DIR_ORIGINAL]
+				   .tuple.src.l3num,
+				   conntrack->tuplehash[IP_CT_DIR_ORIGINAL]
+				   .tuple.dst.protonum);
 	NF_CT_ASSERT(proto);
 
 	if (seq_printf(s, "%-8s %u %-8s %u %ld ",
@@ -307,9 +307,9 @@ static int exp_seq_show(struct seq_file 
 		   expect->tuple.src.l3num,
 		   expect->tuple.dst.protonum);
 	print_tuple(s, &expect->tuple,
-		    nf_ct_find_l3proto(expect->tuple.src.l3num),
-		    nf_ct_find_proto(expect->tuple.src.l3num,
-				     expect->tuple.dst.protonum));
+		    __nf_ct_l3proto_find(expect->tuple.src.l3num),
+		    __nf_ct_proto_find(expect->tuple.src.l3num,
+				       expect->tuple.dst.protonum));
 	return seq_putc(s, '\n');
 }
 
@@ -847,7 +847,11 @@ EXPORT_SYMBOL(nf_conntrack_helper_unregi
 EXPORT_SYMBOL(nf_ct_iterate_cleanup);
 EXPORT_SYMBOL(__nf_ct_refresh_acct);
 EXPORT_SYMBOL(nf_ct_protos);
-EXPORT_SYMBOL(nf_ct_find_proto);
+EXPORT_SYMBOL(__nf_ct_proto_find);
+EXPORT_SYMBOL(nf_ct_proto_find_get);
+EXPORT_SYMBOL(nf_ct_proto_put);
+EXPORT_SYMBOL(nf_ct_l3proto_find_get);
+EXPORT_SYMBOL(nf_ct_l3proto_put);
 EXPORT_SYMBOL(nf_ct_l3protos);
 EXPORT_SYMBOL(nf_conntrack_expect_alloc);
 EXPORT_SYMBOL(nf_conntrack_expect_put);
@@ -867,3 +871,18 @@ EXPORT_SYMBOL(nf_ct_get_tuple);
 EXPORT_SYMBOL(nf_ct_invert_tuple);
 EXPORT_SYMBOL(nf_conntrack_in);
 EXPORT_SYMBOL(__nf_conntrack_attach);
+EXPORT_SYMBOL(nf_conntrack_alloc);
+EXPORT_SYMBOL(nf_conntrack_free);
+EXPORT_SYMBOL(nf_conntrack_flush);
+EXPORT_SYMBOL(nf_ct_remove_expectations);
+EXPORT_SYMBOL(nf_ct_helper_find_get);
+EXPORT_SYMBOL(nf_ct_helper_put);
+EXPORT_SYMBOL(__nf_conntrack_helper_find_byname);
+EXPORT_SYMBOL(__nf_conntrack_find);
+EXPORT_SYMBOL(nf_ct_unlink_expect);
+EXPORT_SYMBOL(nf_conntrack_hash_insert);
+EXPORT_SYMBOL(__nf_conntrack_expect_find);
+EXPORT_SYMBOL(nf_conntrack_expect_find);
+EXPORT_SYMBOL(nf_conntrack_expect_list);
+EXPORT_SYMBOL(nf_ct_port_tuple_to_nfattr);
+EXPORT_SYMBOL(nf_ct_port_nfattr_to_tuple);

--------------050000040707000002080806--
