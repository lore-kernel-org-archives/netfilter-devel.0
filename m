From: Simon Horman <horms@verge.net.au>
Subject: [RFC] IPVS: Enhance grammar used to refer to Kconfig options
Date: Thu, 29 Sep 2011 16:29:16 +0900
Message-ID: <1317281357-25516-1-git-send-email-horms@verge.net.au>
Cc: lvs-devel@vger.kernel.org, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	Randy Dunlap <rdunlap@xenotime.net>,
	Simon Horman <horms@verge.net.au>
To: Julian Anastasov <ja@ssi.bg>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:57190 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904Ab1I2H3k (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Sep 2011 03:29:40 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Simon Horman <horms@verge.net.au>
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
1.7.5.4

