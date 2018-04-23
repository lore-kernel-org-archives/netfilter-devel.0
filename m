From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 09/12] netfilter: conntrack: include kmemleak.h for kmemleak_not_leak()
Date: Mon, 23 Apr 2018 19:57:11 +0200
Message-ID: <20180423175714.9794-10-pablo@netfilter.org>
References: <20180423175714.9794-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180423175714.9794-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>

After merging the netfilter tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

net/netfilter/nf_conntrack_extend.c: In function 'nf_ct_ext_add':
net/netfilter/nf_conntrack_extend.c:74:2: error: implicit declaration of function 'kmemleak_not_leak' [-Werror=implicit-function-declaration]
  kmemleak_not_leak(old);
  ^~~~~~~~~~~~~~~~~
cc1: some warnings being treated as errors

Fixes: 114aa35d06d4 ("netfilter: conntrack: silent a memory leak warning")
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_extend.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_conntrack_extend.c b/net/netfilter/nf_conntrack_extend.c
index bd71a828ebde..277bbfe26478 100644
--- a/net/netfilter/nf_conntrack_extend.c
+++ b/net/netfilter/nf_conntrack_extend.c
@@ -9,6 +9,7 @@
  *      2 of the License, or (at your option) any later version.
  */
 #include <linux/kernel.h>
+#include <linux/kmemleak.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/rcupdate.h>
-- 
2.11.0
