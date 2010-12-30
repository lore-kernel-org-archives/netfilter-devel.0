From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/4] build: remove unused LIBTOOL_DEPS
Date: Fri, 31 Dec 2010 00:41:39 +0100
Message-ID: <1293752503-13178-2-git-send-email-jengelh@medozas.de>
References: <1293752503-13178-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:43758 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390Ab0L3Xlp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Dec 2010 18:41:45 -0500
In-Reply-To: <1293752503-13178-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 configure.ac |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/configure.ac b/configure.ac
index b194ea8..e7c1367 100644
--- a/configure.ac
+++ b/configure.ac
@@ -12,8 +12,6 @@ AM_PROG_LIBTOOL
 AC_PROG_INSTALL
 AC_PROG_LN_S
 
-AC_SUBST(LIBTOOL_DEPS)
-
 case "$host" in 
 *-*-linux*) ;;
 *) AC_MSG_ERROR([Linux only, dude!]);;
-- 
1.7.1

