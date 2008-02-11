From: Peter Warasin <peter@endian.com>
Subject: [PATCH 1/5] Adds input keys enumeration
Date: Mon, 11 Feb 2008 23:07:54 +0100
Message-ID: <20080211221055.928104246@endian.com>
References: <20080211220753.796791654@endian.com>
Cc: ebtables-devel@lists.sourceforge.net,
	Peter Warasin <peter@endian.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from solaria.endian.it ([80.190.199.145]:42230 "EHLO
	solaria.endian.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756586AbYBKWK7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Feb 2008 17:10:59 -0500
Content-Disposition: inline; filename=filter-raw2packet-usekeys.patch
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Adds input key enumeration in order to address the fields
with symbols instead of numbers.
Shortens the lines by the use of GET_VALUE()

Signed-off-by: Peter Warasin <peter@endian.com>

---
 filter/raw2packet/ulogd_raw2packet_BASE.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

Index: ulogd2/filter/raw2packet/ulogd_raw2packet_BASE.c
===================================================================
--- ulogd2.orig/filter/raw2packet/ulogd_raw2packet_BASE.c	2008-02-11 22:03:19.000000000 +0100
+++ ulogd2/filter/raw2packet/ulogd_raw2packet_BASE.c	2008-02-11 22:04:15.000000000 +0100
@@ -43,6 +43,12 @@
 #include <ulogd/ulogd.h>
 #include <ulogd/ipfix_protocol.h>
 
+enum input_keys {
+	INKEY_RAW_PCKT,
+	INKEY_RAW_PCKTLEN,
+	INKEY_OOB_FAMILY,
+};
+
 enum output_keys {
 	KEY_IP_SADDR,
 	KEY_IP_DADDR,
@@ -633,7 +639,8 @@
 static int _interp_iphdr(struct ulogd_pluginstance *pi, u_int32_t len)
 {
 	struct ulogd_key *ret = pi->output.keys;
-	struct iphdr *iph = pi->input.keys[0].u.source->u.value.ptr;
+	struct iphdr *iph =
+		GET_VALUE(pi->input.keys, INKEY_RAW_PCKT).ptr;
 	void *nexthdr = (u_int32_t *)iph + iph->ihl;
 
 	if (len < sizeof(struct iphdr) || len <= iph->ihl * 4)
@@ -702,7 +709,8 @@
 static int _interp_ipv6hdr(struct ulogd_pluginstance *pi, u_int32_t len)
 {
 	struct ulogd_key *ret = pi->output.keys;
-	struct ip6_hdr *ipv6h = pi->input.keys[0].u.source->u.value.ptr;
+	struct ip6_hdr *ipv6h =
+		GET_VALUE(pi->input.keys, INKEY_RAW_PCKT).ptr;
 	unsigned int ptr, hdrlen = 0;
 	u_int8_t curhdr;
 	int fragment = 0;
@@ -819,8 +827,8 @@
 
 static int _interp_pkt(struct ulogd_pluginstance *pi)
 {
-	u_int32_t len = pi->input.keys[1].u.source->u.value.ui32;
-	u_int8_t family = pi->input.keys[2].u.source->u.value.ui8;
+	u_int32_t len = GET_VALUE(pi->input.keys, INKEY_RAW_PCKTLEN).ui32;
+	u_int8_t family = GET_VALUE(pi->input.keys, INKEY_OOB_FAMILY).ui8;
 
 	switch (family) {
 	case AF_INET:

-- 
