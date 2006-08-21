From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 13/18]: x_tables: remove unused argument to target
	functions
Date: Tue, 22 Aug 2006 00:52:35 +0200 (MEST)
Message-ID: <20060821225235.10288.7810.sendpatchset@localhost.localdomain>
References: <20060821225217.10288.69738.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060821225217.10288.69738.sendpatchset@localhost.localdomain>
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

[NETFILTER]: x_tables: remove unused argument to target functions

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 855a763072e92f8b1e4931003cc82a0b3ba1131d
tree e683e7d21c3d96032d90c0634a6d62c2473932ac
parent 160a7782ed42f6295b9d68b18bda7eb1f37e86a0
author Patrick McHardy <kaber@trash.net> Sun, 13 Aug 2006 19:46:20 +0200
committer Patrick McHardy <kaber@trash.net> Sun, 13 Aug 2006 19:46:20 +0200

 include/linux/netfilter/x_tables.h        |    3 +--
 include/linux/netfilter_arp/arp_tables.h  |    3 +--
 include/linux/netfilter_ipv4/ip_tables.h  |    3 +--
 include/linux/netfilter_ipv6/ip6_tables.h |    3 +--
 net/ipv4/netfilter/arp_tables.c           |    9 +++------
 net/ipv4/netfilter/arpt_mangle.c          |    2 +-
 net/ipv4/netfilter/arptable_filter.c      |    2 +-
 net/ipv4/netfilter/ip_nat_rule.c          |    8 +++-----
 net/ipv4/netfilter/ip_tables.c            |    9 +++------
 net/ipv4/netfilter/ipt_CLUSTERIP.c        |    3 +--
 net/ipv4/netfilter/ipt_ECN.c              |    3 +--
 net/ipv4/netfilter/ipt_LOG.c              |    3 +--
 net/ipv4/netfilter/ipt_MASQUERADE.c       |    3 +--
 net/ipv4/netfilter/ipt_NETMAP.c           |    3 +--
 net/ipv4/netfilter/ipt_REDIRECT.c         |    3 +--
 net/ipv4/netfilter/ipt_REJECT.c           |    3 +--
 net/ipv4/netfilter/ipt_SAME.c             |    3 +--
 net/ipv4/netfilter/ipt_TCPMSS.c           |    3 +--
 net/ipv4/netfilter/ipt_TOS.c              |    3 +--
 net/ipv4/netfilter/ipt_TTL.c              |    2 +-
 net/ipv4/netfilter/ipt_ULOG.c             |    2 +-
 net/ipv4/netfilter/iptable_filter.c       |    4 ++--
 net/ipv4/netfilter/iptable_mangle.c       |    4 ++--
 net/ipv4/netfilter/iptable_raw.c          |    2 +-
 net/ipv6/netfilter/ip6_tables.c           |    9 +++------
 net/ipv6/netfilter/ip6t_HL.c              |    2 +-
 net/ipv6/netfilter/ip6t_LOG.c             |    3 +--
 net/ipv6/netfilter/ip6t_REJECT.c          |    3 +--
 net/ipv6/netfilter/ip6table_filter.c      |    4 ++--
 net/ipv6/netfilter/ip6table_mangle.c      |    4 ++--
 net/ipv6/netfilter/ip6table_raw.c         |    2 +-
 net/netfilter/xt_CLASSIFY.c               |    3 +--
 net/netfilter/xt_CONNMARK.c               |    3 +--
 net/netfilter/xt_CONNSECMARK.c            |    2 +-
 net/netfilter/xt_DSCP.c                   |    6 ++----
 net/netfilter/xt_MARK.c                   |    6 ++----
 net/netfilter/xt_NFQUEUE.c                |    3 +--
 net/netfilter/xt_NOTRACK.c                |    3 +--
 net/netfilter/xt_SECMARK.c                |    2 +-
 net/netfilter/xt_connbytes.c              |    2 +-
 net/sched/act_ipt.c                       |    3 +--
 41 files changed, 55 insertions(+), 91 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 9a99124..9cef0e9 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -211,8 +211,7 @@ struct xt_target
 			       const struct net_device *out,
 			       unsigned int hooknum,
 			       const struct xt_target *target,
-			       const void *targinfo,
-			       void *userdata);
+			       const void *targinfo);
 
 	/* Called when user tries to insert an entry of this type:
            hook_mask is a bitmask of hooks from which it can be
diff --git a/include/linux/netfilter_arp/arp_tables.h b/include/linux/netfilter_arp/arp_tables.h
index 62cc27d..149e87c 100644
--- a/include/linux/netfilter_arp/arp_tables.h
+++ b/include/linux/netfilter_arp/arp_tables.h
@@ -248,8 +248,7 @@ extern unsigned int arpt_do_table(struct
 				  unsigned int hook,
 				  const struct net_device *in,
 				  const struct net_device *out,
-				  struct arpt_table *table,
-				  void *userdata);
+				  struct arpt_table *table);
 
 #define ARPT_ALIGN(s) (((s) + (__alignof__(struct arpt_entry)-1)) & ~(__alignof__(struct arpt_entry)-1))
 #endif /*__KERNEL__*/
diff --git a/include/linux/netfilter_ipv4/ip_tables.h b/include/linux/netfilter_ipv4/ip_tables.h
index c0dac16..a536bbd 100644
--- a/include/linux/netfilter_ipv4/ip_tables.h
+++ b/include/linux/netfilter_ipv4/ip_tables.h
@@ -312,8 +312,7 @@ extern unsigned int ipt_do_table(struct 
 				 unsigned int hook,
 				 const struct net_device *in,
 				 const struct net_device *out,
-				 struct ipt_table *table,
-				 void *userdata);
+				 struct ipt_table *table);
 
 #define IPT_ALIGN(s) XT_ALIGN(s)
 
diff --git a/include/linux/netfilter_ipv6/ip6_tables.h b/include/linux/netfilter_ipv6/ip6_tables.h
index d0d5d1e..d7a8e9c 100644
--- a/include/linux/netfilter_ipv6/ip6_tables.h
+++ b/include/linux/netfilter_ipv6/ip6_tables.h
@@ -300,8 +300,7 @@ extern unsigned int ip6t_do_table(struct
 				  unsigned int hook,
 				  const struct net_device *in,
 				  const struct net_device *out,
-				  struct ip6t_table *table,
-				  void *userdata);
+				  struct ip6t_table *table);
 
 /* Check for an extension */
 extern int ip6t_ext_hdr(u8 nexthdr);
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 80c73ca..c38c6c4 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -208,8 +208,7 @@ static unsigned int arpt_error(struct sk
 			       const struct net_device *out,
 			       unsigned int hooknum,
 			       const struct xt_target *target,
-			       const void *targinfo,
-			       void *userinfo)
+			       const void *targinfo)
 {
 	if (net_ratelimit())
 		printk("arp_tables: error: '%s'\n", (char *)targinfo);
@@ -226,8 +225,7 @@ unsigned int arpt_do_table(struct sk_buf
 			   unsigned int hook,
 			   const struct net_device *in,
 			   const struct net_device *out,
-			   struct arpt_table *table,
-			   void *userdata)
+			   struct arpt_table *table)
 {
 	static const char nulldevname[IFNAMSIZ];
 	unsigned int verdict = NF_DROP;
@@ -301,8 +299,7 @@ unsigned int arpt_do_table(struct sk_buf
 								     in, out,
 								     hook,
 								     t->u.kernel.target,
-								     t->data,
-								     userdata);
+								     t->data);
 
 				/* Target might have changed stuff. */
 				arp = (*pskb)->nh.arph;
diff --git a/net/ipv4/netfilter/arpt_mangle.c b/net/ipv4/netfilter/arpt_mangle.c
index a58325c..05fb242 100644
--- a/net/ipv4/netfilter/arpt_mangle.c
+++ b/net/ipv4/netfilter/arpt_mangle.c
@@ -11,7 +11,7 @@ static unsigned int
 target(struct sk_buff **pskb,
        const struct net_device *in, const struct net_device *out,
        unsigned int hooknum, const struct xt_target *target,
-       const void *targinfo, void *userinfo)
+       const void *targinfo)
 {
 	const struct arpt_mangle *mangle = targinfo;
 	struct arphdr *arp;
diff --git a/net/ipv4/netfilter/arptable_filter.c b/net/ipv4/netfilter/arptable_filter.c
index d7c472f..7edea2a 100644
--- a/net/ipv4/netfilter/arptable_filter.c
+++ b/net/ipv4/netfilter/arptable_filter.c
@@ -155,7 +155,7 @@ static unsigned int arpt_hook(unsigned i
 			      const struct net_device *out,
 			      int (*okfn)(struct sk_buff *))
 {
-	return arpt_do_table(pskb, hook, in, out, &packet_filter, NULL);
+	return arpt_do_table(pskb, hook, in, out, &packet_filter);
 }
 
 static struct nf_hook_ops arpt_ops[] = {
diff --git a/net/ipv4/netfilter/ip_nat_rule.c b/net/ipv4/netfilter/ip_nat_rule.c
index 1aba926..1aa0e4f 100644
--- a/net/ipv4/netfilter/ip_nat_rule.c
+++ b/net/ipv4/netfilter/ip_nat_rule.c
@@ -104,8 +104,7 @@ static unsigned int ipt_snat_target(stru
 				    const struct net_device *out,
 				    unsigned int hooknum,
 				    const struct ipt_target *target,
-				    const void *targinfo,
-				    void *userinfo)
+				    const void *targinfo)
 {
 	struct ip_conntrack *ct;
 	enum ip_conntrack_info ctinfo;
@@ -147,8 +146,7 @@ static unsigned int ipt_dnat_target(stru
 				    const struct net_device *out,
 				    unsigned int hooknum,
 				    const struct ipt_target *target,
-				    const void *targinfo,
-				    void *userinfo)
+				    const void *targinfo)
 {
 	struct ip_conntrack *ct;
 	enum ip_conntrack_info ctinfo;
@@ -255,7 +253,7 @@ int ip_nat_rule_find(struct sk_buff **ps
 {
 	int ret;
 
-	ret = ipt_do_table(pskb, hooknum, in, out, &nat_table, NULL);
+	ret = ipt_do_table(pskb, hooknum, in, out, &nat_table);
 
 	if (ret == NF_ACCEPT) {
 		if (!ip_nat_initialized(ct, HOOK2MANIP(hooknum)))
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index fc5bdd5..bdf9196 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -180,8 +180,7 @@ ipt_error(struct sk_buff **pskb,
 	  const struct net_device *out,
 	  unsigned int hooknum,
 	  const struct xt_target *target,
-	  const void *targinfo,
-	  void *userinfo)
+	  const void *targinfo)
 {
 	if (net_ratelimit())
 		printk("ip_tables: error: `%s'\n", (char *)targinfo);
@@ -217,8 +216,7 @@ ipt_do_table(struct sk_buff **pskb,
 	     unsigned int hook,
 	     const struct net_device *in,
 	     const struct net_device *out,
-	     struct ipt_table *table,
-	     void *userdata)
+	     struct ipt_table *table)
 {
 	static const char nulldevname[IFNAMSIZ] __attribute__((aligned(sizeof(long))));
 	u_int16_t offset;
@@ -307,8 +305,7 @@ #endif
 								     in, out,
 								     hook,
 								     t->u.kernel.target,
-								     t->data,
-								     userdata);
+								     t->data);
 
 #ifdef CONFIG_NETFILTER_DEBUG
 				if (((struct ipt_entry *)table_base)->comefrom
diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index d994c5f..a08383c 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -302,8 +302,7 @@ target(struct sk_buff **pskb,
        const struct net_device *out,
        unsigned int hooknum,
        const struct xt_target *target,
-       const void *targinfo,
-       void *userinfo)
+       const void *targinfo)
 {
 	const struct ipt_clusterip_tgt_info *cipinfo = targinfo;
 	enum ip_conntrack_info ctinfo;
diff --git a/net/ipv4/netfilter/ipt_ECN.c b/net/ipv4/netfilter/ipt_ECN.c
index 7e30e6d..1c3da4a 100644
--- a/net/ipv4/netfilter/ipt_ECN.c
+++ b/net/ipv4/netfilter/ipt_ECN.c
@@ -85,8 +85,7 @@ target(struct sk_buff **pskb,
        const struct net_device *out,
        unsigned int hooknum,
        const struct xt_target *target,
-       const void *targinfo,
-       void *userinfo)
+       const void *targinfo)
 {
 	const struct ipt_ECN_info *einfo = targinfo;
 
diff --git a/net/ipv4/netfilter/ipt_LOG.c b/net/ipv4/netfilter/ipt_LOG.c
index b98f7b0..a8d356c 100644
--- a/net/ipv4/netfilter/ipt_LOG.c
+++ b/net/ipv4/netfilter/ipt_LOG.c
@@ -416,8 +416,7 @@ ipt_log_target(struct sk_buff **pskb,
 	       const struct net_device *out,
 	       unsigned int hooknum,
 	       const struct xt_target *target,
-	       const void *targinfo,
-	       void *userinfo)
+	       const void *targinfo)
 {
 	const struct ipt_log_info *loginfo = targinfo;
 	struct nf_loginfo li;
diff --git a/net/ipv4/netfilter/ipt_MASQUERADE.c b/net/ipv4/netfilter/ipt_MASQUERADE.c
index ebd94f2..9659793 100644
--- a/net/ipv4/netfilter/ipt_MASQUERADE.c
+++ b/net/ipv4/netfilter/ipt_MASQUERADE.c
@@ -64,8 +64,7 @@ masquerade_target(struct sk_buff **pskb,
 		  const struct net_device *out,
 		  unsigned int hooknum,
 		  const struct xt_target *target,
-		  const void *targinfo,
-		  void *userinfo)
+		  const void *targinfo)
 {
 	struct ip_conntrack *ct;
 	enum ip_conntrack_info ctinfo;
diff --git a/net/ipv4/netfilter/ipt_NETMAP.c b/net/ipv4/netfilter/ipt_NETMAP.c
index 736c4b5..fd5e74a 100644
--- a/net/ipv4/netfilter/ipt_NETMAP.c
+++ b/net/ipv4/netfilter/ipt_NETMAP.c
@@ -55,8 +55,7 @@ target(struct sk_buff **pskb,
        const struct net_device *out,
        unsigned int hooknum,
        const struct xt_target *target,
-       const void *targinfo,
-       void *userinfo)
+       const void *targinfo)
 {
 	struct ip_conntrack *ct;
 	enum ip_conntrack_info ctinfo;
diff --git a/net/ipv4/netfilter/ipt_REDIRECT.c b/net/ipv4/netfilter/ipt_REDIRECT.c
index f290463..839fe99 100644
--- a/net/ipv4/netfilter/ipt_REDIRECT.c
+++ b/net/ipv4/netfilter/ipt_REDIRECT.c
@@ -58,8 +58,7 @@ redirect_target(struct sk_buff **pskb,
 		const struct net_device *out,
 		unsigned int hooknum,
 		const struct xt_target *target,
-		const void *targinfo,
-		void *userinfo)
+		const void *targinfo)
 {
 	struct ip_conntrack *ct;
 	enum ip_conntrack_info ctinfo;
diff --git a/net/ipv4/netfilter/ipt_REJECT.c b/net/ipv4/netfilter/ipt_REJECT.c
index 95c6662..1dfd8e5 100644
--- a/net/ipv4/netfilter/ipt_REJECT.c
+++ b/net/ipv4/netfilter/ipt_REJECT.c
@@ -228,8 +228,7 @@ static unsigned int reject(struct sk_buf
 			   const struct net_device *out,
 			   unsigned int hooknum,
 			   const struct xt_target *target,
-			   const void *targinfo,
-			   void *userinfo)
+			   const void *targinfo)
 {
 	const struct ipt_reject_info *reject = targinfo;
 
diff --git a/net/ipv4/netfilter/ipt_SAME.c b/net/ipv4/netfilter/ipt_SAME.c
index 7169b09..cf80174 100644
--- a/net/ipv4/netfilter/ipt_SAME.c
+++ b/net/ipv4/netfilter/ipt_SAME.c
@@ -133,8 +133,7 @@ same_target(struct sk_buff **pskb,
 		const struct net_device *out,
 		unsigned int hooknum,
 		const struct xt_target *target,
-		const void *targinfo,
-		void *userinfo)
+		const void *targinfo)
 {
 	struct ip_conntrack *ct;
 	enum ip_conntrack_info ctinfo;
diff --git a/net/ipv4/netfilter/ipt_TCPMSS.c b/net/ipv4/netfilter/ipt_TCPMSS.c
index 0fce85e..6d668dc 100644
--- a/net/ipv4/netfilter/ipt_TCPMSS.c
+++ b/net/ipv4/netfilter/ipt_TCPMSS.c
@@ -41,8 +41,7 @@ ipt_tcpmss_target(struct sk_buff **pskb,
 		  const struct net_device *out,
 		  unsigned int hooknum,
 		  const struct xt_target *target,
-		  const void *targinfo,
-		  void *userinfo)
+		  const void *targinfo)
 {
 	const struct ipt_tcpmss_info *tcpmssinfo = targinfo;
 	struct tcphdr *tcph;
diff --git a/net/ipv4/netfilter/ipt_TOS.c b/net/ipv4/netfilter/ipt_TOS.c
index 52e9d70..043df01 100644
--- a/net/ipv4/netfilter/ipt_TOS.c
+++ b/net/ipv4/netfilter/ipt_TOS.c
@@ -26,8 +26,7 @@ target(struct sk_buff **pskb,
        const struct net_device *out,
        unsigned int hooknum,
        const struct xt_target *target,
-       const void *targinfo,
-       void *userinfo)
+       const void *targinfo)
 {
 	const struct ipt_tos_target_info *tosinfo = targinfo;
 	struct iphdr *iph = (*pskb)->nh.iph;
diff --git a/net/ipv4/netfilter/ipt_TTL.c b/net/ipv4/netfilter/ipt_TTL.c
index 2afb2a8..1640071 100644
--- a/net/ipv4/netfilter/ipt_TTL.c
+++ b/net/ipv4/netfilter/ipt_TTL.c
@@ -23,7 +23,7 @@ static unsigned int 
 ipt_ttl_target(struct sk_buff **pskb,
 	       const struct net_device *in, const struct net_device *out,
 	       unsigned int hooknum, const struct xt_target *target,
-	       const void *targinfo, void *userinfo)
+	       const void *targinfo)
 {
 	struct iphdr *iph;
 	const struct ipt_TTL_info *info = targinfo;
diff --git a/net/ipv4/netfilter/ipt_ULOG.c b/net/ipv4/netfilter/ipt_ULOG.c
index d7dd7fe..062b456 100644
--- a/net/ipv4/netfilter/ipt_ULOG.c
+++ b/net/ipv4/netfilter/ipt_ULOG.c
@@ -303,7 +303,7 @@ static unsigned int ipt_ulog_target(stru
 				    const struct net_device *out,
 				    unsigned int hooknum,
 				    const struct xt_target *target,
-				    const void *targinfo, void *userinfo)
+				    const void *targinfo)
 {
 	struct ipt_ulog_info *loginfo = (struct ipt_ulog_info *) targinfo;
 
diff --git a/net/ipv4/netfilter/iptable_filter.c b/net/ipv4/netfilter/iptable_filter.c
index 7f41748..e2e7dd8 100644
--- a/net/ipv4/netfilter/iptable_filter.c
+++ b/net/ipv4/netfilter/iptable_filter.c
@@ -90,7 +90,7 @@ ipt_hook(unsigned int hook,
 	 const struct net_device *out,
 	 int (*okfn)(struct sk_buff *))
 {
-	return ipt_do_table(pskb, hook, in, out, &packet_filter, NULL);
+	return ipt_do_table(pskb, hook, in, out, &packet_filter);
 }
 
 static unsigned int
@@ -108,7 +108,7 @@ ipt_local_out_hook(unsigned int hook,
 		return NF_ACCEPT;
 	}
 
-	return ipt_do_table(pskb, hook, in, out, &packet_filter, NULL);
+	return ipt_do_table(pskb, hook, in, out, &packet_filter);
 }
 
 static struct nf_hook_ops ipt_ops[] = {
diff --git a/net/ipv4/netfilter/iptable_mangle.c b/net/ipv4/netfilter/iptable_mangle.c
index 4e7998b..79336cb 100644
--- a/net/ipv4/netfilter/iptable_mangle.c
+++ b/net/ipv4/netfilter/iptable_mangle.c
@@ -119,7 +119,7 @@ ipt_route_hook(unsigned int hook,
 	 const struct net_device *out,
 	 int (*okfn)(struct sk_buff *))
 {
-	return ipt_do_table(pskb, hook, in, out, &packet_mangler, NULL);
+	return ipt_do_table(pskb, hook, in, out, &packet_mangler);
 }
 
 static unsigned int
@@ -148,7 +148,7 @@ ipt_local_hook(unsigned int hook,
 	daddr = (*pskb)->nh.iph->daddr;
 	tos = (*pskb)->nh.iph->tos;
 
-	ret = ipt_do_table(pskb, hook, in, out, &packet_mangler, NULL);
+	ret = ipt_do_table(pskb, hook, in, out, &packet_mangler);
 	/* Reroute for ANY change. */
 	if (ret != NF_DROP && ret != NF_STOLEN && ret != NF_QUEUE
 	    && ((*pskb)->nh.iph->saddr != saddr
diff --git a/net/ipv4/netfilter/iptable_raw.c b/net/ipv4/netfilter/iptable_raw.c
index 7912cce..bcbeb4a 100644
--- a/net/ipv4/netfilter/iptable_raw.c
+++ b/net/ipv4/netfilter/iptable_raw.c
@@ -95,7 +95,7 @@ ipt_hook(unsigned int hook,
 	 const struct net_device *out,
 	 int (*okfn)(struct sk_buff *))
 {
-	return ipt_do_table(pskb, hook, in, out, &packet_raw, NULL);
+	return ipt_do_table(pskb, hook, in, out, &packet_raw);
 }
 
 /* 'raw' is the very first table. */
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index f26898b..1978b6c 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -220,8 +220,7 @@ ip6t_error(struct sk_buff **pskb,
 	  const struct net_device *out,
 	  unsigned int hooknum,
 	  const struct xt_target *target,
-	  const void *targinfo,
-	  void *userinfo)
+	  const void *targinfo)
 {
 	if (net_ratelimit())
 		printk("ip6_tables: error: `%s'\n", (char *)targinfo);
@@ -258,8 +257,7 @@ ip6t_do_table(struct sk_buff **pskb,
 	      unsigned int hook,
 	      const struct net_device *in,
 	      const struct net_device *out,
-	      struct xt_table *table,
-	      void *userdata)
+	      struct xt_table *table)
 {
 	static const char nulldevname[IFNAMSIZ] __attribute__((aligned(sizeof(long))));
 	int offset = 0;
@@ -349,8 +347,7 @@ #endif
 								     in, out,
 								     hook,
 								     t->u.kernel.target,
-								     t->data,
-								     userdata);
+								     t->data);
 
 #ifdef CONFIG_NETFILTER_DEBUG
 				if (((struct ip6t_entry *)table_base)->comefrom
diff --git a/net/ipv6/netfilter/ip6t_HL.c b/net/ipv6/netfilter/ip6t_HL.c
index b8eff8e..c85d124 100644
--- a/net/ipv6/netfilter/ip6t_HL.c
+++ b/net/ipv6/netfilter/ip6t_HL.c
@@ -22,7 +22,7 @@ static unsigned int ip6t_hl_target(struc
 				   const struct net_device *out,
 				   unsigned int hooknum,
 				   const struct xt_target *target,
-				   const void *targinfo, void *userinfo)
+				   const void *targinfo)
 {
 	struct ipv6hdr *ip6h;
 	const struct ip6t_HL_info *info = targinfo;
diff --git a/net/ipv6/netfilter/ip6t_LOG.c b/net/ipv6/netfilter/ip6t_LOG.c
index 73c6300..acb9173 100644
--- a/net/ipv6/netfilter/ip6t_LOG.c
+++ b/net/ipv6/netfilter/ip6t_LOG.c
@@ -427,8 +427,7 @@ ip6t_log_target(struct sk_buff **pskb,
 		const struct net_device *out,
 		unsigned int hooknum,
 		const struct xt_target *target,
-		const void *targinfo,
-		void *userinfo)
+		const void *targinfo)
 {
 	const struct ip6t_log_info *loginfo = targinfo;
 	struct nf_loginfo li;
diff --git a/net/ipv6/netfilter/ip6t_REJECT.c b/net/ipv6/netfilter/ip6t_REJECT.c
index 7929ff4..343acd3 100644
--- a/net/ipv6/netfilter/ip6t_REJECT.c
+++ b/net/ipv6/netfilter/ip6t_REJECT.c
@@ -180,8 +180,7 @@ static unsigned int reject6_target(struc
 			   const struct net_device *out,
 			   unsigned int hooknum,
 			   const struct xt_target *target,
-			   const void *targinfo,
-			   void *userinfo)
+			   const void *targinfo)
 {
 	const struct ip6t_reject_info *reject = targinfo;
 
diff --git a/net/ipv6/netfilter/ip6table_filter.c b/net/ipv6/netfilter/ip6table_filter.c
index 60976c0..2fc07c7 100644
--- a/net/ipv6/netfilter/ip6table_filter.c
+++ b/net/ipv6/netfilter/ip6table_filter.c
@@ -108,7 +108,7 @@ ip6t_hook(unsigned int hook,
 	 const struct net_device *out,
 	 int (*okfn)(struct sk_buff *))
 {
-	return ip6t_do_table(pskb, hook, in, out, &packet_filter, NULL);
+	return ip6t_do_table(pskb, hook, in, out, &packet_filter);
 }
 
 static unsigned int
@@ -128,7 +128,7 @@ #if 0
 	}
 #endif
 
-	return ip6t_do_table(pskb, hook, in, out, &packet_filter, NULL);
+	return ip6t_do_table(pskb, hook, in, out, &packet_filter);
 }
 
 static struct nf_hook_ops ip6t_ops[] = {
diff --git a/net/ipv6/netfilter/ip6table_mangle.c b/net/ipv6/netfilter/ip6table_mangle.c
index 03a13ea..32db04f 100644
--- a/net/ipv6/netfilter/ip6table_mangle.c
+++ b/net/ipv6/netfilter/ip6table_mangle.c
@@ -138,7 +138,7 @@ ip6t_route_hook(unsigned int hook,
 	 const struct net_device *out,
 	 int (*okfn)(struct sk_buff *))
 {
-	return ip6t_do_table(pskb, hook, in, out, &packet_mangler, NULL);
+	return ip6t_do_table(pskb, hook, in, out, &packet_mangler);
 }
 
 static unsigned int
@@ -174,7 +174,7 @@ #endif
 	/* flowlabel and prio (includes version, which shouldn't change either */
 	flowlabel = *((u_int32_t *) (*pskb)->nh.ipv6h);
 
-	ret = ip6t_do_table(pskb, hook, in, out, &packet_mangler, NULL);
+	ret = ip6t_do_table(pskb, hook, in, out, &packet_mangler);
 
 	if (ret != NF_DROP && ret != NF_STOLEN 
 		&& (memcmp(&(*pskb)->nh.ipv6h->saddr, &saddr, sizeof(saddr))
diff --git a/net/ipv6/netfilter/ip6table_raw.c b/net/ipv6/netfilter/ip6table_raw.c
index 61a7c58..b4154da 100644
--- a/net/ipv6/netfilter/ip6table_raw.c
+++ b/net/ipv6/netfilter/ip6table_raw.c
@@ -122,7 +122,7 @@ ip6t_hook(unsigned int hook,
 	 const struct net_device *out,
 	 int (*okfn)(struct sk_buff *))
 {
-	return ip6t_do_table(pskb, hook, in, out, &packet_raw, NULL);
+	return ip6t_do_table(pskb, hook, in, out, &packet_raw);
 }
 
 static struct nf_hook_ops ip6t_ops[] = { 
diff --git a/net/netfilter/xt_CLASSIFY.c b/net/netfilter/xt_CLASSIFY.c
index 2d77ebb..5b3bff6 100644
--- a/net/netfilter/xt_CLASSIFY.c
+++ b/net/netfilter/xt_CLASSIFY.c
@@ -29,8 +29,7 @@ target(struct sk_buff **pskb,
        const struct net_device *out,
        unsigned int hooknum,
        const struct xt_target *target,
-       const void *targinfo,
-       void *userinfo)
+       const void *targinfo)
 {
 	const struct xt_classify_target_info *clinfo = targinfo;
 
diff --git a/net/netfilter/xt_CONNMARK.c b/net/netfilter/xt_CONNMARK.c
index e577356..c2125f6 100644
--- a/net/netfilter/xt_CONNMARK.c
+++ b/net/netfilter/xt_CONNMARK.c
@@ -38,8 +38,7 @@ target(struct sk_buff **pskb,
        const struct net_device *out,
        unsigned int hooknum,
        const struct xt_target *target,
-       const void *targinfo,
-       void *userinfo)
+       const void *targinfo)
 {
 	const struct xt_connmark_target_info *markinfo = targinfo;
 	u_int32_t diff;
diff --git a/net/netfilter/xt_CONNSECMARK.c b/net/netfilter/xt_CONNSECMARK.c
index 48f7fc3..4b9cc65 100644
--- a/net/netfilter/xt_CONNSECMARK.c
+++ b/net/netfilter/xt_CONNSECMARK.c
@@ -66,7 +66,7 @@ static void secmark_restore(struct sk_bu
 static unsigned int target(struct sk_buff **pskb, const struct net_device *in,
 			   const struct net_device *out, unsigned int hooknum,
 			   const struct xt_target *target,
-			   const void *targinfo, void *userinfo)
+			   const void *targinfo)
 {
 	struct sk_buff *skb = *pskb;
 	const struct xt_connsecmark_target_info *info = targinfo;
diff --git a/net/netfilter/xt_DSCP.c b/net/netfilter/xt_DSCP.c
index a1cd972..9d23c95 100644
--- a/net/netfilter/xt_DSCP.c
+++ b/net/netfilter/xt_DSCP.c
@@ -32,8 +32,7 @@ static unsigned int target(struct sk_buf
 			   const struct net_device *out,
 			   unsigned int hooknum,
 			   const struct xt_target *target,
-			   const void *targinfo,
-			   void *userinfo)
+			   const void *targinfo)
 {
 	const struct xt_DSCP_info *dinfo = targinfo;
 	u_int8_t dscp = ipv4_get_dsfield((*pskb)->nh.iph) >> XT_DSCP_SHIFT;
@@ -54,8 +53,7 @@ static unsigned int target6(struct sk_bu
 			    const struct net_device *out,
 			    unsigned int hooknum,
 			    const struct xt_target *target,
-			    const void *targinfo,
-			    void *userinfo)
+			    const void *targinfo)
 {
 	const struct xt_DSCP_info *dinfo = targinfo;
 	u_int8_t dscp = ipv6_get_dsfield((*pskb)->nh.ipv6h) >> XT_DSCP_SHIFT;
diff --git a/net/netfilter/xt_MARK.c b/net/netfilter/xt_MARK.c
index 0a61272..95a171c 100644
--- a/net/netfilter/xt_MARK.c
+++ b/net/netfilter/xt_MARK.c
@@ -27,8 +27,7 @@ target_v0(struct sk_buff **pskb,
 	  const struct net_device *out,
 	  unsigned int hooknum,
 	  const struct xt_target *target,
-	  const void *targinfo,
-	  void *userinfo)
+	  const void *targinfo)
 {
 	const struct xt_mark_target_info *markinfo = targinfo;
 
@@ -44,8 +43,7 @@ target_v1(struct sk_buff **pskb,
 	  const struct net_device *out,
 	  unsigned int hooknum,
 	  const struct xt_target *target,
-	  const void *targinfo,
-	  void *userinfo)
+	  const void *targinfo)
 {
 	const struct xt_mark_target_info_v1 *markinfo = targinfo;
 	int mark = 0;
diff --git a/net/netfilter/xt_NFQUEUE.c b/net/netfilter/xt_NFQUEUE.c
index 7b98228..db9b896 100644
--- a/net/netfilter/xt_NFQUEUE.c
+++ b/net/netfilter/xt_NFQUEUE.c
@@ -29,8 +29,7 @@ target(struct sk_buff **pskb,
        const struct net_device *out,
        unsigned int hooknum,
        const struct xt_target *target,
-       const void *targinfo,
-       void *userinfo)
+       const void *targinfo)
 {
 	const struct xt_NFQ_info *tinfo = targinfo;
 
diff --git a/net/netfilter/xt_NOTRACK.c b/net/netfilter/xt_NOTRACK.c
index cab881d..6d00dca 100644
--- a/net/netfilter/xt_NOTRACK.c
+++ b/net/netfilter/xt_NOTRACK.c
@@ -16,8 +16,7 @@ target(struct sk_buff **pskb,
        const struct net_device *out,
        unsigned int hooknum,
        const struct xt_target *target,
-       const void *targinfo,
-       void *userinfo)
+       const void *targinfo)
 {
 	/* Previously seen (loopback)? Ignore. */
 	if ((*pskb)->nfct != NULL)
diff --git a/net/netfilter/xt_SECMARK.c b/net/netfilter/xt_SECMARK.c
index 4300988..8a04dcf 100644
--- a/net/netfilter/xt_SECMARK.c
+++ b/net/netfilter/xt_SECMARK.c
@@ -31,7 +31,7 @@ static u8 mode;
 static unsigned int target(struct sk_buff **pskb, const struct net_device *in,
 			   const struct net_device *out, unsigned int hooknum,
 			   const struct xt_target *target,
-			   const void *targinfo, void *userinfo)
+			   const void *targinfo)
 {
 	u32 secmark = 0;
 	const struct xt_secmark_target_info *info = targinfo;
diff --git a/net/netfilter/xt_connbytes.c b/net/netfilter/xt_connbytes.c
index 2d49948..d725e8b 100644
--- a/net/netfilter/xt_connbytes.c
+++ b/net/netfilter/xt_connbytes.c
@@ -143,7 +143,7 @@ static int check(const char *tablename,
 	return 1;
 }
 
-static struct xt_match xt_connbytes_match = {
+static struct xt_match xt_connbytes_match[] = {
 	{
 		.name		= "connbytes",
 		.family		= AF_INET,
diff --git a/net/sched/act_ipt.c b/net/sched/act_ipt.c
index d799e01..1a5f49e 100644
--- a/net/sched/act_ipt.c
+++ b/net/sched/act_ipt.c
@@ -230,8 +230,7 @@ tcf_ipt(struct sk_buff *skb, struct tc_a
 	 * needs to be replaced. We don't own the skb, so this must not
 	 * happen. The pskb_expand_head above should make sure of this */
 	ret = p->t->u.kernel.target->target(&skb, skb->dev, NULL, p->hook,
-					    p->t->u.kernel.target, p->t->data,
-					    NULL);
+					    p->t->u.kernel.target, p->t->data);
 	switch (ret) {
 	case NF_ACCEPT:
 		result = TC_ACT_OK;
