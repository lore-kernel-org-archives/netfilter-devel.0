From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 8/8] build: fix libiptc build failure on old linux-glibc-devel headers
Date: Thu, 24 Jan 2013 20:37:58 +0100
Message-ID: <1359056278-27618-9-git-send-email-jengelh@inai.de>
References: <1359056278-27618-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:40483 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755103Ab3AXTiL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jan 2013 14:38:11 -0500
In-Reply-To: <1359056278-27618-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Linux 2.4.x systems, where /usr/include/linux generally contain
unsanitized headers, compilation of libiptc fails with

	  CC       libip4tc.lo
	In file included from libip4tc.c:113:
	libiptc.c:93: error: field `list' has incomplete type

This is because /usr/include/linux/list.h still existed at that time,
but has all its definitions stashed in __KERNEL__. Switching
linux_list.h's guards to another name resolves the problem.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 libiptc/linux_list.h   |    4 ++--
 libiptc/linux_stddef.h |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/libiptc/linux_list.h b/libiptc/linux_list.h
index abdcf88..3a51185 100644
--- a/libiptc/linux_list.h
+++ b/libiptc/linux_list.h
@@ -1,5 +1,5 @@
-#ifndef _LINUX_LIST_H
-#define _LINUX_LIST_H
+#ifndef _IPTC_LIST_H
+#define _IPTC_LIST_H
 
 #undef offsetof
 #define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
diff --git a/libiptc/linux_stddef.h b/libiptc/linux_stddef.h
index 56416f1..57758c9 100644
--- a/libiptc/linux_stddef.h
+++ b/libiptc/linux_stddef.h
@@ -1,5 +1,5 @@
-#ifndef _LINUX_STDDEF_H
-#define _LINUX_STDDEF_H
+#ifndef _IPTC_STDDEF_H
+#define _IPTC_STDDEF_H
 
 #undef NULL
 #if defined(__cplusplus)
-- 
1.7.10.4

