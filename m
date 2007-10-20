From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH] Unique symbol names
Date: Sat, 20 Oct 2007 13:44:00 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710201216251.1997@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kaber@trash.net
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:59397 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757618AbXJTLoF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Oct 2007 07:44:05 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


Give the target, match, check, etc. functions unique names.

---
 net/ipv4/netfilter/ipt_CLUSTERIP.c |   25 +++++-------
 net/ipv4/netfilter/ipt_ECN.c       |   22 ++++-------
 net/ipv4/netfilter/ipt_NETMAP.c    |   27 +++++--------
 net/ipv4/netfilter/ipt_REJECT.c    |   23 +++++------
 net/ipv4/netfilter/ipt_TOS.c       |   21 ++++------
 net/ipv4/netfilter/ipt_ULOG.c      |    8 ++--
 net/ipv4/netfilter/ipt_addrtype.c  |   17 ++++----
 net/ipv4/netfilter/ipt_ah.c        |   32 ++++++----------
 net/ipv4/netfilter/ipt_ecn.c       |   25 ++++++------
 net/ipv4/netfilter/ipt_iprange.c   |   18 ++++-----
 net/ipv4/netfilter/ipt_owner.c     |   29 +++++---------
 net/ipv4/netfilter/ipt_tos.c       |   28 ++++++--------
 net/netfilter/xt_CLASSIFY.c        |   13 ++----
 net/netfilter/xt_CONNMARK.c        |   40 ++++++++------------
 net/netfilter/xt_CONNSECMARK.c     |   30 +++++++--------
 net/netfilter/xt_DSCP.c            |   36 +++++++-----------
 net/netfilter/xt_MARK.c            |   54 +++++++++++----------------
 net/netfilter/xt_NFQUEUE.c         |   15 +++----
 net/netfilter/xt_NOTRACK.c         |   13 ++----
 net/netfilter/xt_SECMARK.c         |   23 ++++++-----
 net/netfilter/xt_TRACE.c           |   13 ++----
 net/netfilter/xt_comment.c         |   16 +++-----
 net/netfilter/xt_connbytes.c       |   36 +++++++-----------
 net/netfilter/xt_connmark.c        |   43 +++++++++-------------
 net/netfilter/xt_conntrack.c       |   42 +++++++++------------
 net/netfilter/xt_dccp.c            |   27 +++++--------
 net/netfilter/xt_dscp.c            |   43 +++++++++-------------
 net/netfilter/xt_esp.c             |   29 +++++---------
 net/netfilter/xt_hashlimit.c       |   12 +++---
 net/netfilter/xt_helper.c          |   36 +++++++-----------
 net/netfilter/xt_length.c          |   28 +++++---------
 net/netfilter/xt_mac.c             |   16 +++-----
 net/netfilter/xt_mark.c            |   36 +++++++-----------
 net/netfilter/xt_multiport.c       |   72 ++++++++++++++-----------------------
 net/netfilter/xt_physdev.c         |   28 +++++---------
 net/netfilter/xt_pkttype.c         |   17 +++-----
 net/netfilter/xt_policy.c          |   28 ++++++--------
 net/netfilter/xt_quota.c           |   22 +++++------
 net/netfilter/xt_realm.c           |   20 ++++------
 net/netfilter/xt_sctp.c            |   27 +++++--------
 net/netfilter/xt_state.c           |   36 +++++++-----------
 net/netfilter/xt_statistic.c       |   22 +++++------
 net/netfilter/xt_string.c          |   36 ++++++++----------
 net/netfilter/xt_tcpmss.c          |   16 +++-----
 44 files changed, 502 insertions(+), 698 deletions(-)

Index: gitone/net/ipv4/netfilter/ipt_CLUSTERIP.c
===================================================================
--- gitone.orig/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ gitone/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -289,12 +289,9 @@ clusterip_responsible(const struct clust
  ***********************************************************************/
 
 static unsigned int
-target(struct sk_buff *skb,
-       const struct net_device *in,
-       const struct net_device *out,
-       unsigned int hooknum,
-       const struct xt_target *target,
-       const void *targinfo)
+CLUSTERIP_target(struct sk_buff *skb, const struct net_device *in,
+                 const struct net_device *out, unsigned int hooknum,
+                 const struct xt_target *target, const void *targinfo)
 {
 	const struct ipt_clusterip_tgt_info *cipinfo = targinfo;
 	struct nf_conn *ct;
@@ -361,11 +358,9 @@ target(struct sk_buff *skb,
 }
 
 static bool
-checkentry(const char *tablename,
-	   const void *e_void,
-	   const struct xt_target *target,
-	   void *targinfo,
-	   unsigned int hook_mask)
+CLUSTERIP_check(const char *tablename, const void *e_void,
+                const struct xt_target *target, void *targinfo,
+                unsigned int hook_mask)
 {
 	struct ipt_clusterip_tgt_info *cipinfo = targinfo;
 	const struct ipt_entry *e = e_void;
@@ -429,7 +424,7 @@ checkentry(const char *tablename,
 }
 
 /* drop reference count of cluster config when rule is deleted */
-static void destroy(const struct xt_target *target, void *targinfo)
+static void CLUSTERIP_destroy(const struct xt_target *target, void *targinfo)
 {
 	struct ipt_clusterip_tgt_info *cipinfo = targinfo;
 
@@ -459,9 +454,9 @@ struct compat_ipt_clusterip_tgt_info
 static struct xt_target clusterip_tgt __read_mostly = {
 	.name		= "CLUSTERIP",
 	.family		= AF_INET,
-	.target		= target,
-	.checkentry	= checkentry,
-	.destroy	= destroy,
+	.target		= CLUSTERIP_target,
+	.checkentry	= CLUSTERIP_check,
+	.destroy	= CLUSTERIP_destroy,
 	.targetsize	= sizeof(struct ipt_clusterip_tgt_info),
 #ifdef CONFIG_COMPAT
 	.compatsize	= sizeof(struct compat_ipt_clusterip_tgt_info),
Index: gitone/net/ipv4/netfilter/ipt_ECN.c
===================================================================
--- gitone.orig/net/ipv4/netfilter/ipt_ECN.c
+++ gitone/net/ipv4/netfilter/ipt_ECN.c
@@ -77,12 +77,9 @@ set_ect_tcp(struct sk_buff *skb, const s
 }
 
 static unsigned int
-target(struct sk_buff *skb,
-       const struct net_device *in,
-       const struct net_device *out,
-       unsigned int hooknum,
-       const struct xt_target *target,
-       const void *targinfo)
+ECN_target(struct sk_buff *skb, const struct net_device *in,
+           const struct net_device *out, unsigned int hooknum,
+           const struct xt_target *target, const void *targinfo)
 {
 	const struct ipt_ECN_info *einfo = targinfo;
 
@@ -98,12 +95,9 @@ target(struct sk_buff *skb,
 	return XT_CONTINUE;
 }
 
-static bool
-checkentry(const char *tablename,
-	   const void *e_void,
-	   const struct xt_target *target,
-	   void *targinfo,
-	   unsigned int hook_mask)
+static bool ECN_check(const char *tablename, const void *e_void,
+                      const struct xt_target *target, void *targinfo,
+                      unsigned int hook_mask)
 {
 	const struct ipt_ECN_info *einfo = (struct ipt_ECN_info *)targinfo;
 	const struct ipt_entry *e = e_void;
@@ -130,10 +124,10 @@ checkentry(const char *tablename,
 static struct xt_target ipt_ecn_reg __read_mostly = {
 	.name		= "ECN",
 	.family		= AF_INET,
-	.target		= target,
+	.target		= ECN_target,
 	.targetsize	= sizeof(struct ipt_ECN_info),
 	.table		= "mangle",
-	.checkentry	= checkentry,
+	.checkentry	= ECN_check,
 	.me		= THIS_MODULE,
 };
 
Index: gitone/net/ipv4/netfilter/ipt_NETMAP.c
===================================================================
--- gitone.orig/net/ipv4/netfilter/ipt_NETMAP.c
+++ gitone/net/ipv4/netfilter/ipt_NETMAP.c
@@ -23,11 +23,9 @@ MODULE_AUTHOR("Svenning Soerensen <svenn
 MODULE_DESCRIPTION("iptables 1:1 NAT mapping of IP networks target");
 
 static bool
-check(const char *tablename,
-      const void *e,
-      const struct xt_target *target,
-      void *targinfo,
-      unsigned int hook_mask)
+NETMAP_check(const char *tablename, const void *e,
+             const struct xt_target *target, void *targinfo,
+             unsigned int hook_mask)
 {
 	const struct nf_nat_multi_range_compat *mr = targinfo;
 
@@ -43,12 +41,9 @@ check(const char *tablename,
 }
 
 static unsigned int
-target(struct sk_buff *skb,
-       const struct net_device *in,
-       const struct net_device *out,
-       unsigned int hooknum,
-       const struct xt_target *target,
-       const void *targinfo)
+NETMAP_target(struct sk_buff *skb, const struct net_device *in,
+              const struct net_device *out, unsigned int hooknum,
+              const struct xt_target *target, const void *targinfo)
 {
 	struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
@@ -78,26 +73,26 @@ target(struct sk_buff *skb,
 	return nf_nat_setup_info(ct, &newrange, hooknum);
 }
 
-static struct xt_target target_module __read_mostly = {
+static struct xt_target NETMAP_reg __read_mostly = {
 	.name 		= "NETMAP",
 	.family		= AF_INET,
-	.target 	= target,
+	.target 	= NETMAP_target,
 	.targetsize	= sizeof(struct nf_nat_multi_range_compat),
 	.table		= "nat",
 	.hooks		= (1 << NF_IP_PRE_ROUTING) | (1 << NF_IP_POST_ROUTING) |
 			  (1 << NF_IP_LOCAL_OUT),
-	.checkentry 	= check,
+	.checkentry 	= NETMAP_check,
 	.me 		= THIS_MODULE
 };
 
 static int __init ipt_netmap_init(void)
 {
-	return xt_register_target(&target_module);
+	return xt_register_target(&NETMAP_reg);
 }
 
 static void __exit ipt_netmap_fini(void)
 {
-	xt_unregister_target(&target_module);
+	xt_unregister_target(&NETMAP_reg);
 }
 
 module_init(ipt_netmap_init);
Index: gitone/net/ipv4/netfilter/ipt_REJECT.c
===================================================================
--- gitone.orig/net/ipv4/netfilter/ipt_REJECT.c
+++ gitone/net/ipv4/netfilter/ipt_REJECT.c
@@ -162,12 +162,10 @@ static inline void send_unreach(struct s
 	icmp_send(skb_in, ICMP_DEST_UNREACH, code, 0);
 }
 
-static unsigned int reject(struct sk_buff *skb,
-			   const struct net_device *in,
-			   const struct net_device *out,
-			   unsigned int hooknum,
-			   const struct xt_target *target,
-			   const void *targinfo)
+static unsigned int
+REJECT_target(struct sk_buff *skb, const struct net_device *in,
+              const struct net_device *out, unsigned int hooknum,
+              const struct xt_target *target, const void *targinfo)
 {
 	const struct ipt_reject_info *reject = targinfo;
 
@@ -211,11 +209,10 @@ static unsigned int reject(struct sk_buf
 	return NF_DROP;
 }
 
-static bool check(const char *tablename,
-		  const void *e_void,
-		  const struct xt_target *target,
-		  void *targinfo,
-		  unsigned int hook_mask)
+static bool
+REJECT_check(const char *tablename, const void *e_void,
+             const struct xt_target *target, void *targinfo,
+             unsigned int hook_mask)
 {
 	const struct ipt_reject_info *rejinfo = targinfo;
 	const struct ipt_entry *e = e_void;
@@ -237,12 +234,12 @@ static bool check(const char *tablename,
 static struct xt_target ipt_reject_reg __read_mostly = {
 	.name		= "REJECT",
 	.family		= AF_INET,
-	.target		= reject,
+	.target		= REJECT_target,
 	.targetsize	= sizeof(struct ipt_reject_info),
 	.table		= "filter",
 	.hooks		= (1 << NF_IP_LOCAL_IN) | (1 << NF_IP_FORWARD) |
 			  (1 << NF_IP_LOCAL_OUT),
-	.checkentry	= check,
+	.checkentry	= REJECT_check,
 	.me		= THIS_MODULE,
 };
 
Index: gitone/net/ipv4/netfilter/ipt_TOS.c
===================================================================
--- gitone.orig/net/ipv4/netfilter/ipt_TOS.c
+++ gitone/net/ipv4/netfilter/ipt_TOS.c
@@ -21,12 +21,9 @@ MODULE_AUTHOR("Netfilter Core Team <core
 MODULE_DESCRIPTION("iptables TOS mangling module");
 
 static unsigned int
-target(struct sk_buff *skb,
-       const struct net_device *in,
-       const struct net_device *out,
-       unsigned int hooknum,
-       const struct xt_target *target,
-       const void *targinfo)
+TOS_target(struct sk_buff *skb, const struct net_device *in,
+           const struct net_device *out, unsigned int hooknum,
+           const struct xt_target *target, const void *targinfo)
 {
 	const struct ipt_tos_target_info *tosinfo = targinfo;
 	struct iphdr *iph = ip_hdr(skb);
@@ -44,11 +41,9 @@ target(struct sk_buff *skb,
 }
 
 static bool
-checkentry(const char *tablename,
-	   const void *e_void,
-	   const struct xt_target *target,
-	   void *targinfo,
-	   unsigned int hook_mask)
+TOS_check(const char *tablename, const void *e_void,
+          const struct xt_target *target, void *targinfo,
+          unsigned int hook_mask)
 {
 	const u_int8_t tos = ((struct ipt_tos_target_info *)targinfo)->tos;
 
@@ -66,10 +61,10 @@ checkentry(const char *tablename,
 static struct xt_target ipt_tos_reg __read_mostly = {
 	.name		= "TOS",
 	.family		= AF_INET,
-	.target		= target,
+	.target		= TOS_target,
 	.targetsize	= sizeof(struct ipt_tos_target_info),
 	.table		= "mangle",
-	.checkentry	= checkentry,
+	.checkentry	= TOS_check,
 	.me		= THIS_MODULE,
 };
 
Index: gitone/net/ipv4/netfilter/ipt_ULOG.c
===================================================================
--- gitone.orig/net/ipv4/netfilter/ipt_ULOG.c
+++ gitone/net/ipv4/netfilter/ipt_ULOG.c
@@ -347,7 +347,7 @@ struct compat_ipt_ulog_info {
 	char		prefix[ULOG_PREFIX_LEN];
 };
 
-static void compat_from_user(void *dst, void *src)
+static void ULOG_compat_from_user(void *dst, void *src)
 {
 	const struct compat_ipt_ulog_info *cl = src;
 	struct ipt_ulog_info l = {
@@ -360,7 +360,7 @@ static void compat_from_user(void *dst, 
 	memcpy(dst, &l, sizeof(l));
 }
 
-static int compat_to_user(void __user *dst, void *src)
+static int ULOG_compat_to_user(void __user *dst, void *src)
 {
 	const struct ipt_ulog_info *l = src;
 	struct compat_ipt_ulog_info cl = {
@@ -382,8 +382,8 @@ static struct xt_target ipt_ulog_reg __r
 	.checkentry	= ipt_ulog_checkentry,
 #ifdef CONFIG_COMPAT
 	.compatsize	= sizeof(struct compat_ipt_ulog_info),
-	.compat_from_user = compat_from_user,
-	.compat_to_user	= compat_to_user,
+	.compat_from_user = ULOG_compat_from_user,
+	.compat_to_user	= ULOG_compat_to_user,
 #endif
 	.me		= THIS_MODULE,
 };
Index: gitone/net/ipv4/netfilter/ipt_addrtype.c
===================================================================
--- gitone.orig/net/ipv4/netfilter/ipt_addrtype.c
+++ gitone/net/ipv4/netfilter/ipt_addrtype.c
@@ -27,10 +27,11 @@ static inline bool match_type(__be32 add
 	return !!(mask & (1 << inet_addr_type(addr)));
 }
 
-static bool match(const struct sk_buff *skb,
-		  const struct net_device *in, const struct net_device *out,
-		  const struct xt_match *match, const void *matchinfo,
-		  int offset, unsigned int protoff, bool *hotdrop)
+static bool
+addrtype_match(const struct sk_buff *skb, const struct net_device *in,
+               const struct net_device *out, const struct xt_match *match,
+               const void *matchinfo, int offset, unsigned int protoff,
+               bool *hotdrop)
 {
 	const struct ipt_addrtype_info *info = matchinfo;
 	const struct iphdr *iph = ip_hdr(skb);
@@ -44,22 +45,22 @@ static bool match(const struct sk_buff *
 	return ret;
 }
 
-static struct xt_match addrtype_match __read_mostly = {
+static struct xt_match addrtype_reg __read_mostly = {
 	.name		= "addrtype",
 	.family		= AF_INET,
-	.match		= match,
+	.match		= addrtype_match,
 	.matchsize	= sizeof(struct ipt_addrtype_info),
 	.me		= THIS_MODULE
 };
 
 static int __init ipt_addrtype_init(void)
 {
-	return xt_register_match(&addrtype_match);
+	return xt_register_match(&addrtype_reg);
 }
 
 static void __exit ipt_addrtype_fini(void)
 {
-	xt_unregister_match(&addrtype_match);
+	xt_unregister_match(&addrtype_reg);
 }
 
 module_init(ipt_addrtype_init);
Index: gitone/net/ipv4/netfilter/ipt_ah.c
===================================================================
--- gitone.orig/net/ipv4/netfilter/ipt_ah.c
+++ gitone/net/ipv4/netfilter/ipt_ah.c
@@ -36,15 +36,10 @@ spi_match(u_int32_t min, u_int32_t max, 
 	return r;
 }
 
-static bool
-match(const struct sk_buff *skb,
-      const struct net_device *in,
-      const struct net_device *out,
-      const struct xt_match *match,
-      const void *matchinfo,
-      int offset,
-      unsigned int protoff,
-      bool *hotdrop)
+static bool ah_match(const struct sk_buff *skb, const struct net_device *in,
+                     const struct net_device *out, const struct xt_match *match,
+                     const void *matchinfo, int offset, unsigned int protoff,
+                     bool *hotdrop)
 {
 	struct ip_auth_hdr _ahdr;
 	const struct ip_auth_hdr *ah;
@@ -71,12 +66,9 @@ match(const struct sk_buff *skb,
 }
 
 /* Called when user tries to insert an entry of this type. */
-static bool
-checkentry(const char *tablename,
-	   const void *ip_void,
-	   const struct xt_match *match,
-	   void *matchinfo,
-	   unsigned int hook_mask)
+static bool ah_check(const char *tablename, const void *ip_void,
+                     const struct xt_match *match, void *matchinfo,
+                     unsigned int hook_mask)
 {
 	const struct ipt_ah *ahinfo = matchinfo;
 
@@ -88,24 +80,24 @@ checkentry(const char *tablename,
 	return true;
 }
 
-static struct xt_match ah_match __read_mostly = {
+static struct xt_match ah_reg __read_mostly = {
 	.name		= "ah",
 	.family		= AF_INET,
-	.match		= match,
+	.match		= ah_match,
 	.matchsize	= sizeof(struct ipt_ah),
 	.proto		= IPPROTO_AH,
-	.checkentry	= checkentry,
+	.checkentry	= ah_check,
 	.me		= THIS_MODULE,
 };
 
 static int __init ipt_ah_init(void)
 {
-	return xt_register_match(&ah_match);
+	return xt_register_match(&ah_reg);
 }
 
 static void __exit ipt_ah_fini(void)
 {
-	xt_unregister_match(&ah_match);
+	xt_unregister_match(&ah_reg);
 }
 
 module_init(ipt_ah_init);
Index: gitone/net/ipv4/netfilter/ipt_ecn.c
===================================================================
--- gitone.orig/net/ipv4/netfilter/ipt_ecn.c
+++ gitone/net/ipv4/netfilter/ipt_ecn.c
@@ -67,10 +67,11 @@ static inline bool match_tcp(const struc
 	return true;
 }
 
-static bool match(const struct sk_buff *skb,
-		  const struct net_device *in, const struct net_device *out,
-		  const struct xt_match *match, const void *matchinfo,
-		  int offset, unsigned int protoff, bool *hotdrop)
+static bool
+ecn_match(const struct sk_buff *skb, const struct net_device *in,
+          const struct net_device *out, const struct xt_match *match,
+          const void *matchinfo, int offset, unsigned int protoff,
+          bool *hotdrop)
 {
 	const struct ipt_ecn_info *info = matchinfo;
 
@@ -88,9 +89,9 @@ static bool match(const struct sk_buff *
 	return true;
 }
 
-static bool checkentry(const char *tablename, const void *ip_void,
-		       const struct xt_match *match,
-		       void *matchinfo, unsigned int hook_mask)
+static bool ecn_check(const char *tablename, const void *ip_void,
+                      const struct xt_match *match, void *matchinfo,
+                      unsigned int hook_mask)
 {
 	const struct ipt_ecn_info *info = matchinfo;
 	const struct ipt_ip *ip = ip_void;
@@ -111,23 +112,23 @@ static bool checkentry(const char *table
 	return true;
 }
 
-static struct xt_match ecn_match __read_mostly = {
+static struct xt_match ecn_reg __read_mostly = {
 	.name		= "ecn",
 	.family		= AF_INET,
-	.match		= match,
+	.match		= ecn_match,
 	.matchsize	= sizeof(struct ipt_ecn_info),
-	.checkentry	= checkentry,
+	.checkentry	= ecn_check,
 	.me		= THIS_MODULE,
 };
 
 static int __init ipt_ecn_init(void)
 {
-	return xt_register_match(&ecn_match);
+	return xt_register_match(&ecn_reg);
 }
 
 static void __exit ipt_ecn_fini(void)
 {
-	xt_unregister_match(&ecn_match);
+	xt_unregister_match(&ecn_reg);
 }
 
 module_init(ipt_ecn_init);
Index: gitone/net/ipv4/netfilter/ipt_iprange.c
===================================================================
--- gitone.orig/net/ipv4/netfilter/ipt_iprange.c
+++ gitone/net/ipv4/netfilter/ipt_iprange.c
@@ -18,12 +18,10 @@ MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@
 MODULE_DESCRIPTION("iptables arbitrary IP range match module");
 
 static bool
-match(const struct sk_buff *skb,
-      const struct net_device *in,
-      const struct net_device *out,
-      const struct xt_match *match,
-      const void *matchinfo,
-      int offset, unsigned int protoff, bool *hotdrop)
+iprange_match(const struct sk_buff *skb, const struct net_device *in,
+              const struct net_device *out, const struct xt_match *match,
+              const void *matchinfo, int offset, unsigned int protoff,
+              bool *hotdrop)
 {
 	const struct ipt_iprange_info *info = matchinfo;
 	const struct iphdr *iph = ip_hdr(skb);
@@ -57,22 +55,22 @@ match(const struct sk_buff *skb,
 	return true;
 }
 
-static struct xt_match iprange_match __read_mostly = {
+static struct xt_match iprange_reg __read_mostly = {
 	.name		= "iprange",
 	.family		= AF_INET,
-	.match		= match,
+	.match		= iprange_match,
 	.matchsize	= sizeof(struct ipt_iprange_info),
 	.me		= THIS_MODULE
 };
 
 static int __init ipt_iprange_init(void)
 {
-	return xt_register_match(&iprange_match);
+	return xt_register_match(&iprange_reg);
 }
 
 static void __exit ipt_iprange_fini(void)
 {
-	xt_unregister_match(&iprange_match);
+	xt_unregister_match(&iprange_reg);
 }
 
 module_init(ipt_iprange_init);
Index: gitone/net/ipv4/netfilter/ipt_owner.c
===================================================================
--- gitone.orig/net/ipv4/netfilter/ipt_owner.c
+++ gitone/net/ipv4/netfilter/ipt_owner.c
@@ -22,14 +22,10 @@ MODULE_AUTHOR("Marc Boucher <marc@mbsi.c
 MODULE_DESCRIPTION("iptables owner match");
 
 static bool
-match(const struct sk_buff *skb,
-      const struct net_device *in,
-      const struct net_device *out,
-      const struct xt_match *match,
-      const void *matchinfo,
-      int offset,
-      unsigned int protoff,
-      bool *hotdrop)
+owner_match(const struct sk_buff *skb, const struct net_device *in,
+            const struct net_device *out, const struct xt_match *match,
+            const void *matchinfo, int offset, unsigned int protoff,
+            bool *hotdrop)
 {
 	const struct ipt_owner_info *info = matchinfo;
 
@@ -52,11 +48,8 @@ match(const struct sk_buff *skb,
 }
 
 static bool
-checkentry(const char *tablename,
-	   const void *ip,
-	   const struct xt_match *match,
-	   void *matchinfo,
-	   unsigned int hook_mask)
+owner_check(const char *tablename, const void *ip, const struct xt_match *match,
+            void *matchinfo, unsigned int hook_mask)
 {
 	const struct ipt_owner_info *info = matchinfo;
 
@@ -68,24 +61,24 @@ checkentry(const char *tablename,
 	return true;
 }
 
-static struct xt_match owner_match __read_mostly = {
+static struct xt_match owner_reg __read_mostly = {
 	.name		= "owner",
 	.family		= AF_INET,
-	.match		= match,
+	.match		= owner_match,
 	.matchsize	= sizeof(struct ipt_owner_info),
 	.hooks		= (1 << NF_IP_LOCAL_OUT) | (1 << NF_IP_POST_ROUTING),
-	.checkentry	= checkentry,
+	.checkentry	= owner_check,
 	.me		= THIS_MODULE,
 };
 
 static int __init ipt_owner_init(void)
 {
-	return xt_register_match(&owner_match);
+	return xt_register_match(&owner_reg);
 }
 
 static void __exit ipt_owner_fini(void)
 {
-	xt_unregister_match(&owner_match);
+	xt_unregister_match(&owner_reg);
 }
 
 module_init(ipt_owner_init);
Index: gitone/net/ipv4/netfilter/ipt_tos.c
===================================================================
--- gitone.orig/net/ipv4/netfilter/ipt_tos.c
+++ gitone/net/ipv4/netfilter/ipt_tos.c
@@ -19,37 +19,33 @@ MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("iptables TOS match module");
 
 static bool
-match(const struct sk_buff *skb,
-      const struct net_device *in,
-      const struct net_device *out,
-      const struct xt_match *match,
-      const void *matchinfo,
-      int offset,
-      unsigned int protoff,
-      bool *hotdrop)
+ipt_tos_match(const struct sk_buff *skb, const struct net_device *in,
+              const struct net_device *out, const struct xt_match *match,
+              const void *matchinfo, int offset, unsigned int protoff,
+              bool *hotdrop)
 {
 	const struct ipt_tos_info *info = matchinfo;
 
 	return (ip_hdr(skb)->tos == info->tos) ^ info->invert;
 }
 
-static struct xt_match tos_match __read_mostly = {
+static struct xt_match ipt_tos_reg __read_mostly = {
 	.name		= "tos",
 	.family		= AF_INET,
-	.match		= match,
+	.match		= ipt_tos_match,
 	.matchsize	= sizeof(struct ipt_tos_info),
 	.me		= THIS_MODULE,
 };
 
-static int __init ipt_multiport_init(void)
+static int __init ipt_tos_init(void)
 {
-	return xt_register_match(&tos_match);
+	return xt_register_match(&ipt_tos_reg);
 }
 
-static void __exit ipt_multiport_fini(void)
+static void __exit ipt_tos_fini(void)
 {
-	xt_unregister_match(&tos_match);
+	xt_unregister_match(&ipt_tos_reg);
 }
 
-module_init(ipt_multiport_init);
-module_exit(ipt_multiport_fini);
+module_init(ipt_tos_init);
+module_exit(ipt_tos_fini);
Index: gitone/net/netfilter/xt_CLASSIFY.c
===================================================================
--- gitone.orig/net/netfilter/xt_CLASSIFY.c
+++ gitone/net/netfilter/xt_CLASSIFY.c
@@ -27,12 +27,9 @@ MODULE_ALIAS("ipt_CLASSIFY");
 MODULE_ALIAS("ip6t_CLASSIFY");
 
 static unsigned int
-target(struct sk_buff *skb,
-       const struct net_device *in,
-       const struct net_device *out,
-       unsigned int hooknum,
-       const struct xt_target *target,
-       const void *targinfo)
+CLASSIFY_target(struct sk_buff *skb, const struct net_device *in,
+                const struct net_device *out, unsigned int hooknum,
+                const struct xt_target *target, const void *targinfo)
 {
 	const struct xt_classify_target_info *clinfo = targinfo;
 
@@ -44,7 +41,7 @@ static struct xt_target xt_classify_targ
 	{
 		.family		= AF_INET,
 		.name 		= "CLASSIFY",
-		.target 	= target,
+		.target 	= CLASSIFY_target,
 		.targetsize	= sizeof(struct xt_classify_target_info),
 		.table		= "mangle",
 		.hooks		= (1 << NF_IP_LOCAL_OUT) |
@@ -55,7 +52,7 @@ static struct xt_target xt_classify_targ
 	{
 		.name 		= "CLASSIFY",
 		.family		= AF_INET6,
-		.target 	= target,
+		.target 	= CLASSIFY_target,
 		.targetsize	= sizeof(struct xt_classify_target_info),
 		.table		= "mangle",
 		.hooks		= (1 << NF_IP6_LOCAL_OUT) |
Index: gitone/net/netfilter/xt_CONNMARK.c
===================================================================
--- gitone.orig/net/netfilter/xt_CONNMARK.c
+++ gitone/net/netfilter/xt_CONNMARK.c
@@ -34,12 +34,9 @@ MODULE_ALIAS("ip6t_CONNMARK");
 #include <net/netfilter/nf_conntrack_ecache.h>
 
 static unsigned int
-target(struct sk_buff *skb,
-       const struct net_device *in,
-       const struct net_device *out,
-       unsigned int hooknum,
-       const struct xt_target *target,
-       const void *targinfo)
+CONNMARK_target(struct sk_buff *skb, const struct net_device *in,
+                const struct net_device *out, unsigned int hooknum,
+                const struct xt_target *target, const void *targinfo)
 {
 	const struct xt_connmark_target_info *markinfo = targinfo;
 	struct nf_conn *ct;
@@ -78,11 +75,9 @@ target(struct sk_buff *skb,
 }
 
 static bool
-checkentry(const char *tablename,
-	   const void *entry,
-	   const struct xt_target *target,
-	   void *targinfo,
-	   unsigned int hook_mask)
+CONNMARK_check(const char *tablename, const void *entry,
+               const struct xt_target *target, void *targinfo,
+               unsigned int hook_mask)
 {
 	const struct xt_connmark_target_info *matchinfo = targinfo;
 
@@ -106,8 +101,7 @@ checkentry(const char *tablename,
 	return true;
 }
 
-static void
-destroy(const struct xt_target *target, void *targinfo)
+static void CONNMARK_destroy(const struct xt_target *target, void *targinfo)
 {
 	nf_ct_l3proto_module_put(target->family);
 }
@@ -120,7 +114,7 @@ struct compat_xt_connmark_target_info {
 	u_int16_t	__pad2;
 };
 
-static void compat_from_user(void *dst, void *src)
+static void CONNMARK_compat_from_user(void *dst, void *src)
 {
 	const struct compat_xt_connmark_target_info *cm = src;
 	struct xt_connmark_target_info m = {
@@ -131,7 +125,7 @@ static void compat_from_user(void *dst, 
 	memcpy(dst, &m, sizeof(m));
 }
 
-static int compat_to_user(void __user *dst, void *src)
+static int CONNMARK_compat_to_user(void __user *dst, void *src)
 {
 	const struct xt_connmark_target_info *m = src;
 	struct compat_xt_connmark_target_info cm = {
@@ -147,23 +141,23 @@ static struct xt_target xt_connmark_targ
 	{
 		.name		= "CONNMARK",
 		.family		= AF_INET,
-		.checkentry	= checkentry,
-		.destroy	= destroy,
-		.target		= target,
+		.checkentry	= CONNMARK_check,
+		.destroy	= CONNMARK_destroy,
+		.target		= CONNMARK_target,
 		.targetsize	= sizeof(struct xt_connmark_target_info),
 #ifdef CONFIG_COMPAT
 		.compatsize	= sizeof(struct compat_xt_connmark_target_info),
-		.compat_from_user = compat_from_user,
-		.compat_to_user	= compat_to_user,
+		.compat_from_user = CONNMARK_compat_from_user,
+		.compat_to_user	= CONNMARK_compat_to_user,
 #endif
 		.me		= THIS_MODULE
 	},
 	{
 		.name		= "CONNMARK",
 		.family		= AF_INET6,
-		.checkentry	= checkentry,
-		.destroy	= destroy,
-		.target		= target,
+		.checkentry	= CONNMARK_check,
+		.destroy	= CONNMARK_destroy,
+		.target		= CONNMARK_target,
 		.targetsize	= sizeof(struct xt_connmark_target_info),
 		.me		= THIS_MODULE
 	},
Index: gitone/net/netfilter/xt_CONNSECMARK.c
===================================================================
--- gitone.orig/net/netfilter/xt_CONNSECMARK.c
+++ gitone/net/netfilter/xt_CONNSECMARK.c
@@ -61,10 +61,10 @@ static void secmark_restore(struct sk_bu
 	}
 }
 
-static unsigned int target(struct sk_buff *skb, const struct net_device *in,
-			   const struct net_device *out, unsigned int hooknum,
-			   const struct xt_target *target,
-			   const void *targinfo)
+static unsigned int
+CONNSECMARK_target(struct sk_buff *skb, const struct net_device *in,
+                   const struct net_device *out, unsigned int hooknum,
+                   const struct xt_target *target, const void *targinfo)
 {
 	const struct xt_connsecmark_target_info *info = targinfo;
 
@@ -84,9 +84,10 @@ static unsigned int target(struct sk_buf
 	return XT_CONTINUE;
 }
 
-static bool checkentry(const char *tablename, const void *entry,
-		       const struct xt_target *target, void *targinfo,
-		       unsigned int hook_mask)
+static bool
+CONNSECMARK_check(const char *tablename, const void *entry,
+                  const struct xt_target *target, void *targinfo,
+                  unsigned int hook_mask)
 {
 	const struct xt_connsecmark_target_info *info = targinfo;
 
@@ -108,8 +109,7 @@ static bool checkentry(const char *table
 	return true;
 }
 
-static void
-destroy(const struct xt_target *target, void *targinfo)
+static void CONNSECMARK_destroy(const struct xt_target *target, void *targinfo)
 {
 	nf_ct_l3proto_module_put(target->family);
 }
@@ -118,9 +118,9 @@ static struct xt_target xt_connsecmark_t
 	{
 		.name		= "CONNSECMARK",
 		.family		= AF_INET,
-		.checkentry	= checkentry,
-		.destroy	= destroy,
-		.target		= target,
+		.checkentry	= CONNSECMARK_check,
+		.destroy	= CONNSECMARK_destroy,
+		.target		= CONNSECMARK_target,
 		.targetsize	= sizeof(struct xt_connsecmark_target_info),
 		.table		= "mangle",
 		.me		= THIS_MODULE,
@@ -128,9 +128,9 @@ static struct xt_target xt_connsecmark_t
 	{
 		.name		= "CONNSECMARK",
 		.family		= AF_INET6,
-		.checkentry	= checkentry,
-		.destroy	= destroy,
-		.target		= target,
+		.checkentry	= CONNSECMARK_check,
+		.destroy	= CONNSECMARK_destroy,
+		.target		= CONNSECMARK_target,
 		.targetsize	= sizeof(struct xt_connsecmark_target_info),
 		.table		= "mangle",
 		.me		= THIS_MODULE,
Index: gitone/net/netfilter/xt_DSCP.c
===================================================================
--- gitone.orig/net/netfilter/xt_DSCP.c
+++ gitone/net/netfilter/xt_DSCP.c
@@ -25,12 +25,10 @@ MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_DSCP");
 MODULE_ALIAS("ip6t_DSCP");
 
-static unsigned int target(struct sk_buff *skb,
-			   const struct net_device *in,
-			   const struct net_device *out,
-			   unsigned int hooknum,
-			   const struct xt_target *target,
-			   const void *targinfo)
+static unsigned int
+DSCP_target(struct sk_buff *skb, const struct net_device *in,
+            const struct net_device *out, unsigned int hooknum,
+            const struct xt_target *target, const void *targinfo)
 {
 	const struct xt_DSCP_info *dinfo = targinfo;
 	u_int8_t dscp = ipv4_get_dsfield(ip_hdr(skb)) >> XT_DSCP_SHIFT;
@@ -46,12 +44,10 @@ static unsigned int target(struct sk_buf
 	return XT_CONTINUE;
 }
 
-static unsigned int target6(struct sk_buff *skb,
-			    const struct net_device *in,
-			    const struct net_device *out,
-			    unsigned int hooknum,
-			    const struct xt_target *target,
-			    const void *targinfo)
+static unsigned int
+DSCP_target6(struct sk_buff *skb, const struct net_device *in,
+             const struct net_device *out, unsigned int hooknum,
+             const struct xt_target *target, const void *targinfo)
 {
 	const struct xt_DSCP_info *dinfo = targinfo;
 	u_int8_t dscp = ipv6_get_dsfield(ipv6_hdr(skb)) >> XT_DSCP_SHIFT;
@@ -66,11 +62,9 @@ static unsigned int target6(struct sk_bu
 	return XT_CONTINUE;
 }
 
-static bool checkentry(const char *tablename,
-		       const void *e_void,
-		       const struct xt_target *target,
-		       void *targinfo,
-		       unsigned int hook_mask)
+static bool DSCP_check(const char *tablename, const void *e_void,
+                       const struct xt_target *target, void *targinfo,
+                       unsigned int hook_mask)
 {
 	const u_int8_t dscp = ((struct xt_DSCP_info *)targinfo)->dscp;
 
@@ -85,8 +79,8 @@ static struct xt_target xt_dscp_target[]
 	{
 		.name		= "DSCP",
 		.family		= AF_INET,
-		.checkentry	= checkentry,
-		.target		= target,
+		.checkentry	= DSCP_check,
+		.target		= DSCP_target,
 		.targetsize	= sizeof(struct xt_DSCP_info),
 		.table		= "mangle",
 		.me		= THIS_MODULE,
@@ -94,8 +88,8 @@ static struct xt_target xt_dscp_target[]
 	{
 		.name		= "DSCP",
 		.family		= AF_INET6,
-		.checkentry	= checkentry,
-		.target		= target6,
+		.checkentry	= DSCP_check,
+		.target		= DSCP_target6,
 		.targetsize	= sizeof(struct xt_DSCP_info),
 		.table		= "mangle",
 		.me		= THIS_MODULE,
Index: gitone/net/netfilter/xt_MARK.c
===================================================================
--- gitone.orig/net/netfilter/xt_MARK.c
+++ gitone/net/netfilter/xt_MARK.c
@@ -22,12 +22,9 @@ MODULE_ALIAS("ipt_MARK");
 MODULE_ALIAS("ip6t_MARK");
 
 static unsigned int
-target_v0(struct sk_buff *skb,
-	  const struct net_device *in,
-	  const struct net_device *out,
-	  unsigned int hooknum,
-	  const struct xt_target *target,
-	  const void *targinfo)
+MARK_target_v0(struct sk_buff *skb, const struct net_device *in,
+               const struct net_device *out, unsigned int hooknum,
+               const struct xt_target *target, const void *targinfo)
 {
 	const struct xt_mark_target_info *markinfo = targinfo;
 
@@ -36,12 +33,9 @@ target_v0(struct sk_buff *skb,
 }
 
 static unsigned int
-target_v1(struct sk_buff *skb,
-	  const struct net_device *in,
-	  const struct net_device *out,
-	  unsigned int hooknum,
-	  const struct xt_target *target,
-	  const void *targinfo)
+MARK_target_v1(struct sk_buff *skb, const struct net_device *in,
+               const struct net_device *out, unsigned int hooknum,
+               const struct xt_target *target, const void *targinfo)
 {
 	const struct xt_mark_target_info_v1 *markinfo = targinfo;
 	int mark = 0;
@@ -66,11 +60,9 @@ target_v1(struct sk_buff *skb,
 
 
 static bool
-checkentry_v0(const char *tablename,
-	      const void *entry,
-	      const struct xt_target *target,
-	      void *targinfo,
-	      unsigned int hook_mask)
+MARK_check_v0(const char *tablename, const void *entry,
+              const struct xt_target *target, void *targinfo,
+              unsigned int hook_mask)
 {
 	const struct xt_mark_target_info *markinfo = targinfo;
 
@@ -82,11 +74,9 @@ checkentry_v0(const char *tablename,
 }
 
 static bool
-checkentry_v1(const char *tablename,
-	      const void *entry,
-	      const struct xt_target *target,
-	      void *targinfo,
-	      unsigned int hook_mask)
+MARK_check_v1(const char *tablename, const void *entry,
+              const struct xt_target *target, void *targinfo,
+              unsigned int hook_mask)
 {
 	const struct xt_mark_target_info_v1 *markinfo = targinfo;
 
@@ -112,7 +102,7 @@ struct compat_xt_mark_target_info_v1 {
 	u_int16_t	__pad2;
 };
 
-static void compat_from_user_v1(void *dst, void *src)
+static void MARK_compat_from_user_v1(void *dst, void *src)
 {
 	const struct compat_xt_mark_target_info_v1 *cm = src;
 	struct xt_mark_target_info_v1 m = {
@@ -122,7 +112,7 @@ static void compat_from_user_v1(void *ds
 	memcpy(dst, &m, sizeof(m));
 }
 
-static int compat_to_user_v1(void __user *dst, void *src)
+static int MARK_compat_to_user_v1(void __user *dst, void *src)
 {
 	const struct xt_mark_target_info_v1 *m = src;
 	struct compat_xt_mark_target_info_v1 cm = {
@@ -138,8 +128,8 @@ static struct xt_target xt_mark_target[]
 		.name		= "MARK",
 		.family		= AF_INET,
 		.revision	= 0,
-		.checkentry	= checkentry_v0,
-		.target		= target_v0,
+		.checkentry	= MARK_check_v0,
+		.target		= MARK_target_v0,
 		.targetsize	= sizeof(struct xt_mark_target_info),
 		.table		= "mangle",
 		.me		= THIS_MODULE,
@@ -148,13 +138,13 @@ static struct xt_target xt_mark_target[]
 		.name		= "MARK",
 		.family		= AF_INET,
 		.revision	= 1,
-		.checkentry	= checkentry_v1,
-		.target		= target_v1,
+		.checkentry	= MARK_check_v1,
+		.target		= MARK_target_v1,
 		.targetsize	= sizeof(struct xt_mark_target_info_v1),
 #ifdef CONFIG_COMPAT
 		.compatsize	= sizeof(struct compat_xt_mark_target_info_v1),
-		.compat_from_user = compat_from_user_v1,
-		.compat_to_user	= compat_to_user_v1,
+		.compat_from_user = MARK_compat_from_user_v1,
+		.compat_to_user	= MARK_compat_to_user_v1,
 #endif
 		.table		= "mangle",
 		.me		= THIS_MODULE,
@@ -163,8 +153,8 @@ static struct xt_target xt_mark_target[]
 		.name		= "MARK",
 		.family		= AF_INET6,
 		.revision	= 0,
-		.checkentry	= checkentry_v0,
-		.target		= target_v0,
+		.checkentry	= MARK_check_v0,
+		.target		= MARK_target_v0,
 		.targetsize	= sizeof(struct xt_mark_target_info),
 		.table		= "mangle",
 		.me		= THIS_MODULE,
Index: gitone/net/netfilter/xt_NFQUEUE.c
===================================================================
--- gitone.orig/net/netfilter/xt_NFQUEUE.c
+++ gitone/net/netfilter/xt_NFQUEUE.c
@@ -24,12 +24,9 @@ MODULE_ALIAS("ip6t_NFQUEUE");
 MODULE_ALIAS("arpt_NFQUEUE");
 
 static unsigned int
-target(struct sk_buff *skb,
-       const struct net_device *in,
-       const struct net_device *out,
-       unsigned int hooknum,
-       const struct xt_target *target,
-       const void *targinfo)
+NFQUEUE_target(struct sk_buff *skb, const struct net_device *in,
+               const struct net_device *out, unsigned int hooknum,
+               const struct xt_target *target, const void *targinfo)
 {
 	const struct xt_NFQ_info *tinfo = targinfo;
 
@@ -40,21 +37,21 @@ static struct xt_target xt_nfqueue_targe
 	{
 		.name		= "NFQUEUE",
 		.family		= AF_INET,
-		.target		= target,
+		.target		= NFQUEUE_target,
 		.targetsize	= sizeof(struct xt_NFQ_info),
 		.me		= THIS_MODULE,
 	},
 	{
 		.name		= "NFQUEUE",
 		.family		= AF_INET6,
-		.target		= target,
+		.target		= NFQUEUE_target,
 		.targetsize	= sizeof(struct xt_NFQ_info),
 		.me		= THIS_MODULE,
 	},
 	{
 		.name		= "NFQUEUE",
 		.family		= NF_ARP,
-		.target		= target,
+		.target		= NFQUEUE_target,
 		.targetsize	= sizeof(struct xt_NFQ_info),
 		.me		= THIS_MODULE,
 	},
Index: gitone/net/netfilter/xt_NOTRACK.c
===================================================================
--- gitone.orig/net/netfilter/xt_NOTRACK.c
+++ gitone/net/netfilter/xt_NOTRACK.c
@@ -12,12 +12,9 @@ MODULE_ALIAS("ipt_NOTRACK");
 MODULE_ALIAS("ip6t_NOTRACK");
 
 static unsigned int
-target(struct sk_buff *skb,
-       const struct net_device *in,
-       const struct net_device *out,
-       unsigned int hooknum,
-       const struct xt_target *target,
-       const void *targinfo)
+NOTRACK_target(struct sk_buff *skb, const struct net_device *in,
+               const struct net_device *out, unsigned int hooknum,
+               const struct xt_target *target, const void *targinfo)
 {
 	/* Previously seen (loopback)? Ignore. */
 	if (skb->nfct != NULL)
@@ -38,14 +35,14 @@ static struct xt_target xt_notrack_targe
 	{
 		.name		= "NOTRACK",
 		.family		= AF_INET,
-		.target		= target,
+		.target		= NOTRACK_target,
 		.table		= "raw",
 		.me		= THIS_MODULE,
 	},
 	{
 		.name		= "NOTRACK",
 		.family		= AF_INET6,
-		.target		= target,
+		.target		= NOTRACK_target,
 		.table		= "raw",
 		.me		= THIS_MODULE,
 	},
Index: gitone/net/netfilter/xt_SECMARK.c
===================================================================
--- gitone.orig/net/netfilter/xt_SECMARK.c
+++ gitone/net/netfilter/xt_SECMARK.c
@@ -28,10 +28,10 @@ MODULE_ALIAS("ip6t_SECMARK");
 
 static u8 mode;
 
-static unsigned int target(struct sk_buff *skb, const struct net_device *in,
-			   const struct net_device *out, unsigned int hooknum,
-			   const struct xt_target *target,
-			   const void *targinfo)
+static unsigned int
+SECMARK_target(struct sk_buff *skb, const struct net_device *in,
+               const struct net_device *out, unsigned int hooknum,
+               const struct xt_target *target, const void *targinfo)
 {
 	u32 secmark = 0;
 	const struct xt_secmark_target_info *info = targinfo;
@@ -81,9 +81,10 @@ static bool checkentry_selinux(struct xt
 	return true;
 }
 
-static bool checkentry(const char *tablename, const void *entry,
-		       const struct xt_target *target, void *targinfo,
-		       unsigned int hook_mask)
+static bool
+SECMARK_check(const char *tablename, const void *entry,
+              const struct xt_target *target, void *targinfo,
+	      unsigned int hook_mask)
 {
 	struct xt_secmark_target_info *info = targinfo;
 
@@ -113,8 +114,8 @@ static struct xt_target xt_secmark_targe
 	{
 		.name		= "SECMARK",
 		.family		= AF_INET,
-		.checkentry	= checkentry,
-		.target		= target,
+		.checkentry	= SECMARK_check,
+		.target		= SECMARK_target,
 		.targetsize	= sizeof(struct xt_secmark_target_info),
 		.table		= "mangle",
 		.me		= THIS_MODULE,
@@ -122,8 +123,8 @@ static struct xt_target xt_secmark_targe
 	{
 		.name		= "SECMARK",
 		.family		= AF_INET6,
-		.checkentry	= checkentry,
-		.target		= target,
+		.checkentry	= SECMARK_check,
+		.target		= SECMARK_target,
 		.targetsize	= sizeof(struct xt_secmark_target_info),
 		.table		= "mangle",
 		.me		= THIS_MODULE,
Index: gitone/net/netfilter/xt_TRACE.c
===================================================================
--- gitone.orig/net/netfilter/xt_TRACE.c
+++ gitone/net/netfilter/xt_TRACE.c
@@ -10,12 +10,9 @@ MODULE_ALIAS("ipt_TRACE");
 MODULE_ALIAS("ip6t_TRACE");
 
 static unsigned int
-target(struct sk_buff *skb,
-       const struct net_device *in,
-       const struct net_device *out,
-       unsigned int hooknum,
-       const struct xt_target *target,
-       const void *targinfo)
+TRACE_target(struct sk_buff *skb, const struct net_device *in,
+             const struct net_device *out, unsigned int hooknum,
+             const struct xt_target *target, const void *targinfo)
 {
 	skb->nf_trace = 1;
 	return XT_CONTINUE;
@@ -25,14 +22,14 @@ static struct xt_target xt_trace_target[
 	{
 		.name		= "TRACE",
 		.family		= AF_INET,
-		.target		= target,
+		.target		= TRACE_target,
 		.table		= "raw",
 		.me		= THIS_MODULE,
 	},
 	{
 		.name		= "TRACE",
 		.family		= AF_INET6,
-		.target		= target,
+		.target		= TRACE_target,
 		.table		= "raw",
 		.me		= THIS_MODULE,
 	},
Index: gitone/net/netfilter/xt_comment.c
===================================================================
--- gitone.orig/net/netfilter/xt_comment.c
+++ gitone/net/netfilter/xt_comment.c
@@ -16,14 +16,10 @@ MODULE_ALIAS("ipt_comment");
 MODULE_ALIAS("ip6t_comment");
 
 static bool
-match(const struct sk_buff *skb,
-      const struct net_device *in,
-      const struct net_device *out,
-      const struct xt_match *match,
-      const void *matchinfo,
-      int offset,
-      unsigned int protooff,
-      bool *hotdrop)
+comment_match(const struct sk_buff *skb, const struct net_device *in,
+              const struct net_device *out, const struct xt_match *match,
+              const void *matchinfo, int offset, unsigned int protooff,
+              bool *hotdrop)
 {
 	/* We always match */
 	return true;
@@ -33,14 +29,14 @@ static struct xt_match xt_comment_match[
 	{
 		.name		= "comment",
 		.family		= AF_INET,
-		.match		= match,
+		.match		= comment_match,
 		.matchsize	= sizeof(struct xt_comment_info),
 		.me		= THIS_MODULE
 	},
 	{
 		.name		= "comment",
 		.family		= AF_INET6,
-		.match		= match,
+		.match		= comment_match,
 		.matchsize	= sizeof(struct xt_comment_info),
 		.me		= THIS_MODULE
 	},
Index: gitone/net/netfilter/xt_connbytes.c
===================================================================
--- gitone.orig/net/netfilter/xt_connbytes.c
+++ gitone/net/netfilter/xt_connbytes.c
@@ -17,14 +17,10 @@ MODULE_ALIAS("ipt_connbytes");
 MODULE_ALIAS("ip6t_connbytes");
 
 static bool
-match(const struct sk_buff *skb,
-      const struct net_device *in,
-      const struct net_device *out,
-      const struct xt_match *match,
-      const void *matchinfo,
-      int offset,
-      unsigned int protoff,
-      bool *hotdrop)
+connbytes_match(const struct sk_buff *skb, const struct net_device *in,
+                const struct net_device *out, const struct xt_match *match,
+                const void *matchinfo, int offset, unsigned int protoff,
+                bool *hotdrop)
 {
 	const struct xt_connbytes_info *sinfo = matchinfo;
 	const struct nf_conn *ct;
@@ -96,11 +92,10 @@ match(const struct sk_buff *skb,
 		return what >= sinfo->count.from;
 }
 
-static bool check(const char *tablename,
-		  const void *ip,
-		  const struct xt_match *match,
-		  void *matchinfo,
-		  unsigned int hook_mask)
+static bool
+connbytes_check(const char *tablename, const void *ip,
+                const struct xt_match *match, void *matchinfo,
+                unsigned int hook_mask)
 {
 	const struct xt_connbytes_info *sinfo = matchinfo;
 
@@ -123,8 +118,7 @@ static bool check(const char *tablename,
 	return true;
 }
 
-static void
-destroy(const struct xt_match *match, void *matchinfo)
+static void connbytes_destroy(const struct xt_match *match, void *matchinfo)
 {
 	nf_ct_l3proto_module_put(match->family);
 }
@@ -133,18 +127,18 @@ static struct xt_match xt_connbytes_matc
 	{
 		.name		= "connbytes",
 		.family		= AF_INET,
-		.checkentry	= check,
-		.match		= match,
-		.destroy	= destroy,
+		.checkentry	= connbytes_check,
+		.match		= connbytes_match,
+		.destroy	= connbytes_destroy,
 		.matchsize	= sizeof(struct xt_connbytes_info),
 		.me		= THIS_MODULE
 	},
 	{
 		.name		= "connbytes",
 		.family		= AF_INET6,
-		.checkentry	= check,
-		.match		= match,
-		.destroy	= destroy,
+		.checkentry	= connbytes_check,
+		.match		= connbytes_match,
+		.destroy	= connbytes_destroy,
 		.matchsize	= sizeof(struct xt_connbytes_info),
 		.me		= THIS_MODULE
 	},
Index: gitone/net/netfilter/xt_connmark.c
===================================================================
--- gitone.orig/net/netfilter/xt_connmark.c
+++ gitone/net/netfilter/xt_connmark.c
@@ -32,14 +32,10 @@ MODULE_ALIAS("ipt_connmark");
 MODULE_ALIAS("ip6t_connmark");
 
 static bool
-match(const struct sk_buff *skb,
-      const struct net_device *in,
-      const struct net_device *out,
-      const struct xt_match *match,
-      const void *matchinfo,
-      int offset,
-      unsigned int protoff,
-      bool *hotdrop)
+connmark_match(const struct sk_buff *skb, const struct net_device *in,
+               const struct net_device *out, const struct xt_match *match,
+               const void *matchinfo, int offset, unsigned int protoff,
+               bool *hotdrop)
 {
 	const struct xt_connmark_info *info = matchinfo;
 	const struct nf_conn *ct;
@@ -53,11 +49,9 @@ match(const struct sk_buff *skb,
 }
 
 static bool
-checkentry(const char *tablename,
-	   const void *ip,
-	   const struct xt_match *match,
-	   void *matchinfo,
-	   unsigned int hook_mask)
+connmark_check(const char *tablename, const void *ip,
+               const struct xt_match *match, void *matchinfo,
+               unsigned int hook_mask)
 {
 	const struct xt_connmark_info *cm = matchinfo;
 
@@ -73,8 +67,7 @@ checkentry(const char *tablename,
 	return true;
 }
 
-static void
-destroy(const struct xt_match *match, void *matchinfo)
+static void connmark_destroy(const struct xt_match *match, void *matchinfo)
 {
 	nf_ct_l3proto_module_put(match->family);
 }
@@ -87,7 +80,7 @@ struct compat_xt_connmark_info {
 	u_int16_t	__pad2;
 };
 
-static void compat_from_user(void *dst, void *src)
+static void connmark_compat_from_user(void *dst, void *src)
 {
 	const struct compat_xt_connmark_info *cm = src;
 	struct xt_connmark_info m = {
@@ -98,7 +91,7 @@ static void compat_from_user(void *dst, 
 	memcpy(dst, &m, sizeof(m));
 }
 
-static int compat_to_user(void __user *dst, void *src)
+static int connmark_compat_to_user(void __user *dst, void *src)
 {
 	const struct xt_connmark_info *m = src;
 	struct compat_xt_connmark_info cm = {
@@ -114,23 +107,23 @@ static struct xt_match xt_connmark_match
 	{
 		.name		= "connmark",
 		.family		= AF_INET,
-		.checkentry	= checkentry,
-		.match		= match,
-		.destroy	= destroy,
+		.checkentry	= connmark_check,
+		.match		= connmark_match,
+		.destroy	= connmark_destroy,
 		.matchsize	= sizeof(struct xt_connmark_info),
 #ifdef CONFIG_COMPAT
 		.compatsize	= sizeof(struct compat_xt_connmark_info),
-		.compat_from_user = compat_from_user,
-		.compat_to_user	= compat_to_user,
+		.compat_from_user = connmark_compat_from_user,
+		.compat_to_user	= connmark_compat_to_user,
 #endif
 		.me		= THIS_MODULE
 	},
 	{
 		.name		= "connmark",
 		.family		= AF_INET6,
-		.checkentry	= checkentry,
-		.match		= match,
-		.destroy	= destroy,
+		.checkentry	= connmark_check,
+		.match		= connmark_match,
+		.destroy	= connmark_destroy,
 		.matchsize	= sizeof(struct xt_connmark_info),
 		.me		= THIS_MODULE
 	},
Index: gitone/net/netfilter/xt_conntrack.c
===================================================================
--- gitone.orig/net/netfilter/xt_conntrack.c
+++ gitone/net/netfilter/xt_conntrack.c
@@ -20,14 +20,10 @@ MODULE_DESCRIPTION("iptables connection 
 MODULE_ALIAS("ipt_conntrack");
 
 static bool
-match(const struct sk_buff *skb,
-      const struct net_device *in,
-      const struct net_device *out,
-      const struct xt_match *match,
-      const void *matchinfo,
-      int offset,
-      unsigned int protoff,
-      bool *hotdrop)
+conntrack_match(const struct sk_buff *skb, const struct net_device *in,
+                const struct net_device *out, const struct xt_match *match,
+                const void *matchinfo, int offset, unsigned int protoff,
+                bool *hotdrop)
 {
 	const struct xt_conntrack_info *sinfo = matchinfo;
 	const struct nf_conn *ct;
@@ -115,11 +111,9 @@ match(const struct sk_buff *skb,
 }
 
 static bool
-checkentry(const char *tablename,
-	   const void *ip,
-	   const struct xt_match *match,
-	   void *matchinfo,
-	   unsigned int hook_mask)
+conntrack_check(const char *tablename, const void *ip,
+                const struct xt_match *match, void *matchinfo,
+                unsigned int hook_mask)
 {
 	if (nf_ct_l3proto_try_module_get(match->family) < 0) {
 		printk(KERN_WARNING "can't load conntrack support for "
@@ -129,7 +123,7 @@ checkentry(const char *tablename,
 	return true;
 }
 
-static void destroy(const struct xt_match *match, void *matchinfo)
+static void conntrack_destroy(const struct xt_match *match, void *matchinfo)
 {
 	nf_ct_l3proto_module_put(match->family);
 }
@@ -148,7 +142,7 @@ struct compat_xt_conntrack_info
 	u_int8_t			invflags;
 };
 
-static void compat_from_user(void *dst, void *src)
+static void conntrack_compat_from_user(void *dst, void *src)
 {
 	const struct compat_xt_conntrack_info *cm = src;
 	struct xt_conntrack_info m = {
@@ -165,7 +159,7 @@ static void compat_from_user(void *dst, 
 	memcpy(dst, &m, sizeof(m));
 }
 
-static int compat_to_user(void __user *dst, void *src)
+static int conntrack_compat_to_user(void __user *dst, void *src)
 {
 	const struct xt_conntrack_info *m = src;
 	struct compat_xt_conntrack_info cm = {
@@ -183,16 +177,16 @@ static int compat_to_user(void __user *d
 }
 #endif
 
-static struct xt_match conntrack_match __read_mostly = {
+static struct xt_match conntrack_reg __read_mostly = {
 	.name		= "conntrack",
-	.match		= match,
-	.checkentry	= checkentry,
-	.destroy	= destroy,
+	.match		= conntrack_match,
+	.checkentry	= conntrack_check,
+	.destroy	= conntrack_destroy,
 	.matchsize	= sizeof(struct xt_conntrack_info),
 #ifdef CONFIG_COMPAT
 	.compatsize	= sizeof(struct compat_xt_conntrack_info),
-	.compat_from_user = compat_from_user,
-	.compat_to_user	= compat_to_user,
+	.compat_from_user = conntrack_compat_from_user,
+	.compat_to_user	= conntrack_compat_to_user,
 #endif
 	.family		= AF_INET,
 	.me		= THIS_MODULE,
@@ -200,12 +194,12 @@ static struct xt_match conntrack_match _
 
 static int __init xt_conntrack_init(void)
 {
-	return xt_register_match(&conntrack_match);
+	return xt_register_match(&conntrack_reg);
 }
 
 static void __exit xt_conntrack_fini(void)
 {
-	xt_unregister_match(&conntrack_match);
+	xt_unregister_match(&conntrack_reg);
 }
 
 module_init(xt_conntrack_init);
Index: gitone/net/netfilter/xt_dccp.c
===================================================================
--- gitone.orig/net/netfilter/xt_dccp.c
+++ gitone/net/netfilter/xt_dccp.c
@@ -93,14 +93,10 @@ match_option(u_int8_t option, const stru
 }
 
 static bool
-match(const struct sk_buff *skb,
-      const struct net_device *in,
-      const struct net_device *out,
-      const struct xt_match *match,
-      const void *matchinfo,
-      int offset,
-      unsigned int protoff,
-      bool *hotdrop)
+dccp_match(const struct sk_buff *skb, const struct net_device *in,
+           const struct net_device *out, const struct xt_match *match,
+           const void *matchinfo, int offset, unsigned int protoff,
+           bool *hotdrop)
 {
 	const struct xt_dccp_info *info = matchinfo;
 	struct dccp_hdr _dh, *dh;
@@ -128,11 +124,8 @@ match(const struct sk_buff *skb,
 }
 
 static bool
-checkentry(const char *tablename,
-	   const void *inf,
-	   const struct xt_match *match,
-	   void *matchinfo,
-	   unsigned int hook_mask)
+dccp_check(const char *tablename, const void *inf, const struct xt_match *match,
+	   void *matchinfo, unsigned int hook_mask)
 {
 	const struct xt_dccp_info *info = matchinfo;
 
@@ -145,8 +138,8 @@ static struct xt_match xt_dccp_match[] _
 	{
 		.name 		= "dccp",
 		.family		= AF_INET,
-		.checkentry	= checkentry,
-		.match		= match,
+		.checkentry	= dccp_check,
+		.match		= dccp_match,
 		.matchsize	= sizeof(struct xt_dccp_info),
 		.proto		= IPPROTO_DCCP,
 		.me 		= THIS_MODULE,
@@ -154,8 +147,8 @@ static struct xt_match xt_dccp_match[] _
 	{
 		.name 		= "dccp",
 		.family		= AF_INET6,
-		.checkentry	= checkentry,
-		.match		= match,
+		.checkentry	= dccp_check,
+		.match		= dccp_match,
 		.matchsize	= sizeof(struct xt_dccp_info),
 		.proto		= IPPROTO_DCCP,
 		.me 		= THIS_MODULE,
Index: gitone/net/netfilter/xt_dscp.c
===================================================================
--- gitone.orig/net/netfilter/xt_dscp.c
+++ gitone/net/netfilter/xt_dscp.c
@@ -22,14 +22,11 @@ MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_dscp");
 MODULE_ALIAS("ip6t_dscp");
 
-static bool match(const struct sk_buff *skb,
-		  const struct net_device *in,
-		  const struct net_device *out,
-		  const struct xt_match *match,
-		  const void *matchinfo,
-		  int offset,
-		  unsigned int protoff,
-		  bool *hotdrop)
+static bool
+dscp_match(const struct sk_buff *skb, const struct net_device *in,
+           const struct net_device *out, const struct xt_match *match,
+           const void *matchinfo, int offset, unsigned int protoff,
+           bool *hotdrop)
 {
 	const struct xt_dscp_info *info = matchinfo;
 	u_int8_t dscp = ipv4_get_dsfield(ip_hdr(skb)) >> XT_DSCP_SHIFT;
@@ -37,14 +34,11 @@ static bool match(const struct sk_buff *
 	return (dscp == info->dscp) ^ !!info->invert;
 }
 
-static bool match6(const struct sk_buff *skb,
-		   const struct net_device *in,
-		   const struct net_device *out,
-		   const struct xt_match *match,
-		   const void *matchinfo,
-		   int offset,
-		   unsigned int protoff,
-		   bool *hotdrop)
+static bool
+dscp_match6(const struct sk_buff *skb, const struct net_device *in,
+            const struct net_device *out, const struct xt_match *match,
+            const void *matchinfo, int offset, unsigned int protoff,
+           bool *hotdrop)
 {
 	const struct xt_dscp_info *info = matchinfo;
 	u_int8_t dscp = ipv6_get_dsfield(ipv6_hdr(skb)) >> XT_DSCP_SHIFT;
@@ -52,11 +46,10 @@ static bool match6(const struct sk_buff 
 	return (dscp == info->dscp) ^ !!info->invert;
 }
 
-static bool checkentry(const char *tablename,
-		       const void *info,
-		       const struct xt_match *match,
-		       void *matchinfo,
-		       unsigned int hook_mask)
+static bool
+dscp_check(const char *tablename, const void *info,
+           const struct xt_match *match, void *matchinfo,
+           unsigned int hook_mask)
 {
 	const u_int8_t dscp = ((struct xt_dscp_info *)matchinfo)->dscp;
 
@@ -72,16 +65,16 @@ static struct xt_match xt_dscp_match[] _
 	{
 		.name		= "dscp",
 		.family		= AF_INET,
-		.checkentry	= checkentry,
-		.match		= match,
+		.checkentry	= dscp_check,
+		.match		= dscp_match,
 		.matchsize	= sizeof(struct xt_dscp_info),
 		.me		= THIS_MODULE,
 	},
 	{
 		.name		= "dscp",
 		.family		= AF_INET6,
-		.checkentry	= checkentry,
-		.match		= match6,
+		.checkentry	= dscp_check,
+		.match		= dscp_match6,
 		.matchsize	= sizeof(struct xt_dscp_info),
 		.me		= THIS_MODULE,
 	},
Index: gitone/net/netfilter/xt_esp.c
===================================================================
--- gitone.orig/net/netfilter/xt_esp.c
+++ gitone/net/netfilter/xt_esp.c
@@ -43,14 +43,10 @@ spi_match(u_int32_t min, u_int32_t max, 
 }
 
 static bool
-match(const struct sk_buff *skb,
-      const struct net_device *in,
-      const struct net_device *out,
-      const struct xt_match *match,
-      const void *matchinfo,
-      int offset,
-      unsigned int protoff,
-      bool *hotdrop)
+esp_match(const struct sk_buff *skb, const struct net_device *in,
+          const struct net_device *out, const struct xt_match *match,
+          const void *matchinfo, int offset, unsigned int protoff,
+          bool *hotdrop)
 {
 	struct ip_esp_hdr _esp, *eh;
 	const struct xt_esp *espinfo = matchinfo;
@@ -74,12 +70,9 @@ match(const struct sk_buff *skb,
 }
 
 /* Called when user tries to insert an entry of this type. */
-static bool
-checkentry(const char *tablename,
-	   const void *ip_void,
-	   const struct xt_match *match,
-	   void *matchinfo,
-	   unsigned int hook_mask)
+static bool esp_check(const char *tablename, const void *ip_void,
+                      const struct xt_match *match, void *matchinfo,
+                      unsigned int hook_mask)
 {
 	const struct xt_esp *espinfo = matchinfo;
 
@@ -95,8 +88,8 @@ static struct xt_match xt_esp_match[] __
 	{
 		.name		= "esp",
 		.family		= AF_INET,
-		.checkentry	= checkentry,
-		.match		= match,
+		.checkentry	= esp_check,
+		.match		= esp_match,
 		.matchsize	= sizeof(struct xt_esp),
 		.proto		= IPPROTO_ESP,
 		.me		= THIS_MODULE,
@@ -104,8 +97,8 @@ static struct xt_match xt_esp_match[] __
 	{
 		.name		= "esp",
 		.family		= AF_INET6,
-		.checkentry	= checkentry,
-		.match		= match,
+		.checkentry	= esp_check,
+		.match		= esp_match,
 		.matchsize	= sizeof(struct xt_esp),
 		.proto		= IPPROTO_ESP,
 		.me		= THIS_MODULE,
Index: gitone/net/netfilter/xt_hashlimit.c
===================================================================
--- gitone.orig/net/netfilter/xt_hashlimit.c
+++ gitone/net/netfilter/xt_hashlimit.c
@@ -563,7 +563,7 @@ struct compat_xt_hashlimit_info {
 	compat_uptr_t master;
 };
 
-static void compat_from_user(void *dst, void *src)
+static void hashlimit_compat_from_user(void *dst, void *src)
 {
 	int off = offsetof(struct compat_xt_hashlimit_info, hinfo);
 
@@ -571,7 +571,7 @@ static void compat_from_user(void *dst, 
 	memset(dst + off, 0, sizeof(struct compat_xt_hashlimit_info) - off);
 }
 
-static int compat_to_user(void __user *dst, void *src)
+static int hashlimit_compat_to_user(void __user *dst, void *src)
 {
 	int off = offsetof(struct compat_xt_hashlimit_info, hinfo);
 
@@ -587,8 +587,8 @@ static struct xt_match xt_hashlimit[] __
 		.matchsize	= sizeof(struct xt_hashlimit_info),
 #ifdef CONFIG_COMPAT
 		.compatsize	= sizeof(struct compat_xt_hashlimit_info),
-		.compat_from_user = compat_from_user,
-		.compat_to_user	= compat_to_user,
+		.compat_from_user = hashlimit_compat_from_user,
+		.compat_to_user	= hashlimit_compat_to_user,
 #endif
 		.checkentry	= hashlimit_checkentry,
 		.destroy	= hashlimit_destroy,
@@ -601,8 +601,8 @@ static struct xt_match xt_hashlimit[] __
 		.matchsize	= sizeof(struct xt_hashlimit_info),
 #ifdef CONFIG_COMPAT
 		.compatsize	= sizeof(struct compat_xt_hashlimit_info),
-		.compat_from_user = compat_from_user,
-		.compat_to_user	= compat_to_user,
+		.compat_from_user = hashlimit_compat_from_user,
+		.compat_to_user	= hashlimit_compat_to_user,
 #endif
 		.checkentry	= hashlimit_checkentry,
 		.destroy	= hashlimit_destroy,
Index: gitone/net/netfilter/xt_helper.c
===================================================================
--- gitone.orig/net/netfilter/xt_helper.c
+++ gitone/net/netfilter/xt_helper.c
@@ -24,14 +24,10 @@ MODULE_ALIAS("ip6t_helper");
 
 
 static bool
-match(const struct sk_buff *skb,
-      const struct net_device *in,
-      const struct net_device *out,
-      const struct xt_match *match,
-      const void *matchinfo,
-      int offset,
-      unsigned int protoff,
-      bool *hotdrop)
+helper_match(const struct sk_buff *skb, const struct net_device *in,
+             const struct net_device *out, const struct xt_match *match,
+             const void *matchinfo, int offset, unsigned int protoff,
+             bool *hotdrop)
 {
 	const struct xt_helper_info *info = matchinfo;
 	const struct nf_conn *ct;
@@ -61,11 +57,10 @@ match(const struct sk_buff *skb,
 	return ret;
 }
 
-static bool check(const char *tablename,
-		  const void *inf,
-		  const struct xt_match *match,
-		  void *matchinfo,
-		  unsigned int hook_mask)
+static bool
+helper_check(const char *tablename, const void *inf,
+             const struct xt_match *match, void *matchinfo,
+             unsigned int hook_mask)
 {
 	struct xt_helper_info *info = matchinfo;
 
@@ -78,8 +73,7 @@ static bool check(const char *tablename,
 	return true;
 }
 
-static void
-destroy(const struct xt_match *match, void *matchinfo)
+static void helper_destroy(const struct xt_match *match, void *matchinfo)
 {
 	nf_ct_l3proto_module_put(match->family);
 }
@@ -88,18 +82,18 @@ static struct xt_match xt_helper_match[]
 	{
 		.name		= "helper",
 		.family		= AF_INET,
-		.checkentry	= check,
-		.match		= match,
-		.destroy	= destroy,
+		.checkentry	= helper_check,
+		.match		= helper_match,
+		.destroy	= helper_destroy,
 		.matchsize	= sizeof(struct xt_helper_info),
 		.me		= THIS_MODULE,
 	},
 	{
 		.name		= "helper",
 		.family		= AF_INET6,
-		.checkentry	= check,
-		.match		= match,
-		.destroy	= destroy,
+		.checkentry	= helper_check,
+		.match		= helper_match,
+		.destroy	= helper_destroy,
 		.matchsize	= sizeof(struct xt_helper_info),
 		.me		= THIS_MODULE,
 	},
Index: gitone/net/netfilter/xt_length.c
===================================================================
--- gitone.orig/net/netfilter/xt_length.c
+++ gitone/net/netfilter/xt_length.c
@@ -21,14 +21,10 @@ MODULE_ALIAS("ipt_length");
 MODULE_ALIAS("ip6t_length");
 
 static bool
-match(const struct sk_buff *skb,
-      const struct net_device *in,
-      const struct net_device *out,
-      const struct xt_match *match,
-      const void *matchinfo,
-      int offset,
-      unsigned int protoff,
-      bool *hotdrop)
+length_match(const struct sk_buff *skb, const struct net_device *in,
+             const struct net_device *out, const struct xt_match *match,
+             const void *matchinfo, int offset, unsigned int protoff,
+             bool *hotdrop)
 {
 	const struct xt_length_info *info = matchinfo;
 	u_int16_t pktlen = ntohs(ip_hdr(skb)->tot_len);
@@ -37,14 +33,10 @@ match(const struct sk_buff *skb,
 }
 
 static bool
-match6(const struct sk_buff *skb,
-       const struct net_device *in,
-       const struct net_device *out,
-       const struct xt_match *match,
-       const void *matchinfo,
-       int offset,
-       unsigned int protoff,
-       bool *hotdrop)
+length_match6(const struct sk_buff *skb, const struct net_device *in,
+              const struct net_device *out, const struct xt_match *match,
+              const void *matchinfo, int offset, unsigned int protoff,
+              bool *hotdrop)
 {
 	const struct xt_length_info *info = matchinfo;
 	const u_int16_t pktlen = ntohs(ipv6_hdr(skb)->payload_len) +
@@ -57,14 +49,14 @@ static struct xt_match xt_length_match[]
 	{
 		.name		= "length",
 		.family		= AF_INET,
-		.match		= match,
+		.match		= length_match,
 		.matchsize	= sizeof(struct xt_length_info),
 		.me		= THIS_MODULE,
 	},
 	{
 		.name		= "length",
 		.family		= AF_INET6,
-		.match		= match6,
+		.match		= length_match6,
 		.matchsize	= sizeof(struct xt_length_info),
 		.me		= THIS_MODULE,
 	},
Index: gitone/net/netfilter/xt_mac.c
===================================================================
--- gitone.orig/net/netfilter/xt_mac.c
+++ gitone/net/netfilter/xt_mac.c
@@ -25,14 +25,10 @@ MODULE_ALIAS("ipt_mac");
 MODULE_ALIAS("ip6t_mac");
 
 static bool
-match(const struct sk_buff *skb,
-      const struct net_device *in,
-      const struct net_device *out,
-      const struct xt_match *match,
-      const void *matchinfo,
-      int offset,
-      unsigned int protoff,
-      bool *hotdrop)
+mac_match(const struct sk_buff *skb, const struct net_device *in,
+          const struct net_device *out, const struct xt_match *match,
+          const void *matchinfo, int offset, unsigned int protoff,
+          bool *hotdrop)
 {
     const struct xt_mac_info *info = matchinfo;
 
@@ -48,7 +44,7 @@ static struct xt_match xt_mac_match[] __
 	{
 		.name		= "mac",
 		.family		= AF_INET,
-		.match		= match,
+		.match		= mac_match,
 		.matchsize	= sizeof(struct xt_mac_info),
 		.hooks		= (1 << NF_IP_PRE_ROUTING) |
 				  (1 << NF_IP_LOCAL_IN) |
@@ -58,7 +54,7 @@ static struct xt_match xt_mac_match[] __
 	{
 		.name		= "mac",
 		.family		= AF_INET6,
-		.match		= match,
+		.match		= mac_match,
 		.matchsize	= sizeof(struct xt_mac_info),
 		.hooks		= (1 << NF_IP6_PRE_ROUTING) |
 				  (1 << NF_IP6_LOCAL_IN) |
Index: gitone/net/netfilter/xt_mark.c
===================================================================
--- gitone.orig/net/netfilter/xt_mark.c
+++ gitone/net/netfilter/xt_mark.c
@@ -20,14 +20,10 @@ MODULE_ALIAS("ipt_mark");
 MODULE_ALIAS("ip6t_mark");
 
 static bool
-match(const struct sk_buff *skb,
-      const struct net_device *in,
-      const struct net_device *out,
-      const struct xt_match *match,
-      const void *matchinfo,
-      int offset,
-      unsigned int protoff,
-      bool *hotdrop)
+mark_match(const struct sk_buff *skb, const struct net_device *in,
+           const struct net_device *out, const struct xt_match *match,
+           const void *matchinfo, int offset, unsigned int protoff,
+           bool *hotdrop)
 {
 	const struct xt_mark_info *info = matchinfo;
 
@@ -35,11 +31,9 @@ match(const struct sk_buff *skb,
 }
 
 static bool
-checkentry(const char *tablename,
-	   const void *entry,
-	   const struct xt_match *match,
-	   void *matchinfo,
-	   unsigned int hook_mask)
+mark_check(const char *tablename, const void *entry,
+           const struct xt_match *match, void *matchinfo,
+           unsigned int hook_mask)
 {
 	const struct xt_mark_info *minfo = matchinfo;
 
@@ -58,7 +52,7 @@ struct compat_xt_mark_info {
 	u_int16_t	__pad2;
 };
 
-static void compat_from_user(void *dst, void *src)
+static void mark_compat_from_user(void *dst, void *src)
 {
 	const struct compat_xt_mark_info *cm = src;
 	struct xt_mark_info m = {
@@ -69,7 +63,7 @@ static void compat_from_user(void *dst, 
 	memcpy(dst, &m, sizeof(m));
 }
 
-static int compat_to_user(void __user *dst, void *src)
+static int mark_compat_to_user(void __user *dst, void *src)
 {
 	const struct xt_mark_info *m = src;
 	struct compat_xt_mark_info cm = {
@@ -85,21 +79,21 @@ static struct xt_match xt_mark_match[] _
 	{
 		.name		= "mark",
 		.family		= AF_INET,
-		.checkentry	= checkentry,
-		.match		= match,
+		.checkentry	= mark_check,
+		.match		= mark_match,
 		.matchsize	= sizeof(struct xt_mark_info),
 #ifdef CONFIG_COMPAT
 		.compatsize	= sizeof(struct compat_xt_mark_info),
-		.compat_from_user = compat_from_user,
-		.compat_to_user	= compat_to_user,
+		.compat_from_user = mark_compat_from_user,
+		.compat_to_user	= mark_compat_to_user,
 #endif
 		.me		= THIS_MODULE,
 	},
 	{
 		.name		= "mark",
 		.family		= AF_INET6,
-		.checkentry	= checkentry,
-		.match		= match,
+		.checkentry	= mark_check,
+		.match		= mark_match,
 		.matchsize	= sizeof(struct xt_mark_info),
 		.me		= THIS_MODULE,
 	},
Index: gitone/net/netfilter/xt_multiport.c
===================================================================
--- gitone.orig/net/netfilter/xt_multiport.c
+++ gitone/net/netfilter/xt_multiport.c
@@ -95,14 +95,10 @@ ports_match_v1(const struct xt_multiport
 }
 
 static bool
-match(const struct sk_buff *skb,
-      const struct net_device *in,
-      const struct net_device *out,
-      const struct xt_match *match,
-      const void *matchinfo,
-      int offset,
-      unsigned int protoff,
-      bool *hotdrop)
+multiport_match(const struct sk_buff *skb, const struct net_device *in,
+                const struct net_device *out, const struct xt_match *match,
+                const void *matchinfo, int offset, unsigned int protoff,
+                bool *hotdrop)
 {
 	__be16 _ports[2], *pptr;
 	const struct xt_multiport *multiinfo = matchinfo;
@@ -126,14 +122,10 @@ match(const struct sk_buff *skb,
 }
 
 static bool
-match_v1(const struct sk_buff *skb,
-	 const struct net_device *in,
-	 const struct net_device *out,
-	 const struct xt_match *match,
-	 const void *matchinfo,
-	 int offset,
-	 unsigned int protoff,
-	 bool *hotdrop)
+multiport_match_v1(const struct sk_buff *skb, const struct net_device *in,
+                   const struct net_device *out, const struct xt_match *match,
+                   const void *matchinfo, int offset, unsigned int protoff,
+                   bool *hotdrop)
 {
 	__be16 _ports[2], *pptr;
 	const struct xt_multiport_v1 *multiinfo = matchinfo;
@@ -173,11 +165,9 @@ check(u_int16_t proto,
 
 /* Called when user tries to insert an entry of this type. */
 static bool
-checkentry(const char *tablename,
-	   const void *info,
-	   const struct xt_match *match,
-	   void *matchinfo,
-	   unsigned int hook_mask)
+multiport_check(const char *tablename, const void *info,
+                const struct xt_match *match, void *matchinfo,
+                unsigned int hook_mask)
 {
 	const struct ipt_ip *ip = info;
 	const struct xt_multiport *multiinfo = matchinfo;
@@ -187,11 +177,9 @@ checkentry(const char *tablename,
 }
 
 static bool
-checkentry_v1(const char *tablename,
-	      const void *info,
-	      const struct xt_match *match,
-	      void *matchinfo,
-	      unsigned int hook_mask)
+multiport_check_v1(const char *tablename, const void *info,
+                   const struct xt_match *match, void *matchinfo,
+                   unsigned int hook_mask)
 {
 	const struct ipt_ip *ip = info;
 	const struct xt_multiport_v1 *multiinfo = matchinfo;
@@ -201,11 +189,9 @@ checkentry_v1(const char *tablename,
 }
 
 static bool
-checkentry6(const char *tablename,
-	    const void *info,
-	    const struct xt_match *match,
-	    void *matchinfo,
-	    unsigned int hook_mask)
+multiport_check6(const char *tablename, const void *info,
+                 const struct xt_match *match, void *matchinfo,
+                 unsigned int hook_mask)
 {
 	const struct ip6t_ip6 *ip = info;
 	const struct xt_multiport *multiinfo = matchinfo;
@@ -215,11 +201,9 @@ checkentry6(const char *tablename,
 }
 
 static bool
-checkentry6_v1(const char *tablename,
-	       const void *info,
-	       const struct xt_match *match,
-	       void *matchinfo,
-	       unsigned int hook_mask)
+multiport_check6_v1(const char *tablename, const void *info,
+                    const struct xt_match *match, void *matchinfo,
+                    unsigned int hook_mask)
 {
 	const struct ip6t_ip6 *ip = info;
 	const struct xt_multiport_v1 *multiinfo = matchinfo;
@@ -233,8 +217,8 @@ static struct xt_match xt_multiport_matc
 		.name		= "multiport",
 		.family		= AF_INET,
 		.revision	= 0,
-		.checkentry	= checkentry,
-		.match		= match,
+		.checkentry	= multiport_check,
+		.match		= multiport_match,
 		.matchsize	= sizeof(struct xt_multiport),
 		.me		= THIS_MODULE,
 	},
@@ -242,8 +226,8 @@ static struct xt_match xt_multiport_matc
 		.name		= "multiport",
 		.family		= AF_INET,
 		.revision	= 1,
-		.checkentry	= checkentry_v1,
-		.match		= match_v1,
+		.checkentry	= multiport_check_v1,
+		.match		= multiport_match_v1,
 		.matchsize	= sizeof(struct xt_multiport_v1),
 		.me		= THIS_MODULE,
 	},
@@ -251,8 +235,8 @@ static struct xt_match xt_multiport_matc
 		.name		= "multiport",
 		.family		= AF_INET6,
 		.revision	= 0,
-		.checkentry	= checkentry6,
-		.match		= match,
+		.checkentry	= multiport_check6,
+		.match		= multiport_match,
 		.matchsize	= sizeof(struct xt_multiport),
 		.me		= THIS_MODULE,
 	},
@@ -260,8 +244,8 @@ static struct xt_match xt_multiport_matc
 		.name		= "multiport",
 		.family		= AF_INET6,
 		.revision	= 1,
-		.checkentry	= checkentry6_v1,
-		.match		= match_v1,
+		.checkentry	= multiport_check6_v1,
+		.match		= multiport_match_v1,
 		.matchsize	= sizeof(struct xt_multiport_v1),
 		.me		= THIS_MODULE,
 	},
Index: gitone/net/netfilter/xt_physdev.c
===================================================================
--- gitone.orig/net/netfilter/xt_physdev.c
+++ gitone/net/netfilter/xt_physdev.c
@@ -21,14 +21,10 @@ MODULE_ALIAS("ipt_physdev");
 MODULE_ALIAS("ip6t_physdev");
 
 static bool
-match(const struct sk_buff *skb,
-      const struct net_device *in,
-      const struct net_device *out,
-      const struct xt_match *match,
-      const void *matchinfo,
-      int offset,
-      unsigned int protoff,
-      bool *hotdrop)
+physdev_match(const struct sk_buff *skb, const struct net_device *in,
+              const struct net_device *out, const struct xt_match *match,
+              const void *matchinfo, int offset, unsigned int protoff,
+              bool *hotdrop)
 {
 	int i;
 	static const char nulldevname[IFNAMSIZ];
@@ -99,11 +95,9 @@ match_outdev:
 }
 
 static bool
-checkentry(const char *tablename,
-		       const void *ip,
-		       const struct xt_match *match,
-		       void *matchinfo,
-		       unsigned int hook_mask)
+physdev_check(const char *tablename, const void *ip,
+              const struct xt_match *match, void *matchinfo,
+              unsigned int hook_mask)
 {
 	const struct xt_physdev_info *info = matchinfo;
 
@@ -128,16 +122,16 @@ static struct xt_match xt_physdev_match[
 	{
 		.name		= "physdev",
 		.family		= AF_INET,
-		.checkentry	= checkentry,
-		.match		= match,
+		.checkentry	= physdev_check,
+		.match		= physdev_match,
 		.matchsize	= sizeof(struct xt_physdev_info),
 		.me		= THIS_MODULE,
 	},
 	{
 		.name		= "physdev",
 		.family		= AF_INET6,
-		.checkentry	= checkentry,
-		.match		= match,
+		.checkentry	= physdev_check,
+		.match		= physdev_match,
 		.matchsize	= sizeof(struct xt_physdev_info),
 		.me		= THIS_MODULE,
 	},
Index: gitone/net/netfilter/xt_pkttype.c
===================================================================
--- gitone.orig/net/netfilter/xt_pkttype.c
+++ gitone/net/netfilter/xt_pkttype.c
@@ -21,14 +21,11 @@ MODULE_DESCRIPTION("IP tables match to m
 MODULE_ALIAS("ipt_pkttype");
 MODULE_ALIAS("ip6t_pkttype");
 
-static bool match(const struct sk_buff *skb,
-      const struct net_device *in,
-      const struct net_device *out,
-      const struct xt_match *match,
-      const void *matchinfo,
-      int offset,
-      unsigned int protoff,
-      bool *hotdrop)
+static bool
+pkttype_match(const struct sk_buff *skb, const struct net_device *in,
+              const struct net_device *out, const struct xt_match *match,
+              const void *matchinfo, int offset, unsigned int protoff,
+              bool *hotdrop)
 {
 	u_int8_t type;
 	const struct xt_pkttype_info *info = matchinfo;
@@ -47,14 +44,14 @@ static struct xt_match xt_pkttype_match[
 	{
 		.name		= "pkttype",
 		.family		= AF_INET,
-		.match		= match,
+		.match		= pkttype_match,
 		.matchsize	= sizeof(struct xt_pkttype_info),
 		.me		= THIS_MODULE,
 	},
 	{
 		.name		= "pkttype",
 		.family		= AF_INET6,
-		.match		= match,
+		.match		= pkttype_match,
 		.matchsize	= sizeof(struct xt_pkttype_info),
 		.me		= THIS_MODULE,
 	},
Index: gitone/net/netfilter/xt_policy.c
===================================================================
--- gitone.orig/net/netfilter/xt_policy.c
+++ gitone/net/netfilter/xt_policy.c
@@ -108,14 +108,11 @@ match_policy_out(const struct sk_buff *s
 	return strict ? i == info->len : 0;
 }
 
-static bool match(const struct sk_buff *skb,
-		  const struct net_device *in,
-		  const struct net_device *out,
-		  const struct xt_match *match,
-		  const void *matchinfo,
-		  int offset,
-		  unsigned int protoff,
-		  bool *hotdrop)
+static bool
+policy_match(const struct sk_buff *skb, const struct net_device *in,
+             const struct net_device *out, const struct xt_match *match,
+             const void *matchinfo, int offset, unsigned int protoff,
+             bool *hotdrop)
 {
 	const struct xt_policy_info *info = matchinfo;
 	int ret;
@@ -133,9 +130,10 @@ static bool match(const struct sk_buff *
 	return ret;
 }
 
-static bool checkentry(const char *tablename, const void *ip_void,
-		       const struct xt_match *match,
-		       void *matchinfo, unsigned int hook_mask)
+static bool
+policy_check(const char *tablename, const void *ip_void,
+             const struct xt_match *match, void *matchinfo,
+             unsigned int hook_mask)
 {
 	struct xt_policy_info *info = matchinfo;
 
@@ -168,16 +166,16 @@ static struct xt_match xt_policy_match[]
 	{
 		.name		= "policy",
 		.family		= AF_INET,
5~-		.checkentry 	= checkentry,
-		.match		= match,
+		.checkentry 	= policy_check,
+		.match		= policy_match,
 		.matchsize	= sizeof(struct xt_policy_info),
 		.me		= THIS_MODULE,
 	},
 	{
 		.name		= "policy",
 		.family		= AF_INET6,
-		.checkentry	= checkentry,
-		.match		= match,
+		.checkentry	= policy_check,
+		.match		= policy_match,
 		.matchsize	= sizeof(struct xt_policy_info),
 		.me		= THIS_MODULE,
 	},
Index: gitone/net/netfilter/xt_quota.c
===================================================================
--- gitone.orig/net/netfilter/xt_quota.c
+++ gitone/net/netfilter/xt_quota.c
@@ -17,10 +17,10 @@ MODULE_ALIAS("ip6t_quota");
 static DEFINE_SPINLOCK(quota_lock);
 
 static bool
-match(const struct sk_buff *skb,
-      const struct net_device *in, const struct net_device *out,
-      const struct xt_match *match, const void *matchinfo,
-      int offset, unsigned int protoff, bool *hotdrop)
+quota_match(const struct sk_buff *skb, const struct net_device *in,
+            const struct net_device *out, const struct xt_match *match,
+            const void *matchinfo, int offset, unsigned int protoff,
+            bool *hotdrop)
 {
 	struct xt_quota_info *q =
 		((const struct xt_quota_info *)matchinfo)->master;
@@ -40,9 +40,9 @@ match(const struct sk_buff *skb,
 }
 
 static bool
-checkentry(const char *tablename, const void *entry,
-	   const struct xt_match *match, void *matchinfo,
-	   unsigned int hook_mask)
+quota_check(const char *tablename, const void *entry,
+            const struct xt_match *match, void *matchinfo,
+            unsigned int hook_mask)
 {
 	struct xt_quota_info *q = matchinfo;
 
@@ -57,16 +57,16 @@ static struct xt_match xt_quota_match[] 
 	{
 		.name		= "quota",
 		.family		= AF_INET,
-		.checkentry	= checkentry,
-		.match		= match,
+		.checkentry	= quota_check,
+		.match		= quota_match,
 		.matchsize	= sizeof(struct xt_quota_info),
 		.me		= THIS_MODULE
 	},
 	{
 		.name		= "quota",
 		.family		= AF_INET6,
-		.checkentry	= checkentry,
-		.match		= match,
+		.checkentry	= quota_check,
+		.match		= quota_match,
 		.matchsize	= sizeof(struct xt_quota_info),
 		.me		= THIS_MODULE
 	},
Index: gitone/net/netfilter/xt_realm.c
===================================================================
--- gitone.orig/net/netfilter/xt_realm.c
+++ gitone/net/netfilter/xt_realm.c
@@ -22,14 +22,10 @@ MODULE_DESCRIPTION("X_tables realm match
 MODULE_ALIAS("ipt_realm");
 
 static bool
-match(const struct sk_buff *skb,
-      const struct net_device *in,
-      const struct net_device *out,
-      const struct xt_match *match,
-      const void *matchinfo,
-      int offset,
-      unsigned int protoff,
-      bool *hotdrop)
+realm_match(const struct sk_buff *skb, const struct net_device *in,
+            const struct net_device *out, const struct xt_match *match,
+            const void *matchinfo, int offset, unsigned int protoff,
+            bool *hotdrop)
 {
 	const struct xt_realm_info *info = matchinfo;
 	const struct dst_entry *dst = skb->dst;
@@ -37,9 +33,9 @@ match(const struct sk_buff *skb,
 	return (info->id == (dst->tclassid & info->mask)) ^ info->invert;
 }
 
-static struct xt_match realm_match __read_mostly = {
+static struct xt_match realm_reg __read_mostly = {
 	.name		= "realm",
-	.match		= match,
+	.match		= realm_match,
 	.matchsize	= sizeof(struct xt_realm_info),
 	.hooks		= (1 << NF_IP_POST_ROUTING) | (1 << NF_IP_FORWARD) |
 			  (1 << NF_IP_LOCAL_OUT) | (1 << NF_IP_LOCAL_IN),
@@ -49,12 +45,12 @@ static struct xt_match realm_match __rea
 
 static int __init xt_realm_init(void)
 {
-	return xt_register_match(&realm_match);
+	return xt_register_match(&realm_reg);
 }
 
 static void __exit xt_realm_fini(void)
 {
-	xt_unregister_match(&realm_match);
+	xt_unregister_match(&realm_reg);
 }
 
 module_init(xt_realm_init);
Index: gitone/net/netfilter/xt_sctp.c
===================================================================
--- gitone.orig/net/netfilter/xt_sctp.c
+++ gitone/net/netfilter/xt_sctp.c
@@ -116,14 +116,10 @@ match_packet(const struct sk_buff *skb,
 }
 
 static bool
-match(const struct sk_buff *skb,
-      const struct net_device *in,
-      const struct net_device *out,
-      const struct xt_match *match,
-      const void *matchinfo,
-      int offset,
-      unsigned int protoff,
-      bool *hotdrop)
+sctp_match(const struct sk_buff *skb, const struct net_device *in,
+           const struct net_device *out, const struct xt_match *match,
+           const void *matchinfo, int offset, unsigned int protoff,
+           bool *hotdrop)
 {
 	const struct xt_sctp_info *info = matchinfo;
 	sctp_sctphdr_t _sh, *sh;
@@ -153,11 +149,8 @@ match(const struct sk_buff *skb,
 }
 
 static bool
-checkentry(const char *tablename,
-	   const void *inf,
-	   const struct xt_match *match,
-	   void *matchinfo,
-	   unsigned int hook_mask)
+sctp_check(const char *tablename, const void *inf, const struct xt_match *match,
+           void *matchinfo, unsigned int hook_mask)
 {
 	const struct xt_sctp_info *info = matchinfo;
 
@@ -175,8 +168,8 @@ static struct xt_match xt_sctp_match[] _
 	{
 		.name		= "sctp",
 		.family		= AF_INET,
-		.checkentry	= checkentry,
-		.match		= match,
+		.checkentry	= sctp_check,
+		.match		= sctp_match,
 		.matchsize	= sizeof(struct xt_sctp_info),
 		.proto		= IPPROTO_SCTP,
 		.me		= THIS_MODULE
@@ -184,8 +177,8 @@ static struct xt_match xt_sctp_match[] _
 	{
 		.name		= "sctp",
 		.family		= AF_INET6,
-		.checkentry	= checkentry,
-		.match		= match,
+		.checkentry	= sctp_check,
+		.match		= sctp_match,
 		.matchsize	= sizeof(struct xt_sctp_info),
 		.proto		= IPPROTO_SCTP,
 		.me		= THIS_MODULE
Index: gitone/net/netfilter/xt_state.c
===================================================================
--- gitone.orig/net/netfilter/xt_state.c
+++ gitone/net/netfilter/xt_state.c
@@ -21,14 +21,10 @@ MODULE_ALIAS("ipt_state");
 MODULE_ALIAS("ip6t_state");
 
 static bool
-match(const struct sk_buff *skb,
-      const struct net_device *in,
-      const struct net_device *out,
-      const struct xt_match *match,
-      const void *matchinfo,
-      int offset,
-      unsigned int protoff,
-      bool *hotdrop)
+state_match(const struct sk_buff *skb, const struct net_device *in,
+            const struct net_device *out, const struct xt_match *match,
+            const void *matchinfo, int offset, unsigned int protoff,
+            bool *hotdrop)
 {
 	const struct xt_state_info *sinfo = matchinfo;
 	enum ip_conntrack_info ctinfo;
@@ -44,11 +40,10 @@ match(const struct sk_buff *skb,
 	return (sinfo->statemask & statebit);
 }
 
-static bool check(const char *tablename,
-		  const void *inf,
-		  const struct xt_match *match,
-		  void *matchinfo,
-		  unsigned int hook_mask)
+static bool
+state_check(const char *tablename, const void *inf,
+            const struct xt_match *match, void *matchinfo,
+            unsigned int hook_mask)
 {
 	if (nf_ct_l3proto_try_module_get(match->family) < 0) {
 		printk(KERN_WARNING "can't load conntrack support for "
@@ -58,8 +53,7 @@ static bool check(const char *tablename,
 	return true;
 }
 
-static void
-destroy(const struct xt_match *match, void *matchinfo)
+static void state_destroy(const struct xt_match *match, void *matchinfo)
 {
 	nf_ct_l3proto_module_put(match->family);
 }
@@ -68,18 +62,18 @@ static struct xt_match xt_state_match[] 
 	{
 		.name		= "state",
 		.family		= AF_INET,
-		.checkentry	= check,
-		.match		= match,
-		.destroy	= destroy,
+		.checkentry	= state_check,
+		.match		= state_match,
+		.destroy	= state_destroy,
 		.matchsize	= sizeof(struct xt_state_info),
 		.me		= THIS_MODULE,
 	},
 	{
 		.name		= "state",
 		.family		= AF_INET6,
-		.checkentry	= check,
-		.match		= match,
-		.destroy	= destroy,
+		.checkentry	= state_check,
+		.match		= state_match,
+		.destroy	= state_destroy,
 		.matchsize	= sizeof(struct xt_state_info),
 		.me		= THIS_MODULE,
 	},
Index: gitone/net/netfilter/xt_statistic.c
===================================================================
--- gitone.orig/net/netfilter/xt_statistic.c
+++ gitone/net/netfilter/xt_statistic.c
@@ -25,10 +25,10 @@ MODULE_ALIAS("ip6t_statistic");
 static DEFINE_SPINLOCK(nth_lock);
 
 static bool
-match(const struct sk_buff *skb,
-      const struct net_device *in, const struct net_device *out,
-      const struct xt_match *match, const void *matchinfo,
-      int offset, unsigned int protoff, bool *hotdrop)
+statistic_match(const struct sk_buff *skb, const struct net_device *in,
+                const struct net_device *out, const struct xt_match *match,
+                const void *matchinfo, int offset, unsigned int protoff,
+                bool *hotdrop)
 {
 	struct xt_statistic_info *info = (struct xt_statistic_info *)matchinfo;
 	bool ret = info->flags & XT_STATISTIC_INVERT;
@@ -53,9 +53,9 @@ match(const struct sk_buff *skb,
 }
 
 static bool
-checkentry(const char *tablename, const void *entry,
-	   const struct xt_match *match, void *matchinfo,
-	   unsigned int hook_mask)
+statistic_check(const char *tablename, const void *entry,
+                const struct xt_match *match, void *matchinfo,
+                unsigned int hook_mask)
 {
 	struct xt_statistic_info *info = matchinfo;
 
@@ -70,16 +70,16 @@ static struct xt_match xt_statistic_matc
 	{
 		.name		= "statistic",
 		.family		= AF_INET,
-		.checkentry	= checkentry,
-		.match		= match,
+		.checkentry	= statistic_check,
+		.match		= statistic_match,
 		.matchsize	= sizeof(struct xt_statistic_info),
 		.me		= THIS_MODULE,
 	},
 	{
 		.name		= "statistic",
 		.family		= AF_INET6,
-		.checkentry	= checkentry,
-		.match		= match,
+		.checkentry	= statistic_check,
+		.match		= statistic_match,
 		.matchsize	= sizeof(struct xt_statistic_info),
 		.me		= THIS_MODULE,
 	},
Index: gitone/net/netfilter/xt_string.c
===================================================================
--- gitone.orig/net/netfilter/xt_string.c
+++ gitone/net/netfilter/xt_string.c
@@ -21,14 +21,11 @@ MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_string");
 MODULE_ALIAS("ip6t_string");
 
-static bool match(const struct sk_buff *skb,
-		  const struct net_device *in,
-		  const struct net_device *out,
-		  const struct xt_match *match,
-		  const void *matchinfo,
-		  int offset,
-		  unsigned int protoff,
-		  bool *hotdrop)
+static bool
+string_match(const struct sk_buff *skb, const struct net_device *in,
+             const struct net_device *out, const struct xt_match *match,
+             const void *matchinfo, int offset, unsigned int protoff,
+             bool *hotdrop)
 {
 	const struct xt_string_info *conf = matchinfo;
 	struct ts_state state;
@@ -42,11 +39,10 @@ static bool match(const struct sk_buff *
 
 #define STRING_TEXT_PRIV(m) ((struct xt_string_info *) m)
 
-static bool checkentry(const char *tablename,
-		       const void *ip,
-		       const struct xt_match *match,
-		       void *matchinfo,
-		       unsigned int hook_mask)
+static bool
+string_check(const char *tablename, const void *ip,
+             const struct xt_match *match, void *matchinfo,
+             unsigned int hook_mask)
 {
 	struct xt_string_info *conf = matchinfo;
 	struct ts_config *ts_conf;
@@ -68,7 +64,7 @@ static bool checkentry(const char *table
 	return true;
 }
 
-static void destroy(const struct xt_match *match, void *matchinfo)
+static void string_destroy(const struct xt_match *match, void *matchinfo)
 {
 	textsearch_destroy(STRING_TEXT_PRIV(matchinfo)->config);
 }
@@ -77,18 +73,18 @@ static struct xt_match xt_string_match[]
 	{
 		.name 		= "string",
 		.family		= AF_INET,
-		.checkentry	= checkentry,
-		.match 		= match,
-		.destroy 	= destroy,
+		.checkentry	= string_check,
+		.match 		= string_match,
+		.destroy 	= string_destroy,
 		.matchsize	= sizeof(struct xt_string_info),
 		.me 		= THIS_MODULE
 	},
 	{
 		.name 		= "string",
 		.family		= AF_INET6,
-		.checkentry	= checkentry,
-		.match 		= match,
-		.destroy 	= destroy,
+		.checkentry	= string_check,
+		.match 		= string_match,
+		.destroy 	= string_destroy,
 		.matchsize	= sizeof(struct xt_string_info),
 		.me 		= THIS_MODULE
 	},
Index: gitone/net/netfilter/xt_tcpmss.c
===================================================================
--- gitone.orig/net/netfilter/xt_tcpmss.c
+++ gitone/net/netfilter/xt_tcpmss.c
@@ -25,14 +25,10 @@ MODULE_ALIAS("ipt_tcpmss");
 MODULE_ALIAS("ip6t_tcpmss");
 
 static bool
-match(const struct sk_buff *skb,
-      const struct net_device *in,
-      const struct net_device *out,
-      const struct xt_match *match,
-      const void *matchinfo,
-      int offset,
-      unsigned int protoff,
-      bool *hotdrop)
+tcpmss_match(const struct sk_buff *skb, const struct net_device *in,
+             const struct net_device *out, const struct xt_match *match,
+             const void *matchinfo, int offset, unsigned int protoff,
+             bool *hotdrop)
 {
 	const struct xt_tcpmss_match_info *info = matchinfo;
 	struct tcphdr _tcph, *th;
@@ -86,7 +82,7 @@ static struct xt_match xt_tcpmss_match[]
 	{
 		.name		= "tcpmss",
 		.family		= AF_INET,
-		.match		= match,
+		.match		= tcpmss_match,
 		.matchsize	= sizeof(struct xt_tcpmss_match_info),
 		.proto		= IPPROTO_TCP,
 		.me		= THIS_MODULE,
@@ -94,7 +90,7 @@ static struct xt_match xt_tcpmss_match[]
 	{
 		.name		= "tcpmss",
 		.family		= AF_INET6,
-		.match		= match,
+		.match		= tcpmss_match,
 		.matchsize	= sizeof(struct xt_tcpmss_match_info),
 		.proto		= IPPROTO_TCP,
 		.me		= THIS_MODULE,
