From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 6/6] Sync PRINTPKT with mac modification.
Date: Sat, 28 Jun 2008 01:03:00 +0200
Message-ID: <1214607780-31389-7-git-send-email-eric@inl.fr>
References: <485FB66A.1090601@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@inl.fr>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:56484 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764366AbYF0W5u (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Jun 2008 18:57:50 -0400
In-Reply-To: <485FB66A.1090601@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch synchronizes the PRINTPKT plugin with the replacement
of raw.mac by raw.mac.saddr and raw.mac.daddr. It now displays
a SMAC and a DMAC field in the message.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 include/ulogd/printpkt.h |    3 ++-
 util/printpkt.c          |   26 +++++++++++++++++++++-----
 2 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/include/ulogd/printpkt.h b/include/ulogd/printpkt.h
index 6207d5b..7294743 100644
--- a/include/ulogd/printpkt.h
+++ b/include/ulogd/printpkt.h
@@ -10,7 +10,8 @@ enum pkt_keys {
 	KEY_OOB_UID,
 	KEY_OOB_GID,
 	KEY_OOB_MARK,
-	KEY_RAW_MAC,
+	KEY_RAW_MAC_SADDR,
+	KEY_RAW_MAC_DADDR,
 	KEY_RAW_MACLEN,
 	KEY_IP_SADDR,
 	KEY_IP_DADDR,
diff --git a/util/printpkt.c b/util/printpkt.c
index 90fec0e..d08ec92 100644
--- a/util/printpkt.c
+++ b/util/printpkt.c
@@ -52,7 +52,12 @@ struct ulogd_key printpkt_keys[] = {
 				    .flags = ULOGD_KEYF_OPTIONAL
 				  },
 	[KEY_OOB_MARK]		= { .name = "oob.mark", },
-	[KEY_RAW_MAC]		= { .name = "raw.mac", },
+	[KEY_RAW_MAC_SADDR]	= { .name = "raw.mac.saddr",
+				    .flags = ULOGD_KEYF_OPTIONAL
+				  },
+	[KEY_RAW_MAC_DADDR]	= { .name = "raw.mac.daddr", 
+				    .flags = ULOGD_KEYF_OPTIONAL
+				  },
 	[KEY_RAW_MACLEN]	= { .name = "raw.mac_len", },
 	[KEY_IP_SADDR]		= { .name = "ip.saddr.str", },
 	[KEY_IP_DADDR]		= { .name = "ip.daddr.str", },
@@ -430,16 +435,27 @@ int printpkt_print(struct ulogd_key *res, char *buf)
 				   (char *) GET_VALUE(res, KEY_OOB_OUT).ptr);
 
 	/* FIXME: configurable */
-	if (pp_is_valid(res, KEY_RAW_MAC)) {
-		unsigned char *mac = (unsigned char *) GET_VALUE(res, KEY_RAW_MAC).ptr;
+	if (pp_is_valid(res, KEY_RAW_MAC_SADDR)) {
+		unsigned char *mac = (unsigned char *) GET_VALUE(res, KEY_RAW_MAC_SADDR).ptr;
+		int i, len = GET_VALUE(res, KEY_RAW_MACLEN).ui16;
+
+		buf_cur += sprintf(buf_cur, "SMAC=");
+		for (i = 0; i < len; i++)
+			buf_cur += sprintf(buf_cur, "%02x%c", mac[i],
+					   i == len - 1 ? ' ' : ':');
+	} else
+		buf_cur += sprintf(buf_cur, "SMAC= ");
+
+	if (pp_is_valid(res, KEY_RAW_MAC_DADDR)) {
+		unsigned char *mac = (unsigned char *) GET_VALUE(res, KEY_RAW_MAC_DADDR).ptr;
 		int i, len = GET_VALUE(res, KEY_RAW_MACLEN).ui16;
 
-		buf_cur += sprintf(buf_cur, "MAC=");
+		buf_cur += sprintf(buf_cur, "DMAC=");
 		for (i = 0; i < len; i++)
 			buf_cur += sprintf(buf_cur, "%02x%c", mac[i],
 					   i == len - 1 ? ' ' : ':');
 	} else
-		buf_cur += sprintf(buf_cur, "MAC= ");
+		buf_cur += sprintf(buf_cur, "DMAC= ");
 
 	switch (GET_VALUE(res, KEY_OOB_FAMILY).ui8) {
 	case AF_INET:
-- 
1.5.4.3

