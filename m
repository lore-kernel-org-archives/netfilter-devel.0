From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 8/9] build: remove -fPIC flag
Date: Sun, 31 Oct 2010 00:07:32 +0200
Message-ID: <1288476454-18451-9-git-send-email-jengelh@medozas.de>
References: <1288476454-18451-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:46312 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857Ab0J3WHp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Oct 2010 18:07:45 -0400
In-Reply-To: <1288476454-18451-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

libtool automatically adds PIC flags as needed.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 src/Makefile.am |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/src/Makefile.am b/src/Makefile.am
index cc400b9..e6bc7c4 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -1,7 +1,6 @@
 include $(top_srcdir)/Make_global.am
 
-AM_CFLAGS=-fPIC -Wall
-LIBS=
+AM_CFLAGS = -Wall
 
 lib_LTLIBRARIES = libnfnetlink.la
 
-- 
1.7.1

