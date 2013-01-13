From: Eric Leblond <eric@regit.org>
Subject: [libnetfilter_queue PATCH 1/2] doxygen: improve fail-open documentation.
Date: Sun, 13 Jan 2013 23:49:35 +0100
Message-ID: <1358117376-7522-1-git-send-email-eric@regit.org>
References: <1358117216.4629.2.camel@tiger2>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org,
	Eric Leblond <eric@regit.org>
To: netfilter@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:39594 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620Ab3AMWuG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 13 Jan 2013 17:50:06 -0500
In-Reply-To: <1358117216.4629.2.camel@tiger2>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 src/libnetfilter_queue.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index 9fe9dfa..f93ac66 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -87,6 +87,8 @@
  * (requires Linux kernel >= 2.6.30).
  * - see --queue-balance option in NFQUEUE target for multi-threaded apps
  * (it requires Linux kernel >= 2.6.31).
+ * - consider using fail-open option see nfq_set_queue_flags() (it requires
+ *  Linux kernel >= 3.6)
  */
 
 struct nfq_handle
@@ -620,6 +622,12 @@ int nfq_set_mode(struct nfq_q_handle *qh,
 	flags &= ~NFQA_CFG_F_FAIL_OPEN;
 	err = nfq_set_queue_flags(qh, mask, flags);
 \endverbatim
+ *
+ * If NFQA_CFG_F_FAIL_OPEN is used, the kernel will accept instead of
+ * drop packets that should have been enqueued to a full queue. This
+ * results in the system being able to handle high network load but at
+ * the depend of the control on the packets.
+ *
  * \return -1 on error with errno set appropriately; =0 otherwise.
  */
 int nfq_set_queue_flags(struct nfq_q_handle *qh,
-- 
1.7.10.4

