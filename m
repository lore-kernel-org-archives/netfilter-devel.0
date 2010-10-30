From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 04/10] build: use simpler autoreconf in autogen
Date: Sun, 31 Oct 2010 00:11:09 +0200
Message-ID: <1288476676-32749-5-git-send-email-jengelh@medozas.de>
References: <1288476676-32749-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49967 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753915Ab0J3WLX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Oct 2010 18:11:23 -0400
In-Reply-To: <1288476676-32749-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Note: the use of -i seems required, otherwise autoreconf barfs about
missing tools (depcomp, etc.). Since they are provided in the tarballs
as files anyway rather than like previously as symlinks, I do not see
a problem using -i.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 autogen.sh |   20 +++-----------------
 1 files changed, 3 insertions(+), 17 deletions(-)

diff --git a/autogen.sh b/autogen.sh
index cf697c6..57c3532 100755
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
 [ "x$1" = "xdistrib" ] && include
-run libtoolize
-run aclocal
-#run autoheader
-run automake -a
-run autoconf
+autoreconf -fi
+rm -Rf autom4te.cache
-- 
1.7.1

