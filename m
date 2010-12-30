From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/5] build: remove unused LIBTOOL_DEPS
Date: Fri, 31 Dec 2010 00:40:06 +0100
Message-ID: <1293752411-12923-2-git-send-email-jengelh@medozas.de>
References: <1293752411-12923-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:50198 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752105Ab0L3XkR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Dec 2010 18:40:17 -0500
In-Reply-To: <1293752411-12923-1-git-send-email-jengelh@medozas.de>
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
1.7.1

