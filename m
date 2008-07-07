From: Patrick McHardy <kaber@trash.net>
Subject: Get rid of refrences to no longer existant Fast NAT.
Date: Mon,  7 Jul 2008 14:05:17 +0200 (MEST)
Message-ID: <20080707120516.4975.88905.sendpatchset@localhost.localdomain>
References: <20080707120514.4975.88670.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58370 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531AbYGGMFT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Jul 2008 08:05:19 -0400
In-Reply-To: <20080707120514.4975.88670.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Get rid of refrences to no longer existant Fast NAT.

IP_ROUTE_NAT support was removed in August of 2004, but references to Fast
NAT were left in a couple of config options.

Signed-off-by: Russ Dill <Russ.Dill@gmail.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 8b373c6315ac2b28c32ba26fd24a47b28d489b0b
tree 718165eb921842684bba4015726fa485d263bb18
parent 1efb97e64956296424507f66dd8af9861f98ad89
author Russ Dill <russ.dill@gmail.com> Mon, 07 Jul 2008 13:00:15 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 07 Jul 2008 13:00:15 +0200

 net/ipv4/netfilter/Kconfig |    3 +--
 net/netfilter/Kconfig      |    5 ++---
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 6e25140..f23e60c 100644
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
 
