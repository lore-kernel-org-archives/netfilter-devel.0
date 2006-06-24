From: Torsten Luettgert <t.luettgert@pressestimmen.de>
Subject: [PATCH] 2.6.17 API changes for ROUTE, u32, set
Date: Sat, 24 Jun 2006 15:51:05 +0200
Message-ID: <1151157065.29998.26.camel@scaramouche.combox.de>
References: <1151096311.3421.10.camel@murdegern.hindenburgdamm.example>
	<449D2F69.5090909@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-0wtUO55sSJLm8anb6e2i"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <449D2F69.5090909@trash.net>
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


--=-0wtUO55sSJLm8anb6e2i
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Sa, 2006-06-24 at 14:26 +0200, Patrick McHardy wrote:
> Sure, just send them along as normal diffs. But please no new
> directories, we decided to keep only a single version of things
> in pomng that runs with the latest kernel.

Here are the patches for ROUTE, u32, and set.

Regards,
Torsten


--=-0wtUO55sSJLm8anb6e2i
Content-Disposition: attachment; filename=ROUTE.patch
Content-Type: text/x-patch; name=ROUTE.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

Index: ROUTE/linux-2.6/net/ipv4/netfilter/ipt_ROUTE.c
===================================================================
--- ROUTE/linux-2.6/net/ipv4/netfilter/ipt_ROUTE.c	(revision 6631)
+++ ROUTE/linux-2.6/net/ipv4/netfilter/ipt_ROUTE.c	(working copy)
@@ -280,6 +280,7 @@
 				     const struct net_device *in,
 				     const struct net_device *out,
 				     unsigned int hooknum,
+				     const struct xt_target *target,
 				     const void *targinfo,
 				     void *userinfo)
 {
@@ -401,6 +402,7 @@
 
 static int ipt_route_checkentry(const char *tablename,
 				const void *e,
+				const struct xt_target *target,
 				void *targinfo,
 				unsigned int targinfosize,
 				unsigned int hook_mask)

--=-0wtUO55sSJLm8anb6e2i
Content-Disposition: attachment; filename=set.patch
Content-Type: text/x-patch; name=set.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

Index: set/linux-2.6/net/ipv4/netfilter/ipt_SET.c
===================================================================
--- set/linux-2.6/net/ipv4/netfilter/ipt_SET.c	(revision 6631)
+++ set/linux-2.6/net/ipv4/netfilter/ipt_SET.c	(working copy)
@@ -29,6 +29,7 @@
        const struct net_device *in,
        const struct net_device *out,
        unsigned int hooknum,
+       const struct xt_target *target,
        const void *targinfo,
        void *userinfo)
 {
@@ -48,7 +49,8 @@
 
 static int
 checkentry(const char *tablename,
-	   const struct ipt_entry *e,
+	   const void *e,
+	   const struct xt_target *target,
 	   void *targinfo,
 	   unsigned int targinfosize, unsigned int hook_mask)
 {
@@ -87,7 +89,9 @@
 	return 1;
 }
 
-static void destroy(void *targetinfo, unsigned int targetsize)
+static void destroy(const struct xt_target *target,
+                    void *targetinfo,
+                    unsigned int targetsize)
 {
 	struct ipt_set_info_target *info = targetinfo;
 
Index: set/linux-2.6/net/ipv4/netfilter/ipt_set.c
===================================================================
--- set/linux-2.6/net/ipv4/netfilter/ipt_set.c	(revision 6631)
+++ set/linux-2.6/net/ipv4/netfilter/ipt_set.c	(working copy)
@@ -32,8 +32,10 @@
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
+      const struct xt_match *match,
       const void *matchinfo,
       int offset,
+      unsigned int protoff,
       int *hotdrop)
 {
 	const struct ipt_set_info_match *info = matchinfo;
@@ -45,7 +47,8 @@
 
 static int
 checkentry(const char *tablename,
-	   const struct ipt_ip *ip,
+	   const void *ip,
+	   const struct xt_match *match,
 	   void *matchinfo,
 	   unsigned int matchsize,
 	   unsigned int hook_mask)
@@ -74,7 +77,9 @@
 	return 1;
 }
 
-static void destroy(void *matchinfo, unsigned int matchsize)
+static void destroy(const struct xt_match *match,
+                    void *matchinfo,
+                    unsigned int matchsize)
 {
 	struct ipt_set_info_match *info = matchinfo;
 

--=-0wtUO55sSJLm8anb6e2i
Content-Disposition: attachment; filename=u32.patch
Content-Type: text/x-patch; name=u32.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

Index: u32/linux-2.6/net/ipv4/netfilter/ipt_u32.c
===================================================================
--- u32/linux-2.6/net/ipv4/netfilter/ipt_u32.c	(revision 6631)
+++ u32/linux-2.6/net/ipv4/netfilter/ipt_u32.c	(working copy)
@@ -120,6 +120,7 @@
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
+      const struct xt_match *match,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
@@ -203,6 +204,7 @@
 static int
 checkentry(const char *tablename,
            const void *ip,
+           const struct xt_match *match,
            void *matchinfo,
            unsigned int matchsize,
            unsigned int hook_mask)

--=-0wtUO55sSJLm8anb6e2i--
