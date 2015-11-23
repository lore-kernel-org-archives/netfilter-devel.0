From: Rodrigo Rebello <rprebello@gmail.com>
Subject: [PATCH conntrack-tools] src: fix build with musl libc
Date: Mon, 23 Nov 2015 02:59:49 -0200
Message-ID: <1448254789-30961-1-git-send-email-rprebello@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:34385 "EHLO
	mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101AbbKWE76 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 22 Nov 2015 23:59:58 -0500
Received: by qkfo3 with SMTP id o3so54955345qkf.1
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Nov 2015 20:59:57 -0800 (PST)
Received: from localhost.localdomain ([187.107.24.50])
        by smtp.gmail.com with ESMTPSA id x79sm2644647qka.37.2015.11.22.20.59.56
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 22 Nov 2015 20:59:57 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The GNU version of 'struct tcphdr' is not exposed by musl libc headers
unless _GNU_SOURCE is defined. Without this definition, the build fails
with:

  rpc.c: In function 'rpc_helper_cb':
  rpc.c:351:15: error: 'struct tcphdr' has no member named 'doff'
     offset += th->doff * 4;
                 ^

Signed-off-by: Rodrigo Rebello <rprebello@gmail.com>
---
 src/helpers/rpc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/helpers/rpc.c b/src/helpers/rpc.c
index 82493c2..3a7b337 100644
--- a/src/helpers/rpc.c
+++ b/src/helpers/rpc.c
@@ -28,6 +28,7 @@
 
 #include <rpc/rpc_msg.h>
 #include <rpc/pmap_prot.h>
+#define _GNU_SOURCE
 #include <netinet/tcp.h>
 #include <netinet/udp.h>
 
-- 
2.1.4

