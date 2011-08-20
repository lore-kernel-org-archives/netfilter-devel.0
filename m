From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/6] libxt_set: update man page about kernel support on the feature
Date: Sat, 20 Aug 2011 21:24:49 +0200
Message-ID: <1313868294-21471-3-git-send-email-jengelh@medozas.de>
References: <1313868294-21471-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:40058 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755016Ab1HTTZA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Aug 2011 15:25:00 -0400
In-Reply-To: <1313868294-21471-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_SET.man |    5 ++---
 extensions/libxt_set.man |    5 ++---
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/extensions/libxt_SET.man b/extensions/libxt_SET.man
index 739be41..63eb383 100644
--- a/extensions/libxt_SET.man
+++ b/extensions/libxt_SET.man
@@ -21,6 +21,5 @@ one from the set definition
 when adding entry if it already exists, reset the timeout value
 to the specified one or to the default from the set definition
 .PP
-Use of -j SET requires that ipset kernel support is provided. As standard
-kernels do not ship this currently, the ipset or Xtables-addons package needs
-to be installed.
+Use of -j SET requires that ipset kernel support is provided, which, for
+standard kernels, is the case since Linux 2.6.39.
diff --git a/extensions/libxt_set.man b/extensions/libxt_set.man
index 01b115f..1ad9085 100644
--- a/extensions/libxt_set.man
+++ b/extensions/libxt_set.man
@@ -18,6 +18,5 @@ found in the specified set.
 The option \fB\-\-match\-set\fP can be replaced by \fB\-\-set\fP if that does 
 not clash with an option of other extensions.
 .PP
-Use of -m set requires that ipset kernel support is provided. As standard
-kernels do not ship this currently, the ipset or Xtables-addons package needs
-to be installed.
+Use of -m set requires that ipset kernel support is provided, which, for
+standard kernels, is the case since Linux 2.6.39.
-- 
1.7.3.4

