From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 1/2] build: remove unnecessary AC_EXEEXT
Date: Mon, 25 Jun 2012 20:35:51 +0200
Message-ID: <1340649352-20198-2-git-send-email-jengelh@inai.de>
References: <1340649352-20198-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:48700 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754082Ab2FYSfx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Jun 2012 14:35:53 -0400
In-Reply-To: <1340649352-20198-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jan Engelhardt <jengelh@medozas.de>

The result of AC_EXEEXT is never used -- there is no ${EXEEXT} to be
found in the Makefiles.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 configure.ac |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/configure.ac b/configure.ac
index 588c9c0..4f17aee 100644
--- a/configure.ac
+++ b/configure.ac
@@ -13,7 +13,6 @@ m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])
 
 AC_PROG_CC
 AM_PROG_CC_C_O
-AC_EXEEXT
 AC_DISABLE_STATIC
 AM_PROG_LIBTOOL
 AC_PROG_INSTALL
-- 
1.7.7

