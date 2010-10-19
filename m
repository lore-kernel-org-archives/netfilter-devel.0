From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 04/10] build: use subdir-objects and CC_C_O
Date: Tue, 19 Oct 2010 12:47:35 +0200
Message-ID: <1287485262-6562-5-git-send-email-jengelh@medozas.de>
References: <1287485262-6562-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44402 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758213Ab0JSKrs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Oct 2010 06:47:48 -0400
In-Reply-To: <1287485262-6562-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 configure.ac |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/configure.ac b/configure.ac
index dfdd098..6a199c4 100644
--- a/configure.ac
+++ b/configure.ac
@@ -3,9 +3,10 @@ dnl Process this file with autoconf to create configure.
 AC_INIT([libmnl], [1.0.0-beta0])
 AC_CANONICAL_SYSTEM
 AC_CONFIG_MACRO_DIR([m4])
-AM_INIT_AUTOMAKE([foreign dist-bzip2 1.6])
+AM_INIT_AUTOMAKE([foreign dist-bzip2 1.6 subdir-objects])
 
 AC_PROG_CC
+AM_PROG_CC_C_O
 AC_EXEEXT
 AM_PROG_LIBTOOL
 AC_SUBST(LIBTOOL_DEPS)
-- 
1.7.1

