From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH] rework, fill MAC address in ULOG for ethernet.
Date: Tue,  8 Jul 2008 23:56:59 +0200
Message-ID: <1215554219-13763-1-git-send-email-eric@inl.fr>
References: <486B88F4.7060704@trash.net>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:34127 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751875AbYGHV5C (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Jul 2008 17:57:02 -0400
In-Reply-To: <486B88F4.7060704@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch introduces a parsing of the hardware header field based on
the length of the field. It currently only detects ethernet header and
fill mac.saddr and mac.daddr properly.

With this behaviour it may be impossible to support all kind of devices
but ULOG will soon be deprecated in favor of NFLOG.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 input/packet/ulogd_inppkt_ULOG.c |   68 +++++++++++++++++++++++++++++++-------
 1 files changed, 56 insertions(+), 12 deletions(-)

diff --git a/input/packet/ulogd_inppkt_ULOG.c b/input/packet/ulogd_inppkt_ULOG.c
index c00d9bf..742c43f 100644
--- a/input/packet/ulogd_inppkt_ULOG.c
+++ b/input/packet/ulogd_inppkt_ULOG.c
@@ -7,6 +7,7 @@
 #include <stdlib.h>
 #include <arpa/inet.h>
 #include <string.h>
+#include <linux/if_ether.h>
 
 
 #include <ulogd/ulogd.h>
@@ -65,7 +66,8 @@ static struct config_keyset libulog_kset = {
 	}
 };
 enum ulog_keys {
-	ULOG_KEY_RAW_MAC = 0,
+	ULOG_KEY_RAW_MAC_SADDR = 0,
+	ULOG_KEY_RAW_MAC_DADDR,
 	ULOG_KEY_RAW_PCKT,
 	ULOG_KEY_RAW_PCKTLEN,
 	ULOG_KEY_RAW_PCKTCOUNT,
@@ -83,15 +85,24 @@ enum ulog_keys {
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
@@ -185,16 +196,52 @@ static struct ulogd_key output_keys[] = {
 
 };
 
+
+static int parse_macheader(struct ulogd_key *ret, ulog_packet_msg_t *pkt,
+			   )
+{
+	int hwlen;
+
+	switch (pkt->mac_len) {
+		case (2 * ETH_ALEN +2):
+			hwlen = ETH_ALEN;
+			break;
+		default:
+			ulogd_log(ULOGD_DEBUG, "Unknown mac_len (%d), "
+					"rejecting packet", pkt->mac_len);
+			ret[ULOG_KEY_OOB_PROTOCOL].u.value.ui16 = 0;
+			ret[ULOG_KEY_OOB_PROTOCOL].flags |= ULOGD_RETF_VALID;
+			return ULOGD_IRET_OK;
+	}
+
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
+
+	return ULOGD_IRET_OK;
+}
+
+
+
 static int interp_packet(struct ulogd_pluginstance *ip, ulog_packet_msg_t *pkt)
 {
 	struct ulogd_key *ret = ip->output.keys;
+	int hwlen = 0;
+	int fret;
 
-	if (pkt->mac_len) {
-		ret[ULOG_KEY_RAW_MAC].u.value.ptr = pkt->mac;
-		ret[ULOG_KEY_RAW_MAC].flags |= ULOGD_RETF_VALID;
-		ret[ULOG_KEY_RAW_MAC_LEN].u.value.ui16 = pkt->mac_len;
-		ret[ULOG_KEY_RAW_MAC_LEN].flags |= ULOGD_RETF_VALID;
-	}
+
+	fret = parse_macheader(ret, pkt);
+	if (fret != ULOGD_IRET_OK)
+		return fret;
 
 	ret[ULOG_KEY_RAW_LABEL].u.value.ui8 = ip->config_kset->ces[3].u.value;
 	ret[ULOG_KEY_RAW_LABEL].flags |= ULOGD_RETF_VALID;
@@ -235,9 +282,6 @@ static int interp_packet(struct ulogd_pluginstance *ip, ulog_packet_msg_t *pkt)
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

