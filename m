From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH] Output mac.saddr, mac.daddr and oob.protocol in ULOG plugin.
Date: Wed,  2 Jul 2008 15:52:20 +0200
Message-ID: <1215006740-13074-1-git-send-email-eric@inl.fr>
References: <1214607780-31389-4-git-send-email-eric@inl.fr>
Cc: pablo@netfilter.org, Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:37795 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751734AbYGBNqT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Jul 2008 09:46:19 -0400
In-Reply-To: <1214607780-31389-4-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

Following live discussion with Pablo, here's a resend of my patch
implementing his idea about header parsing. This permits to get rid
of the addition of a new configuration variable in ULOG plugin.

This patch modifies output key of ULOG by providing a parsing of
source, destination mac address and hardware protocol instead
of having a simply sending raw.mac through the stack.

This patch replaces 3 and 4/6 of my previous patchset.

BR,

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 input/packet/ulogd_inppkt_ULOG.c |   50 ++++++++++++++++++++++++++++---------
 1 files changed, 38 insertions(+), 12 deletions(-)

diff --git a/input/packet/ulogd_inppkt_ULOG.c b/input/packet/ulogd_inppkt_ULOG.c
index c00d9bf..7978eb6 100644
--- a/input/packet/ulogd_inppkt_ULOG.c
+++ b/input/packet/ulogd_inppkt_ULOG.c
@@ -65,7 +65,8 @@ static struct config_keyset libulog_kset = {
 	}
 };
 enum ulog_keys {
-	ULOG_KEY_RAW_MAC = 0,
+	ULOG_KEY_RAW_MAC_SADDR = 0,
+	ULOG_KEY_RAW_MAC_DADDR,
 	ULOG_KEY_RAW_PCKT,
 	ULOG_KEY_RAW_PCKTLEN,
 	ULOG_KEY_RAW_PCKTCOUNT,
@@ -83,15 +84,24 @@ enum ulog_keys {
 };
 
 static struct ulogd_key output_keys[] = {
-	[ULOG_KEY_RAW_MAC] = {
+	[ULOG_KEY_RAW_MAC_SADDR] = {
 		.type = ULOGD_RET_RAW,
 		.flags = ULOGD_RETF_NONE,
-		.name = "raw.mac",
+		.name = "raw.mac.saddr",
 		.ipfix = {
 			.vendor = IPFIX_VENDOR_IETF,
 			.field_id = IPFIX_sourceMacAddress,
 		},
 	},
+	[ULOG_KEY_RAW_MAC_DADDR] = {
+		.type = ULOGD_RET_RAW,
+		.flags = ULOGD_RETF_NONE,
+		.name = "raw.mac.daddr",
+		.ipfix = {
+			.vendor = IPFIX_VENDOR_IETF,
+			.field_id = IPFIX_destinationMacAddress,
+		},
+	},
 	[ULOG_KEY_RAW_PCKT] = {
 		.type = ULOGD_RET_RAW,
 		.flags = ULOGD_RETF_NONE,
@@ -188,13 +198,32 @@ static struct ulogd_key output_keys[] = {
 static int interp_packet(struct ulogd_pluginstance *ip, ulog_packet_msg_t *pkt)
 {
 	struct ulogd_key *ret = ip->output.keys;
-
-	if (pkt->mac_len) {
-		ret[ULOG_KEY_RAW_MAC].u.value.ptr = pkt->mac;
-		ret[ULOG_KEY_RAW_MAC].flags |= ULOGD_RETF_VALID;
-		ret[ULOG_KEY_RAW_MAC_LEN].u.value.ui16 = pkt->mac_len;
-		ret[ULOG_KEY_RAW_MAC_LEN].flags |= ULOGD_RETF_VALID;
-	}
+	int hwlen = 0;
+
+	/* compute hardware header length hwlen from mac_len, we suppose
+	 * header field is [ HW DST ADDR | HW SRC ADDR | PROTO ] with
+	 * proto code on two bytes.
+	 * Thus, we have:
+	 * 	hwlen = (mac_len - 2) / 2
+	 */
+	if ((pkt->mac_len % 2) || (pkt->mac_len < 2)) {
+		ulogd_log(ULOGD_NOTICE, "Invalid  mac_len (%d), rejecting"
+			  " packet", pkt->mac_len);
+		return ULOGD_IRET_ERR;
+	} else
+		hwlen = (pkt->mac_len - 2) / 2;
+
+	ret[ULOG_KEY_RAW_MAC_DADDR].u.value.ptr = pkt->mac;
+	ret[ULOG_KEY_RAW_MAC_DADDR].flags |= ULOGD_RETF_VALID;
+	ret[ULOG_KEY_RAW_MAC_SADDR].u.value.ptr = pkt->mac + hwlen;
+	ret[ULOG_KEY_RAW_MAC_SADDR].flags |= ULOGD_RETF_VALID;
+
+	ret[ULOG_KEY_RAW_MAC_LEN].u.value.ui16 = hwlen;
+	ret[ULOG_KEY_RAW_MAC_LEN].flags |= ULOGD_RETF_VALID;
+
+	ret[ULOG_KEY_OOB_PROTOCOL].u.value.ui16 = ntohs(
+			*(uint16_t *)(pkt->mac + 2 * hwlen));
+	ret[ULOG_KEY_OOB_PROTOCOL].flags |= ULOGD_RETF_VALID;
 
 	ret[ULOG_KEY_RAW_LABEL].u.value.ui8 = ip->config_kset->ces[3].u.value;
 	ret[ULOG_KEY_RAW_LABEL].flags |= ULOGD_RETF_VALID;
@@ -235,9 +264,6 @@ static int interp_packet(struct ulogd_pluginstance *ip, ulog_packet_msg_t *pkt)
 	/* ULOG is IPv4 only */
 	ret[ULOG_KEY_OOB_FAMILY].u.value.ui8 = AF_INET;
 	ret[ULOG_KEY_OOB_FAMILY].flags |= ULOGD_RETF_VALID;
-	/* Undef in ULOG but necessary */
-	ret[ULOG_KEY_OOB_PROTOCOL].u.value.ui16 = 0;
-	ret[ULOG_KEY_OOB_PROTOCOL].flags |= ULOGD_RETF_VALID;
 
 	ulogd_propagate_results(ip);
 	return 0;
-- 
1.5.4.3

