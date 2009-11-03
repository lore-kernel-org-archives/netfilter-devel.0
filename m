From: Natanael Copa <natanael.copa@gmail.com>
Subject: [PATCH] build: fix --without-kbuild
Date: Tue,  3 Nov 2009 13:54:57 +0000
Message-ID: <1257256497-26243-2-git-send-email-natanael.copa@gmail.com>
References: <1257256497-26243-1-git-send-email-natanael.copa@gmail.com>
Cc: Natanael Copa <natanael.copa@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:46054 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbZKCNyw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Nov 2009 08:54:52 -0500
Received: by mail-bw0-f227.google.com with SMTP id 27so7619178bwz.21
        for <netfilter-devel@vger.kernel.org>; Tue, 03 Nov 2009 05:54:57 -0800 (PST)
In-Reply-To: <1257256497-26243-1-git-send-email-natanael.copa@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patch fixes ./configure --without-kbuild
---
 configure.ac |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/configure.ac b/configure.ac
index 3475611..3b84fb0 100644
--- a/configure.ac
+++ b/configure.ac
@@ -9,11 +9,18 @@ AM_PROG_CC_C_O
 AC_DISABLE_STATIC
 AC_PROG_LIBTOOL
 
-kbuilddir="/lib/modules/$(uname -r)/build";
 AC_ARG_WITH([kbuild],
 	AS_HELP_STRING([--with-kbuild=PATH],
 	[Path to kernel build directory [[/lib/modules/CURRENT/build]]]),
-	[kbuilddir="$withval"])
+	[kbuilddir="$withval"],
+	[kbuilddir="/lib/modules/$(uname -r)/build"])
+#
+# check for --without-kbuild
+#
+if [[ "$kbuilddir" = no ]]; then
+	kbuilddir=
+fi
+
 AC_ARG_WITH([ksource],,[ksourcedir="$withval"])
 AC_ARG_WITH([xtables],
 	AS_HELP_STRING([--with-xtables=PATH],
-- 
1.6.5

