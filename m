From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 07/12] libipt_[SD]NAT: flag up module name on error
Date: Fri, 13 May 2011 02:47:31 +0200
Message-ID: <1305247657-29158-8-git-send-email-jengelh@medozas.de>
References: <1305247657-29158-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:54335 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759033Ab1EMAt2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 May 2011 20:49:28 -0400
In-Reply-To: <1305247657-29158-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libipt_DNAT.c |    2 +-
 extensions/libipt_SNAT.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/extensions/libipt_DNAT.c b/extensions/libipt_DNAT.c
index 6a46f10..8c4c9c2 100644
--- a/extensions/libipt_DNAT.c
+++ b/extensions/libipt_DNAT.c
@@ -169,7 +169,7 @@ static void DNAT_parse(struct xt_option_call *cb)
 				get_kernel_version();
 			if (kernel_version > LINUX_VERSION(2, 6, 10))
 				xtables_error(PARAMETER_PROBLEM,
-					   "Multiple --to-destination not supported");
+					   "DNAT: Multiple --to-destination not supported");
 		}
 		*cb->target = parse_to(cb->arg, portok, info);
 		/* WTF do we need this for?? */
diff --git a/extensions/libipt_SNAT.c b/extensions/libipt_SNAT.c
index 9156a7b..3691041 100644
--- a/extensions/libipt_SNAT.c
+++ b/extensions/libipt_SNAT.c
@@ -169,7 +169,7 @@ static void SNAT_parse(struct xt_option_call *cb)
 				get_kernel_version();
 			if (kernel_version > LINUX_VERSION(2, 6, 10))
 				xtables_error(PARAMETER_PROBLEM,
-					   "Multiple --to-source not supported");
+					   "SNAT: Multiple --to-source not supported");
 		}
 		*cb->target = parse_to(cb->arg, portok, info);
 		/* WTF do we need this for?? */
-- 
1.7.1

