From: Jan Engelhardt <jengelh@medozas.de>
Subject: build: change equality for old bash
Date: Sun, 22 Jun 2008 18:50:51 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0806221849530.24624@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:49614 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194AbYFVQuy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 22 Jun 2008 12:50:54 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 1063d1608700beb14687078b526d11bf1cf0be5f
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Sun Jun 22 14:45:48 2008 +0200

build: change equailty test for old bash
    
Michael used GNU bash, version 1.14.7(1), which apparently does not
seem to know about the double ("==") variant of equality tests.
    
Reported-by: Michael Teicher <mteicher@gmail.com>
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 configure.ac |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/configure.ac b/configure.ac
index f0ade13..22ebb7e 100644
--- a/configure.ac
+++ b/configure.ac
@@ -47,10 +47,10 @@ if test "$ac_cv_header_linux_dccp_h" != "yes"; then
 fi;
 AC_SUBST([blacklist_modules])
 
-AM_CONDITIONAL([ENABLE_STATIC], [test "$enable_static" == "yes"])
-AM_CONDITIONAL([ENABLE_SHARED], [test "$enable_shared" == "yes"])
-AM_CONDITIONAL([ENABLE_DEVEL], [test "$enable_devel" == "yes"])
-AM_CONDITIONAL([ENABLE_LIBIPQ], [test "$enable_libipq" == "yes"])
+AM_CONDITIONAL([ENABLE_STATIC], [test "$enable_static" = "yes"])
+AM_CONDITIONAL([ENABLE_SHARED], [test "$enable_shared" = "yes"])
+AM_CONDITIONAL([ENABLE_DEVEL], [test "$enable_devel" = "yes"])
+AM_CONDITIONAL([ENABLE_LIBIPQ], [test "$enable_libipq" = "yes"])
 
 regular_CFLAGS="-D_LARGEFILE_SOURCE=1 -D_LARGE_FILES -D_FILE_OFFSET_BITS=64 \
 	-D_REENTRANT -Wall -Waggregate-return -Wmissing-declarations \

