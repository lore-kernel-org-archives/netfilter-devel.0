From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 3/8] [NETFILTER]: Use unsigned types for hooknum and pf
 vars
Date: Sat, 12 Apr 2008 10:40:51 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0804121040010.8405@fbirervta.pbzchgretzou.qr>
References: <1207664257-1927-1-git-send-email-jengelh@computergmbh.de> <91d87468ffa4c7a133c1ec294dbbd99f6642dd29.1207664141.git.jengelh@computergmbh.de> <47FB8AFB.4050904@trash.net> <alpine.LNX.1.10.0804091817420.3866@fbirervta.pbzchgretzou.qr>
 <47FCECFD.3050201@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:54053 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010AbYDLIky (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 12 Apr 2008 04:40:54 -0400
In-Reply-To: <47FCECFD.3050201@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2008-04-09 18:21, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> On Tuesday 2008-04-08 17:10, Patrick McHardy wrote:
>> > Jan Engelhardt wrote:
>> > > and (try to) consistently use u_int16_t for the L3 family.
>> > Let me think about this. I know I suggested to use u_int16_t,
>> > but ypur last patch was only for conntrack, and thats what it
>> > uses in the tuple (only to fill a hole). The protocol is
>> > *actually* a u8, and thats also what all the others use or
>> > should use.
>> 
>> So your resolution is..- moving everything to uint8?
>
> None so far

Then let me buy an '8'.

commit ee0b72bf5e7bb0d57042013d01a66f4cd1ab9b47
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Sat Apr 12 08:24:12 2008 +0200

    [NETFILTER]: Use unsigned types for hooknum and pf vars
    
    and (try to) consistently use u_int8_t for the L3 family.
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
---
 include/linux/netfilter.h                      |   30 +++++-----
 include/linux/netfilter/x_tables.h             |   30 +++++-----
 include/net/netfilter/nf_conntrack_core.h      |    2 +-
 include/net/netfilter/nf_conntrack_expect.h    |    2 +-
 include/net/netfilter/nf_conntrack_l4proto.h   |    4 +-
 include/net/netfilter/nf_conntrack_tuple.h     |   31 ++--------
 include/net/netfilter/nf_log.h                 |    8 +-
 include/net/netfilter/nf_queue.h               |    6 +-
 net/bridge/br_netfilter.c                      |    4 +-
 net/bridge/netfilter/ebt_log.c                 |    2 +-
 net/bridge/netfilter/ebt_ulog.c                |    2 +-
 net/ipv4/netfilter/ipt_LOG.c                   |    2 +-
 net/ipv4/netfilter/ipt_ULOG.c                  |    2 +-
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |    4 +-
 net/ipv6/netfilter/ip6t_LOG.c                  |    2 +-
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |    4 +-
 net/netfilter/core.c                           |    4 +-
 net/netfilter/nf_conntrack_core.c              |    6 +-
 net/netfilter/nf_conntrack_expect.c            |    2 +-
 net/netfilter/nf_conntrack_h323_main.c         |    3 +-
 net/netfilter/nf_conntrack_proto_dccp.c        |    4 +-
 net/netfilter/nf_conntrack_proto_generic.c     |    2 +-
 net/netfilter/nf_conntrack_proto_gre.c         |    2 +-
 net/netfilter/nf_conntrack_proto_sctp.c        |    2 +-
 net/netfilter/nf_conntrack_proto_tcp.c         |    6 +-
 net/netfilter/nf_conntrack_proto_udp.c         |    4 +-
 net/netfilter/nf_conntrack_proto_udplite.c     |    4 +-
 net/netfilter/nf_internals.h                   |    4 +-
 net/netfilter/nf_log.c                         |    6 +-
 net/netfilter/nf_queue.c                       |   10 ++--
 net/netfilter/nf_sockopt.c                     |   15 +++--
 net/netfilter/nfnetlink_log.c                  |    4 +-
 net/netfilter/x_tables.c                       |   48 ++++++++-------
 net/netfilter/xt_connlimit.c                   |    2 +-
 net/netfilter/xt_conntrack.c                   |    8 +-
 net/netfilter/xt_hashlimit.c                   |   11 ++--
 36 files changed, 137 insertions(+), 145 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index e4c6659..dd4aebf 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -92,8 +92,8 @@ struct nf_hook_ops
 	/* User fills in from here down. */
 	nf_hookfn *hook;
 	struct module *owner;
-	int pf;
-	int hooknum;
+	u_int8_t pf;
+	unsigned int hooknum;
 	/* Hooks are ordered in ascending priority. */
 	int priority;
 };
@@ -102,7 +102,7 @@ struct nf_sockopt_ops
 {
 	struct list_head list;
 
-	int pf;
+	u_int8_t pf;
 
 	/* Non-inclusive ranges: use 0/0/NULL to never get called. */
 	int set_optmin;
@@ -140,7 +140,7 @@ extern struct ctl_path nf_net_ipv4_netfilter_sysctl_path[];
 
 extern struct list_head nf_hooks[NPROTO][NF_MAX_HOOKS];
 
-int nf_hook_slow(int pf, unsigned int hook, struct sk_buff *skb,
+int nf_hook_slow(u_int8_t pf, unsigned int hook, struct sk_buff *skb,
 		 struct net_device *indev, struct net_device *outdev,
 		 int (*okfn)(struct sk_buff *), int thresh);
 
@@ -151,7 +151,7 @@ int nf_hook_slow(int pf, unsigned int hook, struct sk_buff *skb,
  *	okfn must be invoked by the caller in this case.  Any other return
  *	value indicates the packet has been consumed by the hook.
  */
-static inline int nf_hook_thresh(int pf, unsigned int hook,
+static inline int nf_hook_thresh(u_int8_t pf, unsigned int hook,
 				 struct sk_buff *skb,
 				 struct net_device *indev,
 				 struct net_device *outdev,
@@ -167,7 +167,7 @@ static inline int nf_hook_thresh(int pf, unsigned int hook,
 	return nf_hook_slow(pf, hook, skb, indev, outdev, okfn, thresh);
 }
 
-static inline int nf_hook(int pf, unsigned int hook, struct sk_buff *skb,
+static inline int nf_hook(u_int8_t pf, unsigned int hook, struct sk_buff *skb,
 			  struct net_device *indev, struct net_device *outdev,
 			  int (*okfn)(struct sk_buff *))
 {
@@ -212,14 +212,14 @@ __ret;})
 	NF_HOOK_THRESH(pf, hook, skb, indev, outdev, okfn, INT_MIN)
 
 /* Call setsockopt() */
-int nf_setsockopt(struct sock *sk, int pf, int optval, char __user *opt, 
+int nf_setsockopt(struct sock *sk, u_int8_t pf, int optval, char __user *opt,
 		  int len);
-int nf_getsockopt(struct sock *sk, int pf, int optval, char __user *opt,
+int nf_getsockopt(struct sock *sk, u_int8_t pf, int optval, char __user *opt,
 		  int *len);
 
-int compat_nf_setsockopt(struct sock *sk, int pf, int optval,
+int compat_nf_setsockopt(struct sock *sk, u_int8_t pf, int optval,
 		char __user *opt, int len);
-int compat_nf_getsockopt(struct sock *sk, int pf, int optval,
+int compat_nf_getsockopt(struct sock *sk, u_int8_t pf, int optval,
 		char __user *opt, int *len);
 
 /* Call this before modifying an existing packet: ensures it is
@@ -292,7 +292,7 @@ extern void nf_unregister_afinfo(const struct nf_afinfo *afinfo);
 extern void (*ip_nat_decode_session)(struct sk_buff *, struct flowi *);
 
 static inline void
-nf_nat_decode_session(struct sk_buff *skb, struct flowi *fl, int family)
+nf_nat_decode_session(struct sk_buff *skb, struct flowi *fl, u_int8_t family)
 {
 #ifdef CONFIG_NF_NAT_NEEDED
 	void (*decodefn)(struct sk_buff *, struct flowi *);
@@ -315,7 +315,7 @@ extern struct proc_dir_entry *proc_net_netfilter;
 #else /* !CONFIG_NETFILTER */
 #define NF_HOOK(pf, hook, skb, indev, outdev, okfn) (okfn)(skb)
 #define NF_HOOK_COND(pf, hook, skb, indev, outdev, okfn, cond) (okfn)(skb)
-static inline int nf_hook_thresh(int pf, unsigned int hook,
+static inline int nf_hook_thresh(u_int8_t pf, unsigned int hook,
 				 struct sk_buff *skb,
 				 struct net_device *indev,
 				 struct net_device *outdev,
@@ -324,7 +324,7 @@ static inline int nf_hook_thresh(int pf, unsigned int hook,
 {
 	return okfn(skb);
 }
-static inline int nf_hook(int pf, unsigned int hook, struct sk_buff *skb,
+static inline int nf_hook(u_int8_t pf, unsigned int hook, struct sk_buff *skb,
 			  struct net_device *indev, struct net_device *outdev,
 			  int (*okfn)(struct sk_buff *))
 {
@@ -332,7 +332,9 @@ static inline int nf_hook(int pf, unsigned int hook, struct sk_buff *skb,
 }
 struct flowi;
 static inline void
-nf_nat_decode_session(struct sk_buff *skb, struct flowi *fl, int family) {}
+nf_nat_decode_session(struct sk_buff *skb, struct flowi *fl, u_int8_t family)
+{
+}
 #endif /*CONFIG_NETFILTER*/
 
 #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 2326296..5284e30 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -292,7 +292,7 @@ struct xt_table
 	/* Set this to THIS_MODULE if you are a module, otherwise NULL */
 	struct module *me;
 
-	int af;		/* address/protocol family */
+	u_int8_t af;		/* address/protocol family */
 };
 
 #include <linux/netfilter_ipv4.h>
@@ -346,19 +346,21 @@ extern struct xt_table_info *xt_replace_table(struct xt_table *table,
 					      struct xt_table_info *newinfo,
 					      int *error);
 
-extern struct xt_match *xt_find_match(int af, const char *name, u8 revision);
-extern struct xt_target *xt_find_target(int af, const char *name, u8 revision);
-extern struct xt_target *xt_request_find_target(int af, const char *name, 
+extern struct xt_match *xt_find_match(u_int8_t af, const char *name,
+				      u8 revision);
+extern struct xt_target *xt_find_target(u_int8_t af, const char *name,
+					u8 revision);
+extern struct xt_target *xt_request_find_target(u_int8_t af, const char *name,
 						u8 revision);
-extern int xt_find_revision(int af, const char *name, u8 revision, int target,
-			    int *err);
+extern int xt_find_revision(u_int8_t af, const char *name, u8 revision,
+			    int target, int *err);
 
-extern struct xt_table *xt_find_table_lock(struct net *net, int af,
+extern struct xt_table *xt_find_table_lock(struct net *net, u_int8_t af,
 					   const char *name);
 extern void xt_table_unlock(struct xt_table *t);
 
-extern int xt_proto_init(struct net *net, int af);
-extern void xt_proto_fini(struct net *net, int af);
+extern int xt_proto_init(struct net *net, u_int8_t af);
+extern void xt_proto_fini(struct net *net, u_int8_t af);
 
 extern struct xt_table_info *xt_alloc_table_info(unsigned int size);
 extern void xt_free_table_info(struct xt_table_info *info);
@@ -423,12 +425,12 @@ struct compat_xt_counters_info
 #define COMPAT_XT_ALIGN(s) (((s) + (__alignof__(struct compat_xt_counters)-1)) \
 		& ~(__alignof__(struct compat_xt_counters)-1))
 
-extern void xt_compat_lock(int af);
-extern void xt_compat_unlock(int af);
+extern void xt_compat_lock(u_int8_t af);
+extern void xt_compat_unlock(u_int8_t af);
 
-extern int xt_compat_add_offset(int af, unsigned int offset, short delta);
-extern void xt_compat_flush_offsets(int af);
-extern short xt_compat_calc_jump(int af, unsigned int offset);
+extern int xt_compat_add_offset(u_int8_t af, unsigned int offset, short delta);
+extern void xt_compat_flush_offsets(u_int8_t af);
+extern short xt_compat_calc_jump(u_int8_t af, unsigned int offset);
 
 extern int xt_compat_match_offset(const struct xt_match *match);
 extern int xt_compat_match_from_user(struct xt_entry_match *m,
diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index a817712..05760d6 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -20,7 +20,7 @@
 /* This header is used to share core functionality between the
    standalone connection tracking module, and the compatibility layer's use
    of connection tracking. */
-extern unsigned int nf_conntrack_in(int pf,
+extern unsigned int nf_conntrack_in(u_int8_t pf,
 				    unsigned int hooknum,
 				    struct sk_buff *skb);
 
diff --git a/include/net/netfilter/nf_conntrack_expect.h b/include/net/netfilter/nf_conntrack_expect.h
index dfdf4b4..4c4d894 100644
--- a/include/net/netfilter/nf_conntrack_expect.h
+++ b/include/net/netfilter/nf_conntrack_expect.h
@@ -86,7 +86,7 @@ void nf_ct_unexpect_related(struct nf_conntrack_expect *exp);
 /* Allocate space for an expectation: this is mandatory before calling
    nf_ct_expect_related.  You will have to call put afterwards. */
 struct nf_conntrack_expect *nf_ct_expect_alloc(struct nf_conn *me);
-void nf_ct_expect_init(struct nf_conntrack_expect *, unsigned int, int,
+void nf_ct_expect_init(struct nf_conntrack_expect *, unsigned int, u_int8_t,
 		       const union nf_inet_addr *,
 		       const union nf_inet_addr *,
 		       u_int8_t, const __be16 *, const __be16 *);
diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index 723df9d..d4376e9 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -39,7 +39,7 @@ struct nf_conntrack_l4proto
 		      const struct sk_buff *skb,
 		      unsigned int dataoff,
 		      enum ip_conntrack_info ctinfo,
-		      int pf,
+		      u_int8_t pf,
 		      unsigned int hooknum);
 
 	/* Called when a new connection for this protocol found;
@@ -52,7 +52,7 @@ struct nf_conntrack_l4proto
 
 	int (*error)(struct sk_buff *skb, unsigned int dataoff,
 		     enum ip_conntrack_info *ctinfo,
-		     int pf, unsigned int hooknum);
+		     u_int8_t pf, unsigned int hooknum);
 
 	/* Print out the per-protocol part of the tuple. Return like seq_* */
 	int (*print_tuple)(struct seq_file *s,
diff --git a/include/net/netfilter/nf_conntrack_tuple.h b/include/net/netfilter/nf_conntrack_tuple.h
index 1bb7087..d00fc25 100644
--- a/include/net/netfilter/nf_conntrack_tuple.h
+++ b/include/net/netfilter/nf_conntrack_tuple.h
@@ -37,7 +37,12 @@ union nf_conntrack_man_proto
 		__be16 port;
 	} udp;
 	struct {
-		__be16 id;
+		union {
+			__be16 id;
+			struct {
+				__u8 type, code;
+			};
+		};
 	} icmp;
 	struct {
 		__be16 port;
@@ -67,29 +72,7 @@ struct nf_conntrack_tuple
 	/* These are the parts of the tuple which are fixed. */
 	struct {
 		union nf_inet_addr u3;
-		union {
-			/* Add other protocols here. */
-			__be16 all;
-
-			struct {
-				__be16 port;
-			} tcp;
-			struct {
-				__be16 port;
-			} udp;
-			struct {
-				u_int8_t type, code;
-			} icmp;
-			struct {
-				__be16 port;
-			} dccp;
-			struct {
-				__be16 port;
-			} sctp;
-			struct {
-				__be16 key;
-			} gre;
-		} u;
+		union nf_conntrack_man_proto u;
 
 		/* The protocol. */
 		u_int8_t protonum;
diff --git a/include/net/netfilter/nf_log.h b/include/net/netfilter/nf_log.h
index 8c6b5ae..7182c06 100644
--- a/include/net/netfilter/nf_log.h
+++ b/include/net/netfilter/nf_log.h
@@ -28,7 +28,7 @@ struct nf_loginfo {
 	} u;
 };
 
-typedef void nf_logfn(unsigned int pf,
+typedef void nf_logfn(u_int8_t pf,
 		      unsigned int hooknum,
 		      const struct sk_buff *skb,
 		      const struct net_device *in,
@@ -43,12 +43,12 @@ struct nf_logger {
 };
 
 /* Function to register/unregister log function. */
-int nf_log_register(int pf, const struct nf_logger *logger);
+int nf_log_register(u_int8_t pf, const struct nf_logger *logger);
 void nf_log_unregister(const struct nf_logger *logger);
-void nf_log_unregister_pf(int pf);
+void nf_log_unregister_pf(u_int8_t pf);
 
 /* Calls the registered backend logging function */
-void nf_log_packet(int pf,
+void nf_log_packet(u_int8_t pf,
 		   unsigned int hooknum,
 		   const struct sk_buff *skb,
 		   const struct net_device *in,
diff --git a/include/net/netfilter/nf_queue.h b/include/net/netfilter/nf_queue.h
index d030044..252fd10 100644
--- a/include/net/netfilter/nf_queue.h
+++ b/include/net/netfilter/nf_queue.h
@@ -8,7 +8,7 @@ struct nf_queue_entry {
 	unsigned int		id;
 
 	struct nf_hook_ops	*elem;
-	int			pf;
+	u_int8_t		pf;
 	unsigned int		hook;
 	struct net_device	*indev;
 	struct net_device	*outdev;
@@ -24,9 +24,9 @@ struct nf_queue_handler {
 	char			*name;
 };
 
-extern int nf_register_queue_handler(int pf,
+extern int nf_register_queue_handler(u_int8_t pf,
 				     const struct nf_queue_handler *qh);
-extern int nf_unregister_queue_handler(int pf,
+extern int nf_unregister_queue_handler(u_int8_t pf,
 				       const struct nf_queue_handler *qh);
 extern void nf_unregister_queue_handlers(const struct nf_queue_handler *qh);
 extern void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict);
diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index 0278a06..6dbdef3 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -649,7 +649,7 @@ static unsigned int br_nf_forward_ip(unsigned int hook, struct sk_buff *skb,
 {
 	struct nf_bridge_info *nf_bridge;
 	struct net_device *parent;
-	int pf;
+	u_int8_t pf;
 
 	if (!skb->nf_bridge)
 		return NF_ACCEPT;
@@ -783,7 +783,7 @@ static unsigned int br_nf_post_routing(unsigned int hook, struct sk_buff *skb,
 {
 	struct nf_bridge_info *nf_bridge = skb->nf_bridge;
 	struct net_device *realoutdev = bridge_parent(skb->dev);
-	int pf;
+	u_int8_t pf;
 
 #ifdef CONFIG_NETFILTER_DEBUG
 	/* Be very paranoid. This probably won't happen anymore, but let's
diff --git a/net/bridge/netfilter/ebt_log.c b/net/bridge/netfilter/ebt_log.c
index 0b209e4..9e9bcd2 100644
--- a/net/bridge/netfilter/ebt_log.c
+++ b/net/bridge/netfilter/ebt_log.c
@@ -60,7 +60,7 @@ static void print_MAC(const unsigned char *p)
 
 #define myNIPQUAD(a) a[0], a[1], a[2], a[3]
 static void
-ebt_log_packet(unsigned int pf, unsigned int hooknum,
+ebt_log_packet(u_int8_t pf, unsigned int hooknum,
    const struct sk_buff *skb, const struct net_device *in,
    const struct net_device *out, const struct nf_loginfo *loginfo,
    const char *prefix)
diff --git a/net/bridge/netfilter/ebt_ulog.c b/net/bridge/netfilter/ebt_ulog.c
index 2d4c9ef..c84bda6 100644
--- a/net/bridge/netfilter/ebt_ulog.c
+++ b/net/bridge/netfilter/ebt_ulog.c
@@ -223,7 +223,7 @@ alloc_failure:
 }
 
 /* this function is registered with the netfilter core */
-static void ebt_log_packet(unsigned int pf, unsigned int hooknum,
+static void ebt_log_packet(u_int8_t pf, unsigned int hooknum,
    const struct sk_buff *skb, const struct net_device *in,
    const struct net_device *out, const struct nf_loginfo *li,
    const char *prefix)
diff --git a/net/ipv4/netfilter/ipt_LOG.c b/net/ipv4/netfilter/ipt_LOG.c
index 1071a57..15b0fba 100644
--- a/net/ipv4/netfilter/ipt_LOG.c
+++ b/net/ipv4/netfilter/ipt_LOG.c
@@ -375,7 +375,7 @@ static struct nf_loginfo default_loginfo = {
 };
 
 static void
-ipt_log_packet(unsigned int pf,
+ipt_log_packet(u_int8_t pf,
 	       unsigned int hooknum,
 	       const struct sk_buff *skb,
 	       const struct net_device *in,
diff --git a/net/ipv4/netfilter/ipt_ULOG.c b/net/ipv4/netfilter/ipt_ULOG.c
index b192756..d8241e6 100644
--- a/net/ipv4/netfilter/ipt_ULOG.c
+++ b/net/ipv4/netfilter/ipt_ULOG.c
@@ -292,7 +292,7 @@ ulog_tg(struct sk_buff *skb, const struct net_device *in,
 	return XT_CONTINUE;
 }
 
-static void ipt_logfn(unsigned int pf,
+static void ipt_logfn(u_int8_t pf,
 		      unsigned int hooknum,
 		      const struct sk_buff *skb,
 		      const struct net_device *in,
diff --git a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
index 78ab19a..87746a1 100644
--- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
@@ -79,7 +79,7 @@ static int icmp_packet(struct nf_conn *ct,
 		       const struct sk_buff *skb,
 		       unsigned int dataoff,
 		       enum ip_conntrack_info ctinfo,
-		       int pf,
+		       u_int8_t pf,
 		       unsigned int hooknum)
 {
 	/* Try to delete connection immediately after all replies:
@@ -174,7 +174,7 @@ icmp_error_message(struct sk_buff *skb,
 /* Small and modified version of icmp_rcv */
 static int
 icmp_error(struct sk_buff *skb, unsigned int dataoff,
-	   enum ip_conntrack_info *ctinfo, int pf, unsigned int hooknum)
+	   enum ip_conntrack_info *ctinfo, u_int8_t pf, unsigned int hooknum)
 {
 	const struct icmphdr *icmph;
 	struct icmphdr _ih;
diff --git a/net/ipv6/netfilter/ip6t_LOG.c b/net/ipv6/netfilter/ip6t_LOG.c
index 29e01dd..af929b0 100644
--- a/net/ipv6/netfilter/ip6t_LOG.c
+++ b/net/ipv6/netfilter/ip6t_LOG.c
@@ -385,7 +385,7 @@ static struct nf_loginfo default_loginfo = {
 };
 
 static void
-ip6t_log_packet(unsigned int pf,
+ip6t_log_packet(u_int8_t pf,
 		unsigned int hooknum,
 		const struct sk_buff *skb,
 		const struct net_device *in,
diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
index ee713b0..7570c3c 100644
--- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
@@ -81,7 +81,7 @@ static int icmpv6_packet(struct nf_conn *ct,
 		       const struct sk_buff *skb,
 		       unsigned int dataoff,
 		       enum ip_conntrack_info ctinfo,
-		       int pf,
+		       u_int8_t pf,
 		       unsigned int hooknum)
 {
 	/* Try to delete connection immediately after all replies:
@@ -174,7 +174,7 @@ icmpv6_error_message(struct sk_buff *skb,
 
 static int
 icmpv6_error(struct sk_buff *skb, unsigned int dataoff,
-	     enum ip_conntrack_info *ctinfo, int pf, unsigned int hooknum)
+	     enum ip_conntrack_info *ctinfo, u_int8_t pf, unsigned int hooknum)
 {
 	const struct icmp6hdr *icmp6h;
 	struct icmp6hdr _ih;
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 292fa28..26b8f48 100644
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
+int nf_hook_slow(u_int8_t pf, unsigned int hook, struct sk_buff *skb,
 		 struct net_device *indev,
 		 struct net_device *outdev,
 		 int (*okfn)(struct sk_buff *),
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 3512373..90f116f 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -662,7 +662,7 @@ resolve_normal_ct(struct sk_buff *skb,
 }
 
 unsigned int
-nf_conntrack_in(int pf, unsigned int hooknum, struct sk_buff *skb)
+nf_conntrack_in(u_int8_t pf, unsigned int hooknum, struct sk_buff *skb)
 {
 	struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
@@ -680,7 +680,7 @@ nf_conntrack_in(int pf, unsigned int hooknum, struct sk_buff *skb)
 	}
 
 	/* rcu_read_lock()ed by nf_hook_slow */
-	l3proto = __nf_ct_l3proto_find((u_int16_t)pf);
+	l3proto = __nf_ct_l3proto_find(pf);
 	ret = l3proto->get_l4proto(skb, skb_network_offset(skb),
 				   &dataoff, &protonum);
 	if (ret <= 0) {
@@ -690,7 +690,7 @@ nf_conntrack_in(int pf, unsigned int hooknum, struct sk_buff *skb)
 		return -ret;
 	}
 
-	l4proto = __nf_ct_l4proto_find((u_int16_t)pf, protonum);
+	l4proto = __nf_ct_l4proto_find(pf, protonum);
 
 	/* It may be an special packet, error, unclean...
 	 * inverse of the return code tells to the netfilter
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index e31beeb..6b881d8 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -241,7 +241,7 @@ struct nf_conntrack_expect *nf_ct_expect_alloc(struct nf_conn *me)
 EXPORT_SYMBOL_GPL(nf_ct_expect_alloc);
 
 void nf_ct_expect_init(struct nf_conntrack_expect *exp, unsigned int class,
-		       int family,
+		       u_int8_t family,
 		       const union nf_inet_addr *saddr,
 		       const union nf_inet_addr *daddr,
 		       u_int8_t proto, const __be16 *src, const __be16 *dst)
diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
index 95da1a2..2a0ef01 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -708,7 +708,8 @@ static int expect_h245(struct sk_buff *skb, struct nf_conn *ct,
 /* If the calling party is on the same side of the forward-to party,
  * we don't need to track the second call */
 static int callforward_do_filter(const union nf_inet_addr *src,
-                                 const union nf_inet_addr *dst, int family)
+				 const union nf_inet_addr *dst,
+				 u_int8_t family)
 {
 	const struct nf_afinfo *afinfo;
 	struct flowi fl1, fl2;
diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_conntrack_proto_dccp.c
index afb4a18..6b47a0f 100644
--- a/net/netfilter/nf_conntrack_proto_dccp.c
+++ b/net/netfilter/nf_conntrack_proto_dccp.c
@@ -461,7 +461,7 @@ static u64 dccp_ack_seq(const struct dccp_hdr *dh)
 
 static int dccp_packet(struct nf_conn *ct, const struct sk_buff *skb,
 		       unsigned int dataoff, enum ip_conntrack_info ctinfo,
-		       int pf, unsigned int hooknum)
+		       u_int8_t pf, unsigned int hooknum)
 {
 	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
 	struct dccp_hdr _dh, *dh;
@@ -547,7 +547,7 @@ static int dccp_packet(struct nf_conn *ct, const struct sk_buff *skb,
 }
 
 static int dccp_error(struct sk_buff *skb, unsigned int dataoff,
-		      enum ip_conntrack_info *ctinfo, int pf,
+		      enum ip_conntrack_info *ctinfo, u_int8_t pf,
 		      unsigned int hooknum)
 {
 	struct dccp_hdr _dh, *dh;
diff --git a/net/netfilter/nf_conntrack_proto_generic.c b/net/netfilter/nf_conntrack_proto_generic.c
index e31b0e7..dbe680a 100644
--- a/net/netfilter/nf_conntrack_proto_generic.c
+++ b/net/netfilter/nf_conntrack_proto_generic.c
@@ -45,7 +45,7 @@ static int packet(struct nf_conn *ct,
 		  const struct sk_buff *skb,
 		  unsigned int dataoff,
 		  enum ip_conntrack_info ctinfo,
-		  int pf,
+		  u_int8_t pf,
 		  unsigned int hooknum)
 {
 	nf_ct_refresh_acct(ct, ctinfo, skb, nf_ct_generic_timeout);
diff --git a/net/netfilter/nf_conntrack_proto_gre.c b/net/netfilter/nf_conntrack_proto_gre.c
index 654a4f7..0e3d124 100644
--- a/net/netfilter/nf_conntrack_proto_gre.c
+++ b/net/netfilter/nf_conntrack_proto_gre.c
@@ -215,7 +215,7 @@ static int gre_packet(struct nf_conn *ct,
 		      const struct sk_buff *skb,
 		      unsigned int dataoff,
 		      enum ip_conntrack_info ctinfo,
-		      int pf,
+		      u_int8_t pf,
 		      unsigned int hooknum)
 {
 	/* If we've seen traffic both ways, this is a GRE connection.
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index cbf2e27..de5a4e0 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -287,7 +287,7 @@ static int sctp_packet(struct nf_conn *ct,
 		       const struct sk_buff *skb,
 		       unsigned int dataoff,
 		       enum ip_conntrack_info ctinfo,
-		       int pf,
+		       u_int8_t pf,
 		       unsigned int hooknum)
 {
 	enum sctp_conntrack new_state, old_state;
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index ba94004..92afc1c 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -484,7 +484,7 @@ static bool tcp_in_window(const struct nf_conn *ct,
 			  const struct sk_buff *skb,
 			  unsigned int dataoff,
 			  const struct tcphdr *tcph,
-			  int pf)
+			  u_int8_t pf)
 {
 	struct ip_ct_tcp_state *sender = &state->seen[dir];
 	struct ip_ct_tcp_state *receiver = &state->seen[!dir];
@@ -743,7 +743,7 @@ static const u8 tcp_valid_flags[(TH_FIN|TH_SYN|TH_RST|TH_ACK|TH_URG) + 1] =
 static int tcp_error(struct sk_buff *skb,
 		     unsigned int dataoff,
 		     enum ip_conntrack_info *ctinfo,
-		     int pf,
+		     u_int8_t pf,
 		     unsigned int hooknum)
 {
 	const struct tcphdr *th;
@@ -798,7 +798,7 @@ static int tcp_packet(struct nf_conn *ct,
 		      const struct sk_buff *skb,
 		      unsigned int dataoff,
 		      enum ip_conntrack_info ctinfo,
-		      int pf,
+		      u_int8_t pf,
 		      unsigned int hooknum)
 {
 	struct nf_conntrack_tuple *tuple;
diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index 8b21762..2a965c4 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -66,7 +66,7 @@ static int udp_packet(struct nf_conn *ct,
 		      const struct sk_buff *skb,
 		      unsigned int dataoff,
 		      enum ip_conntrack_info ctinfo,
-		      int pf,
+		      u_int8_t pf,
 		      unsigned int hooknum)
 {
 	/* If we've seen traffic both ways, this is some kind of UDP
@@ -91,7 +91,7 @@ static bool udp_new(struct nf_conn *ct, const struct sk_buff *skb,
 
 static int udp_error(struct sk_buff *skb, unsigned int dataoff,
 		     enum ip_conntrack_info *ctinfo,
-		     int pf,
+		     u_int8_t pf,
 		     unsigned int hooknum)
 {
 	unsigned int udplen = skb->len - dataoff;
diff --git a/net/netfilter/nf_conntrack_proto_udplite.c b/net/netfilter/nf_conntrack_proto_udplite.c
index 1fa62f3..4fb6c8d 100644
--- a/net/netfilter/nf_conntrack_proto_udplite.c
+++ b/net/netfilter/nf_conntrack_proto_udplite.c
@@ -65,7 +65,7 @@ static int udplite_packet(struct nf_conn *ct,
 			  const struct sk_buff *skb,
 			  unsigned int dataoff,
 			  enum ip_conntrack_info ctinfo,
-			  int pf,
+			  u_int8_t pf,
 			  unsigned int hooknum)
 {
 	/* If we've seen traffic both ways, this is some kind of UDP
@@ -91,7 +91,7 @@ static bool udplite_new(struct nf_conn *ct, const struct sk_buff *skb,
 
 static int udplite_error(struct sk_buff *skb, unsigned int dataoff,
 			 enum ip_conntrack_info *ctinfo,
-			 int pf,
+			 u_int8_t pf,
 			 unsigned int hooknum)
 {
 	unsigned int udplen = skb->len - dataoff;
diff --git a/net/netfilter/nf_internals.h b/net/netfilter/nf_internals.h
index 196269c..bf66099 100644
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
+		    u_int8_t pf, unsigned int hook,
 		    struct net_device *indev,
 		    struct net_device *outdev,
 		    int (*okfn)(struct sk_buff *),
diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index bc11d70..0dca036 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -20,7 +20,7 @@ static DEFINE_MUTEX(nf_log_mutex);
 
 /* return EBUSY if somebody else is registered, EEXIST if the same logger
  * is registred, 0 on success. */
-int nf_log_register(int pf, const struct nf_logger *logger)
+int nf_log_register(u_int8_t pf, const struct nf_logger *logger)
 {
 	int ret;
 
@@ -45,7 +45,7 @@ int nf_log_register(int pf, const struct nf_logger *logger)
 }
 EXPORT_SYMBOL(nf_log_register);
 
-void nf_log_unregister_pf(int pf)
+void nf_log_unregister_pf(u_int8_t pf)
 {
 	if (pf >= NPROTO)
 		return;
@@ -73,7 +73,7 @@ void nf_log_unregister(const struct nf_logger *logger)
 }
 EXPORT_SYMBOL(nf_log_unregister);
 
-void nf_log_packet(int pf,
+void nf_log_packet(u_int8_t pf,
 		   unsigned int hooknum,
 		   const struct sk_buff *skb,
 		   const struct net_device *in,
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index bbd2689..863ac60 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -22,7 +22,7 @@ static DEFINE_MUTEX(queue_handler_mutex);
 
 /* return EBUSY when somebody else is registered, return EEXIST if the
  * same handler is registered, return 0 in case of success. */
-int nf_register_queue_handler(int pf, const struct nf_queue_handler *qh)
+int nf_register_queue_handler(u_int8_t pf, const struct nf_queue_handler *qh)
 {
 	int ret;
 
@@ -45,7 +45,7 @@ int nf_register_queue_handler(int pf, const struct nf_queue_handler *qh)
 EXPORT_SYMBOL(nf_register_queue_handler);
 
 /* The caller must flush their queue before this */
-int nf_unregister_queue_handler(int pf, const struct nf_queue_handler *qh)
+int nf_unregister_queue_handler(u_int8_t pf, const struct nf_queue_handler *qh)
 {
 	if (pf >= NPROTO)
 		return -EINVAL;
@@ -67,7 +67,7 @@ EXPORT_SYMBOL(nf_unregister_queue_handler);
 
 void nf_unregister_queue_handlers(const struct nf_queue_handler *qh)
 {
-	int pf;
+	u_int8_t pf;
 
 	mutex_lock(&queue_handler_mutex);
 	for (pf = 0; pf < NPROTO; pf++)  {
@@ -107,7 +107,7 @@ static void nf_queue_entry_release_refs(struct nf_queue_entry *entry)
  */
 static int __nf_queue(struct sk_buff *skb,
 		      struct list_head *elem,
-		      int pf, unsigned int hook,
+		      u_int8_t pf, unsigned int hook,
 		      struct net_device *indev,
 		      struct net_device *outdev,
 		      int (*okfn)(struct sk_buff *),
@@ -191,7 +191,7 @@ err:
 
 int nf_queue(struct sk_buff *skb,
 	     struct list_head *elem,
-	     int pf, unsigned int hook,
+	     u_int8_t pf, unsigned int hook,
 	     struct net_device *indev,
 	     struct net_device *outdev,
 	     int (*okfn)(struct sk_buff *),
diff --git a/net/netfilter/nf_sockopt.c b/net/netfilter/nf_sockopt.c
index 69d699f..5c1f476 100644
--- a/net/netfilter/nf_sockopt.c
+++ b/net/netfilter/nf_sockopt.c
@@ -60,7 +60,7 @@ void nf_unregister_sockopt(struct nf_sockopt_ops *reg)
 }
 EXPORT_SYMBOL(nf_unregister_sockopt);
 
-static struct nf_sockopt_ops *nf_sockopt_find(struct sock *sk, int pf,
+static struct nf_sockopt_ops *nf_sockopt_find(struct sock *sk, u_int8_t pf,
 		int val, int get)
 {
 	struct nf_sockopt_ops *ops;
@@ -96,7 +96,7 @@ out:
 }
 
 /* Call get/setsockopt() */
-static int nf_sockopt(struct sock *sk, int pf, int val,
+static int nf_sockopt(struct sock *sk, u_int8_t pf, int val,
 		      char __user *opt, int *len, int get)
 {
 	struct nf_sockopt_ops *ops;
@@ -115,21 +115,22 @@ static int nf_sockopt(struct sock *sk, int pf, int val,
 	return ret;
 }
 
-int nf_setsockopt(struct sock *sk, int pf, int val, char __user *opt,
+int nf_setsockopt(struct sock *sk, u_int8_t pf, int val, char __user *opt,
 		  int len)
 {
 	return nf_sockopt(sk, pf, val, opt, &len, 0);
 }
 EXPORT_SYMBOL(nf_setsockopt);
 
-int nf_getsockopt(struct sock *sk, int pf, int val, char __user *opt, int *len)
+int nf_getsockopt(struct sock *sk, u_int8_t pf, int val, char __user *opt,
+		  int *len)
 {
 	return nf_sockopt(sk, pf, val, opt, len, 1);
 }
 EXPORT_SYMBOL(nf_getsockopt);
 
 #ifdef CONFIG_COMPAT
-static int compat_nf_sockopt(struct sock *sk, int pf, int val,
+static int compat_nf_sockopt(struct sock *sk, u_int8_t pf, int val,
 			     char __user *opt, int *len, int get)
 {
 	struct nf_sockopt_ops *ops;
@@ -155,14 +156,14 @@ static int compat_nf_sockopt(struct sock *sk, int pf, int val,
 	return ret;
 }
 
-int compat_nf_setsockopt(struct sock *sk, int pf,
+int compat_nf_setsockopt(struct sock *sk, u_int8_t pf,
 		int val, char __user *opt, int len)
 {
 	return compat_nf_sockopt(sk, pf, val, opt, &len, 0);
 }
 EXPORT_SYMBOL(compat_nf_setsockopt);
 
-int compat_nf_getsockopt(struct sock *sk, int pf,
+int compat_nf_getsockopt(struct sock *sk, u_int8_t pf,
 		int val, char __user *opt, int *len)
 {
 	return compat_nf_sockopt(sk, pf, val, opt, len, 1);
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index b8173af..30c26cb 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -359,7 +359,7 @@ static inline int
 __build_packet_message(struct nfulnl_instance *inst,
 			const struct sk_buff *skb,
 			unsigned int data_len,
-			unsigned int pf,
+			u_int8_t pf,
 			unsigned int hooknum,
 			const struct net_device *indev,
 			const struct net_device *outdev,
@@ -526,7 +526,7 @@ static struct nf_loginfo default_loginfo = {
 
 /* log handler for internal netfilter logging api */
 static void
-nfulnl_log_packet(unsigned int pf,
+nfulnl_log_packet(u_int8_t pf,
 		  unsigned int hooknum,
 		  const struct sk_buff *skb,
 		  const struct net_device *in,
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index f52f7f8..027cbd4 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -68,7 +68,8 @@ static const char *const xt_prefix[NPROTO] = {
 int
 xt_register_target(struct xt_target *target)
 {
-	int ret, af = target->family;
+	u_int8_t af = target->family;
+	int ret;
 
 	ret = mutex_lock_interruptible(&xt[af].mutex);
 	if (ret != 0)
@@ -82,7 +83,7 @@ EXPORT_SYMBOL(xt_register_target);
 void
 xt_unregister_target(struct xt_target *target)
 {
-	int af = target->family;
+	u_int8_t af = target->family;
 
 	mutex_lock(&xt[af].mutex);
 	list_del(&target->list);
@@ -123,7 +124,8 @@ EXPORT_SYMBOL(xt_unregister_targets);
 int
 xt_register_match(struct xt_match *match)
 {
-	int ret, af = match->family;
+	u_int8_t af = match->family;
+	int ret;
 
 	ret = mutex_lock_interruptible(&xt[af].mutex);
 	if (ret != 0)
@@ -139,7 +141,7 @@ EXPORT_SYMBOL(xt_register_match);
 void
 xt_unregister_match(struct xt_match *match)
 {
-	int af =  match->family;
+	u_int8_t af = match->family;
 
 	mutex_lock(&xt[af].mutex);
 	list_del(&match->list);
@@ -185,7 +187,7 @@ EXPORT_SYMBOL(xt_unregister_matches);
  */
 
 /* Find match, grabs ref.  Returns ERR_PTR() on error. */
-struct xt_match *xt_find_match(int af, const char *name, u8 revision)
+struct xt_match *xt_find_match(u_int8_t af, const char *name, u8 revision)
 {
 	struct xt_match *m;
 	int err = 0;
@@ -210,7 +212,7 @@ struct xt_match *xt_find_match(int af, const char *name, u8 revision)
 EXPORT_SYMBOL(xt_find_match);
 
 /* Find target, grabs ref.  Returns ERR_PTR() on error. */
-struct xt_target *xt_find_target(int af, const char *name, u8 revision)
+struct xt_target *xt_find_target(u_int8_t af, const char *name, u8 revision)
 {
 	struct xt_target *t;
 	int err = 0;
@@ -234,7 +236,8 @@ struct xt_target *xt_find_target(int af, const char *name, u8 revision)
 }
 EXPORT_SYMBOL(xt_find_target);
 
-struct xt_target *xt_request_find_target(int af, const char *name, u8 revision)
+struct xt_target *xt_request_find_target(u_int8_t af, const char *name,
+					 u8 revision)
 {
 	struct xt_target *target;
 
@@ -246,7 +249,7 @@ struct xt_target *xt_request_find_target(int af, const char *name, u8 revision)
 }
 EXPORT_SYMBOL_GPL(xt_request_find_target);
 
-static int match_revfn(int af, const char *name, u8 revision, int *bestp)
+static int match_revfn(u_int8_t af, const char *name, u8 revision, int *bestp)
 {
 	const struct xt_match *m;
 	int have_rev = 0;
@@ -262,7 +265,7 @@ static int match_revfn(int af, const char *name, u8 revision, int *bestp)
 	return have_rev;
 }
 
-static int target_revfn(int af, const char *name, u8 revision, int *bestp)
+static int target_revfn(u_int8_t af, const char *name, u8 revision, int *bestp)
 {
 	const struct xt_target *t;
 	int have_rev = 0;
@@ -279,7 +282,7 @@ static int target_revfn(int af, const char *name, u8 revision, int *bestp)
 }
 
 /* Returns true or false (if no such extension at all) */
-int xt_find_revision(int af, const char *name, u8 revision, int target,
+int xt_find_revision(u_int8_t af, const char *name, u8 revision, int target,
 		     int *err)
 {
 	int have_rev, best = -1;
@@ -337,7 +340,7 @@ int xt_check_match(const struct xt_match *match, unsigned short family,
 EXPORT_SYMBOL_GPL(xt_check_match);
 
 #ifdef CONFIG_COMPAT
-int xt_compat_add_offset(int af, unsigned int offset, short delta)
+int xt_compat_add_offset(u_int8_t af, unsigned int offset, short delta)
 {
 	struct compat_delta *tmp;
 
@@ -359,7 +362,7 @@ int xt_compat_add_offset(int af, unsigned int offset, short delta)
 }
 EXPORT_SYMBOL_GPL(xt_compat_add_offset);
 
-void xt_compat_flush_offsets(int af)
+void xt_compat_flush_offsets(u_int8_t af)
 {
 	struct compat_delta *tmp, *next;
 
@@ -373,7 +376,7 @@ void xt_compat_flush_offsets(int af)
 }
 EXPORT_SYMBOL_GPL(xt_compat_flush_offsets);
 
-short xt_compat_calc_jump(int af, unsigned int offset)
+short xt_compat_calc_jump(u_int8_t af, unsigned int offset)
 {
 	struct compat_delta *tmp;
 	short delta;
@@ -590,7 +593,8 @@ void xt_free_table_info(struct xt_table_info *info)
 EXPORT_SYMBOL(xt_free_table_info);
 
 /* Find table by name, grabs mutex & ref.  Returns ERR_PTR() on error. */
-struct xt_table *xt_find_table_lock(struct net *net, int af, const char *name)
+struct xt_table *xt_find_table_lock(struct net *net, u_int8_t af,
+				    const char *name)
 {
 	struct xt_table *t;
 
@@ -612,13 +616,13 @@ void xt_table_unlock(struct xt_table *table)
 EXPORT_SYMBOL_GPL(xt_table_unlock);
 
 #ifdef CONFIG_COMPAT
-void xt_compat_lock(int af)
+void xt_compat_lock(u_int8_t af)
 {
 	mutex_lock(&xt[af].compat_mutex);
 }
 EXPORT_SYMBOL_GPL(xt_compat_lock);
 
-void xt_compat_unlock(int af)
+void xt_compat_unlock(u_int8_t af)
 {
 	mutex_unlock(&xt[af].compat_mutex);
 }
@@ -722,13 +726,13 @@ EXPORT_SYMBOL_GPL(xt_unregister_table);
 #ifdef CONFIG_PROC_FS
 struct xt_names_priv {
 	struct seq_net_private p;
-	int af;
+	u_int8_t af;
 };
 static void *xt_table_seq_start(struct seq_file *seq, loff_t *pos)
 {
 	struct xt_names_priv *priv = seq->private;
 	struct net *net = seq_file_net(seq);
-	int af = priv->af;
+	u_int8_t af = priv->af;
 
 	mutex_lock(&xt[af].mutex);
 	return seq_list_start(&net->xt.tables[af], *pos);
@@ -738,7 +742,7 @@ static void *xt_table_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
 	struct xt_names_priv *priv = seq->private;
 	struct net *net = seq_file_net(seq);
-	int af = priv->af;
+	u_int8_t af = priv->af;
 
 	return seq_list_next(v, &net->xt.tables[af], pos);
 }
@@ -746,7 +750,7 @@ static void *xt_table_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 static void xt_table_seq_stop(struct seq_file *seq, void *v)
 {
 	struct xt_names_priv *priv = seq->private;
-	int af = priv->af;
+	u_int8_t af = priv->af;
 
 	mutex_unlock(&xt[af].mutex);
 }
@@ -922,7 +926,7 @@ static const struct file_operations xt_target_ops = {
 
 #endif /* CONFIG_PROC_FS */
 
-int xt_proto_init(struct net *net, int af)
+int xt_proto_init(struct net *net, u_int8_t af)
 {
 #ifdef CONFIG_PROC_FS
 	char buf[XT_FUNCTION_MAXNAMELEN];
@@ -975,7 +979,7 @@ out:
 }
 EXPORT_SYMBOL_GPL(xt_proto_init);
 
-void xt_proto_fini(struct net *net, int af)
+void xt_proto_fini(struct net *net, u_int8_t af)
 {
 #ifdef CONFIG_PROC_FS
 	char buf[XT_FUNCTION_MAXNAMELEN];
diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
index 2e89a00..340c2cb 100644
--- a/net/netfilter/xt_connlimit.c
+++ b/net/netfilter/xt_connlimit.c
@@ -81,7 +81,7 @@ static inline bool already_closed(const struct nf_conn *conn)
 static inline unsigned int
 same_source_net(const union nf_inet_addr *addr,
 		const union nf_inet_addr *mask,
-		const union nf_inet_addr *u3, unsigned int family)
+		const union nf_inet_addr *u3, u_int8_t family)
 {
 	if (family == AF_INET) {
 		return (addr->ip & mask->ip) == (u3->ip & mask->ip);
diff --git a/net/netfilter/xt_conntrack.c b/net/netfilter/xt_conntrack.c
index d61412f..28a42a3 100644
--- a/net/netfilter/xt_conntrack.c
+++ b/net/netfilter/xt_conntrack.c
@@ -133,7 +133,7 @@ conntrack_addrcmp(const union nf_inet_addr *kaddr,
 static inline bool
 conntrack_mt_origsrc(const struct nf_conn *ct,
                      const struct xt_conntrack_mtinfo1 *info,
-                     unsigned int family)
+		     u_int8_t family)
 {
 	return conntrack_addrcmp(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u3,
 	       &info->origsrc_addr, &info->origsrc_mask, family);
@@ -142,7 +142,7 @@ conntrack_mt_origsrc(const struct nf_conn *ct,
 static inline bool
 conntrack_mt_origdst(const struct nf_conn *ct,
                      const struct xt_conntrack_mtinfo1 *info,
-                     unsigned int family)
+		     u_int8_t family)
 {
 	return conntrack_addrcmp(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.u3,
 	       &info->origdst_addr, &info->origdst_mask, family);
@@ -151,7 +151,7 @@ conntrack_mt_origdst(const struct nf_conn *ct,
 static inline bool
 conntrack_mt_replsrc(const struct nf_conn *ct,
                      const struct xt_conntrack_mtinfo1 *info,
-                     unsigned int family)
+		     u_int8_t family)
 {
 	return conntrack_addrcmp(&ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.u3,
 	       &info->replsrc_addr, &info->replsrc_mask, family);
@@ -160,7 +160,7 @@ conntrack_mt_replsrc(const struct nf_conn *ct,
 static inline bool
 conntrack_mt_repldst(const struct nf_conn *ct,
                      const struct xt_conntrack_mtinfo1 *info,
-                     unsigned int family)
+		     u_int8_t family)
 {
 	return conntrack_addrcmp(&ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u3,
 	       &info->repldst_addr, &info->repldst_mask, family);
diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index dc29007..bb8904c 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -80,7 +80,7 @@ struct dsthash_ent {
 struct xt_hashlimit_htable {
 	struct hlist_node node;		/* global list of all htables */
 	atomic_t use;
-	int family;
+	u_int8_t family;
 
 	struct hashlimit_cfg1 cfg;	/* config */
 
@@ -185,7 +185,7 @@ dsthash_free(struct xt_hashlimit_htable *ht, struct dsthash_ent *ent)
 }
 static void htable_gc(unsigned long htlong);
 
-static int htable_create_v0(struct xt_hashlimit_info *minfo, int family)
+static int htable_create_v0(struct xt_hashlimit_info *minfo, u_int8_t family)
 {
 	struct xt_hashlimit_htable *hinfo;
 	unsigned int size;
@@ -258,8 +258,7 @@ static int htable_create_v0(struct xt_hashlimit_info *minfo, int family)
 	return 0;
 }
 
-static int htable_create(struct xt_hashlimit_mtinfo1 *minfo,
-                         unsigned int family)
+static int htable_create(struct xt_hashlimit_mtinfo1 *minfo, u_int8_t family)
 {
 	struct xt_hashlimit_htable *hinfo;
 	unsigned int size;
@@ -380,7 +379,7 @@ static void htable_destroy(struct xt_hashlimit_htable *hinfo)
 }
 
 static struct xt_hashlimit_htable *htable_find_get(const char *name,
-						   int family)
+						   u_int8_t family)
 {
 	struct xt_hashlimit_htable *hinfo;
 	struct hlist_node *pos;
@@ -916,7 +915,7 @@ static void dl_seq_stop(struct seq_file *s, void *v)
 	spin_unlock_bh(&htable->lock);
 }
 
-static int dl_seq_real_show(struct dsthash_ent *ent, int family,
+static int dl_seq_real_show(struct dsthash_ent *ent, u_int8_t family,
 				   struct seq_file *s)
 {
 	/* recalculate to show accurate numbers */
