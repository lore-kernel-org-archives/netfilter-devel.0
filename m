From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/5] build: enable automake warnings
Date: Thu, 29 Dec 2011 22:24:46 +0100
Message-ID: <1325193891-20905-2-git-send-email-jengelh@medozas.de>
References: <1325193891-20905-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:59709 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753986Ab1L2VYy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Dec 2011 16:24:54 -0500
In-Reply-To: <1325193891-20905-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 configure.ac |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/configure.ac b/configure.ac
index 62322c6..98d163c 100644
--- a/configure.ac
+++ b/configure.ac
@@ -6,7 +6,8 @@ AC_CANONICAL_HOST
 AC_CONFIG_MACRO_DIR([m4])
 AC_CONFIG_HEADERS([config.h])
 
-AM_INIT_AUTOMAKE([foreign tar-pax no-dist-gzip dist-bzip2 1.6 subdir-objects])
+AM_INIT_AUTOMAKE([-Wall foreign tar-pax no-dist-gzip dist-bzip2
+	1.6 subdir-objects])
 
 dnl kernel style compile messages
 m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])
-- 
1.7.3.4

