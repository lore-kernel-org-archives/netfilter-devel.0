From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 1/4] build: resolve automake 1.12 warning
Date: Mon, 28 Oct 2013 13:27:17 +0100
Message-ID: <1382963240-18760-2-git-send-email-jengelh@inai.de>
References: <1382963240-18760-1-git-send-email-jengelh@inai.de>
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:34045 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756132Ab3J1M11 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Oct 2013 08:27:27 -0400
In-Reply-To: <1382963240-18760-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

ltlibrary.am: archiver requires 'AM_PROG_AR' in 'configure.ac'

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 configure.ac | 1 +
 1 file changed, 1 insertion(+)

diff --git a/configure.ac b/configure.ac
index 4d601a6..4758a49 100644
--- a/configure.ac
+++ b/configure.ac
@@ -5,6 +5,7 @@ AC_CONFIG_AUX_DIR([build-aux])
 AC_CANONICAL_HOST
 AC_CONFIG_MACRO_DIR([m4])
 AC_CONFIG_HEADERS([config.h])
+m4_ifdef([AM_PROG_AR], [AM_PROG_AR])
 
 AM_INIT_AUTOMAKE([-Wall foreign tar-pax no-dist-gzip dist-bzip2
 	1.6 subdir-objects])
-- 
1.8.2

