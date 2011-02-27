From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/9] doc: fix odd partial sentence in libipt_TTL
Date: Sun, 27 Feb 2011 02:31:12 +0100
Message-ID: <1298770280-7652-3-git-send-email-jengelh@medozas.de>
References: <1298770280-7652-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:52515 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204Ab1B0Bb3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 26 Feb 2011 20:31:29 -0500
In-Reply-To: <1298770280-7652-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libipt_TTL.man |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/extensions/libipt_TTL.man b/extensions/libipt_TTL.man
index 89fc18f..cf3d1a2 100644
--- a/extensions/libipt_TTL.man
+++ b/extensions/libipt_TTL.man
@@ -3,11 +3,11 @@ how many hops (routers) a packet can traverse until it's time to live is
 exceeded.
 .PP
 Setting or incrementing the TTL field can potentially be very dangerous,
-so it should be avoided at any cost.  
-.PP
-.B Don't ever set or increment the value on packets that leave your local network!
+so it should be avoided at any cost. This target is only valid in
 .B mangle
 table.
+.PP
+.B Don't ever set or increment the value on packets that leave your local network!
 .TP
 \fB\-\-ttl\-set\fP \fIvalue\fP
 Set the TTL value to `value'.
-- 
1.7.1

