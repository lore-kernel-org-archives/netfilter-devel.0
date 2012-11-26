From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 1/2] build: resolve automake-1.12 warnings
Date: Tue, 27 Nov 2012 00:54:58 +0100
Message-ID: <1353974099-19891-2-git-send-email-jengelh@inai.de>
References: <1353974099-19891-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: eric@regit.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:48989 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932424Ab2KZXzK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Nov 2012 18:55:10 -0500
In-Reply-To: <1353974099-19891-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

/usr/share/automake-1.12/am/ltlibrary.am: warning:
'ulogd_output_SQLITE3.la': linking libtool libraries using a non-POSIX
archiver requires 'AM_PROG_AR' in 'configure.ac'
(one for each .la)

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 configure.ac |    1 +
 1 file changed, 1 insertion(+)

diff --git a/configure.ac b/configure.ac
index c70887d..df0e9d3 100644
--- a/configure.ac
+++ b/configure.ac
@@ -6,6 +6,7 @@ AM_INIT_AUTOMAKE([-Wall foreign tar-pax no-dist-gzip dist-bzip2 1.10b])
 AC_CONFIG_HEADER([config.h])
 AC_CONFIG_MACRO_DIR([m4])
 
+m4_ifdef([AM_PROG_AR], [AM_PROG_AR])
 dnl kernel style compile messages
 m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])
 
-- 
1.7.10.4

