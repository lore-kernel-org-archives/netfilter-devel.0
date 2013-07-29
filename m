From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 1/7] netfilter: connlabels: remove unneeded includes
Date: Mon, 29 Jul 2013 15:41:50 +0200
Message-ID: <1375105316-13216-2-git-send-email-fw@strlen.de>
References: <1375105316-13216-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:52395 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756155Ab3G2NkY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 29 Jul 2013 09:40:24 -0400
In-Reply-To: <1375105316-13216-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

leftovers from the (never merged) v1 patch.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_labels.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_labels.c b/net/netfilter/nf_conntrack_labels.c
index 8fe2e99..d3c352b 100644
--- a/net/netfilter/nf_conntrack_labels.c
+++ b/net/netfilter/nf_conntrack_labels.c
@@ -8,12 +8,8 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/ctype.h>
 #include <linux/export.h>
-#include <linux/jhash.h>
-#include <linux/spinlock.h>
 #include <linux/types.h>
-#include <linux/slab.h>
 
 #include <net/netfilter/nf_conntrack_ecache.h>
 #include <net/netfilter/nf_conntrack_labels.h>
-- 
1.7.8.6

