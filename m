From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 6/8] build: use subdir-objects and CC_C_O
Date: Tue, 19 Oct 2010 18:12:19 +0200
Message-ID: <1287504742-12922-7-git-send-email-jengelh@medozas.de>
References: <1287504742-12922-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:53574 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755174Ab0JSQMd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Oct 2010 12:12:33 -0400
In-Reply-To: <1287504742-12922-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 configure.ac |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/configure.ac b/configure.ac
index 99129ea..b86ec14 100644
--- a/configure.ac
+++ b/configure.ac
@@ -3,7 +3,7 @@ AC_INIT([ipset], [5.0], [kadlec@blackhole.kfki.hu])
 AC_CANONICAL_SYSTEM
 AC_CONFIG_MACRO_DIR([m4])
 AC_CONFIG_HEADER([config.h])
-AM_INIT_AUTOMAKE([-Wall -Werror foreign])
+AM_INIT_AUTOMAKE([-Wall -Werror foreign subdir-objects])
 
 dnl Shortcut: Linux supported alone
 case $target in
@@ -104,6 +104,7 @@ AM_CONDITIONAL([DISABLE_EXTRA_FLAGS], [test "x$extra_flags" = xno])
 
 dnl Checks for programs
 AC_PROG_CC
+AM_PROG_CC_C_O
 AC_PROG_LIBTOOL
 AC_PROG_INSTALL
 AC_PROG_LN_S
-- 
1.7.1

