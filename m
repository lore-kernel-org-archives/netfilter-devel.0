From: Peter Warasin <peter-k8AlXt1uIdjQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/5] Adds AF_BRIDGE and ARP header
	interpreter to BASE plugin
Date: Mon, 11 Feb 2008 23:07:55 +0100
Message-ID: <20080211221056.242019648@endian.com>
References: <20080211220753.796791654@endian.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Peter Warasin <peter-k8AlXt1uIdjQT0dZR+AlfA@public.gmane.org>,
	ebtables-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: netfilter-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <ebtables-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline; filename=ulogd2-PF_BRIDGE.patch
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/ebtables-devel>,
	<mailto:ebtables-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=ebtables-devel>
List-Post: <mailto:ebtables-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:ebtables-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/ebtables-devel>,
	<mailto:ebtables-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Sender: ebtables-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Errors-To: ebtables-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: netfilter-devel.vger.kernel.org

This patch adds an AF_BRIDGE interpreter to
ulogd_raw2packet_BASE plugin, which allows to log
packets coming from ebtables.
It also adds an ARP header decoder.

Signed-off-by: Peter Warasin <peter-k8AlXt1uIdjQT0dZR+AlfA@public.gmane.org>

---
 filter/raw2packet/ulogd_raw2packet_BASE.c |  127 +++++++++++++++++++++++++++++-
 1 file changed, 125 insertions(+), 2 deletions(-)

Index: ulogd2/filter/raw2packet/ulogd_raw2packet_BASE.c
===================================================================
--- ulogd2.orig/filter/raw2packet/ulogd_raw2packet_BASE.c	2008-02-11 22:13:27.000000000 +0100
+++ ulogd2/filter/raw2packet/ulogd_raw2packet_BASE.c	2008-02-11 22:20:05.000000000 +0100
@@ -10,6 +10,7 @@
  * 	o UDP header
  * 	o ICMP header
  * 	o AH/ESP header
+ *      o ARP header
  *
  * (C) 2000-2005 by Harald Welte <laforge-TgoAw6mPHtdg9hUCZPvPmw@public.gmane.org>
  *
@@ -42,11 +43,13 @@
 #include <netinet/udp.h>
 #include <ulogd/ulogd.h>
 #include <ulogd/ipfix_protocol.h>
+#include <netinet/if_ether.h>
 
 enum input_keys {
 	INKEY_RAW_PCKT,
 	INKEY_RAW_PCKTLEN,
 	INKEY_OOB_FAMILY,
+	INKEY_OOB_PROTOCOL,
 };
 
 enum output_keys {
@@ -101,6 +104,14 @@
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
@@ -455,7 +466,46 @@
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
+		.type = ULOGD_RET_RAW,
+		.flags = ULOGD_RETF_NONE,
+		.name = "arp.saddr",
+	},
+	[KEY_ARP_THA] = {
+		.type = ULOGD_RET_RAW,
+		.flags = ULOGD_RETF_NONE,
+		.name = "arp.dhwaddr",
+	},
+	[KEY_ARP_TPA] = {
+		.type = ULOGD_RET_RAW,
+		.flags = ULOGD_RETF_NONE,
+		.name = "arp.daddr",
+	},
 };
 
 /***********************************************************************
@@ -825,16 +875,84 @@
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
+	ret[KEY_ARP_SPA].u.value.ptr = &arph->arp_spa;
+	SET_VALID(ret[KEY_ARP_SPA]);
+
+	ret[KEY_ARP_THA].u.value.ptr = &arph->arp_tha;
+	SET_VALID(ret[KEY_ARP_THA]);
+	ret[KEY_ARP_TPA].u.value.ptr = &arph->arp_tpa;
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
@@ -859,7 +977,12 @@
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

-- 

-------------------------------------------------------------------------
This SF.net email is sponsored by: Microsoft
Defy all challenges. Microsoft(R) Visual Studio 2008.
http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
