From: pablo@netfilter.org
Subject: [PATCH 07/14] ipvs: Enhance grammar used to refer to Kconfig options
Date: Tue,  1 Nov 2011 10:11:29 +0100
Message-ID: <1320138696-28048-8-git-send-email-pablo@netfilter.org>
References: <1320138696-28048-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, Simon Horman <horms@verge.net.au>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37238 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752744Ab1KAJME (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Nov 2011 05:12:04 -0400
In-Reply-To: <1320138696-28048-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Simon Horman <horms@verge.net.au>

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 Documentation/networking/ipvs-sysctl.txt |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/ipvs-sysctl.txt b/Documentation/networking/ipvs-sysctl.txt
index 13610e3..f2a2488 100644
--- a/Documentation/networking/ipvs-sysctl.txt
+++ b/Documentation/networking/ipvs-sysctl.txt
@@ -30,7 +30,7 @@ conntrack - BOOLEAN
 	Connections handled by the IPVS FTP application module
 	will have connection tracking entries regardless of this setting.
 
-	Only available when IPVS is compiled with the CONFIG_IP_VS_NFCT
+	Only available when IPVS is compiled with CONFIG_IP_VS_NFCT enabled.
 
 cache_bypass - BOOLEAN
         0 - disabled (default)
@@ -56,7 +56,7 @@ debug_level - INTEGER
 	11         - IPVS packet handling (ip_vs_in/ip_vs_out)
 	12 or more - packet traversal
 
-	Only available when IPVS is compiled with the CONFIG_IP_VS_DEBUG
+	Only available when IPVS is compiled with CONFIG_IP_VS_DEBUG enabled.
 
 	Higher debugging levels include the messages for lower debugging
 	levels, so setting debug level 2, includes level 0, 1 and 2
-- 
1.7.2.5

