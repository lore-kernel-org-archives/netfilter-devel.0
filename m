From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 15/51] netfilter: nf_flow_table: relax mixed ipv4/ipv6 flowtable dependencies
Date: Mon,  7 May 2018 00:46:33 +0200
Message-ID: <20180506224709.29100-16-pablo@netfilter.org>
References: <20180506224709.29100-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180506224709.29100-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

Since the offload hook code was moved, this table no longer depends on
the IPv4 and IPv6 flowtable modules

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/Kconfig | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 704b3832dbad..d20664b02ae4 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -666,8 +666,7 @@ endif # NF_TABLES
 
 config NF_FLOW_TABLE_INET
 	tristate "Netfilter flow table mixed IPv4/IPv6 module"
-	depends on NF_FLOW_TABLE_IPV4
-	depends on NF_FLOW_TABLE_IPV6
+	depends on NF_FLOW_TABLE
 	help
           This option adds the flow table mixed IPv4/IPv6 support.
 
-- 
2.11.0
