From: =?UTF-8?q?S=C3=A9bastien=20Luttringer?= <seblu@seblu.net>
Subject: [PATCH] Add systemd files
Date: Mon, 21 Mar 2016 01:39:00 +0100
Message-ID: <1458520740-13951-1-git-send-email-seblu@seblu.net>
Cc: =?UTF-8?q?S=C3=A9bastien=20Luttringer?= <seblu@seblu.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from achille.seblu.net ([62.210.204.83]:37026 "EHLO
	achille.seblu.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596AbcCUAsE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Mar 2016 20:48:04 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is the current systemd service files I wrote for Arch Linux.
A Fedora maintainer suggest to move them to the upstream to share them
between distribution.
---
 configure.ac                   |  1 +
 files/Makefile.am              |  2 +-
 files/systemd/Makefile.am      |  1 +
 files/systemd/nftables-reload  |  3 +++
 files/systemd/nftables.service | 15 +++++++++++++++
 5 files changed, 21 insertions(+), 1 deletion(-)
 create mode 100644 files/systemd/Makefile.am
 create mode 100755 files/systemd/nftables-reload
 create mode 100644 files/systemd/nftables.service

diff --git a/configure.ac b/configure.ac
index 0d7e6ed..c763d0f 100644
--- a/configure.ac
+++ b/configure.ac
@@ -129,6 +129,7 @@ AC_CONFIG_FILES([					\
 		doc/Makefile				\
 		files/Makefile				\
 		files/nftables/Makefile			\
+		files/systemd/Makefile			\
 		])
 AC_OUTPUT
 
diff --git a/files/Makefile.am b/files/Makefile.am
index a8394c0..00b27db 100644
--- a/files/Makefile.am
+++ b/files/Makefile.am
@@ -1 +1 @@
-SUBDIRS = nftables
+SUBDIRS = nftables systemd
diff --git a/files/systemd/Makefile.am b/files/systemd/Makefile.am
new file mode 100644
index 0000000..3392fe9
--- /dev/null
+++ b/files/systemd/Makefile.am
@@ -0,0 +1 @@
+EXTRA_DIST = nftables.service nftables-reload
diff --git a/files/systemd/nftables-reload b/files/systemd/nftables-reload
new file mode 100755
index 0000000..1c41569
--- /dev/null
+++ b/files/systemd/nftables-reload
@@ -0,0 +1,3 @@
+#!/usr/bin/nft -f
+flush ruleset
+include "/etc/nftables.conf"
diff --git a/files/systemd/nftables.service b/files/systemd/nftables.service
new file mode 100644
index 0000000..d9b9cc4
--- /dev/null
+++ b/files/systemd/nftables.service
@@ -0,0 +1,15 @@
+[Unit]
+Description=Netfilter Tables
+Documentation=man:nft(8)
+Wants=network-pre.target
+Before=network-pre.target
+
+[Service]
+Type=oneshot
+ExecStart=/usr/bin/nft -f /etc/nftables.conf
+ExecReload=/usr/bin/nft -f /usr/lib/systemd/scripts/nftables-reload
+ExecStop=/usr/bin/nft flush ruleset
+RemainAfterExit=yes
+
+[Install]
+WantedBy=multi-user.target
-- 
2.7.4

