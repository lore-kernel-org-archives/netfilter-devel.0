From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 4/6] build: include libipset/nfproto.h
Date: Sat, 17 Dec 2011 16:35:06 +0100
Message-ID: <1324136109-31504-5-git-send-email-jengelh@medozas.de>
References: <1324136109-31504-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:59372 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605Ab1LQPfS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 17 Dec 2011 10:35:18 -0500
In-Reply-To: <1324136109-31504-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

libipset/types.h, which is installed by default, requires nfproto.h.
---
 include/libipset/Makefile.am |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/libipset/Makefile.am b/include/libipset/Makefile.am
index 3c21d0f..30b0df8 100644
--- a/include/libipset/Makefile.am
+++ b/include/libipset/Makefile.am
@@ -6,6 +6,7 @@ pkginclude_HEADERS = \
 	linux_ip_set_hash.h \
 	mnl.h \
 	nf_inet_addr.h \
+	nfproto.h \
 	parse.h \
 	pfxlen.h \
 	print.h \
-- 
1.7.3.4

