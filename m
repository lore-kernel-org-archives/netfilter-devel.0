From: Felix Fietkau <nbd@nbd.name>
Subject: [RFC 5/9] netfilter: nf_flow_table: rename nf_flow_table.c to nf_flow_table_core.c
Date: Sat, 17 Feb 2018 12:12:02 +0100
Message-ID: <20180217111206.37312-5-nbd@nbd.name>
References: <20180217111206.37312-1-nbd@nbd.name>
Cc: pablo@netfilter.org, nbd@nbd.name
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:54336 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751101AbeBQLMq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 17 Feb 2018 06:12:46 -0500
In-Reply-To: <20180217111206.37312-1-nbd@nbd.name>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Preparation for adding more code to the same module

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/netfilter/Makefile                                  | 2 ++
 net/netfilter/{nf_flow_table.c => nf_flow_table_core.c} | 0
 2 files changed, 2 insertions(+)
 rename net/netfilter/{nf_flow_table.c => nf_flow_table_core.c} (100%)

diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 77604f1046c0..074d59860da2 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -112,6 +112,8 @@ obj-$(CONFIG_NFT_FWD_NETDEV)	+= nft_fwd_netdev.o
 
 # flow table infrastructure
 obj-$(CONFIG_NF_FLOW_TABLE)	+= nf_flow_table.o
+nf_flow_table-objs := nf_flow_table_core.o
+
 obj-$(CONFIG_NF_FLOW_TABLE_INET) += nf_flow_table_inet.o
 obj-$(CONFIG_NF_FLOW_TABLE_HW)	+= nf_flow_table_hw.o
 
diff --git a/net/netfilter/nf_flow_table.c b/net/netfilter/nf_flow_table_core.c
similarity index 100%
rename from net/netfilter/nf_flow_table.c
rename to net/netfilter/nf_flow_table_core.c
-- 
2.14.2

