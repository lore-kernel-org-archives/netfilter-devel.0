From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 1/3] Add numeric_label option to ULOG input plugin.
Date: Mon, 28 Apr 2008 15:53:56 +0200
Message-ID: <1209390838-12953-2-git-send-email-eric@inl.fr>
References: <4815D4B0.6040703@netfilter.org>
 <1209390838-12953-1-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:45035 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933042AbYD1NyA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Apr 2008 09:54:00 -0400
In-Reply-To: <1209390838-12953-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds support for "numeric_label" option to the ULOG plugin. For example, it
can be used by another module to determine if the packet has been dropped,
rejected or accepted.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 input/packet/ulogd_inppkt_ULOG.c |   18 +++++++++++++++++-
 1 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/input/packet/ulogd_inppkt_ULOG.c b/input/packet/ulogd_inppkt_ULOG.c
index 5112281..253bbe0 100644
--- a/input/packet/ulogd_inppkt_ULOG.c
+++ b/input/packet/ulogd_inppkt_ULOG.c
@@ -34,7 +34,7 @@ struct ulog_input {
 /* configuration entries */
 
 static struct config_keyset libulog_kset = {
-	.num_ces = 3,
+	.num_ces = 4,
 	.ces = {
 	{
 		.key 	 = "bufsize",
@@ -54,6 +54,13 @@ static struct config_keyset libulog_kset = {
 		.options = CONFIG_OPT_NONE,
 		.u.value = ULOGD_RMEM_DEFAULT,
 	},
+	{
+		.key	 = "numeric_label",
+		.type	 = CONFIG_TYPE_INT,
+		.options = CONFIG_OPT_NONE,
+		.u.value = 0,
+	},
+
 	}
 };
 enum ulog_keys {
@@ -71,6 +78,7 @@ enum ulog_keys {
 	ULOG_KEY_RAW_MAC_LEN,
 	ULOG_KEY_OOB_FAMILY,
 	ULOG_KEY_OOB_PROTOCOL,
+	ULOG_KEY_RAW_LABEL,
 };
 
 static struct ulogd_key output_keys[] = {
@@ -167,6 +175,11 @@ static struct ulogd_key output_keys[] = {
 		.flags = ULOGD_RETF_NONE,
 		.name = "oob.protocol",
 	},
+	{
+		.type = ULOGD_RET_UINT8,
+		.flags = ULOGD_RETF_NONE,
+		.name = "raw.label",
+	},
 
 };
 
@@ -181,6 +194,9 @@ static int interp_packet(struct ulogd_pluginstance *ip, ulog_packet_msg_t *pkt)
 		ret[ULOG_KEY_RAW_MAC_LEN].flags |= ULOGD_RETF_VALID;
 	}
 
+	ret[ULOG_KEY_RAW_LABEL].u.value.ui8 = ip->config_kset->ces[3].u.value;
+	ret[ULOG_KEY_RAW_LABEL].flags |= ULOGD_RETF_VALID;
+
 	/* include pointer to raw ipv4 packet */
 	ret[ULOG_KEY_RAW_PCKT].u.value.ptr = pkt->payload;
 	ret[ULOG_KEY_RAW_PCKT].flags |= ULOGD_RETF_VALID;
-- 
1.5.4.3

