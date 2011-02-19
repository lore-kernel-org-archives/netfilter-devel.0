From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/8] doc: fix wrong sentence about negation in xt_limit
Date: Sat, 19 Feb 2011 20:04:11 +0100
Message-ID: <1298142259-11213-2-git-send-email-jengelh@medozas.de>
References: <1298142259-11213-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42356 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755014Ab1BSTEf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 19 Feb 2011 14:04:35 -0500
In-Reply-To: <1298142259-11213-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is an update to commit v1.4.7~6.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_limit.man |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_limit.man b/extensions/libxt_limit.man
index 9f51ce3..6fb94cc 100644
--- a/extensions/libxt_limit.man
+++ b/extensions/libxt_limit.man
@@ -1,8 +1,11 @@
 This module matches at a limited rate using a token bucket filter.
-A rule using this extension will match until this limit is reached
-(unless the `!' flag is used).  It can be used in combination with the
+A rule using this extension will match until this limit is reached.
+It can be used in combination with the
 .B LOG
 target to give limited logging, for example.
+.PP
+xt_limit has no negation support - you will have to use \-m hashlimit !
+\-\-hashlimit \fIrate\fP in this case whilst omitting \-\-hashlimit\-mode.
 .TP
 \fB\-\-limit\fP \fIrate\fP[\fB/second\fP|\fB/minute\fP|\fB/hour\fP|\fB/day\fP]
 Maximum average matching rate: specified as a number, with an optional
-- 
1.7.1

