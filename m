From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 3/6] Output mac.saddr and mac.daddr in ULOG plugin.
Date: Sat, 28 Jun 2008 01:02:57 +0200
Message-ID: <1214607780-31389-4-git-send-email-eric@inl.fr>
References: <485FB66A.1090601@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@inl.fr>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:56483 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764362AbYF0W5u (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Jun 2008 18:57:50 -0400
In-Reply-To: <485FB66A.1090601@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch modifies output key of ULOG by providing a parsing of
source and destination mac address instead of having a simply
sending raw.mac through the stack.
The introduction of the config key "hwaddrlen" was necessary to be able
to know the length of an hardware address which is used to compute the
length of an address and the offset of destination address

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 input/packet/ulogd_inppkt_ULOG.c |   37 ++++++++++++++++++++++++++++---------
 1 files changed, 28 insertions(+), 9 deletions(-)

diff --git a/input/packet/ulogd_inppkt_ULOG.c b/input/packet/ulogd_inppkt_ULOG.c
index c00d9bf..8abaa60 100644
--- a/input/packet/ulogd_inppkt_ULOG.c
+++ b/input/packet/ulogd_inppkt_ULOG.c
@@ -35,7 +35,7 @@ struct ulog_input {
 /* configuration entries */
 
 static struct config_keyset libulog_kset = {
-	.num_ces = 4,
+	.num_ces = 5,
 	.ces = {
 	{
 		.key 	 = "bufsize",
@@ -61,11 +61,17 @@ static struct config_keyset libulog_kset = {
 		.options = CONFIG_OPT_NONE,
 		.u.value = 0,
 	},
-
+	{
+		.key     = "hwaddrlen",
+		.type    = CONFIG_TYPE_INT,
+		.options = CONFIG_OPT_NONE,
+		.u.value = 6, /* ETH_ALEN */
+	},
 	}
 };
 enum ulog_keys {
-	ULOG_KEY_RAW_MAC = 0,
+	ULOG_KEY_RAW_MAC_SADDR = 0,
+	ULOG_KEY_RAW_MAC_DADDR,
 	ULOG_KEY_RAW_PCKT,
 	ULOG_KEY_RAW_PCKTLEN,
 	ULOG_KEY_RAW_PCKTCOUNT,
@@ -83,15 +89,24 @@ enum ulog_keys {
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
@@ -189,10 +204,14 @@ static int interp_packet(struct ulogd_pluginstance *ip, ulog_packet_msg_t *pkt)
 {
 	struct ulogd_key *ret = ip->output.keys;
 
-	if (pkt->mac_len) {
-		ret[ULOG_KEY_RAW_MAC].u.value.ptr = pkt->mac;
-		ret[ULOG_KEY_RAW_MAC].flags |= ULOGD_RETF_VALID;
-		ret[ULOG_KEY_RAW_MAC_LEN].u.value.ui16 = pkt->mac_len;
+	if (pkt->mac_len >= 2 * ip->config_kset->ces[4].u.value) {
+		ret[ULOG_KEY_RAW_MAC_DADDR].u.value.ptr = pkt->mac;
+		ret[ULOG_KEY_RAW_MAC_DADDR].flags |= ULOGD_RETF_VALID;
+		ret[ULOG_KEY_RAW_MAC_SADDR].u.value.ptr = pkt->mac +
+			ip->config_kset->ces[4].u.value;
+		ret[ULOG_KEY_RAW_MAC_SADDR].flags |= ULOGD_RETF_VALID;
+		ret[ULOG_KEY_RAW_MAC_LEN].u.value.ui16 =
+			ip->config_kset->ces[4].u.value;
 		ret[ULOG_KEY_RAW_MAC_LEN].flags |= ULOGD_RETF_VALID;
 	}
 
-- 
1.5.4.3

