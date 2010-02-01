From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/7] doc: fix recent manpage to reflect actual supported syntax
Date: Mon,  1 Feb 2010 01:19:49 +0100
Message-ID: <1264983594-20871-4-git-send-email-jengelh@medozas.de>
References: <1264983594-20871-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49647 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754264Ab0BAAT7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 31 Jan 2010 19:19:59 -0500
In-Reply-To: <1264983594-20871-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

References: https://bugzilla.novell.com/561180
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_recent.man |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_recent.man b/extensions/libxt_recent.man
index aa138df..532c328 100644
--- a/extensions/libxt_recent.man
+++ b/extensions/libxt_recent.man
@@ -4,6 +4,9 @@ that list in a few different ways.
 For example, you can create a "badguy" list out of people attempting to connect
 to port 139 on your firewall and then DROP all future packets from them without
 considering them.
+.PP
+\fB\-\-set\fP, \fB\-\-rcheck\fP, \fB\-\-update\fP and \fB\-\-remove\fP are
+mutually exclusive.
 .TP
 \fB\-\-name\fP \fIname\fP
 Specify the list to use for the commands. If no name is given then
@@ -33,12 +36,12 @@ Check if the source address of the packet is currently in the list and if so
 that address will be removed from the list and the rule will return true. If
 the address is not found, false is returned.
 .TP
-[\fB!\fR] \fB\-\-seconds\fP \fIseconds\fP
+\fB\-\-seconds\fP \fIseconds\fP
 This option must be used in conjunction with one of \fB\-\-rcheck\fP or
 \fB\-\-update\fP. When used, this will narrow the match to only happen when the
 address is in the list and was seen within the last given number of seconds.
 .TP
-[\fB!\fR] \fB\-\-hitcount\fP \fIhits\fP
+\fB\-\-hitcount\fP \fIhits\fP
 This option must be used in conjunction with one of \fB\-\-rcheck\fP or
 \fB\-\-update\fP. When used, this will narrow the match to only happen when the
 address is in the list and packets had been received greater than or equal to
-- 
1.6.6.1

