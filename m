From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 10/14] Add state option to ULOG input plugin.
Date: Sun, 23 Mar 2008 17:25:18 +0100
Message-ID: <1206289523956-git-send-email-eric@inl.fr>
References: <1206289522679-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:55069 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752729AbYCWQZ3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 23 Mar 2008 12:25:29 -0400
In-Reply-To: <1206289522679-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


This patch adds support for "state" option to the ULOG plugin. For example, it
can be used by another module to determine if the packet has been dropped,
rejected or accepted.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 input/packet/ulogd_inppkt_ULOG.c |   18 +++++++++++++++++-
 1 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/input/packet/ulogd_inppkt_ULOG.c b/input/packet/ulogd_inppkt_ULOG.c
index a1d52f2..9139e7d 100644
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
+		.key	 = "state",
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
+		.name = "raw.state",
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

