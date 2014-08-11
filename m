From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/2] netfilter: nf_tables: nat expression must select CONFIG_NF_NAT
Date: Mon, 11 Aug 2014 18:21:50 +0200
Message-ID: <1407774110-7467-2-git-send-email-pablo@netfilter.org>
References: <1407774110-7467-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, Matteo Croce <technoboy85@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35388 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754174AbaHKQVx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Aug 2014 12:21:53 -0400
In-Reply-To: <1407774110-7467-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This enables the netfilter NAT engine in first place, otherwise
you cannot ever select the nf_tables nat expression if iptables
is not selected.

Reported-by: Matteo Croce <technoboy85@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index ad751fe..05eb177 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -499,7 +499,7 @@ config NFT_LIMIT
 config NFT_NAT
 	depends on NF_TABLES
 	depends on NF_CONNTRACK
-	depends on NF_NAT
+	select NF_NAT
 	tristate "Netfilter nf_tables nat module"
 	help
 	  This option adds the "nat" expression that you can use to perform
-- 
1.7.10.4

