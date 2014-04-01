From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nf_tables PATCH] netfilter: nft_hash: fix inclusion of
 linux/vmalloc.h
Date: Tue, 01 Apr 2014 13:18:10 +0200
Message-ID: <20140401111810.18995.17628.stgit@nfbe.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:45076 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751260AbaDAKuY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Apr 2014 06:50:24 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This solves this compilation warning:

net/netfilter/nft_hash.c: In function 'nft_hash_tbl_free':
net/netfilter/nft_hash.c:79:3: error: implicit declaration of function 'vfree' [-Werror=implicit-function-declaration]
net/netfilter/nft_hash.c: In function 'nft_hash_tbl_alloc':
net/netfilter/nft_hash.c:92:3: error: implicit declaration of function 'vzalloc' [-Werror=implicit-function-declaration]
net/netfilter/nft_hash.c:92:7: warning: assignment makes pointer from integer without a cast [enabled by default]
cc1: some warnings being treated as errors
make[4]: *** [net/netfilter/nft_hash.o] Error 1
make[3]: *** [net/netfilter] Error 2
make[2]: *** [net] Error 2
[...]

Spotted when building the kernel in SPARC.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 net/netfilter/nft_hash.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
index 6a1acde..2732402 100644
--- a/net/netfilter/nft_hash.c
+++ b/net/netfilter/nft_hash.c
@@ -8,6 +8,7 @@
  * Development of this code funded by Astaro AG (http://www.astaro.com/)
  */
 
+#include <linux/vmalloc.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/module.h>

