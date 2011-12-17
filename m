From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 5/6] build: install libipset/linux_ip_set_list.h
Date: Sat, 17 Dec 2011 16:35:07 +0100
Message-ID: <1324136109-31504-6-git-send-email-jengelh@medozas.de>
References: <1324136109-31504-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:59373 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667Ab1LQPfT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 17 Dec 2011 10:35:19 -0500
In-Reply-To: <1324136109-31504-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The other linux_ip_set*.h files are shipped, so this one probably
should too.
---
 include/libipset/Makefile.am |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/libipset/Makefile.am b/include/libipset/Makefile.am
index 30b0df8..d15fedd 100644
--- a/include/libipset/Makefile.am
+++ b/include/libipset/Makefile.am
@@ -4,6 +4,7 @@ pkginclude_HEADERS = \
 	linux_ip_set_bitmap.h \
 	linux_ip_set.h \
 	linux_ip_set_hash.h \
+	linux_ip_set_list.h \
 	mnl.h \
 	nf_inet_addr.h \
 	nfproto.h \
-- 
1.7.3.4

