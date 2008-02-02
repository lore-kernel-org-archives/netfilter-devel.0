From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 03/34]  Use an enum to clarify code.
Date: Sat,  2 Feb 2008 22:23:58 +0100
Message-ID: <12019874701613-git-send-email-eric@inl.fr>
References: <1201987469575-git-send-email-eric@inl.fr>
 <1201987469368-git-send-email-eric@inl.fr>
 <12019874692227-git-send-email-eric@inl.fr>
Cc: Eric leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:46045 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762318AbYBBWQU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Feb 2008 17:16:20 -0500
In-Reply-To: <12019874692227-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Eric leblond <eric@inl.fr>

This patch clarifies code which will be modified in next patch.

Signed-off-by: Eric leblond <eric@inl.fr>
---
:100644 100644 aa354d4... 1d0b9e9... M	util/printflow.c
 util/printflow.c |   43 ++++++++++++++++++++++++++++---------------
 1 files changed, 28 insertions(+), 15 deletions(-)

diff --git a/util/printflow.c b/util/printflow.c
index aa354d4..1d0b9e9 100644
--- a/util/printflow.c
+++ b/util/printflow.c
@@ -28,6 +28,19 @@
 #include <ulogd/ulogd.h>
 #include <ulogd/printflow.h>
 
+enum printflow_fields {
+	PRINTFLOW_IP_SADDR = 0,
+	PRINTFLOW_IP_DADDR,
+	PRINTFLOW_IP_PROTOCOL,
+	PRINTFLOW_L4_SPORT,
+	PRINTFLOW_L4_DPORT,
+	PRINTFLOW_RAW_PKTLEN,
+	PRINTFLOW_RAW_PKTCOUNT,
+	PRINTFLOW_ICMP_CODE,
+	PRINTFLOW_ICMP_TYPE,
+	PRINTFLOW_DIR,
+};
+
 struct ulogd_key printflow_keys[] = {
 	{
 		.type = ULOGD_RET_IPADDR,
@@ -94,38 +107,38 @@ int printflow_print(struct ulogd_key *res, char *buf)
 {
 	char *buf_cur = buf;
 
-	if (pp_is_valid(res, 9))
+	if (pp_is_valid(res, PRINTFLOW_DIR))
 		buf_cur += sprintf(buf_cur, "DIR=%s ",
-				GET_VALUE(res, 9).b ? "REPLY" : "ORIG ");
+				GET_VALUE(res, PRINTFLOW_DIR).b ? "REPLY" : "ORIG ");
 
-	if (pp_is_valid(res, 0))
+	if (pp_is_valid(res, PRINTFLOW_IP_SADDR))
 		buf_cur += sprintf(buf_cur, "SRC=%s ", inet_ntoa(
 				(struct in_addr) {htonl(GET_VALUE(res, 0).ui32)}));
 
-	if (pp_is_valid(res, 1))
+	if (pp_is_valid(res, PRINTFLOW_IP_DADDR))
 		buf_cur += sprintf(buf_cur, "DST=%s ", inet_ntoa(
 				(struct in_addr) {htonl(GET_VALUE(res, 1).ui32)}));
 
-	if (!pp_is_valid(res, 2))
+	if (!pp_is_valid(res, PRINTFLOW_IP_PROTOCOL))
 		goto out;
 
-	switch (GET_VALUE(res, 2).ui8) {
+	switch (GET_VALUE(res, PRINTFLOW_IP_PROTOCOL).ui8) {
 	case IPPROTO_TCP:
 		buf_cur += sprintf(buf_cur, "PROTO=TCP ");
-		pp_print(buf_cur, "SPT", res, 3, ui16);
-		pp_print(buf_cur, "DPT", res, 4, ui16);
+		pp_print(buf_cur, "SPT", res, PRINTFLOW_L4_SPORT, ui16);
+		pp_print(buf_cur, "DPT", res, PRINTFLOW_L4_DPORT, ui16);
 		break;
 
 	case IPPROTO_UDP:
 		buf_cur += sprintf(buf_cur, "PROTO=UDP ");
-		pp_print(buf_cur, "SPT", res, 3, ui16);
-		pp_print(buf_cur, "DPT", res, 4, ui16);
+		pp_print(buf_cur, "SPT", res, PRINTFLOW_L4_SPORT, ui16);
+		pp_print(buf_cur, "DPT", res, PRINTFLOW_L4_DPORT, ui16);
 		break;
 
 	case IPPROTO_ICMP:
 		buf_cur += sprintf(buf_cur, "PROTO=ICMP ");
-		pp_print(buf_cur, "TYPE", res, 7, ui8);
-		pp_print(buf_cur, "CODE", res, 8, ui8);
+		pp_print(buf_cur, "TYPE", res, PRINTFLOW_ICMP_CODE, ui8);
+		pp_print(buf_cur, "CODE", res, PRINTFLOW_ICMP_TYPE, ui8);
 		break;
 
 	case IPPROTO_ESP:
@@ -137,13 +150,13 @@ int printflow_print(struct ulogd_key *res, char *buf)
 		break;
 
 	default:
-		pp_print(buf_cur, "PROTO", res, 2, ui8);
+		pp_print(buf_cur, "PROTO", res, PRINTFLOW_IP_PROTOCOL, ui8);
 		break;
 	}
 
 out:
-	pp_print(buf_cur, "PKTS", res, 6, ui32);
-	pp_print(buf_cur, "BYTES", res, 5, ui32);
+	pp_print(buf_cur, "PKTS", res, PRINTFLOW_RAW_PKTCOUNT, ui32);
+	pp_print(buf_cur, "BYTES", res, PRINTFLOW_RAW_PKTLEN, ui32);
 	strcat(buf_cur, "\n");
 
 	return 0;
-- 
1.5.2.5

