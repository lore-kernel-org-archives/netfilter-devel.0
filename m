From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 03/10] build: avoid use of deprecated INCLUDES
Date: Sun, 31 Oct 2010 00:11:08 +0200
Message-ID: <1288476676-32749-4-git-send-email-jengelh@medozas.de>
References: <1288476676-32749-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49963 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753914Ab0J3WLV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Oct 2010 18:11:21 -0400
In-Reply-To: <1288476676-32749-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Makefile.am: "INCLUDES" is the old name for "AM_CPPFLAGS" (or "*_CPPFLAGS")

And remove unused $(all_includes)

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 src/Makefile.am   |    2 +-
 utils/Makefile.am |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/Makefile.am b/src/Makefile.am
index 63d5bc8..c408961 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -20,7 +20,7 @@
 #
 LIBVERSION=2:0:1
 
-INCLUDES = $(all_includes) -I$(top_srcdir)/include -I${KERNELDIR}
+AM_CPPFLAGS = -I$(top_srcdir)/include -I${KERNELDIR}
 AM_CFLAGS = -fPIC -Wall
 LIBS = @LIBNFQUEUE_LIBS@
 
diff --git a/utils/Makefile.am b/utils/Makefile.am
index 9a5e9d6..1f52864 100644
--- a/utils/Makefile.am
+++ b/utils/Makefile.am
@@ -1,5 +1,5 @@
 
-INCLUDES = $(all_includes) -I$(top_srcdir)/include -I${KERNELDIR} 
+AM_CPPFLAGS = -I$(top_srcdir)/include -I${KERNELDIR}
 
 check_PROGRAMS = nfqnl_test
 
-- 
1.7.1

