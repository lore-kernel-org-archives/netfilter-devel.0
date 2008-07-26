From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD2 PATCH 1/2] Add hardware address parsing to MAC2STR.
Date: Sat, 26 Jul 2008 17:43:47 +0200
Message-ID: <1217087028-1136-2-git-send-email-eric@inl.fr>
References: <20080724171600.GA23670@khasse.inl.fr>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@inl.fr>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:41935 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752262AbYGZPnu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 26 Jul 2008 11:43:50 -0400
In-Reply-To: <20080724171600.GA23670@khasse.inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch modifies the MAC2STR plugin to be able convert hardware
address related fields to string:
 * raw.mac -> mac.str
 * raw.mac.saddr -> mac.saddr.str
It is able to parse ethernet header. For ethernet
we have the following conversion:
 * raw.mac ->
 	* mac.saddr.str
	* mac.daddr.str
	* oob.protocol
Output modules need to have raw.type. In case, ethernet is detected, this
field is set to ethernet and sent to output by the module.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 filter/ulogd_filter_MAC2STR.c |  174 +++++++++++++++++++++++++++++++++++-----
 1 files changed, 152 insertions(+), 22 deletions(-)

diff --git a/filter/ulogd_filter_MAC2STR.c b/filter/ulogd_filter_MAC2STR.c
index 0035886..b4c3864 100644
--- a/filter/ulogd_filter_MAC2STR.c
+++ b/filter/ulogd_filter_MAC2STR.c
@@ -26,67 +26,197 @@
 #include <stdlib.h>
 #include <string.h>
 #include <arpa/inet.h>
+#include <linux/if_arp.h>
+#include <linux/if_ether.h>
 #include <ulogd/ulogd.h>
 
-#define IPADDR_LENGTH 128
-
 enum input_keys {
+	KEY_RAW_TYPE,
+	KEY_OOB_PROTOCOL,
 	KEY_RAW_MAC,
 	KEY_RAW_MACLEN,
+	KEY_RAW_MAC_SADDR,
+	KEY_RAW_MAC_ADDRLEN,
 };
 
 enum output_keys {
+	KEY_MAC_TYPE,
+	KEY_MAC_PROTOCOL,
 	KEY_MAC_SADDR,
+	KEY_MAC_DADDR,
+	KEY_MAC_ADDR,
 };
 
 static struct ulogd_key mac2str_inp[] = {
+	[KEY_RAW_TYPE] = {
+		.type = ULOGD_RET_UINT16,
+		.flags = ULOGD_RETF_NONE|ULOGD_KEYF_OPTIONAL,
+		.name = "raw.type",
+	},
+	[KEY_OOB_PROTOCOL] = {
+		.type = ULOGD_RET_UINT16,
+		.flags = ULOGD_RETF_NONE,
+		.name = "oob.protocol",
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
+	[KEY_RAW_MAC_SADDR] = {
+		.type = ULOGD_RET_RAW,
+		.flags = ULOGD_RETF_NONE|ULOGD_KEYF_OPTIONAL,
+		.name = "raw.mac.saddr",
+	},
+	[KEY_RAW_MAC_ADDRLEN] = {
+		.type = ULOGD_RET_UINT16,
+		.flags = ULOGD_RETF_NONE|ULOGD_KEYF_OPTIONAL,
+		.name = "raw.mac.addrlen",
+	},
 };
 
 static struct ulogd_key mac2str_keys[] = {
-	{
+	[KEY_MAC_TYPE] = {
+		.type = ULOGD_RET_UINT16,
+		.flags = ULOGD_RETF_NONE,
+		.name = "raw.type",
+	},
+	[KEY_MAC_PROTOCOL] = {
+		.type = ULOGD_RET_UINT16,
+		.flags = ULOGD_RETF_NONE,
+		.name = "oob.protocol",
+	},
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
 
+static int parse_mac2str(struct ulogd_key *ret, unsigned char *mac,
+			 int okey, int len)
+{
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
+static int parse_ethernet(struct ulogd_key *ret, struct ulogd_key *inp)
+{
+	int fret;
+	if (! pp_is_valid(inp, KEY_RAW_MAC_SADDR)) {
+		fret = parse_mac2str(ret, 
+				     GET_VALUE(inp, KEY_RAW_MAC).ptr
+					+ ETH_ALEN,
+				     KEY_MAC_SADDR, ETH_ALEN);
+		if (fret != ULOGD_IRET_OK)
+			return fret;
+	}
+	fret = parse_mac2str(ret, GET_VALUE(inp, KEY_RAW_MAC).ptr,
+			     KEY_MAC_DADDR, ETH_ALEN);
+	if (fret != ULOGD_IRET_OK)
+		return fret;
+
+	ret[KEY_MAC_PROTOCOL].u.value.ui16 =
+		ntohs(*(u_int16_t *) (GET_VALUE(inp, KEY_RAW_MAC).ptr
+					+ 2 * ETH_ALEN));
+	ret[KEY_MAC_PROTOCOL].flags |= ULOGD_RETF_VALID;
+
+	return ULOGD_IRET_OK;
+}
+
 static int interp_mac2str(struct ulogd_pluginstance *pi)
 {
 	struct ulogd_key *ret = pi->output.keys;
 	struct ulogd_key *inp = pi->input.keys;
+	u_int16_t type = 0;
+
+	if (pp_is_valid(inp, KEY_OOB_PROTOCOL)) {
+		ret[KEY_MAC_PROTOCOL].u.value.ui16 =
+			GET_VALUE(inp, KEY_OOB_PROTOCOL).ui16;
+		ret[KEY_MAC_PROTOCOL].flags |= ULOGD_RETF_VALID;
+	}
+
+	if (pp_is_valid(inp, KEY_RAW_MAC_SADDR)) {
+		int fret;
+		fret = parse_mac2str(ret,
+				     GET_VALUE(inp, KEY_RAW_MAC_SADDR).ptr,
+				     KEY_MAC_SADDR,
+				     GET_VALUE(inp, KEY_RAW_MAC_ADDRLEN).ui16);
+		if (fret != ULOGD_IRET_OK)
+			return fret;
+	}
 
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
+	if (! pp_is_valid(inp, KEY_RAW_MAC)) {
+		if (GET_VALUE(inp, KEY_RAW_MAC_ADDRLEN).ui16 == ETH_ALEN) {
+			ret[KEY_MAC_TYPE].u.value.ui16 = ARPHRD_ETHER;
+			ret[KEY_MAC_TYPE].flags |= ULOGD_RETF_VALID;
+		} else {
+			ret[KEY_MAC_TYPE].u.value.ui16 = ARPHRD_VOID;
+			ret[KEY_MAC_TYPE].flags |= ULOGD_RETF_VALID;
+		}
+		return ULOGD_IRET_OK;
 	}
 
+	if (pp_is_valid(inp, KEY_RAW_TYPE)) {
+		/* NFLOG with Linux >= 2.6.27 case */
+		ret[KEY_MAC_TYPE].u.value.ui16 = type =
+			GET_VALUE(inp, KEY_RAW_TYPE).ui16;
+		ret[KEY_MAC_TYPE].flags |= ULOGD_RETF_VALID;
+	} else {
+		/* ULOG case, treat ethernet encapsulation */
+		if (GET_VALUE(inp, KEY_RAW_MACLEN).ui16 == ETH_HLEN) {
+			ret[KEY_MAC_TYPE].u.value.ui16 = type = ARPHRD_ETHER;
+			ret[KEY_MAC_TYPE].flags |= ULOGD_RETF_VALID;
+		} else {
+			ret[KEY_MAC_TYPE].u.value.ui16 = type = ARPHRD_VOID;
+			ret[KEY_MAC_TYPE].flags |= ULOGD_RETF_VALID;
+		}
+	}
+
+	switch (type) {
+		case ARPHRD_ETHER:
+			parse_ethernet(ret, inp);
+		default:
+			/* convert raw header to string */
+			return parse_mac2str(ret,
+					     GET_VALUE(inp, KEY_RAW_MAC).ptr,
+					     KEY_MAC_ADDR,
+					     GET_VALUE(inp,
+						     KEY_RAW_MACLEN).ui16);
+	}
 	return ULOGD_IRET_OK;
 }
 
+
+
 static struct ulogd_plugin mac2str_pluging = {
 	.name = "MAC2STR",
 	.input = {
-- 
1.5.4.3

