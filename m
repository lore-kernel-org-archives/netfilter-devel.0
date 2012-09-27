From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 1/7] build: support for automake-1.12
Date: Fri, 28 Sep 2012 00:48:23 +0200
Message-ID: <1348786109-20894-2-git-send-email-jengelh@inai.de>
References: <1348786109-20894-1-git-send-email-jengelh@inai.de>
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:56156 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755000Ab2I0Wsc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Sep 2012 18:48:32 -0400
In-Reply-To: <1348786109-20894-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

automake-1.12 wants that AM_PROG_AR be used when LT_INIT is.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 configure.ac |    1 +
 1 file changed, 1 insertion(+)

diff --git a/configure.ac b/configure.ac
index 179c2d8..861f5b3 100644
--- a/configure.ac
+++ b/configure.ac
@@ -13,6 +13,7 @@ AM_INIT_AUTOMAKE([-Wall])
 AC_PROG_CC
 AM_PROG_CC_C_O
 AC_DISABLE_STATIC
+m4_ifdef([AM_PROG_AR], [AM_PROG_AR])
 AM_PROG_LIBTOOL
 
 AC_ARG_WITH([kernel],
-- 
1.7.10.4

