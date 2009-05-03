From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/9] DNAT/SNAT: add manpage documentation for --persistent flag
Date: Sun,  3 May 2009 21:54:26 +0200
Message-ID: <1241380473-22262-3-git-send-email-jengelh@medozas.de>
References: <1241380473-22262-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:34569 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966AbZECTyf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 May 2009 15:54:35 -0400
In-Reply-To: <1241380473-22262-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libipt_DNAT.man |    7 +++++--
 extensions/libipt_SAME.man |    2 ++
 extensions/libipt_SNAT.man |    7 +++++--
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/extensions/libipt_DNAT.man b/extensions/libipt_DNAT.man
index 22e84c6..d1e0a3a 100644
--- a/extensions/libipt_DNAT.man
+++ b/extensions/libipt_DNAT.man
@@ -32,5 +32,8 @@ anymore.
 If option
 \fB\-\-random\fP
 is used then port mapping will be randomized (kernel >= 2.6.22).
-.RS
-.PP
+.TP
+\fB\-\-persistent\fP
+Gives a client the same source-/destination-address for each connection.
+This supersedes the SAME target. Support for persistent mappings is available
+from 2.6.29-rc2.
diff --git a/extensions/libipt_SAME.man b/extensions/libipt_SAME.man
index b862aa4..a99dc73 100644
--- a/extensions/libipt_SAME.man
+++ b/extensions/libipt_SAME.man
@@ -1,6 +1,8 @@
 Similar to SNAT/DNAT depending on chain: it takes a range of addresses
 (`\-\-to 1.2.3.4\-1.2.3.7') and gives a client the same
 source-/destination-address for each connection.
+.PP
+N.B.: The DNAT target's \fB\-\-persistent\fP option replaced the SAME target.
 .TP
 \fB\-\-to\fP \fIipaddr\fP[\fB\-\fP\fIipaddr\fP]
 Addresses to map source to. May be specified more than once for
diff --git a/extensions/libipt_SNAT.man b/extensions/libipt_SNAT.man
index 040571b..6b828fd 100644
--- a/extensions/libipt_SNAT.man
+++ b/extensions/libipt_SNAT.man
@@ -30,5 +30,8 @@ anymore.
 If option
 \fB\-\-random\fP
 is used then port mapping will be randomized (kernel >= 2.6.21).
-.RS
-.PP
+.TP
+\fB\-\-persistent\fP
+Gives a client the same source-/destination-address for each connection.
+This supersedes the SAME target. Support for persistent mappings is available
+from 2.6.29-rc2.
-- 
1.6.2.2

