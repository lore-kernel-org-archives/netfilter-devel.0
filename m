From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 1/2] build: remove unnecessary pkgconfig->config.status dependency
Date: Mon, 25 Jun 2012 20:34:44 +0200
Message-ID: <1340649285-20005-2-git-send-email-jengelh@inai.de>
References: <1340649285-20005-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:48678 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754002Ab2FYSer (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Jun 2012 14:34:47 -0400
In-Reply-To: <1340649285-20005-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The flags obtained from pkgconfig are in essence preprocessor ones.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 Make_global.am |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Make_global.am b/Make_global.am
index b7dab7b..a4e9bd9 100644
--- a/Make_global.am
+++ b/Make_global.am
@@ -1,2 +1,2 @@
-AM_CPPFLAGS = -I${top_srcdir}/include
-AM_CFLAGS = -Wall ${LIBNFNETLINK_CFLAGS}
+AM_CPPFLAGS = -I${top_srcdir}/include ${LIBNFNETLINK_CFLAGS}
+AM_CFLAGS = -Wall
-- 
1.7.7

