From: Massimiliano Hofer <max@nucleus.it>
Subject: [PATCH] priv_data
Date: Mon, 26 Jun 2006 16:44:03 +0200
Message-ID: <200606261644.04399.max@nucleus.it>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_0K/nEuVxkMBq09Q"
Cc: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

--Boundary-00=_0K/nEuVxkMBq09Q
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,
this is a the bulk of it, but it's just renaming and paramter adjustments.

-- 
Saluti,
   Massimiliano Hofer

--Boundary-00=_0K/nEuVxkMBq09Q
Content-Type: text/x-diff; charset="us-ascii";
	name="02-2.6.17.1-priv_data-matchesandtargets.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="02-2.6.17.1-priv_data-matchesandtargets.patch"

diff -Nru linux-2.6.17.1-priv_data-core/net/ipv4/netfilter/arpt_mangle.c linux-2.6.17.1-priv_data-matchesandtargets/net/ipv4/netfilter/arpt_mangle.c
--- linux-2.6.17.1-priv_data-core/net/ipv4/netfilter/arpt_mangle.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-matchesandtargets/net/ipv4/netfilter/arpt_mangle.c	2006-06-24 02:00:12.000000000 +0200
@@ -11,7 +11,7 @@
 target(struct sk_buff **pskb,
        const struct net_device *in, const struct net_device *out,
        unsigned int hooknum, const struct xt_target *target,
-       const void *targinfo, void *userinfo)
+       const void *targinfo, void *userinfo, void *priv_data)
 {
 	const struct arpt_mangle *mangle = targinfo;
 	struct arphdr *arp;
@@ -66,8 +66,9 @@
 }
 
 static int
-checkentry(const char *tablename, const void *e, const struct xt_target *target,
-           void *targinfo, unsigned int targinfosize, unsigned int hook_mask)
+init(const char *tablename, const void *e, const struct xt_target *target,
+     void *targinfo, unsigned int targinfosize, unsigned int hook_mask,
+     void *priv_data)
 {
 	const struct arpt_mangle *mangle = targinfo;
 
@@ -85,7 +86,7 @@
 	.name		= "mangle",
 	.target		= target,
 	.targetsize	= sizeof(struct arpt_mangle),
-	.checkentry	= checkentry,
+	.init		= init,
 	.me		= THIS_MODULE,
 };
 
diff -Nru linux-2.6.17.1-priv_data-core/net/ipv4/netfilter/ip_nat_rule.c linux-2.6.17.1-priv_data-matchesandtargets/net/ipv4/netfilter/ip_nat_rule.c
--- linux-2.6.17.1-priv_data-core/net/ipv4/netfilter/ip_nat_rule.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-matchesandtargets/net/ipv4/netfilter/ip_nat_rule.c	2006-06-24 01:40:09.000000000 +0200
@@ -105,7 +105,8 @@
 				    unsigned int hooknum,
 				    const struct ipt_target *target,
 				    const void *targinfo,
-				    void *userinfo)
+				    void *userinfo,
+				    void *priv_data)
 {
 	struct ip_conntrack *ct;
 	enum ip_conntrack_info ctinfo;
@@ -148,7 +149,8 @@
 				    unsigned int hooknum,
 				    const struct ipt_target *target,
 				    const void *targinfo,
-				    void *userinfo)
+				    void *userinfo,
+				    void *priv_data)
 {
 	struct ip_conntrack *ct;
 	enum ip_conntrack_info ctinfo;
@@ -170,12 +172,13 @@
 	return ip_nat_setup_info(ct, &mr->range[0], hooknum);
 }
 
-static int ipt_snat_checkentry(const char *tablename,
-			       const void *entry,
-			       const struct ipt_target *target,
-			       void *targinfo,
-			       unsigned int targinfosize,
-			       unsigned int hook_mask)
+static int ipt_snat_init(const char *tablename,
+			 const void *entry,
+			 const struct ipt_target *target,
+			 void *targinfo,
+			 unsigned int targinfosize,
+			 unsigned int hook_mask,
+			 void *priv_data)
 {
 	struct ip_nat_multi_range_compat *mr = targinfo;
 
@@ -187,12 +190,13 @@
 	return 1;
 }
 
-static int ipt_dnat_checkentry(const char *tablename,
-			       const void *entry,
-			       const struct ipt_target *target,
-			       void *targinfo,
-			       unsigned int targinfosize,
-			       unsigned int hook_mask)
+static int ipt_dnat_init(const char *tablename,
+			 const void *entry,
+			 const struct ipt_target *target,
+			 void *targinfo,
+			 unsigned int targinfosize,
+			 unsigned int hook_mask,
+			 void *priv_data)
 {
 	struct ip_nat_multi_range_compat *mr = targinfo;
 
@@ -271,7 +275,7 @@
 	.targetsize	= sizeof(struct ip_nat_multi_range_compat),
 	.table		= "nat",
 	.hooks		= 1 << NF_IP_POST_ROUTING,
-	.checkentry	= ipt_snat_checkentry,
+	.init		= ipt_snat_init,
 };
 
 static struct ipt_target ipt_dnat_reg = {
@@ -280,7 +284,7 @@
 	.targetsize	= sizeof(struct ip_nat_multi_range_compat),
 	.table		= "nat",
 	.hooks		= (1 << NF_IP_PRE_ROUTING) | (1 << NF_IP_LOCAL_OUT),
-	.checkentry	= ipt_dnat_checkentry,
+	.init		= ipt_dnat_init,
 };
 
 int __init ip_nat_rule_init(void)
diff -Nru linux-2.6.17.1-priv_data-core/net/ipv4/netfilter/ipt_addrtype.c linux-2.6.17.1-priv_data-matchesandtargets/net/ipv4/netfilter/ipt_addrtype.c
--- linux-2.6.17.1-priv_data-core/net/ipv4/netfilter/ipt_addrtype.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-matchesandtargets/net/ipv4/netfilter/ipt_addrtype.c	2006-06-20 23:41:21.000000000 +0200
@@ -30,7 +30,8 @@
 static int match(const struct sk_buff *skb,
 		 const struct net_device *in, const struct net_device *out,
 		 const struct xt_match *match, const void *matchinfo,
-		 int offset, unsigned int protoff, int *hotdrop)
+		 int offset, unsigned int protoff, int *hotdrop,
+		 void *priv_data)
 {
 	const struct ipt_addrtype_info *info = matchinfo;
 	const struct iphdr *iph = skb->nh.iph;
diff -Nru linux-2.6.17.1-priv_data-core/net/ipv4/netfilter/ipt_ah.c linux-2.6.17.1-priv_data-matchesandtargets/net/ipv4/netfilter/ipt_ah.c
--- linux-2.6.17.1-priv_data-core/net/ipv4/netfilter/ipt_ah.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-matchesandtargets/net/ipv4/netfilter/ipt_ah.c	2006-06-22 02:04:29.000000000 +0200
@@ -43,7 +43,8 @@
       const void *matchinfo,
       int offset,
       unsigned int protoff,
-      int *hotdrop)
+      int *hotdrop,
+      void *priv_data)
 {
 	struct ip_auth_hdr _ahdr, *ah;
 	const struct ipt_ah *ahinfo = matchinfo;
@@ -70,12 +71,13 @@
 
 /* Called when user tries to insert an entry of this type. */
 static int
-checkentry(const char *tablename,
-	   const void *ip_void,
-	   const struct xt_match *match,
-	   void *matchinfo,
-	   unsigned int matchinfosize,
-	   unsigned int hook_mask)
+init(const char *tablename,
+     const void *ip_void,
+     const struct xt_match *match,
+     void *matchinfo,
+     unsigned int matchinfosize,
+     unsigned int hook_mask,
+     void *priv_data)
 {
 	const struct ipt_ah *ahinfo = matchinfo;
 
@@ -92,7 +94,7 @@
 	.match		= match,
 	.matchsize	= sizeof(struct ipt_ah),
 	.proto		= IPPROTO_AH,
-	.checkentry	= checkentry,
+	.init		= init,
 	.me		= THIS_MODULE,
 };
 
diff -Nru linux-2.6.17.1-priv_data-core/net/ipv4/netfilter/ipt_CLUSTERIP.c linux-2.6.17.1-priv_data-matchesandtargets/net/ipv4/netfilter/ipt_CLUSTERIP.c
--- linux-2.6.17.1-priv_data-core/net/ipv4/netfilter/ipt_CLUSTERIP.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-matchesandtargets/net/ipv4/netfilter/ipt_CLUSTERIP.c	2006-06-24 01:09:44.000000000 +0200
@@ -313,7 +313,8 @@
        unsigned int hooknum,
        const struct xt_target *target,
        const void *targinfo,
-       void *userinfo)
+       void *userinfo,
+       void *priv_data)
 {
 	const struct ipt_clusterip_tgt_info *cipinfo = targinfo;
 	enum ip_conntrack_info ctinfo;
@@ -379,12 +380,13 @@
 }
 
 static int
-checkentry(const char *tablename,
-	   const void *e_void,
-	   const struct xt_target *target,
-           void *targinfo,
-           unsigned int targinfosize,
-           unsigned int hook_mask)
+init(const char *tablename,
+     const void *e_void,
+     const struct xt_target *target,
+     void *targinfo,
+     unsigned int targinfosize,
+     unsigned int hook_mask,
+     void *priv_data)
 {
 	struct ipt_clusterip_tgt_info *cipinfo = targinfo;
 	const struct ipt_entry *e = e_void;
@@ -461,7 +463,7 @@
 
 /* drop reference count of cluster config when rule is deleted */
 static void destroy(const struct xt_target *target, void *targinfo,
-		    unsigned int targinfosize)
+		    unsigned int targinfosize, void *priv_data)
 {
 	struct ipt_clusterip_tgt_info *cipinfo = targinfo;
 
@@ -476,7 +478,7 @@
 	.name		= "CLUSTERIP",
 	.target		= target,
 	.targetsize	= sizeof(struct ipt_clusterip_tgt_info),
-	.checkentry	= checkentry,
+	.init		= init,
 	.destroy	= destroy,
 	.me		= THIS_MODULE
 };
diff -Nru linux-2.6.17.1-priv_data-core/net/ipv4/netfilter/ipt_dscp.c linux-2.6.17.1-priv_data-matchesandtargets/net/ipv4/netfilter/ipt_dscp.c
--- linux-2.6.17.1-priv_data-core/net/ipv4/netfilter/ipt_dscp.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-matchesandtargets/net/ipv4/netfilter/ipt_dscp.c	2006-06-20 23:41:21.000000000 +0200
@@ -22,7 +22,8 @@
 static int match(const struct sk_buff *skb,
 		 const struct net_device *in, const struct net_device *out,
 		 const struct xt_match *match, const void *matchinfo,
-		 int offset, unsigned int protoff, int *hotdrop)
+		 int offset, unsigned int protoff, int *hotdrop,
+		 void *priv_data)
 {
 	const struct ipt_dscp_info *info = matchinfo;
 	const struct iphdr *iph = skb->nh.iph;
diff -Nru linux-2.6.17.1-priv_data-core/net/ipv4/netfilter/ipt_DSCP.c linux-2.6.17.1-priv_data-matchesandtargets/net/ipv4/netfilter/ipt_DSCP.c
--- linux-2.6.17.1-priv_data-core/net/ipv4/netfilter/ipt_DSCP.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-matchesandtargets/net/ipv4/netfilter/ipt_DSCP.c	2006-06-24 01:10:34.000000000 +0200
@@ -31,7 +31,8 @@
        unsigned int hooknum,
        const struct xt_target *target,
        const void *targinfo,
-       void *userinfo)
+       void *userinfo,
+       void *priv_data)
 {
 	const struct ipt_DSCP_info *dinfo = targinfo;
 	u_int8_t sh_dscp = ((dinfo->dscp << IPT_DSCP_SHIFT) & IPT_DSCP_MASK);
@@ -57,12 +58,13 @@
 }
 
 static int
-checkentry(const char *tablename,
-	   const void *e_void,
-	   const struct xt_target *target,
-           void *targinfo,
-           unsigned int targinfosize,
-           unsigned int hook_mask)
+init(const char *tablename,
+     const void *e_void,
+     const struct xt_target *target,
+     void *targinfo,
+     unsigned int targinfosize,
+     unsigned int hook_mask,
+     void *priv_data)
 {
 	const u_int8_t dscp = ((struct ipt_DSCP_info *)targinfo)->dscp;
 
@@ -78,7 +80,7 @@
 	.target		= target,
 	.targetsize	= sizeof(struct ipt_DSCP_info),
 	.table		= "mangle",
-	.checkentry	= checkentry,
+	.init		= init,
 	.me		= THIS_MODULE,
 };
 
diff -Nru linux-2.6.17.1-priv_data-core/net/ipv4/netfilter/ipt_ecn.c linux-2.6.17.1-priv_data-matchesandtargets/net/ipv4/netfilter/ipt_ecn.c
--- linux-2.6.17.1-priv_data-core/net/ipv4/netfilter/ipt_ecn.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-matchesandtargets/net/ipv4/netfilter/ipt_ecn.c	2006-06-22 02:05:14.000000000 +0200
@@ -68,7 +68,8 @@
 static int match(const struct sk_buff *skb,
 		 const struct net_device *in, const struct net_device *out,
 		 const struct xt_match *match, const void *matchinfo,
-		 int offset, unsigned int protoff, int *hotdrop)
+		 int offset, unsigned int protoff, int *hotdrop,
+		 void *priv_data)
 {
 	const struct ipt_ecn_info *info = matchinfo;
 
@@ -86,10 +87,10 @@
 	return 1;
 }
 
-static int checkentry(const char *tablename, const void *ip_void,
-		      const struct xt_match *match,
-		      void *matchinfo, unsigned int matchsize,
-		      unsigned int hook_mask)
+static int init(const char *tablename, const void *ip_void,
+		const struct xt_match *match,
+		void *matchinfo, unsigned int matchsize,
+		unsigned int hook_mask, void *priv_data)
 {
 	const struct ipt_ecn_info *info = matchinfo;
 	const struct ipt_ip *ip = ip_void;
@@ -114,7 +115,7 @@
 	.name		= "ecn",
 	.match		= match,
 	.matchsize	= sizeof(struct ipt_ecn_info),
-	.checkentry	= checkentry,
+	.init		= init,
 	.me		= THIS_MODULE,
 };
 
diff -Nru linux-2.6.17.1-priv_data-core/net/ipv4/netfilter/ipt_ECN.c linux-2.6.17.1-priv_data-matchesandtargets/net/ipv4/netfilter/ipt_ECN.c
--- linux-2.6.17.1-priv_data-core/net/ipv4/netfilter/ipt_ECN.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-matchesandtargets/net/ipv4/netfilter/ipt_ECN.c	2006-06-24 01:51:05.000000000 +0200
@@ -96,7 +96,8 @@
        unsigned int hooknum,
        const struct xt_target *target,
        const void *targinfo,
-       void *userinfo)
+       void *userinfo,
+       void *priv_data)
 {
 	const struct ipt_ECN_info *einfo = targinfo;
 
@@ -113,12 +114,13 @@
 }
 
 static int
-checkentry(const char *tablename,
-	   const void *e_void,
-	   const struct xt_target *target,
-           void *targinfo,
-           unsigned int targinfosize,
-           unsigned int hook_mask)
+init(const char *tablename,
+     const void *e_void,
+     const struct xt_target *target,
+     void *targinfo,
+     unsigned int targinfosize,
+     unsigned int hook_mask,
+     void *priv_data)
 {
 	const struct ipt_ECN_info *einfo = (struct ipt_ECN_info *)targinfo;
 	const struct ipt_entry *e = e_void;
@@ -147,7 +149,7 @@
 	.target		= target,
 	.targetsize	= sizeof(struct ipt_ECN_info),
 	.table		= "mangle",
-	.checkentry	= checkentry,
+	.init		= init,
 	.me		= THIS_MODULE,
 };
 
diff -Nru linux-2.6.17.1-priv_data-core/net/ipv4/netfilter/ipt_hashlimit.c linux-2.6.17.1-priv_data-matchesandtargets/net/ipv4/netfilter/ipt_hashlimit.c
--- linux-2.6.17.1-priv_data-core/net/ipv4/netfilter/ipt_hashlimit.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-matchesandtargets/net/ipv4/netfilter/ipt_hashlimit.c	2006-06-22 02:08:40.000000000 +0200
@@ -93,7 +93,7 @@
 };
 
 static DEFINE_SPINLOCK(hashlimit_lock);	/* protects htables list */
-static DEFINE_MUTEX(hlimit_mutex);	/* additional checkentry protection */
+static DEFINE_MUTEX(hlimit_mutex);	/* additional init protection */
 static HLIST_HEAD(hashlimit_htables);
 static kmem_cache_t *hashlimit_cachep __read_mostly;
 
@@ -432,7 +432,8 @@
 		const void *matchinfo,
 		int offset,
 		unsigned int protoff,
-		int *hotdrop)
+		int *hotdrop,
+		void *priv_data)
 {
 	struct ipt_hashlimit_info *r = 
 		((struct ipt_hashlimit_info *)matchinfo)->u.master;
@@ -506,12 +507,13 @@
 }
 
 static int
-hashlimit_checkentry(const char *tablename,
-		     const void *inf,
-		     const struct xt_match *match,
-		     void *matchinfo,
-		     unsigned int matchsize,
-		     unsigned int hook_mask)
+hashlimit_init(const char *tablename,
+	       const void *inf,
+	       const struct xt_match *match,
+	       void *matchinfo,
+	       unsigned int matchsize,
+	       unsigned int hook_mask,
+	       void *priv_data)
 {
 	struct ipt_hashlimit_info *r = matchinfo;
 
@@ -538,7 +540,7 @@
 		return 0;
 
 	/* This is the best we've got: We cannot release and re-grab lock,
-	 * since checkentry() is called before ip_tables.c grabs ipt_mutex.  
+	 * since init() is called before ip_tables.c grabs ipt_mutex.
 	 * We also cannot grab the hashtable spinlock, since htable_create will 
 	 * call vmalloc, and that can sleep.  And we cannot just re-search
 	 * the list of htable's in htable_create(), since then we would
@@ -559,7 +561,7 @@
 
 static void
 hashlimit_destroy(const struct xt_match *match, void *matchinfo,
-		  unsigned int matchsize)
+		  unsigned int matchsize, void *priv_data)
 {
 	struct ipt_hashlimit_info *r = (struct ipt_hashlimit_info *) matchinfo;
 
@@ -570,7 +572,7 @@
 	.name		= "hashlimit",
 	.match		= hashlimit_match,
 	.matchsize	= sizeof(struct ipt_hashlimit_info),
-	.checkentry	= hashlimit_checkentry,
+	.init		= hashlimit_init,
 	.destroy	= hashlimit_destroy,
 	.me		= THIS_MODULE
 };
diff -Nru linux-2.6.17.1-priv_data-core/net/ipv4/netfilter/ipt_iprange.c linux-2.6.17.1-priv_data-matchesandtargets/net/ipv4/netfilter/ipt_iprange.c
--- linux-2.6.17.1-priv_data-core/net/ipv4/netfilter/ipt_iprange.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-matchesandtargets/net/ipv4/netfilter/ipt_iprange.c	2006-06-20 23:41:21.000000000 +0200
@@ -29,7 +29,7 @@
       const struct net_device *out,
       const struct xt_match *match,
       const void *matchinfo,
-      int offset, unsigned int protoff, int *hotdrop)
+      int offset, unsigned int protoff, int *hotdrop, void *priv_data)
 {
 	const struct ipt_iprange_info *info = matchinfo;
 	const struct iphdr *iph = skb->nh.iph;
diff -Nru linux-2.6.17.1-priv_data-core/net/ipv4/netfilter/ipt_LOG.c linux-2.6.17.1-priv_data-matchesandtargets/net/ipv4/netfilter/ipt_LOG.c
--- linux-2.6.17.1-priv_data-core/net/ipv4/netfilter/ipt_LOG.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-matchesandtargets/net/ipv4/netfilter/ipt_LOG.c	2006-06-24 01:52:53.000000000 +0200
@@ -411,13 +411,14 @@
 }
 
 static unsigned int
-ipt_log_target(struct sk_buff **pskb,
-	       const struct net_device *in,
-	       const struct net_device *out,
-	       unsigned int hooknum,
-	       const struct xt_target *target,
-	       const void *targinfo,
-	       void *userinfo)
+log_target(struct sk_buff **pskb,
+	   const struct net_device *in,
+	   const struct net_device *out,
+	   unsigned int hooknum,
+	   const struct xt_target *target,
+	   const void *targinfo,
+	   void *userinfo,
+	   void *priv_data)
 {
 	const struct ipt_log_info *loginfo = targinfo;
 	struct nf_loginfo li;
@@ -436,12 +437,13 @@
 	return IPT_CONTINUE;
 }
 
-static int ipt_log_checkentry(const char *tablename,
-			      const void *e,
-			      const struct xt_target *target,
-			      void *targinfo,
-			      unsigned int targinfosize,
-			      unsigned int hook_mask)
+static int log_init(const char *tablename,
+		    const void *e,
+		    const struct xt_target *target,
+		    void *targinfo,
+		    unsigned int targinfosize,
+		    unsigned int hook_mask,
+		    void *priv_data)
 {
 	const struct ipt_log_info *loginfo = targinfo;
 
@@ -459,9 +461,9 @@
 
 static struct ipt_target ipt_log_reg = {
 	.name		= "LOG",
-	.target		= ipt_log_target,
+	.target		= log_target,
 	.targetsize	= sizeof(struct ipt_log_info),
-	.checkentry	= ipt_log_checkentry,
+	.init		= log_init,
 	.me		= THIS_MODULE,
 };
 
diff -Nru linux-2.6.17.1-priv_data-core/net/ipv4/netfilter/ipt_MASQUERADE.c linux-2.6.17.1-priv_data-matchesandtargets/net/ipv4/netfilter/ipt_MASQUERADE.c
--- linux-2.6.17.1-priv_data-core/net/ipv4/netfilter/ipt_MASQUERADE.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-matchesandtargets/net/ipv4/netfilter/ipt_MASQUERADE.c	2006-06-24 01:13:00.000000000 +0200
@@ -39,12 +39,13 @@
 
 /* FIXME: Multiple targets. --RR */
 static int
-masquerade_check(const char *tablename,
-		 const void *e,
-		 const struct xt_target *target,
-		 void *targinfo,
-		 unsigned int targinfosize,
-		 unsigned int hook_mask)
+masquerade_init(const char *tablename,
+		const void *e,
+		const struct xt_target *target,
+		void *targinfo,
+		unsigned int targinfosize,
+		unsigned int hook_mask,
+		void *priv_data)
 {
 	const struct ip_nat_multi_range_compat *mr = targinfo;
 
@@ -66,7 +67,8 @@
 		  unsigned int hooknum,
 		  const struct xt_target *target,
 		  const void *targinfo,
-		  void *userinfo)
+		  void *userinfo,
+		  void *priv_data)
 {
 	struct ip_conntrack *ct;
 	enum ip_conntrack_info ctinfo;
@@ -171,7 +173,7 @@
 	.targetsize	= sizeof(struct ip_nat_multi_range_compat),
 	.table		= "nat",
 	.hooks		= 1 << NF_IP_POST_ROUTING,
-	.checkentry	= masquerade_check,
+	.init		= masquerade_init,
 	.me		= THIS_MODULE,
 };
 
diff -Nru linux-2.6.17.1-priv_data-core/net/ipv4/netfilter/ipt_NETMAP.c linux-2.6.17.1-priv_data-matchesandtargets/net/ipv4/netfilter/ipt_NETMAP.c
--- linux-2.6.17.1-priv_data-core/net/ipv4/netfilter/ipt_NETMAP.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-matchesandtargets/net/ipv4/netfilter/ipt_NETMAP.c	2006-06-24 01:13:43.000000000 +0200
@@ -30,12 +30,13 @@
 #endif
 
 static int
-check(const char *tablename,
+init(const char *tablename,
       const void *e,
       const struct xt_target *target,
       void *targinfo,
       unsigned int targinfosize,
-      unsigned int hook_mask)
+      unsigned int hook_mask,
+      void *priv_data)
 {
 	const struct ip_nat_multi_range_compat *mr = targinfo;
 
@@ -57,7 +58,8 @@
        unsigned int hooknum,
        const struct xt_target *target,
        const void *targinfo,
-       void *userinfo)
+       void *userinfo,
+       void *priv_data)
 {
 	struct ip_conntrack *ct;
 	enum ip_conntrack_info ctinfo;
@@ -94,7 +96,7 @@
 	.table		= "nat",
 	.hooks		= (1 << NF_IP_PRE_ROUTING) | (1 << NF_IP_POST_ROUTING) |
 			  (1 << NF_IP_LOCAL_OUT),
-	.checkentry 	= check,
+	.init		= init,
     	.me 		= THIS_MODULE 
 };
 
diff -Nru linux-2.6.17.1-priv_data-core/net/ipv4/netfilter/ipt_owner.c linux-2.6.17.1-priv_data-matchesandtargets/net/ipv4/netfilter/ipt_owner.c
--- linux-2.6.17.1-priv_data-core/net/ipv4/netfilter/ipt_owner.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-matchesandtargets/net/ipv4/netfilter/ipt_owner.c	2006-06-22 02:07:07.000000000 +0200
@@ -29,7 +29,8 @@
       const void *matchinfo,
       int offset,
       unsigned int protoff,
-      int *hotdrop)
+      int *hotdrop,
+      void *priv_data)
 {
 	const struct ipt_owner_info *info = matchinfo;
 
@@ -52,12 +53,13 @@
 }
 
 static int
-checkentry(const char *tablename,
-           const void *ip,
-	   const struct xt_match *match,
-           void *matchinfo,
-           unsigned int matchsize,
-           unsigned int hook_mask)
+init(const char *tablename,
+     const void *ip,
+     const struct xt_match *match,
+     void *matchinfo,
+     unsigned int matchsize,
+     unsigned int hook_mask,
+     void *priv_data)
 {
 	const struct ipt_owner_info *info = matchinfo;
 
@@ -74,7 +76,7 @@
 	.match		= match,
 	.matchsize	= sizeof(struct ipt_owner_info),
 	.hooks		= (1 << NF_IP_LOCAL_OUT) | (1 << NF_IP_POST_ROUTING),
-	.checkentry	= checkentry,
+	.init		= init,
 	.me		= THIS_MODULE,
 };
 
diff -Nru linux-2.6.17.1-priv_data-core/net/ipv4/netfilter/ipt_recent.c linux-2.6.17.1-priv_data-matchesandtargets/net/ipv4/netfilter/ipt_recent.c
--- linux-2.6.17.1-priv_data-core/net/ipv4/netfilter/ipt_recent.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-matchesandtargets/net/ipv4/netfilter/ipt_recent.c	2006-06-22 02:06:32.000000000 +0200
@@ -106,7 +106,8 @@
       const void *matchinfo,
       int offset,
       unsigned int protoff,
-      int *hotdrop);
+      int *hotdrop,
+      void *priv_data);
 
 /* Function to hash a given address into the hash table of table_size size */
 static int hash_func(unsigned int addr, int table_size)
@@ -319,7 +320,7 @@
 	skb->nh.iph->daddr = 0;
 	/* Clear ttl since we have no way of knowing it */
 	skb->nh.iph->ttl = 0;
-	match(skb,NULL,NULL,NULL,info,0,0,NULL);
+	match(skb,NULL,NULL,NULL,info,0,0,NULL,NULL);
 
 	kfree(skb->nh.iph);
 out_free_skb:
@@ -361,7 +362,8 @@
       const void *matchinfo,
       int offset,
       unsigned int protoff,
-      int *hotdrop)
+      int *hotdrop,
+      void *priv_data)
 {
 	int pkt_count, hits_found, ans;
 	unsigned long now;
@@ -657,12 +659,13 @@
  * rule exists, if not it is created.
  */
 static int
-checkentry(const char *tablename,
-           const void *ip,
-	   const struct xt_match *match,
-           void *matchinfo,
-           unsigned int matchsize,
-           unsigned int hook_mask)
+init(const char *tablename,
+     const void *ip,
+     const struct xt_match *match,
+     void *matchinfo,
+     unsigned int matchsize,
+     unsigned int hook_mask,
+     void *priv_data)
 {
 	int flag = 0, c;
 	unsigned long *hold;
@@ -872,7 +875,8 @@
  * up its memory.
  */
 static void
-destroy(const struct xt_match *match, void *matchinfo, unsigned int matchsize)
+destroy(const struct xt_match *match, void *matchinfo,
+	unsigned int matchsize, void *priv_data)
 {
 	const struct ipt_recent_info *info = matchinfo;
 	struct recent_ip_tables *curr_table, *last_table;
@@ -956,7 +960,7 @@
 	.name		= "recent",
 	.match		= match,
 	.matchsize	= sizeof(struct ipt_recent_info),
-	.checkentry	= checkentry,
+	.init		= init,
 	.destroy	= destroy,
 	.me		= THIS_MODULE
 };
diff -Nru linux-2.6.17.1-priv_data-core/net/ipv4/netfilter/ipt_REDIRECT.c linux-2.6.17.1-priv_data-matchesandtargets/net/ipv4/netfilter/ipt_REDIRECT.c
--- linux-2.6.17.1-priv_data-core/net/ipv4/netfilter/ipt_REDIRECT.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-matchesandtargets/net/ipv4/netfilter/ipt_REDIRECT.c	2006-06-24 01:14:25.000000000 +0200
@@ -32,12 +32,13 @@
 
 /* FIXME: Take multiple ranges --RR */
 static int
-redirect_check(const char *tablename,
+redirect_init(const char *tablename,
 	       const void *e,
 	       const struct xt_target *target,
 	       void *targinfo,
 	       unsigned int targinfosize,
-	       unsigned int hook_mask)
+	       unsigned int hook_mask,
+	       void *priv_data)
 {
 	const struct ip_nat_multi_range_compat *mr = targinfo;
 
@@ -59,7 +60,8 @@
 		unsigned int hooknum,
 		const struct xt_target *target,
 		const void *targinfo,
-		void *userinfo)
+		void *userinfo,
+		void *priv_data)
 {
 	struct ip_conntrack *ct;
 	enum ip_conntrack_info ctinfo;
@@ -108,7 +110,7 @@
 	.targetsize	= sizeof(struct ip_nat_multi_range_compat),
 	.table		= "nat",
 	.hooks		= (1 << NF_IP_PRE_ROUTING) | (1 << NF_IP_LOCAL_OUT),
-	.checkentry	= redirect_check,
+	.init		= redirect_init,
 	.me		= THIS_MODULE,
 };
 
diff -Nru linux-2.6.17.1-priv_data-core/net/ipv4/netfilter/ipt_REJECT.c linux-2.6.17.1-priv_data-matchesandtargets/net/ipv4/netfilter/ipt_REJECT.c
--- linux-2.6.17.1-priv_data-core/net/ipv4/netfilter/ipt_REJECT.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-matchesandtargets/net/ipv4/netfilter/ipt_REJECT.c	2006-06-24 01:15:23.000000000 +0200
@@ -227,7 +227,8 @@
 			   unsigned int hooknum,
 			   const struct xt_target *target,
 			   const void *targinfo,
-			   void *userinfo)
+			   void *userinfo,
+			   void *priv_data)
 {
 	const struct ipt_reject_info *reject = targinfo;
 
@@ -271,12 +272,13 @@
 	return NF_DROP;
 }
 
-static int check(const char *tablename,
-		 const void *e_void,
-		 const struct xt_target *target,
-		 void *targinfo,
-		 unsigned int targinfosize,
-		 unsigned int hook_mask)
+static int init(const char *tablename,
+		const void *e_void,
+		const struct xt_target *target,
+		void *targinfo,
+		unsigned int targinfosize,
+		unsigned int hook_mask,
+		void *priv_data)
 {
  	const struct ipt_reject_info *rejinfo = targinfo;
 	const struct ipt_entry *e = e_void;
@@ -302,7 +304,7 @@
 	.table		= "filter",
 	.hooks		= (1 << NF_IP_LOCAL_IN) | (1 << NF_IP_FORWARD) |
 			  (1 << NF_IP_LOCAL_OUT),
-	.checkentry	= check,
+	.init		= init,
 	.me		= THIS_MODULE,
 };
 
diff -Nru linux-2.6.17.1-priv_data-core/net/ipv4/netfilter/ipt_SAME.c linux-2.6.17.1-priv_data-matchesandtargets/net/ipv4/netfilter/ipt_SAME.c
--- linux-2.6.17.1-priv_data-core/net/ipv4/netfilter/ipt_SAME.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-matchesandtargets/net/ipv4/netfilter/ipt_SAME.c	2006-06-24 01:16:20.000000000 +0200
@@ -48,12 +48,13 @@
 #endif
 
 static int
-same_check(const char *tablename,
-	      const void *e,
-	      const struct xt_target *target,
-	      void *targinfo,
-	      unsigned int targinfosize,
-	      unsigned int hook_mask)
+same_init(const char *tablename,
+	  const void *e,
+	  const struct xt_target *target,
+	  void *targinfo,
+	  unsigned int targinfosize,
+	  unsigned int hook_mask,
+	  void *priv_data)
 {
 	unsigned int count, countess, rangeip, index = 0;
 	struct ipt_same_info *mr = targinfo;
@@ -117,7 +118,7 @@
 
 static void 
 same_destroy(const struct xt_target *target, void *targinfo,
-		unsigned int targinfosize)
+		unsigned int targinfosize, void *priv_data)
 {
 	struct ipt_same_info *mr = targinfo;
 
@@ -134,7 +135,8 @@
 		unsigned int hooknum,
 		const struct xt_target *target,
 		const void *targinfo,
-		void *userinfo)
+		void *userinfo,
+		void *priv_data)
 {
 	struct ip_conntrack *ct;
 	enum ip_conntrack_info ctinfo;
@@ -184,7 +186,7 @@
 	.targetsize	= sizeof(struct ipt_same_info),
 	.table		= "nat",
 	.hooks		= (1 << NF_IP_PRE_ROUTING | 1 << NF_IP_POST_ROUTING),
-	.checkentry	= same_check,
+	.init		= same_init,
 	.destroy	= same_destroy,
 	.me		= THIS_MODULE,
 };
diff -Nru linux-2.6.17.1-priv_data-core/net/ipv4/netfilter/ipt_TCPMSS.c linux-2.6.17.1-priv_data-matchesandtargets/net/ipv4/netfilter/ipt_TCPMSS.c
--- linux-2.6.17.1-priv_data-core/net/ipv4/netfilter/ipt_TCPMSS.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-matchesandtargets/net/ipv4/netfilter/ipt_TCPMSS.c	2006-06-24 01:19:40.000000000 +0200
@@ -44,13 +44,14 @@
 }
 
 static unsigned int
-ipt_tcpmss_target(struct sk_buff **pskb,
-		  const struct net_device *in,
-		  const struct net_device *out,
-		  unsigned int hooknum,
-		  const struct xt_target *target,
-		  const void *targinfo,
-		  void *userinfo)
+tcpmss_target(struct sk_buff **pskb,
+	      const struct net_device *in,
+	      const struct net_device *out,
+	      unsigned int hooknum,
+	      const struct xt_target *target,
+	      const void *targinfo,
+	      void *userinfo,
+	      void *priv_data)
 {
 	const struct ipt_tcpmss_info *tcpmssinfo = targinfo;
 	struct tcphdr *tcph;
@@ -210,12 +211,13 @@
 
 /* Must specify -p tcp --syn/--tcp-flags SYN */
 static int
-ipt_tcpmss_checkentry(const char *tablename,
-		      const void *e_void,
-		      const struct xt_target *target,
-		      void *targinfo,
-		      unsigned int targinfosize,
-		      unsigned int hook_mask)
+tcpmss_init(const char *tablename,
+	    const void *e_void,
+	    const struct xt_target *target,
+	    void *targinfo,
+	    unsigned int targinfosize,
+	    unsigned int hook_mask,
+	    void *priv_data)
 {
 	const struct ipt_tcpmss_info *tcpmssinfo = targinfo;
 	const struct ipt_entry *e = e_void;
@@ -236,10 +238,10 @@
 
 static struct ipt_target ipt_tcpmss_reg = {
 	.name		= "TCPMSS",
-	.target		= ipt_tcpmss_target,
+	.target		= tcpmss_target,
 	.targetsize	= sizeof(struct ipt_tcpmss_info),
 	.proto		= IPPROTO_TCP,
-	.checkentry	= ipt_tcpmss_checkentry,
+	.init		= tcpmss_init,
 	.me		= THIS_MODULE,
 };
 
diff -Nru linux-2.6.17.1-priv_data-core/net/ipv4/netfilter/ipt_tos.c linux-2.6.17.1-priv_data-matchesandtargets/net/ipv4/netfilter/ipt_tos.c
--- linux-2.6.17.1-priv_data-core/net/ipv4/netfilter/ipt_tos.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-matchesandtargets/net/ipv4/netfilter/ipt_tos.c	2006-06-20 23:41:21.000000000 +0200
@@ -25,7 +25,8 @@
       const void *matchinfo,
       int offset,
       unsigned int protoff,
-      int *hotdrop)
+      int *hotdrop,
+      void *priv_data)
 {
 	const struct ipt_tos_info *info = matchinfo;
 
diff -Nru linux-2.6.17.1-priv_data-core/net/ipv4/netfilter/ipt_TOS.c linux-2.6.17.1-priv_data-matchesandtargets/net/ipv4/netfilter/ipt_TOS.c
--- linux-2.6.17.1-priv_data-core/net/ipv4/netfilter/ipt_TOS.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-matchesandtargets/net/ipv4/netfilter/ipt_TOS.c	2006-06-24 01:20:20.000000000 +0200
@@ -27,7 +27,8 @@
        unsigned int hooknum,
        const struct xt_target *target,
        const void *targinfo,
-       void *userinfo)
+       void *userinfo,
+       void *priv_data)
 {
 	const struct ipt_tos_target_info *tosinfo = targinfo;
 
@@ -52,12 +53,13 @@
 }
 
 static int
-checkentry(const char *tablename,
-	   const void *e_void,
-	   const struct xt_target *target,
-           void *targinfo,
-           unsigned int targinfosize,
-           unsigned int hook_mask)
+init(const char *tablename,
+     const void *e_void,
+     const struct xt_target *target,
+     void *targinfo,
+     unsigned int targinfosize,
+     unsigned int hook_mask,
+     void *priv_data)
 {
 	const u_int8_t tos = ((struct ipt_tos_target_info *)targinfo)->tos;
 
@@ -77,7 +79,7 @@
 	.target		= target,
 	.targetsize	= sizeof(struct ipt_tos_target_info),
 	.table		= "mangle",
-	.checkentry	= checkentry,
+	.init		= init,
 	.me		= THIS_MODULE,
 };
 
diff -Nru linux-2.6.17.1-priv_data-core/net/ipv4/netfilter/ipt_ttl.c linux-2.6.17.1-priv_data-matchesandtargets/net/ipv4/netfilter/ipt_ttl.c
--- linux-2.6.17.1-priv_data-core/net/ipv4/netfilter/ipt_ttl.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-matchesandtargets/net/ipv4/netfilter/ipt_ttl.c	2006-06-20 23:41:21.000000000 +0200
@@ -22,7 +22,8 @@
 static int match(const struct sk_buff *skb,
 		 const struct net_device *in, const struct net_device *out,
 		 const struct xt_match *match, const void *matchinfo,
-		 int offset, unsigned int protoff, int *hotdrop)
+		 int offset, unsigned int protoff, int *hotdrop,
+		 void *priv_data)
 {
 	const struct ipt_ttl_info *info = matchinfo;
 
diff -Nru linux-2.6.17.1-priv_data-core/net/ipv4/netfilter/ipt_TTL.c linux-2.6.17.1-priv_data-matchesandtargets/net/ipv4/netfilter/ipt_TTL.c
--- linux-2.6.17.1-priv_data-core/net/ipv4/netfilter/ipt_TTL.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-matchesandtargets/net/ipv4/netfilter/ipt_TTL.c	2006-06-24 01:53:41.000000000 +0200
@@ -20,10 +20,10 @@
 MODULE_LICENSE("GPL");
 
 static unsigned int 
-ipt_ttl_target(struct sk_buff **pskb,
-	       const struct net_device *in, const struct net_device *out,
-	       unsigned int hooknum, const struct xt_target *target,
-	       const void *targinfo, void *userinfo)
+ttl_target(struct sk_buff **pskb,
+	   const struct net_device *in, const struct net_device *out,
+	   unsigned int hooknum, const struct xt_target *target,
+	   const void *targinfo, void *userinfo, void *priv_data)
 {
 	struct iphdr *iph;
 	const struct ipt_TTL_info *info = targinfo;
@@ -66,12 +66,13 @@
 	return IPT_CONTINUE;
 }
 
-static int ipt_ttl_checkentry(const char *tablename,
+static int ttl_init(const char *tablename,
 		const void *e,
 		const struct xt_target *target,
 		void *targinfo,
 		unsigned int targinfosize,
-		unsigned int hook_mask)
+		unsigned int hook_mask,
+		void *priv_data)
 {
 	struct ipt_TTL_info *info = targinfo;
 
@@ -87,10 +88,10 @@
 
 static struct ipt_target ipt_TTL = { 
 	.name 		= "TTL",
-	.target 	= ipt_ttl_target, 
+	.target 	= ttl_target,
 	.targetsize	= sizeof(struct ipt_TTL_info),
 	.table		= "mangle",
-	.checkentry 	= ipt_ttl_checkentry, 
+	.init		= ttl_init,
 	.me 		= THIS_MODULE,
 };
 
diff -Nru linux-2.6.17.1-priv_data-core/net/ipv4/netfilter/ipt_ULOG.c linux-2.6.17.1-priv_data-matchesandtargets/net/ipv4/netfilter/ipt_ULOG.c
--- linux-2.6.17.1-priv_data-core/net/ipv4/netfilter/ipt_ULOG.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-matchesandtargets/net/ipv4/netfilter/ipt_ULOG.c	2006-06-24 01:22:42.000000000 +0200
@@ -299,12 +299,13 @@
 	spin_unlock_bh(&ulog_lock);
 }
 
-static unsigned int ipt_ulog_target(struct sk_buff **pskb,
-				    const struct net_device *in,
-				    const struct net_device *out,
-				    unsigned int hooknum,
-				    const struct xt_target *target,
-				    const void *targinfo, void *userinfo)
+static unsigned int ulog_target(struct sk_buff **pskb,
+				const struct net_device *in,
+				const struct net_device *out,
+				unsigned int hooknum,
+				const struct xt_target *target,
+				const void *targinfo, void *userinfo,
+				void *priv_data)
 {
 	struct ipt_ulog_info *loginfo = (struct ipt_ulog_info *) targinfo;
 
@@ -338,12 +339,13 @@
 	ipt_ulog_packet(hooknum, skb, in, out, &loginfo, prefix);
 }
 
-static int ipt_ulog_checkentry(const char *tablename,
-			       const void *e,
-			       const struct xt_target *target,
-			       void *targinfo,
-			       unsigned int targinfosize,
-			       unsigned int hookmask)
+static int ulog_init(const char *tablename,
+		     const void *e,
+		     const struct xt_target *target,
+		     void *targinfo,
+		     unsigned int targinfosize,
+		     unsigned int hookmask,
+		     void *priv_data)
 {
 	struct ipt_ulog_info *loginfo = (struct ipt_ulog_info *) targinfo;
 
@@ -362,9 +364,9 @@
 
 static struct ipt_target ipt_ulog_reg = {
 	.name		= "ULOG",
-	.target		= ipt_ulog_target,
+	.target		= ulog_target,
 	.targetsize	= sizeof(struct ipt_ulog_info),
-	.checkentry	= ipt_ulog_checkentry,
+	.init	= ulog_init,
 	.me		= THIS_MODULE,
 };
 
diff -Nru linux-2.6.17.1-priv_data-core/net/ipv6/netfilter/ip6t_ah.c linux-2.6.17.1-priv_data-matchesandtargets/net/ipv6/netfilter/ip6t_ah.c
--- linux-2.6.17.1-priv_data-core/net/ipv6/netfilter/ip6t_ah.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-matchesandtargets/net/ipv6/netfilter/ip6t_ah.c	2006-06-22 21:56:02.000000000 +0200
@@ -48,7 +48,8 @@
       const void *matchinfo,
       int offset,
       unsigned int protoff,
-      int *hotdrop)
+      int *hotdrop,
+      void *priv_data)
 {
 	struct ip_auth_hdr *ah, _ah;
 	const struct ip6t_ah *ahinfo = matchinfo;
@@ -98,12 +99,13 @@
 
 /* Called when user tries to insert an entry of this type. */
 static int
-checkentry(const char *tablename,
-          const void *entry,
-	  const struct xt_match *match,
-          void *matchinfo,
-          unsigned int matchinfosize,
-          unsigned int hook_mask)
+init(const char *tablename,
+     const void *entry,
+     const struct xt_match *match,
+     void *matchinfo,
+     unsigned int matchinfosize,
+     unsigned int hook_mask,
+     void *priv_data)
 {
 	const struct ip6t_ah *ahinfo = matchinfo;
 
@@ -118,7 +120,7 @@
 	.name		= "ah",
 	.match		= match,
 	.matchsize	= sizeof(struct ip6t_ah),
-	.checkentry	= checkentry,
+	.init		= init,
 	.me		= THIS_MODULE,
 };
 
diff -Nru linux-2.6.17.1-priv_data-core/net/ipv6/netfilter/ip6t_dst.c linux-2.6.17.1-priv_data-matchesandtargets/net/ipv6/netfilter/ip6t_dst.c
--- linux-2.6.17.1-priv_data-core/net/ipv6/netfilter/ip6t_dst.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-matchesandtargets/net/ipv6/netfilter/ip6t_dst.c	2006-06-22 21:56:38.000000000 +0200
@@ -59,7 +59,8 @@
       const void *matchinfo,
       int offset,
       unsigned int protoff,
-      int *hotdrop)
+      int *hotdrop,
+      void *priv_data)
 {
 	struct ipv6_opt_hdr _optsh, *oh;
 	const struct ip6t_opts *optinfo = matchinfo;
@@ -178,12 +179,13 @@
 
 /* Called when user tries to insert an entry of this type. */
 static int
-checkentry(const char *tablename,
-	   const void *info,
-	   const struct xt_match *match,
-	   void *matchinfo,
-	   unsigned int matchinfosize,
-	   unsigned int hook_mask)
+init(const char *tablename,
+     const void *info,
+     const struct xt_match *match,
+     void *matchinfo,
+     unsigned int matchinfosize,
+     unsigned int hook_mask,
+     void *priv_data)
 {
 	const struct ip6t_opts *optsinfo = matchinfo;
 
@@ -202,7 +204,7 @@
 #endif
 	.match		= match,
 	.matchsize	= sizeof(struct ip6t_opts),
-	.checkentry	= checkentry,
+	.init		= init,
 	.me		= THIS_MODULE,
 };
 
diff -Nru linux-2.6.17.1-priv_data-core/net/ipv6/netfilter/ip6t_eui64.c linux-2.6.17.1-priv_data-matchesandtargets/net/ipv6/netfilter/ip6t_eui64.c
--- linux-2.6.17.1-priv_data-core/net/ipv6/netfilter/ip6t_eui64.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-matchesandtargets/net/ipv6/netfilter/ip6t_eui64.c	2006-06-20 23:41:22.000000000 +0200
@@ -26,7 +26,8 @@
       const void *matchinfo,
       int offset,
       unsigned int protoff,
-      int *hotdrop)
+      int *hotdrop,
+      void *priv_data)
 {
 	unsigned char eui64[8];
 	int i = 0;
diff -Nru linux-2.6.17.1-priv_data-core/net/ipv6/netfilter/ip6t_frag.c linux-2.6.17.1-priv_data-matchesandtargets/net/ipv6/netfilter/ip6t_frag.c
--- linux-2.6.17.1-priv_data-core/net/ipv6/netfilter/ip6t_frag.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-matchesandtargets/net/ipv6/netfilter/ip6t_frag.c	2006-06-22 21:57:09.000000000 +0200
@@ -47,7 +47,8 @@
       const void *matchinfo,
       int offset,
       unsigned int protoff,
-      int *hotdrop)
+      int *hotdrop,
+      void *priv_data)
 {
 	struct frag_hdr _frag, *fh;
 	const struct ip6t_frag *fraginfo = matchinfo;
@@ -115,12 +116,13 @@
 
 /* Called when user tries to insert an entry of this type. */
 static int
-checkentry(const char *tablename,
-	   const void *ip,
-	   const struct xt_match *match,
-	   void *matchinfo,
-	   unsigned int matchinfosize,
-	   unsigned int hook_mask)
+init(const char *tablename,
+     const void *ip,
+     const struct xt_match *match,
+     void *matchinfo,
+     unsigned int matchinfosize,
+     unsigned int hook_mask,
+     void *priv_data)
 {
 	const struct ip6t_frag *fraginfo = matchinfo;
 
@@ -135,7 +137,7 @@
 	.name		= "frag",
 	.match		= match,
 	.matchsize	= sizeof(struct ip6t_frag),
-	.checkentry	= checkentry,
+	.init		= init,
 	.me		= THIS_MODULE,
 };
 
diff -Nru linux-2.6.17.1-priv_data-core/net/ipv6/netfilter/ip6t_hbh.c linux-2.6.17.1-priv_data-matchesandtargets/net/ipv6/netfilter/ip6t_hbh.c
--- linux-2.6.17.1-priv_data-core/net/ipv6/netfilter/ip6t_hbh.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-matchesandtargets/net/ipv6/netfilter/ip6t_hbh.c	2006-06-22 21:57:31.000000000 +0200
@@ -59,7 +59,8 @@
       const void *matchinfo,
       int offset,
       unsigned int protoff,
-      int *hotdrop)
+      int *hotdrop,
+      void *priv_data)
 {
 	struct ipv6_opt_hdr _optsh, *oh;
 	const struct ip6t_opts *optinfo = matchinfo;
@@ -178,12 +179,13 @@
 
 /* Called when user tries to insert an entry of this type. */
 static int
-checkentry(const char *tablename,
-	   const void *entry,
-	   const struct xt_match *match,
-	   void *matchinfo,
-	   unsigned int matchinfosize,
-	   unsigned int hook_mask)
+init(const char *tablename,
+    const void *entry,
+    const struct xt_match *match,
+    void *matchinfo,
+    unsigned int matchinfosize,
+    unsigned int hook_mask,
+    void *priv_data)
 {
 	const struct ip6t_opts *optsinfo = matchinfo;
 
@@ -202,7 +204,7 @@
 #endif
 	.match		= match,
 	.matchsize	= sizeof(struct ip6t_opts),
-	.checkentry	= checkentry,
+	.init		= init,
 	.me		= THIS_MODULE,
 };
 
diff -Nru linux-2.6.17.1-priv_data-core/net/ipv6/netfilter/ip6t_hl.c linux-2.6.17.1-priv_data-matchesandtargets/net/ipv6/netfilter/ip6t_hl.c
--- linux-2.6.17.1-priv_data-core/net/ipv6/netfilter/ip6t_hl.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-matchesandtargets/net/ipv6/netfilter/ip6t_hl.c	2006-06-20 23:41:22.000000000 +0200
@@ -21,7 +21,8 @@
 static int match(const struct sk_buff *skb,
 		 const struct net_device *in, const struct net_device *out,
 		 const struct xt_match *match, const void *matchinfo,
-		 int offset, unsigned int protoff, int *hotdrop)
+		 int offset, unsigned int protoff, int *hotdrop,
+		 void *priv_data)
 {
 	const struct ip6t_hl_info *info = matchinfo;
 	const struct ipv6hdr *ip6h = skb->nh.ipv6h;
diff -Nru linux-2.6.17.1-priv_data-core/net/ipv6/netfilter/ip6t_HL.c linux-2.6.17.1-priv_data-matchesandtargets/net/ipv6/netfilter/ip6t_HL.c
--- linux-2.6.17.1-priv_data-core/net/ipv6/netfilter/ip6t_HL.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-matchesandtargets/net/ipv6/netfilter/ip6t_HL.c	2006-06-24 02:04:18.000000000 +0200
@@ -17,12 +17,13 @@
 MODULE_DESCRIPTION("IP tables Hop Limit modification module");
 MODULE_LICENSE("GPL");
 
-static unsigned int ip6t_hl_target(struct sk_buff **pskb, 
+static unsigned int hl_target(struct sk_buff **pskb,
 				   const struct net_device *in,
 				   const struct net_device *out,
 				   unsigned int hooknum,
 				   const struct xt_target *target,
-				   const void *targinfo, void *userinfo)
+				   const void *targinfo, void *userinfo,
+				   void *priv_data)
 {
 	struct ipv6hdr *ip6h;
 	const struct ip6t_HL_info *info = targinfo;
@@ -62,12 +63,13 @@
 	return IP6T_CONTINUE;
 }
 
-static int ip6t_hl_checkentry(const char *tablename,
+static int hl_init(const char *tablename,
 		const void *entry,
 		const struct xt_target *target,
 		void *targinfo,
 		unsigned int targinfosize,
-		unsigned int hook_mask)
+		unsigned int hook_mask,
+		void *priv_data)
 {
 	struct ip6t_HL_info *info = targinfo;
 
@@ -86,10 +88,10 @@
 
 static struct ip6t_target ip6t_HL = { 
 	.name 		= "HL", 
-	.target		= ip6t_hl_target, 
+	.target		= hl_target,
 	.targetsize	= sizeof(struct ip6t_HL_info),
 	.table		= "mangle",
-	.checkentry	= ip6t_hl_checkentry, 
+	.init		= hl_init,
 	.me		= THIS_MODULE
 };
 
diff -Nru linux-2.6.17.1-priv_data-core/net/ipv6/netfilter/ip6t_ipv6header.c linux-2.6.17.1-priv_data-matchesandtargets/net/ipv6/netfilter/ip6t_ipv6header.c
--- linux-2.6.17.1-priv_data-core/net/ipv6/netfilter/ip6t_ipv6header.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-matchesandtargets/net/ipv6/netfilter/ip6t_ipv6header.c	2006-06-22 22:07:35.000000000 +0200
@@ -33,7 +33,8 @@
 		 const void *matchinfo,
 		 int offset,
 		 unsigned int protoff,
-		 int *hotdrop)
+		 int *hotdrop,
+		 void *priv_data)
 {
 	const struct ip6t_ipv6header_info *info = matchinfo;
 	unsigned int temp;
@@ -124,12 +125,13 @@
 }
 
 static int
-ipv6header_checkentry(const char *tablename,
-		      const void *ip,
-		      const struct xt_match *match,
-		      void *matchinfo,
-		      unsigned int matchsize,
-		      unsigned int hook_mask)
+ipv6header_init(const char *tablename,
+		const void *ip,
+		const struct xt_match *match,
+		void *matchinfo,
+		unsigned int matchsize,
+		unsigned int hook_mask,
+		void *priv_data)
 {
 	const struct ip6t_ipv6header_info *info = matchinfo;
 
@@ -145,20 +147,20 @@
 	.name		= "ipv6header",
 	.match		= &ipv6header_match,
 	.matchsize	= sizeof(struct ip6t_ipv6header_info),
-	.checkentry	= &ipv6header_checkentry,
+	.init		= &ipv6header_init,
 	.destroy	= NULL,
 	.me		= THIS_MODULE,
 };
 
-static int __init ipv6header_init(void)
+static int __init ip6t_ipv6header_init(void)
 {
 	return ip6t_register_match(&ip6t_ipv6header_match);
 }
 
-static void __exit ipv6header_exit(void)
+static void __exit ip6t_ipv6header_exit(void)
 {
 	ip6t_unregister_match(&ip6t_ipv6header_match);
 }
 
-module_init(ipv6header_init);
-module_exit(ipv6header_exit);
+module_init(ip6t_ipv6header_init);
+module_exit(ip6t_ipv6header_exit);
diff -Nru linux-2.6.17.1-priv_data-core/net/ipv6/netfilter/ip6t_LOG.c linux-2.6.17.1-priv_data-matchesandtargets/net/ipv6/netfilter/ip6t_LOG.c
--- linux-2.6.17.1-priv_data-core/net/ipv6/netfilter/ip6t_LOG.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-matchesandtargets/net/ipv6/netfilter/ip6t_LOG.c	2006-06-24 02:05:39.000000000 +0200
@@ -422,13 +422,14 @@
 }
 
 static unsigned int
-ip6t_log_target(struct sk_buff **pskb,
-		const struct net_device *in,
-		const struct net_device *out,
-		unsigned int hooknum,
-		const struct xt_target *target,
-		const void *targinfo,
-		void *userinfo)
+log_target(struct sk_buff **pskb,
+	   const struct net_device *in,
+	   const struct net_device *out,
+	   unsigned int hooknum,
+	   const struct xt_target *target,
+	   const void *targinfo,
+	   void *userinfo,
+	   void *priv_data)
 {
 	const struct ip6t_log_info *loginfo = targinfo;
 	struct nf_loginfo li;
@@ -448,12 +449,13 @@
 }
 
 
-static int ip6t_log_checkentry(const char *tablename,
-			       const void *entry,
-			       const struct xt_target *target,
-			       void *targinfo,
-			       unsigned int targinfosize,
-			       unsigned int hook_mask)
+static int log_init(const char *tablename,
+		    const void *entry,
+		    const struct xt_target *target,
+		    void *targinfo,
+		    unsigned int targinfosize,
+		    unsigned int hook_mask,
+		    void *priv_data)
 {
 	const struct ip6t_log_info *loginfo = targinfo;
 
@@ -471,9 +473,9 @@
 
 static struct ip6t_target ip6t_log_reg = {
 	.name 		= "LOG",
-	.target 	= ip6t_log_target, 
+	.target 	= log_target,
 	.targetsize	= sizeof(struct ip6t_log_info),
-	.checkentry	= ip6t_log_checkentry, 
+	.init		= log_init,
 	.me 		= THIS_MODULE,
 };
 
diff -Nru linux-2.6.17.1-priv_data-core/net/ipv6/netfilter/ip6t_owner.c linux-2.6.17.1-priv_data-matchesandtargets/net/ipv6/netfilter/ip6t_owner.c
--- linux-2.6.17.1-priv_data-core/net/ipv6/netfilter/ip6t_owner.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-matchesandtargets/net/ipv6/netfilter/ip6t_owner.c	2006-06-22 21:58:52.000000000 +0200
@@ -30,7 +30,8 @@
       const void *matchinfo,
       int offset,
       unsigned int protoff,
-      int *hotdrop)
+      int *hotdrop,
+      void *priv_data)
 {
 	const struct ip6t_owner_info *info = matchinfo;
 
@@ -53,12 +54,13 @@
 }
 
 static int
-checkentry(const char *tablename,
-	   const void *ip,
-	   const struct xt_match *match,
-	   void *matchinfo,
-	   unsigned int matchsize,
-	   unsigned int hook_mask)
+init(const char *tablename,
+     const void *ip,
+     const struct xt_match *match,
+     void *matchinfo,
+     unsigned int matchsize,
+     unsigned int hook_mask,
+     void *priv_data)
 {
 	const struct ip6t_owner_info *info = matchinfo;
 
@@ -75,7 +77,7 @@
 	.match		= match,
 	.matchsize	= sizeof(struct ip6t_owner_info),
 	.hooks		= (1 << NF_IP6_LOCAL_OUT) | (1 << NF_IP6_POST_ROUTING),
-	.checkentry	= checkentry,
+	.init		= init,
 	.me		= THIS_MODULE,
 };
 
diff -Nru linux-2.6.17.1-priv_data-core/net/ipv6/netfilter/ip6t_REJECT.c linux-2.6.17.1-priv_data-matchesandtargets/net/ipv6/netfilter/ip6t_REJECT.c
--- linux-2.6.17.1-priv_data-core/net/ipv6/netfilter/ip6t_REJECT.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-matchesandtargets/net/ipv6/netfilter/ip6t_REJECT.c	2006-06-24 01:03:29.000000000 +0200
@@ -181,7 +181,8 @@
 			   unsigned int hooknum,
 			   const struct xt_target *target,
 			   const void *targinfo,
-			   void *userinfo)
+			   void *userinfo,
+			   void *priv_data)
 {
 	const struct ip6t_reject_info *reject = targinfo;
 
@@ -220,12 +221,13 @@
 	return NF_DROP;
 }
 
-static int check(const char *tablename,
-		 const void *entry,
-		 const struct xt_target *target,
-		 void *targinfo,
-		 unsigned int targinfosize,
-		 unsigned int hook_mask)
+static int init(const char *tablename,
+		const void *entry,
+		const struct xt_target *target,
+		void *targinfo,
+		unsigned int targinfosize,
+		unsigned int hook_mask,
+		void *priv_data)
 {
  	const struct ip6t_reject_info *rejinfo = targinfo;
 	const struct ip6t_entry *e = entry;
@@ -251,7 +253,7 @@
 	.table		= "filter",
 	.hooks		= (1 << NF_IP6_LOCAL_IN) | (1 << NF_IP6_FORWARD) |
 			  (1 << NF_IP6_LOCAL_OUT),
-	.checkentry	= check,
+	.init		= init,
 	.me		= THIS_MODULE
 };
 
diff -Nru linux-2.6.17.1-priv_data-core/net/ipv6/netfilter/ip6t_rt.c linux-2.6.17.1-priv_data-matchesandtargets/net/ipv6/netfilter/ip6t_rt.c
--- linux-2.6.17.1-priv_data-core/net/ipv6/netfilter/ip6t_rt.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-matchesandtargets/net/ipv6/netfilter/ip6t_rt.c	2006-06-22 21:59:13.000000000 +0200
@@ -49,7 +49,8 @@
       const void *matchinfo,
       int offset,
       unsigned int protoff,
-      int *hotdrop)
+      int *hotdrop,
+      void *priv_data)
 {
 	struct ipv6_rt_hdr _route, *rh;
 	const struct ip6t_rt *rtinfo = matchinfo;
@@ -193,12 +194,13 @@
 
 /* Called when user tries to insert an entry of this type. */
 static int
-checkentry(const char *tablename,
-	   const void *entry,
-	   const struct xt_match *match,
-	   void *matchinfo,
-	   unsigned int matchinfosize,
-	   unsigned int hook_mask)
+init(const char *tablename,
+     const void *entry,
+     const struct xt_match *match,
+     void *matchinfo,
+     unsigned int matchinfosize,
+     unsigned int hook_mask,
+     void *priv_data)
 {
 	const struct ip6t_rt *rtinfo = matchinfo;
 
@@ -221,7 +223,7 @@
 	.name		= "rt",
 	.match		= match,
 	.matchsize	= sizeof(struct ip6t_rt),
-	.checkentry	= checkentry,
+	.init		= init,
 	.me		= THIS_MODULE,
 };
 
diff -Nru linux-2.6.17.1-priv_data-core/net/netfilter/xt_CLASSIFY.c linux-2.6.17.1-priv_data-matchesandtargets/net/netfilter/xt_CLASSIFY.c
--- linux-2.6.17.1-priv_data-core/net/netfilter/xt_CLASSIFY.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-matchesandtargets/net/netfilter/xt_CLASSIFY.c	2006-06-24 00:44:58.000000000 +0200
@@ -30,7 +30,8 @@
        unsigned int hooknum,
        const struct xt_target *target,
        const void *targinfo,
-       void *userinfo)
+       void *userinfo,
+       void *priv_data)
 {
 	const struct xt_classify_target_info *clinfo = targinfo;
 
diff -Nru linux-2.6.17.1-priv_data-core/net/netfilter/xt_comment.c linux-2.6.17.1-priv_data-matchesandtargets/net/netfilter/xt_comment.c
--- linux-2.6.17.1-priv_data-core/net/netfilter/xt_comment.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-matchesandtargets/net/netfilter/xt_comment.c	2006-06-20 23:41:22.000000000 +0200
@@ -23,7 +23,8 @@
       const void *matchinfo,
       int offset,
       unsigned int protooff,
-      int *hotdrop)
+      int *hotdrop,
+      void *priv_data)
 {
 	/* We always match */
 	return 1;
diff -Nru linux-2.6.17.1-priv_data-core/net/netfilter/xt_connbytes.c linux-2.6.17.1-priv_data-matchesandtargets/net/netfilter/xt_connbytes.c
--- linux-2.6.17.1-priv_data-core/net/netfilter/xt_connbytes.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-matchesandtargets/net/netfilter/xt_connbytes.c	2006-06-22 22:15:17.000000000 +0200
@@ -48,7 +48,8 @@
       const void *matchinfo,
       int offset,
       unsigned int protoff,
-      int *hotdrop)
+      int *hotdrop,
+      void *priv_data)
 {
 	const struct xt_connbytes_info *sinfo = matchinfo;
 	u_int64_t what = 0;	/* initialize to make gcc happy */
@@ -121,12 +122,13 @@
 		return (what >= sinfo->count.from);
 }
 
-static int check(const char *tablename,
-		 const void *ip,
-		 const struct xt_match *match,
-		 void *matchinfo,
-		 unsigned int matchsize,
-		 unsigned int hook_mask)
+static int init(const char *tablename,
+		const void *ip,
+		const struct xt_match *match,
+		void *matchinfo,
+		unsigned int matchsize,
+		unsigned int hook_mask,
+		void *priv_data)
 {
 	const struct xt_connbytes_info *sinfo = matchinfo;
 
@@ -146,7 +148,7 @@
 static struct xt_match connbytes_match = {
 	.name		= "connbytes",
 	.match		= match,
-	.checkentry	= check,
+	.init		= init,
 	.matchsize	= sizeof(struct xt_connbytes_info),
 	.family		= AF_INET,
 	.me		= THIS_MODULE
@@ -154,7 +156,7 @@
 static struct xt_match connbytes6_match = {
 	.name		= "connbytes",
 	.match		= match,
-	.checkentry	= check,
+	.init		= init,
 	.matchsize	= sizeof(struct xt_connbytes_info),
 	.family		= AF_INET6,
 	.me		= THIS_MODULE
diff -Nru linux-2.6.17.1-priv_data-core/net/netfilter/xt_connmark.c linux-2.6.17.1-priv_data-matchesandtargets/net/netfilter/xt_connmark.c
--- linux-2.6.17.1-priv_data-core/net/netfilter/xt_connmark.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-matchesandtargets/net/netfilter/xt_connmark.c	2006-06-22 22:18:03.000000000 +0200
@@ -39,7 +39,8 @@
       const void *matchinfo,
       int offset,
       unsigned int protoff,
-      int *hotdrop)
+      int *hotdrop,
+      void *priv_data)
 {
 	const struct xt_connmark_info *info = matchinfo;
 	u_int32_t ctinfo;
@@ -51,12 +52,13 @@
 }
 
 static int
-checkentry(const char *tablename,
-	   const void *ip,
-	   const struct xt_match *match,
-	   void *matchinfo,
-	   unsigned int matchsize,
-	   unsigned int hook_mask)
+init(const char *tablename,
+     const void *ip,
+     const struct xt_match *match,
+     void *matchinfo,
+     unsigned int matchsize,
+     unsigned int hook_mask,
+     void *priv_data)
 {
 	struct xt_connmark_info *cm = (struct xt_connmark_info *)matchinfo;
 
@@ -75,7 +77,8 @@
 }
 
 static void
-destroy(const struct xt_match *match, void *matchinfo, unsigned int matchsize)
+destroy(const struct xt_match *match, void *matchinfo,
+	unsigned int matchsize, void *priv_data)
 {
 #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
 	nf_ct_l3proto_module_put(match->family);
@@ -86,7 +89,7 @@
 	.name		= "connmark",
 	.match		= match,
 	.matchsize	= sizeof(struct xt_connmark_info),
-	.checkentry	= checkentry,
+	.init		= init,
 	.destroy	= destroy,
 	.family		= AF_INET,
 	.me		= THIS_MODULE
@@ -96,7 +99,7 @@
 	.name		= "connmark",
 	.match		= match,
 	.matchsize	= sizeof(struct xt_connmark_info),
-	.checkentry	= checkentry,
+	.init		= init,
 	.destroy	= destroy,
 	.family		= AF_INET6,
 	.me		= THIS_MODULE
diff -Nru linux-2.6.17.1-priv_data-core/net/netfilter/xt_CONNMARK.c linux-2.6.17.1-priv_data-matchesandtargets/net/netfilter/xt_CONNMARK.c
--- linux-2.6.17.1-priv_data-core/net/netfilter/xt_CONNMARK.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-matchesandtargets/net/netfilter/xt_CONNMARK.c	2006-06-24 00:48:32.000000000 +0200
@@ -39,7 +39,8 @@
        unsigned int hooknum,
        const struct xt_target *target,
        const void *targinfo,
-       void *userinfo)
+       void *userinfo,
+       void *priv_data)
 {
 	const struct xt_connmark_target_info *markinfo = targinfo;
 	u_int32_t diff;
@@ -73,12 +74,13 @@
 }
 
 static int
-checkentry(const char *tablename,
-	   const void *entry,
-	   const struct xt_target *target,
-	   void *targinfo,
-	   unsigned int targinfosize,
-	   unsigned int hook_mask)
+init(const char *tablename,
+     const void *entry,
+     const struct xt_target *target,
+     void *targinfo,
+     unsigned int targinfosize,
+     unsigned int hook_mask,
+     void *priv_data)
 {
 	struct xt_connmark_target_info *matchinfo = targinfo;
 
@@ -101,7 +103,7 @@
 	.name		= "CONNMARK",
 	.target		= target,
 	.targetsize	= sizeof(struct xt_connmark_target_info),
-	.checkentry	= checkentry,
+	.init		= init,
 	.family		= AF_INET,
 	.me		= THIS_MODULE
 };
@@ -110,7 +112,7 @@
 	.name		= "CONNMARK",
 	.target		= target,
 	.targetsize	= sizeof(struct xt_connmark_target_info),
-	.checkentry	= checkentry,
+	.init		= init,
 	.family		= AF_INET6,
 	.me		= THIS_MODULE
 };
diff -Nru linux-2.6.17.1-priv_data-core/net/netfilter/xt_conntrack.c linux-2.6.17.1-priv_data-matchesandtargets/net/netfilter/xt_conntrack.c
--- linux-2.6.17.1-priv_data-core/net/netfilter/xt_conntrack.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-matchesandtargets/net/netfilter/xt_conntrack.c	2006-06-22 22:18:37.000000000 +0200
@@ -36,7 +36,8 @@
       const void *matchinfo,
       int offset,
       unsigned int protoff,
-      int *hotdrop)
+      int *hotdrop,
+      void *priv_data)
 {
 	const struct xt_conntrack_info *sinfo = matchinfo;
 	struct ip_conntrack *ct;
@@ -123,7 +124,8 @@
       const void *matchinfo,
       int offset,
       unsigned int protoff,
-      int *hotdrop)
+      int *hotdrop,
+      void *priv_data)
 {
 	const struct xt_conntrack_info *sinfo = matchinfo;
 	struct nf_conn *ct;
@@ -204,12 +206,13 @@
 #endif /* CONFIG_NF_IP_CONNTRACK */
 
 static int
-checkentry(const char *tablename,
-	   const void *ip,
-	   const struct xt_match *match,
-	   void *matchinfo,
-	   unsigned int matchsize,
-	   unsigned int hook_mask)
+init(const char *tablename,
+     const void *ip,
+     const struct xt_match *match,
+     void *matchinfo,
+     unsigned int matchsize,
+     unsigned int hook_mask,
+     void *priv_data)
 {
 #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
 	if (nf_ct_l3proto_try_module_get(match->family) < 0) {
@@ -222,7 +225,8 @@
 }
 
 static void
-destroy(const struct xt_match *match, void *matchinfo, unsigned int matchsize)
+destroy(const struct xt_match *match, void *matchinfo,
+	unsigned int matchsize, void *priv_data)
 {
 #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
 	nf_ct_l3proto_module_put(match->family);
@@ -232,7 +236,7 @@
 static struct xt_match conntrack_match = {
 	.name		= "conntrack",
 	.match		= match,
-	.checkentry	= checkentry,
+	.init		= init,
 	.destroy	= destroy,
 	.matchsize	= sizeof(struct xt_conntrack_info),
 	.family		= AF_INET,
diff -Nru linux-2.6.17.1-priv_data-core/net/netfilter/xt_dccp.c linux-2.6.17.1-priv_data-matchesandtargets/net/netfilter/xt_dccp.c
--- linux-2.6.17.1-priv_data-core/net/netfilter/xt_dccp.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-matchesandtargets/net/netfilter/xt_dccp.c	2006-06-22 22:19:15.000000000 +0200
@@ -99,7 +99,8 @@
       const void *matchinfo,
       int offset,
       unsigned int protoff,
-      int *hotdrop)
+      int *hotdrop,
+      void *priv_data)
 {
 	const struct xt_dccp_info *info = 
 				(const struct xt_dccp_info *)matchinfo;
@@ -128,12 +129,13 @@
 }
 
 static int
-checkentry(const char *tablename,
-	   const void *inf,
-	   const struct xt_match *match,
-	   void *matchinfo,
-	   unsigned int matchsize,
-	   unsigned int hook_mask)
+init(const char *tablename,
+     const void *inf,
+     const struct xt_match *match,
+     void *matchinfo,
+     unsigned int matchsize,
+     unsigned int hook_mask,
+     void *priv_data)
 {
 	const struct xt_dccp_info *info = matchinfo;
 
@@ -148,7 +150,7 @@
 	.match		= match,
 	.matchsize	= sizeof(struct xt_dccp_info),
 	.proto		= IPPROTO_DCCP,
-	.checkentry	= checkentry,
+	.init		= init,
 	.family		= AF_INET,
 	.me 		= THIS_MODULE,
 };
@@ -158,7 +160,7 @@
 	.match		= match,
 	.matchsize	= sizeof(struct xt_dccp_info),
 	.proto		= IPPROTO_DCCP,
-	.checkentry	= checkentry,
+	.init		= init,
 	.family		= AF_INET6,
 	.me 		= THIS_MODULE,
 };
diff -Nru linux-2.6.17.1-priv_data-core/net/netfilter/xt_esp.c linux-2.6.17.1-priv_data-matchesandtargets/net/netfilter/xt_esp.c
--- linux-2.6.17.1-priv_data-core/net/netfilter/xt_esp.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-matchesandtargets/net/netfilter/xt_esp.c	2006-06-24 21:01:56.000000000 +0200
@@ -50,7 +50,8 @@
       const void *matchinfo,
       int offset,
       unsigned int protoff,
-      int *hotdrop)
+      int *hotdrop,
+      void *priv_data)
 {
 	struct ip_esp_hdr _esp, *eh;
 	const struct xt_esp *espinfo = matchinfo;
@@ -75,12 +76,13 @@
 
 /* Called when user tries to insert an entry of this type. */
 static int
-checkentry(const char *tablename,
-	   const void *ip_void,
-	   const struct xt_match *match,
-	   void *matchinfo,
-	   unsigned int matchinfosize,
-	   unsigned int hook_mask)
+init(const char *tablename,
+     const void *ip_void,
+     const struct xt_match *match,
+     void *matchinfo,
+     unsigned int matchinfosize,
+     unsigned int hook_mask,
+     void *priv_data)
 {
 	const struct xt_esp *espinfo = matchinfo;
 
@@ -96,9 +98,9 @@
 	.name		= "esp",
 	.family		= AF_INET,
 	.proto		= IPPROTO_ESP,
-	.match		= &match,
+	.match		= match,
 	.matchsize	= sizeof(struct xt_esp),
-	.checkentry	= &checkentry,
+	.init		= init,
 	.me		= THIS_MODULE,
 };
 
@@ -106,9 +108,9 @@
 	.name		= "esp",
 	.family		= AF_INET6,
 	.proto		= IPPROTO_ESP,
-	.match		= &match,
+	.match		= match,
 	.matchsize	= sizeof(struct xt_esp),
-	.checkentry	= &checkentry,
+	.init		= init,
 	.me		= THIS_MODULE,
 };
 
diff -Nru linux-2.6.17.1-priv_data-core/net/netfilter/xt_helper.c linux-2.6.17.1-priv_data-matchesandtargets/net/netfilter/xt_helper.c
--- linux-2.6.17.1-priv_data-core/net/netfilter/xt_helper.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-matchesandtargets/net/netfilter/xt_helper.c	2006-06-22 22:20:18.000000000 +0200
@@ -46,7 +46,8 @@
       const void *matchinfo,
       int offset,
       unsigned int protoff,
-      int *hotdrop)
+      int *hotdrop,
+      void *priv_data)
 {
 	const struct xt_helper_info *info = matchinfo;
 	struct ip_conntrack *ct;
@@ -94,7 +95,8 @@
       const void *matchinfo,
       int offset,
       unsigned int protoff,
-      int *hotdrop)
+      int *hotdrop,
+      void *priv_data)
 {
 	const struct xt_helper_info *info = matchinfo;
 	struct nf_conn *ct;
@@ -135,12 +137,13 @@
 }
 #endif
 
-static int check(const char *tablename,
-		 const void *inf,
-		 const struct xt_match *match,
-		 void *matchinfo,
-		 unsigned int matchsize,
-		 unsigned int hook_mask)
+static int init(const char *tablename,
+		const void *inf,
+		const struct xt_match *match,
+		void *matchinfo,
+		unsigned int matchsize,
+		unsigned int hook_mask,
+		void *priv_data)
 {
 	struct xt_helper_info *info = matchinfo;
 
@@ -156,7 +159,8 @@
 }
 
 static void
-destroy(const struct xt_match *match, void *matchinfo, unsigned int matchsize)
+destroy(const struct xt_match *match, void *matchinfo,
+	unsigned int matchsize, void *priv_data)
 {
 #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
 	nf_ct_l3proto_module_put(match->family);
@@ -167,7 +171,7 @@
 	.name		= "helper",
 	.match		= match,
 	.matchsize	= sizeof(struct xt_helper_info),
-	.checkentry	= check,
+	.init		= init,
 	.destroy	= destroy,
 	.family		= AF_INET,
 	.me		= THIS_MODULE,
@@ -176,7 +180,7 @@
 	.name		= "helper",
 	.match		= match,
 	.matchsize	= sizeof(struct xt_helper_info),
-	.checkentry	= check,
+	.init		= init,
 	.destroy	= destroy,
 	.family		= AF_INET6,
 	.me		= THIS_MODULE,
diff -Nru linux-2.6.17.1-priv_data-core/net/netfilter/xt_length.c linux-2.6.17.1-priv_data-matchesandtargets/net/netfilter/xt_length.c
--- linux-2.6.17.1-priv_data-core/net/netfilter/xt_length.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-matchesandtargets/net/netfilter/xt_length.c	2006-06-20 23:41:22.000000000 +0200
@@ -28,7 +28,8 @@
       const void *matchinfo,
       int offset,
       unsigned int protoff,
-      int *hotdrop)
+      int *hotdrop,
+      void *priv_data)
 {
 	const struct xt_length_info *info = matchinfo;
 	u_int16_t pktlen = ntohs(skb->nh.iph->tot_len);
@@ -44,7 +45,8 @@
        const void *matchinfo,
        int offset,
        unsigned int protoff,
-       int *hotdrop)
+       int *hotdrop,
+       void *priv_data)
 {
 	const struct xt_length_info *info = matchinfo;
 	u_int16_t pktlen = ntohs(skb->nh.ipv6h->payload_len) + sizeof(struct ipv6hdr);
diff -Nru linux-2.6.17.1-priv_data-core/net/netfilter/xt_limit.c linux-2.6.17.1-priv_data-matchesandtargets/net/netfilter/xt_limit.c
--- linux-2.6.17.1-priv_data-core/net/netfilter/xt_limit.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-matchesandtargets/net/netfilter/xt_limit.c	2006-06-24 21:09:43.000000000 +0200
@@ -65,14 +65,15 @@
 #define CREDITS_PER_JIFFY POW2_BELOW32(MAX_CPJ)
 
 static int
-ipt_limit_match(const struct sk_buff *skb,
-		const struct net_device *in,
-		const struct net_device *out,
-		const struct xt_match *match,
-		const void *matchinfo,
-		int offset,
-		unsigned int protoff,
-		int *hotdrop)
+match(const struct sk_buff *skb,
+      const struct net_device *in,
+      const struct net_device *out,
+      const struct xt_match *match,
+      const void *matchinfo,
+      int offset,
+      unsigned int protoff,
+      int *hotdrop,
+      void *priv_data)
 {
 	struct xt_rateinfo *r = ((struct xt_rateinfo *)matchinfo)->master;
 	unsigned long now = jiffies;
@@ -106,12 +107,13 @@
 }
 
 static int
-ipt_limit_checkentry(const char *tablename,
-		     const void *inf,
-		     const struct xt_match *match,
-		     void *matchinfo,
-		     unsigned int matchsize,
-		     unsigned int hook_mask)
+init(const char *tablename,
+     const void *inf,
+     const struct xt_match *match,
+     void *matchinfo,
+     unsigned int matchsize,
+     unsigned int hook_mask,
+     void *priv_data)
 {
 	struct xt_rateinfo *r = matchinfo;
 
@@ -138,17 +140,17 @@
 
 static struct xt_match ipt_limit_reg = {
 	.name		= "limit",
-	.match		= ipt_limit_match,
+	.match		= match,
 	.matchsize	= sizeof(struct xt_rateinfo),
-	.checkentry	= ipt_limit_checkentry,
+	.init		= init,
 	.family		= AF_INET,
 	.me		= THIS_MODULE,
 };
 static struct xt_match limit6_reg = {
 	.name		= "limit",
-	.match		= ipt_limit_match,
+	.match		= match,
 	.matchsize	= sizeof(struct xt_rateinfo),
-	.checkentry	= ipt_limit_checkentry,
+	.init		= init,
 	.family		= AF_INET6,
 	.me		= THIS_MODULE,
 };
diff -Nru linux-2.6.17.1-priv_data-core/net/netfilter/xt_mac.c linux-2.6.17.1-priv_data-matchesandtargets/net/netfilter/xt_mac.c
--- linux-2.6.17.1-priv_data-core/net/netfilter/xt_mac.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-matchesandtargets/net/netfilter/xt_mac.c	2006-06-20 23:41:22.000000000 +0200
@@ -31,7 +31,8 @@
       const void *matchinfo,
       int offset,
       unsigned int protoff,
-      int *hotdrop)
+      int *hotdrop,
+      void *priv_data)
 {
     const struct xt_mac_info *info = matchinfo;
 
diff -Nru linux-2.6.17.1-priv_data-core/net/netfilter/xt_mark.c linux-2.6.17.1-priv_data-matchesandtargets/net/netfilter/xt_mark.c
--- linux-2.6.17.1-priv_data-core/net/netfilter/xt_mark.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-matchesandtargets/net/netfilter/xt_mark.c	2006-06-22 22:22:24.000000000 +0200
@@ -27,7 +27,8 @@
       const void *matchinfo,
       int offset,
       unsigned int protoff,
-      int *hotdrop)
+      int *hotdrop,
+      void *priv_data)
 {
 	const struct xt_mark_info *info = matchinfo;
 
@@ -35,12 +36,13 @@
 }
 
 static int
-checkentry(const char *tablename,
-           const void *entry,
-	   const struct xt_match *match,
-           void *matchinfo,
-           unsigned int matchsize,
-           unsigned int hook_mask)
+init(const char *tablename,
+     const void *entry,
+     const struct xt_match *match,
+     void *matchinfo,
+     unsigned int matchsize,
+     unsigned int hook_mask,
+     void *priv_data)
 {
 	struct xt_mark_info *minfo = (struct xt_mark_info *) matchinfo;
 
@@ -55,7 +57,7 @@
 	.name		= "mark",
 	.match		= match,
 	.matchsize	= sizeof(struct xt_mark_info),
-	.checkentry	= checkentry,
+	.init		= init,
 	.family		= AF_INET,
 	.me		= THIS_MODULE,
 };
@@ -64,7 +66,7 @@
 	.name		= "mark",
 	.match		= match,
 	.matchsize	= sizeof(struct xt_mark_info),
-	.checkentry	= checkentry,
+	.init		= init,
 	.family		= AF_INET6,
 	.me		= THIS_MODULE,
 };
diff -Nru linux-2.6.17.1-priv_data-core/net/netfilter/xt_MARK.c linux-2.6.17.1-priv_data-matchesandtargets/net/netfilter/xt_MARK.c
--- linux-2.6.17.1-priv_data-core/net/netfilter/xt_MARK.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-matchesandtargets/net/netfilter/xt_MARK.c	2006-06-24 00:48:40.000000000 +0200
@@ -28,7 +28,8 @@
 	  unsigned int hooknum,
 	  const struct xt_target *target,
 	  const void *targinfo,
-	  void *userinfo)
+	  void *userinfo,
+	  void *priv_data)
 {
 	const struct xt_mark_target_info *markinfo = targinfo;
 
@@ -45,7 +46,8 @@
 	  unsigned int hooknum,
 	  const struct xt_target *target,
 	  const void *targinfo,
-	  void *userinfo)
+	  void *userinfo,
+	  void *priv_data)
 {
 	const struct xt_mark_target_info_v1 *markinfo = targinfo;
 	int mark = 0;
@@ -72,12 +74,13 @@
 
 
 static int
-checkentry_v0(const char *tablename,
-	      const void *entry,
-	      const struct xt_target *target,
-	      void *targinfo,
-	      unsigned int targinfosize,
-	      unsigned int hook_mask)
+init_v0(const char *tablename,
+	const void *entry,
+	const struct xt_target *target,
+	void *targinfo,
+	unsigned int targinfosize,
+	unsigned int hook_mask,
+	void *priv_data)
 {
 	struct xt_mark_target_info *markinfo = targinfo;
 
@@ -89,12 +92,13 @@
 }
 
 static int
-checkentry_v1(const char *tablename,
-	      const void *entry,
-	      const struct xt_target *target,
-	      void *targinfo,
-	      unsigned int targinfosize,
-	      unsigned int hook_mask)
+init_v1(const char *tablename,
+	const void *entry,
+	const struct xt_target *target,
+	void *targinfo,
+	unsigned int targinfosize,
+	unsigned int hook_mask,
+	void *priv_data)
 {
 	struct xt_mark_target_info_v1 *markinfo = targinfo;
 
@@ -117,7 +121,7 @@
 	.target		= target_v0,
 	.targetsize	= sizeof(struct xt_mark_target_info),
 	.table		= "mangle",
-	.checkentry	= checkentry_v0,
+	.init	= init_v0,
 	.me		= THIS_MODULE,
 	.family		= AF_INET,
 	.revision	= 0,
@@ -128,7 +132,7 @@
 	.target		= target_v1,
 	.targetsize	= sizeof(struct xt_mark_target_info_v1),
 	.table		= "mangle",
-	.checkentry	= checkentry_v1,
+	.init		= init_v1,
 	.me		= THIS_MODULE,
 	.family		= AF_INET,
 	.revision	= 1,
@@ -139,7 +143,7 @@
 	.target		= target_v0,
 	.targetsize	= sizeof(struct xt_mark_target_info),
 	.table		= "mangle",
-	.checkentry	= checkentry_v0,
+	.init		= init_v0,
 	.me		= THIS_MODULE,
 	.family		= AF_INET6,
 	.revision	= 0,
diff -Nru linux-2.6.17.1-priv_data-core/net/netfilter/xt_multiport.c linux-2.6.17.1-priv_data-matchesandtargets/net/netfilter/xt_multiport.c
--- linux-2.6.17.1-priv_data-core/net/netfilter/xt_multiport.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-matchesandtargets/net/netfilter/xt_multiport.c	2006-06-24 21:03:47.000000000 +0200
@@ -102,7 +102,8 @@
       const void *matchinfo,
       int offset,
       unsigned int protoff,
-      int *hotdrop)
+      int *hotdrop,
+      void *priv_data)
 {
 	u16 _ports[2], *pptr;
 	const struct xt_multiport *multiinfo = matchinfo;
@@ -133,7 +134,8 @@
 	 const void *matchinfo,
 	 int offset,
 	 unsigned int protoff,
-	 int *hotdrop)
+	 int *hotdrop,
+	 void *priv_data)
 {
 	u16 _ports[2], *pptr;
 	const struct xt_multiport_v1 *multiinfo = matchinfo;
@@ -171,12 +173,13 @@
 
 /* Called when user tries to insert an entry of this type. */
 static int
-checkentry(const char *tablename,
-	   const void *info,
-	   const struct xt_match *match,
-	   void *matchinfo,
-	   unsigned int matchsize,
-	   unsigned int hook_mask)
+init(const char *tablename,
+     const void *info,
+     const struct xt_match *match,
+     void *matchinfo,
+     unsigned int matchsize,
+     unsigned int hook_mask,
+     void *priv_data)
 {
 	const struct ipt_ip *ip = info;
 	const struct xt_multiport *multiinfo = matchinfo;
@@ -186,12 +189,13 @@
 }
 
 static int
-checkentry_v1(const char *tablename,
-	      const void *info,
-	      const struct xt_match *match,
-	      void *matchinfo,
-	      unsigned int matchsize,
-	      unsigned int hook_mask)
+init_v1(const char *tablename,
+	const void *info,
+	const struct xt_match *match,
+	void *matchinfo,
+	unsigned int matchsize,
+	unsigned int hook_mask,
+	void *priv_data)
 {
 	const struct ipt_ip *ip = info;
 	const struct xt_multiport_v1 *multiinfo = matchinfo;
@@ -201,12 +205,13 @@
 }
 
 static int
-checkentry6(const char *tablename,
-	    const void *info,
-	    const struct xt_match *match,
-	    void *matchinfo,
-	    unsigned int matchsize,
-	    unsigned int hook_mask)
+init6(const char *tablename,
+      const void *info,
+      const struct xt_match *match,
+      void *matchinfo,
+      unsigned int matchsize,
+      unsigned int hook_mask,
+      void *priv_data)
 {
 	const struct ip6t_ip6 *ip = info;
 	const struct xt_multiport *multiinfo = matchinfo;
@@ -216,12 +221,13 @@
 }
 
 static int
-checkentry6_v1(const char *tablename,
-	       const void *info,
-	       const struct xt_match *match,
-	       void *matchinfo,
-	       unsigned int matchsize,
-	       unsigned int hook_mask)
+init6_v1(const char *tablename,
+	 const void *info,
+	 const struct xt_match *match,
+	 void *matchinfo,
+	 unsigned int matchsize,
+	 unsigned int hook_mask,
+	 void *priv_data)
 {
 	const struct ip6t_ip6 *ip = info;
 	const struct xt_multiport_v1 *multiinfo = matchinfo;
@@ -234,8 +240,8 @@
 	.name		= "multiport",
 	.revision	= 0,
 	.matchsize	= sizeof(struct xt_multiport),
-	.match		= &match,
-	.checkentry	= &checkentry,
+	.match		= match,
+	.init		= init,
 	.family		= AF_INET,
 	.me		= THIS_MODULE,
 };
@@ -244,8 +250,8 @@
 	.name		= "multiport",
 	.revision	= 1,
 	.matchsize	= sizeof(struct xt_multiport_v1),
-	.match		= &match_v1,
-	.checkentry	= &checkentry_v1,
+	.match		= match_v1,
+	.init		= init_v1,
 	.family		= AF_INET,
 	.me		= THIS_MODULE,
 };
@@ -254,8 +260,8 @@
 	.name		= "multiport",
 	.revision	= 0,
 	.matchsize	= sizeof(struct xt_multiport),
-	.match		= &match,
-	.checkentry	= &checkentry6,
+	.match		= match,
+	.init		= init6,
 	.family		= AF_INET6,
 	.me		= THIS_MODULE,
 };
@@ -264,8 +270,8 @@
 	.name		= "multiport",
 	.revision	= 1,
 	.matchsize	= sizeof(struct xt_multiport_v1),
-	.match		= &match_v1,
-	.checkentry	= &checkentry6_v1,
+	.match		= match_v1,
+	.init		= init6_v1,
 	.family		= AF_INET6,
 	.me		= THIS_MODULE,
 };
diff -Nru linux-2.6.17.1-priv_data-core/net/netfilter/xt_NFQUEUE.c linux-2.6.17.1-priv_data-matchesandtargets/net/netfilter/xt_NFQUEUE.c
--- linux-2.6.17.1-priv_data-core/net/netfilter/xt_NFQUEUE.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-matchesandtargets/net/netfilter/xt_NFQUEUE.c	2006-06-24 00:49:11.000000000 +0200
@@ -30,7 +30,8 @@
        unsigned int hooknum,
        const struct xt_target *target,
        const void *targinfo,
-       void *userinfo)
+       void *userinfo,
+       void *priv_data)
 {
 	const struct xt_NFQ_info *tinfo = targinfo;
 
diff -Nru linux-2.6.17.1-priv_data-core/net/netfilter/xt_NOTRACK.c linux-2.6.17.1-priv_data-matchesandtargets/net/netfilter/xt_NOTRACK.c
--- linux-2.6.17.1-priv_data-core/net/netfilter/xt_NOTRACK.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-matchesandtargets/net/netfilter/xt_NOTRACK.c	2006-06-24 00:49:22.000000000 +0200
@@ -17,7 +17,8 @@
        unsigned int hooknum,
        const struct xt_target *target,
        const void *targinfo,
-       void *userinfo)
+       void *userinfo,
+       void *priv_data)
 {
 	/* Previously seen (loopback)? Ignore. */
 	if ((*pskb)->nfct != NULL)
diff -Nru linux-2.6.17.1-priv_data-core/net/netfilter/xt_physdev.c linux-2.6.17.1-priv_data-matchesandtargets/net/netfilter/xt_physdev.c
--- linux-2.6.17.1-priv_data-core/net/netfilter/xt_physdev.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-matchesandtargets/net/netfilter/xt_physdev.c	2006-06-22 22:24:58.000000000 +0200
@@ -30,7 +30,8 @@
       const void *matchinfo,
       int offset,
       unsigned int protoff,
-      int *hotdrop)
+      int *hotdrop,
+      void *priv_data)
 {
 	int i;
 	static const char nulldevname[IFNAMSIZ];
@@ -101,12 +102,13 @@
 }
 
 static int
-checkentry(const char *tablename,
-		       const void *ip,
-		       const struct xt_match *match,
-		       void *matchinfo,
-		       unsigned int matchsize,
-		       unsigned int hook_mask)
+init(const char *tablename,
+     const void *ip,
+     const struct xt_match *match,
+     void *matchinfo,
+     unsigned int matchsize,
+     unsigned int hook_mask,
+     void *priv_data)
 {
 	const struct xt_physdev_info *info = matchinfo;
 
@@ -120,7 +122,7 @@
 	.name		= "physdev",
 	.match		= match,
 	.matchsize	= sizeof(struct xt_physdev_info),
-	.checkentry	= checkentry,
+	.init		= init,
 	.family		= AF_INET,
 	.me		= THIS_MODULE,
 };
@@ -129,7 +131,7 @@
 	.name		= "physdev",
 	.match		= match,
 	.matchsize	= sizeof(struct xt_physdev_info),
-	.checkentry	= checkentry,
+	.init		= init,
 	.family		= AF_INET6,
 	.me		= THIS_MODULE,
 };
diff -Nru linux-2.6.17.1-priv_data-core/net/netfilter/xt_pkttype.c linux-2.6.17.1-priv_data-matchesandtargets/net/netfilter/xt_pkttype.c
--- linux-2.6.17.1-priv_data-core/net/netfilter/xt_pkttype.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-matchesandtargets/net/netfilter/xt_pkttype.c	2006-06-20 23:41:22.000000000 +0200
@@ -26,7 +26,8 @@
       const void *matchinfo,
       int offset,
       unsigned int protoff,
-      int *hotdrop)
+      int *hotdrop,
+      void *priv_data)
 {
 	const struct xt_pkttype_info *info = matchinfo;
 
diff -Nru linux-2.6.17.1-priv_data-core/net/netfilter/xt_policy.c linux-2.6.17.1-priv_data-matchesandtargets/net/netfilter/xt_policy.c
--- linux-2.6.17.1-priv_data-core/net/netfilter/xt_policy.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-matchesandtargets/net/netfilter/xt_policy.c	2006-06-22 22:29:59.000000000 +0200
@@ -116,7 +116,8 @@
                  const void *matchinfo,
                  int offset,
                  unsigned int protoff,
-                 int *hotdrop)
+                 int *hotdrop,
+                 void *priv_data)
 {
 	const struct xt_policy_info *info = matchinfo;
 	int ret;
@@ -134,10 +135,10 @@
 	return ret;
 }
 
-static int checkentry(const char *tablename, const void *ip_void,
-                      const struct xt_match *match,
-                      void *matchinfo, unsigned int matchsize,
-                      unsigned int hook_mask)
+static int init(const char *tablename, const void *ip_void,
+		const struct xt_match *match,
+		void *matchinfo, unsigned int matchsize,
+		unsigned int hook_mask, void *priv_data)
 {
 	struct xt_policy_info *info = matchinfo;
 
@@ -171,7 +172,7 @@
 	.family		= AF_INET,
 	.match		= match,
 	.matchsize	= sizeof(struct xt_policy_info),
-	.checkentry 	= checkentry,
+	.init	 	= init,
 	.family		= AF_INET,
 	.me		= THIS_MODULE,
 };
@@ -181,12 +182,12 @@
 	.family		= AF_INET6,
 	.match		= match,
 	.matchsize	= sizeof(struct xt_policy_info),
-	.checkentry	= checkentry,
+	.init		= init,
 	.family		= AF_INET6,
 	.me		= THIS_MODULE,
 };
 
-static int __init init(void)
+static int __init xt_policy_init(void)
 {
 	int ret;
 
@@ -199,13 +200,13 @@
 	return ret;
 }
 
-static void __exit fini(void)
+static void __exit xt_policy_fini(void)
 {
 	xt_unregister_match(&policy6_match);
 	xt_unregister_match(&policy_match);
 }
 
-module_init(init);
-module_exit(fini);
+module_init(xt_policy_init);
+module_exit(xt_policy_fini);
 MODULE_ALIAS("ipt_policy");
 MODULE_ALIAS("ip6t_policy");
diff -Nru linux-2.6.17.1-priv_data-core/net/netfilter/xt_realm.c linux-2.6.17.1-priv_data-matchesandtargets/net/netfilter/xt_realm.c
--- linux-2.6.17.1-priv_data-core/net/netfilter/xt_realm.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-matchesandtargets/net/netfilter/xt_realm.c	2006-06-20 23:41:22.000000000 +0200
@@ -31,7 +31,8 @@
       const void *matchinfo,
       int offset,
       unsigned int protoff,
-      int *hotdrop)
+      int *hotdrop,
+      void *priv_data)
 {
 	const struct xt_realm_info *info = matchinfo;
 	struct dst_entry *dst = skb->dst;
diff -Nru linux-2.6.17.1-priv_data-core/net/netfilter/xt_sctp.c linux-2.6.17.1-priv_data-matchesandtargets/net/netfilter/xt_sctp.c
--- linux-2.6.17.1-priv_data-core/net/netfilter/xt_sctp.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-matchesandtargets/net/netfilter/xt_sctp.c	2006-06-22 22:26:38.000000000 +0200
@@ -127,7 +127,8 @@
       const void *matchinfo,
       int offset,
       unsigned int protoff,
-      int *hotdrop)
+      int *hotdrop,
+      void *priv_data)
 {
 	const struct xt_sctp_info *info;
 	sctp_sctphdr_t _sh, *sh;
@@ -161,12 +162,13 @@
 }
 
 static int
-checkentry(const char *tablename,
-	   const void *inf,
-	   const struct xt_match *match,
-	   void *matchinfo,
-	   unsigned int matchsize,
-	   unsigned int hook_mask)
+init(const char *tablename,
+     const void *inf,
+     const struct xt_match *match,
+     void *matchinfo,
+     unsigned int matchsize,
+     unsigned int hook_mask,
+     void *priv_data)
 {
 	const struct xt_sctp_info *info = matchinfo;
 
@@ -185,7 +187,7 @@
 	.match		= match,
 	.matchsize	= sizeof(struct xt_sctp_info),
 	.proto		= IPPROTO_SCTP,
-	.checkentry	= checkentry,
+	.init		= init,
 	.family		= AF_INET,
 	.me		= THIS_MODULE
 };
@@ -195,7 +197,7 @@
 	.match		= match,
 	.matchsize	= sizeof(struct xt_sctp_info),
 	.proto		= IPPROTO_SCTP,
-	.checkentry	= checkentry,
+	.init		= init,
 	.family		= AF_INET6,
 	.me		= THIS_MODULE
 };
diff -Nru linux-2.6.17.1-priv_data-core/net/netfilter/xt_state.c linux-2.6.17.1-priv_data-matchesandtargets/net/netfilter/xt_state.c
--- linux-2.6.17.1-priv_data-core/net/netfilter/xt_state.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-matchesandtargets/net/netfilter/xt_state.c	2006-06-22 22:27:33.000000000 +0200
@@ -28,7 +28,8 @@
       const void *matchinfo,
       int offset,
       unsigned int protoff,
-      int *hotdrop)
+      int *hotdrop,
+      void *priv_data)
 {
 	const struct xt_state_info *sinfo = matchinfo;
 	enum ip_conntrack_info ctinfo;
@@ -44,12 +45,13 @@
 	return (sinfo->statemask & statebit);
 }
 
-static int check(const char *tablename,
-		 const void *inf,
-		 const struct xt_match *match,
-		 void *matchinfo,
-		 unsigned int matchsize,
-		 unsigned int hook_mask)
+static int init(const char *tablename,
+		const void *inf,
+		const struct xt_match *match,
+		void *matchinfo,
+		unsigned int matchsize,
+		unsigned int hook_mask,
+		void *priv_data)
 {
 #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
 	if (nf_ct_l3proto_try_module_get(match->family) < 0) {
@@ -62,7 +64,8 @@
 }
 
 static void
-destroy(const struct xt_match *match, void *matchinfo, unsigned int matchsize)
+destroy(const struct xt_match *match, void *matchinfo,
+	unsigned int matchsize, void *priv_data)
 {
 #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
 	nf_ct_l3proto_module_put(match->family);
@@ -72,7 +75,7 @@
 static struct xt_match state_match = {
 	.name		= "state",
 	.match		= match,
-	.checkentry	= check,
+	.init		= init,
 	.destroy	= destroy,
 	.matchsize	= sizeof(struct xt_state_info),
 	.family		= AF_INET,
@@ -82,7 +85,7 @@
 static struct xt_match state6_match = {
 	.name		= "state",
 	.match		= match,
-	.checkentry	= check,
+	.init		= init,
 	.destroy	= destroy,
 	.matchsize	= sizeof(struct xt_state_info),
 	.family		= AF_INET6,
diff -Nru linux-2.6.17.1-priv_data-core/net/netfilter/xt_string.c linux-2.6.17.1-priv_data-matchesandtargets/net/netfilter/xt_string.c
--- linux-2.6.17.1-priv_data-core/net/netfilter/xt_string.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-matchesandtargets/net/netfilter/xt_string.c	2006-06-22 22:28:09.000000000 +0200
@@ -28,7 +28,8 @@
 		 const void *matchinfo,
 		 int offset,
 		 unsigned int protoff,
-		 int *hotdrop)
+		 int *hotdrop,
+		 void *priv_data)
 {
 	struct ts_state state;
 	struct xt_string_info *conf = (struct xt_string_info *) matchinfo;
@@ -42,12 +43,13 @@
 
 #define STRING_TEXT_PRIV(m) ((struct xt_string_info *) m)
 
-static int checkentry(const char *tablename,
-		      const void *ip,
-		      const struct xt_match *match,
-		      void *matchinfo,
-		      unsigned int matchsize,
-		      unsigned int hook_mask)
+static int init(const char *tablename,
+		const void *ip,
+		const struct xt_match *match,
+		void *matchinfo,
+		unsigned int matchsize,
+		unsigned int hook_mask,
+		void *priv_data)
 {
 	struct xt_string_info *conf = matchinfo;
 	struct ts_config *ts_conf;
@@ -67,7 +69,7 @@
 }
 
 static void destroy(const struct xt_match *match, void *matchinfo,
-		    unsigned int matchsize)
+		    unsigned int matchsize, void *priv_data)
 {
 	textsearch_destroy(STRING_TEXT_PRIV(matchinfo)->config);
 }
@@ -76,7 +78,7 @@
 	.name 		= "string",
 	.match 		= match,
 	.matchsize	= sizeof(struct xt_string_info),
-	.checkentry	= checkentry,
+	.init		= init,
 	.destroy 	= destroy,
 	.family		= AF_INET,
 	.me 		= THIS_MODULE
@@ -85,7 +87,7 @@
 	.name 		= "string",
 	.match 		= match,
 	.matchsize	= sizeof(struct xt_string_info),
-	.checkentry	= checkentry,
+	.init		= init,
 	.destroy 	= destroy,
 	.family		= AF_INET6,
 	.me 		= THIS_MODULE
diff -Nru linux-2.6.17.1-priv_data-core/net/netfilter/xt_tcpmss.c linux-2.6.17.1-priv_data-matchesandtargets/net/netfilter/xt_tcpmss.c
--- linux-2.6.17.1-priv_data-core/net/netfilter/xt_tcpmss.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-matchesandtargets/net/netfilter/xt_tcpmss.c	2006-06-20 23:41:22.000000000 +0200
@@ -85,7 +85,8 @@
       const void *matchinfo,
       int offset,
       unsigned int protoff,
-      int *hotdrop)
+      int *hotdrop,
+      void *priv_data)
 {
 	const struct xt_tcpmss_match_info *info = matchinfo;
 
diff -Nru linux-2.6.17.1-priv_data-core/net/netfilter/xt_tcpudp.c linux-2.6.17.1-priv_data-matchesandtargets/net/netfilter/xt_tcpudp.c
--- linux-2.6.17.1-priv_data-core/net/netfilter/xt_tcpudp.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-matchesandtargets/net/netfilter/xt_tcpudp.c	2006-06-22 22:13:56.000000000 +0200
@@ -78,7 +78,8 @@
 	  const void *matchinfo,
 	  int offset,
 	  unsigned int protoff,
-	  int *hotdrop)
+	  int *hotdrop,
+	  void *priv_data)
 {
 	struct tcphdr _tcph, *th;
 	const struct xt_tcp *tcpinfo = matchinfo;
@@ -137,12 +138,13 @@
 
 /* Called when user tries to insert an entry of this type. */
 static int
-tcp_checkentry(const char *tablename,
+tcp_init_match(const char *tablename,
 	       const void *info,
 	       const struct xt_match *match,
 	       void *matchinfo,
 	       unsigned int matchsize,
-	       unsigned int hook_mask)
+	       unsigned int hook_mask,
+	       void *priv_data)
 {
 	const struct xt_tcp *tcpinfo = matchinfo;
 
@@ -158,7 +160,8 @@
 	  const void *matchinfo,
 	  int offset,
 	  unsigned int protoff,
-	  int *hotdrop)
+	  int *hotdrop,
+	  void *priv_data)
 {
 	struct udphdr _udph, *uh;
 	const struct xt_udp *udpinfo = matchinfo;
@@ -186,12 +189,13 @@
 
 /* Called when user tries to insert an entry of this type. */
 static int
-udp_checkentry(const char *tablename,
+udp_init_match(const char *tablename,
 	       const void *info,
 	       const struct xt_match *match,
 	       void *matchinfo,
 	       unsigned int matchsize,
-	       unsigned int hook_mask)
+	       unsigned int hook_mask,
+	       void *priv_data)
 {
 	const struct xt_tcp *udpinfo = matchinfo;
 
@@ -205,7 +209,7 @@
 	.matchsize	= sizeof(struct xt_tcp),
 	.proto		= IPPROTO_TCP,
 	.family		= AF_INET,
-	.checkentry	= tcp_checkentry,
+	.init		= tcp_init_match,
 	.me		= THIS_MODULE,
 };
 
@@ -215,7 +219,7 @@
 	.matchsize	= sizeof(struct xt_tcp),
 	.proto		= IPPROTO_TCP,
 	.family		= AF_INET6,
-	.checkentry	= tcp_checkentry,
+	.init		= tcp_init_match,
 	.me		= THIS_MODULE,
 };
 
@@ -225,7 +229,7 @@
 	.matchsize	= sizeof(struct xt_udp),
 	.proto		= IPPROTO_UDP,
 	.family		= AF_INET,
-	.checkentry	= udp_checkentry,
+	.init		= udp_init_match,
 	.me		= THIS_MODULE,
 };
 static struct xt_match udp6_matchstruct = {
@@ -234,7 +238,7 @@
 	.matchsize	= sizeof(struct xt_udp),
 	.proto		= IPPROTO_UDP,
 	.family		= AF_INET6,
-	.checkentry	= udp_checkentry,
+	.init		= udp_init_match,
 	.me		= THIS_MODULE,
 };
 

--Boundary-00=_0K/nEuVxkMBq09Q--
