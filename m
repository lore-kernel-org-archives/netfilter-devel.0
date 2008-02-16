From: Peter Warasin <peter@endian.com>
Subject: [PATCHv5 2/5] Adds AF_BRIDGE and ARP header interpreter to      BASE
 plugin
Date: Sat, 16 Feb 2008 01:25:30 +0100
Message-ID: <47B62D7A.3010906@endian.com>
References: <20080211220753.796791654@endian.com>    <20080211221056.242019648@endian.com> <47B377A2.6080309@endian.com> <4279.80.214.249.17.1202974766.squirrel@mail.inl.fr> <47B42760.5080603@endian.com> <47B45D0F.8070008@netfilter.org> <47B5CB03.2070903@endian.com> <47B5CE66.4090107@endian.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070106090405060002020602"
Cc: Eric Leblond <eric@inl.fr>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from solaria.endian.it ([80.190.199.145]:52783 "EHLO
	solaria.endian.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758205AbYBPAZr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Feb 2008 19:25:47 -0500
In-Reply-To: <47B5CE66.4090107@endian.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070106090405060002020602
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi

Ok, now it is fixed and works for me
Made some confusion because i changed that type.
Please don't slap me :)

During tests i found another bug in IP2STR. The for loop goes only
until MAX_KEY-1, but should include MAX_KEY otherwise it will not print
out the last key (in this case the destination ip address of the arp 
packet).

It clashes with my patch 4, so i will resend that patch, too,
including the bugfix.

peter


--------------070106090405060002020602
Content-Type: text/x-patch;
 name="ulogd2-PF_BRIDGE.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ulogd2-PF_BRIDGE.patch"

Adds AF_BRIDGE and ARP header interpreter to BASE plugin

This patch adds an AF_BRIDGE interpreter to
ulogd_raw2packet_BASE plugin, which allows to log
packets coming from ebtables.
It also adds an ARP header decoder.

Signed-off-by: Peter Warasin <peter@endian.com>

---
 filter/raw2packet/ulogd_raw2packet_BASE.c |  132 +++++++++++++++++++++++++++++-
 1 file changed, 130 insertions(+), 2 deletions(-)

Index: ulogd2/filter/raw2packet/ulogd_raw2packet_BASE.c
===================================================================
--- ulogd2.orig/filter/raw2packet/ulogd_raw2packet_BASE.c	2008-02-16 01:12:59.000000000 +0100
+++ ulogd2/filter/raw2packet/ulogd_raw2packet_BASE.c	2008-02-16 01:14:27.000000000 +0100
@@ -10,6 +10,7 @@
  * 	o UDP header
  * 	o ICMP header
  * 	o AH/ESP header
+ *      o ARP header
  *
  * (C) 2000-2005 by Harald Welte <laforge@gnumonks.org>
  *
@@ -42,11 +43,14 @@
 #include <netinet/udp.h>
 #include <ulogd/ulogd.h>
 #include <ulogd/ipfix_protocol.h>
+#include <netinet/if_ether.h>
+#include <string.h>
 
 enum input_keys {
 	INKEY_RAW_PCKT,
 	INKEY_RAW_PCKTLEN,
 	INKEY_OOB_FAMILY,
+	INKEY_OOB_PROTOCOL,
 };
 
 enum output_keys {
@@ -101,6 +105,14 @@
 	KEY_ICMPV6_ECHOSEQ,
 	KEY_ICMPV6_CSUM,
 	KEY_AHESP_SPI,
+	KEY_OOB_PROTOCOL,
+	KEY_ARP_HTYPE,
+	KEY_ARP_PTYPE,
+	KEY_ARP_OPCODE,
+	KEY_ARP_SHA,
+	KEY_ARP_SPA,
+	KEY_ARP_THA,
+	KEY_ARP_TPA,
 };
 
 static struct ulogd_key iphdr_rets[] = {
@@ -455,7 +467,46 @@
 		.flags = ULOGD_RETF_NONE,
 		.name = "ahesp.spi",
 	},
-
+	[KEY_OOB_PROTOCOL] = {
+		.type = ULOGD_RET_UINT16,
+		.flags = ULOGD_RETF_NONE,
+		.name = "oob.protocol",
+	},
+	[KEY_ARP_HTYPE] = {
+		.type = ULOGD_RET_UINT16,
+		.flags = ULOGD_RETF_NONE,
+		.name = "arp.hwtype",
+	},
+	[KEY_ARP_PTYPE] = {
+		.type = ULOGD_RET_UINT16,
+		.flags = ULOGD_RETF_NONE,
+		.name = "arp.protocoltype",
+	},
+	[KEY_ARP_OPCODE] = {
+		.type = ULOGD_RET_UINT16,
+		.flags = ULOGD_RETF_NONE,
+		.name = "arp.operation",
+	},
+	[KEY_ARP_SHA] = {
+		.type = ULOGD_RET_RAW,
+		.flags = ULOGD_RETF_NONE,
+		.name = "arp.shwaddr",
+	},
+	[KEY_ARP_SPA] = {
+		.type = ULOGD_RET_IPADDR,
+		.flags = ULOGD_RETF_NONE,
+		.name = "arp.saddr",
+	},
+	[KEY_ARP_THA] = {
+		.type = ULOGD_RET_RAW,
+		.flags = ULOGD_RETF_NONE,
+		.name = "arp.dhwaddr",
+	},
+	[KEY_ARP_TPA] = {
+		.type = ULOGD_RET_IPADDR,
+		.flags = ULOGD_RETF_NONE,
+		.name = "arp.daddr",
+	},
 };
 
 /***********************************************************************
@@ -825,16 +876,88 @@
 	return 0;
 }
 
+/***********************************************************************
+ * 			ARP HEADER
+ ***********************************************************************/
+static int _interp_arp(struct ulogd_pluginstance *pi, u_int32_t len)
+{
+	struct ulogd_key *ret = pi->output.keys;
+	const struct ether_arp *arph =
+		GET_VALUE(pi->input.keys, INKEY_RAW_PCKT).ptr;
+
+	if (len < sizeof(struct ether_arp))
+		return 0;
+
+	ret[KEY_ARP_HTYPE].u.value.ui16 = ntohs(arph->arp_hrd);
+	SET_VALID(ret[KEY_ARP_HTYPE]);
+	ret[KEY_ARP_PTYPE].u.value.ui16 = ntohs(arph->arp_pro);
+	SET_VALID(ret[KEY_ARP_PTYPE]);
+	ret[KEY_ARP_OPCODE].u.value.ui16 = ntohs(arph->arp_op);
+	SET_VALID(ret[KEY_ARP_OPCODE]);
+
+	ret[KEY_ARP_SHA].u.value.ptr = &arph->arp_sha;
+	SET_VALID(ret[KEY_ARP_SHA]);
+
+	memcpy(&ret[KEY_ARP_SPA].u.value.ui32, &arph->arp_spa,
+	       sizeof(u_int32_t));
+	SET_VALID(ret[KEY_ARP_SPA]);
+
+	ret[KEY_ARP_THA].u.value.ptr = &arph->arp_tha;
+	SET_VALID(ret[KEY_ARP_THA]);
+
+	memcpy(&ret[KEY_ARP_TPA].u.value.ui32, &arph->arp_tpa,
+	       sizeof(u_int32_t));
+	SET_VALID(ret[KEY_ARP_TPA]);
+
+	return 0;
+}
+
+/***********************************************************************
+ * 			ETHER HEADER
+ ***********************************************************************/
+
+static int _interp_bridge(struct ulogd_pluginstance *pi, u_int32_t len)
+{
+	struct ulogd_key *ret = pi->output.keys;
+	const struct sk_buff *skb =
+		GET_VALUE(pi->input.keys, INKEY_RAW_PCKT).ptr;
+	const u_int16_t proto =
+		GET_VALUE(pi->input.keys, INKEY_OOB_PROTOCOL).ui16;
+
+	switch (proto) {
+	case ETH_P_IP:
+		_interp_iphdr(pi, len);
+		break;
+	case ETH_P_IPV6:
+		_interp_ipv6hdr(pi, len);
+		break;
+	case ETH_P_ARP:
+		_interp_arp(pi, len);
+		break;
+	/* ETH_P_8021Q ?? others? */
+	};
+
+	return 0;
+}
+
+
 static int _interp_pkt(struct ulogd_pluginstance *pi)
 {
 	u_int32_t len = GET_VALUE(pi->input.keys, INKEY_RAW_PCKTLEN).ui32;
 	u_int8_t family = GET_VALUE(pi->input.keys, INKEY_OOB_FAMILY).ui8;
+	struct ulogd_key *ret = pi->output.keys;
+
+	ret[KEY_OOB_PROTOCOL].u.value.ui16 =
+		GET_VALUE(pi->input.keys, INKEY_OOB_PROTOCOL).ui16;
+	SET_VALID(ret[KEY_OOB_PROTOCOL]);
 
 	switch (family) {
 	case AF_INET:
 		return _interp_iphdr(pi, len);
 	case AF_INET6:
 		return _interp_ipv6hdr(pi, len);
+	case AF_BRIDGE:
+		return _interp_bridge(pi, len);
 	}
 	return 0;
 }
@@ -859,7 +982,12 @@
 	{
 		.type = ULOGD_RET_UINT8,
 		.name = "oob.family",
-	}
+	},
+	{
+		.type = ULOGD_RET_UINT16,
+		.name = "oob.protocol",
+	},
+
 };
 
 static struct ulogd_plugin base_plugin = {

--------------070106090405060002020602--
