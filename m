From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nftables] netfilter: nf_tables: fix unmet dependencies in nf_tables_inet
Date: Mon, 13 Jan 2014 12:02:38 +0100
Message-ID: <1389610958-5223-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40779 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730AbaAMLDY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 13 Jan 2014 06:03:24 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

warning: (NF_TABLES_INET) selects NF_TABLES_IPV6 which has unmet direct dependencies (NET && NETFILTER && INET && IPV6 && NF_TABLES)
warning: (NF_TABLES_INET) selects NF_TABLES_IPV6 which has unmet direct dependencies (NET && NETFILTER && INET && IPV6 && NF_TABLES)

Fix it by replacing 'selects' by depends on' as in other NF_TABLES_*
configuration options.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 37d2092..2421b9b 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -430,8 +430,8 @@ config NF_TABLES
 
 config NF_TABLES_INET
 	depends on NF_TABLES
-	select NF_TABLES_IPV4
-	select NF_TABLES_IPV6
+	depends on NF_TABLES_IPV4
+	depends on NF_TABLES_IPV6
 	tristate "Netfilter nf_tables mixed IPv4/IPv6 tables support"
 	help
 	  This option enables support for a mixed IPv4/IPv6 "inet" table.
-- 
1.7.10.4

