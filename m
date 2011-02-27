From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/9] doc: mention other possible nf_loggers for TRACE
Date: Sun, 27 Feb 2011 02:31:11 +0100
Message-ID: <1298770280-7652-2-git-send-email-jengelh@medozas.de>
References: <1298770280-7652-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:52513 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165Ab1B0Bb2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 26 Feb 2011 20:31:28 -0500
In-Reply-To: <1298770280-7652-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_TRACE.man |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/extensions/libxt_TRACE.man b/extensions/libxt_TRACE.man
index d28c3a0..ea0ce0f 100644
--- a/extensions/libxt_TRACE.man
+++ b/extensions/libxt_TRACE.man
@@ -1,7 +1,9 @@
 This target marks packes so that the kernel will log every rule which match 
-the packets as those traverse the tables, chains, rules. (The ipt_LOG or
-ip6t_LOG module 
-is required for the logging.) The packets are logged with the string prefix: 
+the packets as those traverse the tables, chains, rules.
+.PP
+A logging backend, such as ip(6)t_LOG or nfnetlink_log, must be loaded for this
+to be visible.
+The packets are logged with the string prefix:
 "TRACE: tablename:chainname:type:rulenum " where type can be "rule" for 
 plain rule, "return" for implicit rule at the end of a user defined chain 
 and "policy" for the policy of the built in chains. 
-- 
1.7.1

