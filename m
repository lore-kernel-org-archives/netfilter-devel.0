From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] netfilter: nf_tables: flow_offload depends on flow_table
Date: Fri, 12 Jan 2018 16:50:26 +0100
Message-ID: <20180112155033.3694504-1-arnd@arndb.de>
Cc: Arnd Bergmann <arnd@arndb.de>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        "Pablo M. Bermudo Garay" <pablombg@gmail.com>,
        Manuel Messner <mm@skelett.io>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Without CONFIG_NF_FLOW_TABLE, the new nft_flow_offload module produces
a link error:

net/netfilter/nft_flow_offload.o: In function `nft_flow_offload_iterate_cleanup':
nft_flow_offload.c:(.text+0xb0): undefined reference to `nf_flow_table_iterate'
net/netfilter/nft_flow_offload.o: In function `flow_offload_iterate_cleanup':
nft_flow_offload.c:(.text+0x160): undefined reference to `flow_offload_dead'
net/netfilter/nft_flow_offload.o: In function `nft_flow_offload_eval':
nft_flow_offload.c:(.text+0xc4c): undefined reference to `flow_offload_alloc'
nft_flow_offload.c:(.text+0xc64): undefined reference to `flow_offload_add'
nft_flow_offload.c:(.text+0xc94): undefined reference to `flow_offload_free'

This adds a Kconfig dependency for it.

Fixes: a3c90f7a2323 ("netfilter: nf_tables: flow offload expression")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 net/netfilter/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index ea447826e127..9019fa98003d 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -506,7 +506,7 @@ config NFT_CT
 	  connection tracking information such as the flow state.
 
 config NFT_FLOW_OFFLOAD
-	depends on NF_CONNTRACK
+	depends on NF_CONNTRACK && NF_FLOW_TABLE
 	tristate "Netfilter nf_tables hardware flow offload module"
 	help
 	  This option adds the "flow_offload" expression that you can use to
-- 
2.9.0
