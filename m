From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 04/34]  Adapt printflow for one conntrack entry per line format.
Date: Sat,  2 Feb 2008 22:23:59 +0100
Message-ID: <12019874702005-git-send-email-eric@inl.fr>
References: <1201987469575-git-send-email-eric@inl.fr>
 <1201987469368-git-send-email-eric@inl.fr>
 <12019874692227-git-send-email-eric@inl.fr>
 <12019874701613-git-send-email-eric@inl.fr>
Cc: Eric leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:46049 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762304AbYBBWQa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Feb 2008 17:16:30 -0500
In-Reply-To: <12019874701613-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Eric leblond <eric@inl.fr>

This patch update the printflow output module to be able to print a
whole conntrack entry on a single line.

Signed-off-by: Eric leblond <eric@inl.fr>
---
:100644 100644 7343a23... 979f673... M	include/ulogd/printflow.h
:100644 100644 1d0b9e9... d803633... M	util/printflow.c
 include/ulogd/printflow.h |    2 +-
 util/printflow.c          |  161 ++++++++++++++++++++++++++++++++++-----------
 2 files changed, 123 insertions(+), 40 deletions(-)

diff --git a/include/ulogd/printflow.h b/include/ulogd/printflow.h
index 7343a23..979f673 100644
--- a/include/ulogd/printflow.h
+++ b/include/ulogd/printflow.h
@@ -1,7 +1,7 @@
 #ifndef _PRINTFLOW_H
 #define _PRINTFLOW_H
 
-#define FLOW_IDS 	10
+#define FLOW_IDS 16
 extern struct ulogd_key printflow_keys[FLOW_IDS];
 
 int printflow_print(struct ulogd_key *res, char *buf);
diff --git a/util/printflow.c b/util/printflow.c
index 1d0b9e9..d803633 100644
--- a/util/printflow.c
+++ b/util/printflow.c
@@ -29,68 +29,104 @@
 #include <ulogd/printflow.h>
 
 enum printflow_fields {
-	PRINTFLOW_IP_SADDR = 0,
-	PRINTFLOW_IP_DADDR,
-	PRINTFLOW_IP_PROTOCOL,
-	PRINTFLOW_L4_SPORT,
-	PRINTFLOW_L4_DPORT,
-	PRINTFLOW_RAW_PKTLEN,
-	PRINTFLOW_RAW_PKTCOUNT,
+	PRINTFLOW_ORIG_IP_SADDR = 0,
+	PRINTFLOW_ORIG_IP_DADDR,
+	PRINTFLOW_ORIG_IP_PROTOCOL,
+	PRINTFLOW_ORIG_L4_SPORT,
+	PRINTFLOW_ORIG_L4_DPORT,
+	PRINTFLOW_ORIG_RAW_PKTLEN,
+	PRINTFLOW_ORIG_RAW_PKTCOUNT,
+	PRINTFLOW_REPLY_IP_SADDR,
+	PRINTFLOW_REPLY_IP_DADDR,
+	PRINTFLOW_REPLY_IP_PROTOCOL,
+	PRINTFLOW_REPLY_L4_SPORT,
+	PRINTFLOW_REPLY_L4_DPORT,
+	PRINTFLOW_REPLY_RAW_PKTLEN,
+	PRINTFLOW_REPLY_RAW_PKTCOUNT,
 	PRINTFLOW_ICMP_CODE,
 	PRINTFLOW_ICMP_TYPE,
-	PRINTFLOW_DIR,
 };
 
-struct ulogd_key printflow_keys[] = {
+struct ulogd_key printflow_keys[FLOW_IDS] = {
 	{
 		.type = ULOGD_RET_IPADDR,
 		.flags = ULOGD_RETF_NONE,
-		.name = "ip.saddr",
+		.name = "orig.ip.saddr",
 	},
 	{
 		.type = ULOGD_RET_IPADDR,
 		.flags = ULOGD_RETF_NONE,
-		.name = "ip.daddr",
+		.name = "orig.ip.daddr",
 	},
 	{
 		.type = ULOGD_RET_UINT8,
 		.flags = ULOGD_RETF_NONE,
-		.name = "ip.protocol",
+		.name = "orig.ip.protocol",
 	},
 	{
 		.type = ULOGD_RET_UINT16,
 		.flags = ULOGD_RETF_NONE,
-		.name = "l4.sport",
+		.name = "orig.l4.sport",
 	},
 	{
 		.type = ULOGD_RET_UINT16,
 		.flags = ULOGD_RETF_NONE,
-		.name = "l4.dport",
+		.name = "orig.l4.dport",
 	},
 	{
 		.type = ULOGD_RET_UINT32,
 		.flags = ULOGD_RETF_NONE,
-		.name = "raw.pktlen",
+		.name = "orig.raw.pktlen",
 	},
 	{
 		.type = ULOGD_RET_UINT32,
 		.flags = ULOGD_RETF_NONE,
-		.name = "raw.pktcount",
+		.name = "orig.raw.pktcount",
+	},
+	{
+		.type = ULOGD_RET_IPADDR,
+		.flags = ULOGD_RETF_NONE,
+		.name = "reply.ip.saddr",
+	},
+	{
+		.type = ULOGD_RET_IPADDR,
+		.flags = ULOGD_RETF_NONE,
+		.name = "reply.ip.daddr",
 	},
 	{
 		.type = ULOGD_RET_UINT8,
 		.flags = ULOGD_RETF_NONE,
-		.name = "icmp.code",
+		.name = "reply.ip.protocol",
+	},
+	{
+		.type = ULOGD_RET_UINT16,
+		.flags = ULOGD_RETF_NONE,
+		.name = "reply.l4.sport",
+	},
+	{
+		.type = ULOGD_RET_UINT16,
+		.flags = ULOGD_RETF_NONE,
+		.name = "reply.l4.dport",
+	},
+	{
+		.type = ULOGD_RET_UINT32,
+		.flags = ULOGD_RETF_NONE,
+		.name = "reply.raw.pktlen",
+	},
+	{
+		.type = ULOGD_RET_UINT32,
+		.flags = ULOGD_RETF_NONE,
+		.name = "reply.raw.pktcount",
 	},
 	{
 		.type = ULOGD_RET_UINT8,
 		.flags = ULOGD_RETF_NONE,
-		.name = "icmp.type",
+		.name = "icmp.code",
 	},
 	{
-		.type = ULOGD_RET_BOOL,
+		.type = ULOGD_RET_UINT8,
 		.flags = ULOGD_RETF_NONE,
-		.name = "dir",
+		.name = "icmp.type",
 	},
 };
 int printflow_keys_num = sizeof(printflow_keys)/sizeof(*printflow_keys);
@@ -107,32 +143,30 @@ int printflow_print(struct ulogd_key *res, char *buf)
 {
 	char *buf_cur = buf;
 
-	if (pp_is_valid(res, PRINTFLOW_DIR))
-		buf_cur += sprintf(buf_cur, "DIR=%s ",
-				GET_VALUE(res, PRINTFLOW_DIR).b ? "REPLY" : "ORIG ");
+	buf_cur += sprintf(buf_cur, "ORIG: ");
 
-	if (pp_is_valid(res, PRINTFLOW_IP_SADDR))
+	if (pp_is_valid(res, PRINTFLOW_ORIG_IP_SADDR))
 		buf_cur += sprintf(buf_cur, "SRC=%s ", inet_ntoa(
-				(struct in_addr) {htonl(GET_VALUE(res, 0).ui32)}));
+				(struct in_addr) {htonl(GET_VALUE(res, PRINTFLOW_ORIG_IP_SADDR).ui32)}));
 
-	if (pp_is_valid(res, PRINTFLOW_IP_DADDR))
+	if (pp_is_valid(res, PRINTFLOW_ORIG_IP_DADDR))
 		buf_cur += sprintf(buf_cur, "DST=%s ", inet_ntoa(
-				(struct in_addr) {htonl(GET_VALUE(res, 1).ui32)}));
+				(struct in_addr) {htonl(GET_VALUE(res, PRINTFLOW_ORIG_IP_DADDR).ui32)}));
 
-	if (!pp_is_valid(res, PRINTFLOW_IP_PROTOCOL))
-		goto out;
+	if (!pp_is_valid(res, PRINTFLOW_ORIG_IP_PROTOCOL))
+		goto orig_out;
 
-	switch (GET_VALUE(res, PRINTFLOW_IP_PROTOCOL).ui8) {
+	switch (GET_VALUE(res, PRINTFLOW_ORIG_IP_PROTOCOL).ui8) {
 	case IPPROTO_TCP:
 		buf_cur += sprintf(buf_cur, "PROTO=TCP ");
-		pp_print(buf_cur, "SPT", res, PRINTFLOW_L4_SPORT, ui16);
-		pp_print(buf_cur, "DPT", res, PRINTFLOW_L4_DPORT, ui16);
+		pp_print(buf_cur, "SPT", res, PRINTFLOW_ORIG_L4_SPORT, ui16);
+		pp_print(buf_cur, "DPT", res, PRINTFLOW_ORIG_L4_DPORT, ui16);
 		break;
 
 	case IPPROTO_UDP:
 		buf_cur += sprintf(buf_cur, "PROTO=UDP ");
-		pp_print(buf_cur, "SPT", res, PRINTFLOW_L4_SPORT, ui16);
-		pp_print(buf_cur, "DPT", res, PRINTFLOW_L4_DPORT, ui16);
+		pp_print(buf_cur, "SPT", res, PRINTFLOW_ORIG_L4_SPORT, ui16);
+		pp_print(buf_cur, "DPT", res, PRINTFLOW_ORIG_L4_DPORT, ui16);
 		break;
 
 	case IPPROTO_ICMP:
@@ -150,14 +184,63 @@ int printflow_print(struct ulogd_key *res, char *buf)
 		break;
 
 	default:
-		pp_print(buf_cur, "PROTO", res, PRINTFLOW_IP_PROTOCOL, ui8);
+		pp_print(buf_cur, "PROTO", res, PRINTFLOW_ORIG_IP_PROTOCOL, ui8);
 		break;
 	}
 
-out:
-	pp_print(buf_cur, "PKTS", res, PRINTFLOW_RAW_PKTCOUNT, ui32);
-	pp_print(buf_cur, "BYTES", res, PRINTFLOW_RAW_PKTLEN, ui32);
-	strcat(buf_cur, "\n");
+orig_out:
+	pp_print(buf_cur, "PKTS", res, PRINTFLOW_ORIG_RAW_PKTCOUNT, ui32);
+	pp_print(buf_cur, "BYTES", res, PRINTFLOW_ORIG_RAW_PKTLEN, ui32);
+
+	buf_cur += sprintf(buf_cur, ", REPLY: ");
+
+	if (pp_is_valid(res, PRINTFLOW_REPLY_IP_SADDR))
+		buf_cur += sprintf(buf_cur, "SRC=%s ", inet_ntoa(
+				(struct in_addr) {htonl(GET_VALUE(res, PRINTFLOW_REPLY_IP_SADDR).ui32)}));
+
+	if (pp_is_valid(res, PRINTFLOW_REPLY_IP_DADDR))
+		buf_cur += sprintf(buf_cur, "DST=%s ", inet_ntoa(
+				(struct in_addr) {htonl(GET_VALUE(res, PRINTFLOW_REPLY_IP_DADDR).ui32)}));
+
+	if (!pp_is_valid(res, PRINTFLOW_REPLY_IP_PROTOCOL))
+		goto reply_out;
+
+	switch (GET_VALUE(res, PRINTFLOW_REPLY_IP_PROTOCOL).ui8) {
+	case IPPROTO_TCP:
+		buf_cur += sprintf(buf_cur, "PROTO=TCP ");
+		pp_print(buf_cur, "SPT", res, PRINTFLOW_REPLY_L4_SPORT, ui16);
+		pp_print(buf_cur, "DPT", res, PRINTFLOW_REPLY_L4_DPORT, ui16);
+		break;
+
+	case IPPROTO_UDP:
+		buf_cur += sprintf(buf_cur, "PROTO=UDP ");
+		pp_print(buf_cur, "SPT", res, PRINTFLOW_REPLY_L4_SPORT, ui16);
+		pp_print(buf_cur, "DPT", res, PRINTFLOW_REPLY_L4_DPORT, ui16);
+		break;
+
+	case IPPROTO_ICMP:
+		buf_cur += sprintf(buf_cur, "PROTO=ICMP ");
+		pp_print(buf_cur, "TYPE", res, PRINTFLOW_ICMP_CODE, ui8);
+		pp_print(buf_cur, "CODE", res, PRINTFLOW_ICMP_TYPE, ui8);
+		break;
+
+	case IPPROTO_ESP:
+		buf_cur += sprintf(buf_cur, "PROTO=ESP ");
+		break;
+
+	case IPPROTO_AH:
+		buf_cur += sprintf(buf_cur, "PROTO=AH ");
+		break;
+
+	default:
+		pp_print(buf_cur, "PROTO", res, PRINTFLOW_REPLY_IP_PROTOCOL, ui8);
+		break;
+	}
 
+reply_out:
+	pp_print(buf_cur, "PKTS", res, PRINTFLOW_REPLY_RAW_PKTCOUNT, ui32);
+	pp_print(buf_cur, "BYTES", res, PRINTFLOW_REPLY_RAW_PKTLEN, ui32);
+
+	strcat(buf_cur, "\n");
 	return 0;
 }
-- 
1.5.2.5

