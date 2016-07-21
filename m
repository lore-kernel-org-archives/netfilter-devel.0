From: Kylie McClain <somasissounds@gmail.com>
Subject: [PATCH] Fix test building on musl libc
Date: Wed, 20 Jul 2016 23:55:21 -0400
Message-ID: <20160721035521.26816-1-somasissounds@gmail.com>
Cc: Kylie McClain <somasis@exherbo.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:36319 "EHLO
	mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbcGUDz1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Jul 2016 23:55:27 -0400
Received: by mail-qk0-f196.google.com with SMTP id q8so5545006qke.3
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Jul 2016 20:55:26 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Kylie McClain <somasis@exherbo.org>

On musl libc, sys/select.h is where FD_* definitions are located.
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

