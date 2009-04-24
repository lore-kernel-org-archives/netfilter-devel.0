From: Laszlo Attila Toth <panther@balabit.hu>
Subject: [PATCH 2/2] TProxy doesn't depend on NF_CONNTRACK
Date: Fri, 24 Apr 2009 15:30:20 +0200
Message-ID: <1240579820-18637-2-git-send-email-panther@balabit.hu>
References: <1240579820-18637-1-git-send-email-panther@balabit.hu>
Cc: Laszlo Attila Toth <panther@balabit.hu>
To: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from support.balabit.hu ([195.70.41.86]:60200 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756308AbZDXN7K (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Apr 2009 09:59:10 -0400
Received: from balabit.hu (unknown [10.80.0.254])
	by lists.balabit.hu (Postfix) with ESMTP id 17D3339D33E
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Apr 2009 15:30:25 +0200 (CEST)
In-Reply-To: <1240579820-18637-1-git-send-email-panther@balabit.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Laszlo Attila Toth <panther@balabit.hu>
---
 net/netfilter/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 2329c5f..881203c 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -275,6 +275,8 @@ config NF_CT_NETLINK
 	help
 	  This option enables support for a netlink-based userspace interface
 
+endif # NF_CONNTRACK
+
 # transparent proxy support
 config NETFILTER_TPROXY
 	tristate "Transparent proxying support (EXPERIMENTAL)"
@@ -290,8 +292,6 @@ config NETFILTER_TPROXY
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
-endif # NF_CONNTRACK
-
 config NETFILTER_XTABLES
 	tristate "Netfilter Xtables support (required for ip_tables)"
 	default m if NETFILTER_ADVANCED=n
-- 
1.6.2.2.404.ge96f3

