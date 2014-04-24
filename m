From: Florian Westphal <fw@strlen.de>
Subject: [PATCH lnf-queue] src: PF_BIND/UNBIND is ignored in 3.8 and later
Date: Thu, 24 Apr 2014 11:01:11 +0200
Message-ID: <1398330071-3463-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:36475 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755444AbaDXJGS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Apr 2014 05:06:18 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

There is confusion on what this command actually does and why
examples commonly PF_UNBIND at startup.

Since these are obsolete document that its not needed at all
from 3.8 onwards and remove the unbind from the example program.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
I'll push it later today if noone objets.

diff --git a/examples/nf-queue.c b/examples/nf-queue.c
index 1f465ad..4e0b227 100644
--- a/examples/nf-queue.c
+++ b/examples/nf-queue.c
@@ -136,17 +136,9 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
 
-	nlh = nfq_hdr_put(buf, NFQNL_MSG_CONFIG, 0);
-	nfq_nlmsg_cfg_put_cmd(nlh, AF_INET, NFQNL_CFG_CMD_PF_UNBIND);
-
-	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
-		perror("mnl_socket_send");
-		exit(EXIT_FAILURE);
-	}
-
+	/* PF_BIND is not needed with kernels 3.8 and later */
 	nlh = nfq_hdr_put(buf, NFQNL_MSG_CONFIG, 0);
 	nfq_nlmsg_cfg_put_cmd(nlh, AF_INET, NFQNL_CFG_CMD_PF_BIND);
-
 	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
 		perror("mnl_socket_send");
 		exit(EXIT_FAILURE);
diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index 32725d1..740b340 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -455,8 +455,9 @@ EXPORT_SYMBOL(nfq_close);
  * \param h Netfilter queue connection handle obtained via call to nfq_open()
  * \param pf protocol family to bind to nfqueue handler obtained from nfq_open()
  *
- * Binds the given queue connection handle to process packets belonging to 
+ * Binds the given queue connection handle to process packets belonging to
  * the given protocol family (ie. PF_INET, PF_INET6, etc).
+ * This call is obsolete, Linux kernels from 3.8 onwards ignore it.
  *
  * \return integer inferior to 0 in case of failure
  */
@@ -473,6 +474,8 @@ EXPORT_SYMBOL(nfq_bind_pf);
  *
  * Unbinds the given queue connection handle from processing packets belonging
  * to the given protocol family.
+ *
+ * This call is obsolete, Linux kernels from 3.8 onwards ignore it.
  */
 int nfq_unbind_pf(struct nfq_handle *h, u_int16_t pf)
 {
diff --git a/src/nlmsg.c b/src/nlmsg.c
index 81e170e..aebdd5e 100644
--- a/src/nlmsg.c
+++ b/src/nlmsg.c
@@ -77,10 +77,13 @@ EXPORT_SYMBOL(nfq_nlmsg_verdict_put_pkt);
  *   subsystem is working.
  * - NFQNL_CFG_CMD_BIND: Binds the program to a specific queue.
  * - NFQNL_CFG_CMD_UNBIND: Unbinds the program to a specifiq queue.
+ *
+ * Obsolete commands:
  * - NFQNL_CFG_CMD_PF_BIND: Binds to process packets belonging to the given
  *   protocol family (ie. PF_INET, PF_INET6, etc).
  * - NFQNL_CFG_CMD_PF_UNBIND: Unbinds from processing packets belonging to the
- *   given protocol family.
+ *   given protocol family.  Both commands are ignored by Linux kernel 3.8 and
+ *   later versions.
  */
 void nfq_nlmsg_cfg_put_cmd(struct nlmsghdr *nlh, uint16_t pf, uint8_t cmd)
 {
-- 
1.8.1.5

