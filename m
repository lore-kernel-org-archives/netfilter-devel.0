From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/3] build: remove unused LIBTOOL_DEPS
Date: Fri, 31 Dec 2010 00:42:52 +0100
Message-ID: <1293752575-13611-2-git-send-email-jengelh@medozas.de>
References: <1293752575-13611-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:43816 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752545Ab0L3Xm6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Dec 2010 18:42:58 -0500
In-Reply-To: <1293752575-13611-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 configure.ac |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/configure.ac b/configure.ac
index 3831697..4ea53b9 100644
--- a/configure.ac
+++ b/configure.ac
@@ -12,8 +12,6 @@ AC_DISABLE_STATIC
 AM_PROG_LIBTOOL
 AC_PROG_INSTALL
 
-AC_SUBST(LIBTOOL_DEPS)
-
 case "$host" in
 *-*-linux*) ;;
 *) AC_MSG_ERROR([Linux only, dude!]);;
-- 
1.7.1

