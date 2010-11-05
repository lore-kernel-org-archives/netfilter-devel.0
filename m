From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/5] build: default to not building static libraries
Date: Fri,  5 Nov 2010 18:56:50 +0100
Message-ID: <1288979814-18512-3-git-send-email-jengelh@medozas.de>
References: <1288979814-18512-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:55374 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753332Ab0KER46 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Nov 2010 13:56:58 -0400
In-Reply-To: <1288979814-18512-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 configure.ac |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/configure.ac b/configure.ac
index 37fbeee..1d5ac2b 100644
--- a/configure.ac
+++ b/configure.ac
@@ -6,6 +6,7 @@ AC_CONFIG_MACRO_DIR([m4])
 AM_INIT_AUTOMAKE([-Wall foreign subdir-objects dist-bzip2 1.6])
 
 AC_PROG_CC
+AC_DISABLE_STATIC
 AM_PROG_LIBTOOL
 AC_PROG_INSTALL
 AC_PROG_LN_S
-- 
1.7.1

