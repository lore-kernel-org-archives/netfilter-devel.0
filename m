From: Cedric de Launois <delaunois@info.ucl.ac.be>
Subject: [PATCH] ROUTE patch, oops forgot it ;)
Date: Wed, 10 Nov 2004 17:36:44 +0100
Message-ID: <1100104604.1748.98.camel@descartes.info.ucl.ac.be>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-4gY1Gu3wJE8hP8jhS9lN"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>
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


--=-4gY1Gu3wJE8hP8jhS9lN
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Sorry, I forgot to attach it...

--=-4gY1Gu3wJE8hP8jhS9lN
Content-Disposition: attachment; filename=ipt_ROUTE-fl4_dst-fix.patch
Content-Type: text/x-patch; name=ipt_ROUTE-fl4_dst-fix.patch;
	charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

--- patch-o-matic-ng.orig/ROUTE/linux-2.6/net/ipv4/netfilter/ipt_ROUTE.c	2004-11-10 17:12:35.000000000 +0100
+++ patch-o-matic-ng/ROUTE/linux-2.6/net/ipv4/netfilter/ipt_ROUTE.c	2004-11-10 17:14:50.000000000 +0100
@@ -4,7 +4,7 @@
  *
  * Copyright (C) 2002 Cedric de Launois <delaunois@info.ucl.ac.be>
  *
- * v 1.9 2004/05/14
+ * v 1.10 2004/11/10
  *
  * This software is distributed under GNU GPL v2, 1991
  */
@@ -69,7 +69,7 @@
 	
 	/* The destination address may be overloaded by the target */
 	if (route_info->gw)
-		fl.fld_dst = route_info->gw;
+		fl.fl4_dst = route_info->gw;
 	
 	/* Trying to route the packet using the standard routing table. */
 	if ((err = ip_route_output_key(&rt, &fl))) {

--=-4gY1Gu3wJE8hP8jhS9lN--
