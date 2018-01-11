From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: clusterip: make sure arp hooks are available
Date: Thu, 11 Jan 2018 09:21:29 +0100
Message-ID: <20180111082129.18782-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:55826 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753843AbeAKIdj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 Jan 2018 03:33:39 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The clusterip target needs to register an arp mangling hook,
so make sure NF_ARP hooks are available.

Fixes: 2a95183a5e ("netfilter: don't allocate space for arp/bridge hooks unless needed")
Reported-by: kernel test robot <fengguang.wu@intel.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/netfilter/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 7d5d444964aa..08742da63dd5 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -342,6 +342,7 @@ config IP_NF_TARGET_CLUSTERIP
 	depends on NF_CONNTRACK_IPV4
 	depends on NETFILTER_ADVANCED
 	select NF_CONNTRACK_MARK
+	select NETFILTER_FAMILY_ARP
 	help
 	  The CLUSTERIP target allows you to build load-balancing clusters of
 	  network servers without having a dedicated load-balancing
-- 
2.13.6

