From: Massimiliano Hofer <max@nucleus.it>
Subject: Re: [PATCH] priv_data (formerly entry_data)
Date: Wed, 21 Jun 2006 02:03:30 +0200
Message-ID: <200606210203.33209.max@nucleus.it>
References: <200606050029.08602.max@nucleus.it>
	<200606201325.02775.max@nucleus.it> <4497F561.4000503@trash.net>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_VzImEgS2SKbCq3t"
Cc: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <4497F561.4000503@trash.net>
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

--Boundary-00=_VzImEgS2SKbCq3t
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tuesday 20 June 2006 3:17 pm, Patrick McHardy wrote:

> The case of just needing a pointer is just an optimization for a
> special-case in my opinion (avoid lookup of globally shared state),
> per-instance state is probably more common. So I'd suggest to go
> with the second possibility.

Is this better?
I'll send an example of its use in a few minutes.

-- 
Saluti,
   Massimiliano Hofer

--Boundary-00=_VzImEgS2SKbCq3t
Content-Type: text/x-diff; charset="iso-8859-15";
	name="2.6.17.1-priv_data_core.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="2.6.17.1-priv_data_core.patch"

diff -Nru linux-2.6.17.1/include/linux/netfilter/x_tables.h linux-2.6.17.1-priv_data_core/include/linux/netfilter/x_tables.h
--- linux-2.6.17.1/include/linux/netfilter/x_tables.h	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data_core/include/linux/netfilter/x_tables.h	2006-06-21 00:49:03.000000000 +0200
@@ -20,6 +20,7 @@
 
 			/* Used inside the kernel */
 			struct xt_match *match;
+			void *priv_data;
 		} kernel;
 
 		/* Total length */
@@ -166,7 +167,8 @@
 		     const void *matchinfo,
 		     int offset,
 		     unsigned int protoff,
-		     int *hotdrop);
+		     int *hotdrop,
+		     void *priv_data);
 
 	/* Called when user tries to insert an entry of this type. */
 	/* Should return true or false. */
@@ -175,11 +177,12 @@
 			  const struct xt_match *match,
 			  void *matchinfo,
 			  unsigned int matchinfosize,
-			  unsigned int hook_mask);
+			  unsigned int hook_mask,
+			  void *priv_data);
 
 	/* Called when entry of this type deleted. */
 	void (*destroy)(const struct xt_match *match, void *matchinfo,
-			unsigned int matchinfosize);
+			unsigned int matchinfosize, void *priv_data);
 
 	/* Called when userspace align differs from kernel space one */
 	int (*compat)(void *match, void **dstptr, int *size, int convert);
@@ -189,6 +192,7 @@
 
 	char *table;
 	unsigned int matchsize;
+	size_t priv_size;
 	unsigned int hooks;
 	unsigned short proto;
 
diff -Nru linux-2.6.17.1/net/ipv4/netfilter/ip_tables.c linux-2.6.17.1-priv_data_core/net/ipv4/netfilter/ip_tables.c
--- linux-2.6.17.1/net/ipv4/netfilter/ip_tables.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data_core/net/ipv4/netfilter/ip_tables.c	2006-06-21 00:49:12.000000000 +0200
@@ -200,7 +200,8 @@
 {
 	/* Stop iteration if it doesn't match */
 	if (!m->u.kernel.match->match(skb, in, out, m->u.kernel.match, m->data,
-				      offset, skb->nh.iph->ihl*4, hotdrop))
+				      offset, skb->nh.iph->ihl*4, hotdrop,
+				      m->u.kernel.priv_data))
 		return 1;
 	else
 		return 0;
@@ -468,7 +469,9 @@
 
 	if (m->u.kernel.match->destroy)
 		m->u.kernel.match->destroy(m->u.kernel.match, m->data,
-					   m->u.match_size - sizeof(*m));
+					   m->u.match_size - sizeof(*m),
+					   m->u.kernel.priv_data);
+	kfree(m->u.kernel.priv_data);
 	module_put(m->u.kernel.match->me);
 	return 0;
 }
@@ -519,10 +522,20 @@
 	if (ret)
 		goto err;
 
+	if (match->priv_size) {
+		m->u.kernel.priv_data = kzalloc(match->priv_size,
+					      GFP_KERNEL);
+		if (!m->u.kernel.priv_data) {
+			ret = -ENOMEM;
+			goto err;
+		}
+	}
+
 	if (m->u.kernel.match->checkentry
 	    && !m->u.kernel.match->checkentry(name, ip, match, m->data,
 					      m->u.match_size - sizeof(*m),
-					      hookmask)) {
+					      hookmask,
+					      m->u.kernel.priv_data)) {
 		duprintf("ip_tables: check failed for `%s'.\n",
 			 m->u.kernel.match->name);
 		ret = -EINVAL;
@@ -2152,7 +2165,8 @@
 	   const void *matchinfo,
 	   int offset,
 	   unsigned int protoff,
-	   int *hotdrop)
+	   int *hotdrop,
+	   void *priv_data)
 {
 	struct icmphdr _icmph, *ic;
 	const struct ipt_icmp *icmpinfo = matchinfo;
@@ -2185,7 +2199,8 @@
 	   const struct xt_match *match,
 	   void *matchinfo,
 	   unsigned int matchsize,
-	   unsigned int hook_mask)
+	   unsigned int hook_mask,
+	   void *priv_data)
 {
 	const struct ipt_icmp *icmpinfo = matchinfo;
 
diff -Nru linux-2.6.17.1/net/ipv6/netfilter/ip6_tables.c linux-2.6.17.1-priv_data_core/net/ipv6/netfilter/ip6_tables.c
--- linux-2.6.17.1/net/ipv6/netfilter/ip6_tables.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data_core/net/ipv6/netfilter/ip6_tables.c	2006-06-21 00:49:25.000000000 +0200
@@ -240,7 +240,8 @@
 {
 	/* Stop iteration if it doesn't match */
 	if (!m->u.kernel.match->match(skb, in, out, m->u.kernel.match, m->data,
-				      offset, protoff, hotdrop))
+				      offset, protoff, hotdrop,
+				      m->u.kernel.priv_data))
 		return 1;
 	else
 		return 0;
@@ -508,7 +509,9 @@
 
 	if (m->u.kernel.match->destroy)
 		m->u.kernel.match->destroy(m->u.kernel.match, m->data,
-					   m->u.match_size - sizeof(*m));
+					   m->u.match_size - sizeof(*m),
+					   m->u.kernel.priv_data);
+	kfree(m->u.kernel.priv_data);
 	module_put(m->u.kernel.match->me);
 	return 0;
 }
@@ -559,10 +562,20 @@
 	if (ret)
 		goto err;
 
+	if (match->priv_size) {
+		m->u.kernel.priv_data = kzalloc(match->priv_size,
+					      GFP_KERNEL);
+		if (!m->u.kernel.priv_data) {
+			ret = -ENOMEM;
+			goto err;
+		}
+	}
+	
 	if (m->u.kernel.match->checkentry
 	    && !m->u.kernel.match->checkentry(name, ipv6, match,  m->data,
 					      m->u.match_size - sizeof(*m),
-					      hookmask)) {
+					      hookmask,
+					      m->u.kernel.priv_data)) {
 		duprintf("ip_tables: check failed for `%s'.\n",
 			 m->u.kernel.match->name);
 		ret = -EINVAL;
@@ -1320,7 +1333,8 @@
 	   const void *matchinfo,
 	   int offset,
 	   unsigned int protoff,
-	   int *hotdrop)
+	   int *hotdrop,
+	   void *priv_data)
 {
 	struct icmp6hdr _icmp, *ic;
 	const struct ip6t_icmp *icmpinfo = matchinfo;
@@ -1352,7 +1366,8 @@
 	   const struct xt_match *match,
 	   void *matchinfo,
 	   unsigned int matchsize,
-	   unsigned int hook_mask)
+	   unsigned int hook_mask,
+	   void *priv_data)
 {
 	const struct ip6t_icmp *icmpinfo = matchinfo;
 

--Boundary-00=_VzImEgS2SKbCq3t
Content-Type: text/x-diff; charset="iso-8859-15";
	name="2.6.17.1-priv_data_matches.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="2.6.17.1-priv_data_matches.patch"

diff -Nru linux-2.6.17.1-priv_data_core/net/ipv4/netfilter/ipt_addrtype.c linux-2.6.17.1-priv_data_matches/net/ipv4/netfilter/ipt_addrtype.c
--- linux-2.6.17.1-priv_data_core/net/ipv4/netfilter/ipt_addrtype.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data_matches/net/ipv4/netfilter/ipt_addrtype.c	2006-06-21 01:09:57.000000000 +0200
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
diff -Nru linux-2.6.17.1-priv_data_core/net/ipv4/netfilter/ipt_ah.c linux-2.6.17.1-priv_data_matches/net/ipv4/netfilter/ipt_ah.c
--- linux-2.6.17.1-priv_data_core/net/ipv4/netfilter/ipt_ah.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data_matches/net/ipv4/netfilter/ipt_ah.c	2006-06-21 01:09:57.000000000 +0200
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
@@ -75,7 +76,8 @@
 	   const struct xt_match *match,
 	   void *matchinfo,
 	   unsigned int matchinfosize,
-	   unsigned int hook_mask)
+	   unsigned int hook_mask,
+	   void *priv_data)
 {
 	const struct ipt_ah *ahinfo = matchinfo;
 
diff -Nru linux-2.6.17.1-priv_data_core/net/ipv4/netfilter/ipt_dscp.c linux-2.6.17.1-priv_data_matches/net/ipv4/netfilter/ipt_dscp.c
--- linux-2.6.17.1-priv_data_core/net/ipv4/netfilter/ipt_dscp.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data_matches/net/ipv4/netfilter/ipt_dscp.c	2006-06-21 01:09:57.000000000 +0200
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
diff -Nru linux-2.6.17.1-priv_data_core/net/ipv4/netfilter/ipt_ecn.c linux-2.6.17.1-priv_data_matches/net/ipv4/netfilter/ipt_ecn.c
--- linux-2.6.17.1-priv_data_core/net/ipv4/netfilter/ipt_ecn.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data_matches/net/ipv4/netfilter/ipt_ecn.c	2006-06-21 01:09:57.000000000 +0200
@@ -68,7 +68,8 @@
 static int match(const struct sk_buff *skb,
 		 const struct net_device *in, const struct net_device *out,
 		 const struct xt_match *match, const void *matchinfo,
-		 int offset, unsigned int protoff, int *hotdrop)
+		 int offset, unsigned int protoff, int *hotdrop,
+		 void *priv_data)
 {
 	const struct ipt_ecn_info *info = matchinfo;
 
@@ -89,7 +90,7 @@
 static int checkentry(const char *tablename, const void *ip_void,
 		      const struct xt_match *match,
 		      void *matchinfo, unsigned int matchsize,
-		      unsigned int hook_mask)
+		      unsigned int hook_mask, void *priv_data)
 {
 	const struct ipt_ecn_info *info = matchinfo;
 	const struct ipt_ip *ip = ip_void;
diff -Nru linux-2.6.17.1-priv_data_core/net/ipv4/netfilter/ipt_hashlimit.c linux-2.6.17.1-priv_data_matches/net/ipv4/netfilter/ipt_hashlimit.c
--- linux-2.6.17.1-priv_data_core/net/ipv4/netfilter/ipt_hashlimit.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data_matches/net/ipv4/netfilter/ipt_hashlimit.c	2006-06-21 01:09:57.000000000 +0200
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
@@ -511,7 +512,8 @@
 		     const struct xt_match *match,
 		     void *matchinfo,
 		     unsigned int matchsize,
-		     unsigned int hook_mask)
+		     unsigned int hook_mask,
+		     void *priv_data)
 {
 	struct ipt_hashlimit_info *r = matchinfo;
 
@@ -559,7 +561,7 @@
 
 static void
 hashlimit_destroy(const struct xt_match *match, void *matchinfo,
-		  unsigned int matchsize)
+		  unsigned int matchsize, void *priv_data)
 {
 	struct ipt_hashlimit_info *r = (struct ipt_hashlimit_info *) matchinfo;
 
diff -Nru linux-2.6.17.1-priv_data_core/net/ipv4/netfilter/ipt_iprange.c linux-2.6.17.1-priv_data_matches/net/ipv4/netfilter/ipt_iprange.c
--- linux-2.6.17.1-priv_data_core/net/ipv4/netfilter/ipt_iprange.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data_matches/net/ipv4/netfilter/ipt_iprange.c	2006-06-21 01:09:57.000000000 +0200
@@ -29,7 +29,7 @@
       const struct net_device *out,
       const struct xt_match *match,
       const void *matchinfo,
-      int offset, unsigned int protoff, int *hotdrop)
+      int offset, unsigned int protoff, int *hotdrop, void *priv_data)
 {
 	const struct ipt_iprange_info *info = matchinfo;
 	const struct iphdr *iph = skb->nh.iph;
diff -Nru linux-2.6.17.1-priv_data_core/net/ipv4/netfilter/ipt_owner.c linux-2.6.17.1-priv_data_matches/net/ipv4/netfilter/ipt_owner.c
--- linux-2.6.17.1-priv_data_core/net/ipv4/netfilter/ipt_owner.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data_matches/net/ipv4/netfilter/ipt_owner.c	2006-06-21 01:09:57.000000000 +0200
@@ -29,7 +29,8 @@
       const void *matchinfo,
       int offset,
       unsigned int protoff,
-      int *hotdrop)
+      int *hotdrop,
+      void *priv_data)
 {
 	const struct ipt_owner_info *info = matchinfo;
 
@@ -57,7 +58,8 @@
 	   const struct xt_match *match,
            void *matchinfo,
            unsigned int matchsize,
-           unsigned int hook_mask)
+           unsigned int hook_mask,
+           void *priv_data)
 {
 	const struct ipt_owner_info *info = matchinfo;
 
diff -Nru linux-2.6.17.1-priv_data_core/net/ipv4/netfilter/ipt_recent.c linux-2.6.17.1-priv_data_matches/net/ipv4/netfilter/ipt_recent.c
--- linux-2.6.17.1-priv_data_core/net/ipv4/netfilter/ipt_recent.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data_matches/net/ipv4/netfilter/ipt_recent.c	2006-06-21 01:09:57.000000000 +0200
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
@@ -662,7 +664,8 @@
 	   const struct xt_match *match,
            void *matchinfo,
            unsigned int matchsize,
-           unsigned int hook_mask)
+           unsigned int hook_mask,
+           void *priv_data)
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
diff -Nru linux-2.6.17.1-priv_data_core/net/ipv4/netfilter/ipt_tos.c linux-2.6.17.1-priv_data_matches/net/ipv4/netfilter/ipt_tos.c
--- linux-2.6.17.1-priv_data_core/net/ipv4/netfilter/ipt_tos.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data_matches/net/ipv4/netfilter/ipt_tos.c	2006-06-21 01:09:57.000000000 +0200
@@ -25,7 +25,8 @@
       const void *matchinfo,
       int offset,
       unsigned int protoff,
-      int *hotdrop)
+      int *hotdrop,
+      void *priv_data)
 {
 	const struct ipt_tos_info *info = matchinfo;
 
diff -Nru linux-2.6.17.1-priv_data_core/net/ipv4/netfilter/ipt_ttl.c linux-2.6.17.1-priv_data_matches/net/ipv4/netfilter/ipt_ttl.c
--- linux-2.6.17.1-priv_data_core/net/ipv4/netfilter/ipt_ttl.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data_matches/net/ipv4/netfilter/ipt_ttl.c	2006-06-21 01:09:57.000000000 +0200
@@ -22,7 +22,8 @@
 static int match(const struct sk_buff *skb,
 		 const struct net_device *in, const struct net_device *out,
 		 const struct xt_match *match, const void *matchinfo,
-		 int offset, unsigned int protoff, int *hotdrop)
+		 int offset, unsigned int protoff, int *hotdrop,
+		 void *priv_data)
 {
 	const struct ipt_ttl_info *info = matchinfo;
 
diff -Nru linux-2.6.17.1-priv_data_core/net/ipv6/netfilter/ip6t_ah.c linux-2.6.17.1-priv_data_matches/net/ipv6/netfilter/ip6t_ah.c
--- linux-2.6.17.1-priv_data_core/net/ipv6/netfilter/ip6t_ah.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data_matches/net/ipv6/netfilter/ip6t_ah.c	2006-06-21 01:09:57.000000000 +0200
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
@@ -103,7 +104,8 @@
 	  const struct xt_match *match,
           void *matchinfo,
           unsigned int matchinfosize,
-          unsigned int hook_mask)
+          unsigned int hook_mask,
+          void *priv_data)
 {
 	const struct ip6t_ah *ahinfo = matchinfo;
 
diff -Nru linux-2.6.17.1-priv_data_core/net/ipv6/netfilter/ip6t_dst.c linux-2.6.17.1-priv_data_matches/net/ipv6/netfilter/ip6t_dst.c
--- linux-2.6.17.1-priv_data_core/net/ipv6/netfilter/ip6t_dst.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data_matches/net/ipv6/netfilter/ip6t_dst.c	2006-06-21 01:09:57.000000000 +0200
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
@@ -183,7 +184,8 @@
 	   const struct xt_match *match,
 	   void *matchinfo,
 	   unsigned int matchinfosize,
-	   unsigned int hook_mask)
+	   unsigned int hook_mask,
+	   void *priv_data)
 {
 	const struct ip6t_opts *optsinfo = matchinfo;
 
diff -Nru linux-2.6.17.1-priv_data_core/net/ipv6/netfilter/ip6t_eui64.c linux-2.6.17.1-priv_data_matches/net/ipv6/netfilter/ip6t_eui64.c
--- linux-2.6.17.1-priv_data_core/net/ipv6/netfilter/ip6t_eui64.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data_matches/net/ipv6/netfilter/ip6t_eui64.c	2006-06-21 01:09:57.000000000 +0200
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
diff -Nru linux-2.6.17.1-priv_data_core/net/ipv6/netfilter/ip6t_frag.c linux-2.6.17.1-priv_data_matches/net/ipv6/netfilter/ip6t_frag.c
--- linux-2.6.17.1-priv_data_core/net/ipv6/netfilter/ip6t_frag.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data_matches/net/ipv6/netfilter/ip6t_frag.c	2006-06-21 01:09:57.000000000 +0200
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
@@ -120,7 +121,8 @@
 	   const struct xt_match *match,
 	   void *matchinfo,
 	   unsigned int matchinfosize,
-	   unsigned int hook_mask)
+	   unsigned int hook_mask,
+	   void *priv_data)
 {
 	const struct ip6t_frag *fraginfo = matchinfo;
 
diff -Nru linux-2.6.17.1-priv_data_core/net/ipv6/netfilter/ip6t_hbh.c linux-2.6.17.1-priv_data_matches/net/ipv6/netfilter/ip6t_hbh.c
--- linux-2.6.17.1-priv_data_core/net/ipv6/netfilter/ip6t_hbh.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data_matches/net/ipv6/netfilter/ip6t_hbh.c	2006-06-21 01:09:57.000000000 +0200
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
@@ -183,7 +184,8 @@
 	   const struct xt_match *match,
 	   void *matchinfo,
 	   unsigned int matchinfosize,
-	   unsigned int hook_mask)
+	   unsigned int hook_mask,
+	   void *priv_data)
 {
 	const struct ip6t_opts *optsinfo = matchinfo;
 
diff -Nru linux-2.6.17.1-priv_data_core/net/ipv6/netfilter/ip6t_hl.c linux-2.6.17.1-priv_data_matches/net/ipv6/netfilter/ip6t_hl.c
--- linux-2.6.17.1-priv_data_core/net/ipv6/netfilter/ip6t_hl.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data_matches/net/ipv6/netfilter/ip6t_hl.c	2006-06-21 01:09:57.000000000 +0200
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
diff -Nru linux-2.6.17.1-priv_data_core/net/ipv6/netfilter/ip6t_ipv6header.c linux-2.6.17.1-priv_data_matches/net/ipv6/netfilter/ip6t_ipv6header.c
--- linux-2.6.17.1-priv_data_core/net/ipv6/netfilter/ip6t_ipv6header.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data_matches/net/ipv6/netfilter/ip6t_ipv6header.c	2006-06-21 01:09:57.000000000 +0200
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
@@ -129,7 +130,8 @@
 		      const struct xt_match *match,
 		      void *matchinfo,
 		      unsigned int matchsize,
-		      unsigned int hook_mask)
+		      unsigned int hook_mask,
+		      void *priv_data)
 {
 	const struct ip6t_ipv6header_info *info = matchinfo;
 
diff -Nru linux-2.6.17.1-priv_data_core/net/ipv6/netfilter/ip6t_owner.c linux-2.6.17.1-priv_data_matches/net/ipv6/netfilter/ip6t_owner.c
--- linux-2.6.17.1-priv_data_core/net/ipv6/netfilter/ip6t_owner.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data_matches/net/ipv6/netfilter/ip6t_owner.c	2006-06-21 01:09:57.000000000 +0200
@@ -30,7 +30,8 @@
       const void *matchinfo,
       int offset,
       unsigned int protoff,
-      int *hotdrop)
+      int *hotdrop,
+      void *priv_data)
 {
 	const struct ip6t_owner_info *info = matchinfo;
 
@@ -58,7 +59,8 @@
 	   const struct xt_match *match,
 	   void *matchinfo,
 	   unsigned int matchsize,
-	   unsigned int hook_mask)
+	   unsigned int hook_mask,
+	   void *priv_data)
 {
 	const struct ip6t_owner_info *info = matchinfo;
 
diff -Nru linux-2.6.17.1-priv_data_core/net/ipv6/netfilter/ip6t_rt.c linux-2.6.17.1-priv_data_matches/net/ipv6/netfilter/ip6t_rt.c
--- linux-2.6.17.1-priv_data_core/net/ipv6/netfilter/ip6t_rt.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data_matches/net/ipv6/netfilter/ip6t_rt.c	2006-06-21 01:09:57.000000000 +0200
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
@@ -198,7 +199,8 @@
 	   const struct xt_match *match,
 	   void *matchinfo,
 	   unsigned int matchinfosize,
-	   unsigned int hook_mask)
+	   unsigned int hook_mask,
+	   void *priv_data)
 {
 	const struct ip6t_rt *rtinfo = matchinfo;
 
diff -Nru linux-2.6.17.1-priv_data_core/net/netfilter/xt_comment.c linux-2.6.17.1-priv_data_matches/net/netfilter/xt_comment.c
--- linux-2.6.17.1-priv_data_core/net/netfilter/xt_comment.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data_matches/net/netfilter/xt_comment.c	2006-06-21 01:09:57.000000000 +0200
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
diff -Nru linux-2.6.17.1-priv_data_core/net/netfilter/xt_connbytes.c linux-2.6.17.1-priv_data_matches/net/netfilter/xt_connbytes.c
--- linux-2.6.17.1-priv_data_core/net/netfilter/xt_connbytes.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data_matches/net/netfilter/xt_connbytes.c	2006-06-21 01:09:57.000000000 +0200
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
@@ -126,7 +127,8 @@
 		 const struct xt_match *match,
 		 void *matchinfo,
 		 unsigned int matchsize,
-		 unsigned int hook_mask)
+		 unsigned int hook_mask,
+		 void *priv_data)
 {
 	const struct xt_connbytes_info *sinfo = matchinfo;
 
diff -Nru linux-2.6.17.1-priv_data_core/net/netfilter/xt_connmark.c linux-2.6.17.1-priv_data_matches/net/netfilter/xt_connmark.c
--- linux-2.6.17.1-priv_data_core/net/netfilter/xt_connmark.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data_matches/net/netfilter/xt_connmark.c	2006-06-21 01:09:57.000000000 +0200
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
@@ -56,7 +57,8 @@
 	   const struct xt_match *match,
 	   void *matchinfo,
 	   unsigned int matchsize,
-	   unsigned int hook_mask)
+	   unsigned int hook_mask,
+	   void *priv_data)
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
diff -Nru linux-2.6.17.1-priv_data_core/net/netfilter/xt_conntrack.c linux-2.6.17.1-priv_data_matches/net/netfilter/xt_conntrack.c
--- linux-2.6.17.1-priv_data_core/net/netfilter/xt_conntrack.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data_matches/net/netfilter/xt_conntrack.c	2006-06-21 01:09:57.000000000 +0200
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
@@ -209,7 +211,8 @@
 	   const struct xt_match *match,
 	   void *matchinfo,
 	   unsigned int matchsize,
-	   unsigned int hook_mask)
+	   unsigned int hook_mask,
+	   void *priv_data)
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
diff -Nru linux-2.6.17.1-priv_data_core/net/netfilter/xt_dccp.c linux-2.6.17.1-priv_data_matches/net/netfilter/xt_dccp.c
--- linux-2.6.17.1-priv_data_core/net/netfilter/xt_dccp.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data_matches/net/netfilter/xt_dccp.c	2006-06-21 01:09:57.000000000 +0200
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
@@ -133,7 +134,8 @@
 	   const struct xt_match *match,
 	   void *matchinfo,
 	   unsigned int matchsize,
-	   unsigned int hook_mask)
+	   unsigned int hook_mask,
+	   void *priv_data)
 {
 	const struct xt_dccp_info *info = matchinfo;
 
diff -Nru linux-2.6.17.1-priv_data_core/net/netfilter/xt_esp.c linux-2.6.17.1-priv_data_matches/net/netfilter/xt_esp.c
--- linux-2.6.17.1-priv_data_core/net/netfilter/xt_esp.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data_matches/net/netfilter/xt_esp.c	2006-06-21 01:09:57.000000000 +0200
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
@@ -80,7 +81,8 @@
 	   const struct xt_match *match,
 	   void *matchinfo,
 	   unsigned int matchinfosize,
-	   unsigned int hook_mask)
+	   unsigned int hook_mask,
+	   void *priv_data)
 {
 	const struct xt_esp *espinfo = matchinfo;
 
diff -Nru linux-2.6.17.1-priv_data_core/net/netfilter/xt_helper.c linux-2.6.17.1-priv_data_matches/net/netfilter/xt_helper.c
--- linux-2.6.17.1-priv_data_core/net/netfilter/xt_helper.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data_matches/net/netfilter/xt_helper.c	2006-06-21 01:09:57.000000000 +0200
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
@@ -140,7 +142,8 @@
 		 const struct xt_match *match,
 		 void *matchinfo,
 		 unsigned int matchsize,
-		 unsigned int hook_mask)
+		 unsigned int hook_mask,
+		 void *priv_data)
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
diff -Nru linux-2.6.17.1-priv_data_core/net/netfilter/xt_length.c linux-2.6.17.1-priv_data_matches/net/netfilter/xt_length.c
--- linux-2.6.17.1-priv_data_core/net/netfilter/xt_length.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data_matches/net/netfilter/xt_length.c	2006-06-21 01:09:57.000000000 +0200
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
diff -Nru linux-2.6.17.1-priv_data_core/net/netfilter/xt_limit.c linux-2.6.17.1-priv_data_matches/net/netfilter/xt_limit.c
--- linux-2.6.17.1-priv_data_core/net/netfilter/xt_limit.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data_matches/net/netfilter/xt_limit.c	2006-06-21 01:09:57.000000000 +0200
@@ -72,7 +72,8 @@
 		const void *matchinfo,
 		int offset,
 		unsigned int protoff,
-		int *hotdrop)
+		int *hotdrop,
+		void *priv_data)
 {
 	struct xt_rateinfo *r = ((struct xt_rateinfo *)matchinfo)->master;
 	unsigned long now = jiffies;
@@ -111,7 +112,8 @@
 		     const struct xt_match *match,
 		     void *matchinfo,
 		     unsigned int matchsize,
-		     unsigned int hook_mask)
+		     unsigned int hook_mask,
+		     void *priv_data)
 {
 	struct xt_rateinfo *r = matchinfo;
 
diff -Nru linux-2.6.17.1-priv_data_core/net/netfilter/xt_mac.c linux-2.6.17.1-priv_data_matches/net/netfilter/xt_mac.c
--- linux-2.6.17.1-priv_data_core/net/netfilter/xt_mac.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data_matches/net/netfilter/xt_mac.c	2006-06-21 01:09:57.000000000 +0200
@@ -31,7 +31,8 @@
       const void *matchinfo,
       int offset,
       unsigned int protoff,
-      int *hotdrop)
+      int *hotdrop,
+      void *priv_data)
 {
     const struct xt_mac_info *info = matchinfo;
 
diff -Nru linux-2.6.17.1-priv_data_core/net/netfilter/xt_mark.c linux-2.6.17.1-priv_data_matches/net/netfilter/xt_mark.c
--- linux-2.6.17.1-priv_data_core/net/netfilter/xt_mark.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data_matches/net/netfilter/xt_mark.c	2006-06-21 01:09:57.000000000 +0200
@@ -27,7 +27,8 @@
       const void *matchinfo,
       int offset,
       unsigned int protoff,
-      int *hotdrop)
+      int *hotdrop,
+      void *priv_data)
 {
 	const struct xt_mark_info *info = matchinfo;
 
@@ -40,7 +41,8 @@
 	   const struct xt_match *match,
            void *matchinfo,
            unsigned int matchsize,
-           unsigned int hook_mask)
+           unsigned int hook_mask,
+           void *priv_data)
 {
 	struct xt_mark_info *minfo = (struct xt_mark_info *) matchinfo;
 
diff -Nru linux-2.6.17.1-priv_data_core/net/netfilter/xt_multiport.c linux-2.6.17.1-priv_data_matches/net/netfilter/xt_multiport.c
--- linux-2.6.17.1-priv_data_core/net/netfilter/xt_multiport.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data_matches/net/netfilter/xt_multiport.c	2006-06-21 01:09:57.000000000 +0200
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
@@ -176,7 +178,8 @@
 	   const struct xt_match *match,
 	   void *matchinfo,
 	   unsigned int matchsize,
-	   unsigned int hook_mask)
+	   unsigned int hook_mask,
+	   void *priv_data)
 {
 	const struct ipt_ip *ip = info;
 	const struct xt_multiport *multiinfo = matchinfo;
@@ -191,7 +194,8 @@
 	      const struct xt_match *match,
 	      void *matchinfo,
 	      unsigned int matchsize,
-	      unsigned int hook_mask)
+	      unsigned int hook_mask,
+	      void *priv_data)
 {
 	const struct ipt_ip *ip = info;
 	const struct xt_multiport_v1 *multiinfo = matchinfo;
@@ -206,7 +210,8 @@
 	    const struct xt_match *match,
 	    void *matchinfo,
 	    unsigned int matchsize,
-	    unsigned int hook_mask)
+	    unsigned int hook_mask,
+	    void *priv_data)
 {
 	const struct ip6t_ip6 *ip = info;
 	const struct xt_multiport *multiinfo = matchinfo;
@@ -221,7 +226,8 @@
 	       const struct xt_match *match,
 	       void *matchinfo,
 	       unsigned int matchsize,
-	       unsigned int hook_mask)
+	       unsigned int hook_mask,
+	       void *priv_data)
 {
 	const struct ip6t_ip6 *ip = info;
 	const struct xt_multiport_v1 *multiinfo = matchinfo;
diff -Nru linux-2.6.17.1-priv_data_core/net/netfilter/xt_physdev.c linux-2.6.17.1-priv_data_matches/net/netfilter/xt_physdev.c
--- linux-2.6.17.1-priv_data_core/net/netfilter/xt_physdev.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data_matches/net/netfilter/xt_physdev.c	2006-06-21 01:09:57.000000000 +0200
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
@@ -106,7 +107,8 @@
 		       const struct xt_match *match,
 		       void *matchinfo,
 		       unsigned int matchsize,
-		       unsigned int hook_mask)
+		       unsigned int hook_mask,
+		       void *priv_data)
 {
 	const struct xt_physdev_info *info = matchinfo;
 
diff -Nru linux-2.6.17.1-priv_data_core/net/netfilter/xt_pkttype.c linux-2.6.17.1-priv_data_matches/net/netfilter/xt_pkttype.c
--- linux-2.6.17.1-priv_data_core/net/netfilter/xt_pkttype.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data_matches/net/netfilter/xt_pkttype.c	2006-06-21 01:09:57.000000000 +0200
@@ -26,7 +26,8 @@
       const void *matchinfo,
       int offset,
       unsigned int protoff,
-      int *hotdrop)
+      int *hotdrop,
+      void *priv_data)
 {
 	const struct xt_pkttype_info *info = matchinfo;
 
diff -Nru linux-2.6.17.1-priv_data_core/net/netfilter/xt_policy.c linux-2.6.17.1-priv_data_matches/net/netfilter/xt_policy.c
--- linux-2.6.17.1-priv_data_core/net/netfilter/xt_policy.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data_matches/net/netfilter/xt_policy.c	2006-06-21 01:09:57.000000000 +0200
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
@@ -137,7 +138,7 @@
 static int checkentry(const char *tablename, const void *ip_void,
                       const struct xt_match *match,
                       void *matchinfo, unsigned int matchsize,
-                      unsigned int hook_mask)
+                      unsigned int hook_mask, void *priv_data)
 {
 	struct xt_policy_info *info = matchinfo;
 
diff -Nru linux-2.6.17.1-priv_data_core/net/netfilter/xt_realm.c linux-2.6.17.1-priv_data_matches/net/netfilter/xt_realm.c
--- linux-2.6.17.1-priv_data_core/net/netfilter/xt_realm.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data_matches/net/netfilter/xt_realm.c	2006-06-21 01:09:57.000000000 +0200
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
diff -Nru linux-2.6.17.1-priv_data_core/net/netfilter/xt_sctp.c linux-2.6.17.1-priv_data_matches/net/netfilter/xt_sctp.c
--- linux-2.6.17.1-priv_data_core/net/netfilter/xt_sctp.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data_matches/net/netfilter/xt_sctp.c	2006-06-21 01:09:57.000000000 +0200
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
@@ -166,7 +167,8 @@
 	   const struct xt_match *match,
 	   void *matchinfo,
 	   unsigned int matchsize,
-	   unsigned int hook_mask)
+	   unsigned int hook_mask,
+	   void *priv_data)
 {
 	const struct xt_sctp_info *info = matchinfo;
 
diff -Nru linux-2.6.17.1-priv_data_core/net/netfilter/xt_state.c linux-2.6.17.1-priv_data_matches/net/netfilter/xt_state.c
--- linux-2.6.17.1-priv_data_core/net/netfilter/xt_state.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data_matches/net/netfilter/xt_state.c	2006-06-21 01:09:57.000000000 +0200
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
@@ -49,7 +50,8 @@
 		 const struct xt_match *match,
 		 void *matchinfo,
 		 unsigned int matchsize,
-		 unsigned int hook_mask)
+		 unsigned int hook_mask,
+		 void *priv_data)
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
diff -Nru linux-2.6.17.1-priv_data_core/net/netfilter/xt_string.c linux-2.6.17.1-priv_data_matches/net/netfilter/xt_string.c
--- linux-2.6.17.1-priv_data_core/net/netfilter/xt_string.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data_matches/net/netfilter/xt_string.c	2006-06-21 01:09:57.000000000 +0200
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
@@ -47,7 +48,8 @@
 		      const struct xt_match *match,
 		      void *matchinfo,
 		      unsigned int matchsize,
-		      unsigned int hook_mask)
+		      unsigned int hook_mask,
+		      void *priv_data)
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
diff -Nru linux-2.6.17.1-priv_data_core/net/netfilter/xt_tcpmss.c linux-2.6.17.1-priv_data_matches/net/netfilter/xt_tcpmss.c
--- linux-2.6.17.1-priv_data_core/net/netfilter/xt_tcpmss.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data_matches/net/netfilter/xt_tcpmss.c	2006-06-21 01:09:57.000000000 +0200
@@ -85,7 +85,8 @@
       const void *matchinfo,
       int offset,
       unsigned int protoff,
-      int *hotdrop)
+      int *hotdrop,
+      void *priv_data)
 {
 	const struct xt_tcpmss_match_info *info = matchinfo;
 
diff -Nru linux-2.6.17.1-priv_data_core/net/netfilter/xt_tcpudp.c linux-2.6.17.1-priv_data_matches/net/netfilter/xt_tcpudp.c
--- linux-2.6.17.1-priv_data_core/net/netfilter/xt_tcpudp.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data_matches/net/netfilter/xt_tcpudp.c	2006-06-21 01:09:57.000000000 +0200
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
@@ -142,7 +143,8 @@
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
@@ -191,7 +194,8 @@
 	       const struct xt_match *match,
 	       void *matchinfo,
 	       unsigned int matchsize,
-	       unsigned int hook_mask)
+	       unsigned int hook_mask,
+	       void *priv_data)
 {
 	const struct xt_tcp *udpinfo = matchinfo;
 

--Boundary-00=_VzImEgS2SKbCq3t--
