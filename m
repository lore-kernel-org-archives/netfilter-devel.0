From: Felix Fietkau <nbd@nbd.name>
Subject: [RFC 9/9] netfilter: nf_flow_table: relax mixed ipv4/ipv6 flowtable dependencies
Date: Sat, 17 Feb 2018 12:12:06 +0100
Message-ID: <20180217111206.37312-9-nbd@nbd.name>
References: <20180217111206.37312-1-nbd@nbd.name>
Cc: pablo@netfilter.org, nbd@nbd.name
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:54288 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751091AbeBQLMK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 17 Feb 2018 06:12:10 -0500
In-Reply-To: <20180217111206.37312-1-nbd@nbd.name>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Since the offload hook code was moved, this table no longer depends on
the IPv4 and IPv6 flowtable modules

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/netfilter/Kconfig | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 29b144c04f53..28603e112cb4 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -666,8 +666,7 @@ endif # NF_TABLES
 
 config NF_FLOW_TABLE_INET
 	tristate "Netfilter flow table mixed IPv4/IPv6 module"
-	depends on NF_FLOW_TABLE_IPV4
-	depends on NF_FLOW_TABLE_IPV6
+	depends on NF_FLOW_TABLE
 	help
           This option adds the flow table mixed IPv4/IPv6 support.
 
-- 
2.14.2

