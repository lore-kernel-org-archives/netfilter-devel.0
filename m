From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] netfilter: nf_tables: rename set implementations
Date: Tue,  9 Aug 2016 16:11:46 +0200
Message-ID: <1470751906-1534-1-git-send-email-pablo@netfilter.org>
Cc: nevola@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52196 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751804AbcHIOMj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Aug 2016 10:12:39 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 647721878A9
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Aug 2016 16:12:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 5503AFC61A
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Aug 2016 16:12:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 0DCF9FF153
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Aug 2016 16:12:33 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use nft_set_* prefix for backend set implementations, thus we can use
nft_hash for the new hash expression.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Laura, I'm posting this patch that you need in first place before the hash
expression.

 net/netfilter/Kconfig                            | 4 ++--
 net/netfilter/Makefile                           | 4 ++--
 net/netfilter/{nft_hash.c => nft_set_hash.c}     | 0
 net/netfilter/{nft_rbtree.c => nft_set_rbtree.c} | 0
 4 files changed, 4 insertions(+), 4 deletions(-)
 rename net/netfilter/{nft_hash.c => nft_set_hash.c} (100%)
 rename net/netfilter/{nft_rbtree.c => nft_set_rbtree.c} (100%)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 9266cee..e5740e1 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -481,13 +481,13 @@ config NFT_CT
 	  This option adds the "meta" expression that you can use to match
 	  connection tracking information such as the flow state.
 
-config NFT_RBTREE
+config NFT_SET_RBTREE
 	tristate "Netfilter nf_tables rbtree set module"
 	help
 	  This option adds the "rbtree" set type (Red Black tree) that is used
 	  to build interval-based sets.
 
-config NFT_HASH
+config NFT_SET_HASH
 	tristate "Netfilter nf_tables hash set module"
 	help
 	  This option adds the "hash" set type that is used to build one-way
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 6913454..101fb85 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -86,8 +86,8 @@ obj-$(CONFIG_NFT_NAT)		+= nft_nat.o
 obj-$(CONFIG_NFT_QUEUE)		+= nft_queue.o
 obj-$(CONFIG_NFT_REJECT) 	+= nft_reject.o
 obj-$(CONFIG_NFT_REJECT_INET)	+= nft_reject_inet.o
-obj-$(CONFIG_NFT_RBTREE)	+= nft_rbtree.o
-obj-$(CONFIG_NFT_HASH)		+= nft_hash.o
+obj-$(CONFIG_NFT_SET_RBTREE)	+= nft_set_rbtree.o
+obj-$(CONFIG_NFT_SET_HASH)	+= nft_set_hash.o
 obj-$(CONFIG_NFT_COUNTER)	+= nft_counter.o
 obj-$(CONFIG_NFT_LOG)		+= nft_log.o
 obj-$(CONFIG_NFT_MASQ)		+= nft_masq.o
diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_set_hash.c
similarity index 100%
rename from net/netfilter/nft_hash.c
rename to net/netfilter/nft_set_hash.c
diff --git a/net/netfilter/nft_rbtree.c b/net/netfilter/nft_set_rbtree.c
similarity index 100%
rename from net/netfilter/nft_rbtree.c
rename to net/netfilter/nft_set_rbtree.c
-- 
2.1.4

