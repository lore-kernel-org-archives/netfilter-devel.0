From: Felix Janda <felix.janda@posteo.de>
Subject: [iptables PATCH 2/2 RFC] Remove Libc5 support code
Date: Sat, 2 May 2015 21:51:38 +0200
Message-ID: <20150502195138.GB17994@euler>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:49848 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1949357AbbEBTvr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 May 2015 15:51:47 -0400
Received: from dovecot03.posteo.de (unknown [185.67.36.28])
	by mx02.posteo.de (Postfix) with ESMTPS id 35D8025B17D3
	for <netfilter-devel@vger.kernel.org>; Sat,  2 May 2015 21:51:46 +0200 (CEST)
Received: from mail.posteo.de (localhost [127.0.0.1])
	by dovecot03.posteo.de (Postfix) with ESMTPSA id 3lfLgQ0P3tz5vMr
	for <netfilter-devel@vger.kernel.org>; Sat,  2 May 2015 21:51:46 +0200 (CEST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Current code makes the assumption that !defined(__GLIBC__) means libc5
which is very unlikely the case nowadays.

Fixes compile error because of conflict between kernel and musl headers.
---
If libc5 is considered still relevant, I could try to come up with an
autoconf test.
---
 include/libiptc/ipt_kernel_headers.h | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/include/libiptc/ipt_kernel_headers.h b/include/libiptc/ipt_kernel_headers.h
index 18861fe..a5963e9 100644
--- a/include/libiptc/ipt_kernel_headers.h
+++ b/include/libiptc/ipt_kernel_headers.h
@@ -5,7 +5,6 @@
 
 #include <limits.h>
 
-#if defined(__GLIBC__) && __GLIBC__ == 2
 #include <netinet/ip.h>
 #include <netinet/in.h>
 #include <netinet/ip_icmp.h>
@@ -13,15 +12,4 @@
 #include <netinet/udp.h>
 #include <net/if.h>
 #include <sys/types.h>
-#else /* libc5 */
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
-- 
2.3.6
