From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH] build: resolve automake-1.12 warnings
Date: Mon,  8 Oct 2012 15:14:19 +0200
Message-ID: <1349702059-21784-2-git-send-email-jengelh@inai.de>
References: <1349702059-21784-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:49055 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753060Ab2JHNOU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Oct 2012 09:14:20 -0400
In-Reply-To: <1349702059-21784-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

am/ltlibrary.am: warning: 'libnetfilter_cttimeout.la': linking
libtool libraries using a non-POSIX archiver requires 'AM_PROG_AR'
in 'configure.ac'

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 configure.ac |    1 +
 1 file changed, 1 insertion(+)

diff --git a/configure.ac b/configure.ac
index a4cf468..d79e941 100644
--- a/configure.ac
+++ b/configure.ac
@@ -8,6 +8,7 @@ AC_CONFIG_HEADERS([config.h])
 
 AM_INIT_AUTOMAKE([-Wall foreign tar-pax no-dist-gzip dist-bzip2
 	1.6 subdir-objects])
+m4_ifdef([AM_PROG_AR], [AM_PROG_AR])
 
 dnl kernel style compile messages
 m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])
-- 
1.7.10.4

