From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 79/79: xtables: remove bogus mangle table dependency of connmark
Date: Wed,  8 Oct 2008 12:48:08 +0200 (MEST)
Message-ID: <20081008104808.10423.60730.sendpatchset@x2.localnet>
References: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46112 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754899AbYJHKsJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Oct 2008 06:48:09 -0400
In-Reply-To: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit f39a9410ed0503278fd5edc559fa019051413039
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Wed Oct 8 11:35:20 2008 +0200

    netfilter: xtables: remove bogus mangle table dependency of connmark
    
    Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 899e780..f70b414 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -318,7 +318,6 @@ config NETFILTER_XT_TARGET_CLASSIFY
 
 config NETFILTER_XT_TARGET_CONNMARK
 	tristate  '"CONNMARK" target support'
-	depends on IP_NF_MANGLE || IP6_NF_MANGLE
 	depends on NF_CONNTRACK
 	depends on NETFILTER_ADVANCED
 	select NF_CONNTRACK_MARK
