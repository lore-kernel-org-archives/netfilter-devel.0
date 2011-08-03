From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/2] build: fix error with automake-1.9
Date: Wed,  3 Aug 2011 17:11:58 +0200
Message-ID: <1312384319-29980-3-git-send-email-jengelh@medozas.de>
References: <1312384319-29980-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:59559 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754888Ab1HCPMD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Aug 2011 11:12:03 -0400
In-Reply-To: <1312384319-29980-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

src/Makefile.am: C objects in subdir but "AM_PROG_CC_C_O"
not in "configure.ac"

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 .gitignore   |    2 ++
 configure.ac |    1 +
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/.gitignore b/.gitignore
index 6f5ca1f..c7acff2 100644
--- a/.gitignore
+++ b/.gitignore
@@ -8,6 +8,7 @@ Makefile.in
 
 /aclocal.m4
 /autom4te.cache
+/compile
 /config.*
 /configure
 /depcomp
@@ -15,5 +16,6 @@ Makefile.in
 /libtool
 /ltmain.sh
 /missing
+/stamp-h1
 
 /*.pc
diff --git a/configure.ac b/configure.ac
index dedf2f8..25a5b41 100644
--- a/configure.ac
+++ b/configure.ac
@@ -7,6 +7,7 @@ AC_CANONICAL_HOST
 AM_INIT_AUTOMAKE([-Wall foreign subdir-objects dist-bzip2 1.6])
 
 AC_PROG_CC
+AM_PROG_CC_C_O
 AC_EXEEXT
 AC_DISABLE_STATIC
 AM_PROG_LIBTOOL
-- 
1.7.3.4

