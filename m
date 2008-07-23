From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD2 PATCH 3/4] Add source and destination address convertion in MAC2STR.
Date: Wed, 23 Jul 2008 23:20:47 +0200
Message-ID: <1216848048-13516-3-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:39935 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754676AbYGWVUu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jul 2008 17:20:50 -0400
In-Reply-To: <>
References: <>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch modifies the MAC2STR plugin to be able convert hardware
address related fields to string:
 * raw.mac -> mac.str
 * raw.mac.saddr -> mac.saddr.str
 * raw.mac.daddr -> mac.daddr.str
Each field is optional and is converted if present.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 filter/ulogd_filter_MAC2STR.c |   92 ++++++++++++++++++++++++++++++++--------
 1 files changed, 73 insertions(+), 19 deletions(-)

diff --git a/filter/ulogd_filter_MAC2STR.c b/filter/ulogd_filter_MAC2STR.c
index 0035886..05f9de9 100644
--- a/filter/ulogd_filter_MAC2STR.c
+++ b/filter/ulogd_filter_MAC2STR.c
@@ -31,57 +31,111 @@
 #define IPADDR_LENGTH 128
 
 enum input_keys {
+	KEY_RAW_MAC_SADDR,
+	KEY_RAW_MAC_DADDR,
+	KEY_RAW_MACADDRLEN,
 	KEY_RAW_MAC,
 	KEY_RAW_MACLEN,
 };
 
 enum output_keys {
 	KEY_MAC_SADDR,
+	KEY_MAC_DADDR,
+	KEY_MAC_ADDR,
 };
 
 static struct ulogd_key mac2str_inp[] = {
+	[KEY_RAW_MAC_SADDR] = {
+		.type = ULOGD_RET_RAW,
+		.flags = ULOGD_RETF_NONE|ULOGD_KEYF_OPTIONAL,
+		.name = "raw.mac.saddr",
+	},
+	[KEY_RAW_MAC_DADDR] = {
+		.type = ULOGD_RET_RAW,
+		.flags = ULOGD_RETF_NONE|ULOGD_KEYF_OPTIONAL,
+		.name = "raw.mac.daddr",
+	},
+	[KEY_RAW_MACADDRLEN] = {
+		.type = ULOGD_RET_UINT16,
+		.flags = ULOGD_RETF_NONE|ULOGD_KEYF_OPTIONAL,
+		.name = "raw.mac.addrlen",
+	},
 	[KEY_RAW_MAC] = {
 		.type = ULOGD_RET_RAW,
-		.flags = ULOGD_RETF_NONE,
+		.flags = ULOGD_RETF_NONE|ULOGD_KEYF_OPTIONAL,
 		.name = "raw.mac",
 	},
 	[KEY_RAW_MACLEN] = { 
 		.type = ULOGD_RET_UINT16, 
-		.flags = ULOGD_RETF_NONE, 
+		.flags = ULOGD_RETF_NONE|ULOGD_KEYF_OPTIONAL,
 		.name = "raw.mac_len", 
 	},
-
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
+	[KEY_MAC_ADDR] = {
+		.type = ULOGD_RET_STRING,
+		.flags = ULOGD_RETF_FREE,
+		.name = "mac.str",
+	},
 };
 
+static int parse_mac2str(struct ulogd_key *ret, struct ulogd_key *inp,
+			 int ikey, int okey, int key_size)
+{
+	unsigned char *mac = (unsigned char *) GET_VALUE(inp, ikey).ptr;
+	int len = GET_VALUE(inp, key_size).ui16;
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
+	ret[okey].u.value.ptr = mac_str;
+	ret[okey].flags |= ULOGD_RETF_VALID;
+
+	return ULOGD_IRET_OK;
+}
+
 static int interp_mac2str(struct ulogd_pluginstance *pi)
 {
 	struct ulogd_key *ret = pi->output.keys;
 	struct ulogd_key *inp = pi->input.keys;
+	int retc;
+
+	if (pp_is_valid(inp, KEY_RAW_MAC_SADDR)) {
+		retc = parse_mac2str(ret, inp, KEY_RAW_MAC_SADDR,
+				     KEY_MAC_SADDR, KEY_RAW_MACADDRLEN);
+		if (retc != ULOGD_IRET_OK)
+			return retc;
+	}
+	if (pp_is_valid(inp, KEY_RAW_MAC_DADDR)) {
+		retc = parse_mac2str(ret, inp, KEY_RAW_MAC_DADDR,
+				     KEY_MAC_DADDR, KEY_RAW_MACADDRLEN);
+		if (retc != ULOGD_IRET_OK)
+			return retc;
+	}
 
 	if (pp_is_valid(inp, KEY_RAW_MAC)) {
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
+		retc = parse_mac2str(ret, inp, KEY_RAW_MAC,
+				     KEY_MAC_ADDR, KEY_RAW_MACLEN);
+		if (retc != ULOGD_IRET_OK)
+			return retc;
 	}
 
 	return ULOGD_IRET_OK;
-- 
1.5.4.3

