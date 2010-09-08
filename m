From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 6/7] build: no need for error message in PKG_CHECK_MODULES
Date: Thu,  9 Sep 2010 01:32:41 +0200
Message-ID: <1283988763-1577-7-git-send-email-jengelh@medozas.de>
References: <1283988763-1577-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:48417 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756753Ab0IHXcv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Sep 2010 19:32:51 -0400
In-Reply-To: <1283988763-1577-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

PKG_CHECK_MODULES already produces its own (and more verbose) messsage
when a module cannot be found.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 configure.ac |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/configure.ac b/configure.ac
index fe5b6fa..d5b65af 100644
--- a/configure.ac
+++ b/configure.ac
@@ -19,8 +19,6 @@ case "$host" in
 esac
 
 dnl Dependencies
-LIBNFNETLINK_REQUIRED=1.0.0
-
 AC_CHECK_PROG(HAVE_PKG_CONFIG, pkg-config, yes)
 if test "x$HAVE_PKG_CONFIG" = "x"
 then
@@ -29,8 +27,7 @@ then
 	exit 1
 fi
 
-PKG_CHECK_MODULES(LIBNFNETLINK, libnfnetlink >= $LIBNFNETLINK_REQUIRED,,
-	AC_MSG_ERROR(Cannot find libnfnetlink >= $LIBNFNETLINK_REQUIRED))
+PKG_CHECK_MODULES([LIBNFNETLINK], [libnfnetlink >= 1.0.0])
 
 AC_CHECK_HEADERS(arpa/inet.h)
 dnl Check for inet_ntop
-- 
1.7.1

