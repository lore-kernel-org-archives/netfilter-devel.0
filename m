From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 4/6] Use IP2STR keys in PRINTFLOW module.
Date: Wed, 26 Mar 2008 23:49:09 +0100
Message-ID: <12065717523264-git-send-email-eric@inl.fr>
References: <12065717514081-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:36537 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753816AbYCZWtO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Mar 2008 18:49:14 -0400
In-Reply-To: <12065717514081-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The PRINTFLOW module had its own code for string conversion of IPv6 address.
This patch change the input key of the module to use conversion made by the
IP2STR module.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
:100644 100644 6c2ffd5... 272ee4f... M	util/printflow.c
 util/printflow.c |   20 ++++++++------------
 1 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/util/printflow.c b/util/printflow.c
index 6c2ffd5..272ee4f 100644
--- a/util/printflow.c
+++ b/util/printflow.c
@@ -52,12 +52,12 @@ struct ulogd_key printflow_keys[FLOW_IDS] = {
 	{
 		.type = ULOGD_RET_IPADDR,
 		.flags = ULOGD_RETF_NONE,
-		.name = "orig.ip.saddr",
+		.name = "orig.ip.saddr.str",
 	},
 	{
 		.type = ULOGD_RET_IPADDR,
 		.flags = ULOGD_RETF_NONE,
-		.name = "orig.ip.daddr",
+		.name = "orig.ip.daddr.str",
 	},
 	{
 		.type = ULOGD_RET_UINT8,
@@ -87,12 +87,12 @@ struct ulogd_key printflow_keys[FLOW_IDS] = {
 	{
 		.type = ULOGD_RET_IPADDR,
 		.flags = ULOGD_RETF_NONE,
-		.name = "reply.ip.saddr",
+		.name = "reply.ip.saddr.str",
 	},
 	{
 		.type = ULOGD_RET_IPADDR,
 		.flags = ULOGD_RETF_NONE,
-		.name = "reply.ip.daddr",
+		.name = "reply.ip.daddr.str",
 	},
 	{
 		.type = ULOGD_RET_UINT8,
@@ -162,12 +162,10 @@ int printflow_print(struct ulogd_key *res, char *buf)
 	buf_cur += sprintf(buf_cur, "ORIG: ");
 
 	if (pp_is_valid(res, PRINTFLOW_ORIG_IP_SADDR))
-		buf_cur += sprintf(buf_cur, "SRC=%s ", inet_ntoa(
-				(struct in_addr) {htonl(GET_VALUE(res, PRINTFLOW_ORIG_IP_SADDR).ui32)}));
+		buf_cur += sprintf(buf_cur, "SRC=%s ", GET_VALUE(res, PRINTFLOW_ORIG_IP_SADDR).ptr);
 
 	if (pp_is_valid(res, PRINTFLOW_ORIG_IP_DADDR))
-		buf_cur += sprintf(buf_cur, "DST=%s ", inet_ntoa(
-				(struct in_addr) {htonl(GET_VALUE(res, PRINTFLOW_ORIG_IP_DADDR).ui32)}));
+		buf_cur += sprintf(buf_cur, "DST=%s ", GET_VALUE(res, PRINTFLOW_ORIG_IP_DADDR).ptr);
 
 	if (!pp_is_valid(res, PRINTFLOW_ORIG_IP_PROTOCOL))
 		goto orig_out;
@@ -211,12 +209,10 @@ orig_out:
 	buf_cur += sprintf(buf_cur, ", REPLY: ");
 
 	if (pp_is_valid(res, PRINTFLOW_REPLY_IP_SADDR))
-		buf_cur += sprintf(buf_cur, "SRC=%s ", inet_ntoa(
-				(struct in_addr) {htonl(GET_VALUE(res, PRINTFLOW_REPLY_IP_SADDR).ui32)}));
+		buf_cur += sprintf(buf_cur, "SRC=%s ", GET_VALUE(res, PRINTFLOW_REPLY_IP_SADDR).ptr);
 
 	if (pp_is_valid(res, PRINTFLOW_REPLY_IP_DADDR))
-		buf_cur += sprintf(buf_cur, "DST=%s ", inet_ntoa(
-				(struct in_addr) {htonl(GET_VALUE(res, PRINTFLOW_REPLY_IP_DADDR).ui32)}));
+		buf_cur += sprintf(buf_cur, "DST=%s ", GET_VALUE(res, PRINTFLOW_REPLY_IP_DADDR).ptr);
 
 	if (!pp_is_valid(res, PRINTFLOW_REPLY_IP_PROTOCOL))
 		goto reply_out;
-- 
1.5.2.5

