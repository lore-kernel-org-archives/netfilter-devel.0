From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 09/10] netfilter: xt_recent: update description
Date: Tue, 16 Mar 2010 02:32:13 +0100
Message-ID: <1268703135-2622-10-git-send-email-jengelh@medozas.de>
References: <1268703135-2622-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49821 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965901Ab0CPBce (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Mar 2010 21:32:34 -0400
In-Reply-To: <1268703135-2622-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It had IPv6 for quite a while already :-)

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/netfilter/xt_recent.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index 1af74dd..bcabfbc 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -35,7 +35,7 @@
 
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
 MODULE_AUTHOR("Jan Engelhardt <jengelh@medozas.de>");
-MODULE_DESCRIPTION("Xtables: \"recently-seen\" host matching for IPv4");
+MODULE_DESCRIPTION("Xtables: \"recently-seen\" host matching");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_recent");
 MODULE_ALIAS("ip6t_recent");
-- 
1.7.0.2

