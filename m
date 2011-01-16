From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 1/6] netfilter: kconfig: NFQUEUE is useless without NETFILTER_NETLINK_QUEUE
Date: Sun, 16 Jan 2011 14:19:02 +0100
Message-ID: <1295183947-12786-2-git-send-email-fw@strlen.de>
References: <1295183947-12786-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:42905 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752417Ab1APNY3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Jan 2011 08:24:29 -0500
In-Reply-To: <1295183947-12786-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

NFLOG already does the same thing for NETFILTER_NETLINK_LOG.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 1b79353..03fc794 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -477,6 +477,7 @@ config NETFILTER_XT_TARGET_NFLOG
 config NETFILTER_XT_TARGET_NFQUEUE
 	tristate '"NFQUEUE" target Support'
 	depends on NETFILTER_ADVANCED
+	select NETFILTER_NETLINK_QUEUE
 	help
 	  This target replaced the old obsolete QUEUE target.
 
-- 
1.7.2.2

