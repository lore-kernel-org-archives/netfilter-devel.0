From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 1/4] build: don't install internal.h
Date: Fri, 26 Apr 2013 10:33:28 +0200
Message-ID: <1366965211-23412-2-git-send-email-fw@strlen.de>
References: <1366965211-23412-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:48573 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932449Ab3DZIbZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Apr 2013 04:31:25 -0400
In-Reply-To: <1366965211-23412-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 src/Makefile.am |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/src/Makefile.am b/src/Makefile.am
index d694794..6e5d503 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -24,7 +24,7 @@ include ${top_srcdir}/Make_global.am
 
 lib_LTLIBRARIES = libnetfilter_queue.la
 
-include_HEADERS = internal.h
+noinst_HEADERS = internal.h
 
 libnetfilter_queue_la_LDFLAGS = -Wc,-nostartfiles -lnfnetlink \
 				-version-info $(LIBVERSION)
-- 
1.7.8.6

