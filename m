From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 3/3] Modify printflow filter to display event type in output message.
Date: Mon, 17 Mar 2008 01:07:03 +0100
Message-ID: <12057124233697-git-send-email-eric@inl.fr>
References: <12057124233723-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:44215 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753176AbYCQAHF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Mar 2008 20:07:05 -0400
In-Reply-To: <12057124233723-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds support of event type display in printflow filter. This is used
to display event type in textual output modules. Here's an output example:

[DESTROY] ORIG: SRC=192.168.1.2 DST=192.168.1.255 PROTO=UDP SPT=631 DPT=631 \\
	PKTS=1 BYTES=197 , REPLY: SRC=192.168.1.255 DST=192.168.1.2 \\
	PROTO=UDP SPT=631 DPT=631 PKTS=0 BYTES=0

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 include/ulogd/printflow.h |    2 +-
 util/printflow.c          |   20 ++++++++++++++++++++
 2 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/include/ulogd/printflow.h b/include/ulogd/printflow.h
index 979f673..b793426 100644
--- a/include/ulogd/printflow.h
+++ b/include/ulogd/printflow.h
@@ -1,7 +1,7 @@
 #ifndef _PRINTFLOW_H
 #define _PRINTFLOW_H
 
-#define FLOW_IDS 16
+#define FLOW_IDS 17
 extern struct ulogd_key printflow_keys[FLOW_IDS];
 
 int printflow_print(struct ulogd_key *res, char *buf);
diff --git a/util/printflow.c b/util/printflow.c
index 92c4f0f..6c2ffd5 100644
--- a/util/printflow.c
+++ b/util/printflow.c
@@ -45,6 +45,7 @@ enum printflow_fields {
 	PRINTFLOW_REPLY_RAW_PKTCOUNT,
 	PRINTFLOW_ICMP_CODE,
 	PRINTFLOW_ICMP_TYPE,
+	PRINTFLOW_EVENT_TYPE,
 };
 
 struct ulogd_key printflow_keys[FLOW_IDS] = {
@@ -128,6 +129,11 @@ struct ulogd_key printflow_keys[FLOW_IDS] = {
 		.flags = ULOGD_RETF_NONE,
 		.name = "icmp.type",
 	},
+	{
+		.type = ULOGD_RET_UINT32,
+		.flags = ULOGD_RETF_NONE,
+		.name = "ct.event",
+	},
 };
 int printflow_keys_num = sizeof(printflow_keys)/sizeof(*printflow_keys);
 
@@ -139,6 +145,20 @@ int printflow_print(struct ulogd_key *res, char *buf)
 {
 	char *buf_cur = buf;
 
+	if (pp_is_valid(res, PRINTFLOW_EVENT_TYPE)) {
+		switch (GET_VALUE(res, PRINTFLOW_EVENT_TYPE).ui32) {
+			case 1:
+				buf_cur += sprintf(buf_cur, "[NEW] ");
+				break;
+			case 2:
+				buf_cur += sprintf(buf_cur, "[UPDATE] ");
+				break;
+			case 3:
+				buf_cur += sprintf(buf_cur, "[DESTROY] ");
+				break;
+		}
+	}
+
 	buf_cur += sprintf(buf_cur, "ORIG: ");
 
 	if (pp_is_valid(res, PRINTFLOW_ORIG_IP_SADDR))
-- 
1.5.4.3

