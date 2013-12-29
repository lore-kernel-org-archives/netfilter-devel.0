From: Eric Leblond <eric@regit.org>
Subject: [PATCH 1/2] netfilter: nft: select NFNETLINK
Date: Sun, 29 Dec 2013 11:01:29 +0100
Message-ID: <1388311290-18366-2-git-send-email-eric@regit.org>
References: <1388311290-18366-1-git-send-email-eric@regit.org>
Cc: Eric Leblond <eric@regit.org>
To: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:53078 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271Ab3L2KBx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 29 Dec 2013 05:01:53 -0500
In-Reply-To: <1388311290-18366-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In Kconfig, nft is set as depending on NFNETLINK so building nft as a
module or inside kernel is depending of the state of NFNETLINK inside
the kernel config. If someone wants to build nftables inside the
kernel, it is necessary to also build NFNETLINK inside the kernel.
But NFNETLINK can not be set in the menu so it is necessary to toggle
an external value such as logging or nfacct to have a switch of
NFNETLINK to kernel build.
This patch change the dependency to a select inside Kconfig to be able
to set the build of nftables as modules or inside kernel independently.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 net/netfilter/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 4371c98..01f9f64 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -414,7 +414,7 @@ config NETFILTER_SYNPROXY
 endif # NF_CONNTRACK
 
 config NF_TABLES
-	depends on NETFILTER_NETLINK
+	select NETFILTER_NETLINK
 	tristate "Netfilter nf_tables support"
 
 config NFT_EXTHDR
-- 
1.8.5.2

