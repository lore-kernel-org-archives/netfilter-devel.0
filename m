From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 1/7] Add label option to NFLOG input plugin.
Date: Wed, 16 Apr 2008 15:22:35 +0200
Message-ID: <1208352161448-git-send-email-eric@inl.fr>
References: <4805E566.7010902@netfilter.org>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:33216 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759910AbYDPNWo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Apr 2008 09:22:44 -0400
In-Reply-To: <4805E566.7010902@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds support for "label" option to the NFLOG plugin. For example, it
can be used by another module to determine if the packet has been dropped,
rejected or accepted.

This patch also fixes a bug in definition of seq_global_ce macro.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
:100644 100644 195f6cc... e67ae7a... M	input/packet/ulogd_inppkt_NFLOG.c
 input/packet/ulogd_inppkt_NFLOG.c |   24 +++++++++++++++++++++---
 1 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/input/packet/ulogd_inppkt_NFLOG.c b/input/packet/ulogd_inppkt_NFLOG.c
index 195f6cc..e67ae7a 100644
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
+			.key	 = "label",
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
+#define label_ce(x)	(x->ces[7])
 
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
+		.name = "raw.label",
+	},
+
 
 };
 
@@ -270,6 +285,9 @@ interp_packet(struct ulogd_pluginstance *upi, struct nflog_data *ldata)
 	ret[NFLOG_KEY_OOB_FAMILY].u.value.ui8 = af_ce(upi->config_kset).u.value;
 	ret[NFLOG_KEY_OOB_FAMILY].flags |= ULOGD_RETF_VALID;
 
+	ret[NFLOG_KEY_RAW_STATE].u.value.ui8 = label_ce(upi->config_kset).u.value;
+	ret[NFLOG_KEY_RAW_STATE].flags |= ULOGD_RETF_VALID;
+
 	if (ph) {
 		/* FIXME */
 		ret[NFLOG_KEY_OOB_HOOK].u.value.ui8 = ph->hook;
-- 
1.5.2.5

