From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/6] Add .gitignore
Date: Wed, 29 Feb 2012 08:15:37 +0100
Message-ID: <1330499742-28091-2-git-send-email-jengelh@medozas.de>
References: <1330499742-28091-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:48520 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966122Ab2B2HPu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 Feb 2012 02:15:50 -0500
In-Reply-To: <1330499742-28091-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 .gitignore |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)
 create mode 100644 .gitignore

diff --git a/.gitignore b/.gitignore
new file mode 100644
index 0000000..e6b85bf
--- /dev/null
+++ b/.gitignore
@@ -0,0 +1,18 @@
+.deps/
+.libs/
+*.la
+*.lo
+Makefile
+Makefile.in
+
+/aclocal.m4
+/autom4te.cache/
+/build-aux/
+/config.*
+/configure
+/libtool
+/stamp-h1
+
+
+/doxygen.cfg
+/*.pc
-- 
1.7.7

