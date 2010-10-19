From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/8] build: just use autoreconf
Date: Tue, 19 Oct 2010 18:12:14 +0200
Message-ID: <1287504742-12922-2-git-send-email-jengelh@medozas.de>
References: <1287504742-12922-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:53564 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754720Ab0JSQM2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Oct 2010 12:12:28 -0400
In-Reply-To: <1287504742-12922-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is the recommended way to regenerate the GNU build system files
these days.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 autogen.sh |   18 ++----------------
 1 files changed, 2 insertions(+), 16 deletions(-)

diff --git a/autogen.sh b/autogen.sh
index d65b0b7..72240f7 100755
--- a/autogen.sh
+++ b/autogen.sh
@@ -1,18 +1,4 @@
 #!/bin/sh
 
-run ()
-{
-    echo "running: $*"
-    eval $*
-
-    if test $? != 0 ; then
-	echo "error: while running '$*'"
-	exit 1
-    fi
-}
-
-run aclocal
-run autoheader
-run libtoolize -f
-run automake -a
-run autoconf
+autoreconf -fi
+rm -Rf autom4te.cache
-- 
1.7.1

