From: Eric Leblond <eric@regit.org>
Subject: [libnetfilter_queue PATCH 2/2] doxygen: improve documentation
Date: Sun, 13 Jan 2013 23:49:36 +0100
Message-ID: <1358117376-7522-2-git-send-email-eric@regit.org>
References: <1358117216.4629.2.camel@tiger2>
 <1358117376-7522-1-git-send-email-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org,
	Eric Leblond <eric@regit.org>
To: netfilter@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:39598 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620Ab3AMWuM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 13 Jan 2013 17:50:12 -0500
In-Reply-To: <1358117376-7522-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch improves the doxygen documentation and adds a reference
to an external article.
---
 src/libnetfilter_queue.c |   22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index f93ac66..be25217 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -51,7 +51,21 @@
  *  - receiving queued packets from the kernel nfnetlink_queue subsystem
  *  - issuing verdicts and/or reinjecting altered packets to the kernel
  *  nfnetlink_queue subsystem
- * 
+ *
+ * The cinematic is the following: When an iptables rules with target NFQUEUE
+ * matches, the kernel en-queued the packet in a chained list. It then format
+ * a nfnetlink message and sends the information (packet data , packet id and
+ * metadata) via a socket to the software connected to the queue. The software
+ * can then read the message.
+ *
+ * To remove the packet from the queue, the userspace software must issue a
+ * verdict asking kernel to accept or drop the packet. Userspace can also alter
+ * the packet. Verdict can be done in asynchronous manner, as the only needed
+ * information is the packet id.
+ *
+ * When a queue is full, packets that should have been en-queued are dropped by
+ * kernel instead of being en-queued.
+ *
  * \section Git Tree
  * The current development version of libnetfilter_queue can be accessed
  * at https://git.netfilter.org/cgi-bin/gitweb.cgi?p=libnetfilter_queue.git;a=summary.
@@ -66,6 +80,10 @@
  * the doxygen documentation (start by \link LibrarySetup \endlink page) and
  * nf-queue.c source file.
  *
+ * Another source of information on libnetfilter_queue usage is the following
+ * article:
+ *  https://home.regit.org/netfilter-en/using-nfqueue-and-libnetfilter_queue/
+ *
  * \section errors ENOBUFS errors in recv()
  *
  * recv() may return -1 and errno is set to ENOBUFS in case that your
@@ -89,6 +107,8 @@
  * (it requires Linux kernel >= 2.6.31).
  * - consider using fail-open option see nfq_set_queue_flags() (it requires
  *  Linux kernel >= 3.6)
+ * - increase queue max length with nfq_set_queue_maxlen() to resist to packets
+ * burst
  */
 
 struct nfq_handle
-- 
1.7.10.4

