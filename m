From: Eric Leblond <eric@regit.org>
Subject: [PATCH 2/2] netfilter: nft: explicit dependency to IPv6
Date: Sun, 29 Dec 2013 11:01:30 +0100
Message-ID: <1388311290-18366-3-git-send-email-eric@regit.org>
References: <1388311290-18366-1-git-send-email-eric@regit.org>
Cc: Eric Leblond <eric@regit.org>
To: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:53081 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab3L2KBy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 29 Dec 2013 05:01:54 -0500
In-Reply-To: <1388311290-18366-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nftables IPv6 tables could be selected independently of other
Netfilter component so it needs to be dependent of IPv6.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 net/ipv6/netfilter/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index 7702f9e..36c71da 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -27,6 +27,7 @@ config NF_CONNTRACK_IPV6
 
 config NF_TABLES_IPV6
 	depends on NF_TABLES
+	depends on INET && IPV6
 	tristate "IPv6 nf_tables support"
 
 config NFT_CHAIN_ROUTE_IPV6
-- 
1.8.5.2

