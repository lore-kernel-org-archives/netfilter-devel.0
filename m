From: Vlad Dogaru <ddvlad@rosedu.org>
Subject: [PATCH] iptables: fix MASQUERADE section of man page
Date: Wed,  8 Jun 2011 15:22:22 +0300
Message-ID: <1307535742-24214-1-git-send-email-ddvlad@rosedu.org>
Cc: Vlad Dogaru <ddvlad@rosedu.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from [141.85.37.41] ([141.85.37.41]:37604 "EHLO swarm.cs.pub.ro"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751029Ab1FHMb7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jun 2011 08:31:59 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The section about MASQUERADE specifies that it takes a single option,
but in reality it takes two: --to-ports and --random.

Signed-off-by: Vlad Dogaru <ddvlad@rosedu.org>
---
 extensions/libipt_MASQUERADE.man |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/extensions/libipt_MASQUERADE.man b/extensions/libipt_MASQUERADE.man
index 8f42993..2dae964 100644
--- a/extensions/libipt_MASQUERADE.man
+++ b/extensions/libipt_MASQUERADE.man
@@ -10,7 +10,7 @@ effect that connections are
 .I forgotten
 when the interface goes down.  This is the correct behavior when the
 next dialup is unlikely to have the same interface address (and hence
-any established connections are lost anyway).  It takes one option:
+any established connections are lost anyway).
 .TP
 \fB\-\-to\-ports\fP \fIport\fP[\fB\-\fP\fIport\fP]
 This specifies a range of source ports to use, overriding the default
-- 
1.7.4.1

