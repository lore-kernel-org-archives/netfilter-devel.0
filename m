From: Peter Warasin <peter@endian.com>
Subject: [PATCHv2 4/5] adds AF_BRIDGE support to IP2STR
Date: Thu, 14 Feb 2008 00:06:37 +0100
Message-ID: <47B377FD.3040608@endian.com>
References: <20080211220753.796791654@endian.com> <20080211221056.846673328@endian.com> <20080212211538.GB13507@bayen.regit.org> <47B2D0CB.3020707@endian.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060701040901060300070600"
To: Eric Leblond <eric@inl.fr>, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from solaria.endian.it ([80.190.199.145]:47797 "EHLO
	solaria.endian.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394AbYBMXGs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Feb 2008 18:06:48 -0500
In-Reply-To: <47B2D0CB.3020707@endian.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060701040901060300070600
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Eric

Here is the corrected patch.

peter


--------------060701040901060300070600
Content-Type: text/x-patch;
 name="ulogd2-PF_BRIDGE-IP2STR.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ulogd2-PF_BRIDGE-IP2STR.patch"

adds AF_BRIDGE support to IP2STR

This patch make the ip address string converter AF_BRIDGE
compatible and add ip address ARP keys in order to make
them also convert.

Signed-off-by: Peter Warasin <peter@endian.com>

---
 filter/ulogd_filter_IP2STR.c |   74 +++++++++++++++++++++++++++++++------------
 1 file changed, 54 insertions(+), 20 deletions(-)

Index: ulogd2/filter/ulogd_filter_IP2STR.c
===================================================================
--- ulogd2.orig/filter/ulogd_filter_IP2STR.c	2008-02-11 22:44:47.000000000 +0100
+++ ulogd2/filter/ulogd_filter_IP2STR.c	2008-02-11 22:53:42.000000000 +0100
@@ -27,11 +27,13 @@
 #include <string.h>
 #include <arpa/inet.h>
 #include <ulogd/ulogd.h>
+#include <netinet/if_ether.h>
 
 #define IPADDR_LENGTH 128
 
 enum input_keys {
 	KEY_OOB_FAMILY,
+	KEY_OOB_PROTOCOL,
 	KEY_IP_SADDR,
 	START_KEY = KEY_IP_SADDR,
 	KEY_IP_DADDR,
@@ -39,7 +41,9 @@
 	KEY_ORIG_IP_DADDR,
 	KEY_REPLY_IP_SADDR,
 	KEY_REPLY_IP_DADDR,
-	MAX_KEY = KEY_REPLY_IP_DADDR,
+	KEY_ARP_SPA,
+	KEY_ARP_TPA,
+	MAX_KEY = KEY_ARP_TPA,
 };
 
 static struct ulogd_key ip2str_inp[] = {
@@ -48,6 +52,11 @@
 		.flags = ULOGD_RETF_NONE,
 		.name = "oob.family",
 	},
+	[KEY_OOB_PROTOCOL] = {
+		.type = ULOGD_RET_UINT16,
+		.flags = ULOGD_RETF_NONE,
+		.name = "oob.protocol",
+	},
 	[KEY_IP_SADDR] = {
 		.type = ULOGD_RET_IPADDR,
 		.flags = ULOGD_RETF_NONE|ULOGD_KEYF_OPTIONAL,
@@ -78,6 +87,16 @@
 		.flags	= ULOGD_RETF_NONE|ULOGD_KEYF_OPTIONAL,
 		.name	= "reply.ip.daddr",
 	},
+	[KEY_ARP_SPA] = {
+		.type = ULOGD_RET_IPADDR,
+		.flags = ULOGD_RETF_NONE,
+		.name = "arp.saddr",
+	},
+	[KEY_ARP_TPA] = {
+		.type = ULOGD_RET_IPADDR,
+		.flags = ULOGD_RETF_NONE,
+		.name = "arp.daddr",
+	},
 };
 
 static struct ulogd_key ip2str_keys[] = {
@@ -111,26 +130,41 @@
 		.flags = ULOGD_RETF_FREE,
 		.name = "reply.ip.daddr.str",
 	},
+	{
+		.type = ULOGD_RET_STRING,
+		.flags = ULOGD_RETF_FREE,
+		.name = "arp.saddr.str",
+	},
+	{
+		.type = ULOGD_RET_STRING,
+		.flags = ULOGD_RETF_FREE,
+		.name = "arp.daddr.str",
+	},
 };
 
-static char *ip2str(struct ulogd_key* inp, int index, char family)
+static char *ip2str(struct ulogd_key *inp, int index, int protocol)
 {
 	char tmp[IPADDR_LENGTH];
-	switch (family) {
-		case AF_INET6:
-			inet_ntop(AF_INET6,
-					&GET_VALUE(inp, index).ptr,
-					tmp, sizeof(tmp));
-			break;
-		case AF_INET:
-			inet_ntop(AF_INET,
-					&GET_VALUE(inp, index).ui32,
-					tmp, sizeof(tmp));
-			break;
-		default:
-			/* TODO error handling */
-			ulogd_log(ULOGD_NOTICE, "Unknown protocol family\n");
-			return NULL;
+	switch (protocol) {
+	case ETH_P_IPV6:
+		inet_ntop(AF_INET6,
+			  &GET_VALUE(inp, index).ptr,
+			  tmp, sizeof(tmp));
+		break;
+	case ETH_P_IP:
+		inet_ntop(AF_INET,
+			  &GET_VALUE(inp, index).ui32,
+			  tmp, sizeof(tmp));
+		break;
+	case ETH_P_ARP:
+		inet_ntop(AF_INET,
+			  &GET_VALUE(inp, index).ptr,
+			  tmp, sizeof(tmp));
+		break;
+	default:
+		/* TODO error handling */
+		ulogd_log(ULOGD_NOTICE, "Unknown protocol\n");
+		return NULL;
 	}
 	return strdup(tmp);
 }
@@ -140,13 +174,13 @@
 	struct ulogd_key *ret = pi->output.keys;
 	struct ulogd_key *inp = pi->input.keys;
 	int i;
-	int oob_family = GET_VALUE(inp, KEY_OOB_FAMILY).ui8;
+	int oob_protocol = GET_VALUE(inp, KEY_OOB_PROTOCOL).ui16;
 
 	/* Iter on all addr fields */
 	for(i = START_KEY; i < MAX_KEY; i++) {
 		if (pp_is_valid(inp, i)) {
-			ret[i-1].u.value.ptr = ip2str(inp, i, oob_family);
-			ret[i-1].flags |= ULOGD_RETF_VALID;
+			ret[i-START_KEY].u.value.ptr = ip2str(inp, i, oob_protocol);
+			ret[i-START_KEY].flags |= ULOGD_RETF_VALID;
 		}
 	}
 

--------------060701040901060300070600--
