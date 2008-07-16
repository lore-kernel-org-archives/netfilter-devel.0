From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD2 PATCH] Sync NFLOG input plugin with NFLOG modification related to hardware header.
Date: Thu, 17 Jul 2008 00:31:46 +0200
Message-ID: <1216247506-21802-1-git-send-email-eric@inl.fr>
References: <487CA584.3030200@trash.net>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:34501 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751972AbYGPWbt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Jul 2008 18:31:49 -0400
In-Reply-To: <487CA584.3030200@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch modifies ulogd2 to synchronize NFLOG with ULOG relatively to the
definition of raw.mac. It fills the field with the complete hardware header
instead of simply using the source hardware header.

This is a preliminary work for an implementation of an hardware header parsing.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 input/packet/ulogd_inppkt_NFLOG.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/input/packet/ulogd_inppkt_NFLOG.c b/input/packet/ulogd_inppkt_NFLOG.c
index cb58661..b69a99f 100644
--- a/input/packet/ulogd_inppkt_NFLOG.c
+++ b/input/packet/ulogd_inppkt_NFLOG.c
@@ -290,9 +290,8 @@ static inline int
 interp_packet(struct ulogd_pluginstance *upi, struct nflog_data *ldata)
 {
 	struct ulogd_key *ret = upi->output.keys;
-
+	
 	struct nfulnl_msg_packet_hdr *ph = nflog_get_msg_packet_hdr(ldata);
-	struct nfulnl_msg_packet_hw *hw = nflog_get_packet_hw(ldata);
 	char *payload;
 	int payload_len = nflog_get_payload(ldata, &payload);
 	char *prefix = nflog_get_prefix(ldata);
@@ -318,10 +317,11 @@ interp_packet(struct ulogd_pluginstance *upi, struct nflog_data *ldata)
 		ret[NFLOG_KEY_OOB_PROTOCOL].flags |= ULOGD_RETF_VALID;
 	}
 
-	if (hw) {
-		ret[NFLOG_KEY_RAW_MAC].u.value.ptr = hw->hw_addr;
+	if (nflog_get_msg_packet_hwhdrlen(ldata)) {
+		ret[NFLOG_KEY_RAW_MAC].u.value.ptr = nflog_get_msg_packet_hwhdr(ldata);
 		ret[NFLOG_KEY_RAW_MAC].flags |= ULOGD_RETF_VALID;
-		ret[NFLOG_KEY_RAW_MAC_LEN].u.value.ui16 = ntohs(hw->hw_addrlen);
+		ret[NFLOG_KEY_RAW_MAC_LEN].u.value.ui16 =
+			nflog_get_msg_packet_hwhdrlen(ldata);
 		ret[NFLOG_KEY_RAW_MAC_LEN].flags |= ULOGD_RETF_VALID;
 	}
 
-- 
1.5.4.3

