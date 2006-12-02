From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 08/20]: Add NAT support for nf_conntrack
Date: Sat,  2 Dec 2006 15:49:48 +0100 (MET)
Message-ID: <20061202145252.1381.2259.sendpatchset@localhost.localdomain>
References: <20061202145241.1381.88698.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20061202145241.1381.88698.sendpatchset@localhost.localdomain>
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

[NETFILTER]: Add NAT support for nf_conntrack

Add NAT support for nf_conntrack. Joint work of Jozsef Kadlecsik,
Yasuyuki Kozakai, Martin Josefsson and myself.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 1c341bc77a3d189d65ce0455640ac03a1dc293da
tree 57109aec020a31d86ed8df9642a70d7e425d6ee2
parent 970f82888147acc34d493064dfe66d4374063e90
author Patrick McHardy <kaber@trash.net> Sat, 02 Dec 2006 15:34:04 +0100
committer Patrick McHardy <kaber@trash.net> Sat, 02 Dec 2006 15:34:04 +0100

 include/linux/netfilter.h                      |    2 
 include/net/netfilter/ipv4/nf_conntrack_ipv4.h |   20 -
 include/net/netfilter/nf_conntrack.h           |   29 +
 include/net/netfilter/nf_conntrack_expect.h    |    2 
 include/net/netfilter/nf_nat.h                 |   77 +++
 include/net/netfilter/nf_nat_core.h            |   27 +
 include/net/netfilter/nf_nat_helper.h          |   32 +
 include/net/netfilter/nf_nat_protocol.h        |   70 +++
 include/net/netfilter/nf_nat_rule.h            |   35 +
 net/ipv4/netfilter/Kconfig                     |   30 +
 net/ipv4/netfilter/Makefile                    |    7 
 net/ipv4/netfilter/ip_nat_standalone.c         |    6 
 net/ipv4/netfilter/ipt_MASQUERADE.c            |   29 +
 net/ipv4/netfilter/ipt_NETMAP.c                |    4 
 net/ipv4/netfilter/ipt_REDIRECT.c              |    6 
 net/ipv4/netfilter/ipt_SAME.c                  |   12 
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    7 
 net/ipv4/netfilter/nf_nat_core.c               |  647 ++++++++++++++++++++++++
 net/ipv4/netfilter/nf_nat_helper.c             |  433 ++++++++++++++++
 net/ipv4/netfilter/nf_nat_proto_icmp.c         |   86 +++
 net/ipv4/netfilter/nf_nat_proto_tcp.c          |  148 +++++
 net/ipv4/netfilter/nf_nat_proto_udp.c          |  138 +++++
 net/ipv4/netfilter/nf_nat_proto_unknown.c      |   54 ++
 net/ipv4/netfilter/nf_nat_rule.c               |  343 +++++++++++++
 net/ipv4/netfilter/nf_nat_standalone.c         |  406 +++++++++++++++
 net/netfilter/nf_conntrack_core.c              |   23 +
 net/netfilter/nf_conntrack_netlink.c           |   46 +-
 net/netfilter/nf_conntrack_proto_tcp.c         |    2 
 net/netfilter/nf_conntrack_standalone.c        |    5 
 29 files changed, 2667 insertions(+), 59 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index f6f3fcb..d4c4c51 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -357,7 +357,7 @@ extern void (*ip_nat_decode_session)(str
 static inline void
 nf_nat_decode_session(struct sk_buff *skb, struct flowi *fl, int family)
 {
-#ifdef CONFIG_IP_NF_NAT_NEEDED
+#if defined(CONFIG_IP_NF_NAT_NEEDED) || defined(CONFIG_NF_NAT_NEEDED)
 	void (*decodefn)(struct sk_buff *, struct flowi *);
 
 	if (family == AF_INET && (decodefn = ip_nat_decode_session) != NULL)
diff --git a/include/net/netfilter/ipv4/nf_conntrack_ipv4.h b/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
index 34b453a..a1c57ee 100644
--- a/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
+++ b/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
@@ -9,29 +9,23 @@
 #ifndef _NF_CONNTRACK_IPV4_H
 #define _NF_CONNTRACK_IPV4_H
 
-#ifdef CONFIG_IP_NF_NAT_NEEDED
-#include <linux/netfilter_ipv4/ip_nat.h>
+#ifdef CONFIG_NF_NAT_NEEDED
+#include <net/netfilter/nf_nat.h>
 
 /* per conntrack: nat application helper private data */
-union ip_conntrack_nat_help {
+union nf_conntrack_nat_help {
         /* insert nat helper private data here */
 };
 
-struct nf_conntrack_ipv4_nat {
-	struct ip_nat_info info;
-	union ip_conntrack_nat_help help;
+struct nf_conn_nat {
+	struct nf_nat_info info;
+	union nf_conntrack_nat_help help;
 #if defined(CONFIG_IP_NF_TARGET_MASQUERADE) || \
 	defined(CONFIG_IP_NF_TARGET_MASQUERADE_MODULE)
 	int masq_index;
 #endif
 };
-#endif /* CONFIG_IP_NF_NAT_NEEDED */
-
-struct nf_conntrack_ipv4 {
-#ifdef CONFIG_IP_NF_NAT_NEEDED
-	struct nf_conntrack_ipv4_nat *nat;
-#endif
-};
+#endif /* CONFIG_NF_NAT_NEEDED */
 
 /* Returns new sk_buff, or NULL */
 struct sk_buff *
diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index b4beb8c..9948af0 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -264,18 +264,45 @@ nf_conntrack_unregister_cache(u_int32_t 
 
 /* valid combinations:
  * basic: nf_conn, nf_conn .. nf_conn_help
- * nat: nf_conn .. nf_conn_nat, nf_conn .. nf_conn_nat, nf_conn help
+ * nat: nf_conn .. nf_conn_nat, nf_conn .. nf_conn_nat .. nf_conn help
  */
+#ifdef CONFIG_NF_NAT_NEEDED
+static inline struct nf_conn_nat *nfct_nat(const struct nf_conn *ct)
+{
+	unsigned int offset = sizeof(struct nf_conn);
+
+	if (!(ct->features & NF_CT_F_NAT))
+		return NULL;
+
+	offset = ALIGN(offset, __alignof__(struct nf_conn_nat));
+	return (struct nf_conn_nat *) ((void *)ct + offset);
+}
+
 static inline struct nf_conn_help *nfct_help(const struct nf_conn *ct)
 {
 	unsigned int offset = sizeof(struct nf_conn);
 
 	if (!(ct->features & NF_CT_F_HELP))
 		return NULL;
+	if (ct->features & NF_CT_F_NAT) {
+		offset = ALIGN(offset, __alignof__(struct nf_conn_nat));
+		offset += sizeof(struct nf_conn_nat);
+	}
 
 	offset = ALIGN(offset, __alignof__(struct nf_conn_help));
 	return (struct nf_conn_help *) ((void *)ct + offset);
 }
+#else /* No NAT */
+static inline struct nf_conn_help *nfct_help(const struct nf_conn *ct)
+{
+	unsigned int offset = sizeof(struct nf_conn);
+
+	if (!(ct->features & NF_CT_F_HELP))
+		return NULL;
 
+	offset = ALIGN(offset, __alignof__(struct nf_conn_help));
+	return (struct nf_conn_help *) ((void *)ct + offset);
+}
+#endif /* CONFIG_NF_NAT_NEEDED */
 #endif /* __KERNEL__ */
 #endif /* _NF_CONNTRACK_H */
diff --git a/include/net/netfilter/nf_conntrack_expect.h b/include/net/netfilter/nf_conntrack_expect.h
index 5d853e8..b969c43 100644
--- a/include/net/netfilter/nf_conntrack_expect.h
+++ b/include/net/netfilter/nf_conntrack_expect.h
@@ -43,7 +43,7 @@ struct nf_conntrack_expect
 #ifdef CONFIG_NF_NAT_NEEDED
 	/* This is the original per-proto part, used to map the
 	 * expected connection the way the recipient expects. */
-	union nf_conntrack_manip_proto saved_proto;
+	union nf_conntrack_man_proto saved_proto;
 	/* Direction relative to the master connection. */
 	enum ip_conntrack_dir dir;
 #endif
diff --git a/include/net/netfilter/nf_nat.h b/include/net/netfilter/nf_nat.h
new file mode 100644
index 0000000..61c6206
--- /dev/null
+++ b/include/net/netfilter/nf_nat.h
@@ -0,0 +1,77 @@
+#ifndef _NF_NAT_H
+#define _NF_NAT_H
+#include <linux/netfilter_ipv4.h>
+#include <net/netfilter/nf_conntrack_tuple.h>
+
+#define NF_NAT_MAPPING_TYPE_MAX_NAMELEN 16
+
+enum nf_nat_manip_type
+{
+	IP_NAT_MANIP_SRC,
+	IP_NAT_MANIP_DST
+};
+
+/* SRC manip occurs POST_ROUTING or LOCAL_IN */
+#define HOOK2MANIP(hooknum) ((hooknum) != NF_IP_POST_ROUTING && (hooknum) != NF_IP_LOCAL_IN)
+
+#define IP_NAT_RANGE_MAP_IPS 1
+#define IP_NAT_RANGE_PROTO_SPECIFIED 2
+
+/* NAT sequence number modifications */
+struct nf_nat_seq {
+	/* position of the last TCP sequence number modification (if any) */
+	u_int32_t correction_pos;
+
+	/* sequence number offset before and after last modification */
+	int16_t offset_before, offset_after;
+};
+
+/* Single range specification. */
+struct nf_nat_range
+{
+	/* Set to OR of flags above. */
+	unsigned int flags;
+
+	/* Inclusive: network order. */
+	__be32 min_ip, max_ip;
+
+	/* Inclusive: network order */
+	union nf_conntrack_man_proto min, max;
+};
+
+/* For backwards compat: don't use in modern code. */
+struct nf_nat_multi_range_compat
+{
+	unsigned int rangesize; /* Must be 1. */
+
+	/* hangs off end. */
+	struct nf_nat_range range[1];
+};
+
+#ifdef __KERNEL__
+#include <linux/list.h>
+
+/* The structure embedded in the conntrack structure. */
+struct nf_nat_info
+{
+	struct list_head bysource;
+	struct nf_nat_seq seq[IP_CT_DIR_MAX];
+};
+
+struct nf_conn;
+
+/* Set up the info structure to map into this range. */
+extern unsigned int nf_nat_setup_info(struct nf_conn *ct,
+				      const struct nf_nat_range *range,
+				      unsigned int hooknum);
+
+/* Is this tuple already taken? (not by us)*/
+extern int nf_nat_used_tuple(const struct nf_conntrack_tuple *tuple,
+			     const struct nf_conn *ignored_conntrack);
+
+extern int nf_nat_module_is_loaded;
+
+#else  /* !__KERNEL__: iptables wants this to compile. */
+#define nf_nat_multi_range nf_nat_multi_range_compat
+#endif /*__KERNEL__*/
+#endif
diff --git a/include/net/netfilter/nf_nat_core.h b/include/net/netfilter/nf_nat_core.h
new file mode 100644
index 0000000..9778ffa
--- /dev/null
+++ b/include/net/netfilter/nf_nat_core.h
@@ -0,0 +1,27 @@
+#ifndef _NF_NAT_CORE_H
+#define _NF_NAT_CORE_H
+#include <linux/list.h>
+#include <net/netfilter/nf_conntrack.h>
+
+/* This header used to share core functionality between the standalone
+   NAT module, and the compatibility layer's use of NAT for masquerading. */
+
+extern unsigned int nf_nat_packet(struct nf_conn *ct,
+				  enum ip_conntrack_info ctinfo,
+				  unsigned int hooknum,
+				  struct sk_buff **pskb);
+
+extern int nf_nat_icmp_reply_translation(struct nf_conn *ct,
+					 enum ip_conntrack_info ctinfo,
+					 unsigned int hooknum,
+					 struct sk_buff **pskb);
+
+static inline int nf_nat_initialized(struct nf_conn *ct,
+				     enum nf_nat_manip_type manip)
+{
+	if (manip == IP_NAT_MANIP_SRC)
+		return test_bit(IPS_SRC_NAT_DONE_BIT, &ct->status);
+	else
+		return test_bit(IPS_DST_NAT_DONE_BIT, &ct->status);
+}
+#endif /* _NF_NAT_CORE_H */
diff --git a/include/net/netfilter/nf_nat_helper.h b/include/net/netfilter/nf_nat_helper.h
new file mode 100644
index 0000000..ec98ecf
--- /dev/null
+++ b/include/net/netfilter/nf_nat_helper.h
@@ -0,0 +1,32 @@
+#ifndef _NF_NAT_HELPER_H
+#define _NF_NAT_HELPER_H
+/* NAT protocol helper routines. */
+
+#include <net/netfilter/nf_conntrack.h>
+
+struct sk_buff;
+
+/* These return true or false. */
+extern int nf_nat_mangle_tcp_packet(struct sk_buff **skb,
+				    struct nf_conn *ct,
+				    enum ip_conntrack_info ctinfo,
+				    unsigned int match_offset,
+				    unsigned int match_len,
+				    const char *rep_buffer,
+				    unsigned int rep_len);
+extern int nf_nat_mangle_udp_packet(struct sk_buff **skb,
+				    struct nf_conn *ct,
+				    enum ip_conntrack_info ctinfo,
+				    unsigned int match_offset,
+				    unsigned int match_len,
+				    const char *rep_buffer,
+				    unsigned int rep_len);
+extern int nf_nat_seq_adjust(struct sk_buff **pskb,
+			     struct nf_conn *ct,
+			     enum ip_conntrack_info ctinfo);
+
+/* Setup NAT on this expected conntrack so it follows master, but goes
+ * to port ct->master->saved_proto. */
+extern void nf_nat_follow_master(struct nf_conn *ct,
+				 struct nf_conntrack_expect *this);
+#endif
diff --git a/include/net/netfilter/nf_nat_protocol.h b/include/net/netfilter/nf_nat_protocol.h
new file mode 100644
index 0000000..a9ec5ef
--- /dev/null
+++ b/include/net/netfilter/nf_nat_protocol.h
@@ -0,0 +1,70 @@
+/* Header for use in defining a given protocol. */
+#ifndef _NF_NAT_PROTOCOL_H
+#define _NF_NAT_PROTOCOL_H
+#include <net/netfilter/nf_nat.h>
+#include <linux/netfilter/nfnetlink_conntrack.h>
+
+struct nf_nat_range;
+
+struct nf_nat_protocol
+{
+	/* Protocol name */
+	const char *name;
+
+	/* Protocol number. */
+	unsigned int protonum;
+
+	struct module *me;
+
+	/* Translate a packet to the target according to manip type.
+	   Return true if succeeded. */
+	int (*manip_pkt)(struct sk_buff **pskb,
+			 unsigned int iphdroff,
+			 const struct nf_conntrack_tuple *tuple,
+			 enum nf_nat_manip_type maniptype);
+
+	/* Is the manipable part of the tuple between min and max incl? */
+	int (*in_range)(const struct nf_conntrack_tuple *tuple,
+			enum nf_nat_manip_type maniptype,
+			const union nf_conntrack_man_proto *min,
+			const union nf_conntrack_man_proto *max);
+
+	/* Alter the per-proto part of the tuple (depending on
+	   maniptype), to give a unique tuple in the given range if
+	   possible; return false if not.  Per-protocol part of tuple
+	   is initialized to the incoming packet. */
+	int (*unique_tuple)(struct nf_conntrack_tuple *tuple,
+			    const struct nf_nat_range *range,
+			    enum nf_nat_manip_type maniptype,
+			    const struct nf_conn *ct);
+
+	int (*range_to_nfattr)(struct sk_buff *skb,
+			       const struct nf_nat_range *range);
+
+	int (*nfattr_to_range)(struct nfattr *tb[],
+			       struct nf_nat_range *range);
+};
+
+/* Protocol registration. */
+extern int nf_nat_protocol_register(struct nf_nat_protocol *proto);
+extern void nf_nat_protocol_unregister(struct nf_nat_protocol *proto);
+
+extern struct nf_nat_protocol *nf_nat_proto_find_get(u_int8_t protocol);
+extern void nf_nat_proto_put(struct nf_nat_protocol *proto);
+
+/* Built-in protocols. */
+extern struct nf_nat_protocol nf_nat_protocol_tcp;
+extern struct nf_nat_protocol nf_nat_protocol_udp;
+extern struct nf_nat_protocol nf_nat_protocol_icmp;
+extern struct nf_nat_protocol nf_nat_unknown_protocol;
+
+extern int init_protocols(void) __init;
+extern void cleanup_protocols(void);
+extern struct nf_nat_protocol *find_nat_proto(u_int16_t protonum);
+
+extern int nf_nat_port_range_to_nfattr(struct sk_buff *skb,
+				       const struct nf_nat_range *range);
+extern int nf_nat_port_nfattr_to_range(struct nfattr *tb[],
+				       struct nf_nat_range *range);
+
+#endif /*_NF_NAT_PROTO_H*/
diff --git a/include/net/netfilter/nf_nat_rule.h b/include/net/netfilter/nf_nat_rule.h
new file mode 100644
index 0000000..f191c67
--- /dev/null
+++ b/include/net/netfilter/nf_nat_rule.h
@@ -0,0 +1,35 @@
+#ifndef _NF_NAT_RULE_H
+#define _NF_NAT_RULE_H
+#include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_nat.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+
+/* Compatibility definitions for ipt_FOO modules */
+#define ip_nat_range			nf_nat_range
+#define ip_conntrack_tuple		nf_conntrack_tuple
+#define ip_conntrack_get		nf_ct_get
+#define ip_conntrack			nf_conn
+#define ip_nat_setup_info		nf_nat_setup_info
+#define ip_nat_multi_range_compat	nf_nat_multi_range_compat
+#define ip_ct_iterate_cleanup		nf_ct_iterate_cleanup
+#define	IP_NF_ASSERT			NF_CT_ASSERT
+
+extern int nf_nat_rule_init(void) __init;
+extern void nf_nat_rule_cleanup(void);
+extern int nf_nat_rule_find(struct sk_buff **pskb,
+			    unsigned int hooknum,
+			    const struct net_device *in,
+			    const struct net_device *out,
+			    struct nf_conn *ct,
+			    struct nf_nat_info *info);
+
+extern unsigned int
+alloc_null_binding(struct nf_conn *ct,
+		   struct nf_nat_info *info,
+		   unsigned int hooknum);
+
+extern unsigned int
+alloc_null_binding_confirmed(struct nf_conn *ct,
+			     struct nf_nat_info *info,
+			     unsigned int hooknum);
+#endif /* _NF_NAT_RULE_H */
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 7148527..01789ae 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -6,7 +6,7 @@ menu "IP: Netfilter Configuration"
 	depends on INET && NETFILTER
 
 config NF_CONNTRACK_IPV4
-	tristate "IPv4 support for new connection tracking (EXPERIMENTAL)"
+	tristate "IPv4 support for new connection tracking (required for NAT) (EXPERIMENTAL)"
 	depends on EXPERIMENTAL && NF_CONNTRACK
 	---help---
 	  Connection tracking keeps a record of what packets have passed
@@ -387,7 +387,7 @@ config IP_NF_TARGET_TCPMSS
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
-# NAT + specific targets
+# NAT + specific targets: ip_conntrack
 config IP_NF_NAT
 	tristate "Full NAT"
 	depends on IP_NF_IPTABLES && IP_NF_CONNTRACK
@@ -398,14 +398,30 @@ config IP_NF_NAT
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+# NAT + specific targets: nf_conntrack
+config NF_NAT
+	tristate "Full NAT"
+	depends on IP_NF_IPTABLES && NF_CONNTRACK
+	help
+	  The Full NAT option allows masquerading, port forwarding and other
+	  forms of full Network Address Port Translation.  It is controlled by
+	  the `nat' table in iptables: see the man page for iptables(8).
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 config IP_NF_NAT_NEEDED
 	bool
-	depends on IP_NF_NAT != n
+	depends on IP_NF_NAT
+	default y
+
+config NF_NAT_NEEDED
+	bool
+	depends on NF_NAT
 	default y
 
 config IP_NF_TARGET_MASQUERADE
 	tristate "MASQUERADE target support"
-	depends on IP_NF_NAT
+	depends on (NF_NAT || IP_NF_NAT)
 	help
 	  Masquerading is a special case of NAT: all outgoing connections are
 	  changed to seem to come from a particular interface's address, and
@@ -417,7 +433,7 @@ config IP_NF_TARGET_MASQUERADE
 
 config IP_NF_TARGET_REDIRECT
 	tristate "REDIRECT target support"
-	depends on IP_NF_NAT
+	depends on (NF_NAT || IP_NF_NAT)
 	help
 	  REDIRECT is a special case of NAT: all incoming connections are
 	  mapped onto the incoming interface's address, causing the packets to
@@ -428,7 +444,7 @@ config IP_NF_TARGET_REDIRECT
 
 config IP_NF_TARGET_NETMAP
 	tristate "NETMAP target support"
-	depends on IP_NF_NAT
+	depends on (NF_NAT || IP_NF_NAT)
 	help
 	  NETMAP is an implementation of static 1:1 NAT mapping of network
 	  addresses. It maps the network address part, while keeping the host
@@ -439,7 +455,7 @@ config IP_NF_TARGET_NETMAP
 
 config IP_NF_TARGET_SAME
 	tristate "SAME target support"
-	depends on IP_NF_NAT
+	depends on (NF_NAT || IP_NF_NAT)
 	help
 	  This option adds a `SAME' target, which works like the standard SNAT
 	  target, but attempts to give clients the same IP for all connections.
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index 21359d8..ec31690 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -5,7 +5,12 @@ #
 # objects for the standalone - connection tracking / NAT
 ip_conntrack-objs	:= ip_conntrack_standalone.o ip_conntrack_core.o ip_conntrack_proto_generic.o ip_conntrack_proto_tcp.o ip_conntrack_proto_udp.o ip_conntrack_proto_icmp.o
 ip_nat-objs	:= ip_nat_core.o ip_nat_helper.o ip_nat_proto_unknown.o ip_nat_proto_tcp.o ip_nat_proto_udp.o ip_nat_proto_icmp.o
+nf_nat-objs	:= nf_nat_core.o nf_nat_helper.o nf_nat_proto_unknown.o nf_nat_proto_tcp.o nf_nat_proto_udp.o nf_nat_proto_icmp.o
+ifneq ($(CONFIG_NF_NAT),)
+iptable_nat-objs	:= nf_nat_rule.o nf_nat_standalone.o
+else
 iptable_nat-objs	:= ip_nat_rule.o ip_nat_standalone.o
+endif
 
 ip_conntrack_pptp-objs	:= ip_conntrack_helper_pptp.o ip_conntrack_proto_gre.o
 ip_nat_pptp-objs	:= ip_nat_helper_pptp.o ip_nat_proto_gre.o
@@ -16,6 +21,7 @@ ip_nat_h323-objs := ip_nat_helper_h323.o
 # connection tracking
 obj-$(CONFIG_IP_NF_CONNTRACK) += ip_conntrack.o
 obj-$(CONFIG_IP_NF_NAT) += ip_nat.o
+obj-$(CONFIG_NF_NAT) += nf_nat.o
 
 # conntrack netlink interface
 obj-$(CONFIG_IP_NF_CONNTRACK_NETLINK) += ip_conntrack_netlink.o
@@ -50,6 +56,7 @@ # the three instances of ip_tables
 obj-$(CONFIG_IP_NF_FILTER) += iptable_filter.o
 obj-$(CONFIG_IP_NF_MANGLE) += iptable_mangle.o
 obj-$(CONFIG_IP_NF_NAT) += iptable_nat.o
+obj-$(CONFIG_NF_NAT) += iptable_nat.o
 obj-$(CONFIG_IP_NF_RAW) += iptable_raw.o
 
 # matches
diff --git a/net/ipv4/netfilter/ip_nat_standalone.c b/net/ipv4/netfilter/ip_nat_standalone.c
index d85d2de..ad66328 100644
--- a/net/ipv4/netfilter/ip_nat_standalone.c
+++ b/net/ipv4/netfilter/ip_nat_standalone.c
@@ -44,12 +44,6 @@ #else
 #define DEBUGP(format, args...)
 #endif
 
-#define HOOKNAME(hooknum) ((hooknum) == NF_IP_POST_ROUTING ? "POST_ROUTING"  \
-			   : ((hooknum) == NF_IP_PRE_ROUTING ? "PRE_ROUTING" \
-			      : ((hooknum) == NF_IP_LOCAL_OUT ? "LOCAL_OUT"  \
-			         : ((hooknum) == NF_IP_LOCAL_IN ? "LOCAL_IN"  \
-				    : "*ERROR*")))
-
 #ifdef CONFIG_XFRM
 static void nat_decode_session(struct sk_buff *skb, struct flowi *fl)
 {
diff --git a/net/ipv4/netfilter/ipt_MASQUERADE.c b/net/ipv4/netfilter/ipt_MASQUERADE.c
index 3dbfcfa..28b9233 100644
--- a/net/ipv4/netfilter/ipt_MASQUERADE.c
+++ b/net/ipv4/netfilter/ipt_MASQUERADE.c
@@ -2,7 +2,7 @@
    (depending on route). */
 
 /* (C) 1999-2001 Paul `Rusty' Russell
- * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
+ * (C) 2002-2006 Netfilter Core Team <coreteam@netfilter.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -20,7 +20,11 @@ #include <net/ip.h>
 #include <net/checksum.h>
 #include <net/route.h>
 #include <linux/netfilter_ipv4.h>
+#ifdef CONFIG_NF_NAT_NEEDED
+#include <net/netfilter/nf_nat_rule.h>
+#else
 #include <linux/netfilter_ipv4/ip_nat_rule.h>
+#endif
 #include <linux/netfilter_ipv4/ip_tables.h>
 
 MODULE_LICENSE("GPL");
@@ -65,23 +69,33 @@ masquerade_target(struct sk_buff **pskb,
 		  const struct xt_target *target,
 		  const void *targinfo)
 {
+#ifdef CONFIG_NF_NAT_NEEDED
+	struct nf_conn_nat *nat;
+#endif
 	struct ip_conntrack *ct;
 	enum ip_conntrack_info ctinfo;
-	const struct ip_nat_multi_range_compat *mr;
 	struct ip_nat_range newrange;
+	const struct ip_nat_multi_range_compat *mr;
 	struct rtable *rt;
 	__be32 newsrc;
 
 	IP_NF_ASSERT(hooknum == NF_IP_POST_ROUTING);
 
 	ct = ip_conntrack_get(*pskb, &ctinfo);
+#ifdef CONFIG_NF_NAT_NEEDED
+	nat = nfct_nat(ct);
+#endif
 	IP_NF_ASSERT(ct && (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED
 	                    || ctinfo == IP_CT_RELATED + IP_CT_IS_REPLY));
 
 	/* Source address is 0.0.0.0 - locally generated packet that is
 	 * probably not supposed to be masqueraded.
 	 */
+#ifdef CONFIG_NF_NAT_NEEDED
+	if (ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u3.ip == 0)
+#else
 	if (ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip == 0)
+#endif
 		return NF_ACCEPT;
 
 	mr = targinfo;
@@ -93,7 +107,11 @@ masquerade_target(struct sk_buff **pskb,
 	}
 
 	write_lock_bh(&masq_lock);
+#ifdef CONFIG_NF_NAT_NEEDED
+	nat->masq_index = out->ifindex;
+#else
 	ct->nat.masq_index = out->ifindex;
+#endif
 	write_unlock_bh(&masq_lock);
 
 	/* Transfer from original range. */
@@ -109,10 +127,17 @@ masquerade_target(struct sk_buff **pskb,
 static inline int
 device_cmp(struct ip_conntrack *i, void *ifindex)
 {
+#ifdef CONFIG_NF_NAT_NEEDED
+	struct nf_conn_nat *nat = nfct_nat(i);
+#endif
 	int ret;
 
 	read_lock_bh(&masq_lock);
+#ifdef CONFIG_NF_NAT_NEEDED
+	ret = (nat->masq_index == (int)(long)ifindex);
+#else
 	ret = (i->nat.masq_index == (int)(long)ifindex);
+#endif
 	read_unlock_bh(&masq_lock);
 
 	return ret;
diff --git a/net/ipv4/netfilter/ipt_NETMAP.c b/net/ipv4/netfilter/ipt_NETMAP.c
index 58a88f2..9390e90 100644
--- a/net/ipv4/netfilter/ipt_NETMAP.c
+++ b/net/ipv4/netfilter/ipt_NETMAP.c
@@ -15,7 +15,11 @@ #include <linux/module.h>
 #include <linux/netdevice.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter_ipv4.h>
+#ifdef CONFIG_NF_NAT_NEEDED
+#include <net/netfilter/nf_nat_rule.h>
+#else
 #include <linux/netfilter_ipv4/ip_nat_rule.h>
+#endif
 
 #define MODULENAME "NETMAP"
 MODULE_LICENSE("GPL");
diff --git a/net/ipv4/netfilter/ipt_REDIRECT.c b/net/ipv4/netfilter/ipt_REDIRECT.c
index c0dcfe9..462eceb 100644
--- a/net/ipv4/netfilter/ipt_REDIRECT.c
+++ b/net/ipv4/netfilter/ipt_REDIRECT.c
@@ -1,6 +1,6 @@
 /* Redirect.  Simple mapping which alters dst to a local IP address. */
 /* (C) 1999-2001 Paul `Rusty' Russell
- * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
+ * (C) 2002-2006 Netfilter Core Team <coreteam@netfilter.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -18,7 +18,11 @@ #include <linux/inetdevice.h>
 #include <net/protocol.h>
 #include <net/checksum.h>
 #include <linux/netfilter_ipv4.h>
+#ifdef CONFIG_NF_NAT_NEEDED
+#include <net/netfilter/nf_nat_rule.h>
+#else
 #include <linux/netfilter_ipv4/ip_nat_rule.h>
+#endif
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
diff --git a/net/ipv4/netfilter/ipt_SAME.c b/net/ipv4/netfilter/ipt_SAME.c
index b38b133..3dcf294 100644
--- a/net/ipv4/netfilter/ipt_SAME.c
+++ b/net/ipv4/netfilter/ipt_SAME.c
@@ -34,7 +34,11 @@ #include <linux/inetdevice.h>
 #include <net/protocol.h>
 #include <net/checksum.h>
 #include <linux/netfilter_ipv4.h>
+#ifdef CONFIG_NF_NAT_NEEDED
+#include <net/netfilter/nf_nat_rule.h>
+#else
 #include <linux/netfilter_ipv4/ip_nat_rule.h>
+#endif
 #include <linux/netfilter_ipv4/ipt_SAME.h>
 
 MODULE_LICENSE("GPL");
@@ -152,11 +156,17 @@ same_target(struct sk_buff **pskb,
 	   Here we calculate the index in same->iparray which
 	   holds the ipaddress we should use */
 	
+#ifdef CONFIG_NF_NAT_NEEDED
+	tmpip = ntohl(t->src.u3.ip);
+
+	if (!(same->info & IPT_SAME_NODST))
+		tmpip += ntohl(t->dst.u3.ip);
+#else
 	tmpip = ntohl(t->src.ip);
 
 	if (!(same->info & IPT_SAME_NODST))
 		tmpip += ntohl(t->dst.ip);
-	
+#endif
 	aindex = tmpip % same->ipnum;
 
 	new_ip = htonl(same->iparray[aindex]);
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index 653f57b..5655109 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -111,10 +111,10 @@ ipv4_prepare(struct sk_buff **pskb, unsi
 	return NF_ACCEPT;
 }
 
-int nat_module_is_loaded = 0;
+int nf_nat_module_is_loaded = 0;
 static u_int32_t ipv4_get_features(const struct nf_conntrack_tuple *tuple)
 {
-	if (nat_module_is_loaded)
+	if (nf_nat_module_is_loaded)
 		return NF_CT_F_NAT;
 
 	return NF_CT_F_BASIC;
@@ -532,3 +532,6 @@ module_init(nf_conntrack_l3proto_ipv4_in
 module_exit(nf_conntrack_l3proto_ipv4_fini);
 
 EXPORT_SYMBOL(nf_ct_ipv4_gather_frags);
+#ifdef CONFIG_NF_NAT_NEEDED
+EXPORT_SYMBOL(nf_nat_module_is_loaded);
+#endif
diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
new file mode 100644
index 0000000..86a9227
--- /dev/null
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -0,0 +1,647 @@
+/* NAT for netfilter; shared with compatibility layer. */
+
+/* (C) 1999-2001 Paul `Rusty' Russell
+ * (C) 2002-2006 Netfilter Core Team <coreteam@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/timer.h>
+#include <linux/skbuff.h>
+#include <linux/vmalloc.h>
+#include <net/checksum.h>
+#include <net/icmp.h>
+#include <net/ip.h>
+#include <net/tcp.h>  /* For tcp_prot in getorigdst */
+#include <linux/icmp.h>
+#include <linux/udp.h>
+#include <linux/jhash.h>
+
+#include <linux/netfilter_ipv4.h>
+#include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_core.h>
+#include <net/netfilter/nf_nat.h>
+#include <net/netfilter/nf_nat_protocol.h>
+#include <net/netfilter/nf_nat_core.h>
+#include <net/netfilter/nf_nat_helper.h>
+#include <net/netfilter/nf_conntrack_helper.h>
+#include <net/netfilter/nf_conntrack_l3proto.h>
+#include <net/netfilter/nf_conntrack_l4proto.h>
+
+#if 0
+#define DEBUGP printk
+#else
+#define DEBUGP(format, args...)
+#endif
+
+static DEFINE_RWLOCK(nf_nat_lock);
+
+static struct nf_conntrack_l3proto *l3proto = NULL;
+
+/* Calculated at init based on memory size */
+static unsigned int nf_nat_htable_size;
+
+static struct list_head *bysource;
+
+#define MAX_IP_NAT_PROTO 256
+static struct nf_nat_protocol *nf_nat_protos[MAX_IP_NAT_PROTO];
+
+static inline struct nf_nat_protocol *
+__nf_nat_proto_find(u_int8_t protonum)
+{
+	return nf_nat_protos[protonum];
+}
+
+struct nf_nat_protocol *
+nf_nat_proto_find_get(u_int8_t protonum)
+{
+	struct nf_nat_protocol *p;
+
+	/* we need to disable preemption to make sure 'p' doesn't get
+	 * removed until we've grabbed the reference */
+	preempt_disable();
+	p = __nf_nat_proto_find(protonum);
+	if (!try_module_get(p->me))
+		p = &nf_nat_unknown_protocol;
+	preempt_enable();
+
+	return p;
+}
+EXPORT_SYMBOL_GPL(nf_nat_proto_find_get);
+
+void
+nf_nat_proto_put(struct nf_nat_protocol *p)
+{
+	module_put(p->me);
+}
+EXPORT_SYMBOL_GPL(nf_nat_proto_put);
+
+/* We keep an extra hash for each conntrack, for fast searching. */
+static inline unsigned int
+hash_by_src(const struct nf_conntrack_tuple *tuple)
+{
+	/* Original src, to ensure we map it consistently if poss. */
+	return jhash_3words((__force u32)tuple->src.u3.ip, tuple->src.u.all,
+			    tuple->dst.protonum, 0) % nf_nat_htable_size;
+}
+
+/* Noone using conntrack by the time this called. */
+static void nf_nat_cleanup_conntrack(struct nf_conn *conn)
+{
+	struct nf_conn_nat *nat;
+	if (!(conn->status & IPS_NAT_DONE_MASK))
+		return;
+
+	nat = nfct_nat(conn);
+	write_lock_bh(&nf_nat_lock);
+	list_del(&nat->info.bysource);
+	write_unlock_bh(&nf_nat_lock);
+}
+
+/* Is this tuple already taken? (not by us) */
+int
+nf_nat_used_tuple(const struct nf_conntrack_tuple *tuple,
+		  const struct nf_conn *ignored_conntrack)
+{
+	/* Conntrack tracking doesn't keep track of outgoing tuples; only
+	   incoming ones.  NAT means they don't have a fixed mapping,
+	   so we invert the tuple and look for the incoming reply.
+
+	   We could keep a separate hash if this proves too slow. */
+	struct nf_conntrack_tuple reply;
+
+	nf_ct_invert_tuplepr(&reply, tuple);
+	return nf_conntrack_tuple_taken(&reply, ignored_conntrack);
+}
+EXPORT_SYMBOL(nf_nat_used_tuple);
+
+/* If we source map this tuple so reply looks like reply_tuple, will
+ * that meet the constraints of range. */
+static int
+in_range(const struct nf_conntrack_tuple *tuple,
+	 const struct nf_nat_range *range)
+{
+	struct nf_nat_protocol *proto;
+
+	proto = __nf_nat_proto_find(tuple->dst.protonum);
+	/* If we are supposed to map IPs, then we must be in the
+	   range specified, otherwise let this drag us onto a new src IP. */
+	if (range->flags & IP_NAT_RANGE_MAP_IPS) {
+		if (ntohl(tuple->src.u3.ip) < ntohl(range->min_ip) ||
+		    ntohl(tuple->src.u3.ip) > ntohl(range->max_ip))
+			return 0;
+	}
+
+	if (!(range->flags & IP_NAT_RANGE_PROTO_SPECIFIED) ||
+	    proto->in_range(tuple, IP_NAT_MANIP_SRC,
+			    &range->min, &range->max))
+		return 1;
+
+	return 0;
+}
+
+static inline int
+same_src(const struct nf_conn *ct,
+	 const struct nf_conntrack_tuple *tuple)
+{
+	const struct nf_conntrack_tuple *t;
+
+	t = &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
+	return (t->dst.protonum == tuple->dst.protonum &&
+		t->src.u3.ip == tuple->src.u3.ip &&
+		t->src.u.all == tuple->src.u.all);
+}
+
+/* Only called for SRC manip */
+static int
+find_appropriate_src(const struct nf_conntrack_tuple *tuple,
+		     struct nf_conntrack_tuple *result,
+		     const struct nf_nat_range *range)
+{
+	unsigned int h = hash_by_src(tuple);
+	struct nf_conn_nat *nat;
+	struct nf_conn *ct;
+
+	read_lock_bh(&nf_nat_lock);
+	list_for_each_entry(nat, &bysource[h], info.bysource) {
+		ct = (struct nf_conn *)((char *)nat - offsetof(struct nf_conn, data));
+		if (same_src(ct, tuple)) {
+			/* Copy source part from reply tuple. */
+			nf_ct_invert_tuplepr(result,
+				       &ct->tuplehash[IP_CT_DIR_REPLY].tuple);
+			result->dst = tuple->dst;
+
+			if (in_range(result, range)) {
+				read_unlock_bh(&nf_nat_lock);
+				return 1;
+			}
+		}
+	}
+	read_unlock_bh(&nf_nat_lock);
+	return 0;
+}
+
+/* For [FUTURE] fragmentation handling, we want the least-used
+   src-ip/dst-ip/proto triple.  Fairness doesn't come into it.  Thus
+   if the range specifies 1.2.3.4 ports 10000-10005 and 1.2.3.5 ports
+   1-65535, we don't do pro-rata allocation based on ports; we choose
+   the ip with the lowest src-ip/dst-ip/proto usage.
+*/
+static void
+find_best_ips_proto(struct nf_conntrack_tuple *tuple,
+		    const struct nf_nat_range *range,
+		    const struct nf_conn *ct,
+		    enum nf_nat_manip_type maniptype)
+{
+	__be32 *var_ipp;
+	/* Host order */
+	u_int32_t minip, maxip, j;
+
+	/* No IP mapping?  Do nothing. */
+	if (!(range->flags & IP_NAT_RANGE_MAP_IPS))
+		return;
+
+	if (maniptype == IP_NAT_MANIP_SRC)
+		var_ipp = &tuple->src.u3.ip;
+	else
+		var_ipp = &tuple->dst.u3.ip;
+
+	/* Fast path: only one choice. */
+	if (range->min_ip == range->max_ip) {
+		*var_ipp = range->min_ip;
+		return;
+	}
+
+	/* Hashing source and destination IPs gives a fairly even
+	 * spread in practice (if there are a small number of IPs
+	 * involved, there usually aren't that many connections
+	 * anyway).  The consistency means that servers see the same
+	 * client coming from the same IP (some Internet Banking sites
+	 * like this), even across reboots. */
+	minip = ntohl(range->min_ip);
+	maxip = ntohl(range->max_ip);
+	j = jhash_2words((__force u32)tuple->src.u3.ip,
+			 (__force u32)tuple->dst.u3.ip, 0);
+	*var_ipp = htonl(minip + j % (maxip - minip + 1));
+}
+
+/* Manipulate the tuple into the range given.  For NF_IP_POST_ROUTING,
+ * we change the source to map into the range.  For NF_IP_PRE_ROUTING
+ * and NF_IP_LOCAL_OUT, we change the destination to map into the
+ * range.  It might not be possible to get a unique tuple, but we try.
+ * At worst (or if we race), we will end up with a final duplicate in
+ * __ip_conntrack_confirm and drop the packet. */
+static void
+get_unique_tuple(struct nf_conntrack_tuple *tuple,
+		 const struct nf_conntrack_tuple *orig_tuple,
+		 const struct nf_nat_range *range,
+		 struct nf_conn *ct,
+		 enum nf_nat_manip_type maniptype)
+{
+	struct nf_nat_protocol *proto;
+
+	/* 1) If this srcip/proto/src-proto-part is currently mapped,
+	   and that same mapping gives a unique tuple within the given
+	   range, use that.
+
+	   This is only required for source (ie. NAT/masq) mappings.
+	   So far, we don't do local source mappings, so multiple
+	   manips not an issue.  */
+	if (maniptype == IP_NAT_MANIP_SRC) {
+		if (find_appropriate_src(orig_tuple, tuple, range)) {
+			DEBUGP("get_unique_tuple: Found current src map\n");
+			if (!nf_nat_used_tuple(tuple, ct))
+				return;
+		}
+	}
+
+	/* 2) Select the least-used IP/proto combination in the given
+	   range. */
+	*tuple = *orig_tuple;
+	find_best_ips_proto(tuple, range, ct, maniptype);
+
+	/* 3) The per-protocol part of the manip is made to map into
+	   the range to make a unique tuple. */
+
+	proto = nf_nat_proto_find_get(orig_tuple->dst.protonum);
+
+	/* Only bother mapping if it's not already in range and unique */
+	if ((!(range->flags & IP_NAT_RANGE_PROTO_SPECIFIED) ||
+	     proto->in_range(tuple, maniptype, &range->min, &range->max)) &&
+	    !nf_nat_used_tuple(tuple, ct)) {
+		nf_nat_proto_put(proto);
+		return;
+	}
+
+	/* Last change: get protocol to try to obtain unique tuple. */
+	proto->unique_tuple(tuple, range, maniptype, ct);
+
+	nf_nat_proto_put(proto);
+}
+
+unsigned int
+nf_nat_setup_info(struct nf_conn *ct,
+		  const struct nf_nat_range *range,
+		  unsigned int hooknum)
+{
+	struct nf_conntrack_tuple curr_tuple, new_tuple;
+	struct nf_conn_nat *nat = nfct_nat(ct);
+	struct nf_nat_info *info = &nat->info;
+	int have_to_hash = !(ct->status & IPS_NAT_DONE_MASK);
+	enum nf_nat_manip_type maniptype = HOOK2MANIP(hooknum);
+
+	NF_CT_ASSERT(hooknum == NF_IP_PRE_ROUTING ||
+		     hooknum == NF_IP_POST_ROUTING ||
+		     hooknum == NF_IP_LOCAL_IN ||
+		     hooknum == NF_IP_LOCAL_OUT);
+	BUG_ON(nf_nat_initialized(ct, maniptype));
+
+	/* What we've got will look like inverse of reply. Normally
+	   this is what is in the conntrack, except for prior
+	   manipulations (future optimization: if num_manips == 0,
+	   orig_tp =
+	   conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple) */
+	nf_ct_invert_tuplepr(&curr_tuple,
+			     &ct->tuplehash[IP_CT_DIR_REPLY].tuple);
+
+	get_unique_tuple(&new_tuple, &curr_tuple, range, ct, maniptype);
+
+	if (!nf_ct_tuple_equal(&new_tuple, &curr_tuple)) {
+		struct nf_conntrack_tuple reply;
+
+		/* Alter conntrack table so will recognize replies. */
+		nf_ct_invert_tuplepr(&reply, &new_tuple);
+		nf_conntrack_alter_reply(ct, &reply);
+
+		/* Non-atomic: we own this at the moment. */
+		if (maniptype == IP_NAT_MANIP_SRC)
+			ct->status |= IPS_SRC_NAT;
+		else
+			ct->status |= IPS_DST_NAT;
+	}
+
+	/* Place in source hash if this is the first time. */
+	if (have_to_hash) {
+		unsigned int srchash;
+
+		srchash = hash_by_src(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
+		write_lock_bh(&nf_nat_lock);
+		list_add(&info->bysource, &bysource[srchash]);
+		write_unlock_bh(&nf_nat_lock);
+	}
+
+	/* It's done. */
+	if (maniptype == IP_NAT_MANIP_DST)
+		set_bit(IPS_DST_NAT_DONE_BIT, &ct->status);
+	else
+		set_bit(IPS_SRC_NAT_DONE_BIT, &ct->status);
+
+	return NF_ACCEPT;
+}
+EXPORT_SYMBOL(nf_nat_setup_info);
+
+/* Returns true if succeeded. */
+static int
+manip_pkt(u_int16_t proto,
+	  struct sk_buff **pskb,
+	  unsigned int iphdroff,
+	  const struct nf_conntrack_tuple *target,
+	  enum nf_nat_manip_type maniptype)
+{
+	struct iphdr *iph;
+	struct nf_nat_protocol *p;
+
+	if (!skb_make_writable(pskb, iphdroff + sizeof(*iph)))
+		return 0;
+
+	iph = (void *)(*pskb)->data + iphdroff;
+
+	/* Manipulate protcol part. */
+	p = nf_nat_proto_find_get(proto);
+	if (!p->manip_pkt(pskb, iphdroff, target, maniptype)) {
+		nf_nat_proto_put(p);
+		return 0;
+	}
+	nf_nat_proto_put(p);
+
+	iph = (void *)(*pskb)->data + iphdroff;
+
+	if (maniptype == IP_NAT_MANIP_SRC) {
+		nf_csum_replace4(&iph->check, iph->saddr, target->src.u3.ip);
+		iph->saddr = target->src.u3.ip;
+	} else {
+		nf_csum_replace4(&iph->check, iph->daddr, target->dst.u3.ip);
+		iph->daddr = target->dst.u3.ip;
+	}
+	return 1;
+}
+
+/* Do packet manipulations according to nf_nat_setup_info. */
+unsigned int nf_nat_packet(struct nf_conn *ct,
+			   enum ip_conntrack_info ctinfo,
+			   unsigned int hooknum,
+			   struct sk_buff **pskb)
+{
+	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
+	unsigned long statusbit;
+	enum nf_nat_manip_type mtype = HOOK2MANIP(hooknum);
+
+	if (mtype == IP_NAT_MANIP_SRC)
+		statusbit = IPS_SRC_NAT;
+	else
+		statusbit = IPS_DST_NAT;
+
+	/* Invert if this is reply dir. */
+	if (dir == IP_CT_DIR_REPLY)
+		statusbit ^= IPS_NAT_MASK;
+
+	/* Non-atomic: these bits don't change. */
+	if (ct->status & statusbit) {
+		struct nf_conntrack_tuple target;
+
+		/* We are aiming to look like inverse of other direction. */
+		nf_ct_invert_tuplepr(&target, &ct->tuplehash[!dir].tuple);
+
+		if (!manip_pkt(target.dst.protonum, pskb, 0, &target, mtype))
+			return NF_DROP;
+	}
+	return NF_ACCEPT;
+}
+EXPORT_SYMBOL_GPL(nf_nat_packet);
+
+/* Dir is direction ICMP is coming from (opposite to packet it contains) */
+int nf_nat_icmp_reply_translation(struct nf_conn *ct,
+				  enum ip_conntrack_info ctinfo,
+				  unsigned int hooknum,
+				  struct sk_buff **pskb)
+{
+	struct {
+		struct icmphdr icmp;
+		struct iphdr ip;
+	} *inside;
+	struct nf_conntrack_tuple inner, target;
+	int hdrlen = (*pskb)->nh.iph->ihl * 4;
+	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
+	unsigned long statusbit;
+	enum nf_nat_manip_type manip = HOOK2MANIP(hooknum);
+
+	if (!skb_make_writable(pskb, hdrlen + sizeof(*inside)))
+		return 0;
+
+	inside = (void *)(*pskb)->data + (*pskb)->nh.iph->ihl*4;
+
+	/* We're actually going to mangle it beyond trivial checksum
+	   adjustment, so make sure the current checksum is correct. */
+	if (nf_ip_checksum(*pskb, hooknum, hdrlen, 0))
+		return 0;
+
+	/* Must be RELATED */
+	NF_CT_ASSERT((*pskb)->nfctinfo == IP_CT_RELATED ||
+		     (*pskb)->nfctinfo == IP_CT_RELATED+IP_CT_IS_REPLY);
+
+	/* Redirects on non-null nats must be dropped, else they'll
+           start talking to each other without our translation, and be
+           confused... --RR */
+	if (inside->icmp.type == ICMP_REDIRECT) {
+		/* If NAT isn't finished, assume it and drop. */
+		if ((ct->status & IPS_NAT_DONE_MASK) != IPS_NAT_DONE_MASK)
+			return 0;
+
+		if (ct->status & IPS_NAT_MASK)
+			return 0;
+	}
+
+	DEBUGP("icmp_reply_translation: translating error %p manp %u dir %s\n",
+	       *pskb, manip, dir == IP_CT_DIR_ORIGINAL ? "ORIG" : "REPLY");
+
+	if (!nf_ct_get_tuple(*pskb,
+			     (*pskb)->nh.iph->ihl*4 + sizeof(struct icmphdr),
+			     (*pskb)->nh.iph->ihl*4 +
+	                     sizeof(struct icmphdr) + inside->ip.ihl*4,
+	                     (u_int16_t)AF_INET,
+	                     inside->ip.protocol,
+	                     &inner,
+	                     l3proto,
+			     __nf_ct_l4proto_find((u_int16_t)PF_INET,
+			     			  inside->ip.protocol)))
+		return 0;
+
+	/* Change inner back to look like incoming packet.  We do the
+	   opposite manip on this hook to normal, because it might not
+	   pass all hooks (locally-generated ICMP).  Consider incoming
+	   packet: PREROUTING (DST manip), routing produces ICMP, goes
+	   through POSTROUTING (which must correct the DST manip). */
+	if (!manip_pkt(inside->ip.protocol, pskb,
+		       (*pskb)->nh.iph->ihl*4 + sizeof(inside->icmp),
+		       &ct->tuplehash[!dir].tuple,
+		       !manip))
+		return 0;
+
+	if ((*pskb)->ip_summed != CHECKSUM_PARTIAL) {
+		/* Reloading "inside" here since manip_pkt inner. */
+		inside = (void *)(*pskb)->data + (*pskb)->nh.iph->ihl*4;
+		inside->icmp.checksum = 0;
+		inside->icmp.checksum =
+			csum_fold(skb_checksum(*pskb, hdrlen,
+					       (*pskb)->len - hdrlen, 0));
+	}
+
+	/* Change outer to look the reply to an incoming packet
+	 * (proto 0 means don't invert per-proto part). */
+	if (manip == IP_NAT_MANIP_SRC)
+		statusbit = IPS_SRC_NAT;
+	else
+		statusbit = IPS_DST_NAT;
+
+	/* Invert if this is reply dir. */
+	if (dir == IP_CT_DIR_REPLY)
+		statusbit ^= IPS_NAT_MASK;
+
+	if (ct->status & statusbit) {
+		nf_ct_invert_tuplepr(&target, &ct->tuplehash[!dir].tuple);
+		if (!manip_pkt(0, pskb, 0, &target, manip))
+			return 0;
+	}
+
+	return 1;
+}
+EXPORT_SYMBOL_GPL(nf_nat_icmp_reply_translation);
+
+/* Protocol registration. */
+int nf_nat_protocol_register(struct nf_nat_protocol *proto)
+{
+	int ret = 0;
+
+	write_lock_bh(&nf_nat_lock);
+	if (nf_nat_protos[proto->protonum] != &nf_nat_unknown_protocol) {
+		ret = -EBUSY;
+		goto out;
+	}
+	nf_nat_protos[proto->protonum] = proto;
+ out:
+	write_unlock_bh(&nf_nat_lock);
+	return ret;
+}
+EXPORT_SYMBOL(nf_nat_protocol_register);
+
+/* Noone stores the protocol anywhere; simply delete it. */
+void nf_nat_protocol_unregister(struct nf_nat_protocol *proto)
+{
+	write_lock_bh(&nf_nat_lock);
+	nf_nat_protos[proto->protonum] = &nf_nat_unknown_protocol;
+	write_unlock_bh(&nf_nat_lock);
+
+	/* Someone could be still looking at the proto in a bh. */
+	synchronize_net();
+}
+EXPORT_SYMBOL(nf_nat_protocol_unregister);
+
+#if defined(CONFIG_IP_NF_CONNTRACK_NETLINK) || \
+    defined(CONFIG_IP_NF_CONNTRACK_NETLINK_MODULE)
+int
+nf_nat_port_range_to_nfattr(struct sk_buff *skb,
+			    const struct nf_nat_range *range)
+{
+	NFA_PUT(skb, CTA_PROTONAT_PORT_MIN, sizeof(__be16),
+		&range->min.tcp.port);
+	NFA_PUT(skb, CTA_PROTONAT_PORT_MAX, sizeof(__be16),
+		&range->max.tcp.port);
+
+	return 0;
+
+nfattr_failure:
+	return -1;
+}
+EXPORT_SYMBOL_GPL(nf_nat_port_nfattr_to_range);
+
+int
+nf_nat_port_nfattr_to_range(struct nfattr *tb[], struct nf_nat_range *range)
+{
+	int ret = 0;
+
+	/* we have to return whether we actually parsed something or not */
+
+	if (tb[CTA_PROTONAT_PORT_MIN-1]) {
+		ret = 1;
+		range->min.tcp.port =
+			*(__be16 *)NFA_DATA(tb[CTA_PROTONAT_PORT_MIN-1]);
+	}
+
+	if (!tb[CTA_PROTONAT_PORT_MAX-1]) {
+		if (ret)
+			range->max.tcp.port = range->min.tcp.port;
+	} else {
+		ret = 1;
+		range->max.tcp.port =
+			*(__be16 *)NFA_DATA(tb[CTA_PROTONAT_PORT_MAX-1]);
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(nf_nat_port_range_to_nfattr);
+#endif
+
+static int __init nf_nat_init(void)
+{
+	size_t i;
+
+	/* Leave them the same for the moment. */
+	nf_nat_htable_size = nf_conntrack_htable_size;
+
+	/* One vmalloc for both hash tables */
+	bysource = vmalloc(sizeof(struct list_head) * nf_nat_htable_size);
+	if (!bysource)
+		return -ENOMEM;
+
+	/* Sew in builtin protocols. */
+	write_lock_bh(&nf_nat_lock);
+	for (i = 0; i < MAX_IP_NAT_PROTO; i++)
+		nf_nat_protos[i] = &nf_nat_unknown_protocol;
+	nf_nat_protos[IPPROTO_TCP] = &nf_nat_protocol_tcp;
+	nf_nat_protos[IPPROTO_UDP] = &nf_nat_protocol_udp;
+	nf_nat_protos[IPPROTO_ICMP] = &nf_nat_protocol_icmp;
+	write_unlock_bh(&nf_nat_lock);
+
+	for (i = 0; i < nf_nat_htable_size; i++) {
+		INIT_LIST_HEAD(&bysource[i]);
+	}
+
+	/* FIXME: Man, this is a hack.  <SIGH> */
+	NF_CT_ASSERT(nf_conntrack_destroyed == NULL);
+	nf_conntrack_destroyed = &nf_nat_cleanup_conntrack;
+
+	/* Initialize fake conntrack so that NAT will skip it */
+	nf_conntrack_untracked.status |= IPS_NAT_DONE_MASK;
+
+	l3proto = nf_ct_l3proto_find_get((u_int16_t)AF_INET);
+	return 0;
+}
+
+/* Clear NAT section of all conntracks, in case we're loaded again. */
+static int clean_nat(struct nf_conn *i, void *data)
+{
+	struct nf_conn_nat *nat = nfct_nat(i);
+
+	if (!nat)
+		return 0;
+	memset(nat, 0, sizeof(nat));
+	i->status &= ~(IPS_NAT_MASK | IPS_NAT_DONE_MASK | IPS_SEQ_ADJUST);
+	return 0;
+}
+
+static void __exit nf_nat_cleanup(void)
+{
+	nf_ct_iterate_cleanup(&clean_nat, NULL);
+	nf_conntrack_destroyed = NULL;
+	vfree(bysource);
+	nf_ct_l3proto_put(l3proto);
+}
+
+MODULE_LICENSE("GPL");
+
+module_init(nf_nat_init);
+module_exit(nf_nat_cleanup);
diff --git a/net/ipv4/netfilter/nf_nat_helper.c b/net/ipv4/netfilter/nf_nat_helper.c
new file mode 100644
index 0000000..98fbfc8
--- /dev/null
+++ b/net/ipv4/netfilter/nf_nat_helper.c
@@ -0,0 +1,433 @@
+/* ip_nat_helper.c - generic support functions for NAT helpers
+ *
+ * (C) 2000-2002 Harald Welte <laforge@netfilter.org>
+ * (C) 2003-2006 Netfilter Core Team <coreteam@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/module.h>
+#include <linux/kmod.h>
+#include <linux/types.h>
+#include <linux/timer.h>
+#include <linux/skbuff.h>
+#include <linux/tcp.h>
+#include <linux/udp.h>
+#include <net/checksum.h>
+#include <net/tcp.h>
+
+#include <linux/netfilter_ipv4.h>
+#include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_helper.h>
+#include <net/netfilter/nf_conntrack_expect.h>
+#include <net/netfilter/nf_nat.h>
+#include <net/netfilter/nf_nat_protocol.h>
+#include <net/netfilter/nf_nat_core.h>
+#include <net/netfilter/nf_nat_helper.h>
+
+#if 0
+#define DEBUGP printk
+#define DUMP_OFFSET(x)	printk("offset_before=%d, offset_after=%d, correction_pos=%u\n", x->offset_before, x->offset_after, x->correction_pos);
+#else
+#define DEBUGP(format, args...)
+#define DUMP_OFFSET(x)
+#endif
+
+static DEFINE_SPINLOCK(nf_nat_seqofs_lock);
+
+/* Setup TCP sequence correction given this change at this sequence */
+static inline void
+adjust_tcp_sequence(u32 seq,
+		    int sizediff,
+		    struct nf_conn *ct,
+		    enum ip_conntrack_info ctinfo)
+{
+	int dir;
+	struct nf_nat_seq *this_way, *other_way;
+	struct nf_conn_nat *nat = nfct_nat(ct);
+
+	DEBUGP("nf_nat_resize_packet: old_size = %u, new_size = %u\n",
+		(*skb)->len, new_size);
+
+	dir = CTINFO2DIR(ctinfo);
+
+	this_way = &nat->info.seq[dir];
+	other_way = &nat->info.seq[!dir];
+
+	DEBUGP("nf_nat_resize_packet: Seq_offset before: ");
+	DUMP_OFFSET(this_way);
+
+	spin_lock_bh(&nf_nat_seqofs_lock);
+
+	/* SYN adjust. If it's uninitialized, or this is after last
+	 * correction, record it: we don't handle more than one
+	 * adjustment in the window, but do deal with common case of a
+	 * retransmit */
+	if (this_way->offset_before == this_way->offset_after ||
+	    before(this_way->correction_pos, seq)) {
+		   this_way->correction_pos = seq;
+		   this_way->offset_before = this_way->offset_after;
+		   this_way->offset_after += sizediff;
+	}
+	spin_unlock_bh(&nf_nat_seqofs_lock);
+
+	DEBUGP("nf_nat_resize_packet: Seq_offset after: ");
+	DUMP_OFFSET(this_way);
+}
+
+/* Frobs data inside this packet, which is linear. */
+static void mangle_contents(struct sk_buff *skb,
+			    unsigned int dataoff,
+			    unsigned int match_offset,
+			    unsigned int match_len,
+			    const char *rep_buffer,
+			    unsigned int rep_len)
+{
+	unsigned char *data;
+
+	BUG_ON(skb_is_nonlinear(skb));
+	data = (unsigned char *)skb->nh.iph + dataoff;
+
+	/* move post-replacement */
+	memmove(data + match_offset + rep_len,
+		data + match_offset + match_len,
+		skb->tail - (data + match_offset + match_len));
+
+	/* insert data from buffer */
+	memcpy(data + match_offset, rep_buffer, rep_len);
+
+	/* update skb info */
+	if (rep_len > match_len) {
+		DEBUGP("nf_nat_mangle_packet: Extending packet by "
+		       "%u from %u bytes\n", rep_len - match_len,
+		       skb->len);
+		skb_put(skb, rep_len - match_len);
+	} else {
+		DEBUGP("nf_nat_mangle_packet: Shrinking packet from "
+		       "%u from %u bytes\n", match_len - rep_len,
+		       skb->len);
+		__skb_trim(skb, skb->len + rep_len - match_len);
+	}
+
+	/* fix IP hdr checksum information */
+	skb->nh.iph->tot_len = htons(skb->len);
+	ip_send_check(skb->nh.iph);
+}
+
+/* Unusual, but possible case. */
+static int enlarge_skb(struct sk_buff **pskb, unsigned int extra)
+{
+	struct sk_buff *nskb;
+
+	if ((*pskb)->len + extra > 65535)
+		return 0;
+
+	nskb = skb_copy_expand(*pskb, skb_headroom(*pskb), extra, GFP_ATOMIC);
+	if (!nskb)
+		return 0;
+
+	/* Transfer socket to new skb. */
+	if ((*pskb)->sk)
+		skb_set_owner_w(nskb, (*pskb)->sk);
+	kfree_skb(*pskb);
+	*pskb = nskb;
+	return 1;
+}
+
+/* Generic function for mangling variable-length address changes inside
+ * NATed TCP connections (like the PORT XXX,XXX,XXX,XXX,XXX,XXX
+ * command in FTP).
+ *
+ * Takes care about all the nasty sequence number changes, checksumming,
+ * skb enlargement, ...
+ *
+ * */
+int
+nf_nat_mangle_tcp_packet(struct sk_buff **pskb,
+			 struct nf_conn *ct,
+			 enum ip_conntrack_info ctinfo,
+			 unsigned int match_offset,
+			 unsigned int match_len,
+			 const char *rep_buffer,
+			 unsigned int rep_len)
+{
+	struct iphdr *iph;
+	struct tcphdr *tcph;
+	int oldlen, datalen;
+
+	if (!skb_make_writable(pskb, (*pskb)->len))
+		return 0;
+
+	if (rep_len > match_len &&
+	    rep_len - match_len > skb_tailroom(*pskb) &&
+	    !enlarge_skb(pskb, rep_len - match_len))
+		return 0;
+
+	SKB_LINEAR_ASSERT(*pskb);
+
+	iph = (*pskb)->nh.iph;
+	tcph = (void *)iph + iph->ihl*4;
+
+	oldlen = (*pskb)->len - iph->ihl*4;
+	mangle_contents(*pskb, iph->ihl*4 + tcph->doff*4,
+			match_offset, match_len, rep_buffer, rep_len);
+
+	datalen = (*pskb)->len - iph->ihl*4;
+	if ((*pskb)->ip_summed != CHECKSUM_PARTIAL) {
+		tcph->check = 0;
+		tcph->check = tcp_v4_check(tcph, datalen,
+					   iph->saddr, iph->daddr,
+					   csum_partial((char *)tcph,
+					   		datalen, 0));
+	} else
+		nf_proto_csum_replace2(&tcph->check, *pskb,
+				       htons(oldlen), htons(datalen), 1);
+
+	if (rep_len != match_len) {
+		set_bit(IPS_SEQ_ADJUST_BIT, &ct->status);
+		adjust_tcp_sequence(ntohl(tcph->seq),
+				    (int)rep_len - (int)match_len,
+				    ct, ctinfo);
+		/* Tell TCP window tracking about seq change */
+		nf_conntrack_tcp_update(*pskb, (*pskb)->nh.iph->ihl*4,
+					ct, CTINFO2DIR(ctinfo));
+	}
+	return 1;
+}
+EXPORT_SYMBOL(nf_nat_mangle_tcp_packet);
+
+/* Generic function for mangling variable-length address changes inside
+ * NATed UDP connections (like the CONNECT DATA XXXXX MESG XXXXX INDEX XXXXX
+ * command in the Amanda protocol)
+ *
+ * Takes care about all the nasty sequence number changes, checksumming,
+ * skb enlargement, ...
+ *
+ * XXX - This function could be merged with nf_nat_mangle_tcp_packet which
+ *       should be fairly easy to do.
+ */
+int
+nf_nat_mangle_udp_packet(struct sk_buff **pskb,
+			 struct nf_conn *ct,
+			 enum ip_conntrack_info ctinfo,
+			 unsigned int match_offset,
+			 unsigned int match_len,
+			 const char *rep_buffer,
+			 unsigned int rep_len)
+{
+	struct iphdr *iph;
+	struct udphdr *udph;
+	int datalen, oldlen;
+
+	/* UDP helpers might accidentally mangle the wrong packet */
+	iph = (*pskb)->nh.iph;
+	if ((*pskb)->len < iph->ihl*4 + sizeof(*udph) +
+	                       match_offset + match_len)
+		return 0;
+
+	if (!skb_make_writable(pskb, (*pskb)->len))
+		return 0;
+
+	if (rep_len > match_len &&
+	    rep_len - match_len > skb_tailroom(*pskb) &&
+	    !enlarge_skb(pskb, rep_len - match_len))
+		return 0;
+
+	iph = (*pskb)->nh.iph;
+	udph = (void *)iph + iph->ihl*4;
+
+	oldlen = (*pskb)->len - iph->ihl*4;
+	mangle_contents(*pskb, iph->ihl*4 + sizeof(*udph),
+			match_offset, match_len, rep_buffer, rep_len);
+
+	/* update the length of the UDP packet */
+	datalen = (*pskb)->len - iph->ihl*4;
+	udph->len = htons(datalen);
+
+	/* fix udp checksum if udp checksum was previously calculated */
+	if (!udph->check && (*pskb)->ip_summed != CHECKSUM_PARTIAL)
+		return 1;
+
+	if ((*pskb)->ip_summed != CHECKSUM_PARTIAL) {
+		udph->check = 0;
+		udph->check = csum_tcpudp_magic(iph->saddr, iph->daddr,
+		                                datalen, IPPROTO_UDP,
+		                                csum_partial((char *)udph,
+		                                             datalen, 0));
+		if (!udph->check)
+			udph->check = CSUM_MANGLED_0;
+	} else
+		nf_proto_csum_replace2(&udph->check, *pskb,
+				       htons(oldlen), htons(datalen), 1);
+
+	return 1;
+}
+EXPORT_SYMBOL(nf_nat_mangle_udp_packet);
+
+/* Adjust one found SACK option including checksum correction */
+static void
+sack_adjust(struct sk_buff *skb,
+	    struct tcphdr *tcph,
+	    unsigned int sackoff,
+	    unsigned int sackend,
+	    struct nf_nat_seq *natseq)
+{
+	while (sackoff < sackend) {
+		struct tcp_sack_block_wire *sack;
+		__be32 new_start_seq, new_end_seq;
+
+		sack = (void *)skb->data + sackoff;
+		if (after(ntohl(sack->start_seq) - natseq->offset_before,
+			  natseq->correction_pos))
+			new_start_seq = htonl(ntohl(sack->start_seq)
+					- natseq->offset_after);
+		else
+			new_start_seq = htonl(ntohl(sack->start_seq)
+					- natseq->offset_before);
+
+		if (after(ntohl(sack->end_seq) - natseq->offset_before,
+			  natseq->correction_pos))
+			new_end_seq = htonl(ntohl(sack->end_seq)
+				      - natseq->offset_after);
+		else
+			new_end_seq = htonl(ntohl(sack->end_seq)
+				      - natseq->offset_before);
+
+		DEBUGP("sack_adjust: start_seq: %d->%d, end_seq: %d->%d\n",
+			ntohl(sack->start_seq), new_start_seq,
+			ntohl(sack->end_seq), new_end_seq);
+
+		nf_proto_csum_replace4(&tcph->check, skb,
+				       sack->start_seq, new_start_seq, 0);
+		nf_proto_csum_replace4(&tcph->check, skb,
+				       sack->end_seq, new_end_seq, 0);
+		sack->start_seq = new_start_seq;
+		sack->end_seq = new_end_seq;
+		sackoff += sizeof(*sack);
+	}
+}
+
+/* TCP SACK sequence number adjustment */
+static inline unsigned int
+nf_nat_sack_adjust(struct sk_buff **pskb,
+		   struct tcphdr *tcph,
+		   struct nf_conn *ct,
+		   enum ip_conntrack_info ctinfo)
+{
+	unsigned int dir, optoff, optend;
+	struct nf_conn_nat *nat = nfct_nat(ct);
+
+	optoff = (*pskb)->nh.iph->ihl*4 + sizeof(struct tcphdr);
+	optend = (*pskb)->nh.iph->ihl*4 + tcph->doff*4;
+
+	if (!skb_make_writable(pskb, optend))
+		return 0;
+
+	dir = CTINFO2DIR(ctinfo);
+
+	while (optoff < optend) {
+		/* Usually: option, length. */
+		unsigned char *op = (*pskb)->data + optoff;
+
+		switch (op[0]) {
+		case TCPOPT_EOL:
+			return 1;
+		case TCPOPT_NOP:
+			optoff++;
+			continue;
+		default:
+			/* no partial options */
+			if (optoff + 1 == optend ||
+			    optoff + op[1] > optend ||
+			    op[1] < 2)
+				return 0;
+			if (op[0] == TCPOPT_SACK &&
+			    op[1] >= 2+TCPOLEN_SACK_PERBLOCK &&
+			    ((op[1] - 2) % TCPOLEN_SACK_PERBLOCK) == 0)
+				sack_adjust(*pskb, tcph, optoff+2,
+					    optoff+op[1],
+					    &nat->info.seq[!dir]);
+			optoff += op[1];
+		}
+	}
+	return 1;
+}
+
+/* TCP sequence number adjustment.  Returns 1 on success, 0 on failure */
+int
+nf_nat_seq_adjust(struct sk_buff **pskb,
+		  struct nf_conn *ct,
+		  enum ip_conntrack_info ctinfo)
+{
+	struct tcphdr *tcph;
+	int dir;
+	__be32 newseq, newack;
+	struct nf_conn_nat *nat = nfct_nat(ct);
+	struct nf_nat_seq *this_way, *other_way;
+
+	dir = CTINFO2DIR(ctinfo);
+
+	this_way = &nat->info.seq[dir];
+	other_way = &nat->info.seq[!dir];
+
+	if (!skb_make_writable(pskb, (*pskb)->nh.iph->ihl*4+sizeof(*tcph)))
+		return 0;
+
+	tcph = (void *)(*pskb)->data + (*pskb)->nh.iph->ihl*4;
+	if (after(ntohl(tcph->seq), this_way->correction_pos))
+		newseq = htonl(ntohl(tcph->seq) + this_way->offset_after);
+	else
+		newseq = htonl(ntohl(tcph->seq) + this_way->offset_before);
+
+	if (after(ntohl(tcph->ack_seq) - other_way->offset_before,
+		  other_way->correction_pos))
+		newack = htonl(ntohl(tcph->ack_seq) - other_way->offset_after);
+	else
+		newack = htonl(ntohl(tcph->ack_seq) - other_way->offset_before);
+
+	nf_proto_csum_replace4(&tcph->check, *pskb, tcph->seq, newseq, 0);
+	nf_proto_csum_replace4(&tcph->check, *pskb, tcph->ack_seq, newack, 0);
+
+	DEBUGP("Adjusting sequence number from %u->%u, ack from %u->%u\n",
+		ntohl(tcph->seq), ntohl(newseq), ntohl(tcph->ack_seq),
+		ntohl(newack));
+
+	tcph->seq = newseq;
+	tcph->ack_seq = newack;
+
+	if (!nf_nat_sack_adjust(pskb, tcph, ct, ctinfo))
+		return 0;
+
+	nf_conntrack_tcp_update(*pskb, (*pskb)->nh.iph->ihl*4, ct, dir);
+
+	return 1;
+}
+EXPORT_SYMBOL(nf_nat_seq_adjust);
+
+/* Setup NAT on this expected conntrack so it follows master. */
+/* If we fail to get a free NAT slot, we'll get dropped on confirm */
+void nf_nat_follow_master(struct nf_conn *ct,
+			  struct nf_conntrack_expect *exp)
+{
+	struct nf_nat_range range;
+
+	/* This must be a fresh one. */
+	BUG_ON(ct->status & IPS_NAT_DONE_MASK);
+
+	/* Change src to where master sends to */
+	range.flags = IP_NAT_RANGE_MAP_IPS;
+	range.min_ip = range.max_ip
+		= ct->master->tuplehash[!exp->dir].tuple.dst.u3.ip;
+	/* hook doesn't matter, but it has to do source manip */
+	nf_nat_setup_info(ct, &range, NF_IP_POST_ROUTING);
+
+	/* For DST manip, map port here to where it's expected. */
+	range.flags = (IP_NAT_RANGE_MAP_IPS | IP_NAT_RANGE_PROTO_SPECIFIED);
+	range.min = range.max = exp->saved_proto;
+	range.min_ip = range.max_ip
+		= ct->master->tuplehash[!exp->dir].tuple.src.u3.ip;
+	/* hook doesn't matter, but it has to do destination manip */
+	nf_nat_setup_info(ct, &range, NF_IP_PRE_ROUTING);
+}
+EXPORT_SYMBOL(nf_nat_follow_master);
diff --git a/net/ipv4/netfilter/nf_nat_proto_icmp.c b/net/ipv4/netfilter/nf_nat_proto_icmp.c
new file mode 100644
index 0000000..dcfd772
--- /dev/null
+++ b/net/ipv4/netfilter/nf_nat_proto_icmp.c
@@ -0,0 +1,86 @@
+/* (C) 1999-2001 Paul `Rusty' Russell
+ * (C) 2002-2006 Netfilter Core Team <coreteam@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/types.h>
+#include <linux/init.h>
+#include <linux/ip.h>
+#include <linux/icmp.h>
+
+#include <linux/netfilter.h>
+#include <net/netfilter/nf_nat.h>
+#include <net/netfilter/nf_nat_core.h>
+#include <net/netfilter/nf_nat_rule.h>
+#include <net/netfilter/nf_nat_protocol.h>
+
+static int
+icmp_in_range(const struct nf_conntrack_tuple *tuple,
+	      enum nf_nat_manip_type maniptype,
+	      const union nf_conntrack_man_proto *min,
+	      const union nf_conntrack_man_proto *max)
+{
+	return ntohs(tuple->src.u.icmp.id) >= ntohs(min->icmp.id) &&
+	       ntohs(tuple->src.u.icmp.id) <= ntohs(max->icmp.id);
+}
+
+static int
+icmp_unique_tuple(struct nf_conntrack_tuple *tuple,
+		  const struct nf_nat_range *range,
+		  enum nf_nat_manip_type maniptype,
+		  const struct nf_conn *ct)
+{
+	static u_int16_t id;
+	unsigned int range_size;
+	unsigned int i;
+
+	range_size = ntohs(range->max.icmp.id) - ntohs(range->min.icmp.id) + 1;
+	/* If no range specified... */
+	if (!(range->flags & IP_NAT_RANGE_PROTO_SPECIFIED))
+		range_size = 0xFFFF;
+
+	for (i = 0; i < range_size; i++, id++) {
+		tuple->src.u.icmp.id = htons(ntohs(range->min.icmp.id) +
+		                             (id % range_size));
+		if (!nf_nat_used_tuple(tuple, ct))
+			return 1;
+	}
+	return 0;
+}
+
+static int
+icmp_manip_pkt(struct sk_buff **pskb,
+	       unsigned int iphdroff,
+	       const struct nf_conntrack_tuple *tuple,
+	       enum nf_nat_manip_type maniptype)
+{
+	struct iphdr *iph = (struct iphdr *)((*pskb)->data + iphdroff);
+	struct icmphdr *hdr;
+	unsigned int hdroff = iphdroff + iph->ihl*4;
+
+	if (!skb_make_writable(pskb, hdroff + sizeof(*hdr)))
+		return 0;
+
+	hdr = (struct icmphdr *)((*pskb)->data + hdroff);
+	nf_proto_csum_replace2(&hdr->checksum, *pskb,
+			       hdr->un.echo.id, tuple->src.u.icmp.id, 0);
+	hdr->un.echo.id = tuple->src.u.icmp.id;
+	return 1;
+}
+
+struct nf_nat_protocol nf_nat_protocol_icmp = {
+	.name			= "ICMP",
+	.protonum		= IPPROTO_ICMP,
+	.me			= THIS_MODULE,
+	.manip_pkt		= icmp_manip_pkt,
+	.in_range		= icmp_in_range,
+	.unique_tuple		= icmp_unique_tuple,
+#if defined(CONFIG_IP_NF_CONNTRACK_NETLINK) || \
+    defined(CONFIG_IP_NF_CONNTRACK_NETLINK_MODULE)
+	.range_to_nfattr	= nf_nat_port_range_to_nfattr,
+	.nfattr_to_range	= nf_nat_port_nfattr_to_range,
+#endif
+};
diff --git a/net/ipv4/netfilter/nf_nat_proto_tcp.c b/net/ipv4/netfilter/nf_nat_proto_tcp.c
new file mode 100644
index 0000000..7e26a7e
--- /dev/null
+++ b/net/ipv4/netfilter/nf_nat_proto_tcp.c
@@ -0,0 +1,148 @@
+/* (C) 1999-2001 Paul `Rusty' Russell
+ * (C) 2002-2006 Netfilter Core Team <coreteam@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/types.h>
+#include <linux/init.h>
+#include <linux/ip.h>
+#include <linux/tcp.h>
+
+#include <linux/netfilter.h>
+#include <linux/netfilter/nfnetlink_conntrack.h>
+#include <net/netfilter/nf_nat.h>
+#include <net/netfilter/nf_nat_rule.h>
+#include <net/netfilter/nf_nat_protocol.h>
+#include <net/netfilter/nf_nat_core.h>
+
+static int
+tcp_in_range(const struct nf_conntrack_tuple *tuple,
+	     enum nf_nat_manip_type maniptype,
+	     const union nf_conntrack_man_proto *min,
+	     const union nf_conntrack_man_proto *max)
+{
+	__be16 port;
+
+	if (maniptype == IP_NAT_MANIP_SRC)
+		port = tuple->src.u.tcp.port;
+	else
+		port = tuple->dst.u.tcp.port;
+
+	return ntohs(port) >= ntohs(min->tcp.port) &&
+	       ntohs(port) <= ntohs(max->tcp.port);
+}
+
+static int
+tcp_unique_tuple(struct nf_conntrack_tuple *tuple,
+		 const struct nf_nat_range *range,
+		 enum nf_nat_manip_type maniptype,
+		 const struct nf_conn *ct)
+{
+	static u_int16_t port;
+	__be16 *portptr;
+	unsigned int range_size, min, i;
+
+	if (maniptype == IP_NAT_MANIP_SRC)
+		portptr = &tuple->src.u.tcp.port;
+	else
+		portptr = &tuple->dst.u.tcp.port;
+
+	/* If no range specified... */
+	if (!(range->flags & IP_NAT_RANGE_PROTO_SPECIFIED)) {
+		/* If it's dst rewrite, can't change port */
+		if (maniptype == IP_NAT_MANIP_DST)
+			return 0;
+
+		/* Map privileged onto privileged. */
+		if (ntohs(*portptr) < 1024) {
+			/* Loose convention: >> 512 is credential passing */
+			if (ntohs(*portptr)<512) {
+				min = 1;
+				range_size = 511 - min + 1;
+			} else {
+				min = 600;
+				range_size = 1023 - min + 1;
+			}
+		} else {
+			min = 1024;
+			range_size = 65535 - 1024 + 1;
+		}
+	} else {
+		min = ntohs(range->min.tcp.port);
+		range_size = ntohs(range->max.tcp.port) - min + 1;
+	}
+
+	for (i = 0; i < range_size; i++, port++) {
+		*portptr = htons(min + port % range_size);
+		if (!nf_nat_used_tuple(tuple, ct))
+			return 1;
+	}
+	return 0;
+}
+
+static int
+tcp_manip_pkt(struct sk_buff **pskb,
+	      unsigned int iphdroff,
+	      const struct nf_conntrack_tuple *tuple,
+	      enum nf_nat_manip_type maniptype)
+{
+	struct iphdr *iph = (struct iphdr *)((*pskb)->data + iphdroff);
+	struct tcphdr *hdr;
+	unsigned int hdroff = iphdroff + iph->ihl*4;
+	__be32 oldip, newip;
+	__be16 *portptr, newport, oldport;
+	int hdrsize = 8; /* TCP connection tracking guarantees this much */
+
+	/* this could be a inner header returned in icmp packet; in such
+	   cases we cannot update the checksum field since it is outside of
+	   the 8 bytes of transport layer headers we are guaranteed */
+	if ((*pskb)->len >= hdroff + sizeof(struct tcphdr))
+		hdrsize = sizeof(struct tcphdr);
+
+	if (!skb_make_writable(pskb, hdroff + hdrsize))
+		return 0;
+
+	iph = (struct iphdr *)((*pskb)->data + iphdroff);
+	hdr = (struct tcphdr *)((*pskb)->data + hdroff);
+
+	if (maniptype == IP_NAT_MANIP_SRC) {
+		/* Get rid of src ip and src pt */
+		oldip = iph->saddr;
+		newip = tuple->src.u3.ip;
+		newport = tuple->src.u.tcp.port;
+		portptr = &hdr->source;
+	} else {
+		/* Get rid of dst ip and dst pt */
+		oldip = iph->daddr;
+		newip = tuple->dst.u3.ip;
+		newport = tuple->dst.u.tcp.port;
+		portptr = &hdr->dest;
+	}
+
+	oldport = *portptr;
+	*portptr = newport;
+
+	if (hdrsize < sizeof(*hdr))
+		return 1;
+
+	nf_proto_csum_replace4(&hdr->check, *pskb, oldip, newip, 1);
+	nf_proto_csum_replace2(&hdr->check, *pskb, oldport, newport, 0);
+	return 1;
+}
+
+struct nf_nat_protocol nf_nat_protocol_tcp = {
+	.name			= "TCP",
+	.protonum		= IPPROTO_TCP,
+	.me			= THIS_MODULE,
+	.manip_pkt		= tcp_manip_pkt,
+	.in_range		= tcp_in_range,
+	.unique_tuple		= tcp_unique_tuple,
+#if defined(CONFIG_IP_NF_CONNTRACK_NETLINK) || \
+    defined(CONFIG_IP_NF_CONNTRACK_NETLINK_MODULE)
+	.range_to_nfattr	= nf_nat_port_range_to_nfattr,
+	.nfattr_to_range	= nf_nat_port_nfattr_to_range,
+#endif
+};
diff --git a/net/ipv4/netfilter/nf_nat_proto_udp.c b/net/ipv4/netfilter/nf_nat_proto_udp.c
new file mode 100644
index 0000000..ab0ce4c
--- /dev/null
+++ b/net/ipv4/netfilter/nf_nat_proto_udp.c
@@ -0,0 +1,138 @@
+/* (C) 1999-2001 Paul `Rusty' Russell
+ * (C) 2002-2006 Netfilter Core Team <coreteam@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/types.h>
+#include <linux/init.h>
+#include <linux/ip.h>
+#include <linux/udp.h>
+
+#include <linux/netfilter.h>
+#include <net/netfilter/nf_nat.h>
+#include <net/netfilter/nf_nat_core.h>
+#include <net/netfilter/nf_nat_rule.h>
+#include <net/netfilter/nf_nat_protocol.h>
+
+static int
+udp_in_range(const struct nf_conntrack_tuple *tuple,
+	     enum nf_nat_manip_type maniptype,
+	     const union nf_conntrack_man_proto *min,
+	     const union nf_conntrack_man_proto *max)
+{
+	__be16 port;
+
+	if (maniptype == IP_NAT_MANIP_SRC)
+		port = tuple->src.u.udp.port;
+	else
+		port = tuple->dst.u.udp.port;
+
+	return ntohs(port) >= ntohs(min->udp.port) &&
+	       ntohs(port) <= ntohs(max->udp.port);
+}
+
+static int
+udp_unique_tuple(struct nf_conntrack_tuple *tuple,
+		 const struct nf_nat_range *range,
+		 enum nf_nat_manip_type maniptype,
+		 const struct nf_conn *ct)
+{
+	static u_int16_t port;
+	__be16 *portptr;
+	unsigned int range_size, min, i;
+
+	if (maniptype == IP_NAT_MANIP_SRC)
+		portptr = &tuple->src.u.udp.port;
+	else
+		portptr = &tuple->dst.u.udp.port;
+
+	/* If no range specified... */
+	if (!(range->flags & IP_NAT_RANGE_PROTO_SPECIFIED)) {
+		/* If it's dst rewrite, can't change port */
+		if (maniptype == IP_NAT_MANIP_DST)
+			return 0;
+
+		if (ntohs(*portptr) < 1024) {
+			/* Loose convention: >> 512 is credential passing */
+			if (ntohs(*portptr)<512) {
+				min = 1;
+				range_size = 511 - min + 1;
+			} else {
+				min = 600;
+				range_size = 1023 - min + 1;
+			}
+		} else {
+			min = 1024;
+			range_size = 65535 - 1024 + 1;
+		}
+	} else {
+		min = ntohs(range->min.udp.port);
+		range_size = ntohs(range->max.udp.port) - min + 1;
+	}
+
+	for (i = 0; i < range_size; i++, port++) {
+		*portptr = htons(min + port % range_size);
+		if (!nf_nat_used_tuple(tuple, ct))
+			return 1;
+	}
+	return 0;
+}
+
+static int
+udp_manip_pkt(struct sk_buff **pskb,
+	      unsigned int iphdroff,
+	      const struct nf_conntrack_tuple *tuple,
+	      enum nf_nat_manip_type maniptype)
+{
+	struct iphdr *iph = (struct iphdr *)((*pskb)->data + iphdroff);
+	struct udphdr *hdr;
+	unsigned int hdroff = iphdroff + iph->ihl*4;
+	__be32 oldip, newip;
+	__be16 *portptr, newport;
+
+	if (!skb_make_writable(pskb, hdroff + sizeof(*hdr)))
+		return 0;
+
+	iph = (struct iphdr *)((*pskb)->data + iphdroff);
+	hdr = (struct udphdr *)((*pskb)->data + hdroff);
+
+	if (maniptype == IP_NAT_MANIP_SRC) {
+		/* Get rid of src ip and src pt */
+		oldip = iph->saddr;
+		newip = tuple->src.u3.ip;
+		newport = tuple->src.u.udp.port;
+		portptr = &hdr->source;
+	} else {
+		/* Get rid of dst ip and dst pt */
+		oldip = iph->daddr;
+		newip = tuple->dst.u3.ip;
+		newport = tuple->dst.u.udp.port;
+		portptr = &hdr->dest;
+	}
+	if (hdr->check || (*pskb)->ip_summed == CHECKSUM_PARTIAL) {
+		nf_proto_csum_replace4(&hdr->check, *pskb, oldip, newip, 1);
+		nf_proto_csum_replace2(&hdr->check, *pskb, *portptr, newport,
+				       0);
+		if (!hdr->check)
+			hdr->check = CSUM_MANGLED_0;
+	}
+	*portptr = newport;
+	return 1;
+}
+
+struct nf_nat_protocol nf_nat_protocol_udp = {
+	.name			= "UDP",
+	.protonum		= IPPROTO_UDP,
+	.me			= THIS_MODULE,
+	.manip_pkt		= udp_manip_pkt,
+	.in_range		= udp_in_range,
+	.unique_tuple		= udp_unique_tuple,
+#if defined(CONFIG_IP_NF_CONNTRACK_NETLINK) || \
+    defined(CONFIG_IP_NF_CONNTRACK_NETLINK_MODULE)
+	.range_to_nfattr	= nf_nat_port_range_to_nfattr,
+	.nfattr_to_range	= nf_nat_port_nfattr_to_range,
+#endif
+};
diff --git a/net/ipv4/netfilter/nf_nat_proto_unknown.c b/net/ipv4/netfilter/nf_nat_proto_unknown.c
new file mode 100644
index 0000000..f50d020
--- /dev/null
+++ b/net/ipv4/netfilter/nf_nat_proto_unknown.c
@@ -0,0 +1,54 @@
+/* The "unknown" protocol.  This is what is used for protocols we
+ * don't understand.  It's returned by ip_ct_find_proto().
+ */
+
+/* (C) 1999-2001 Paul `Rusty' Russell
+ * (C) 2002-2006 Netfilter Core Team <coreteam@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/types.h>
+#include <linux/init.h>
+
+#include <linux/netfilter.h>
+#include <net/netfilter/nf_nat.h>
+#include <net/netfilter/nf_nat_rule.h>
+#include <net/netfilter/nf_nat_protocol.h>
+
+static int unknown_in_range(const struct nf_conntrack_tuple *tuple,
+			    enum nf_nat_manip_type manip_type,
+			    const union nf_conntrack_man_proto *min,
+			    const union nf_conntrack_man_proto *max)
+{
+	return 1;
+}
+
+static int unknown_unique_tuple(struct nf_conntrack_tuple *tuple,
+				const struct nf_nat_range *range,
+				enum nf_nat_manip_type maniptype,
+				const struct nf_conn *ct)
+{
+	/* Sorry: we can't help you; if it's not unique, we can't frob
+	   anything. */
+	return 0;
+}
+
+static int
+unknown_manip_pkt(struct sk_buff **pskb,
+		  unsigned int iphdroff,
+		  const struct nf_conntrack_tuple *tuple,
+		  enum nf_nat_manip_type maniptype)
+{
+	return 1;
+}
+
+struct nf_nat_protocol nf_nat_unknown_protocol = {
+	.name			= "unknown",
+	/* .me isn't set: getting a ref to this cannot fail. */
+	.manip_pkt		= unknown_manip_pkt,
+	.in_range		= unknown_in_range,
+	.unique_tuple		= unknown_unique_tuple,
+};
diff --git a/net/ipv4/netfilter/nf_nat_rule.c b/net/ipv4/netfilter/nf_nat_rule.c
new file mode 100644
index 0000000..b868ee0
--- /dev/null
+++ b/net/ipv4/netfilter/nf_nat_rule.c
@@ -0,0 +1,343 @@
+/* (C) 1999-2001 Paul `Rusty' Russell
+ * (C) 2002-2006 Netfilter Core Team <coreteam@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+/* Everything about the rules for NAT. */
+#include <linux/types.h>
+#include <linux/ip.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter_ipv4.h>
+#include <linux/module.h>
+#include <linux/kmod.h>
+#include <linux/skbuff.h>
+#include <linux/proc_fs.h>
+#include <net/checksum.h>
+#include <net/route.h>
+#include <linux/bitops.h>
+
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <net/netfilter/nf_nat.h>
+#include <net/netfilter/nf_nat_core.h>
+#include <net/netfilter/nf_nat_rule.h>
+
+#if 0
+#define DEBUGP printk
+#else
+#define DEBUGP(format, args...)
+#endif
+
+#define NAT_VALID_HOOKS ((1<<NF_IP_PRE_ROUTING) | (1<<NF_IP_POST_ROUTING) | (1<<NF_IP_LOCAL_OUT))
+
+static struct
+{
+	struct ipt_replace repl;
+	struct ipt_standard entries[3];
+	struct ipt_error term;
+} nat_initial_table __initdata = {
+	.repl = {
+		.name = "nat",
+		.valid_hooks = NAT_VALID_HOOKS,
+		.num_entries = 4,
+		.size = sizeof(struct ipt_standard) * 3 + sizeof(struct ipt_error),
+		.hook_entry = {
+			[NF_IP_PRE_ROUTING] = 0,
+			[NF_IP_POST_ROUTING] = sizeof(struct ipt_standard),
+			[NF_IP_LOCAL_OUT] = sizeof(struct ipt_standard) * 2 },
+		.underflow = {
+			[NF_IP_PRE_ROUTING] = 0,
+			[NF_IP_POST_ROUTING] = sizeof(struct ipt_standard),
+			[NF_IP_LOCAL_OUT] = sizeof(struct ipt_standard) * 2 },
+	},
+	.entries = {
+		/* PRE_ROUTING */
+		{
+			.entry = {
+	    			.target_offset = sizeof(struct ipt_entry),
+	    			.next_offset = sizeof(struct ipt_standard),
+			},
+			.target = {
+				.target = {
+					.u = {
+						.target_size = IPT_ALIGN(sizeof(struct ipt_standard_target)),
+					},
+				},
+				.verdict = -NF_ACCEPT - 1,
+			},
+		},
+		/* POST_ROUTING */
+		{
+			.entry = {
+	    			.target_offset = sizeof(struct ipt_entry),
+	    			.next_offset = sizeof(struct ipt_standard),
+			},
+			.target = {
+				.target = {
+					.u = {
+						.target_size = IPT_ALIGN(sizeof(struct ipt_standard_target)),
+					},
+				},
+				.verdict = -NF_ACCEPT - 1,
+			},
+		},
+		/* LOCAL_OUT */
+		{
+			.entry = {
+	    			.target_offset = sizeof(struct ipt_entry),
+	    			.next_offset = sizeof(struct ipt_standard),
+			},
+			.target = {
+				.target = {
+					.u = {
+						.target_size = IPT_ALIGN(sizeof(struct ipt_standard_target)),
+					},
+				},
+				.verdict = -NF_ACCEPT - 1,
+			},
+		},
+	},
+	/* ERROR */
+	.term = {
+		.entry = {
+			.target_offset = sizeof(struct ipt_entry),
+			.next_offset = sizeof(struct ipt_error),
+		},
+		.target = {
+			.target = {
+				.u = {
+					.user = {
+						.target_size = IPT_ALIGN(sizeof(struct ipt_error_target)),
+						.name = IPT_ERROR_TARGET,
+					},
+				},
+			},
+			.errorname = "ERROR",
+		},
+	}
+};
+
+static struct ipt_table nat_table = {
+	.name		= "nat",
+	.valid_hooks	= NAT_VALID_HOOKS,
+	.lock		= RW_LOCK_UNLOCKED,
+	.me		= THIS_MODULE,
+	.af		= AF_INET,
+};
+
+/* Source NAT */
+static unsigned int ipt_snat_target(struct sk_buff **pskb,
+				    const struct net_device *in,
+				    const struct net_device *out,
+				    unsigned int hooknum,
+				    const struct xt_target *target,
+				    const void *targinfo)
+{
+	struct nf_conn *ct;
+	enum ip_conntrack_info ctinfo;
+	const struct nf_nat_multi_range_compat *mr = targinfo;
+
+	NF_CT_ASSERT(hooknum == NF_IP_POST_ROUTING);
+
+	ct = nf_ct_get(*pskb, &ctinfo);
+
+	/* Connection must be valid and new. */
+	NF_CT_ASSERT(ct && (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED ||
+	                    ctinfo == IP_CT_RELATED + IP_CT_IS_REPLY));
+	NF_CT_ASSERT(out);
+
+	return nf_nat_setup_info(ct, &mr->range[0], hooknum);
+}
+
+/* Before 2.6.11 we did implicit source NAT if required. Warn about change. */
+static void warn_if_extra_mangle(__be32 dstip, __be32 srcip)
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
+static unsigned int ipt_dnat_target(struct sk_buff **pskb,
+				    const struct net_device *in,
+				    const struct net_device *out,
+				    unsigned int hooknum,
+				    const struct xt_target *target,
+				    const void *targinfo)
+{
+	struct nf_conn *ct;
+	enum ip_conntrack_info ctinfo;
+	const struct nf_nat_multi_range_compat *mr = targinfo;
+
+	NF_CT_ASSERT(hooknum == NF_IP_PRE_ROUTING ||
+		     hooknum == NF_IP_LOCAL_OUT);
+
+	ct = nf_ct_get(*pskb, &ctinfo);
+
+	/* Connection must be valid and new. */
+	NF_CT_ASSERT(ct && (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED));
+
+	if (hooknum == NF_IP_LOCAL_OUT &&
+	    mr->range[0].flags & IP_NAT_RANGE_MAP_IPS)
+		warn_if_extra_mangle((*pskb)->nh.iph->daddr,
+				     mr->range[0].min_ip);
+
+	return nf_nat_setup_info(ct, &mr->range[0], hooknum);
+}
+
+static int ipt_snat_checkentry(const char *tablename,
+			       const void *entry,
+			       const struct xt_target *target,
+			       void *targinfo,
+			       unsigned int hook_mask)
+{
+	struct nf_nat_multi_range_compat *mr = targinfo;
+
+	/* Must be a valid range */
+	if (mr->rangesize != 1) {
+		printk("SNAT: multiple ranges no longer supported\n");
+		return 0;
+	}
+	return 1;
+}
+
+static int ipt_dnat_checkentry(const char *tablename,
+			       const void *entry,
+			       const struct xt_target *target,
+			       void *targinfo,
+			       unsigned int hook_mask)
+{
+	struct nf_nat_multi_range_compat *mr = targinfo;
+
+	/* Must be a valid range */
+	if (mr->rangesize != 1) {
+		printk("DNAT: multiple ranges no longer supported\n");
+		return 0;
+	}
+	return 1;
+}
+
+inline unsigned int
+alloc_null_binding(struct nf_conn *ct,
+		   struct nf_nat_info *info,
+		   unsigned int hooknum)
+{
+	/* Force range to this IP; let proto decide mapping for
+	   per-proto parts (hence not IP_NAT_RANGE_PROTO_SPECIFIED).
+	   Use reply in case it's already been mangled (eg local packet).
+	*/
+	__be32 ip
+		= (HOOK2MANIP(hooknum) == IP_NAT_MANIP_SRC
+		   ? ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u3.ip
+		   : ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.u3.ip);
+	struct nf_nat_range range
+		= { IP_NAT_RANGE_MAP_IPS, ip, ip, { 0 }, { 0 } };
+
+	DEBUGP("Allocating NULL binding for %p (%u.%u.%u.%u)\n",
+	       ct, NIPQUAD(ip));
+	return nf_nat_setup_info(ct, &range, hooknum);
+}
+
+unsigned int
+alloc_null_binding_confirmed(struct nf_conn *ct,
+                             struct nf_nat_info *info,
+                             unsigned int hooknum)
+{
+	__be32 ip
+		= (HOOK2MANIP(hooknum) == IP_NAT_MANIP_SRC
+		   ? ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u3.ip
+		   : ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.u3.ip);
+	u_int16_t all
+		= (HOOK2MANIP(hooknum) == IP_NAT_MANIP_SRC
+		   ? ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u.all
+		   : ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.u.all);
+	struct nf_nat_range range
+		= { IP_NAT_RANGE_MAP_IPS, ip, ip, { all }, { all } };
+
+	DEBUGP("Allocating NULL binding for confirmed %p (%u.%u.%u.%u)\n",
+	       ct, NIPQUAD(ip));
+	return nf_nat_setup_info(ct, &range, hooknum);
+}
+
+int nf_nat_rule_find(struct sk_buff **pskb,
+		     unsigned int hooknum,
+		     const struct net_device *in,
+		     const struct net_device *out,
+		     struct nf_conn *ct,
+		     struct nf_nat_info *info)
+{
+	int ret;
+
+	ret = ipt_do_table(pskb, hooknum, in, out, &nat_table);
+
+	if (ret == NF_ACCEPT) {
+		if (!nf_nat_initialized(ct, HOOK2MANIP(hooknum)))
+			/* NUL mapping */
+			ret = alloc_null_binding(ct, info, hooknum);
+	}
+	return ret;
+}
+
+static struct ipt_target ipt_snat_reg = {
+	.name		= "SNAT",
+	.target		= ipt_snat_target,
+	.targetsize	= sizeof(struct nf_nat_multi_range_compat),
+	.table		= "nat",
+	.hooks		= 1 << NF_IP_POST_ROUTING,
+	.checkentry	= ipt_snat_checkentry,
+	.family		= AF_INET,
+};
+
+static struct xt_target ipt_dnat_reg = {
+	.name		= "DNAT",
+	.target		= ipt_dnat_target,
+	.targetsize	= sizeof(struct nf_nat_multi_range_compat),
+	.table		= "nat",
+	.hooks		= (1 << NF_IP_PRE_ROUTING) | (1 << NF_IP_LOCAL_OUT),
+	.checkentry	= ipt_dnat_checkentry,
+	.family		= AF_INET,
+};
+
+int __init nf_nat_rule_init(void)
+{
+	int ret;
+
+	ret = ipt_register_table(&nat_table, &nat_initial_table.repl);
+	if (ret != 0)
+		return ret;
+	ret = xt_register_target(&ipt_snat_reg);
+	if (ret != 0)
+		goto unregister_table;
+
+	ret = xt_register_target(&ipt_dnat_reg);
+	if (ret != 0)
+		goto unregister_snat;
+
+	return ret;
+
+ unregister_snat:
+	xt_unregister_target(&ipt_snat_reg);
+ unregister_table:
+	ipt_unregister_table(&nat_table);
+
+	return ret;
+}
+
+void nf_nat_rule_cleanup(void)
+{
+	xt_unregister_target(&ipt_dnat_reg);
+	xt_unregister_target(&ipt_snat_reg);
+	ipt_unregister_table(&nat_table);
+}
diff --git a/net/ipv4/netfilter/nf_nat_standalone.c b/net/ipv4/netfilter/nf_nat_standalone.c
new file mode 100644
index 0000000..730a7a4
--- /dev/null
+++ b/net/ipv4/netfilter/nf_nat_standalone.c
@@ -0,0 +1,406 @@
+/* (C) 1999-2001 Paul `Rusty' Russell
+ * (C) 2002-2006 Netfilter Core Team <coreteam@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/types.h>
+#include <linux/icmp.h>
+#include <linux/ip.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter_ipv4.h>
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/proc_fs.h>
+#include <net/ip.h>
+#include <net/checksum.h>
+#include <linux/spinlock.h>
+
+#include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_core.h>
+#include <net/netfilter/nf_nat.h>
+#include <net/netfilter/nf_nat_rule.h>
+#include <net/netfilter/nf_nat_protocol.h>
+#include <net/netfilter/nf_nat_core.h>
+#include <net/netfilter/nf_nat_helper.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+
+#if 0
+#define DEBUGP printk
+#else
+#define DEBUGP(format, args...)
+#endif
+
+#define HOOKNAME(hooknum) ((hooknum) == NF_IP_POST_ROUTING ? "POST_ROUTING"  \
+			   : ((hooknum) == NF_IP_PRE_ROUTING ? "PRE_ROUTING" \
+			      : ((hooknum) == NF_IP_LOCAL_OUT ? "LOCAL_OUT"  \
+			         : ((hooknum) == NF_IP_LOCAL_IN ? "LOCAL_IN"  \
+				    : "*ERROR*")))
+
+#ifdef CONFIG_XFRM
+static void nat_decode_session(struct sk_buff *skb, struct flowi *fl)
+{
+	struct nf_conn *ct;
+	struct nf_conntrack_tuple *t;
+	enum ip_conntrack_info ctinfo;
+	enum ip_conntrack_dir dir;
+	unsigned long statusbit;
+
+	ct = nf_ct_get(skb, &ctinfo);
+	if (ct == NULL)
+		return;
+	dir = CTINFO2DIR(ctinfo);
+	t = &ct->tuplehash[dir].tuple;
+
+	if (dir == IP_CT_DIR_ORIGINAL)
+		statusbit = IPS_DST_NAT;
+	else
+		statusbit = IPS_SRC_NAT;
+
+	if (ct->status & statusbit) {
+		fl->fl4_dst = t->dst.u3.ip;
+		if (t->dst.protonum == IPPROTO_TCP ||
+		    t->dst.protonum == IPPROTO_UDP)
+			fl->fl_ip_dport = t->dst.u.tcp.port;
+	}
+
+	statusbit ^= IPS_NAT_MASK;
+
+	if (ct->status & statusbit) {
+		fl->fl4_src = t->src.u3.ip;
+		if (t->dst.protonum == IPPROTO_TCP ||
+		    t->dst.protonum == IPPROTO_UDP)
+			fl->fl_ip_sport = t->src.u.tcp.port;
+	}
+}
+#endif
+
+static unsigned int
+nf_nat_fn(unsigned int hooknum,
+	  struct sk_buff **pskb,
+	  const struct net_device *in,
+	  const struct net_device *out,
+	  int (*okfn)(struct sk_buff *))
+{
+	struct nf_conn *ct;
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn_nat *nat;
+	struct nf_nat_info *info;
+	/* maniptype == SRC for postrouting. */
+	enum nf_nat_manip_type maniptype = HOOK2MANIP(hooknum);
+
+	/* We never see fragments: conntrack defrags on pre-routing
+	   and local-out, and nf_nat_out protects post-routing. */
+	NF_CT_ASSERT(!((*pskb)->nh.iph->frag_off
+		       & htons(IP_MF|IP_OFFSET)));
+
+	ct = nf_ct_get(*pskb, &ctinfo);
+	/* Can't track?  It's not due to stress, or conntrack would
+	   have dropped it.  Hence it's the user's responsibilty to
+	   packet filter it out, or implement conntrack/NAT for that
+	   protocol. 8) --RR */
+	if (!ct) {
+		/* Exception: ICMP redirect to new connection (not in
+                   hash table yet).  We must not let this through, in
+                   case we're doing NAT to the same network. */
+		if ((*pskb)->nh.iph->protocol == IPPROTO_ICMP) {
+			struct icmphdr _hdr, *hp;
+
+			hp = skb_header_pointer(*pskb,
+						(*pskb)->nh.iph->ihl*4,
+						sizeof(_hdr), &_hdr);
+			if (hp != NULL &&
+			    hp->type == ICMP_REDIRECT)
+				return NF_DROP;
+		}
+		return NF_ACCEPT;
+	}
+
+	/* Don't try to NAT if this packet is not conntracked */
+	if (ct == &nf_conntrack_untracked)
+		return NF_ACCEPT;
+
+	nat = nfct_nat(ct);
+	if (!nat)
+		return NF_DROP;
+
+	switch (ctinfo) {
+	case IP_CT_RELATED:
+	case IP_CT_RELATED+IP_CT_IS_REPLY:
+		if ((*pskb)->nh.iph->protocol == IPPROTO_ICMP) {
+			if (!nf_nat_icmp_reply_translation(ct, ctinfo,
+							   hooknum, pskb))
+				return NF_DROP;
+			else
+				return NF_ACCEPT;
+		}
+		/* Fall thru... (Only ICMPs can be IP_CT_IS_REPLY) */
+	case IP_CT_NEW:
+		info = &nat->info;
+
+		/* Seen it before?  This can happen for loopback, retrans,
+		   or local packets.. */
+		if (!nf_nat_initialized(ct, maniptype)) {
+			unsigned int ret;
+
+			if (unlikely(nf_ct_is_confirmed(ct)))
+				/* NAT module was loaded late */
+				ret = alloc_null_binding_confirmed(ct, info,
+				                                   hooknum);
+			else if (hooknum == NF_IP_LOCAL_IN)
+				/* LOCAL_IN hook doesn't have a chain!  */
+				ret = alloc_null_binding(ct, info, hooknum);
+			else
+				ret = nf_nat_rule_find(pskb, hooknum, in, out,
+						       ct, info);
+
+			if (ret != NF_ACCEPT) {
+				return ret;
+			}
+		} else
+			DEBUGP("Already setup manip %s for ct %p\n",
+			       maniptype == IP_NAT_MANIP_SRC ? "SRC" : "DST",
+			       ct);
+		break;
+
+	default:
+		/* ESTABLISHED */
+		NF_CT_ASSERT(ctinfo == IP_CT_ESTABLISHED ||
+			     ctinfo == (IP_CT_ESTABLISHED+IP_CT_IS_REPLY));
+		info = &nat->info;
+	}
+
+	NF_CT_ASSERT(info);
+	return nf_nat_packet(ct, ctinfo, hooknum, pskb);
+}
+
+static unsigned int
+nf_nat_in(unsigned int hooknum,
+          struct sk_buff **pskb,
+          const struct net_device *in,
+          const struct net_device *out,
+          int (*okfn)(struct sk_buff *))
+{
+	unsigned int ret;
+	__be32 daddr = (*pskb)->nh.iph->daddr;
+
+	ret = nf_nat_fn(hooknum, pskb, in, out, okfn);
+	if (ret != NF_DROP && ret != NF_STOLEN &&
+	    daddr != (*pskb)->nh.iph->daddr) {
+		dst_release((*pskb)->dst);
+		(*pskb)->dst = NULL;
+	}
+	return ret;
+}
+
+static unsigned int
+nf_nat_out(unsigned int hooknum,
+	   struct sk_buff **pskb,
+	   const struct net_device *in,
+	   const struct net_device *out,
+	   int (*okfn)(struct sk_buff *))
+{
+#ifdef CONFIG_XFRM
+	struct nf_conn *ct;
+	enum ip_conntrack_info ctinfo;
+#endif
+	unsigned int ret;
+
+	/* root is playing with raw sockets. */
+	if ((*pskb)->len < sizeof(struct iphdr) ||
+	    (*pskb)->nh.iph->ihl * 4 < sizeof(struct iphdr))
+		return NF_ACCEPT;
+
+	ret = nf_nat_fn(hooknum, pskb, in, out, okfn);
+#ifdef CONFIG_XFRM
+	if (ret != NF_DROP && ret != NF_STOLEN &&
+	    (ct = nf_ct_get(*pskb, &ctinfo)) != NULL) {
+		enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
+
+		if (ct->tuplehash[dir].tuple.src.u3.ip !=
+		    ct->tuplehash[!dir].tuple.dst.u3.ip
+		    || ct->tuplehash[dir].tuple.src.u.all !=
+		       ct->tuplehash[!dir].tuple.dst.u.all
+		    )
+			return ip_xfrm_me_harder(pskb) == 0 ? ret : NF_DROP;
+	}
+#endif
+	return ret;
+}
+
+static unsigned int
+nf_nat_local_fn(unsigned int hooknum,
+		struct sk_buff **pskb,
+		const struct net_device *in,
+		const struct net_device *out,
+		int (*okfn)(struct sk_buff *))
+{
+	struct nf_conn *ct;
+	enum ip_conntrack_info ctinfo;
+	unsigned int ret;
+
+	/* root is playing with raw sockets. */
+	if ((*pskb)->len < sizeof(struct iphdr) ||
+	    (*pskb)->nh.iph->ihl * 4 < sizeof(struct iphdr))
+		return NF_ACCEPT;
+
+	ret = nf_nat_fn(hooknum, pskb, in, out, okfn);
+	if (ret != NF_DROP && ret != NF_STOLEN &&
+	    (ct = nf_ct_get(*pskb, &ctinfo)) != NULL) {
+		enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
+
+		if (ct->tuplehash[dir].tuple.dst.u3.ip !=
+		    ct->tuplehash[!dir].tuple.src.u3.ip
+#ifdef CONFIG_XFRM
+		    || ct->tuplehash[dir].tuple.dst.u.all !=
+		       ct->tuplehash[!dir].tuple.src.u.all
+#endif
+		    )
+			if (ip_route_me_harder(pskb, RTN_UNSPEC))
+				ret = NF_DROP;
+	}
+	return ret;
+}
+
+static unsigned int
+nf_nat_adjust(unsigned int hooknum,
+	      struct sk_buff **pskb,
+	      const struct net_device *in,
+	      const struct net_device *out,
+	      int (*okfn)(struct sk_buff *))
+{
+	struct nf_conn *ct;
+	enum ip_conntrack_info ctinfo;
+
+	ct = nf_ct_get(*pskb, &ctinfo);
+	if (ct && test_bit(IPS_SEQ_ADJUST_BIT, &ct->status)) {
+	        DEBUGP("nf_nat_standalone: adjusting sequence number\n");
+	        if (!nf_nat_seq_adjust(pskb, ct, ctinfo))
+	                return NF_DROP;
+	}
+	return NF_ACCEPT;
+}
+
+/* We must be after connection tracking and before packet filtering. */
+
+static struct nf_hook_ops nf_nat_ops[] = {
+	/* Before packet filtering, change destination */
+	{
+		.hook		= nf_nat_in,
+		.owner		= THIS_MODULE,
+		.pf		= PF_INET,
+		.hooknum	= NF_IP_PRE_ROUTING,
+		.priority	= NF_IP_PRI_NAT_DST,
+	},
+	/* After packet filtering, change source */
+	{
+		.hook		= nf_nat_out,
+		.owner		= THIS_MODULE,
+		.pf		= PF_INET,
+		.hooknum	= NF_IP_POST_ROUTING,
+		.priority	= NF_IP_PRI_NAT_SRC,
+	},
+	/* After conntrack, adjust sequence number */
+	{
+		.hook		= nf_nat_adjust,
+		.owner		= THIS_MODULE,
+		.pf		= PF_INET,
+		.hooknum	= NF_IP_POST_ROUTING,
+		.priority	= NF_IP_PRI_NAT_SEQ_ADJUST,
+	},
+	/* Before packet filtering, change destination */
+	{
+		.hook		= nf_nat_local_fn,
+		.owner		= THIS_MODULE,
+		.pf		= PF_INET,
+		.hooknum	= NF_IP_LOCAL_OUT,
+		.priority	= NF_IP_PRI_NAT_DST,
+	},
+	/* After packet filtering, change source */
+	{
+		.hook		= nf_nat_fn,
+		.owner		= THIS_MODULE,
+		.pf		= PF_INET,
+		.hooknum	= NF_IP_LOCAL_IN,
+		.priority	= NF_IP_PRI_NAT_SRC,
+	},
+	/* After conntrack, adjust sequence number */
+	{
+		.hook		= nf_nat_adjust,
+		.owner		= THIS_MODULE,
+		.pf		= PF_INET,
+		.hooknum	= NF_IP_LOCAL_IN,
+		.priority	= NF_IP_PRI_NAT_SEQ_ADJUST,
+	},
+};
+
+static int __init nf_nat_standalone_init(void)
+{
+	int size, ret = 0;
+
+	need_conntrack();
+
+	size = ALIGN(sizeof(struct nf_conn), __alignof__(struct nf_conn_nat)) +
+	       sizeof(struct nf_conn_nat);
+	ret = nf_conntrack_register_cache(NF_CT_F_NAT, "nf_nat:base", size);
+	if (ret < 0) {
+		printk(KERN_ERR "nf_nat_init: Unable to create slab cache\n");
+		return ret;
+	}
+
+	size = ALIGN(size, __alignof__(struct nf_conn_help)) +
+	       sizeof(struct nf_conn_help);
+	ret = nf_conntrack_register_cache(NF_CT_F_NAT|NF_CT_F_HELP,
+					  "nf_nat:help", size);
+	if (ret < 0) {
+		printk(KERN_ERR "nf_nat_init: Unable to create slab cache\n");
+		goto cleanup_register_cache;
+	}
+#ifdef CONFIG_XFRM
+	BUG_ON(ip_nat_decode_session != NULL);
+	ip_nat_decode_session = nat_decode_session;
+#endif
+	ret = nf_nat_rule_init();
+	if (ret < 0) {
+		printk("nf_nat_init: can't setup rules.\n");
+		goto cleanup_decode_session;
+	}
+	ret = nf_register_hooks(nf_nat_ops, ARRAY_SIZE(nf_nat_ops));
+	if (ret < 0) {
+		printk("nf_nat_init: can't register hooks.\n");
+		goto cleanup_rule_init;
+	}
+	nf_nat_module_is_loaded = 1;
+	return ret;
+
+ cleanup_rule_init:
+	nf_nat_rule_cleanup();
+ cleanup_decode_session:
+#ifdef CONFIG_XFRM
+	ip_nat_decode_session = NULL;
+	synchronize_net();
+#endif
+	nf_conntrack_unregister_cache(NF_CT_F_NAT|NF_CT_F_HELP);
+ cleanup_register_cache:
+	nf_conntrack_unregister_cache(NF_CT_F_NAT);
+	return ret;
+}
+
+static void __exit nf_nat_standalone_fini(void)
+{
+	nf_unregister_hooks(nf_nat_ops, ARRAY_SIZE(nf_nat_ops));
+	nf_nat_rule_cleanup();
+	nf_nat_module_is_loaded = 0;
+#ifdef CONFIG_XFRM
+	ip_nat_decode_session = NULL;
+	synchronize_net();
+#endif
+	/* Conntrack caches are unregistered in nf_conntrack_cleanup */
+}
+
+module_init(nf_nat_standalone_init);
+module_exit(nf_nat_standalone_fini);
+
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("ip_nat");
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index f952a7f..aa8beab 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -579,7 +579,8 @@ __nf_conntrack_alloc(const struct nf_con
 	/* FIXME: protect helper list per RCU */
 	read_lock_bh(&nf_conntrack_lock);
 	helper = __nf_ct_helper_find(repl);
-	if (helper)
+	/* NAT might want to assign a helper later */
+	if (helper || features & NF_CT_F_NAT)
 		features |= NF_CT_F_HELP;
 	read_unlock_bh(&nf_conntrack_lock);
 
@@ -850,6 +851,26 @@ int nf_ct_invert_tuplepr(struct nf_connt
 						     orig->dst.protonum));
 }
 
+/* Alter reply tuple (maybe alter helper).  This is for NAT, and is
+   implicitly racy: see __nf_conntrack_confirm */
+void nf_conntrack_alter_reply(struct nf_conn *ct,
+			      const struct nf_conntrack_tuple *newreply)
+{
+	struct nf_conn_help *help = nfct_help(ct);
+
+	write_lock_bh(&nf_conntrack_lock);
+	/* Should be unconfirmed, so not in hash table yet */
+	NF_CT_ASSERT(!nf_ct_is_confirmed(ct));
+
+	DEBUGP("Altering reply tuple of %p to ", ct);
+	NF_CT_DUMP_TUPLE(newreply);
+
+	ct->tuplehash[IP_CT_DIR_REPLY].tuple = *newreply;
+	if (!ct->master && help && help->expecting == 0)
+		help->helper = __nf_ct_helper_find(newreply);
+	write_unlock_bh(&nf_conntrack_lock);
+}
+
 /* Refresh conntrack for this many jiffies and do accounting if do_acct is 1 */
 void __nf_ct_refresh_acct(struct nf_conn *ct,
 			  enum ip_conntrack_info ctinfo,
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index f9c8ddd..bd1d2de 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -39,7 +39,11 @@ #include <net/netfilter/nf_conntrack_exp
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <net/netfilter/nf_conntrack_l3proto.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
-#include <linux/netfilter_ipv4/ip_nat_protocol.h>
+#include <net/netfilter/nf_conntrack_tuple.h>
+#ifdef CONFIG_NF_NAT_NEEDED
+#include <net/netfilter/nf_nat_core.h>
+#include <net/netfilter/nf_nat_protocol.h>
+#endif
 
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nfnetlink_conntrack.h>
@@ -430,7 +434,7 @@ ctnetlink_dump_table(struct sk_buff *skb
 restart:
 		list_for_each_prev(i, &nf_conntrack_hash[cb->args[0]]) {
 			h = (struct nf_conntrack_tuple_hash *) i;
-			if (DIRECTION(h) != IP_CT_DIR_ORIGINAL)
+			if (NF_CT_DIRECTION(h) != IP_CT_DIR_ORIGINAL)
 				continue;
 			ct = nf_ct_tuplehash_to_ctrack(h);
 			/* Dump entries of a given L3 protocol number.
@@ -556,28 +560,28 @@ ctnetlink_parse_tuple(struct nfattr *cda
 	return 0;
 }
 
-#ifdef CONFIG_IP_NF_NAT_NEEDED
+#ifdef CONFIG_NF_NAT_NEEDED
 static const size_t cta_min_protonat[CTA_PROTONAT_MAX] = {
 	[CTA_PROTONAT_PORT_MIN-1]       = sizeof(u_int16_t),
 	[CTA_PROTONAT_PORT_MAX-1]       = sizeof(u_int16_t),
 };
 
-static int ctnetlink_parse_nat_proto(struct nfattr *attr,
+static int nfnetlink_parse_nat_proto(struct nfattr *attr,
 				     const struct nf_conn *ct,
-				     struct ip_nat_range *range)
+				     struct nf_nat_range *range)
 {
 	struct nfattr *tb[CTA_PROTONAT_MAX];
-	struct ip_nat_protocol *npt;
+	struct nf_nat_protocol *npt;
 
 	nfattr_parse_nested(tb, CTA_PROTONAT_MAX, attr);
 
 	if (nfattr_bad_size(tb, CTA_PROTONAT_MAX, cta_min_protonat))
 		return -EINVAL;
 
-	npt = ip_nat_proto_find_get(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum);
+	npt = nf_nat_proto_find_get(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum);
 
 	if (!npt->nfattr_to_range) {
-		ip_nat_proto_put(npt);
+		nf_nat_proto_put(npt);
 		return 0;
 	}
 
@@ -585,7 +589,7 @@ static int ctnetlink_parse_nat_proto(str
 	if (npt->nfattr_to_range(tb, range) > 0)
 		range->flags |= IP_NAT_RANGE_PROTO_SPECIFIED;
 
-	ip_nat_proto_put(npt);
+	nf_nat_proto_put(npt);
 
 	return 0;
 }
@@ -596,8 +600,8 @@ static const size_t cta_min_nat[CTA_NAT_
 };
 
 static inline int
-ctnetlink_parse_nat(struct nfattr *nat,
-		    const struct nf_conn *ct, struct ip_nat_range *range)
+nfnetlink_parse_nat(struct nfattr *nat,
+		    const struct nf_conn *ct, struct nf_nat_range *range)
 {
 	struct nfattr *tb[CTA_NAT_MAX];
 	int err;
@@ -623,7 +627,7 @@ ctnetlink_parse_nat(struct nfattr *nat,
 	if (!tb[CTA_NAT_PROTO-1])
 		return 0;
 
-	err = ctnetlink_parse_nat_proto(tb[CTA_NAT_PROTO-1], ct, range);
+	err = nfnetlink_parse_nat_proto(tb[CTA_NAT_PROTO-1], ct, range);
 	if (err < 0)
 		return err;
 
@@ -798,35 +802,35 @@ ctnetlink_change_status(struct nf_conn *
 		return -EINVAL;
 
 	if (cda[CTA_NAT_SRC-1] || cda[CTA_NAT_DST-1]) {
-#ifndef CONFIG_IP_NF_NAT_NEEDED
+#ifndef CONFIG_NF_NAT_NEEDED
 		return -EINVAL;
 #else
-		struct ip_nat_range range;
+		struct nf_nat_range range;
 
 		if (cda[CTA_NAT_DST-1]) {
-			if (ctnetlink_parse_nat(cda[CTA_NAT_DST-1], ct,
+			if (nfnetlink_parse_nat(cda[CTA_NAT_DST-1], ct,
 						&range) < 0)
 				return -EINVAL;
-			if (ip_nat_initialized(ct,
+			if (nf_nat_initialized(ct,
 					       HOOK2MANIP(NF_IP_PRE_ROUTING)))
 				return -EEXIST;
-			ip_nat_setup_info(ct, &range, hooknum);
+			nf_nat_setup_info(ct, &range, NF_IP_PRE_ROUTING);
 		}
 		if (cda[CTA_NAT_SRC-1]) {
-			if (ctnetlink_parse_nat(cda[CTA_NAT_SRC-1], ct,
+			if (nfnetlink_parse_nat(cda[CTA_NAT_SRC-1], ct,
 						&range) < 0)
 				return -EINVAL;
-			if (ip_nat_initialized(ct,
+			if (nf_nat_initialized(ct,
 					       HOOK2MANIP(NF_IP_POST_ROUTING)))
 				return -EEXIST;
-			ip_nat_setup_info(ct, &range, hooknum);
+			nf_nat_setup_info(ct, &range, NF_IP_POST_ROUTING);
 		}
 #endif
 	}
 
 	/* Be careful here, modifying NAT bits can screw up things,
 	 * so don't let users modify them directly if they don't pass
-	 * ip_nat_range. */
+	 * nf_nat_range. */
 	ct->status |= status & ~(IPS_NAT_DONE_MASK | IPS_NAT_MASK);
 	return 0;
 }
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 71f492f..8156e42 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -730,7 +730,7 @@ static int tcp_in_window(struct ip_ct_tc
 	return res;
 }
 
-#ifdef CONFIG_IP_NF_NAT_NEEDED
+#ifdef CONFIG_NF_NAT_NEEDED
 /* Update sender->td_end after NAT successfully mangled the packet */
 /* Caller must linearize skb at tcp header. */
 void nf_conntrack_tcp_update(struct sk_buff *skb,
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index be94b63..3f56a3a 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -530,8 +530,11 @@ EXPORT_SYMBOL(nf_conntrack_lock);
 EXPORT_SYMBOL(nf_conntrack_hash);
 EXPORT_SYMBOL(nf_conntrack_untracked);
 EXPORT_SYMBOL_GPL(nf_conntrack_find_get);
-#ifdef CONFIG_IP_NF_NAT_NEEDED
+#ifdef CONFIG_NF_NAT_NEEDED
 EXPORT_SYMBOL(nf_conntrack_tcp_update);
+EXPORT_SYMBOL(nf_conntrack_register_cache);
+EXPORT_SYMBOL(nf_conntrack_unregister_cache);
+EXPORT_SYMBOL(nf_conntrack_alter_reply);
 #endif
 EXPORT_SYMBOL(__nf_conntrack_confirm);
 EXPORT_SYMBOL(nf_ct_get_tuple);
