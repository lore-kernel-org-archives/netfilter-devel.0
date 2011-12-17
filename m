From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 4/4] build: disable implicit .tar.gz archive generation and use POSIX mode
Date: Sat, 17 Dec 2011 16:37:10 +0100
Message-ID: <1324136231-25643-5-git-send-email-jengelh@medozas.de>
References: <1324136231-25643-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:59776 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752352Ab1LQPhR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 17 Dec 2011 10:37:17 -0500
In-Reply-To: <1324136231-25643-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 configure.ac |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/configure.ac b/configure.ac
index 130ca75..69173e6 100644
--- a/configure.ac
+++ b/configure.ac
@@ -5,7 +5,7 @@ AC_CONFIG_AUX_DIR([build-aux])
 AC_CANONICAL_HOST
 AC_CONFIG_MACRO_DIR([m4])
 AC_CONFIG_HEADERS([config.h])
-AM_INIT_AUTOMAKE([foreign dist-bzip2 1.6 subdir-objects])
+AM_INIT_AUTOMAKE([foreign tar-pax no-dist-gzip dist-bzip2 1.6 subdir-objects])
 
 AC_PROG_CC
 AM_PROG_CC_C_O
-- 
1.7.3.4

