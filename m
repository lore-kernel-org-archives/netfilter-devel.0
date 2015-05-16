From: Felix Janda <felix.janda@posteo.de>
Subject: [libmnl PATCH 1/2] examples/netfilter: Use stdint types
Date: Sat, 16 May 2015 12:37:12 +0200
Message-ID: <20150516103243.GK14201@euler>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:49282 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507AbbEPKhf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 May 2015 06:37:35 -0400
Received: from dovecot03.posteo.de (unknown [185.67.36.28])
	by mx02.posteo.de (Postfix) with ESMTPS id 30AEB25A3DFD
	for <netfilter-devel@vger.kernel.org>; Sat, 16 May 2015 12:37:33 +0200 (CEST)
Received: from mail.posteo.de (localhost [127.0.0.1])
	by dovecot03.posteo.de (Postfix) with ESMTPSA id 3lpjjT5rtBz5vN7
	for <netfilter-devel@vger.kernel.org>; Sat, 16 May 2015 12:37:33 +0200 (CEST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 examples/netfilter/nf-log.c   | 2 +-
 examples/netfilter/nf-queue.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/examples/netfilter/nf-log.c b/examples/netfilter/nf-log.c
index 901bd80..ec8175b 100644
--- a/examples/netfilter/nf-log.c
+++ b/examples/netfilter/nf-log.c
@@ -11,7 +11,7 @@
 #include <linux/netfilter/nfnetlink.h>
 
 #ifndef aligned_be64
-#define aligned_be64 u_int64_t __attribute__((aligned(8)))
+#define aligned_be64 uint64_t __attribute__((aligned(8)))
 #endif
 
 #include <linux/netfilter/nfnetlink_log.h>
diff --git a/examples/netfilter/nf-queue.c b/examples/netfilter/nf-queue.c
index 72779f0..6627787 100644
--- a/examples/netfilter/nf-queue.c
+++ b/examples/netfilter/nf-queue.c
@@ -11,7 +11,7 @@
 #include <linux/netfilter/nfnetlink.h>
 
 #ifndef aligned_be64
-#define aligned_be64 u_int64_t __attribute__((aligned(8)))
+#define aligned_be64 uint64_t __attribute__((aligned(8)))
 #endif
 
 #include <linux/netfilter/nfnetlink_queue.h>
-- 
2.3.6
