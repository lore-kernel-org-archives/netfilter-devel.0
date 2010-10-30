From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 04/11] build: use simpler autoreconf in autogen
Date: Sun, 31 Oct 2010 00:09:52 +0200
Message-ID: <1288476600-29859-5-git-send-email-jengelh@medozas.de>
References: <1288476600-29859-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49905 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753809Ab0J3WKG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Oct 2010 18:10:06 -0400
In-Reply-To: <1288476600-29859-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 autogen.sh |   20 +++-----------------
 1 files changed, 3 insertions(+), 17 deletions(-)

diff --git a/autogen.sh b/autogen.sh
index b962504..ce22b64 100755
--- a/autogen.sh
+++ b/autogen.sh
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/sh -e
 
 include ()
 {
@@ -34,20 +34,6 @@ include ()
     fi
 }
 
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
 [ "x$1" == "xdistrib" ] && include
-run aclocal
-#run autoheader
-run libtoolize -f
-run automake -a
-run autoconf
+autoreconf -fi
+rm -Rf autom4te.cache
-- 
1.7.1

