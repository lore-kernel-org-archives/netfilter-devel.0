From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 5/7] doc: mention requirement of additional packages for ipset
Date: Mon,  1 Feb 2010 01:19:51 +0100
Message-ID: <1264983594-20871-6-git-send-email-jengelh@medozas.de>
References: <1264983594-20871-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49655 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754589Ab0BAAUD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 31 Jan 2010 19:20:03 -0500
In-Reply-To: <1264983594-20871-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

References: https://bugzilla.novell.com/561177
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libipt_SET.man |    4 ++++
 extensions/libipt_set.man |    4 ++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/extensions/libipt_SET.man b/extensions/libipt_SET.man
index 0dce1c7..ea80c2a 100644
--- a/extensions/libipt_SET.man
+++ b/extensions/libipt_SET.man
@@ -12,3 +12,7 @@ where flags are
 and/or
 .BR "dst"
 specifications and there can be no more than six of them.
+.PP
+Use of -j SET requires that ipset kernel support is provided. As standard
+kernels do not ship this currently, the ipset or Xtables-addons package needs
+to be installed.
diff --git a/extensions/libipt_set.man b/extensions/libipt_set.man
index 93b42d3..aca1bfc 100644
--- a/extensions/libipt_set.man
+++ b/extensions/libipt_set.man
@@ -17,3 +17,7 @@ found in the specified set.
 .PP
 The option \fB\-\-match\-set\fR can be replaced by \fB\-\-set\fR if that does 
 not clash with an option of other extensions.
+.PP
+Use of -m set requires that ipset kernel support is provided. As standard
+kernels do not ship this currently, the ipset or Xtables-addons package needs
+to be installed.
-- 
1.6.6.1

