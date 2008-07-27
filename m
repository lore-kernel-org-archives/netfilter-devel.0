From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD2 PATCH 05/11] Suppress some warnings in format string usage.
Date: Sun, 27 Jul 2008 15:51:20 +0200
Message-ID: <1217166686-28508-6-git-send-email-eric@inl.fr>
References: <20080723162746.GB31572@bayen.regit.org>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:43800 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751866AbYG0Nv3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 27 Jul 2008 09:51:29 -0400
In-Reply-To: <20080723162746.GB31572@bayen.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch cast to (char *) some (void *) to avoid a gcc warning in string
format parsing.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 output/ulogd_output_LOGEMU.c |    2 +-
 output/ulogd_output_NACCT.c  |    8 ++++----
 output/ulogd_output_SYSLOG.c |    2 +-
 util/db.c                    |    2 +-
 util/printflow.c             |    8 ++++----
 util/printpkt.c              |   12 ++++++------
 6 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/output/ulogd_output_LOGEMU.c b/output/ulogd_output_LOGEMU.c
index cab3b0c..edee86f 100644
--- a/output/ulogd_output_LOGEMU.c
+++ b/output/ulogd_output_LOGEMU.c
@@ -102,7 +102,7 @@ static int _output_logemu(struct ulogd_pluginstance *upi)
 			*tmp = '\0';
 
 		fprintf(li->of, "%.15s %s %s", timestr, hostname,
-				res[0].u.source->u.value.ptr);
+				(char *) res[0].u.source->u.value.ptr);
 
 		if (upi->config_kset->ces[1].u.value)
 			fflush(li->of);
diff --git a/output/ulogd_output_NACCT.c b/output/ulogd_output_NACCT.c
index 4897959..0ab2be4 100644
--- a/output/ulogd_output_NACCT.c
+++ b/output/ulogd_output_NACCT.c
@@ -130,9 +130,9 @@ nacct_interp(struct ulogd_pluginstance *pi)
 				 "%u\t%u\t%s\t%u\t%s\t%u\t%u\t%u",
 				 GET_VALUE(inp, KEY_FLOW_END).ui32,
 				 GET_VALUE(inp, KEY_IP_PROTO).ui8,
-				 GET_VALUE(inp, KEY_IP_SADDR).ptr,
+				 (char *) GET_VALUE(inp, KEY_IP_SADDR).ptr,
 				 GET_VALUE(inp, KEY_ICMP_TYPE).ui8,
-				 GET_VALUE(inp, KEY_IP_DADDR).ptr,
+				 (char *) GET_VALUE(inp, KEY_IP_DADDR).ptr,
 				 GET_VALUE(inp, KEY_ICMP_CODE).ui8,
 				 GET_VALUE(inp, KEY_RAW_PKTCNT).ui32,
 				 GET_VALUE(inp, KEY_RAW_PKTLEN).ui32);
@@ -141,9 +141,9 @@ nacct_interp(struct ulogd_pluginstance *pi)
 				 "%u\t%u\t%s\t%u\t%s\t%u\t%u\t%u",
 				 GET_VALUE(inp, KEY_FLOW_END).ui32,
 				 GET_VALUE(inp, KEY_IP_PROTO).ui8,
-				 GET_VALUE(inp, KEY_IP_SADDR).ptr,
+				 (char *) GET_VALUE(inp, KEY_IP_SADDR).ptr,
 				 GET_VALUE(inp, KEY_L4_SPORT).ui16,
-				 GET_VALUE(inp, KEY_IP_DADDR).ptr,
+				 (char *) GET_VALUE(inp, KEY_IP_DADDR).ptr,
 				 GET_VALUE(inp, KEY_L4_DPORT).ui16,
 				 GET_VALUE(inp, KEY_RAW_PKTCNT).ui32,
 				 GET_VALUE(inp, KEY_RAW_PKTLEN).ui32);
diff --git a/output/ulogd_output_SYSLOG.c b/output/ulogd_output_SYSLOG.c
index 8dd93f3..1812cb0 100644
--- a/output/ulogd_output_SYSLOG.c
+++ b/output/ulogd_output_SYSLOG.c
@@ -77,7 +77,7 @@ static int _output_syslog(struct ulogd_pluginstance *upi)
 
 	if (res[0].u.source->flags & ULOGD_RETF_VALID)
 		syslog(li->syslog_level | li->syslog_facility, "%s",
-				res[0].u.source->u.value.ptr);
+				(char *) res[0].u.source->u.value.ptr);
 
 	return ULOGD_IRET_OK;
 }
diff --git a/util/db.c b/util/db.c
index 8e9dde6..68dcc31 100644
--- a/util/db.c
+++ b/util/db.c
@@ -284,7 +284,7 @@ static int __interp_db(struct ulogd_pluginstance *upi)
 			sprintf(di->stmt_ins, "',");
 			break;
 		case ULOGD_RET_RAWSTR:
-			sprintf(di->stmt_ins, "%s,", res->u.value.ptr);
+			sprintf(di->stmt_ins, "%s,", (char *) res->u.value.ptr);
 			break;
 		case ULOGD_RET_RAW:
 			ulogd_log(ULOGD_NOTICE,
diff --git a/util/printflow.c b/util/printflow.c
index 73d2969..bb3c2c4 100644
--- a/util/printflow.c
+++ b/util/printflow.c
@@ -164,12 +164,12 @@ int printflow_print(struct ulogd_key *res, char *buf)
 	if (pp_is_valid(res, PRINTFLOW_ORIG_IP_SADDR))
 		buf_cur += sprintf(buf_cur,
 				   "SRC=%s ", 
-				   GET_VALUE(res, PRINTFLOW_ORIG_IP_SADDR).ptr);
+				   (char *) GET_VALUE(res, PRINTFLOW_ORIG_IP_SADDR).ptr);
 
 	if (pp_is_valid(res, PRINTFLOW_ORIG_IP_DADDR))
 		buf_cur += sprintf(buf_cur,
 				   "DST=%s ",
-				   GET_VALUE(res, PRINTFLOW_ORIG_IP_DADDR).ptr);
+				   (char *) GET_VALUE(res, PRINTFLOW_ORIG_IP_DADDR).ptr);
 
 	if (!pp_is_valid(res, PRINTFLOW_ORIG_IP_PROTOCOL))
 		goto orig_out;
@@ -215,12 +215,12 @@ orig_out:
 	if (pp_is_valid(res, PRINTFLOW_REPLY_IP_SADDR))
 		buf_cur += sprintf(buf_cur,
 				   "SRC=%s ",
-				   GET_VALUE(res,PRINTFLOW_REPLY_IP_SADDR).ptr);
+				   (char *) GET_VALUE(res,PRINTFLOW_REPLY_IP_SADDR).ptr);
 
 	if (pp_is_valid(res, PRINTFLOW_REPLY_IP_DADDR))
 		buf_cur += sprintf(buf_cur,
 				   "DST=%s ",
-				   GET_VALUE(res,PRINTFLOW_REPLY_IP_DADDR).ptr);
+				   (char *) GET_VALUE(res,PRINTFLOW_REPLY_IP_DADDR).ptr);
 
 	if (!pp_is_valid(res, PRINTFLOW_REPLY_IP_PROTOCOL))
 		goto reply_out;
diff --git a/util/printpkt.c b/util/printpkt.c
index c64a4cb..5359b8b 100644
--- a/util/printpkt.c
+++ b/util/printpkt.c
@@ -193,11 +193,11 @@ static int printpkt_ipv4(struct ulogd_key *res, char *buf)
 
 	if (pp_is_valid(res, KEY_IP_SADDR))
 		buf_cur += sprintf(buf_cur, "SRC=%s ",
-				   GET_VALUE(res, KEY_IP_SADDR).ptr);
+				   (char *) GET_VALUE(res, KEY_IP_SADDR).ptr);
 
 	if (pp_is_valid(res, KEY_IP_DADDR))
 		buf_cur += sprintf(buf_cur, "DST=%s ",
-				   GET_VALUE(res, KEY_IP_DADDR).ptr);
+				   (char *) GET_VALUE(res, KEY_IP_DADDR).ptr);
 
 	/* FIXME: add pp_is_valid calls to remainder of file */
 	buf_cur += sprintf(buf_cur,"LEN=%u TOS=%02X PREC=0x%02X TTL=%u ID=%u ", 
@@ -279,11 +279,11 @@ static int printpkt_ipv6(struct ulogd_key *res, char *buf)
 
 	if (pp_is_valid(res, KEY_IP_SADDR))
 		buf_cur += sprintf(buf_cur, "SRC=%s ",
-				   GET_VALUE(res, KEY_IP_SADDR).ptr);
+				   (char *) GET_VALUE(res, KEY_IP_SADDR).ptr);
 
 	if (pp_is_valid(res, KEY_IP_DADDR))
 		buf_cur += sprintf(buf_cur, "DST=%s ",
-				   GET_VALUE(res, KEY_IP_DADDR).ptr);
+				   (char *) GET_VALUE(res, KEY_IP_DADDR).ptr);
 
 	if (pp_is_valid(res, KEY_IP6_PAYLOAD_LEN))
 		buf_cur += sprintf(buf_cur, "LEN=%Zu ",
@@ -355,11 +355,11 @@ int printpkt_arp(struct ulogd_key *res, char *buf)
 
 	if (pp_is_valid(res, KEY_ARP_SPA))
 		buf_cur += sprintf(buf_cur, "SRC=%s ",
-				   GET_VALUE(res, KEY_ARP_SPA).ptr);
+				   (char *) GET_VALUE(res, KEY_ARP_SPA).ptr);
 
 	if (pp_is_valid(res, KEY_ARP_TPA))
 		buf_cur += sprintf(buf_cur, "DST=%s ",
-				   GET_VALUE(res, KEY_ARP_TPA).ptr);
+				   (char *) GET_VALUE(res, KEY_ARP_TPA).ptr);
 
 	buf_cur += sprintf(buf_cur, "PROTO=ARP ");
 
-- 
1.5.4.3

