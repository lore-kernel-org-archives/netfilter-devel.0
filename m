From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 3/7] extensions: remove 'unclean' match
Date: Thu, 19 Feb 2015 14:11:19 +0100
Message-ID: <1424351483-27617-4-git-send-email-fw@strlen.de>
References: <1424351483-27617-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:58479 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753266AbbBSNLq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Feb 2015 08:11:46 -0500
In-Reply-To: <1424351483-27617-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

removed from kernel in 2003.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 extensions/libipt_unclean.c   | 15 ---------------
 extensions/libipt_unclean.man |  2 --
 2 files changed, 17 deletions(-)
 delete mode 100644 extensions/libipt_unclean.c
 delete mode 100644 extensions/libipt_unclean.man

diff --git a/extensions/libipt_unclean.c b/extensions/libipt_unclean.c
deleted file mode 100644
index bc4a4a0..0000000
--- a/extensions/libipt_unclean.c
+++ /dev/null
@@ -1,15 +0,0 @@
-/* Shared library add-on to iptables for unclean. */
-#include <xtables.h>
-
-static struct xtables_match unclean_mt_reg = {
-	.name		= "unclean",
-	.version	= XTABLES_VERSION,
-	.family		= NFPROTO_IPV4,
-	.size		= XT_ALIGN(0),
-	.userspacesize	= XT_ALIGN(0),
-};
-
-void _init(void)
-{
-	xtables_register_match(&unclean_mt_reg);
-}
diff --git a/extensions/libipt_unclean.man b/extensions/libipt_unclean.man
deleted file mode 100644
index 3fecd55..0000000
--- a/extensions/libipt_unclean.man
+++ /dev/null
@@ -1,2 +0,0 @@
-This module takes no options, but attempts to match packets which seem
-malformed or unusual.  This is regarded as experimental.
-- 
2.0.5

