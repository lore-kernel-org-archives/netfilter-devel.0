From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 1/2] build: resolve automake 1.12 warning
Date: Sun, 20 Oct 2013 16:29:15 +0200
Message-ID: <1382279356-5050-2-git-send-email-jengelh@inai.de>
References: <1382279356-5050-1-git-send-email-jengelh@inai.de>
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:38891 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089Ab3JTO3V (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Oct 2013 10:29:21 -0400
In-Reply-To: <1382279356-5050-1-git-send-email-jengelh@inai.de>
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

