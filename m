From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 1/2] netfilter: nf_tables: nft_queue does not depend on x_tables
Date: Wed, 25 Mar 2015 08:09:55 +0000
Message-ID: <1427270996-6311-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45364 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbbCYIKs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Mar 2015 04:10:48 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 net/netfilter/Kconfig | 1 -
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
2.1.0

