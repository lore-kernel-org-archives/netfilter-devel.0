From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 11/51] netfilter: nf_flow_table: rename nf_flow_table.c to nf_flow_table_core.c
Date: Mon,  7 May 2018 00:46:29 +0200
Message-ID: <20180506224709.29100-12-pablo@netfilter.org>
References: <20180506224709.29100-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180506224709.29100-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

Preparation for adding more code to the same module

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/Makefile                                  | 2 ++
 net/netfilter/{nf_flow_table.c => nf_flow_table_core.c} | 0
 2 files changed, 2 insertions(+)
 rename net/netfilter/{nf_flow_table.c => nf_flow_table_core.c} (100%)

diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index fd32bd2c9521..700c5d51e405 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -111,6 +111,8 @@ obj-$(CONFIG_NFT_FWD_NETDEV)	+= nft_fwd_netdev.o
 
 # flow table infrastructure
 obj-$(CONFIG_NF_FLOW_TABLE)	+= nf_flow_table.o
+nf_flow_table-objs := nf_flow_table_core.o
+
 obj-$(CONFIG_NF_FLOW_TABLE_INET) += nf_flow_table_inet.o
 
 # generic X tables 
diff --git a/net/netfilter/nf_flow_table.c b/net/netfilter/nf_flow_table_core.c
similarity index 100%
rename from net/netfilter/nf_flow_table.c
rename to net/netfilter/nf_flow_table_core.c
-- 
2.11.0
