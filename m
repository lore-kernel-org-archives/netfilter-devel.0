From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 4/5] Add label option to NFLOG input plugin.
Date: Mon, 21 Apr 2008 22:43:46 +0200
Message-ID: <12088106271839-git-send-email-eric@inl.fr>
References: <12088106273628-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:40015 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752189AbYDUUnt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Apr 2008 16:43:49 -0400
In-Reply-To: <12088106273628-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds support for "label" option to the NFLOG plugin. For example, it
can be used by another module to determine if the packet has been dropped,
rejected or accepted.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 input/packet/ulogd_inppkt_NFLOG.c |   20 +++++++++++++++++++-
 1 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/input/packet/ulogd_inppkt_NFLOG.c b/input/packet/ulogd_inppkt_NFLOG.c
index 43e1bc4..13f59a7 100644
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
 
@@ -88,6 +95,7 @@ static struct config_keyset libulog_kset = {
 #define unbind_ce(x)	(x->ces[4])
 #define seq_ce(x)	(x->ces[5])
 #define seq_global_ce(x)	(x->ces[6])
+#define label_ce(x)	(x->ces[7])
 
 enum nflog_keys {
 	NFLOG_KEY_RAW_MAC = 0,
@@ -108,6 +116,7 @@ enum nflog_keys {
 	NFLOG_KEY_OOB_PROTOCOL,
 	NFLOG_KEY_OOB_UID,
 	NFLOG_KEY_OOB_GID,
+	NFLOG_KEY_RAW_LABEL,
 };
 
 static struct ulogd_key output_keys[] = {
@@ -252,6 +261,12 @@ static struct ulogd_key output_keys[] = {
 		.flags = ULOGD_RETF_NONE,
 		.name = "oob.gid",
 	},
+	{
+		.type = ULOGD_RET_UINT8,
+		.flags = ULOGD_RETF_NONE,
+		.name = "raw.label",
+	},
+
 };
 
 static inline int 
@@ -275,6 +290,9 @@ interp_packet(struct ulogd_pluginstance *upi, struct nflog_data *ldata)
 	ret[NFLOG_KEY_OOB_FAMILY].u.value.ui8 = af_ce(upi->config_kset).u.value;
 	ret[NFLOG_KEY_OOB_FAMILY].flags |= ULOGD_RETF_VALID;
 
+	ret[NFLOG_KEY_RAW_LABEL].u.value.ui8 = label_ce(upi->config_kset).u.value;
+	ret[NFLOG_KEY_RAW_LABEL].flags |= ULOGD_RETF_VALID;
+
 	if (ph) {
 		/* FIXME */
 		ret[NFLOG_KEY_OOB_HOOK].u.value.ui8 = ph->hook;
-- 
1.5.2.5

