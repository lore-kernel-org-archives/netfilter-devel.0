From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH nftables] nftables: fix compilation when nf-netlink is a module
Date: Wed,  6 Mar 2013 11:26:37 +0100
Message-ID: <1362565597-2391-1-git-send-email-nicolas.dichtel@6wind.com>
Cc: netfilter-devel@vger.kernel.org,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 33.106-14-84.ripe.coltfrance.com ([84.14.106.33]:52236 "EHLO
	proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756732Ab3CFKet (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Mar 2013 05:34:49 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nftables uses nfnl_[un]lock() and thus depends on CONFIG_NETFILTER_NETLINK.
It's not possible to have nftables built-in when CONFIG_NETFILTER_NETLINK is set
to m.

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 net/netfilter/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 7d1c3c0..acf6705 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -430,6 +430,7 @@ config NETFILTER_XTABLES
 	  ip6_tables or arp_tables.
 
 config NF_TABLES
+       depends on NETFILTER_NETLINK
        tristate "Netfilter nf_tables support"
 
 config NFT_PAYLOAD
-- 
1.8.0.1

