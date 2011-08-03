From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH] build: fix error with automake-1.9
Date: Wed,  3 Aug 2011 17:09:25 +0200
Message-ID: <1312384166-26541-2-git-send-email-jengelh@medozas.de>
References: <1312384166-26541-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:59515 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754579Ab1HCPJ3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Aug 2011 11:09:29 -0400
In-Reply-To: <1312384166-26541-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

src/Makefile.am: C objects in subdir but "AM_PROG_CC_C_O"
not in "configure.ac"

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 .gitignore   |    1 +
 configure.ac |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/.gitignore b/.gitignore
index c9550f5..d0fb94d 100644
--- a/.gitignore
+++ b/.gitignore
@@ -8,6 +8,7 @@ Makefile.in
 
 /aclocal.m4
 /autom4te.cache
+/compile
 /config.*
 /configure
 /depcomp
diff --git a/configure.ac b/configure.ac
index f18138e..6247629 100644
--- a/configure.ac
+++ b/configure.ac
@@ -11,6 +11,7 @@ dnl kernel style compile messages
 m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])
 
 AC_PROG_CC
+AM_PROG_CC_C_O
 AC_DISABLE_STATIC
 AM_PROG_LIBTOOL
 AC_PROG_INSTALL
-- 
1.7.3.4

