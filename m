From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] ipv6 ROUTE target api changes
Date: Wed, 2 Aug 2006 16:49:33 -0700
Message-ID: <20060802234933.GA1183@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="3MwIy2ne0vdjdPXF"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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


--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

My recent .targetsize patch missed the other API changes in the IPv6
ROUTE target.  

This resolves bugzilla #490 (again).

Phil


--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-ROUTE-try2

diff -ru pom-orig/patchlets/ROUTE/linux-2.6/net/ipv6/netfilter/ip6t_ROUTE.c pom-new/patchlets/ROUTE/linux-2.6/net/ipv6/netfilter/ip6t_ROUTE.c
--- pom-orig/patchlets/ROUTE/linux-2.6/net/ipv6/netfilter/ip6t_ROUTE.c	2006-07-22 10:07:52.000000000 -0400
+++ pom-new/patchlets/ROUTE/linux-2.6/net/ipv6/netfilter/ip6t_ROUTE.c	2006-08-02 19:46:04.000000000 -0400
@@ -192,6 +192,7 @@
 		  const struct net_device *in,
 		  const struct net_device *out,
 		  unsigned int hooknum,
+		  const struct xt_target *target,
 		  const void *targinfo,
 		  void *userinfo)
 {
@@ -259,7 +260,8 @@
 
 static int 
 ip6t_route_checkentry(const char *tablename,
-		      const struct ip6t_entry *e,
+		      const void *entry,
+		      const struct xt_target *target,
 		      void *targinfo,
 		      unsigned int targinfosize,
 		      unsigned int hook_mask)

--3MwIy2ne0vdjdPXF--
