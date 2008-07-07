From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 06/13: ebt_nflog: fix Kconfig typo
Date: Mon,  7 Jul 2008 14:05:23 +0200 (MEST)
Message-ID: <20080707120522.4975.22620.sendpatchset@localhost.localdomain>
References: <20080707120514.4975.88670.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58381 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629AbYGGMFY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Jul 2008 08:05:24 -0400
In-Reply-To: <20080707120514.4975.88670.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

netfilter: ebt_nflog: fix Kconfig typo

The help text should refer to nflog instead of ulog. Noticed by
Krzysztof Halasa <khc@pm.waw.pl>.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 48d88486554c27296e6f0e4b37aae3bbb37af5d2
tree 5e381318cdc2c46ed9d7e4afa58815c125d441f2
parent fa30a357f95a548526ffe578a57ff55fb2646674
author Patrick McHardy <kaber@trash.net> Mon, 07 Jul 2008 13:00:16 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 07 Jul 2008 13:00:16 +0200

 net/bridge/netfilter/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/bridge/netfilter/Kconfig b/net/bridge/netfilter/Kconfig
index 540df41..9094797 100644
--- a/net/bridge/netfilter/Kconfig
+++ b/net/bridge/netfilter/Kconfig
@@ -230,7 +230,7 @@ config BRIDGE_EBT_NFLOG
 	  either the old LOG target, the old ULOG target or nfnetlink_log
 	  as backend.
 
-	  This option adds the ulog watcher, that you can use in any rule
+	  This option adds the nflog watcher, that you can use in any rule
 	  in any ebtables table.
 
 	  To compile it as a module, choose M here.  If unsure, say N.
