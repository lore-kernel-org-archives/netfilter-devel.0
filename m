From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 23/23] netfilter: xtables: remove bogus mangle table dependency of connmark
Date: Mon,  6 Oct 2008 08:15:26 -0400
Message-ID: <a9e3428013044fa286070e96f75cf34e07234fcb.1223294924.git.jengelh@medozas.de>
References: <1223295326-10890-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:57101 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939AbYJFMPc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Oct 2008 08:15:32 -0400
In-Reply-To: <1223295326-10890-1-git-send-email-jengelh@medozas.de>
In-Reply-To: <0a71cdb22ae4ae9ad9c49cab82cc41ccdd5653a1.1223294924.git.jengelh@medozas.de>
References: <0a71cdb22ae4ae9ad9c49cab82cc41ccdd5653a1.1223294924.git.jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/netfilter/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 899e780..f70b414 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -318,7 +318,6 @@ config NETFILTER_XT_TARGET_CLASSIFY
 
 config NETFILTER_XT_TARGET_CONNMARK
 	tristate  '"CONNMARK" target support'
-	depends on IP_NF_MANGLE || IP6_NF_MANGLE
 	depends on NF_CONNTRACK
 	depends on NETFILTER_ADVANCED
 	select NF_CONNTRACK_MARK
-- 
1.6.0.1

