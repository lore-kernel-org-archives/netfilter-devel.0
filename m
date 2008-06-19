From: Eric Leblond <eric@inl.fr>
Subject: [PATCH] Change packet hw header struct accordingly to NFLOG update.
Date: Thu, 19 Jun 2008 14:55:46 +0200
Message-ID: <1213880146-1476-1-git-send-email-eric@inl.fr>
References: <1213878331-1074-1-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:54436 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756069AbYFSMzt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jun 2008 08:55:49 -0400
In-Reply-To: <1213878331-1074-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch synchronizes libnetfilter_log with my last patch.

Sent for completeness: kernel patch will need rework.
---
 include/libnetfilter_log/linux_nfnetlink_log.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/include/libnetfilter_log/linux_nfnetlink_log.h b/include/libnetfilter_log/linux_nfnetlink_log.h
index f8e174d..83beb2d 100644
--- a/include/libnetfilter_log/linux_nfnetlink_log.h
+++ b/include/libnetfilter_log/linux_nfnetlink_log.h
@@ -25,10 +25,12 @@ struct nfulnl_msg_packet_hdr {
 	u_int8_t	_pad;
 } __attribute__ ((packed));
 
+#define MAX_HWHEADER_LEN 16
+
 struct nfulnl_msg_packet_hw {
 	u_int16_t	hw_addrlen;
 	u_int16_t	_pad;
-	u_int8_t	hw_addr[8];
+	u_int8_t	hw_addr[MAX_HWHEADER_LEN];
 } __attribute__ ((packed));
 
 struct nfulnl_msg_packet_timestamp {
-- 
1.5.5.3

