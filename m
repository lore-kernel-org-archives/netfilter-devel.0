From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 04/16] [NETFILTER]: Fix name of hopbyhop in Netfilter Kconfig
Date: Sat,  4 Oct 2008 15:41:18 -0400
Message-ID: <f4acb47ca89589eb43f89b6d1efb1a85aa9240da.1223149287.git.jengelh@medozas.de>
References: <67e1140a1db2e8aa9a4b6c80289039487c5445cb.1223149287.git.jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:34301 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300AbYJDTld (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 4 Oct 2008 15:41:33 -0400
In-Reply-To: <67e1140a1db2e8aa9a4b6c80289039487c5445cb.1223149287.git.jengelh@medozas.de>
In-Reply-To: <67e1140a1db2e8aa9a4b6c80289039487c5445cb.1223149287.git.jengelh@medozas.de>
References: <67e1140a1db2e8aa9a4b6c80289039487c5445cb.1223149287.git.jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The module is called hbh, not hopbyhop.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/ipv6/netfilter/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index 0cfcce7..f244324 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -67,7 +67,7 @@ config IP6_NF_MATCH_RT
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config IP6_NF_MATCH_OPTS
-	tristate '"hopbyhop" and "dst" opts header match support'
+	tristate '"hbh" hop-by-hop and "dst" opts header match support'
 	depends on IP6_NF_IPTABLES
 	depends on NETFILTER_ADVANCED
 	help
-- 
1.6.0.1

