From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 2/7] doc: grammatical updates to libxt_SET
Date: Sat, 28 Jul 2012 19:21:04 +0200
Message-ID: <1343496069-5442-3-git-send-email-jengelh@inai.de>
References: <1343496069-5442-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:34339 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752933Ab2G1RVQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 28 Jul 2012 13:21:16 -0400
In-Reply-To: <1343496069-5442-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Cherry-picked these from recent patches from Mr Dash Four.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 extensions/libxt_SET.man |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/extensions/libxt_SET.man b/extensions/libxt_SET.man
index 63eb383..c35ba93 100644
--- a/extensions/libxt_SET.man
+++ b/extensions/libxt_SET.man
@@ -1,24 +1,24 @@
-This modules adds and/or deletes entries from IP sets which can be defined 
+This module adds and/or deletes entries from IP sets which can be defined
 by ipset(8).
 .TP
 \fB\-\-add\-set\fP \fIsetname\fP \fIflag\fP[\fB,\fP\fIflag\fP...]
-add the address(es)/port(s) of the packet to the sets
+add the address(es)/port(s) of the packet to the set
 .TP
 \fB\-\-del\-set\fP \fIsetname\fP \fIflag\fP[\fB,\fP\fIflag\fP...]
-delete the address(es)/port(s) of the packet from the sets
+delete the address(es)/port(s) of the packet from the set
 .IP
-where flags are
+where \fIflag\fP(s) are
 .BR "src"
 and/or
 .BR "dst"
 specifications and there can be no more than six of them.
 .TP
 \fB\-\-timeout\fP \fIvalue\fP
-when adding entry, the timeout value to use instead of the default
+when adding an entry, the timeout value to use instead of the default
 one from the set definition
 .TP
 \fB\-\-exist\fP
-when adding entry if it already exists, reset the timeout value
+when adding an entry if it already exists, reset the timeout value
 to the specified one or to the default from the set definition
 .PP
 Use of -j SET requires that ipset kernel support is provided, which, for
-- 
1.7.7

