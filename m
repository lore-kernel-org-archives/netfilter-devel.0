From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 4/5] Add support for UID dumping to NFLOG input plugin.
Date: Sat,  9 Feb 2008 13:36:34 +0100
Message-ID: <12025605962908-git-send-email-eric@inl.fr>
References: <12025605952271-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:54972 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753972AbYBIMgi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 9 Feb 2008 07:36:38 -0500
In-Reply-To: <12025605952271-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Eric Leblond <eric@inl.fr>
---
 input/packet/ulogd_inppkt_NFLOG.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/input/packet/ulogd_inppkt_NFLOG.c b/input/packet/ulogd_inppkt_NFLOG.c
index 1b8e32c..3f013cc 100644
--- a/input/packet/ulogd_inppkt_NFLOG.c
+++ b/input/packet/ulogd_inppkt_NFLOG.c
@@ -106,6 +106,7 @@ enum nflog_keys {
 	NFLOG_KEY_OOB_SEQ_GLOBAL,
 	NFLOG_KEY_OOB_FAMILY,
 	NFLOG_KEY_OOB_PROTOCOL,
+	NFLOG_KEY_OOB_UID,
 };
 
 static struct ulogd_key output_keys[] = {
@@ -240,6 +241,12 @@ static struct ulogd_key output_keys[] = {
 		.flags = ULOGD_RETF_NONE,
 		.name = "oob.protocol",
 	},
+	{
+		.type = ULOGD_RET_UINT32,
+		.flags = ULOGD_RETF_NONE,
+		.name = "oob.uid",
+	},
+
 };
 
 static inline int 
@@ -257,6 +264,8 @@ interp_packet(struct ulogd_pluginstance *upi, struct nflog_data *ldata)
 	u_int32_t indev = nflog_get_indev(ldata);
 	u_int32_t outdev = nflog_get_outdev(ldata);
 	u_int32_t seq;
+	u_int32_t uid;
+	
 
 	ret[NFLOG_KEY_OOB_FAMILY].u.value.ui8 = af_ce(upi->config_kset).u.value;
 	ret[NFLOG_KEY_OOB_FAMILY].flags |= ULOGD_RETF_VALID;
@@ -317,6 +326,11 @@ interp_packet(struct ulogd_pluginstance *upi, struct nflog_data *ldata)
 		ret[NFLOG_KEY_OOB_IFINDEX_OUT].flags |= ULOGD_RETF_VALID;
 	}
 
+	if (nflog_get_uid(ldata, &uid) == 0) {
+		ret[NFLOG_KEY_OOB_UID].u.value.ui32 = uid;
+		ret[NFLOG_KEY_OOB_UID].flags |= ULOGD_RETF_VALID;
+	}
+
 	if (nflog_get_seq(ldata, &seq) == 0) {
 		ret[NFLOG_KEY_OOB_SEQ_LOCAL].u.value.ui32 = seq;
 		ret[NFLOG_KEY_OOB_SEQ_LOCAL].flags |= ULOGD_RETF_VALID;
-- 
1.5.2.5

