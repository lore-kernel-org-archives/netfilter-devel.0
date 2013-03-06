From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH nftables v2] nftables: fix compilation when nf-netlink is a module
Date: Wed,  6 Mar 2013 14:42:07 +0100
Message-ID: <1362577327-16634-1-git-send-email-nicolas.dichtel@6wind.com>
References: <51372681.7010604@6wind.com>
Cc: netfilter-devel@vger.kernel.org,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 33.106-14-84.ripe.coltfrance.com ([84.14.106.33]:52361 "EHLO
	proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755822Ab3CFNmL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Mar 2013 08:42:11 -0500
In-Reply-To: <51372681.7010604@6wind.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nftables uses nfnl_[un]lock() and thus depends on CONFIG_NETFILTER_NETLINK.
It's not possible to have nftables built-in when CONFIG_NETFILTER_NETLINK is set
to m.

I also add a dependancy between NETFILTER_XTABLES and NFT_COMPAT instead of
automatically set NETFILTER_XTABLES when NFT_COMPAT is set. This is to avoid a
circular dependency:

net/netfilter/Kconfig:432:error: recursive dependency detected!
net/netfilter/Kconfig:432:	symbol NF_TABLES depends on NETFILTER_NETLINK
net/netfilter/Kconfig:4:	symbol NETFILTER_NETLINK is selected by NETFILTER_NETLINK_ACCT
net/netfilter/Kconfig:7:	symbol NETFILTER_NETLINK_ACCT is selected by NETFILTER_XT_MATCH_NFACCT
net/netfilter/Kconfig:1087:	symbol NETFILTER_XT_MATCH_NFACCT depends on NETFILTER_XTABLES
net/netfilter/Kconfig:425:	symbol NETFILTER_XTABLES is selected by NFT_COMPAT
net/netfilter/Kconfig:478:	symbol NFT_COMPAT depends on NF_TABLES

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
v2: fix circular dependency

 net/netfilter/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 7d1c3c0..903275e 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -430,6 +430,7 @@ config NETFILTER_XTABLES
 	  ip6_tables or arp_tables.
 
 config NF_TABLES
+       depends on NETFILTER_NETLINK
        tristate "Netfilter nf_tables support"
 
 config NFT_PAYLOAD
@@ -476,7 +477,7 @@ config NFT_NAT
 
 config NFT_COMPAT
        depends on NF_TABLES
-       select NETFILTER_XTABLES
+       depends on NETFILTER_XTABLES
        tristate "Netfilter x_tables over nf_tables module"
        help
 	 This is required if you intend to use any of existing
-- 
1.8.0.1

