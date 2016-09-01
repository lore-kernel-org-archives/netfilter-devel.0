From: Kevin Cernekee <cernekee@chromium.org>
Subject: [RFC 3/3] conntrackd: cthelper: ssdp: Track UPnP eventing
Date: Wed, 31 Aug 2016 21:27:55 -0700
Message-ID: <1472704075-38007-3-git-send-email-cernekee@chromium.org>
References: <1472704075-38007-1-git-send-email-cernekee@chromium.org>
Cc: ashley.hughes@blueyonder.co.uk, netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:35120 "EHLO
        mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751167AbcIAE3Y (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Sep 2016 00:29:24 -0400
Received: by mail-pa0-f48.google.com with SMTP id hb8so25456360pac.2
        for <netfilter-devel@vger.kernel.org>; Wed, 31 Aug 2016 21:29:24 -0700 (PDT)
In-Reply-To: <1472704075-38007-1-git-send-email-cernekee@chromium.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The UPnP Device Architecture spec provides a way for devices to connect
back to control points, called "Eventing" (chapter 4).  This sequence can
look something like:

1) Outbound multicast M-SEARCH packet (dst: 1900/udp)
 - Create expectation for unicast reply from <any host> to source port

2) Inbound unicast reply (there may be several of these from different devices)
 - Find the device's URL, e.g.
   LOCATION: http://192.168.1.123:1400/xml/device_description.xml
 - Create expectation to track connections to this host:port (tcp)

3) Outbound connection to device's web server (there will be several of these)
 - Watch for a SUBSCRIBE request
 - Find the control point's callback URL, e.g.
   CALLBACK: <http://192.168.1.124:3500/notify>
 - Create expectation to open up inbound connections to this host:port

4) Inbound connection to control point's web server
 - Once this is complete, the subscription should work

Add the necessary code to add expectations for each of these connections
and rewrite the IP in the CALLBACK URL.

Signed-off-by: Kevin Cernekee <cernekee@chromium.org>
---


This needs more testing on my end, so I'm posting it as an RFC to solicit
preliminary feedback.


 doc/helper/conntrackd.conf |  10 +-
 src/helpers/ssdp.c         | 400 ++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 403 insertions(+), 7 deletions(-)

diff --git a/doc/helper/conntrackd.conf b/doc/helper/conntrackd.conf
index 5c07509..ec24e2a 100644
--- a/doc/helper/conntrackd.conf
+++ b/doc/helper/conntrackd.conf
@@ -74,7 +74,15 @@ Helper {
 		QueueNum 5
 		QueueLen 10240
 		Policy ssdp {
-			ExpectMax 1
+			ExpectMax 8
+			ExpectTimeout 300
+		}
+	}
+	Type ssdp inet tcp {
+		QueueNum 5
+		QueueLen 10240
+		Policy ssdp {
+			ExpectMax 8
 			ExpectTimeout 300
 		}
 	}
diff --git a/src/helpers/ssdp.c b/src/helpers/ssdp.c
index bc41087..d9c9a5a 100644
--- a/src/helpers/ssdp.c
+++ b/src/helpers/ssdp.c
@@ -1,5 +1,5 @@
 /*
- * SSDP connection tracking helper
+ * SSDP/UPnP connection tracking helper
  * (SSDP = Simple Service Discovery Protocol)
  * For documentation about SSDP see
  * http://en.wikipedia.org/wiki/Simple_Service_Discovery_Protocol
@@ -8,6 +8,18 @@
  * Based on the SSDP conntrack helper (nf_conntrack_ssdp.c),
  * :http://marc.info/?t=132945775100001&r=1&w=2
  *  (C) 2012 Ian Pilcher <arequipeno@gmail.com>
+ * Copyright (C) 2016 Google Inc.
+ *
+ * This requires Linux 3.12 or higher.  Usage:
+ *
+ *     nfct add helper ssdp inet udp
+ *     nfct add helper ssdp inet tcp
+ *     iptables -t raw -A OUTPUT -p udp --dport 1900 -j CT --helper ssdp
+ *     iptables -t raw -A PREROUTING -p udp --dport 1900 -j CT --helper ssdp
+ *
+ * This helper supports SNAT when used in conjunction with a daemon that
+ * forwards SSDP broadcasts/replies between interfaces, e.g.
+ * https://chromium.googlesource.com/chromiumos/platform2/+/master/arc-networkd/multicast_forwarder.h
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -19,8 +31,10 @@
 #include "myct.h"
 #include "log.h"
 #include <errno.h>
+#include <stdlib.h>
 #include <arpa/inet.h>
 #include <netinet/ip.h>
+#include <netinet/tcp.h>
 #include <netinet/udp.h>
 #include <libmnl/libmnl.h>
 #include <libnetfilter_conntrack/libnetfilter_conntrack.h>
@@ -36,8 +50,94 @@
 #define SSDP_M_SEARCH		"M-SEARCH"
 #define SSDP_M_SEARCH_SIZE	(sizeof SSDP_M_SEARCH - 1)
 
-static int ssdp_helper_cb(struct pkt_buff *pkt, uint32_t protoff,
-			  struct myct *myct, uint32_t ctinfo)
+/* So, this packet has hit the connection tracking matching code.
+   Mangle it, and change the expectation to match the new version. */
+static unsigned int nf_nat_ssdp(struct pkt_buff *pkt,
+				int ctinfo,
+				unsigned int matchoff,
+				unsigned int matchlen,
+				struct nf_conntrack *ct,
+				struct nf_expect *exp)
+{
+	union nfct_attr_grp_addr newip;
+	uint16_t port;
+	int dir = CTINFO2DIR(ctinfo);
+	char buffer[sizeof("255.255.255.255:65535")];
+	unsigned int buflen;
+	const struct nf_conntrack *expected;
+	struct nf_conntrack *nat_tuple;
+	uint16_t initial_port;
+
+	/* Connection will come from wherever this packet goes, hence !dir */
+	cthelper_get_addr_dst(ct, !dir, &newip);
+
+	expected = nfexp_get_attr(exp, ATTR_EXP_EXPECTED);
+
+	nat_tuple = nfct_new();
+	if (nat_tuple == NULL)
+		return NF_ACCEPT;
+
+	initial_port = nfct_get_attr_u16(expected, ATTR_PORT_DST);
+
+	nfexp_set_attr_u32(exp, ATTR_EXP_NAT_DIR, !dir);
+
+	/* libnetfilter_conntrack needs this */
+	nfct_set_attr_u8(nat_tuple, ATTR_L3PROTO, AF_INET);
+	nfct_set_attr_u32(nat_tuple, ATTR_IPV4_SRC, 0);
+	nfct_set_attr_u32(nat_tuple, ATTR_IPV4_DST, 0);
+	nfct_set_attr_u8(nat_tuple, ATTR_L4PROTO,
+			 nfct_get_attr_u8(ct, ATTR_L4PROTO));
+	nfct_set_attr_u16(nat_tuple, ATTR_PORT_DST, 0);
+
+	/* When you see the packet, we need to NAT it the same as the
+	   this one. */
+	nfexp_set_attr(exp, ATTR_EXP_FN, "nat-follow-master");
+
+	/* Try to get same port: if not, try to change it. */
+	for (port = ntohs(initial_port); port != 0; port++) {
+		int ret;
+
+		nfct_set_attr_u16(nat_tuple, ATTR_PORT_SRC, htons(port));
+		nfexp_set_attr(exp, ATTR_EXP_NAT_TUPLE, nat_tuple);
+
+		ret = cthelper_add_expect(exp);
+		if (ret == 0)
+			break;
+		else if (ret != -EBUSY) {
+			port = 0;
+			break;
+		}
+	}
+
+	if (port == 0)
+		return NF_DROP;
+
+	/* Only the SUBSCRIBE request contains an IP string that needs to be
+	   mangled. */
+	if (!matchoff)
+		return NF_ACCEPT;
+
+	buflen = snprintf(buffer, sizeof(buffer),
+				"%u.%u.%u.%u:%u",
+                                ((unsigned char *)&newip.ip)[0],
+                                ((unsigned char *)&newip.ip)[1],
+                                ((unsigned char *)&newip.ip)[2],
+                                ((unsigned char *)&newip.ip)[3], port);
+	if (!buflen)
+		goto out;
+
+	if (!nfq_tcp_mangle_ipv4(pkt, matchoff, matchlen, buffer, buflen))
+		goto out;
+
+	return NF_ACCEPT;
+
+out:
+	cthelper_del_expect(exp);
+	return NF_DROP;
+}
+
+static int handle_ssdp_new(struct pkt_buff *pkt, uint32_t protoff,
+			   struct myct *myct, uint32_t ctinfo)
 {
 	int ret = NF_ACCEPT;
 	union nfct_attr_grp_addr daddr, saddr, taddr;
@@ -109,12 +209,285 @@ static int ssdp_helper_cb(struct pkt_buff *pkt, uint32_t protoff,
 		nfexp_destroy(exp);
 		return NF_DROP;
 	}
+	nfexp_set_attr(exp, ATTR_EXP_HELPER_NAME, "ssdp");
+	if (nfct_get_attr_u32(myct->ct, ATTR_STATUS) & IPS_SRC_NAT)
+		return nf_nat_ssdp(pkt, ctinfo, 0, 0, myct->ct, exp);
+
 	myct->exp = exp;
 
 	return ret;
 }
 
-static struct ctd_helper ssdp_helper = {
+static int find_hdr(const char *name, const uint8_t *data, int data_len,
+		    char *val, int val_len, const uint8_t **pos)
+{
+	int name_len = strlen(name);
+	int i;
+
+	while (1) {
+		if (data_len < name_len + 2)
+			return -1;
+
+		if (strncasecmp(name, (char *)data, name_len) == 0)
+			break;
+
+		for (i = 0; ; i++) {
+			if (i >= data_len - 1)
+				return -1;
+			if (data[i] == '\r' && data[i+1] == '\n')
+				break;
+		}
+
+		data_len -= i+2;
+		data += i+2;
+	}
+
+	data_len -= name_len;
+	data += name_len;
+	if (pos)
+		*pos = data;
+
+	for (i = 0; ; i++, val_len--) {
+		if (!val_len)
+			return -1;
+		if (*data == '\r') {
+			*val = 0;
+			return 0;
+		}
+		*(val++) = *(data++);
+	}
+}
+
+static int parse_url(const char *url,
+		     uint8_t l3proto,
+		     union nfct_attr_grp_addr *addr,
+		     uint16_t *port,
+		     size_t *match_offset,
+		     size_t *match_len)
+{
+	const char *start = url, *end;
+	size_t ip_len;
+
+	if (strncasecmp(url, "http://[", 8) == 0) {
+		char buf[64] = {0};
+
+		if (l3proto != AF_INET6) {
+			pr_debug("conntrack_ssdp: IPv6 URL in IPv4 SSDP reply\n");
+			return -1;
+		}
+
+		url += 8;
+
+		end = strchr(url, ']');
+		if (!end) {
+			pr_debug("conntrack_ssdp: unterminated IPv6 address: '%s'\n", url);
+			return -1;
+		}
+
+		ip_len = end - url;
+		if (ip_len > sizeof(buf) - 1) {
+			pr_debug("conntrack_ssdp: IPv6 address too long: '%s'\n", url);
+			return -1;
+		}
+		strncpy(buf, url, ip_len);
+
+		if (inet_pton(AF_INET6, buf, addr) != 1) {
+			pr_debug("conntrack_ssdp: Error parsing IPv6 address: '%s'\n", buf);
+			return -1;
+		}
+	} else if (strncasecmp(url, "http://", 7) == 0) {
+		char buf[64] = {0};
+
+		if (l3proto != AF_INET) {
+			pr_debug("conntrack_ssdp: IPv4 URL in IPv6 SSDP reply\n");
+			return -1;
+		}
+
+		url += 7;
+		for (end = url; ; end++) {
+			if (*end != '.' && *end != '\0' &&
+			    (*end < '0' || *end > '9'))
+				break;
+		}
+
+		ip_len = end - url;
+		if (ip_len > sizeof(buf) - 1) {
+			pr_debug("conntrack_ssdp: IPv4 address too long: '%s'\n", url);
+			return -1;
+		}
+		strncpy(buf, url, ip_len);
+
+		if (inet_pton(AF_INET, buf, addr) != 1) {
+			pr_debug("conntrack_ssdp: Error parsing IPv4 address: '%s'\n", buf);
+			return -1;
+		}
+	} else {
+		pr_debug("conntrack_ssdp: header does not start with http://\n");
+		return -1;
+	}
+
+	if (match_offset)
+		*match_offset = url - start;
+
+	if (*end != ':') {
+		*port = htons(80);
+		if (match_len)
+			*match_len = ip_len;
+	} else {
+		char *endptr = NULL;
+		*port = htons(strtol(end + 1, &endptr, 10));
+		if (match_len)
+			*match_len = ip_len + endptr - end;;
+	}
+
+	return 0;
+}
+
+static int handle_ssdp_reply(struct pkt_buff *pkt, uint32_t protoff,
+			     struct myct *myct, uint32_t ctinfo)
+{
+	uint8_t *data = pktb_network_header(pkt);
+	size_t bytes_left = pktb_len(pkt);
+	char hdr_val[256];
+	union nfct_attr_grp_addr addr;
+	uint16_t port;
+	struct nf_expect *exp = NULL;
+
+	if (bytes_left < protoff + sizeof(struct udphdr)) {
+		pr_debug("conntrack_ssdp: Short packet\n");
+		return NF_ACCEPT;
+	}
+	bytes_left -= protoff + sizeof(struct udphdr);
+	data += protoff + sizeof(struct udphdr);
+
+	if (find_hdr("LOCATION: ", data, bytes_left,
+		     hdr_val, sizeof(hdr_val), NULL) < 0) {
+		pr_debug("conntrack_ssdp: No LOCATION header found\n");
+		return NF_ACCEPT;
+	}
+	pr_debug("conntrack_ssdp: found location URL `%s'\n", hdr_val);
+
+	if (parse_url(hdr_val, nfct_get_attr_u8(myct->ct, ATTR_L3PROTO),
+		      &addr, &port, NULL, NULL) < 0) {
+		pr_debug("conntrack_ssdp: Error parsing URL\n");
+		return NF_ACCEPT;
+	}
+
+	exp = nfexp_new();
+	if (cthelper_expect_init(exp,
+				 myct->ct,
+				 0 /* class */,
+				 NULL /* saddr */,
+				 &addr /* daddr */,
+				 IPPROTO_TCP,
+				 NULL /* sport */,
+				 &port /* dport */,
+				 NF_CT_EXPECT_PERMANENT /* flags */) < 0) {
+		pr_debug("conntrack_ssdp: Failed to init expectation\n");
+		nfexp_destroy(exp);
+		return NF_ACCEPT;
+	}
+
+	nfexp_set_attr(exp, ATTR_EXP_HELPER_NAME, "ssdp");
+	if (nfct_get_attr_u32(myct->ct, ATTR_STATUS) & IPS_SRC_NAT)
+		return nf_nat_ssdp(pkt, ctinfo, 0, 0, myct->ct, exp);
+
+	myct->exp = exp;
+	return NF_ACCEPT;
+}
+
+static int handle_http_request(struct pkt_buff *pkt, uint32_t protoff,
+			       struct myct *myct, uint32_t ctinfo)
+{
+	struct tcphdr *th;
+	unsigned int dataoff, datalen;
+	const uint8_t *data;
+	char hdr_val[256];
+	union nfct_attr_grp_addr cbaddr = {0}, daddr = {0}, saddr = {0};
+	uint16_t cbport;
+	struct nf_expect *exp = NULL;
+	const uint8_t *hdr_pos;
+	size_t ip_offset, ip_len;
+	int dir = CTINFO2DIR(ctinfo);
+
+	th = (struct tcphdr *) (pktb_network_header(pkt) + protoff);
+	dataoff = protoff + th->doff * 4;
+	datalen = pktb_len(pkt) - dataoff;
+	data = pktb_network_header(pkt) + dataoff;
+
+	if (datalen < 10 || strncmp((char *)data, "SUBSCRIBE ", 10) != 0)
+		return NF_ACCEPT;
+
+	if (find_hdr("CALLBACK: <", data, datalen,
+		     hdr_val, sizeof(hdr_val), &hdr_pos) < 0) {
+		pr_debug("conntrack_ssdp: No CALLBACK header found\n");
+		return NF_ACCEPT;
+	}
+	pr_debug("conntrack_ssdp: found callback URL `%s'\n", hdr_val);
+
+	if (parse_url(hdr_val, nfct_get_attr_u8(myct->ct, ATTR_L3PROTO),
+		      &cbaddr, &cbport, &ip_offset, &ip_len) < 0) {
+		pr_debug("conntrack_ssdp: Error parsing URL\n");
+		return NF_ACCEPT;
+	}
+
+	cthelper_get_addr_dst(myct->ct, !dir, &daddr);
+	cthelper_get_addr_src(myct->ct, dir, &saddr);
+
+	if (memcmp(&saddr, &cbaddr, sizeof(cbaddr)) != 0) {
+		pr_debug("conntrack_ssdp: Callback address belongs to another host\n");
+		return NF_ACCEPT;
+	}
+
+	cthelper_get_addr_src(myct->ct, !dir, &saddr);
+
+	exp = nfexp_new();
+	if (cthelper_expect_init(exp,
+				 myct->ct,
+				 0 /* class */,
+				 &saddr /* saddr */,
+				 &daddr /* daddr */,
+				 IPPROTO_TCP,
+				 NULL /* sport */,
+				 &cbport /* dport */,
+				 NF_CT_EXPECT_PERMANENT /* flags */) < 0) {
+		pr_debug("conntrack_ssdp: Failed to init expectation\n");
+		nfexp_destroy(exp);
+		return NF_ACCEPT;
+	}
+
+	if (nfct_get_attr_u32(myct->ct, ATTR_STATUS) & IPS_SRC_NAT) {
+		return nf_nat_ssdp(pkt, ctinfo,
+				   (hdr_pos - data) + ip_offset,
+				   ip_len, myct->ct, exp);
+	}
+
+	myct->exp = exp;
+	return NF_ACCEPT;
+}
+
+static int ssdp_helper_cb(struct pkt_buff *pkt, uint32_t protoff,
+			  struct myct *myct, uint32_t ctinfo)
+{
+	uint8_t proto;
+
+	if (ctinfo == IP_CT_NEW)
+		return handle_ssdp_new(pkt, protoff, myct, ctinfo);
+
+	proto = nfct_get_attr_u16(myct->ct, ATTR_ORIG_L4PROTO);
+	if (proto == IPPROTO_UDP)
+		return handle_ssdp_reply(pkt, protoff, myct, ctinfo);
+	else {
+		if (ctinfo == IP_CT_ESTABLISHED)
+			return handle_http_request(pkt, protoff, myct, ctinfo);
+		else
+			return NF_ACCEPT;
+	}
+
+	return NF_DROP;
+}
+
+static struct ctd_helper ssdp_helper_udp = {
 	.name		= "ssdp",
 	.l4proto	= IPPROTO_UDP,
 	.priv_data_len	= 0,
@@ -122,7 +495,21 @@ static struct ctd_helper ssdp_helper = {
 	.policy		= {
 		[0] = {
 			.name		= "ssdp",
-			.expect_max	= 1,
+			.expect_max	= 8,
+			.expect_timeout	= 5 * 60,
+		},
+	},
+};
+
+static struct ctd_helper ssdp_helper_tcp = {
+	.name		= "ssdp",
+	.l4proto	= IPPROTO_TCP,
+	.priv_data_len	= 0,
+	.cb		= ssdp_helper_cb,
+	.policy		= {
+		[0] = {
+			.name		= "ssdp",
+			.expect_max	= 8,
 			.expect_timeout	= 5 * 60,
 		},
 	},
@@ -130,5 +517,6 @@ static struct ctd_helper ssdp_helper = {
 
 static void __attribute__ ((constructor)) ssdp_init(void)
 {
-	helper_register(&ssdp_helper);
+	helper_register(&ssdp_helper_udp);
+	helper_register(&ssdp_helper_tcp);
 }
-- 
1.9.1

