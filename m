From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/39]: remove unused include file
Date: Wed, 20 Sep 2006 10:23:52 +0200 (MEST)
Message-ID: <20060920082444.14636.45495.sendpatchset@localhost.localdomain>
References: <20060920082442.14636.6806.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060920082442.14636.6806.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: remove unused include file

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 2b9aa10745a14bddfcac991b5b11f809c02a6ffd
tree a6504d5995a92ad65bab428ad0861cba2d5576e7
parent 03789adae76100f1102dc35d8d7af9abdb1ac99c
author Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:27:35 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:27:35 +0200

 include/linux/netfilter_logging.h |   33 ---------------------------------
 1 files changed, 0 insertions(+), 33 deletions(-)

diff --git a/include/linux/netfilter_logging.h b/include/linux/netfilter_logging.h
deleted file mode 100644
index 562bb6a..0000000
--- a/include/linux/netfilter_logging.h
+++ /dev/null
@@ -1,33 +0,0 @@
-/* Internal logging interface, which relies on the real 
-   LOG target modules */
-#ifndef __LINUX_NETFILTER_LOGGING_H
-#define __LINUX_NETFILTER_LOGGING_H
-
-#ifdef __KERNEL__
-#include <asm/atomic.h>
-
-struct nf_logging_t {
-	void (*nf_log_packet)(struct sk_buff **pskb,
-			      unsigned int hooknum,
-			      const struct net_device *in,
-			      const struct net_device *out,
-			      const char *prefix);
-	void (*nf_log)(char *pfh, size_t len,
-		       const char *prefix);
-};
-
-extern void nf_log_register(int pf, const struct nf_logging_t *logging);
-extern void nf_log_unregister(int pf, const struct nf_logging_t *logging);
-
-extern void nf_log_packet(int pf,
-			  struct sk_buff **pskb,
-			  unsigned int hooknum,
-			  const struct net_device *in,
-			  const struct net_device *out,
-			  const char *fmt, ...);
-extern void nf_log(int pf,
-		   char *pfh, size_t len,
-		   const char *fmt, ...);
-#endif /*__KERNEL__*/
-
-#endif /*__LINUX_NETFILTER_LOGGING_H*/
