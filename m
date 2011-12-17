From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/3] build: disable implicit .tar.gz archive generation and use POSIX mode
Date: Sat, 17 Dec 2011 16:37:56 +0100
Message-ID: <1324136277-10721-4-git-send-email-jengelh@medozas.de>
References: <1324136277-10721-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:59808 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752425Ab1LQPiE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 17 Dec 2011 10:38:04 -0500
In-Reply-To: <1324136277-10721-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 configure.ac |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/configure.ac b/configure.ac
index 3d536d5..22582b8 100644
--- a/configure.ac
+++ b/configure.ac
@@ -3,7 +3,8 @@ AC_CONFIG_AUX_DIR([build-aux])
 
 AC_CANONICAL_HOST
 AC_CONFIG_MACRO_DIR([m4])
-AM_INIT_AUTOMAKE([-Wall foreign subdir-objects dist-bzip2 1.6])
+AM_INIT_AUTOMAKE([-Wall foreign subdir-objects
+	tar-pax no-dist-gzip dist-bzip2 1.6])
 
 dnl kernel style compile messages
 m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])
-- 
1.7.3.4

