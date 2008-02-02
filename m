From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 17/34]  Suppress key relative to IPv6 address.
Date: Sat,  2 Feb 2008 22:24:12 +0100
Message-ID: <1201987471474-git-send-email-eric@inl.fr>
References: <1201987469575-git-send-email-eric@inl.fr>
 <1201987469368-git-send-email-eric@inl.fr>
 <12019874692227-git-send-email-eric@inl.fr>
 <12019874701613-git-send-email-eric@inl.fr>
 <12019874702005-git-send-email-eric@inl.fr>
 <12019874703998-git-send-email-eric@inl.fr>
 <12019874701589-git-send-email-eric@inl.fr>
 <12019874701366-git-send-email-eric@inl.fr>
 <12019874704144-git-send-email-eric@inl.fr>
 <12019874703136-git-send-email-eric@inl.fr>
 <12019874701552-git-send-email-eric@inl.fr>
 <12019874701370-git-send-email-eric@inl.fr>
 <12019874702349-git-send-email-eric@inl.fr>
 <12019874703504-git-send-email-eric@inl.fr>
 <12019874704067-git-send-email-eric@inl.fr>
 <12019874703897-git-send-email-eric@inl.fr>
 <12019874712066-git-send-email-eric@inl.fr>
Cc: Eric leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:46043 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762300AbYBBWQQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Feb 2008 17:16:16 -0500
In-Reply-To: <12019874712066-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Eric leblond <eric@inl.fr>

This patch suppress key relative to IPv6 address because IPv4 and IPv6 can 
be stored in the same key.

Signed-off-by: Eric leblond <eric@inl.fr>
---
:100644 100644 4420507... e837c62... M	filter/raw2packet/ulogd_raw2packet_BASE.c
:100644 100644 3db2862... ae56946... M	include/ulogd/printpkt.h
:100644 100644 d43f1fd... 465b224... M	ulogd.conf.in
:100644 100644 7719cae... 6606824... M	util/printpkt.c
 filter/raw2packet/ulogd_raw2packet_BASE.c |   28 ++++------------------------
 include/ulogd/printpkt.h                  |    2 --
 ulogd.conf.in                             |   10 +++++++++-
 util/printpkt.c                           |   26 ++++++++------------------
 4 files changed, 21 insertions(+), 45 deletions(-)

diff --git a/filter/raw2packet/ulogd_raw2packet_BASE.c b/filter/raw2packet/ulogd_raw2packet_BASE.c
index 4420507..e837c62 100644
--- a/filter/raw2packet/ulogd_raw2packet_BASE.c
+++ b/filter/raw2packet/ulogd_raw2packet_BASE.c
@@ -54,8 +54,6 @@ enum output_keys {
 	KEY_IP_CSUM,
 	KEY_IP_ID,
 	KEY_IP_FRAGOFF,
-	KEY_IP6_SADDR,
-	KEY_IP6_DADDR,
 	KEY_IP6_PAYLOAD_LEN,
 	KEY_IP6_PRIORITY,
 	KEY_IP6_FLOWLABEL,
@@ -186,24 +184,6 @@ static struct ulogd_key iphdr_rets[] = {
 			.field_id = IPFIX_fragmentOffsetIPv4,
 		},
 	},
-	[KEY_IP6_SADDR] = {
-		.type = ULOGD_RET_RAW,
-		.flags = ULOGD_RETF_NONE,
-		.name = "ip6.saddr",
-		.ipfix = {
-			.vendor = IPFIX_VENDOR_IETF,
-			.field_id = IPFIX_sourceIPv6Address,
-		},
-	},
-	[KEY_IP6_DADDR] = {
-		.type = ULOGD_RET_RAW,
-		.flags = ULOGD_RETF_NONE,
-		.name = "ip6.daddr",
-		.ipfix = {
-			.vendor = IPFIX_VENDOR_IETF,
-			.field_id = IPFIX_destinationIPv6Address,
-		},
-	},
 	[KEY_IP6_PAYLOAD_LEN] = {
 		.type = ULOGD_RET_UINT16,
 		.flags = ULOGD_RETF_NONE,
@@ -730,10 +710,10 @@ static int _interp_ipv6hdr(struct ulogd_pluginstance *pi, u_int32_t len)
 	if (len < sizeof(struct ip6_hdr))
 		return 0;
 
-	ret[KEY_IP6_SADDR].u.value.ptr = &ipv6h->ip6_src;
-	ret[KEY_IP6_SADDR].flags |= ULOGD_RETF_VALID;
-	ret[KEY_IP6_DADDR].u.value.ptr = &ipv6h->ip6_dst;
-	ret[KEY_IP6_DADDR].flags |= ULOGD_RETF_VALID;
+	ret[KEY_IP_SADDR].u.value.ptr = &ipv6h->ip6_src;
+	ret[KEY_IP_SADDR].flags |= ULOGD_RETF_VALID;
+	ret[KEY_IP_DADDR].u.value.ptr = &ipv6h->ip6_dst;
+	ret[KEY_IP_DADDR].flags |= ULOGD_RETF_VALID;
 	ret[KEY_IP6_PAYLOAD_LEN].u.value.ui16 = ntohs(ipv6h->ip6_plen);
 	ret[KEY_IP6_PAYLOAD_LEN].flags |= ULOGD_RETF_VALID;
 	ret[KEY_IP6_PRIORITY].u.value.ui8 = ntohl(ipv6h->ip6_flow & 0x0ff00000) >> 20;
diff --git a/include/ulogd/printpkt.h b/include/ulogd/printpkt.h
index 3db2862..ae56946 100644
--- a/include/ulogd/printpkt.h
+++ b/include/ulogd/printpkt.h
@@ -17,8 +17,6 @@ enum pkt_keys {
 	KEY_IP_ID,
 	KEY_IP_FRAGOFF,
 	KEY_IP_PROTOCOL,
-	KEY_IP6_SADDR,
-	KEY_IP6_DADDR,
 	KEY_IP6_PAYLOAD_LEN,
 	KEY_IP6_PRIORITY,
 	KEY_IP6_HOPLIMIT,
diff --git a/ulogd.conf.in b/ulogd.conf.in
index d43f1fd..465b224 100644
--- a/ulogd.conf.in
+++ b/ulogd.conf.in
@@ -35,6 +35,7 @@ bufsize=150000
 plugin="@libdir@/ulogd/ulogd_inppkt_NFLOG.so"
 plugin="@libdir@/ulogd/ulogd_inpflow_NFCT.so"
 plugin="@libdir@/ulogd/ulogd_filter_IFINDEX.so"
+plugin="@libdir@/ulogd/ulogd_filter_IP2STR.so"
 plugin="@libdir@/ulogd/ulogd_filter_PRINTPKT.so"
 plugin="@libdir@/ulogd/ulogd_filter_PRINTFLOW.so"
 plugin="@libdir@/ulogd/ulogd_output_LOGEMU.so"
@@ -42,7 +43,10 @@ plugin="@libdir@/ulogd/ulogd_output_OPRINT.so"
 plugin="@libdir@/ulogd/ulogd_raw2packet_BASE.so"
 
 # this is a stack for packet-based logging via LOGEMU
-#stack=log1:NFLOG,base1:BASE,ifi1:IFINDEX,print1:PRINTPKT,emu1:LOGEMU
+#stack=log1:NFLOG,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,print1:PRINTPKT,emu1:LOGEMU
+
+# this is a stack for IPv6 packet-based logging via LOGEMU
+#stack=log2:NFLOG,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,print1:PRINTPKT,emu1:LOGEMU
 
 # this is a stack for ULOG packet-based logging via LOGEMU
 #stack=ulog1:ULOG,base1:BASE,print1:PRINTPKT,emu1:LOGEMU
@@ -59,6 +63,10 @@ plugin="@libdir@/ulogd/ulogd_raw2packet_BASE.so"
 # netlink multicast group (the same as the iptables --ulog-nlgroup param)
 group=0
 
+[log2]
+group=1
+addressfamily=10
+
 [ulog1]
 nlgroup=1
 
diff --git a/util/printpkt.c b/util/printpkt.c
index 7719cae..6606824 100644
--- a/util/printpkt.c
+++ b/util/printpkt.c
@@ -45,16 +45,14 @@ struct ulogd_key printpkt_keys[] = {
 	[KEY_OOB_OUT]		= { .name = "oob.out", },
 	[KEY_RAW_MAC]		= { .name = "raw.mac", },
 	[KEY_RAW_MACLEN]	= { .name = "raw.mac_len", },
-	[KEY_IP_SADDR]		= { .name = "ip.saddr", },
-	[KEY_IP_DADDR]		= { .name = "ip.daddr", },
+	[KEY_IP_SADDR]		= { .name = "ip.saddr.str", },
+	[KEY_IP_DADDR]		= { .name = "ip.daddr.str", },
 	[KEY_IP_TOTLEN]		= { .name = "ip.totlen", },
 	[KEY_IP_TOS]		= { .name = "ip.tos", },
 	[KEY_IP_TTL]		= { .name = "ip.ttl", },
 	[KEY_IP_ID]		= { .name = "ip.id", },
 	[KEY_IP_FRAGOFF]	= { .name = "ip.fragoff", },
 	[KEY_IP_PROTOCOL]	= { .name = "ip.protocol", },
-	[KEY_IP6_SADDR]		= { .name = "ip6.saddr", },
-	[KEY_IP6_DADDR]		= { .name = "ip6.daddr", },
 	[KEY_IP6_PAYLOAD_LEN]	= { .name = "ip6.payload_len" },
 	[KEY_IP6_PRIORITY]	= { .name = "ip6.priority" },
 	[KEY_IP6_HOPLIMIT]	= { .name = "ip6.hoplimit" },
@@ -182,15 +180,11 @@ static int printpkt_ipv4(struct ulogd_key *res, char *buf)
 
 	if (pp_is_valid(res, KEY_IP_SADDR))
 		buf_cur += sprintf(buf_cur, "SRC=%s ",
-				   inet_ntop(AF_INET,
-				   	     &GET_VALUE(res, KEY_IP_SADDR).ui32,
-					     tmp, sizeof(tmp)));
+				   GET_VALUE(res, KEY_IP_SADDR).ptr);
 
 	if (pp_is_valid(res, KEY_IP_DADDR))
 		buf_cur += sprintf(buf_cur, "DST=%s ",
-				   inet_ntop(AF_INET,
-				   	     &GET_VALUE(res, KEY_IP_DADDR).ui32,
-					     tmp, sizeof(tmp)));
+				   GET_VALUE(res, KEY_IP_DADDR).ptr);
 
 	/* FIXME: add pp_is_valid calls to remainder of file */
 	buf_cur += sprintf(buf_cur,"LEN=%u TOS=%02X PREC=0x%02X TTL=%u ID=%u ", 
@@ -271,17 +265,13 @@ static int printpkt_ipv6(struct ulogd_key *res, char *buf)
 	char *buf_cur = buf;
 	char tmp[INET6_ADDRSTRLEN];
 
-	if (pp_is_valid(res, KEY_IP6_SADDR))
+	if (pp_is_valid(res, KEY_IP_SADDR))
 		buf_cur += sprintf(buf_cur, "SRC=%s ",
-				   inet_ntop(AF_INET6,
-				   	     GET_VALUE(res, KEY_IP6_SADDR).ptr,
-					     tmp, sizeof(tmp)));
+				   GET_VALUE(res, KEY_IP_SADDR).ptr);
 
-	if (pp_is_valid(res, KEY_IP6_DADDR))
+	if (pp_is_valid(res, KEY_IP_DADDR))
 		buf_cur += sprintf(buf_cur, "DST=%s ",
-				   inet_ntop(AF_INET6,
-				   	     GET_VALUE(res, KEY_IP6_DADDR).ptr,
-					     tmp, sizeof(tmp)));
+				   GET_VALUE(res, KEY_IP_DADDR).ptr);
 
 	if (pp_is_valid(res, KEY_IP6_PAYLOAD_LEN))
 		buf_cur += sprintf(buf_cur, "LEN=%Zu ",
-- 
1.5.2.5

