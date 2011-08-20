From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 4/6] doc: fix typo in libxt_TRACE
Date: Sat, 20 Aug 2011 21:24:51 +0200
Message-ID: <1313868294-21471-5-git-send-email-jengelh@medozas.de>
References: <1313868294-21471-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:40064 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755059Ab1HTTZC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Aug 2011 15:25:02 -0400
In-Reply-To: <1313868294-21471-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Bernard Massot <bernard@massot.ath.cx>

References: http://bugzilla.netfilter.org/show_bug.cgi?id=736
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_TRACE.man |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/extensions/libxt_TRACE.man b/extensions/libxt_TRACE.man
index ea0ce0f..8d590a5 100644
--- a/extensions/libxt_TRACE.man
+++ b/extensions/libxt_TRACE.man
@@ -1,4 +1,4 @@
-This target marks packes so that the kernel will log every rule which match 
+This target marks packets so that the kernel will log every rule which match 
 the packets as those traverse the tables, chains, rules.
 .PP
 A logging backend, such as ip(6)t_LOG or nfnetlink_log, must be loaded for this
-- 
1.7.3.4

