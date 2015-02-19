From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 1/7] extensions: remove MIRROR
Date: Thu, 19 Feb 2015 14:11:17 +0100
Message-ID: <1424351483-27617-2-git-send-email-fw@strlen.de>
References: <1424351483-27617-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:58476 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752790AbbBSNLm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Feb 2015 08:11:42 -0500
In-Reply-To: <1424351483-27617-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

removed from the kernel back in 2003.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 extensions/libipt_MIRROR.c   | 15 ---------------
 extensions/libipt_MIRROR.man | 12 ------------
 2 files changed, 27 deletions(-)
 delete mode 100644 extensions/libipt_MIRROR.c
 delete mode 100644 extensions/libipt_MIRROR.man

diff --git a/extensions/libipt_MIRROR.c b/extensions/libipt_MIRROR.c
deleted file mode 100644
index fb78751..0000000
--- a/extensions/libipt_MIRROR.c
+++ /dev/null
@@ -1,15 +0,0 @@
-/* Shared library add-on to iptables to add MIRROR target support. */
-#include <xtables.h>
-
-static struct xtables_target mirror_tg_reg = {
-	.name		= "MIRROR",
-	.version	= XTABLES_VERSION,
-	.family		= NFPROTO_IPV4,
-	.size		= XT_ALIGN(0),
-	.userspacesize	= XT_ALIGN(0),
-};
-
-void _init(void)
-{
-	xtables_register_target(&mirror_tg_reg);
-}
diff --git a/extensions/libipt_MIRROR.man b/extensions/libipt_MIRROR.man
deleted file mode 100644
index 7b720bc..0000000
--- a/extensions/libipt_MIRROR.man
+++ /dev/null
@@ -1,12 +0,0 @@
-This is an experimental demonstration target which inverts the source
-and destination fields in the IP header and retransmits the packet.
-It is only valid in the
-.BR INPUT ,
-.B FORWARD
-and
-.B PREROUTING
-chains, and user-defined chains which are only called from those
-chains.  Note that the outgoing packets are
-.B NOT
-seen by any packet filtering chains, connection tracking or NAT, to
-avoid loops and other problems.
-- 
2.0.5

