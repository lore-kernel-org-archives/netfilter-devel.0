From: Kylie McClain <somasissounds@gmail.com>
Subject: [PATCH] Fix test building on musl libc
Date: Thu, 21 Jul 2016 00:10:45 -0400
Message-ID: <20160721041045.9986-1-somasissounds@gmail.com>
Cc: Kylie McClain <somasis@exherbo.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:35274 "EHLO
	mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795AbcGUEKs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 Jul 2016 00:10:48 -0400
Received: by mail-qk0-f193.google.com with SMTP id q62so5547632qkf.2
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Jul 2016 21:10:48 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Kylie McClain <somasis@exherbo.org>

On musl libc, sys/select.h is where FD_* definitions are located.

Apologies for the repeated email, I realized I forgot to signoff on the commit.

Signed-off-by: Kylie McClain <somasis@exherbo.org>
---
 examples/netfilter/nfct-daemon.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/examples/netfilter/nfct-daemon.c b/examples/netfilter/nfct-daemon.c
index a97c2ec..d223ac2 100644
--- a/examples/netfilter/nfct-daemon.c
+++ b/examples/netfilter/nfct-daemon.c
@@ -13,6 +13,7 @@
 #include <netinet/in.h>
 #include <inttypes.h>
 #include <errno.h>
+#include <sys/select.h>
 
 #include <libmnl/libmnl.h>
 #include <linux/netlink.h>
-- 
2.9.0

