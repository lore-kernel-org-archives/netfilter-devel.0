From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 15/32] netfilter: clusterip: make sure arp hooks are available
Date: Fri, 19 Jan 2018 20:10:24 +0100
Message-ID: <20180119191041.25804-16-pablo@netfilter.org>
References: <20180119191041.25804-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180119191041.25804-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

The clusterip target needs to register an arp mangling hook,
so make sure NF_ARP hooks are available.

Fixes: 2a95183a5e ("netfilter: don't allocate space for arp/bridge hooks unless needed")
Reported-by: kernel test robot <fengguang.wu@intel.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 3ad46a90b0fc..f28b08819f89 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -343,6 +343,7 @@ config IP_NF_TARGET_CLUSTERIP
 	depends on NF_CONNTRACK_IPV4
 	depends on NETFILTER_ADVANCED
 	select NF_CONNTRACK_MARK
+	select NETFILTER_FAMILY_ARP
 	help
 	  The CLUSTERIP target allows you to build load-balancing clusters of
 	  network servers without having a dedicated load-balancing
-- 
2.11.0
