From: Felix Janda <felix.janda@posteo.de>
Subject: [arptables PATCH 2/2] Remove support for libc5
Date: Sat, 16 May 2015 10:31:41 +0200
Message-ID: <20150516083141.GB14201@euler>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:60168 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932145AbbEPIb5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 May 2015 04:31:57 -0400
Received: from dovecot03.posteo.de (unknown [185.67.36.28])
	by mx02.posteo.de (Postfix) with ESMTPS id E139725B17D7
	for <netfilter-devel@vger.kernel.org>; Sat, 16 May 2015 10:31:55 +0200 (CEST)
Received: from mail.posteo.de (localhost [127.0.0.1])
	by dovecot03.posteo.de (Postfix) with ESMTPSA id 3lpfwW48XMz5vNB
	for <netfilter-devel@vger.kernel.org>; Sat, 16 May 2015 10:31:55 +0200 (CEST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fixes compilation with musl libc

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 include/libarptc/arpt_kernel_headers.h | 12 ------------
 libarptc/libarptc.c                    |  4 ----
 2 files changed, 16 deletions(-)

diff --git a/include/libarptc/arpt_kernel_headers.h b/include/libarptc/arpt_kernel_headers.h
index 442cc54..140e999 100644
--- a/include/libarptc/arpt_kernel_headers.h
+++ b/include/libarptc/arpt_kernel_headers.h
@@ -5,7 +5,6 @@
 
 #include <limits.h>
 
-#if defined(__GLIBC__) && __GLIBC__ == 2
 #include <netinet/ip.h>
 #include <netinet/in.h>
 #include <netinet/ip_icmp.h>
@@ -14,16 +13,5 @@
 #include <netinet/ether.h>
 #include <net/if.h>
 #include <sys/types.h>
-#else
-#include <sys/socket.h>
-#include <linux/ip.h>
-#include <linux/in.h>
-#include <linux/if.h>
-#include <linux/icmp.h>
-#include <linux/tcp.h>
-#include <linux/udp.h>
-#include <linux/types.h>
-#include <linux/in6.h>
-#endif
 
 #endif
diff --git a/libarptc/libarptc.c b/libarptc/libarptc.c
index f03dd0b..71602c2 100644
--- a/libarptc/libarptc.c
+++ b/libarptc/libarptc.c
@@ -23,10 +23,6 @@
 #define inline
 #endif
 
-#if !defined(__GLIBC__) || (__GLIBC__ < 2)
-typedef unsigned int socklen_t;
-#endif
-
 #include "libarptc/libarptc.h"
 
 #define IP_VERSION	4
-- 
2.3.6
