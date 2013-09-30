From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 16/26] netfilter: ipset: Kconfig: ipset needs NETFILTER_NETLINK
Date: Mon, 30 Sep 2013 21:50:27 +0200
Message-ID: <1380570637-31235-17-git-send-email-kadlec@blackhole.kfki.hu>
References: <1380570637-31235-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:60604 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756374Ab3I3Tup (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Sep 2013 15:50:45 -0400
In-Reply-To: <1380570637-31235-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/ipset/Kconfig b/net/netfilter/ipset/Kconfig
index ba36c28..fd2c14b 100644
--- a/net/netfilter/ipset/Kconfig
+++ b/net/netfilter/ipset/Kconfig
@@ -1,7 +1,7 @@
 menuconfig IP_SET
 	tristate "IP set support"
 	depends on INET && NETFILTER
-	depends on NETFILTER_NETLINK
+	select NETFILTER_NETLINK
 	help
 	  This option adds IP set support to the kernel.
 	  In order to define and use the sets, you need the userspace utility
-- 
1.7.0.4

