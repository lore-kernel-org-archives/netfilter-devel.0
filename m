From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 3/4] build: remove unused -DLIBNETFILTER_CONNTRACK_DIR
Date: Sun, 20 May 2012 00:08:11 +0200
Message-ID: <1337465292-28924-4-git-send-email-jengelh@inai.de>
References: <1337465292-28924-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:38047 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753049Ab2ESWIT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 19 May 2012 18:08:19 -0400
In-Reply-To: <1337465292-28924-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jan Engelhardt <jengelh@medozas.de>

CFLAGS must not be overriden if not set (it belongs to the user).
Since -DLIBNETFILTER_CONNTRACK_DIR is unused however, remove it
altogether.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 configure.ac |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/configure.ac b/configure.ac
index 4a78294..ba7a6f3 100644
--- a/configure.ac
+++ b/configure.ac
@@ -59,11 +59,6 @@ int main()
      ],[AC_MSG_RESULT(no)],[AC_MSG_RESULT(no)])
 fi
 
-if test ! -z "$libdir"; then
-	MODULE_DIR="\\\"$libdir/libnetfilter_conntrack/\\\""
-	CFLAGS="$CFLAGS -DLIBNETFILTER_CONNTRACK_DIR=$MODULE_DIR"
-fi
-
 dnl Output the makefile
 AC_CONFIG_FILES([Makefile src/Makefile include/Makefile utils/Makefile
 	qa/Makefile include/libnetfilter_conntrack/Makefile
-- 
1.7.7

