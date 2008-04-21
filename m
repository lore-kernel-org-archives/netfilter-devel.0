From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 2/5] Add hook output to ULOG input module.
Date: Mon, 21 Apr 2008 22:43:44 +0200
Message-ID: <12088106273511-git-send-email-eric@inl.fr>
References: <12088106273628-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:40011 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752071AbYDUUnt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Apr 2008 16:43:49 -0400
In-Reply-To: <12088106273628-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds oob.hook to the list of output key sof ULOG input plugin.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 input/packet/ulogd_inppkt_ULOG.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/input/packet/ulogd_inppkt_ULOG.c b/input/packet/ulogd_inppkt_ULOG.c
index a58b41f..064321a 100644
--- a/input/packet/ulogd_inppkt_ULOG.c
+++ b/input/packet/ulogd_inppkt_ULOG.c
@@ -74,6 +74,7 @@ enum ulog_keys {
 	ULOG_KEY_OOB_MARK,
 	ULOG_KEY_OOB_IN,
 	ULOG_KEY_OOB_OUT,
+	ULOG_KEY_OOB_HOOK,
 	ULOG_KEY_RAW_MAC_LEN,
 	ULOG_KEY_OOB_FAMILY,
 	ULOG_KEY_OOB_PROTOCOL,
@@ -150,6 +151,15 @@ static struct ulogd_key output_keys[] = {
 		.flags = ULOGD_RETF_NONE,
 		.name = "oob.out", 
 	},
+	{
+		.type = ULOGD_RET_UINT8,
+		.flags = ULOGD_RETF_NONE,
+		.name = "oob.hook",
+		.ipfix = {
+			.vendor = IPFIX_VENDOR_NETFILTER,
+			.field_id = IPFIX_NF_hook,
+		},
+	},
 	{ 
 		.type = ULOGD_RET_UINT16, 
 		.flags = ULOGD_RETF_NONE, 
@@ -217,6 +227,9 @@ static int interp_packet(struct ulogd_pluginstance *ip, ulog_packet_msg_t *pkt)
 	ret[ULOG_KEY_OOB_OUT].u.value.ptr = pkt->outdev_name;
 	ret[ULOG_KEY_OOB_OUT].flags |= ULOGD_RETF_VALID;
 
+	ret[ULOG_KEY_OOB_HOOK].u.value.ui8 = pkt->hook;
+	ret[ULOG_KEY_OOB_HOOK].flags |= ULOGD_RETF_VALID;
+
 	/* ULOG is IPv4 only */
 	ret[ULOG_KEY_OOB_FAMILY].u.value.ui8 = AF_INET;
 	ret[ULOG_KEY_OOB_FAMILY].flags |= ULOGD_RETF_VALID;
-- 
1.5.2.5

