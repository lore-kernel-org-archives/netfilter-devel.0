From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 4/6] Introduce datatype and hwaddrlen param to MAC2STR plugin.
Date: Thu, 19 Jun 2008 14:23:05 +0200
Message-ID: <1213878187-909-5-git-send-email-eric@inl.fr>
References: <1213878187-909-1-git-send-email-eric@inl.fr>
Cc: chifflier@inl.fr, Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:60869 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756448AbYFSMXd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jun 2008 08:23:33 -0400
In-Reply-To: <1213878187-909-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch introduces a hwaddrlen and datatype parameters in
MAC2STR configuration. This is a workaround differences between
ULOG and NFLOG:
 * NFLOG sends MAC address in userspace (dev_parse_header content)
 * ULOG sends complete link header (skb_mac_header content)
And they use the same field (raw.mac) for that. Database schema
needs mac.saddr.str and/or mac.daddr.str fields. With datatype set
0 only mac.daddr is logged. Both fields are filled when datatype is
set to 1. hwaddrlen param can be used to change the length of
link header address (default is 6 which is used by ethernet header).

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 filter/ulogd_filter_MAC2STR.c |  117 ++++++++++++++++++++++++++++++++++------
 ulogd.conf.in                 |    9 +++
 2 files changed, 108 insertions(+), 18 deletions(-)

diff --git a/filter/ulogd_filter_MAC2STR.c b/filter/ulogd_filter_MAC2STR.c
index 0035886..0d09baa 100644
--- a/filter/ulogd_filter_MAC2STR.c
+++ b/filter/ulogd_filter_MAC2STR.c
@@ -30,6 +30,34 @@
 
 #define IPADDR_LENGTH 128
 
+enum mac2str_kset {
+	MAC2STR_LEN,
+	MAC2STR_TYPE,
+};
+
+enum mac2str_datatype {
+	MAC2STR_ONLY_SMAC,
+	MAC2STR_FULL_MAC,
+};
+
+static struct config_keyset libulog_kset = {
+	.num_ces = 2,
+	.ces = {
+		[MAC2STR_LEN] = {
+			.key 	 = "hwaddrlen",
+			.type 	 = CONFIG_TYPE_INT,
+			.options = CONFIG_OPT_NONE,
+			.u.value = 6,
+		},
+		[MAC2STR_TYPE] = {
+			.key 	 = "datatype",
+			.type 	 = CONFIG_TYPE_INT,
+			.options = CONFIG_OPT_NONE,
+			.u.value = MAC2STR_ONLY_SMAC,
+		}
+	}
+};
+
 enum input_keys {
 	KEY_RAW_MAC,
 	KEY_RAW_MACLEN,
@@ -37,6 +65,7 @@ enum input_keys {
 
 enum output_keys {
 	KEY_MAC_SADDR,
+	KEY_MAC_DADDR,
 };
 
 static struct ulogd_key mac2str_inp[] = {
@@ -45,22 +74,48 @@ static struct ulogd_key mac2str_inp[] = {
 		.flags = ULOGD_RETF_NONE,
 		.name = "raw.mac",
 	},
-	[KEY_RAW_MACLEN] = { 
-		.type = ULOGD_RET_UINT16, 
-		.flags = ULOGD_RETF_NONE, 
-		.name = "raw.mac_len", 
+	[KEY_RAW_MACLEN] = {
+		.type = ULOGD_RET_UINT16,
+		.flags = ULOGD_RETF_NONE,
+		.name = "raw.mac_len",
 	},
 
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
 
+static int parse_header(struct ulogd_key *ret, unsigned char *mac, int hwlen, int type)
+{
+	char *mac_str = NULL;
+	char *buf_cur = NULL;
+	mac_str = calloc(hwlen/sizeof(char)*3, sizeof(char));
+	buf_cur = mac_str;
+	int i;
+
+	if (mac_str == NULL)
+		return ULOGD_IRET_ERR;
+
+	for (i = 0; i < hwlen; i++)
+		buf_cur += sprintf(buf_cur, "%02x%c", mac[i],
+				i == hwlen - 1 ? 0 : ':');
+
+	ret[type].u.value.ptr = mac_str;
+	ret[type].flags |= ULOGD_RETF_VALID;
+
+	return ULOGD_IRET_OK;
+}
+
 static int interp_mac2str(struct ulogd_pluginstance *pi)
 {
 	struct ulogd_key *ret = pi->output.keys;
@@ -69,24 +124,48 @@ static int interp_mac2str(struct ulogd_pluginstance *pi)
 	if (pp_is_valid(inp, KEY_RAW_MAC)) {
 		unsigned char *mac = (unsigned char *) GET_VALUE(inp, KEY_RAW_MAC).ptr;
 		int len = GET_VALUE(inp, KEY_RAW_MACLEN).ui16;
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
+		int hwlen = pi->config_kset->ces[MAC2STR_LEN].u.value;
+		int retp;
+
+		if (hwlen) {
+			if (len < hwlen)
+				return ULOGD_IRET_ERR;
+		} else {
+			hwlen = len;
+		}
+
+		switch (pi->config_kset->ces[MAC2STR_TYPE].u.value) {
+		case MAC2STR_ONLY_SMAC:
+			retp = parse_header(ret, mac, hwlen, KEY_MAC_SADDR);
+			if (retp != ULOGD_IRET_OK)
+				return retp;
+			break;
+		case MAC2STR_FULL_MAC:
+			retp = parse_header(ret, mac, hwlen, KEY_MAC_DADDR);
+			if (retp != ULOGD_IRET_OK)
+				return retp;
+			retp = parse_header(ret, mac + hwlen, hwlen, KEY_MAC_SADDR);
+			if (retp != ULOGD_IRET_OK)
+				return retp;
+			break;
+		default:
+			break;
+		}
 	}
 
 	return ULOGD_IRET_OK;
 }
 
+static int configure(struct ulogd_pluginstance *upi,
+		     struct ulogd_pluginstance_stack *stack)
+{
+	ulogd_log(ULOGD_DEBUG, "parsing config file section `%s', "
+		  "plugin `%s'\n", upi->id, upi->plugin->name);
+
+	config_parse_file(upi->id, upi->config_kset);
+	return 0;
+}
+
 static struct ulogd_plugin mac2str_pluging = {
 	.name = "MAC2STR",
 	.input = {
@@ -100,6 +179,8 @@ static struct ulogd_plugin mac2str_pluging = {
 		.type = ULOGD_DTYPE_PACKET,
 		},
 	.interp = &interp_mac2str,
+	.config_kset = &libulog_kset,
+	.configure = &configure,
 	.version = ULOGD_VERSION,
 };
 
diff --git a/ulogd.conf.in b/ulogd.conf.in
index a32234d..c7714ee 100644
--- a/ulogd.conf.in
+++ b/ulogd.conf.in
@@ -188,3 +188,12 @@ sync = 1
 
 [mark1]
 mark = 1
+
+[mac2str1]
+# datatype:
+#  * Set to 0 for NFLOG version with saddr log only
+#  * set to 1 for ULOG and NFLOG version with full header log
+datatype = 0
+# Set hwaddrlen to length of hardware address (default 6 for ethernet)
+#hwaddrlen = 6
+
-- 
1.5.5.3

