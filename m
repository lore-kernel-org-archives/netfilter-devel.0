From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 2/2] build: remove unused lines in Makefile.am
Date: Mon, 25 Jun 2012 20:35:52 +0200
Message-ID: <1340649352-20198-3-git-send-email-jengelh@inai.de>
References: <1340649352-20198-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:48702 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755641Ab2FYSfy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Jun 2012 14:35:54 -0400
In-Reply-To: <1340649352-20198-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 Make_global.am |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Make_global.am b/Make_global.am
index a67e104..c16cb09 100644
--- a/Make_global.am
+++ b/Make_global.am
@@ -1,2 +1,2 @@
-AM_CPPFLAGS = -I${top_srcdir}/include -I${KERNELDIR}
-AM_CFLAGS = -Wall ${LIBNFNETLINK_CFLAGS}
+AM_CPPFLAGS = -I${top_srcdir}/include -I${KERNELDIR} ${LIBNFNETLINK_CFLAGS}
+AM_CFLAGS = -Wall
-- 
1.7.7

