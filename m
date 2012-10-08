From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH] build: resolve automake-1.12 warnings
Date: Mon,  8 Oct 2012 15:17:19 +0200
Message-ID: <1349702239-25213-2-git-send-email-jengelh@inai.de>
References: <1349702239-25213-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:49130 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753505Ab2JHNRU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Oct 2012 09:17:20 -0400
In-Reply-To: <1349702239-25213-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

am/ltlibrary.am: warning: 'libnetfilter_queue.la': linking libtool
libraries using a non-POSIX archiver requires 'AM_PROG_AR' in
'configure.ac'

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 bl           |    2 ++
 configure.ac |    1 +
 2 files changed, 3 insertions(+)
 create mode 100644 bl

diff --git a/bl b/bl
new file mode 100644
index 0000000..57eb8dd
--- /dev/null
+++ b/bl
@@ -0,0 +1,2 @@
+Error: '/home/jengelh/code/libnetfilter_queue' is not an osc project dir or working copy
+Current directory looks like git.
diff --git a/configure.ac b/configure.ac
index 0a1fbd6..07747a6 100644
--- a/configure.ac
+++ b/configure.ac
@@ -8,6 +8,7 @@ AC_CONFIG_HEADERS([config.h])
 
 AM_INIT_AUTOMAKE([-Wall foreign subdir-objects
 	tar-pax no-dist-gzip dist-bzip2 1.6])
+m4_ifdef([AM_PROG_AR], [AM_PROG_AR])
 
 dnl kernel style compile messages
 m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])
-- 
1.7.10.4

