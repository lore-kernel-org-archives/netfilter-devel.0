From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 2/2] Update .gitignore
Date: Mon,  8 Oct 2012 14:57:20 +0200
Message-ID: <1349701040-10894-3-git-send-email-jengelh@inai.de>
References: <1349701040-10894-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:48827 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751883Ab2JHM51 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Oct 2012 08:57:27 -0400
In-Reply-To: <1349701040-10894-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 .gitignore |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)
 create mode 100644 .gitignore

diff --git a/.gitignore b/.gitignore
new file mode 100644
index 0000000..a83525b
--- /dev/null
+++ b/.gitignore
@@ -0,0 +1,18 @@
+.deps/
+.libs/
+Makefile
+Makefile.in
+*.o
+*.la
+*.lo
+
+/aclocal.m4
+/autom4te.cache/
+/build-aux/
+/config.*
+/configure
+/libtool
+
+/doxygen.cfg
+/*.pc
+/stamp-h1
-- 
1.7.10.4

