From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/3] build: default to not building static libraries
Date: Fri,  5 Nov 2010 18:37:29 +0100
Message-ID: <1288978652-15892-2-git-send-email-jengelh@medozas.de>
References: <1288978652-15892-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42072 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754062Ab0KERhf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Nov 2010 13:37:35 -0400
In-Reply-To: <1288978652-15892-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 configure.ac |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/configure.ac b/configure.ac
index 429f0a7..18e546f 100644
--- a/configure.ac
+++ b/configure.ac
@@ -7,6 +7,7 @@ AC_CONFIG_MACRO_DIR([m4])
 AM_INIT_AUTOMAKE([-Wall foreign subdir-objects dist-bzip2 1.6])
 
 AC_PROG_CC
+AC_DISABLE_STATIC
 AM_PROG_LIBTOOL
 AC_PROG_INSTALL
 AC_PROG_LN_S
-- 
1.7.1

