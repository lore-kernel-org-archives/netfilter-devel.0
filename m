From: Pawel Sikora <pluto@pld-linux.org>
Subject: [PATCH] Warning: "nd_tbl" [net/ipv6/netfilter/ip6t_ROUTE.ko]
	undefined!
Date: Fri, 22 Apr 2005 13:31:27 +0200
Message-ID: <200504221331.27454.pluto@pld-linux.org>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_PCOaCbIMaM+6wx1"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Developers <netfilter-devel@lists.netfilter.org>
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

--Boundary-00=_PCOaCbIMaM+6wx1
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

Please apply attached patch.

Regards,
Pawel.

-- 
/* Copyright (C) 2003, SCO, Inc. This is valuable Intellectual Property. */

                           #define say(x) lie(x)

--Boundary-00=_PCOaCbIMaM+6wx1
Content-Type: text/x-diff;
  charset="utf-8";
  name="nd_tbl.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="nd_tbl.patch"

Warning: "nd_tbl" [net/ipv6/netfilter/ip6t_ROUTE.ko] undefined!

--- a/net/ipv6/ipv6_syms.c	2005-04-22 13:18:01.000000000 +0200
+++ b/net/ipv6/ipv6_syms.c	2005-04-22 13:21:28.000000000 +0200
@@ -36,6 +36,7 @@
 #ifdef CONFIG_XFRM
 EXPORT_SYMBOL(xfrm6_rcv);
 #endif
+EXPORT_SYMBOL(nd_tbl);
 EXPORT_SYMBOL(rt6_lookup);
 EXPORT_SYMBOL(fl6_sock_lookup);
 EXPORT_SYMBOL(ipv6_push_nfrag_opts);

--Boundary-00=_PCOaCbIMaM+6wx1--
