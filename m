From: Eric Leblond <eric@regit.org>
Subject: [ulogd PATCH 1/2] store Common Information Model name in ulogd key
Date: Tue, 28 Jan 2014 23:41:26 +0100
Message-ID: <1390948887-2112-2-git-send-email-eric@regit.org>
References: <1390948887-2112-1-git-send-email-eric@regit.org>
Cc: Eric Leblond <eric@regit.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:56244 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754923AbaA1Wlt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 28 Jan 2014 17:41:49 -0500
In-Reply-To: <1390948887-2112-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds storage for CIM field name in ulogd key. This
will be used by JSON output to interoperate with logging
collector such as logstash or splunk.

Common Information Model is an open standard that defines how managed
elements in an IT environment are represented as a common set of objects
and relationships between them:
 http://www.dmtf.org/standards/cim

This seems to be mainly XML based but there is a JSON version of some
aspects of the model. One of the main documentation on CIM in JSON
format seems to be:
 http://docs.splunk.com/Documentation/PCI/2.0/DataSource/CommonInformationModelFieldReference

Using the correct CIM field name allow events coming from ulogd to be
correlated with events coming from other sources.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 filter/raw2packet/ulogd_raw2packet_BASE.c | 10 ++++++++--
 filter/ulogd_filter_IP2STR.c              |  4 ++++
 include/ulogd/ulogd.h                     |  3 +++
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/filter/raw2packet/ulogd_raw2packet_BASE.c b/filter/raw2packet/ulogd_raw2packet_BASE.c
index 8dfe38e..c9d5227 100644
--- a/filter/raw2packet/ulogd_raw2packet_BASE.c
+++ b/filter/raw2packet/ulogd_raw2packet_BASE.c
@@ -259,6 +259,7 @@ static struct ulogd_key iphdr_rets[] = {
 			.vendor = IPFIX_VENDOR_IETF,
 			.field_id = IPFIX_tcpSourcePort,
 		},
+		.cim_name = "src_port",
 	},
 	[KEY_TCP_DPORT] = {
 		.type = ULOGD_RET_UINT16,
@@ -268,6 +269,7 @@ static struct ulogd_key iphdr_rets[] = {
 			.vendor = IPFIX_VENDOR_IETF,
 			.field_id = IPFIX_tcpDestinationPort,
 		},
+		.cim_name = "dest_port",
 	},
 	[KEY_TCP_SEQ] = {
 		.type = ULOGD_RET_UINT32,
@@ -368,6 +370,7 @@ static struct ulogd_key iphdr_rets[] = {
 			.vendor = IPFIX_VENDOR_IETF, 
 			.field_id = IPFIX_udpSourcePort,
 		},
+		.cim_name = "src_port",
 	},
 	[KEY_UDP_DPORT] = {
 		.type = ULOGD_RET_UINT16,
@@ -377,6 +380,7 @@ static struct ulogd_key iphdr_rets[] = {
 			.vendor = IPFIX_VENDOR_IETF,
 			.field_id = IPFIX_udpDestinationPort,
 		},
+		.cim_name = "dest_port",
 	},
 	[KEY_UDP_LEN] = {
 		.type = ULOGD_RET_UINT16,
@@ -512,12 +516,14 @@ static struct ulogd_key iphdr_rets[] = {
 	[KEY_SCTP_SPORT] = {
 		.type = ULOGD_RET_UINT16,
 		.flags = ULOGD_RETF_NONE,
-		.name = "sctp.sport", 
+		.name = "sctp.sport",
+		.cim_name = "src_port",
 	},
 	[KEY_SCTP_DPORT] = {
 		.type = ULOGD_RET_UINT16,
 		.flags = ULOGD_RETF_NONE,
-		.name = "sctp.dport", 
+		.name = "sctp.dport",
+		.cim_name = "dest_port",
 	},
 	[KEY_SCTP_CSUM] = {
 		.type = ULOGD_RET_UINT32,
diff --git a/filter/ulogd_filter_IP2STR.c b/filter/ulogd_filter_IP2STR.c
index 44157fe..732e1ef 100644
--- a/filter/ulogd_filter_IP2STR.c
+++ b/filter/ulogd_filter_IP2STR.c
@@ -102,18 +102,22 @@ static struct ulogd_key ip2str_keys[] = {
 	{
 		.type = ULOGD_RET_STRING,
 		.name = "ip.saddr.str",
+		.cim_name = "src_ip",
 	},
 	{
 		.type = ULOGD_RET_STRING,
 		.name = "ip.daddr.str",
+		.cim_name = "dest_ip",
 	},
 	{
 		.type = ULOGD_RET_STRING,
 		.name = "orig.ip.saddr.str",
+		.cim_name = "src_ip",
 	},
 	{
 		.type = ULOGD_RET_STRING,
 		.name = "orig.ip.daddr.str",
+		.cim_name = "dest_ip",
 	},
 	{
 		.type = ULOGD_RET_STRING,
diff --git a/include/ulogd/ulogd.h b/include/ulogd/ulogd.h
index cc2f15c..cf26a15 100644
--- a/include/ulogd/ulogd.h
+++ b/include/ulogd/ulogd.h
@@ -98,6 +98,9 @@ struct ulogd_key {
 		u_int16_t	field_id;
 	} ipfix;
 
+	/* Store field name for Common Information Model */
+	char *cim_name;
+
 	union {
 		/* and finally the returned value */
 		union {
-- 
1.9.rc1

