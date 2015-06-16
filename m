From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 1/2] netfilter: bridge: rename br_netfilter.c to br_netfilter_hooks.c
Date: Tue, 16 Jun 2015 14:35:05 +0200
Message-ID: <1434458106-32445-1-git-send-email-pablo@netfilter.org>
Cc: fw@strlen.de, bernhard.thaler@wvnet.at
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43541 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752384AbbFPM3w (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Jun 2015 08:29:52 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

To prepare separation of the IPv6 code into different file.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/Makefile                                 |    1 +
 net/bridge/{br_netfilter.c => br_netfilter_hooks.c} |    0
 2 files changed, 1 insertion(+)
 rename net/bridge/{br_netfilter.c => br_netfilter_hooks.c} (100%)

diff --git a/net/bridge/Makefile b/net/bridge/Makefile
index fd7ee03..c52577a 100644
--- a/net/bridge/Makefile
+++ b/net/bridge/Makefile
@@ -12,6 +12,7 @@ bridge-$(CONFIG_SYSFS) += br_sysfs_if.o br_sysfs_br.o
 
 bridge-$(subst m,y,$(CONFIG_BRIDGE_NETFILTER)) += br_nf_core.o
 
+br_netfilter-y := br_netfilter_hooks.o
 obj-$(CONFIG_BRIDGE_NETFILTER) += br_netfilter.o
 
 bridge-$(CONFIG_BRIDGE_IGMP_SNOOPING) += br_multicast.o br_mdb.o
diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter_hooks.c
similarity index 100%
rename from net/bridge/br_netfilter.c
rename to net/bridge/br_netfilter_hooks.c
-- 
1.7.10.4

