From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 2/4] extensions: libipt_ULOG: man page should mention NFLOG
Date: Mon, 15 Jul 2013 00:30:00 +0200
Message-ID: <1373841002-19071-2-git-send-email-fw@strlen.de>
References: <1373841002-19071-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:50935 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753322Ab3GNWaO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 14 Jul 2013 18:30:14 -0400
In-Reply-To: <1373841002-19071-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Florian Westphal <fw@strlen.de>
---
diff --git a/extensions/libipt_ULOG.man b/extensions/libipt_ULOG.man
index 649b6e3..c91f776 100644
--- a/extensions/libipt_ULOG.man
+++ b/extensions/libipt_ULOG.man
@@ -1,4 +1,5 @@
-This target provides userspace logging of matching packets.  When this
+This is the deprecated ipv4-only predecessor of the NFLOG target.
+It provides userspace logging of matching packets.  When this
 target is set for a rule, the Linux kernel will multicast this packet
 through a
 .IR netlink 
-- 
1.8.1.5

