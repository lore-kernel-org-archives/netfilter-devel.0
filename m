From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/3] build: disable implicit .tar.gz archive generation and use POSIX mode
Date: Sat, 17 Dec 2011 16:39:21 +0100
Message-ID: <1324136362-16840-4-git-send-email-jengelh@medozas.de>
References: <1324136362-16840-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:59829 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752415Ab1LQPj1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 17 Dec 2011 10:39:27 -0500
In-Reply-To: <1324136362-16840-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 configure.ac |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/configure.ac b/configure.ac
index 5bb032e..132cdbf 100644
--- a/configure.ac
+++ b/configure.ac
@@ -2,7 +2,7 @@ dnl Process this file with autoconf to produce a configure script.
 AC_PREREQ([2.50])
 AC_INIT([ulogd], [2.0.0beta4])
 AC_CONFIG_AUX_DIR([build-aux])
-AM_INIT_AUTOMAKE([-Wall foreign dist-bzip2 1.10b])
+AM_INIT_AUTOMAKE([-Wall foreign tar-pax no-dist-gzip dist-bzip2 1.10b])
 AC_CONFIG_HEADER([config.h])
 AC_CONFIG_MACRO_DIR([m4])
 
-- 
1.7.3.4

