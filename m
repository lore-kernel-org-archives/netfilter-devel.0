From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 04/15] netfilter: nf_tables: nft_queue does not depend on x_tables
Date: Thu, 26 Mar 2015 13:06:51 +0100
Message-ID: <1427371622-4466-5-git-send-email-pablo@netfilter.org>
References: <1427371622-4466-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1427371622-4466-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Patrick McHardy <kaber@trash.net>

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/Kconfig |    1 -
 1 file changed, 1 deletion(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 971cd75..f70e34a 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -522,7 +522,6 @@ config NFT_NAT
 	  typical Network Address Translation (NAT) packet transformations.
 
 config NFT_QUEUE
-	depends on NETFILTER_XTABLES
 	depends on NETFILTER_NETLINK_QUEUE
 	tristate "Netfilter nf_tables queue module"
 	help
-- 
1.7.10.4
