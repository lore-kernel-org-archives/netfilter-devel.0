From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 4/7] doc: fix limit manpage to reflect actual supported syntax
Date: Mon,  1 Feb 2010 01:19:50 +0100
Message-ID: <1264983594-20871-5-git-send-email-jengelh@medozas.de>
References: <1264983594-20871-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49650 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754581Ab0BAAUB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 31 Jan 2010 19:20:01 -0500
In-Reply-To: <1264983594-20871-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

References: https://bugzilla.novell.com/561179
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_limit.man |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/extensions/libxt_limit.man b/extensions/libxt_limit.man
index c00e1d9..9f51ce3 100644
--- a/extensions/libxt_limit.man
+++ b/extensions/libxt_limit.man
@@ -4,7 +4,7 @@ A rule using this extension will match until this limit is reached
 .B LOG
 target to give limited logging, for example.
 .TP
-[\fB!\fP] \fB\-\-limit\fP \fIrate\fP[\fB/second\fP|\fB/minute\fP|\fB/hour\fP|\fB/day\fP]
+\fB\-\-limit\fP \fIrate\fP[\fB/second\fP|\fB/minute\fP|\fB/hour\fP|\fB/day\fP]
 Maximum average matching rate: specified as a number, with an optional
 `/second', `/minute', `/hour', or `/day' suffix; the default is
 3/hour.
-- 
1.6.6.1

