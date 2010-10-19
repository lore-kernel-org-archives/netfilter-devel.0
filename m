From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 10/10] Add .gitignore files
Date: Tue, 19 Oct 2010 12:47:41 +0200
Message-ID: <1287485262-6562-11-git-send-email-jengelh@medozas.de>
References: <1287485262-6562-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44412 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758257Ab0JSKry (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Oct 2010 06:47:54 -0400
In-Reply-To: <1287485262-6562-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 .gitignore                    |   23 +++++++++++++++++++++++
 examples/genl/.gitignore      |    1 +
 examples/netfilter/.gitignore |    2 ++
 examples/rtnl/.gitignore      |    7 +++++++
 4 files changed, 33 insertions(+), 0 deletions(-)
 create mode 100644 .gitignore
 create mode 100644 examples/genl/.gitignore
 create mode 100644 examples/netfilter/.gitignore
 create mode 100644 examples/rtnl/.gitignore

diff --git a/.gitignore b/.gitignore
new file mode 100644
index 0000000..04462c0
--- /dev/null
+++ b/.gitignore
@@ -0,0 +1,23 @@
+*~
+*.la
+*.lo
+*.o
+.deps
+.libs
+Makefile
+Makefile.in
+
+/aclocal.m4
+/autom4te.cache
+/compile
+/config.*
+/configure
+/depcomp
+/install-sh
+/libtool
+/ltmain.sh
+/missing
+/stamp-h1
+
+/doxygen.cfg
+/libmnl.pc
diff --git a/examples/genl/.gitignore b/examples/genl/.gitignore
new file mode 100644
index 0000000..57f0ca9
--- /dev/null
+++ b/examples/genl/.gitignore
@@ -0,0 +1 @@
+/genl-family-get
diff --git a/examples/netfilter/.gitignore b/examples/netfilter/.gitignore
new file mode 100644
index 0000000..0d1727d
--- /dev/null
+++ b/examples/netfilter/.gitignore
@@ -0,0 +1,2 @@
+/nf-queue
+/nfct-event
diff --git a/examples/rtnl/.gitignore b/examples/rtnl/.gitignore
new file mode 100644
index 0000000..b03a27d
--- /dev/null
+++ b/examples/rtnl/.gitignore
@@ -0,0 +1,7 @@
+/rtnl-link-dump
+/rtnl-link-dump2
+/rtnl-link-dump3
+/rtnl-link-event
+/rtnl-link-set
+/rtnl-route-add
+/rtnl-route-dump
-- 
1.7.1

