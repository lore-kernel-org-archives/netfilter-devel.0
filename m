From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 08/14] Add state option to NFLOG input plugin.
Date: Sun, 23 Mar 2008 17:25:16 +0100
Message-ID: <12062895233806-git-send-email-eric@inl.fr>
References: <1206289522679-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:55046 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752729AbYCWQZZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 23 Mar 2008 12:25:25 -0400
In-Reply-To: <1206289522679-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds support for "state" option to the NFLOG plugin. For example, it
can be used by another module to determine if the packet has been dropped,
rejected or accepted.

This patch also fixes a bug in definition of seq_global_ce macro.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 input/packet/ulogd_inppkt_NFLOG.c |   24 +++++++++++++++++++++---
 1 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/input/packet/ulogd_inppkt_NFLOG.c b/input/packet/ulogd_inppkt_NFLOG.c
index 467d42f..7562687 100644
--- a/input/packet/ulogd_inppkt_NFLOG.c
+++ b/input/packet/ulogd_inppkt_NFLOG.c
@@ -34,7 +34,7 @@ struct nflog_input {
 /* configuration entries */
 
 static struct config_keyset libulog_kset = {
-	.num_ces = 7,
+	.num_ces = 8,
 	.ces = {
 		{
 			.key 	 = "bufsize",
@@ -78,6 +78,13 @@ static struct config_keyset libulog_kset = {
 			.options = CONFIG_OPT_NONE,
 			.u.value = 0,
 		},
+		{
+			.key	 = "state",
+			.type	 = CONFIG_TYPE_INT,
+			.options = CONFIG_OPT_NONE,
+			.u.value = 0,
+		},
+
 	}
 };
 
@@ -86,8 +93,9 @@ static struct config_keyset libulog_kset = {
 #define rmem_ce(x)	(x->ces[2])
 #define af_ce(x)	(x->ces[3])
 #define unbind_ce(x)	(x->ces[4])
-#define seq_ce(x)	(x->ces[4])
-#define seq_global_ce(x)	(x->ces[5])
+#define seq_ce(x)	(x->ces[5])
+#define seq_global_ce(x)	(x->ces[6])
+#define state_ce(x)	(x->ces[7])
 
 enum nflog_keys {
 	NFLOG_KEY_RAW_MAC = 0,
@@ -107,6 +115,7 @@ enum nflog_keys {
 	NFLOG_KEY_OOB_FAMILY,
 	NFLOG_KEY_OOB_PROTOCOL,
 	NFLOG_KEY_OOB_UID,
+	NFLOG_KEY_RAW_STATE,
 };
 
 static struct ulogd_key output_keys[] = {
@@ -246,6 +255,12 @@ static struct ulogd_key output_keys[] = {
 		.flags = ULOGD_RETF_NONE,
 		.name = "oob.uid",
 	},
+	{
+		.type = ULOGD_RET_UINT8,
+		.flags = ULOGD_RETF_NONE,
+		.name = "raw.state",
+	},
+
 
 };
 
@@ -270,6 +285,9 @@ interp_packet(struct ulogd_pluginstance *upi, struct nflog_data *ldata)
 	ret[NFLOG_KEY_OOB_FAMILY].u.value.ui8 = af_ce(upi->config_kset).u.value;
 	ret[NFLOG_KEY_OOB_FAMILY].flags |= ULOGD_RETF_VALID;
 
+	ret[NFLOG_KEY_RAW_STATE].u.value.ui8 = state_ce(upi->config_kset).u.value;
+	ret[NFLOG_KEY_RAW_STATE].flags |= ULOGD_RETF_VALID;
+
 	if (ph) {
 		/* FIXME */
 		ret[NFLOG_KEY_OOB_HOOK].u.value.ui8 = ph->hook;
-- 
1.5.2.5

