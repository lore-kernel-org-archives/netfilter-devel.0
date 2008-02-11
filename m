From: Peter Warasin <peter@endian.com>
Subject: [PATCH 3/5] adds AF_BRIDGE support to PRINTPKT plugin
Date: Mon, 11 Feb 2008 23:07:56 +0100
Message-ID: <20080211221056.540287033@endian.com>
References: <20080211220753.796791654@endian.com>
Cc: ebtables-devel@lists.sourceforge.net,
	Peter Warasin <peter@endian.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from solaria.endian.it ([80.190.199.145]:42241 "EHLO
	solaria.endian.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757136AbYBKWK7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Feb 2008 17:10:59 -0500
Content-Disposition: inline; filename=ulogd2-PF_BRIDGE-printpkt.patch
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds support for AF_BRIDGE to
the PRINTPKT plugin, which allows to form
log lines for packets coming from ebtables.
Currently it supports IPv4, IPv6 and ARP.

Signed-off-by: Peter Warasin <peter@endian.com>

---
 include/ulogd/printpkt.h |    8 ++++
 util/printpkt.c          |   81 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 89 insertions(+)

Index: ulogd2/include/ulogd/printpkt.h
===================================================================
--- ulogd2.orig/include/ulogd/printpkt.h	2008-02-11 22:37:18.000000000 +0100
+++ ulogd2/include/ulogd/printpkt.h	2008-02-11 22:37:20.000000000 +0100
@@ -51,6 +51,14 @@
 	KEY_ICMPV6_ECHOID,
 	KEY_ICMPV6_ECHOSEQ,
 	KEY_AHESP_SPI,
+	KEY_OOB_PROTOCOL,
+	KEY_ARP_HTYPE,
+	KEY_ARP_PTYPE,
+	KEY_ARP_OPCODE,
+	KEY_ARP_SHA,
+	KEY_ARP_SPA,
+	KEY_ARP_THA,
+	KEY_ARP_TPA,
 	__PRINTPKT_KEYS
 };
 #define PRINTPKT_KEYS (__PRINTPKT_KEYS)
Index: ulogd2/util/printpkt.c
===================================================================
--- ulogd2.orig/util/printpkt.c	2008-02-11 22:37:18.000000000 +0100
+++ ulogd2/util/printpkt.c	2008-02-11 22:40:05.000000000 +0100
@@ -36,9 +36,11 @@
 #include <ulogd/ulogd.h>
 #include <ulogd/conffile.h>
 #include <ulogd/printpkt.h>
+#include <netinet/if_ether.h>
 
 struct ulogd_key printpkt_keys[] = {
 	[KEY_OOB_FAMILY]	= { .name = "oob.family", },
+	[KEY_OOB_PROTOCOL]	= { .name = "oob.protocol", },
 	[KEY_OOB_TIME_SEC]	= { .name = "oob.time.sec", },
 	[KEY_OOB_PREFIX]	= { .name = "oob.prefix", },
 	[KEY_OOB_IN]		= { .name = "oob.in", },
@@ -90,6 +92,14 @@
 	[KEY_ICMPV6_ECHOID]	= { .name = "icmpv6.echoid", },
 	[KEY_ICMPV6_ECHOSEQ]	= { .name = "icmpv6.echoseq", },
 	[KEY_AHESP_SPI]		= { .name = "ahesp.spi", },
+	[KEY_ARP_HTYPE]         = { .name = "arp.hwtype", },
+	[KEY_ARP_PTYPE]         = { .name = "arp.protocoltype", },
+	[KEY_ARP_OPCODE]        = { .name = "arp.operation", },
+	[KEY_ARP_SHA]           = { .name = "arp.shwaddr", },
+	[KEY_ARP_SPA]           = { .name = "arp.saddr.str", },
+	[KEY_ARP_THA]           = { .name = "arp.dhwaddr", },
+	[KEY_ARP_TPA]           = { .name = "arp.daddr.str", },
+
 };
 
 static int printpkt_proto(struct ulogd_key *res, char *buf, int protocol)
@@ -334,6 +344,74 @@
 	return buf_cur - buf;
 }
 
+int printpkt_arp(struct ulogd_key *res, char *buf)
+{
+	char *buf_cur = buf;
+	u_int16_t code = 0;
+	u_int8_t *mac;
+	char tmp[INET_ADDRSTRLEN];
+
+	if (pp_is_valid(res, KEY_ARP_SPA))
+		buf_cur += sprintf(buf_cur, "SRC=%s ",
+				   GET_VALUE(res, KEY_ARP_SPA).ptr);
+
+	if (pp_is_valid(res, KEY_ARP_TPA))
+		buf_cur += sprintf(buf_cur, "DST=%s ",
+				   GET_VALUE(res, KEY_ARP_TPA).ptr);
+
+	buf_cur += sprintf(buf_cur, "PROTO=ARP ");
+
+	if (pp_is_valid(res, KEY_ARP_OPCODE)) {
+		code = GET_VALUE(res, KEY_ARP_OPCODE).ui16;
+		switch (code) {
+		case ARPOP_REQUEST:
+			buf_cur += sprintf(buf_cur, "REQUEST ");
+			break;
+		case ARPOP_REPLY:
+			buf_cur += sprintf(buf_cur, "REPLY ");
+			break;
+		case ARPOP_NAK:
+			buf_cur += sprintf(buf_cur, "NAK ");
+			break;
+		default:
+			buf_cur += sprintf(buf_cur, "CODE=%u ", code);
+		}
+
+		if (pp_is_valid(res, KEY_ARP_SHA) && (code == ARPOP_REPLY)) {
+			mac = GET_VALUE(res, KEY_ARP_SHA).ptr;
+			buf_cur += sprintf(buf_cur, "REPLY_MAC="
+					   "%02x:%02x:%02x:%02x:%02x:%02x ",
+					   mac[0], mac[1], mac[2],
+					   mac[3], mac[4], mac[5]);
+		}
+	}
+
+	return buf_cur - buf;
+}
+
+
+int printpkt_bridge(struct ulogd_key *res, char *buf)
+{
+	char *buf_cur = buf;
+
+	switch (GET_VALUE(res, KEY_OOB_PROTOCOL).ui16) {
+	case ETH_P_IP:
+		buf_cur += printpkt_ipv4(res, buf_cur);
+		break;
+	case ETH_P_IPV6:
+		buf_cur += printpkt_ipv6(res, buf_cur);
+		break;
+	case ETH_P_ARP:
+		buf_cur += printpkt_arp(res, buf_cur);
+		break;
+	default:
+		buf_cur += sprintf(buf_cur, "PROTO=%u ",
+			   GET_VALUE(res, KEY_OOB_PROTOCOL).ui16);
+	}
+
+	return buf_cur - buf;
+}
+
 int printpkt_print(struct ulogd_key *res, char *buf)
 {
 	char *buf_cur = buf;
@@ -366,6 +444,9 @@
 	case AF_INET6:
 		buf_cur += printpkt_ipv6(res, buf_cur);
 		break;
+	case AF_BRIDGE:
+		buf_cur += printpkt_bridge(res, buf_cur);
+		break;
 	}
 
 	if (pp_is_valid(res, KEY_OOB_UID))

-- 
