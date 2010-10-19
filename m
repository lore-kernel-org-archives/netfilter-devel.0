From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 5/8] build: remove manual -fPIC flag
Date: Tue, 19 Oct 2010 18:12:18 +0200
Message-ID: <1287504742-12922-6-git-send-email-jengelh@medozas.de>
References: <1287504742-12922-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:53572 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755115Ab0JSQMc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Oct 2010 12:12:32 -0400
In-Reply-To: <1287504742-12922-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

libtool will take care of adding -fPIC as needed. In fact, static
libraries are often not desired to be compiled with -fPIC.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 lib/Makefile.am |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/Makefile.am b/lib/Makefile.am
index 74f36e8..79b81db 100644
--- a/lib/Makefile.am
+++ b/lib/Makefile.am
@@ -1,6 +1,6 @@
 include $(top_srcdir)/Make_global.am
 
-AM_CFLAGS += -fPIC ${libmnl_CFLAGS}
+AM_CFLAGS += ${libmnl_CFLAGS}
 
 lib_LTLIBRARIES = libipset.la
 
-- 
1.7.1

