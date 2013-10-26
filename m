From: Kevin Cernekee <cernekee@gmail.com>
Subject: [PATCH iptables 1/3] android: libiptc: Fix socklen_t type mismatch on Android
Date: Sat, 26 Oct 2013 11:50:31 -0700
Message-ID: <1382813433-20890-2-git-send-email-cernekee@gmail.com>
References: <1382813433-20890-1-git-send-email-cernekee@gmail.com>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:64691 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344Ab3JZSur (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 26 Oct 2013 14:50:47 -0400
Received: by mail-pa0-f53.google.com with SMTP id kx10so2734562pab.26
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Oct 2013 11:50:47 -0700 (PDT)
In-Reply-To: <1382813433-20890-1-git-send-email-cernekee@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Bionic defines socklen_t as a signed int, so redefining it as unsigned
breaks the build.

This change comes from AOSP.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 libiptc/libip4tc.c |    2 +-
 libiptc/libip6tc.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/libiptc/libip4tc.c b/libiptc/libip4tc.c
index dd59951..2b029d4 100644
--- a/libiptc/libip4tc.c
+++ b/libiptc/libip4tc.c
@@ -22,7 +22,7 @@
 #define inline
 #endif
 
-#if !defined(__GLIBC__) || (__GLIBC__ < 2)
+#if !defined(__ANDROID__) && (!defined(__GLIBC__) || (__GLIBC__ < 2))
 typedef unsigned int socklen_t;
 #endif
 
diff --git a/libiptc/libip6tc.c b/libiptc/libip6tc.c
index ca01bcb..4e47e69 100644
--- a/libiptc/libip6tc.c
+++ b/libiptc/libip6tc.c
@@ -23,7 +23,7 @@
 #define inline
 #endif
 
-#if !defined(__GLIBC__) || (__GLIBC__ < 2)
+#if !defined(__ANDROID__) && (!defined(__GLIBC__) || (__GLIBC__ < 2))
 typedef unsigned int socklen_t;
 #endif
 
-- 
1.7.9.5

