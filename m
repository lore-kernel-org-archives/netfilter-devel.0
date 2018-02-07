From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 03/11] netfilter: flowtable infrastructure depends on NETFILTER_INGRESS
Date: Wed,  7 Feb 2018 18:42:21 +0100
Message-ID: <20180207174229.4098-4-pablo@netfilter.org>
References: <20180207174229.4098-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46984 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754151AbeBGRmk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Feb 2018 12:42:40 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D66983066AE
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Feb 2018 18:42:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C7E2ADA78B
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Feb 2018 18:42:38 +0100 (CET)
In-Reply-To: <20180207174229.4098-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

config NF_FLOW_TABLE depends on NETFILTER_INGRESS. If users forget to
enable this toggle, flowtable registration fails with EOPNOTSUPP.

Moreover, turn 'select NF_FLOW_TABLE' in every flowtable family flavour
into dependency instead, otherwise this new dependency on
NETFILTER_INGRESS causes a warning. This also allows us to remove the
explicit dependency between family flowtables <-> NF_TABLES and
NF_CONNTRACK, given they depend on the NF_FLOW_TABLE core that already
expresses the general dependencies for this new infrastructure.

Moreover, NF_FLOW_TABLE_INET depends on NF_FLOW_TABLE_IPV4 and
NF_FLOWTABLE_IPV6, which already depends on NF_FLOW_TABLE. So we can get
rid of direct dependency with NF_FLOW_TABLE.

In general, let's avoid 'select', it just makes things more complicated.

Reported-by: John Crispin <john@phrozen.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/Kconfig | 3 +--
 net/ipv6/netfilter/Kconfig | 3 +--
 net/netfilter/Kconfig      | 8 +++++---
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 5f52236780b4..dfe6fa4ea554 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -80,8 +80,7 @@ endif # NF_TABLES
 
 config NF_FLOW_TABLE_IPV4
 	tristate "Netfilter flow table IPv4 module"
-	depends on NF_CONNTRACK && NF_TABLES
-	select NF_FLOW_TABLE
+	depends on NF_FLOW_TABLE
 	help
 	  This option adds the flow table IPv4 support.
 
diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index 4a634b7a2c80..d395d1590699 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -73,8 +73,7 @@ endif # NF_TABLES
 
 config NF_FLOW_TABLE_IPV6
 	tristate "Netfilter flow table IPv6 module"
-	depends on NF_CONNTRACK && NF_TABLES
-	select NF_FLOW_TABLE
+	depends on NF_FLOW_TABLE
 	help
 	  This option adds the flow table IPv6 support.
 
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 9019fa98003d..d3220b43c832 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -666,8 +666,8 @@ endif # NF_TABLES
 
 config NF_FLOW_TABLE_INET
 	tristate "Netfilter flow table mixed IPv4/IPv6 module"
-	depends on NF_FLOW_TABLE_IPV4 && NF_FLOW_TABLE_IPV6
-	select NF_FLOW_TABLE
+	depends on NF_FLOW_TABLE_IPV4
+	depends on NF_FLOW_TABLE_IPV6
 	help
           This option adds the flow table mixed IPv4/IPv6 support.
 
@@ -675,7 +675,9 @@ config NF_FLOW_TABLE_INET
 
 config NF_FLOW_TABLE
 	tristate "Netfilter flow table module"
-	depends on NF_CONNTRACK && NF_TABLES
+	depends on NETFILTER_INGRESS
+	depends on NF_CONNTRACK
+	depends on NF_TABLES
 	help
 	  This option adds the flow table core infrastructure.
 
-- 
2.11.0

