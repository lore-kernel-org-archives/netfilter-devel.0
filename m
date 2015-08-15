From: Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH] configure: fix 3rd arg w/AC_ARG_ENABLE
Date: Sat, 15 Aug 2015 14:13:35 -0400
Message-ID: <1439662415-4374-1-git-send-email-vapier@gentoo.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:53886 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752683AbbHOSNi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 15 Aug 2015 14:13:38 -0400
Received: from localhost.localdomain (localhost [127.0.0.1])
	by smtp.gentoo.org (Postfix) with ESMTP id D6EDC340BD0
	for <netfilter-devel@vger.kernel.org>; Sat, 15 Aug 2015 18:13:37 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The 3rd arg is used when --{enable,disable}-foo are passed in, not when
the feature is enabled.  Use the existing $enableval instead.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 configure.ac | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/configure.ac b/configure.ac
index 2521ccc..7ff572a 100644
--- a/configure.ac
+++ b/configure.ac
@@ -53,10 +53,10 @@ AC_ARG_ENABLE([libipq],
 	[enable_libipq="$enableval"], [enable_libipq="no"])
 AC_ARG_ENABLE([bpf-compiler],
 	AS_HELP_STRING([--enable-bpf-compiler], [Build bpf compiler]),
-	[enable_bpfc="yes"], [enable_bpfc="no"])
+	[enable_bpfc="$enableval"], [enable_bpfc="no"])
 AC_ARG_ENABLE([nfsynproxy],
 	AS_HELP_STRING([--enable-nfsynproxy], [Build SYNPROXY configuration tool]),
-	[enable_nfsynproxy="yes"], [enable_nfsynproxy="no"])
+	[enable_nfsynproxy="$enableval"], [enable_nfsynproxy="no"])
 AC_ARG_WITH([pkgconfigdir], AS_HELP_STRING([--with-pkgconfigdir=PATH],
 	[Path to the pkgconfig directory [[LIBDIR/pkgconfig]]]),
 	[pkgconfigdir="$withval"], [pkgconfigdir='${libdir}/pkgconfig'])
-- 
2.4.4

