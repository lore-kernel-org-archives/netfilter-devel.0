Return-Path: <SRS0=J2Vc=4L=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F17CC35670
	for <netfilter-devel@archiver.kernel.org>; Sun, 23 Feb 2020 23:49:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F32F206E0
	for <netfilter-devel@archiver.kernel.org>; Sun, 23 Feb 2020 23:49:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727150AbgBWXts (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 23 Feb 2020 18:49:48 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:45984 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726534AbgBWXts (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 23 Feb 2020 18:49:48 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1j610L-0004jA-6Q; Mon, 24 Feb 2020 00:49:45 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH libnetfilter_queue] src: add nfq_get_skbinfo()
Date:   Mon, 24 Feb 2020 00:49:41 +0100
Message-Id: <20200223234941.44877-1-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Silly, since its easy to fetch this via libmnl.
Unfortunately there is a large number of software that uses the old
API, so add a helper to return the attribute.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 fixmanpages.sh                                |  6 ++--
 .../libnetfilter_queue/libnetfilter_queue.h   |  1 +
 src/libnetfilter_queue.c                      | 31 +++++++++++++++++++
 3 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/fixmanpages.sh b/fixmanpages.sh
index 897086bad6df..4d12247d14f6 100755
--- a/fixmanpages.sh
+++ b/fixmanpages.sh
@@ -11,8 +11,10 @@ function main
     add2group nfq_get_nfmark nfq_get_timestamp nfq_get_indev nfq_get_physindev
     add2group nfq_get_outdev nfq_get_physoutdev nfq_get_indev_name
     add2group nfq_get_physindev_name nfq_get_outdev_name
-    add2group nfq_get_physoutdev_name nfq_get_packet_hw nfq_get_uid
-    add2group nfq_get_gid nfq_get_secctx nfq_get_payload
+    add2group nfq_get_physoutdev_name nfq_get_packet_hw
+    add2group nfq_get_skbinfo
+    add2group nfq_get_uid nfq_get_gid
+    add2group nfq_get_secctx nfq_get_payload
   setgroup Queue nfq_fd
     add2group nfq_create_queue nfq_destroy_queue nfq_handle_packet nfq_set_mode
     add2group nfq_set_queue_flags nfq_set_queue_maxlen nfq_set_verdict
diff --git a/include/libnetfilter_queue/libnetfilter_queue.h b/include/libnetfilter_queue/libnetfilter_queue.h
index 092c57d07451..46e14e135458 100644
--- a/include/libnetfilter_queue/libnetfilter_queue.h
+++ b/include/libnetfilter_queue/libnetfilter_queue.h
@@ -103,6 +103,7 @@ extern uint32_t nfq_get_indev(struct nfq_data *nfad);
 extern uint32_t nfq_get_physindev(struct nfq_data *nfad);
 extern uint32_t nfq_get_outdev(struct nfq_data *nfad);
 extern uint32_t nfq_get_physoutdev(struct nfq_data *nfad);
+extern uint32_t nfq_get_skbinfo(struct nfq_data *nfad);
 extern int nfq_get_uid(struct nfq_data *nfad, uint32_t *uid);
 extern int nfq_get_gid(struct nfq_data *nfad, uint32_t *gid);
 extern int nfq_get_secctx(struct nfq_data *nfad, unsigned char **secdata);
diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index 3cf9653393e6..f5462a374b80 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -1210,6 +1210,37 @@ struct nfqnl_msg_packet_hw *nfq_get_packet_hw(struct nfq_data *nfad)
 					struct nfqnl_msg_packet_hw);
 }
 
+/**
+ * nfq_get_skbinfo - return the NFQA_SKB_INFO meta information
+ * \param nfad Netlink packet data handle passed to callback function
+ *
+ * This can be used to obtain extra information about a packet by testing
+ * the returned integer for any of the following bit flags:
+ *
+ * - NFQA_SKB_CSUMNOTREADY
+ *   packet header checksums will be computed by hardware later on, i.e.
+ *   tcp/ip checksums in the packet must not be validated, application
+ *   should pretend they are correct.
+ * - NFQA_SKB_GSO
+ *   packet is an aggregated super-packet.  It exceeds device mtu and will
+ *   be (re-)split on transmit by hardware.
+ * - NFQA_SKB_CSUM_NOTVERIFIED
+ *   packet checksum was not yet verified by the kernel/hardware, for
+ *   example because this is an incoming packet and the NIC does not
+ *   perform checksum validation at hardware level.
+ * See nfq_set_queue_flags() documentation for more information.
+ *
+ * \return the skbinfo value
+ */
+EXPORT_SYMBOL
+uint32_t nfq_get_skbinfo(struct nfq_data *nfad)
+{
+	if (!nfnl_attr_present(nfad->data, NFQA_SKB_INFO))
+		return 0;
+
+	return ntohl(nfnl_get_data(nfad->data, NFQA_SKB_INFO, uint32_t));
+}
+
 /**
  * nfq_get_uid - get the UID of the user the packet belongs to
  * \param nfad Netlink packet data handle passed to callback function
-- 
2.24.1

