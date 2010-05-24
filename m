From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH] utils: add missing include flags to Makefile
Date: Mon, 24 May 2010 07:53:32 +0200
Message-ID: <1274680413-25691-2-git-send-email-jengelh@medozas.de>
References: <4BF74E78.1030805@lists.schang.net>
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	netfilter@lists.schang.net
To: kaber@trash.net
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <4BF74E78.1030805@lists.schang.net>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Fixes this compile error:

  CC     nfnl_osf.o
nfnl_osf.c:48:36: fatal error: linux/netfilter/xt_osf.h: No such file or directory
compilation terminated.

References: http://marc.info/?l=netfilter&m=127449929621579&w=2
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 utils/Makefile.am |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/utils/Makefile.am b/utils/Makefile.am
index d023b0c..79ce34b 100644
--- a/utils/Makefile.am
+++ b/utils/Makefile.am
@@ -1,5 +1,7 @@
 # -*- Makefile -*-
 
+AM_CFLAGS = ${regular_CFLAGS} -I${top_builddir}/include -I${top_srcdir}/include
+
 sbin_PROGRAMS = nfnl_osf
 pkgdata_DATA = pf.os
 
-- 
1.7.1

