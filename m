From: Piotr Sawicki <piotr.sawicki@gmail.com>
Subject: [PATCH] libnetfilter_queue: Add information about retrieving
 UID/GID/SECCTX fields
Date: Mon, 26 Jun 2017 22:31:30 +0200
Message-ID: <oirqus$3p1$1@blaine.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:41192 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751432AbdFZUbj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 26 Jun 2017 16:31:39 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gnnd-netfilter-devel@m.gmane.org>)
        id 1dPafT-0004r0-15
        for netfilter-devel@vger.kernel.org; Mon, 26 Jun 2017 22:31:31 +0200
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Piotr Radoslaw Sawicki <piotr.sawicki@gmail.com>

Add information about retrieving UID/GID/SECCTX fields

Signed-off-by: Piotr Radoslaw Sawicki <piotr.sawicki@gmail.com>
---
  src/libnetfilter_queue.c | 19 +++++++++++++++++++
  1 file changed, 19 insertions(+)

diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index 1702158..4002687 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -698,6 +698,13 @@ EXPORT_SYMBOL(nfq_set_mode);
  	flags &= ~NFQA_CFG_F_FAIL_OPEN;
  	err = nfq_set_queue_flags(qh, mask, flags);
  \endverbatim
+ *  - NFQA_CFG_F_SECCTX: the kernel will dump security context of the 
socket to
+ *  which each packet belongs.
+ *
+ *  \warning
+ *  When fragmentation occurs and NFQA_CFG_F_GSO is NOT set then the kernel
+ *  dumps UID/GID and security context fields only for one fragment. To 
deal with
+ *  this limitation always set NFQA_CFG_F_GSO.
   *
   * \return -1 on error with errno set appropriately; =0 otherwise.
   */
@@ -1201,6 +1208,10 @@ EXPORT_SYMBOL(nfq_get_packet_hw);
  /**
   * nfq_get_uid - get the UID of the user the packet belongs to
   * \param nfad Netlink packet data handle passed to callback function
+ * \warning If the NFQA_CFG_F_GSO flag is not set, then fragmented packets
+ *       may be pushed into the queue. In this case, only one fragment will
+ *       have the UID field set. To deal with this issue always set
+ *       NFQA_CFG_F_GSO.
   *
   * \return 1 if there is a UID available, 0 otherwise.
   */
@@ -1217,6 +1228,10 @@ EXPORT_SYMBOL(nfq_get_uid);
  /**
   * nfq_get_gid - get the GID of the user the packet belongs to
   * \param nfad Netlink packet data handle passed to callback function
+ * \warning If the NFQA_CFG_F_GSO flag is not set, then fragmented packets
+ *       may be pushed into the queue. In this case, only one fragment will
+ *       have the GID field set. To deal with this issue always set
+ *       NFQA_CFG_F_GSO.
   *
   * \return 1 if there is a GID available, 0 otherwise.
   */
@@ -1235,6 +1250,10 @@ EXPORT_SYMBOL(nfq_get_gid);
   * nfq_get_secctx - get the security context for this packet
   * \param nfad Netlink packet data handle passed to callback function
   * \param secdata data to write the security context to
+ * \warning If the NFQA_CFG_F_GSO flag is not set, then fragmented packets
+ *       may be pushed into the queue. In this case, only one fragment will
+ *       have the SECCTX field set. To deal with this issue always set
+ *       NFQA_CFG_F_GSO.
   *
   * \return -1 on error, otherwise > 0
   */
-- 
2.7.4

