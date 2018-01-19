From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 17/32] netfilter: nf_tables: flow_offload depends on flow_table
Date: Fri, 19 Jan 2018 20:10:26 +0100
Message-ID: <20180119191041.25804-18-pablo@netfilter.org>
References: <20180119191041.25804-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45292 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932452AbeASTLL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Jan 2018 14:11:11 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5F0E12EFECE
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jan 2018 20:11:04 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 44414DA857
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jan 2018 20:11:04 +0100 (CET)
In-Reply-To: <20180119191041.25804-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Arnd Bergmann <arnd@arndb.de>

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
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
2.11.0

