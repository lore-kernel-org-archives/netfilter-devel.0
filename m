From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 01/13] build: fix disable_static functionality
Date: Sat, 23 Oct 2010 07:44:38 +0200
Message-ID: <1287812691-14470-2-git-send-email-jengelh@medozas.de>
References: <1287812691-14470-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:55083 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751556Ab0JWFo7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 Oct 2010 01:44:59 -0400
In-Reply-To: <1287812691-14470-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Small slip on my part. AC_DISABLE_STATIC must actually come before
LT_INIT to have any effect. (This is even documented.)

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 configure.ac |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/configure.ac b/configure.ac
index dbb6ae3..ea1aa4b 100644
--- a/configure.ac
+++ b/configure.ac
@@ -8,8 +8,8 @@ AM_INIT_AUTOMAKE([foreign dist-bzip2 1.6 subdir-objects])
 AC_PROG_CC
 AM_PROG_CC_C_O
 AC_EXEEXT
-LT_INIT
 AC_DISABLE_STATIC
+LT_INIT
 AC_SUBST(LIBTOOL_DEPS)
 
 case $target in 
-- 
1.7.1

