From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: commit 720350a38b1dbd43c907d5d81decd6edd6725d81
Date: Tue, 25 Mar 2008 19:06:08 +0100
Message-ID: <1206468391-368-6-git-send-email-jengelh@computergmbh.de>
References: <alpine.LNX.1.10.0803251903230.31276@fbirervta.pbzchgretzou.qr>
 <1206468391-368-1-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-2-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-3-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-4-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-5-git-send-email-jengelh@computergmbh.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:52539 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758891AbYCYSGf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2008 14:06:35 -0400
In-Reply-To: <1206468391-368-5-git-send-email-jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

    [NETFILTER]: Use unsigned types for hooknum and pf vars
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
---
 include/linux/netfilter.h                      |   54 ++++++++-------
 include/linux/netfilter/x_tables.h             |   33 +++++----
 include/net/netfilter/nf_conntrack_core.h      |    2 +-
 include/net/netfilter/nf_conntrack_expect.h    |    2 +-
 include/net/netfilter/nf_conntrack_l4proto.h   |    4 +-
 include/net/netfilter/nf_log.h                 |    6 +-
 include/net/netfilter/nf_queue.h               |    6 +-
 net/bridge/br_netfilter.c                      |    4 +-
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |    5 +-
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |    5 +-
 net/netfilter/core.c                           |    4 +-
 net/netfilter/nf_conntrack_amanda.c            |    2 +-
 net/netfilter/nf_conntrack_core.c              |    2 +-
 net/netfilter/nf_conntrack_expect.c            |    2 +-
 net/netfilter/nf_conntrack_h323_main.c         |    7 +-
 net/netfilter/nf_conntrack_proto_generic.c     |    2 +-
 net/netfilter/nf_conntrack_proto_gre.c         |    2 +-
 net/netfilter/nf_conntrack_proto_sctp.c        |    2 +-
 net/netfilter/nf_conntrack_proto_tcp.c         |    6 +-
 net/netfilter/nf_conntrack_proto_udp.c         |    4 +-
 net/netfilter/nf_conntrack_proto_udplite.c     |    4 +-
 net/netfilter/nf_conntrack_sane.c              |    2 +-
 net/netfilter/nf_conntrack_sip.c               |    8 +-
 net/netfilter/nf_conntrack_tftp.c              |    2 +-
 net/netfilter/nf_internals.h                   |    4 +-
 net/netfilter/nf_log.c                         |    6 +-
 net/netfilter/nf_queue.c                       |   12 ++--
 net/netfilter/nf_sockopt.c                     |   15 ++--
 net/netfilter/x_tables.c                       |   52 ++++++++-------
 29 files changed, 139 insertions(+), 120 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 89e6c72..3a88f7e 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -91,8 +91,8 @@ struct nf_hook_ops
 	/* User fills in from here down. */
 	nf_hookfn *hook;
 	struct module *owner;
-	int pf;
-	int hooknum;
+	unsigned int pf;
+	unsigned int hooknum;
 	/* Hooks are ordered in ascending priority. */
 	int priority;
 };
@@ -101,7 +101,7 @@ struct nf_sockopt_ops
 {
 	struct list_head list;
 
-	int pf;
+	unsigned int pf;
 
 	/* Non-inclusive ranges: use 0/0/NULL to never get called. */
 	int set_optmin;
@@ -139,7 +139,7 @@ extern struct ctl_path nf_net_ipv4_netfilter_sysctl_path[];
 
 extern struct list_head nf_hooks[NPROTO][NF_MAX_HOOKS];
 
-int nf_hook_slow(int pf, unsigned int hook, struct sk_buff *skb,
+int nf_hook_slow(unsigned int pf, unsigned int hook, struct sk_buff *skb,
 		 struct net_device *indev, struct net_device *outdev,
 		 int (*okfn)(struct sk_buff *), int thresh);
 
@@ -150,12 +150,10 @@ int nf_hook_slow(int pf, unsigned int hook, struct sk_buff *skb,
  *	okfn must be invoked by the caller in this case.  Any other return
  *	value indicates the packet has been consumed by the hook.
  */
-static inline int nf_hook_thresh(int pf, unsigned int hook,
-				 struct sk_buff *skb,
-				 struct net_device *indev,
-				 struct net_device *outdev,
-				 int (*okfn)(struct sk_buff *), int thresh,
-				 int cond)
+static inline int
+nf_hook_thresh(unsigned int pf, unsigned int hook, struct sk_buff *skb,
+               struct net_device *indev, struct net_device *outdev,
+               int (*okfn)(struct sk_buff *), int thresh, int cond)
 {
 	if (!cond)
 		return 1;
@@ -166,9 +164,10 @@ static inline int nf_hook_thresh(int pf, unsigned int hook,
 	return nf_hook_slow(pf, hook, skb, indev, outdev, okfn, thresh);
 }
 
-static inline int nf_hook(int pf, unsigned int hook, struct sk_buff *skb,
-			  struct net_device *indev, struct net_device *outdev,
-			  int (*okfn)(struct sk_buff *))
+static inline int
+nf_hook(unsigned int pf, unsigned int hook, struct sk_buff *skb,
+        struct net_device *indev, struct net_device *outdev,
+        int (*okfn)(struct sk_buff *))
 {
 	return nf_hook_thresh(pf, hook, skb, indev, outdev, okfn, INT_MIN, 1);
 }
@@ -211,14 +210,14 @@ __ret;})
 	NF_HOOK_THRESH(pf, hook, skb, indev, outdev, okfn, INT_MIN)
 
 /* Call setsockopt() */
-int nf_setsockopt(struct sock *sk, int pf, int optval, char __user *opt, 
-		  int len);
-int nf_getsockopt(struct sock *sk, int pf, int optval, char __user *opt,
-		  int *len);
+int nf_setsockopt(struct sock *sk, unsigned int pf, int optval,
+                  char __user *opt, int len);
+int nf_getsockopt(struct sock *sk, unsigned int pf, int optval,
+                  char __user *opt, int *len);
 
-int compat_nf_setsockopt(struct sock *sk, int pf, int optval,
+int compat_nf_setsockopt(struct sock *sk, unsigned int pf, int optval,
 		char __user *opt, int len);
-int compat_nf_getsockopt(struct sock *sk, int pf, int optval,
+int compat_nf_getsockopt(struct sock *sk, unsigned int pf, int optval,
 		char __user *opt, int *len);
 
 /* Call this before modifying an existing packet: ensures it is
@@ -269,7 +268,8 @@ extern void nf_unregister_afinfo(const struct nf_afinfo *afinfo);
 extern void (*ip_nat_decode_session)(struct sk_buff *, struct flowi *);
 
 static inline void
-nf_nat_decode_session(struct sk_buff *skb, struct flowi *fl, int family)
+nf_nat_decode_session(struct sk_buff *skb, struct flowi *fl,
+                      unsigned int family)
 {
 #ifdef CONFIG_NF_NAT_NEEDED
 	void (*decodefn)(struct sk_buff *, struct flowi *);
@@ -292,7 +292,7 @@ extern struct proc_dir_entry *proc_net_netfilter;
 #else /* !CONFIG_NETFILTER */
 #define NF_HOOK(pf, hook, skb, indev, outdev, okfn) (okfn)(skb)
 #define NF_HOOK_COND(pf, hook, skb, indev, outdev, okfn, cond) (okfn)(skb)
-static inline int nf_hook_thresh(int pf, unsigned int hook,
+static inline int nf_hook_thresh(unsigned int pf, unsigned int hook,
 				 struct sk_buff *skb,
 				 struct net_device *indev,
 				 struct net_device *outdev,
@@ -301,15 +301,19 @@ static inline int nf_hook_thresh(int pf, unsigned int hook,
 {
 	return okfn(skb);
 }
-static inline int nf_hook(int pf, unsigned int hook, struct sk_buff *skb,
-			  struct net_device *indev, struct net_device *outdev,
-			  int (*okfn)(struct sk_buff *))
+static inline int
+nf_hook(unsigned int pf, unsigned int hook, struct sk_buff *skb,
+        struct net_device *indev, struct net_device *outdev,
+        int (*okfn)(struct sk_buff *))
 {
 	return 1;
 }
 struct flowi;
 static inline void
-nf_nat_decode_session(struct sk_buff *skb, struct flowi *fl, int family) {}
+nf_nat_decode_session(struct sk_buff *skb, struct flowi *fl,
+                      unsigned int family)
+{
+}
 #endif /*CONFIG_NETFILTER*/
 
 #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 2326296..89103e7 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -292,7 +292,7 @@ struct xt_table
 	/* Set this to THIS_MODULE if you are a module, otherwise NULL */
 	struct module *me;
 
-	int af;		/* address/protocol family */
+	unsigned int af;		/* address/protocol family */
 };
 
 #include <linux/netfilter_ipv4.h>
@@ -346,19 +346,21 @@ extern struct xt_table_info *xt_replace_table(struct xt_table *table,
 					      struct xt_table_info *newinfo,
 					      int *error);
 
-extern struct xt_match *xt_find_match(int af, const char *name, u8 revision);
-extern struct xt_target *xt_find_target(int af, const char *name, u8 revision);
-extern struct xt_target *xt_request_find_target(int af, const char *name, 
-						u8 revision);
-extern int xt_find_revision(int af, const char *name, u8 revision, int target,
-			    int *err);
+extern struct xt_match *
+xt_find_match(unsigned int af, const char *name, u8 revision);
+extern struct xt_target *
+xt_find_target(unsigned int af, const char *name, u8 revision);
+extern struct xt_target *
+xt_request_find_target(unsigned int af, const char *name, u8 revision);
+extern int xt_find_revision(unsigned int af, const char *name, u8 revision,
+                            int target, int *err);
 
-extern struct xt_table *xt_find_table_lock(struct net *net, int af,
+extern struct xt_table *xt_find_table_lock(struct net *net, unsigned int af,
 					   const char *name);
 extern void xt_table_unlock(struct xt_table *t);
 
-extern int xt_proto_init(struct net *net, int af);
-extern void xt_proto_fini(struct net *net, int af);
+extern int xt_proto_init(struct net *net, unsigned int af);
+extern void xt_proto_fini(struct net *net, unsigned int af);
 
 extern struct xt_table_info *xt_alloc_table_info(unsigned int size);
 extern void xt_free_table_info(struct xt_table_info *info);
@@ -423,12 +425,13 @@ struct compat_xt_counters_info
 #define COMPAT_XT_ALIGN(s) (((s) + (__alignof__(struct compat_xt_counters)-1)) \
 		& ~(__alignof__(struct compat_xt_counters)-1))
 
-extern void xt_compat_lock(int af);
-extern void xt_compat_unlock(int af);
+extern void xt_compat_lock(unsigned int af);
+extern void xt_compat_unlock(unsigned int af);
 
-extern int xt_compat_add_offset(int af, unsigned int offset, short delta);
-extern void xt_compat_flush_offsets(int af);
-extern short xt_compat_calc_jump(int af, unsigned int offset);
+extern int xt_compat_add_offset(unsigned int af, unsigned int offset,
+                                short delta);
+extern void xt_compat_flush_offsets(unsigned int af);
+extern short xt_compat_calc_jump(unsigned int af, unsigned int offset);
 
 extern int xt_compat_match_offset(const struct xt_match *match);
 extern int xt_compat_match_from_user(struct xt_entry_match *m,
diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index 9ee2646..74d7a01 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -20,7 +20,7 @@
 /* This header is used to share core functionality between the
    standalone connection tracking module, and the compatibility layer's use
    of connection tracking. */
-extern unsigned int nf_conntrack_in(int pf,
+extern unsigned int nf_conntrack_in(unsigned int pf,
 				    unsigned int hooknum,
 				    struct sk_buff *skb);
 
diff --git a/include/net/netfilter/nf_conntrack_expect.h b/include/net/netfilter/nf_conntrack_expect.h
index dfdf4b4..7d9a18b 100644
--- a/include/net/netfilter/nf_conntrack_expect.h
+++ b/include/net/netfilter/nf_conntrack_expect.h
@@ -86,7 +86,7 @@ void nf_ct_unexpect_related(struct nf_conntrack_expect *exp);
 /* Allocate space for an expectation: this is mandatory before calling
    nf_ct_expect_related.  You will have to call put afterwards. */
 struct nf_conntrack_expect *nf_ct_expect_alloc(struct nf_conn *me);
-void nf_ct_expect_init(struct nf_conntrack_expect *, unsigned int, int,
+void nf_ct_expect_init(struct nf_conntrack_expect *, unsigned int, unsigned int,
 		       const union nf_inet_addr *,
 		       const union nf_inet_addr *,
 		       u_int8_t, const __be16 *, const __be16 *);
diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index efc16ec..1d2f8fd 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -40,7 +40,7 @@ struct nf_conntrack_l4proto
 		      const struct sk_buff *skb,
 		      unsigned int dataoff,
 		      enum ip_conntrack_info ctinfo,
-		      int pf,
+		      unsigned int pf,
 		      unsigned int hooknum);
 
 	/* Called when a new connection for this protocol found;
@@ -53,7 +53,7 @@ struct nf_conntrack_l4proto
 
 	int (*error)(struct sk_buff *skb, unsigned int dataoff,
 		     enum ip_conntrack_info *ctinfo,
-		     int pf, unsigned int hooknum);
+		     unsigned int pf, unsigned int hooknum);
 
 	/* Print out the per-protocol part of the tuple. Return like seq_* */
 	int (*print_tuple)(struct seq_file *s,
diff --git a/include/net/netfilter/nf_log.h b/include/net/netfilter/nf_log.h
index 8c6b5ae..0c910de 100644
--- a/include/net/netfilter/nf_log.h
+++ b/include/net/netfilter/nf_log.h
@@ -43,12 +43,12 @@ struct nf_logger {
 };
 
 /* Function to register/unregister log function. */
-int nf_log_register(int pf, const struct nf_logger *logger);
+int nf_log_register(unsigned int pf, const struct nf_logger *logger);
 void nf_log_unregister(const struct nf_logger *logger);
-void nf_log_unregister_pf(int pf);
+void nf_log_unregister_pf(unsigned int pf);
 
 /* Calls the registered backend logging function */
-void nf_log_packet(int pf,
+void nf_log_packet(unsigned int pf,
 		   unsigned int hooknum,
 		   const struct sk_buff *skb,
 		   const struct net_device *in,
diff --git a/include/net/netfilter/nf_queue.h b/include/net/netfilter/nf_queue.h
index d030044..00497f0 100644
--- a/include/net/netfilter/nf_queue.h
+++ b/include/net/netfilter/nf_queue.h
@@ -8,7 +8,7 @@ struct nf_queue_entry {
 	unsigned int		id;
 
 	struct nf_hook_ops	*elem;
-	int			pf;
+	unsigned int		pf;
 	unsigned int		hook;
 	struct net_device	*indev;
 	struct net_device	*outdev;
@@ -24,9 +24,9 @@ struct nf_queue_handler {
 	char			*name;
 };
 
-extern int nf_register_queue_handler(int pf,
+extern int nf_register_queue_handler(unsigned int pf,
 				     const struct nf_queue_handler *qh);
-extern int nf_unregister_queue_handler(int pf,
+extern int nf_unregister_queue_handler(unsigned int pf,
 				       const struct nf_queue_handler *qh);
 extern void nf_unregister_queue_handlers(const struct nf_queue_handler *qh);
 extern void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict);
diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index 0278a06..36fdfcb 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -649,7 +649,7 @@ static unsigned int br_nf_forward_ip(unsigned int hook, struct sk_buff *skb,
 {
 	struct nf_bridge_info *nf_bridge;
 	struct net_device *parent;
-	int pf;
+	unsigned int pf;
 
 	if (!skb->nf_bridge)
 		return NF_ACCEPT;
@@ -783,7 +783,7 @@ static unsigned int br_nf_post_routing(unsigned int hook, struct sk_buff *skb,
 {
 	struct nf_bridge_info *nf_bridge = skb->nf_bridge;
 	struct net_device *realoutdev = bridge_parent(skb->dev);
-	int pf;
+	unsigned int pf;
 
 #ifdef CONFIG_NETFILTER_DEBUG
 	/* Be very paranoid. This probably won't happen anymore, but let's
diff --git a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
index 6873fdd..999f305 100644
--- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
@@ -80,7 +80,7 @@ static int icmp_packet(struct nf_conn *ct,
 		       const struct sk_buff *skb,
 		       unsigned int dataoff,
 		       enum ip_conntrack_info ctinfo,
-		       int pf,
+		       unsigned int pf,
 		       unsigned int hooknum)
 {
 	/* Try to delete connection immediately after all replies:
@@ -175,7 +175,8 @@ icmp_error_message(struct sk_buff *skb,
 /* Small and modified version of icmp_rcv */
 static int
 icmp_error(struct sk_buff *skb, unsigned int dataoff,
-	   enum ip_conntrack_info *ctinfo, int pf, unsigned int hooknum)
+           enum ip_conntrack_info *ctinfo, unsigned int pf,
+           unsigned int hooknum)
 {
 	const struct icmphdr *icmph;
 	struct icmphdr _ih;
diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
index 0897d0f..a7551ad 100644
--- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
@@ -81,7 +81,7 @@ static int icmpv6_packet(struct nf_conn *ct,
 		       const struct sk_buff *skb,
 		       unsigned int dataoff,
 		       enum ip_conntrack_info ctinfo,
-		       int pf,
+		       unsigned int pf,
 		       unsigned int hooknum)
 {
 	/* Try to delete connection immediately after all replies:
@@ -175,7 +175,8 @@ icmpv6_error_message(struct sk_buff *skb,
 
 static int
 icmpv6_error(struct sk_buff *skb, unsigned int dataoff,
-	     enum ip_conntrack_info *ctinfo, int pf, unsigned int hooknum)
+             enum ip_conntrack_info *ctinfo, unsigned int pf,
+             unsigned int hooknum)
 {
 	const struct icmp6hdr *icmp6h;
 	struct icmp6hdr _ih;
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index ec05684..7cdd94b 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -113,7 +113,7 @@ EXPORT_SYMBOL(nf_unregister_hooks);
 
 unsigned int nf_iterate(struct list_head *head,
 			struct sk_buff *skb,
-			int hook,
+			unsigned int hook,
 			const struct net_device *indev,
 			const struct net_device *outdev,
 			struct list_head **i,
@@ -155,7 +155,7 @@ unsigned int nf_iterate(struct list_head *head,
 
 /* Returns 1 if okfn() needs to be executed by the caller,
  * -EPERM for NF_DROP, 0 otherwise. */
-int nf_hook_slow(int pf, unsigned int hook, struct sk_buff *skb,
+int nf_hook_slow(unsigned int pf, unsigned int hook, struct sk_buff *skb,
 		 struct net_device *indev,
 		 struct net_device *outdev,
 		 int (*okfn)(struct sk_buff *),
diff --git a/net/netfilter/nf_conntrack_amanda.c b/net/netfilter/nf_conntrack_amanda.c
index ddfac99..074ec60 100644
--- a/net/netfilter/nf_conntrack_amanda.c
+++ b/net/netfilter/nf_conntrack_amanda.c
@@ -91,7 +91,7 @@ static int amanda_help(struct sk_buff *skb,
 	char pbuf[sizeof("65535")], *tmp;
 	u_int16_t len;
 	__be16 port;
-	int family = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
+	unsigned int family = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
 	int ret = NF_ACCEPT;
 	typeof(nf_nat_amanda_hook) nf_nat_amanda;
 
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index b77eb56..2c4eaff 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -665,7 +665,7 @@ resolve_normal_ct(struct sk_buff *skb,
 }
 
 unsigned int
-nf_conntrack_in(int pf, unsigned int hooknum, struct sk_buff *skb)
+nf_conntrack_in(unsigned int pf, unsigned int hooknum, struct sk_buff *skb)
 {
 	struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index e31beeb..136d0bf 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -241,7 +241,7 @@ struct nf_conntrack_expect *nf_ct_expect_alloc(struct nf_conn *me)
 EXPORT_SYMBOL_GPL(nf_ct_expect_alloc);
 
 void nf_ct_expect_init(struct nf_conntrack_expect *exp, unsigned int class,
-		       int family,
+		       unsigned int family,
 		       const union nf_inet_addr *saddr,
 		       const union nf_inet_addr *daddr,
 		       u_int8_t proto, const __be16 *src, const __be16 *dst)
diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
index 505052d..a8f2267 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -218,7 +218,7 @@ static int get_h245_addr(struct nf_conn *ct, const unsigned char *data,
 			 union nf_inet_addr *addr, __be16 *port)
 {
 	const unsigned char *p;
-	int family = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
+	unsigned int family = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
 	int len;
 
 	if (taddr->choice != eH245_TransportAddress_unicastAddress)
@@ -634,7 +634,7 @@ int get_h225_addr(struct nf_conn *ct, unsigned char *data,
 		  union nf_inet_addr *addr, __be16 *port)
 {
 	const unsigned char *p;
-	int family = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
+	unsigned int family = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
 	int len;
 
 	switch (taddr->choice) {
@@ -714,7 +714,8 @@ static int expect_h245(struct sk_buff *skb, struct nf_conn *ct,
 /* If the calling party is on the same side of the forward-to party,
  * we don't need to track the second call */
 static int callforward_do_filter(const union nf_inet_addr *src,
-                                 const union nf_inet_addr *dst, int family)
+                                 const union nf_inet_addr *dst,
+				 unsigned int family)
 {
 	const struct nf_afinfo *afinfo;
 	struct flowi fl1, fl2;
diff --git a/net/netfilter/nf_conntrack_proto_generic.c b/net/netfilter/nf_conntrack_proto_generic.c
index 5545891..6470194 100644
--- a/net/netfilter/nf_conntrack_proto_generic.c
+++ b/net/netfilter/nf_conntrack_proto_generic.c
@@ -45,7 +45,7 @@ static int packet(struct nf_conn *ct,
 		  const struct sk_buff *skb,
 		  unsigned int dataoff,
 		  enum ip_conntrack_info ctinfo,
-		  int pf,
+		  unsigned int pf,
 		  unsigned int hooknum)
 {
 	nf_ct_refresh_acct(ct, ctinfo, skb, nf_ct_generic_timeout);
diff --git a/net/netfilter/nf_conntrack_proto_gre.c b/net/netfilter/nf_conntrack_proto_gre.c
index e10024a..e85096e 100644
--- a/net/netfilter/nf_conntrack_proto_gre.c
+++ b/net/netfilter/nf_conntrack_proto_gre.c
@@ -216,7 +216,7 @@ static int gre_packet(struct nf_conn *ct,
 		      const struct sk_buff *skb,
 		      unsigned int dataoff,
 		      enum ip_conntrack_info ctinfo,
-		      int pf,
+		      unsigned int pf,
 		      unsigned int hooknum)
 {
 	/* If we've seen traffic both ways, this is a GRE connection.
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index f9a0837..d61f83e 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -287,7 +287,7 @@ static int sctp_packet(struct nf_conn *ct,
 		       const struct sk_buff *skb,
 		       unsigned int dataoff,
 		       enum ip_conntrack_info ctinfo,
-		       int pf,
+		       unsigned int pf,
 		       unsigned int hooknum)
 {
 	enum sctp_conntrack new_state, old_state;
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 6256795..b3e557d 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -485,7 +485,7 @@ static int tcp_in_window(const struct nf_conn *ct,
 			 const struct sk_buff *skb,
 			 unsigned int dataoff,
 			 const struct tcphdr *tcph,
-			 int pf)
+			 unsigned int pf)
 {
 	struct ip_ct_tcp_state *sender = &state->seen[dir];
 	struct ip_ct_tcp_state *receiver = &state->seen[!dir];
@@ -744,7 +744,7 @@ static const u8 tcp_valid_flags[(TH_FIN|TH_SYN|TH_RST|TH_ACK|TH_URG) + 1] =
 static int tcp_error(struct sk_buff *skb,
 		     unsigned int dataoff,
 		     enum ip_conntrack_info *ctinfo,
-		     int pf,
+		     unsigned int pf,
 		     unsigned int hooknum)
 {
 	const struct tcphdr *th;
@@ -799,7 +799,7 @@ static int tcp_packet(struct nf_conn *ct,
 		      const struct sk_buff *skb,
 		      unsigned int dataoff,
 		      enum ip_conntrack_info ctinfo,
-		      int pf,
+		      unsigned int pf,
 		      unsigned int hooknum)
 {
 	struct nf_conntrack_tuple *tuple;
diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index b8a35cc..f86aba3 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -66,7 +66,7 @@ static int udp_packet(struct nf_conn *ct,
 		      const struct sk_buff *skb,
 		      unsigned int dataoff,
 		      enum ip_conntrack_info ctinfo,
-		      int pf,
+		      unsigned int pf,
 		      unsigned int hooknum)
 {
 	/* If we've seen traffic both ways, this is some kind of UDP
@@ -91,7 +91,7 @@ static int udp_new(struct nf_conn *ct, const struct sk_buff *skb,
 
 static int udp_error(struct sk_buff *skb, unsigned int dataoff,
 		     enum ip_conntrack_info *ctinfo,
-		     int pf,
+		     unsigned int pf,
 		     unsigned int hooknum)
 {
 	unsigned int udplen = skb->len - dataoff;
diff --git a/net/netfilter/nf_conntrack_proto_udplite.c b/net/netfilter/nf_conntrack_proto_udplite.c
index 9dd03c7..2bf4cf0 100644
--- a/net/netfilter/nf_conntrack_proto_udplite.c
+++ b/net/netfilter/nf_conntrack_proto_udplite.c
@@ -65,7 +65,7 @@ static int udplite_packet(struct nf_conn *ct,
 			  const struct sk_buff *skb,
 			  unsigned int dataoff,
 			  enum ip_conntrack_info ctinfo,
-			  int pf,
+			  unsigned int pf,
 			  unsigned int hooknum)
 {
 	/* If we've seen traffic both ways, this is some kind of UDP
@@ -91,7 +91,7 @@ static int udplite_new(struct nf_conn *ct, const struct sk_buff *skb,
 
 static int udplite_error(struct sk_buff *skb, unsigned int dataoff,
 			 enum ip_conntrack_info *ctinfo,
-			 int pf,
+			 unsigned int pf,
 			 unsigned int hooknum)
 {
 	unsigned int udplen = skb->len - dataoff;
diff --git a/net/netfilter/nf_conntrack_sane.c b/net/netfilter/nf_conntrack_sane.c
index 7542e25..4f3d0cb 100644
--- a/net/netfilter/nf_conntrack_sane.c
+++ b/net/netfilter/nf_conntrack_sane.c
@@ -72,7 +72,7 @@ static int help(struct sk_buff *skb,
 	struct nf_conntrack_tuple *tuple;
 	struct sane_request *req;
 	struct sane_reply_net_start *reply;
-	int family = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
+	unsigned int family = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
 
 	ct_sane_info = &nfct_help(ct)->help.ct_sane_info;
 	/* Until there's been traffic both ways, don't look in packets. */
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index da5dec6..a939de4 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -142,7 +142,7 @@ static int parse_addr(const struct nf_conn *ct, const char *cp,
                       const char *limit)
 {
 	const char *end;
-	int family = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
+	unsigned int family = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
 	int ret = 0;
 
 	switch (family) {
@@ -739,7 +739,7 @@ static int set_expected_rtp_rtcp(struct sk_buff *skb,
 	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
 	union nf_inet_addr *saddr;
 	struct nf_conntrack_tuple tuple;
-	int family = ct->tuplehash[!dir].tuple.src.l3num;
+	unsigned int family = ct->tuplehash[!dir].tuple.src.l3num;
 	int direct_rtp = 0, skip_expect = 0, ret = NF_DROP;
 	u_int16_t base_port;
 	__be16 rtp_port, rtcp_port;
@@ -870,7 +870,7 @@ static int process_sdp(struct sk_buff *skb,
 {
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
-	int family = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
+	unsigned int family = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
 	unsigned int matchoff, matchlen;
 	unsigned int mediaoff, medialen;
 	unsigned int sdpoff;
@@ -1033,7 +1033,7 @@ static int process_register_request(struct sk_buff *skb,
 	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
 	struct nf_conn_help *help = nfct_help(ct);
 	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
-	int family = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
+	unsigned int family = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
 	unsigned int matchoff, matchlen;
 	struct nf_conntrack_expect *exp;
 	union nf_inet_addr *saddr, daddr;
diff --git a/net/netfilter/nf_conntrack_tftp.c b/net/netfilter/nf_conntrack_tftp.c
index a28341b..95d1743 100644
--- a/net/netfilter/nf_conntrack_tftp.c
+++ b/net/netfilter/nf_conntrack_tftp.c
@@ -44,7 +44,7 @@ static int tftp_help(struct sk_buff *skb,
 	struct nf_conntrack_expect *exp;
 	struct nf_conntrack_tuple *tuple;
 	unsigned int ret = NF_ACCEPT;
-	int family = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
+	unsigned int family = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
 	typeof(nf_nat_tftp_hook) nf_nat_tftp;
 
 	tfh = skb_header_pointer(skb, protoff + sizeof(struct udphdr),
diff --git a/net/netfilter/nf_internals.h b/net/netfilter/nf_internals.h
index 196269c..0c3fcd6 100644
--- a/net/netfilter/nf_internals.h
+++ b/net/netfilter/nf_internals.h
@@ -15,7 +15,7 @@
 /* core.c */
 extern unsigned int nf_iterate(struct list_head *head,
 				struct sk_buff *skb,
-				int hook,
+				unsigned int hook,
 				const struct net_device *indev,
 				const struct net_device *outdev,
 				struct list_head **i,
@@ -25,7 +25,7 @@ extern unsigned int nf_iterate(struct list_head *head,
 /* nf_queue.c */
 extern int nf_queue(struct sk_buff *skb,
 		    struct list_head *elem,
-		    int pf, unsigned int hook,
+		    unsigned int pf, unsigned int hook,
 		    struct net_device *indev,
 		    struct net_device *outdev,
 		    int (*okfn)(struct sk_buff *),
diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index cec9976..f1e858b 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -20,7 +20,7 @@ static DEFINE_MUTEX(nf_log_mutex);
 
 /* return EBUSY if somebody else is registered, EEXIST if the same logger
  * is registred, 0 on success. */
-int nf_log_register(int pf, const struct nf_logger *logger)
+int nf_log_register(unsigned int pf, const struct nf_logger *logger)
 {
 	int ret;
 
@@ -45,7 +45,7 @@ int nf_log_register(int pf, const struct nf_logger *logger)
 }
 EXPORT_SYMBOL(nf_log_register);
 
-void nf_log_unregister_pf(int pf)
+void nf_log_unregister_pf(unsigned int pf)
 {
 	if (pf >= NPROTO)
 		return;
@@ -73,7 +73,7 @@ void nf_log_unregister(const struct nf_logger *logger)
 }
 EXPORT_SYMBOL(nf_log_unregister);
 
-void nf_log_packet(int pf,
+void nf_log_packet(unsigned int pf,
 		   unsigned int hooknum,
 		   const struct sk_buff *skb,
 		   const struct net_device *in,
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index ddc80ea..046dc81 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -22,7 +22,8 @@ static DEFINE_MUTEX(queue_handler_mutex);
 
 /* return EBUSY when somebody else is registered, return EEXIST if the
  * same handler is registered, return 0 in case of success. */
-int nf_register_queue_handler(int pf, const struct nf_queue_handler *qh)
+int nf_register_queue_handler(unsigned int pf,
+                              const struct nf_queue_handler *qh)
 {
 	int ret;
 
@@ -45,7 +46,8 @@ int nf_register_queue_handler(int pf, const struct nf_queue_handler *qh)
 EXPORT_SYMBOL(nf_register_queue_handler);
 
 /* The caller must flush their queue before this */
-int nf_unregister_queue_handler(int pf, const struct nf_queue_handler *qh)
+int nf_unregister_queue_handler(unsigned int pf,
+                                const struct nf_queue_handler *qh)
 {
 	if (pf >= NPROTO)
 		return -EINVAL;
@@ -67,7 +69,7 @@ EXPORT_SYMBOL(nf_unregister_queue_handler);
 
 void nf_unregister_queue_handlers(const struct nf_queue_handler *qh)
 {
-	int pf;
+	unsigned int pf;
 
 	mutex_lock(&queue_handler_mutex);
 	for (pf = 0; pf < NPROTO; pf++)  {
@@ -107,7 +109,7 @@ static void nf_queue_entry_release_refs(struct nf_queue_entry *entry)
  */
 static int __nf_queue(struct sk_buff *skb,
 		      struct list_head *elem,
-		      int pf, unsigned int hook,
+		      unsigned int pf, unsigned int hook,
 		      struct net_device *indev,
 		      struct net_device *outdev,
 		      int (*okfn)(struct sk_buff *),
@@ -191,7 +193,7 @@ err:
 
 int nf_queue(struct sk_buff *skb,
 	     struct list_head *elem,
-	     int pf, unsigned int hook,
+	     unsigned int pf, unsigned int hook,
 	     struct net_device *indev,
 	     struct net_device *outdev,
 	     int (*okfn)(struct sk_buff *),
diff --git a/net/netfilter/nf_sockopt.c b/net/netfilter/nf_sockopt.c
index 3dd4b3c..170521d 100644
--- a/net/netfilter/nf_sockopt.c
+++ b/net/netfilter/nf_sockopt.c
@@ -60,7 +60,7 @@ void nf_unregister_sockopt(struct nf_sockopt_ops *reg)
 }
 EXPORT_SYMBOL(nf_unregister_sockopt);
 
-static struct nf_sockopt_ops *nf_sockopt_find(struct sock *sk, int pf,
+static struct nf_sockopt_ops *nf_sockopt_find(struct sock *sk, unsigned int pf,
 		int val, int get)
 {
 	struct nf_sockopt_ops *ops;
@@ -96,7 +96,7 @@ out:
 }
 
 /* Call get/setsockopt() */
-static int nf_sockopt(struct sock *sk, int pf, int val,
+static int nf_sockopt(struct sock *sk, unsigned int pf, int val,
 		      char __user *opt, int *len, int get)
 {
 	struct nf_sockopt_ops *ops;
@@ -115,21 +115,22 @@ static int nf_sockopt(struct sock *sk, int pf, int val,
 	return ret;
 }
 
-int nf_setsockopt(struct sock *sk, int pf, int val, char __user *opt,
+int nf_setsockopt(struct sock *sk, unsigned int pf, int val, char __user *opt,
 		  int len)
 {
 	return nf_sockopt(sk, pf, val, opt, &len, 0);
 }
 EXPORT_SYMBOL(nf_setsockopt);
 
-int nf_getsockopt(struct sock *sk, int pf, int val, char __user *opt, int *len)
+int nf_getsockopt(struct sock *sk, unsigned int pf, int val,
+                  char __user *opt, int *len)
 {
 	return nf_sockopt(sk, pf, val, opt, len, 1);
 }
 EXPORT_SYMBOL(nf_getsockopt);
 
 #ifdef CONFIG_COMPAT
-static int compat_nf_sockopt(struct sock *sk, int pf, int val,
+static int compat_nf_sockopt(struct sock *sk, unsigned int pf, int val,
 			     char __user *opt, int *len, int get)
 {
 	struct nf_sockopt_ops *ops;
@@ -155,14 +156,14 @@ static int compat_nf_sockopt(struct sock *sk, int pf, int val,
 	return ret;
 }
 
-int compat_nf_setsockopt(struct sock *sk, int pf,
+int compat_nf_setsockopt(struct sock *sk, unsigned int pf,
 		int val, char __user *opt, int len)
 {
 	return compat_nf_sockopt(sk, pf, val, opt, &len, 0);
 }
 EXPORT_SYMBOL(compat_nf_setsockopt);
 
-int compat_nf_getsockopt(struct sock *sk, int pf,
+int compat_nf_getsockopt(struct sock *sk, unsigned int pf,
 		int val, char __user *opt, int *len)
 {
 	return compat_nf_sockopt(sk, pf, val, opt, len, 1);
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 4d74dff..78877d5 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -68,7 +68,8 @@ static const char *const xt_prefix[NPROTO] = {
 int
 xt_register_target(struct xt_target *target)
 {
-	int ret, af = target->family;
+	unsigned int af = target->family;
+	int ret;
 
 	ret = mutex_lock_interruptible(&xt[af].mutex);
 	if (ret != 0)
@@ -82,7 +83,7 @@ EXPORT_SYMBOL(xt_register_target);
 void
 xt_unregister_target(struct xt_target *target)
 {
-	int af = target->family;
+	unsigned int af = target->family;
 
 	mutex_lock(&xt[af].mutex);
 	list_del(&target->list);
@@ -123,7 +124,8 @@ EXPORT_SYMBOL(xt_unregister_targets);
 int
 xt_register_match(struct xt_match *match)
 {
-	int ret, af = match->family;
+	unsigned int af = match->family;
+	int ret;
 
 	ret = mutex_lock_interruptible(&xt[af].mutex);
 	if (ret != 0)
@@ -139,7 +141,7 @@ EXPORT_SYMBOL(xt_register_match);
 void
 xt_unregister_match(struct xt_match *match)
 {
-	int af =  match->family;
+	unsigned int af = match->family;
 
 	mutex_lock(&xt[af].mutex);
 	list_del(&match->list);
@@ -185,7 +187,7 @@ EXPORT_SYMBOL(xt_unregister_matches);
  */
 
 /* Find match, grabs ref.  Returns ERR_PTR() on error. */
-struct xt_match *xt_find_match(int af, const char *name, u8 revision)
+struct xt_match *xt_find_match(unsigned int af, const char *name, u8 revision)
 {
 	struct xt_match *m;
 	int err = 0;
@@ -210,7 +212,7 @@ struct xt_match *xt_find_match(int af, const char *name, u8 revision)
 EXPORT_SYMBOL(xt_find_match);
 
 /* Find target, grabs ref.  Returns ERR_PTR() on error. */
-struct xt_target *xt_find_target(int af, const char *name, u8 revision)
+struct xt_target *xt_find_target(unsigned int af, const char *name, u8 revision)
 {
 	struct xt_target *t;
 	int err = 0;
@@ -234,7 +236,8 @@ struct xt_target *xt_find_target(int af, const char *name, u8 revision)
 }
 EXPORT_SYMBOL(xt_find_target);
 
-struct xt_target *xt_request_find_target(int af, const char *name, u8 revision)
+struct xt_target *xt_request_find_target(unsigned int af, const char *name,
+                                         u8 revision)
 {
 	struct xt_target *target;
 
@@ -246,7 +249,8 @@ struct xt_target *xt_request_find_target(int af, const char *name, u8 revision)
 }
 EXPORT_SYMBOL_GPL(xt_request_find_target);
 
-static int match_revfn(int af, const char *name, u8 revision, int *bestp)
+static int match_revfn(unsigned int af, const char *name, u8 revision,
+                       int *bestp)
 {
 	const struct xt_match *m;
 	int have_rev = 0;
@@ -262,7 +266,8 @@ static int match_revfn(int af, const char *name, u8 revision, int *bestp)
 	return have_rev;
 }
 
-static int target_revfn(int af, const char *name, u8 revision, int *bestp)
+static int target_revfn(unsigned int af, const char *name, u8 revision,
+                        int *bestp)
 {
 	const struct xt_target *t;
 	int have_rev = 0;
@@ -279,8 +284,8 @@ static int target_revfn(int af, const char *name, u8 revision, int *bestp)
 }
 
 /* Returns true or false (if no such extension at all) */
-int xt_find_revision(int af, const char *name, u8 revision, int target,
-		     int *err)
+int xt_find_revision(unsigned int af, const char *name, u8 revision,
+                     int target, int *err)
 {
 	int have_rev, best = -1;
 
@@ -337,7 +342,7 @@ int xt_check_match(const struct xt_match *match, unsigned short family,
 EXPORT_SYMBOL_GPL(xt_check_match);
 
 #ifdef CONFIG_COMPAT
-int xt_compat_add_offset(int af, unsigned int offset, short delta)
+int xt_compat_add_offset(unsigned int af, unsigned int offset, short delta)
 {
 	struct compat_delta *tmp;
 
@@ -359,7 +364,7 @@ int xt_compat_add_offset(int af, unsigned int offset, short delta)
 }
 EXPORT_SYMBOL_GPL(xt_compat_add_offset);
 
-void xt_compat_flush_offsets(int af)
+void xt_compat_flush_offsets(unsigned int af)
 {
 	struct compat_delta *tmp, *next;
 
@@ -373,7 +378,7 @@ void xt_compat_flush_offsets(int af)
 }
 EXPORT_SYMBOL_GPL(xt_compat_flush_offsets);
 
-short xt_compat_calc_jump(int af, unsigned int offset)
+short xt_compat_calc_jump(unsigned int af, unsigned int offset)
 {
 	struct compat_delta *tmp;
 	short delta;
@@ -590,7 +595,8 @@ void xt_free_table_info(struct xt_table_info *info)
 EXPORT_SYMBOL(xt_free_table_info);
 
 /* Find table by name, grabs mutex & ref.  Returns ERR_PTR() on error. */
-struct xt_table *xt_find_table_lock(struct net *net, int af, const char *name)
+struct xt_table *xt_find_table_lock(struct net *net, unsigned int af,
+                                    const char *name)
 {
 	struct xt_table *t;
 
@@ -612,13 +618,13 @@ void xt_table_unlock(struct xt_table *table)
 EXPORT_SYMBOL_GPL(xt_table_unlock);
 
 #ifdef CONFIG_COMPAT
-void xt_compat_lock(int af)
+void xt_compat_lock(unsigned int af)
 {
 	mutex_lock(&xt[af].compat_mutex);
 }
 EXPORT_SYMBOL_GPL(xt_compat_lock);
 
-void xt_compat_unlock(int af)
+void xt_compat_unlock(unsigned int af)
 {
 	mutex_unlock(&xt[af].compat_mutex);
 }
@@ -722,13 +728,13 @@ EXPORT_SYMBOL_GPL(xt_unregister_table);
 #ifdef CONFIG_PROC_FS
 struct xt_names_priv {
 	struct seq_net_private p;
-	int af;
+	unsigned int af;
 };
 static void *xt_table_seq_start(struct seq_file *seq, loff_t *pos)
 {
 	struct xt_names_priv *priv = seq->private;
 	struct net *net = priv->p.net;
-	int af = priv->af;
+	unsigned int af = priv->af;
 
 	mutex_lock(&xt[af].mutex);
 	return seq_list_start(&net->xt.tables[af], *pos);
@@ -738,7 +744,7 @@ static void *xt_table_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
 	struct xt_names_priv *priv = seq->private;
 	struct net *net = priv->p.net;
-	int af = priv->af;
+	unsigned int af = priv->af;
 
 	return seq_list_next(v, &net->xt.tables[af], pos);
 }
@@ -746,7 +752,7 @@ static void *xt_table_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 static void xt_table_seq_stop(struct seq_file *seq, void *v)
 {
 	struct xt_names_priv *priv = seq->private;
-	int af = priv->af;
+	unsigned int af = priv->af;
 
 	mutex_unlock(&xt[af].mutex);
 }
@@ -922,7 +928,7 @@ static const struct file_operations xt_target_ops = {
 
 #endif /* CONFIG_PROC_FS */
 
-int xt_proto_init(struct net *net, int af)
+int xt_proto_init(struct net *net, unsigned int af)
 {
 #ifdef CONFIG_PROC_FS
 	char buf[XT_FUNCTION_MAXNAMELEN];
@@ -975,7 +981,7 @@ out:
 }
 EXPORT_SYMBOL_GPL(xt_proto_init);
 
-void xt_proto_fini(struct net *net, int af)
+void xt_proto_fini(struct net *net, unsigned int af)
 {
 #ifdef CONFIG_PROC_FS
 	char buf[XT_FUNCTION_MAXNAMELEN];
