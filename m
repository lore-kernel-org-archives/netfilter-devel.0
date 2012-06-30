From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH] build: remove stray empty variable
Date: Sat, 30 Jun 2012 03:07:54 +0200
Message-ID: <1341018474-1274-2-git-send-email-jengelh@inai.de>
References: <1341018474-1274-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:57308 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752778Ab2F3BSE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Jun 2012 21:18:04 -0400
In-Reply-To: <1341018474-1274-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Compilation can fail when libnfnetlink is not in a directory searched
by default. Reason is the empty KERNELDIR variable which makes for a
gcc command like:

	gcc -I. -I../include -I -Wall -I/usr/include/libnfnetlink-1.0.0+git28
	-Wall -c libnetfilter_queue.c

What one would expect is that gcc would search in the (non-existent)
directory "-Wall" and just continue as usual, since -Wall is specified
again. Instead, gcc versions before 4.6 attempt to search the
(similarly non-existent) directory "-I/usr/[...]" and thus miss.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 Make_global.am |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Make_global.am b/Make_global.am
index c16cb09..a4e9bd9 100644
--- a/Make_global.am
+++ b/Make_global.am
@@ -1,2 +1,2 @@
-AM_CPPFLAGS = -I${top_srcdir}/include -I${KERNELDIR} ${LIBNFNETLINK_CFLAGS}
+AM_CPPFLAGS = -I${top_srcdir}/include ${LIBNFNETLINK_CFLAGS}
 AM_CFLAGS = -Wall
-- 
1.7.7

