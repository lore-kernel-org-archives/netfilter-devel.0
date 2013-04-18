From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 2/2] netfilter: rpfilter: depend on raw or mangle table
Date: Thu, 18 Apr 2013 10:45:25 +0200
Message-ID: <1366274725-16286-2-git-send-email-fw@strlen.de>
References: <1366274725-16286-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:50389 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753310Ab3DRInW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Apr 2013 04:43:22 -0400
In-Reply-To: <1366274725-16286-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

rpfilter is only valid in raw/mangle PREROUTING, i.e.
RPFILTER=y|m is useless without raw or mangle table support.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/netfilter/Kconfig |    2 +-
 net/ipv6/netfilter/Kconfig |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 0d755c5..e7916c1 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -71,7 +71,7 @@ config IP_NF_MATCH_ECN
 
 config IP_NF_MATCH_RPFILTER
 	tristate '"rpfilter" reverse path filter match support'
-	depends on NETFILTER_ADVANCED
+	depends on NETFILTER_ADVANCED && (IP_NF_MANGLE || IP_NF_RAW)
 	---help---
 	  This option allows you to match packets whose replies would
 	  go out via the interface the packet came in.
diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index c72532a..4433ab40 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -105,7 +105,7 @@ config IP6_NF_MATCH_MH
 
 config IP6_NF_MATCH_RPFILTER
 	tristate '"rpfilter" reverse path filter match support'
-	depends on NETFILTER_ADVANCED
+	depends on NETFILTER_ADVANCED && (IP6_NF_MANGLE || IP6_NF_RAW)
 	---help---
 	  This option allows you to match packets whose replies would
 	  go out via the interface the packet came in.
-- 
1.7.8.6

