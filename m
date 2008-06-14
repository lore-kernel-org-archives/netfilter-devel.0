From: Russ Dill <russ.dill@gmail.com>
Subject: [PATCH] Get rid of refrences to no longer existant Fast NAT.
Date: Fri, 13 Jun 2008 17:24:18 -0700
Message-ID: <1213403058.28235.1.camel@russ-laptop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.229]:56982 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764088AbYFNAYz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Jun 2008 20:24:55 -0400
Received: by rv-out-0506.google.com with SMTP id k40so2783174rvb.1
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Jun 2008 17:24:55 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

IP_ROUTE_NAT support was removed in August of 2004, but references to Fast
NAT were left in a couple of config options.

Signed-off-by: Russ Dill <Russ.Dill@gmail.com>
---
 net/ipv4/netfilter/Kconfig |    3 +--
 net/netfilter/Kconfig      |    5 ++---
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 2767841..3d566a0 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -213,8 +213,7 @@ config IP_NF_TARGET_NETMAP
 	help
 	  NETMAP is an implementation of static 1:1 NAT mapping of network
 	  addresses. It maps the network address part, while keeping the host
-	  address part intact. It is similar to Fast NAT, except that
-	  Netfilter's connection tracking doesn't work well with Fast NAT.
+	  address part intact.
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index aa8d80c..316c7af 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -33,9 +33,8 @@ config NF_CONNTRACK
 	  into connections.
 
 	  This is required to do Masquerading or other kinds of Network
-	  Address Translation (except for Fast NAT).  It can also be used to
-	  enhance packet filtering (see `Connection state match support'
-	  below).
+	  Address Translation.  It can also be used to enhance packet
+	  filtering (see `Connection state match support' below).
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
-- 
1.5.4.3



