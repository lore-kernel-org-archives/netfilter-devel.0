From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH] build: resolve automake-1.12 warnings
Date: Tue,  9 Oct 2012 16:02:35 +0200
Message-ID: <1349791355-8494-2-git-send-email-jengelh@inai.de>
References: <1349791355-8494-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:54957 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754290Ab2JIOCi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Oct 2012 10:02:38 -0400
In-Reply-To: <1349791355-8494-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

am/ltlibrary.am: warning: 'libnfnetlink.la': linking libtool libraries
using a non-POSIX archiver requires 'AM_PROG_AR' in 'configure.ac'

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 configure.ac |    1 +
 1 file changed, 1 insertion(+)

diff --git a/configure.ac b/configure.ac
index ed549df..0926a1c 100644
--- a/configure.ac
+++ b/configure.ac
@@ -7,6 +7,7 @@ AC_CANONICAL_HOST
 
 AM_INIT_AUTOMAKE([-Wall foreign subdir-objects
 	tar-pax no-dist-gzip dist-bzip2 1.6])
+m4_ifdef([AM_PROG_AR], [AM_PROG_AR])
 
 dnl kernel style compile messages
 m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])
-- 
1.7.10.4

