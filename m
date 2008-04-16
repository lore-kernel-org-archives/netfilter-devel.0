From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 3/7] Add label option to ULOG input plugin.
Date: Wed, 16 Apr 2008 15:22:37 +0200
Message-ID: <12083521613823-git-send-email-eric@inl.fr>
References: <4805E566.7010902@netfilter.org>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:33222 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760735AbYDPNWo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Apr 2008 09:22:44 -0400
In-Reply-To: <4805E566.7010902@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds support for "label" option to the ULOG plugin. For example, it
can be used by another module to determine if the packet has been dropped,
rejected or accepted.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
:100644 100644 d30c07e... c3a44da... M	input/packet/ulogd_inppkt_ULOG.c
 input/packet/ulogd_inppkt_ULOG.c |   18 +++++++++++++++++-
 1 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/input/packet/ulogd_inppkt_ULOG.c b/input/packet/ulogd_inppkt_ULOG.c
index d30c07e..c3a44da 100644
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
+		.key	 = "label",
+		.type	 = CONFIG_TYPE_INT,
+		.options = CONFIG_OPT_NONE,
+		.u.value = 0,
+	},
+
 	}
 };
 enum ulog_keys {
@@ -70,6 +77,7 @@ enum ulog_keys {
 	ULOG_KEY_RAW_MAC_LEN,
 	ULOG_KEY_OOB_FAMILY,
 	ULOG_KEY_OOB_PROTOCOL,
+	ULOG_KEY_RAW_STATE,
 };
 
 static struct ulogd_key output_keys[] = {
@@ -157,6 +165,11 @@ static struct ulogd_key output_keys[] = {
 		.flags = ULOGD_RETF_NONE,
 		.name = "oob.protocol",
 	},
+	{
+		.type = ULOGD_RET_UINT8,
+		.flags = ULOGD_RETF_NONE,
+		.name = "raw.label",
+	},
 
 };
 
@@ -171,6 +184,9 @@ static int interp_packet(struct ulogd_pluginstance *ip, ulog_packet_msg_t *pkt)
 		ret[ULOG_KEY_RAW_MAC_LEN].flags |= ULOGD_RETF_VALID;
 	}
 
+	ret[ULOG_KEY_RAW_STATE].u.value.ui8 = ip->config_kset->ces[3].u.value;
+	ret[ULOG_KEY_RAW_STATE].flags |= ULOGD_RETF_VALID;
+
 	/* include pointer to raw ipv4 packet */
 	ret[ULOG_KEY_RAW_PCKT].u.value.ptr = pkt->payload;
 	ret[ULOG_KEY_RAW_PCKT].flags |= ULOGD_RETF_VALID;
-- 
1.5.2.5

