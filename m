From: Jike Song <jike.song@intel.com>
Subject: [PATCH] netfilter, kbuild: use canonical method to specify objs.
Date: Fri,  2 Jun 2017 17:35:37 +0800
Message-ID: <1496396137-22173-1-git-send-email-jike.song@intel.com>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Jike Song <jike.song@intel.com>
To: pablo@netfilter.org, kadlec@blackhole.kfki.hu, fw@strlen.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:31710 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751239AbdFBJfq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Jun 2017 05:35:46 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Should use ":=" instead of "+=".

Signed-off-by: Jike Song <jike.song@intel.com>
---
 net/netfilter/Makefile | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index c9b78e7..9133809 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -70,10 +70,9 @@ obj-$(CONFIG_NETFILTER_SYNPROXY) += nf_synproxy_core.o
 obj-$(CONFIG_NF_DUP_NETDEV)	+= nf_dup_netdev.o
 
 # nf_tables
-nf_tables-objs += nf_tables_core.o nf_tables_api.o nf_tables_trace.o
-nf_tables-objs += nft_immediate.o nft_cmp.o nft_range.o
-nf_tables-objs += nft_bitwise.o nft_byteorder.o nft_payload.o
-nf_tables-objs += nft_lookup.o nft_dynset.o
+nf_tables-objs := nf_tables_core.o nf_tables_api.o nf_tables_trace.o \
+		  nft_immediate.o nft_cmp.o nft_range.o nft_bitwise.o \
+		  nft_byteorder.o nft_payload.o nft_lookup.o nft_dynset.o
 
 obj-$(CONFIG_NF_TABLES)		+= nf_tables.o
 obj-$(CONFIG_NF_TABLES_INET)	+= nf_tables_inet.o
-- 
1.9.3

