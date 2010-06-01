From: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
Subject: [PATCH] Fix simple typo in KConfig for netfiltert xt_TEE.
Date: Tue, 01 Jun 2010 16:47:03 +0200
Message-ID: <1275403623-9133-1-git-send-email-hannemann@nets.rwth-aachen.de>
Content-Transfer-Encoding: 7BIT
Cc: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mta-2.ms.rz.RWTH-Aachen.DE ([134.130.7.73]:52143 "EHLO
	mta-2.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753920Ab0FAOqk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Jun 2010 10:46:40 -0400
Received: from ironport-out-1.rz.rwth-aachen.de ([134.130.5.40])
 by mta-2.ms.rz.RWTH-Aachen.de
 (Sun Java(tm) System Messaging Server 6.3-7.04 (built Sep 26 2008))
 with ESMTP id <0L3C00EKCBPQF8D0@mta-2.ms.rz.RWTH-Aachen.de> for
 netfilter-devel@vger.kernel.org; Tue, 01 Jun 2010 16:46:38 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Destination was spelled wrong in KConfig.

Signed-off-by: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
---
 net/netfilter/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 8593a77..7d4582c 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -503,7 +503,7 @@ config NETFILTER_XT_TARGET_RATEEST
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config NETFILTER_XT_TARGET_TEE
-	tristate '"TEE" - packet cloning to alternate destiantion'
+	tristate '"TEE" - packet cloning to alternate destination'
 	depends on NETFILTER_ADVANCED
 	depends on (IPV6 || IPV6=n)
 	depends on !NF_CONNTRACK || NF_CONNTRACK
-- 
1.5.4

