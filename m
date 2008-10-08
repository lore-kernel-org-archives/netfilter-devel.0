From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 65/79: ip6tables: fix name of hopbyhop in Kconfig
Date: Wed,  8 Oct 2008 12:47:49 +0200 (MEST)
Message-ID: <20081008104748.10423.16257.sendpatchset@x2.localnet>
References: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46055 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754765AbYJHKrt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Oct 2008 06:47:49 -0400
In-Reply-To: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 77d7358995489bf354fb4f65f4528e47980ffb08
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Wed Oct 8 11:35:17 2008 +0200

    netfilter: ip6tables: fix name of hopbyhop in Kconfig
    
    The module is called hbh, not hopbyhop.
    
    Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index 0cfcce7..f244324 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -67,7 +67,7 @@ config IP6_NF_MATCH_RT
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config IP6_NF_MATCH_OPTS
-	tristate '"hopbyhop" and "dst" opts header match support'
+	tristate '"hbh" hop-by-hop and "dst" opts header match support'
 	depends on IP6_NF_IPTABLES
 	depends on NETFILTER_ADVANCED
 	help
