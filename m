From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH] build: move library flags to CPPFLAGS
Date: Mon, 25 Jun 2012 20:25:21 +0200
Message-ID: <1340648721-16435-2-git-send-email-jengelh@inai.de>
References: <1340648721-16435-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:48573 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755696Ab2FYSZY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Jun 2012 14:25:24 -0400
In-Reply-To: <1340648721-16435-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Because the obtained flags are essentially that (preprocessor
options).

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 Make_global.am |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Make_global.am b/Make_global.am
index 557900d..e3595d2 100644
--- a/Make_global.am
+++ b/Make_global.am
@@ -4,5 +4,5 @@
 # http://sources.redhat.com/autobook/autobook/autobook_91.html
 LIBVERSION=6:0:3
 
-AM_CPPFLAGS = -I$(top_srcdir)/include
-AM_CFLAGS = -Wall ${LIBNFNETLINK_CFLAGS} ${LIBMNL_CFLAGS}
+AM_CPPFLAGS = -I$(top_srcdir)/include ${LIBNFNETLINK_CFLAGS} ${LIBMNL_CFLAGS}
+AM_CFLAGS = -Wall
-- 
1.7.7

