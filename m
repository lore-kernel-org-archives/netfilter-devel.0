From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 2/6] Adapt MAC2STR to NFLOG and ULOG input key change.
Date: Sat, 28 Jun 2008 01:02:56 +0200
Message-ID: <1214607780-31389-3-git-send-email-eric@inl.fr>
References: <485FB66A.1090601@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@inl.fr>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:56481 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764359AbYF0W5t (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Jun 2008 18:57:49 -0400
In-Reply-To: <485FB66A.1090601@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

MAC2STR was only dealing with the raw.mac key. This patch modifies
its behaviour to be able to convert raw.mac.saddr and raw.mac.daddr
fields.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 filter/ulogd_filter_MAC2STR.c |   69 ++++++++++++++++++++++++++++------------
 1 files changed, 48 insertions(+), 21 deletions(-)

diff --git a/filter/ulogd_filter_MAC2STR.c b/filter/ulogd_filter_MAC2STR.c
index 0035886..bb40c2b 100644
--- a/filter/ulogd_filter_MAC2STR.c
+++ b/filter/ulogd_filter_MAC2STR.c
@@ -31,19 +31,26 @@
 #define IPADDR_LENGTH 128
 
 enum input_keys {
-	KEY_RAW_MAC,
+	KEY_RAW_MAC_SADDR,
+	KEY_RAW_MAC_DADDR,
 	KEY_RAW_MACLEN,
 };
 
 enum output_keys {
 	KEY_MAC_SADDR,
+	KEY_MAC_DADDR,
 };
 
 static struct ulogd_key mac2str_inp[] = {
-	[KEY_RAW_MAC] = {
+	[KEY_RAW_MAC_SADDR] = {
 		.type = ULOGD_RET_RAW,
-		.flags = ULOGD_RETF_NONE,
-		.name = "raw.mac",
+		.flags = ULOGD_RETF_NONE|ULOGD_KEYF_OPTIONAL,
+		.name = "raw.mac.saddr",
+	},
+	[KEY_RAW_MAC_DADDR] = {
+		.type = ULOGD_RET_RAW,
+		.flags = ULOGD_RETF_NONE|ULOGD_KEYF_OPTIONAL,
+		.name = "raw.mac.daddr",
 	},
 	[KEY_RAW_MACLEN] = { 
 		.type = ULOGD_RET_UINT16, 
@@ -54,34 +61,54 @@ static struct ulogd_key mac2str_inp[] = {
 };
 
 static struct ulogd_key mac2str_keys[] = {
-	{
+	[KEY_MAC_SADDR] = {
 		.type = ULOGD_RET_STRING,
 		.flags = ULOGD_RETF_FREE,
 		.name = "mac.saddr.str",
 	},
+	[KEY_MAC_DADDR] = {
+		.type = ULOGD_RET_STRING,
+		.flags = ULOGD_RETF_FREE,
+		.name = "mac.daddr.str",
+	},
 };
 
+static int parse_mac2str(struct ulogd_key *ret, struct ulogd_key *inp, int key)
+{
+	unsigned char *mac = (unsigned char *) GET_VALUE(inp, key).ptr;
+	int len = GET_VALUE(inp, KEY_RAW_MACLEN).ui16;
+	char *mac_str = calloc(len/sizeof(char)*3, sizeof(char));
+	char *buf_cur = mac_str;
+	int i;
+
+	if (mac_str == NULL)
+		return ULOGD_IRET_ERR;
+
+	for (i = 0; i < len; i++)
+		buf_cur += sprintf(buf_cur, "%02x%c", mac[i],
+				i == len - 1 ? 0 : ':');
+
+	ret[key].u.value.ptr = mac_str;
+	ret[key].flags |= ULOGD_RETF_VALID;
+
+	return ULOGD_IRET_OK;
+}
+
 static int interp_mac2str(struct ulogd_pluginstance *pi)
 {
 	struct ulogd_key *ret = pi->output.keys;
 	struct ulogd_key *inp = pi->input.keys;
+	int retc;
 
-	if (pp_is_valid(inp, KEY_RAW_MAC)) {
-		unsigned char *mac = (unsigned char *) GET_VALUE(inp, KEY_RAW_MAC).ptr;
-		int len = GET_VALUE(inp, KEY_RAW_MACLEN).ui16;
-		char *mac_str = calloc(len/sizeof(char)*3, sizeof(char));
-		char *buf_cur = mac_str;
-		int i;
-		
-		if (mac_str == NULL)
-			return ULOGD_IRET_ERR;
-
-		for (i = 0; i < len; i++)
-			buf_cur += sprintf(buf_cur, "%02x%c", mac[i],
-					   i == len - 1 ? 0 : ':');
-
-		ret[KEY_MAC_SADDR].u.value.ptr = mac_str;
-		ret[KEY_MAC_SADDR].flags |= ULOGD_RETF_VALID;
+	if (pp_is_valid(inp, KEY_RAW_MAC_SADDR)) {
+		retc = parse_mac2str(ret, inp, KEY_RAW_MAC_SADDR);
+		if (retc != ULOGD_IRET_OK)
+			return retc;
+	}
+	if (pp_is_valid(inp, KEY_RAW_MAC_DADDR)) {
+		retc = parse_mac2str(ret, inp, KEY_RAW_MAC_DADDR);
+		if (retc != ULOGD_IRET_OK)
+			return retc;
 	}
 
 	return ULOGD_IRET_OK;
-- 
1.5.4.3

