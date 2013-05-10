From: Eric Leblond <eric@regit.org>
Subject: [PATCH] libipset.pc must be installed via 'make install'
Date: Fri, 10 May 2013 22:25:17 +0200
Message-ID: <1368217517-19894-1-git-send-email-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:55706 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754386Ab3EJUZh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 May 2013 16:25:37 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

libipset.pc was not installed by classic 'make install'. This
patch adds it to the list of installed files.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 lib/Makefile.am |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/lib/Makefile.am b/lib/Makefile.am
index 2d22aff..ccc02aa 100644
--- a/lib/Makefile.am
+++ b/lib/Makefile.am
@@ -36,6 +36,9 @@ libipset_la_SOURCES = \
 
 EXTRA_DIST = $(IPSET_SETTYPE_LIST) libipset.map
 
+pkgconfigdir = $(libdir)/pkgconfig
+pkgconfig_DATA = libipset.pc
+
 sparse-check: $(libipset_la_SOURCES:.c=.d)
 
 %.d: %.c
-- 
1.7.10.4

