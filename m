From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 09/10] build: default to not build static libraries
Date: Tue, 19 Oct 2010 12:47:40 +0200
Message-ID: <1287485262-6562-10-git-send-email-jengelh@medozas.de>
References: <1287485262-6562-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44411 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758257Ab0JSKrx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Oct 2010 06:47:53 -0400
In-Reply-To: <1287485262-6562-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Users wanting static libraries can just use
./configure --enable-static.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 configure.ac |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/configure.ac b/configure.ac
index d9567ea..dbb6ae3 100644
--- a/configure.ac
+++ b/configure.ac
@@ -9,6 +9,7 @@ AC_PROG_CC
 AM_PROG_CC_C_O
 AC_EXEEXT
 LT_INIT
+AC_DISABLE_STATIC
 AC_SUBST(LIBTOOL_DEPS)
 
 case $target in 
-- 
1.7.1

