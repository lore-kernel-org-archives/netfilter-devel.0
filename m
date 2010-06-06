From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/4] doc: xt_hashlimit: fix a typo
Date: Sun,  6 Jun 2010 13:23:54 +0200
Message-ID: <1275823437-12089-3-git-send-email-jengelh@medozas.de>
References: <1275823437-12089-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:45397 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757575Ab0FFLYD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 6 Jun 2010 07:24:03 -0400
In-Reply-To: <1275823437-12089-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

References: http://bugzilla.netfilter.org/show_bug.cgi?id=646
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_hashlimit.man |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/extensions/libxt_hashlimit.man b/extensions/libxt_hashlimit.man
index 9820a92..b870f55 100644
--- a/extensions/libxt_hashlimit.man
+++ b/extensions/libxt_hashlimit.man
@@ -7,7 +7,7 @@ quantum per group":
 matching on source host
 "1000 packets per second for every host in 192.168.0.0/16"
 .TP
-matching on source prot
+matching on source port
 "100 packets per second for every service of 192.168.1.1"
 .TP
 matching on subnet
-- 
1.7.1

