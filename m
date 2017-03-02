From: Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH iptables] utils: nfsynproxy: fix build with musl libc
Date: Thu,  2 Mar 2017 09:35:07 +0200
Message-ID: <06e0312d0bfd1f0b9e7c23ab654f18524d49e86b.1488440107.git.baruch@tkos.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Baruch Siach <baruch@tkos.co.il>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from guitar.tcltek.co.il ([192.115.133.116]:49951 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754015AbdCBHhL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Mar 2017 02:37:11 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The musl libc exposes some struct tcphdr field only when _GNU_SOURCE is
defined. Fix the following build failure:

nfsynproxy.c: In function ‘parse_packet’:
nfsynproxy.c:34:9: error: ‘const struct tcphdr’ has no member named ‘syn’
  if (!th->syn || !th->ack)
         ^
nfsynproxy.c:34:21: error: ‘const struct tcphdr’ has no member named ‘ack’
  if (!th->syn || !th->ack)
                     ^
nfsynproxy.c:42:8: error: ‘const struct tcphdr’ has no member named ‘res2’
  if (th->res2 == 0x1)
        ^
nfsynproxy.c:45:13: error: ‘const struct tcphdr’ has no member named ‘doff’
  length = th->doff * 4 - sizeof(*th);
             ^

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 utils/nfsynproxy.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/utils/nfsynproxy.c b/utils/nfsynproxy.c
index baedc92c5d9f..bf5c416340f1 100644
--- a/utils/nfsynproxy.c
+++ b/utils/nfsynproxy.c
@@ -6,6 +6,7 @@
  * published by the Free Software Foundation.
  */
 
+#define _GNU_SOURCE
 #include <stdlib.h>
 #include <stdbool.h>
 #include <unistd.h>
-- 
2.11.0

