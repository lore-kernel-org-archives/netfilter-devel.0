From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 1/2] build: resolve automake-1.12 warnings
Date: Mon,  8 Oct 2012 14:57:19 +0200
Message-ID: <1349701040-10894-2-git-send-email-jengelh@inai.de>
References: <1349701040-10894-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:48826 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220Ab2JHM51 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Oct 2012 08:57:27 -0400
In-Reply-To: <1349701040-10894-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

/usr/share/automake-1.12/am/ltlibrary.am: warning:
'libnetfilter_cthelper.la': linking libtool libraries using a non-POSIX
archiver requires 'AM_PROG_AR' in 'configure.ac'

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 configure.ac |    1 +
 1 file changed, 1 insertion(+)

diff --git a/configure.ac b/configure.ac
index d9b0118..d52b1ce 100644
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

