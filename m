From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/4] doc: xt_string: correct copy-and-pasting in manpage
Date: Sun,  6 Jun 2010 13:23:53 +0200
Message-ID: <1275823437-12089-2-git-send-email-jengelh@medozas.de>
References: <1275823437-12089-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:45394 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755438Ab0FFLYB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 6 Jun 2010 07:24:01 -0400
In-Reply-To: <1275823437-12089-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

References: http://bugzilla.netfilter.org/show_bug.cgi?id=653
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_string.man |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/extensions/libxt_string.man b/extensions/libxt_string.man
index 725f3ff..b6b271d 100644
--- a/extensions/libxt_string.man
+++ b/extensions/libxt_string.man
@@ -7,7 +7,9 @@ Select the pattern matching strategy. (bm = Boyer-Moore, kmp = Knuth-Pratt-Morri
 Set the offset from which it starts looking for any matching. If not passed, default is 0.
 .TP
 \fB\-\-to\fP \fIoffset\fP
-Set the offset from which it starts looking for any matching. If not passed, default is the packet size.
+Set the offset up to which should be scanned. That is, byte \fIoffset\fP-1
+(counting from 0) is the last one that is scanned.
+If not passed, default is the packet size.
 .TP
 [\fB!\fP] \fB\-\-string\fP \fIpattern\fP
 Matches the given pattern.
-- 
1.7.1

