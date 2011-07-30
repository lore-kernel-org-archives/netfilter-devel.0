From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/3] build: remove unused LIBTOOL_DEPS
Date: Sat, 30 Jul 2011 21:11:01 +0200
Message-ID: <1312053064-2153-2-git-send-email-jengelh@medozas.de>
References: <1312053064-2153-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:36863 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752323Ab1G3TLI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Jul 2011 15:11:08 -0400
In-Reply-To: <1312053064-2153-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 configure.ac |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/configure.ac b/configure.ac
index 3d62082..dedf2f8 100644
--- a/configure.ac
+++ b/configure.ac
@@ -10,7 +10,6 @@ AC_PROG_CC
 AC_EXEEXT
 AC_DISABLE_STATIC
 AM_PROG_LIBTOOL
-AC_SUBST(LIBTOOL_DEPS)
 
 case "$host" in 
 *-*-linux*) ;;
-- 
1.7.3.4

