From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 2/6] Convert struct to [KEY] = {} format.
Date: Thu, 19 Jun 2008 14:23:03 +0200
Message-ID: <1213878187-909-3-git-send-email-eric@inl.fr>
References: <1213878187-909-1-git-send-email-eric@inl.fr>
Cc: chifflier@inl.fr, Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:60858 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755834AbYFSMXc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jun 2008 08:23:32 -0400
In-Reply-To: <1213878187-909-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch converts NFLOG and ULOG structure to the [KEY} = {}
discuss sooner with Patrick on the ML.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 input/packet/ulogd_inppkt_NFLOG.c |   39 +++++++++++++++++++------------------
 input/packet/ulogd_inppkt_ULOG.c  |   31 +++++++++++++++--------------
 2 files changed, 36 insertions(+), 34 deletions(-)

diff --git a/input/packet/ulogd_inppkt_NFLOG.c b/input/packet/ulogd_inppkt_NFLOG.c
index 95a2956..728b410 100644
--- a/input/packet/ulogd_inppkt_NFLOG.c
+++ b/input/packet/ulogd_inppkt_NFLOG.c
@@ -136,7 +136,7 @@ enum nflog_keys {
 };
 
 static struct ulogd_key output_keys[] = {
-	{
+	[NFLOG_KEY_RAW_MAC] = {
 		.type = ULOGD_RET_RAW,
 		.flags = ULOGD_RETF_NONE,
 		.name = "raw.mac",
@@ -145,7 +145,7 @@ static struct ulogd_key output_keys[] = {
 			.field_id = IPFIX_sourceMacAddress,
 		},
 	},
-	{
+	[NFLOG_KEY_RAW_PCKT] = {
 		.type = ULOGD_RET_RAW,
 		.flags = ULOGD_RETF_NONE,
 		.name = "raw.pkt",
@@ -154,7 +154,7 @@ static struct ulogd_key output_keys[] = {
 			.field_id = IPFIX_NF_rawpacket,
 		},
 	},
-	{
+	[NFLOG_KEY_RAW_PCKTLEN] = {
 		.type = ULOGD_RET_UINT32,
 		.flags = ULOGD_RETF_NONE,
 		.name = "raw.pktlen",
@@ -163,7 +163,7 @@ static struct ulogd_key output_keys[] = {
 			.field_id = IPFIX_NF_rawpacket_length,
 		},
 	},
-	{
+	[NFLOG_KEY_RAW_PCKTCOUNT] = {
 		.type = ULOGD_RET_UINT32,
 		.flags = ULOGD_RETF_NONE,
 		.name = "raw.pktcount",
@@ -172,7 +172,7 @@ static struct ulogd_key output_keys[] = {
 			.field_id = IPFIX_packetDeltaCount,
 		},
 	},
-	{
+	[NFLOG_KEY_OOB_PREFIX] = {
 		.type = ULOGD_RET_STRING,
 		.flags = ULOGD_RETF_NONE,
 		.name = "oob.prefix",
@@ -181,7 +181,8 @@ static struct ulogd_key output_keys[] = {
 			.field_id = IPFIX_NF_prefix,
 		},
 	},
-	{ 	.type = ULOGD_RET_UINT32,
+	[NFLOG_KEY_OOB_TIME_SEC] = {
+		.type = ULOGD_RET_UINT32,
 		.flags = ULOGD_RETF_NONE,
 		.name = "oob.time.sec",
 		.ipfix = {
@@ -189,7 +190,7 @@ static struct ulogd_key output_keys[] = {
 			.field_id = IPFIX_flowStartSeconds,
 		},
 	},
-	{
+	[NFLOG_KEY_OOB_TIME_USEC] = {
 		.type = ULOGD_RET_UINT32,
 		.flags = ULOGD_RETF_NONE,
 		.name = "oob.time.usec",
@@ -198,7 +199,7 @@ static struct ulogd_key output_keys[] = {
 			.field_id = IPFIX_flowStartMicroSeconds,
 		},
 	},
-	{
+	[NFLOG_KEY_OOB_MARK] = {
 		.type = ULOGD_RET_UINT32,
 		.flags = ULOGD_RETF_NONE,
 		.name = "oob.mark",
@@ -207,7 +208,7 @@ static struct ulogd_key output_keys[] = {
 			.field_id = IPFIX_NF_mark,
 		},
 	},
-	{
+	[NFLOG_KEY_OOB_IFINDEX_IN] = {
 		.type = ULOGD_RET_UINT32,
 		.flags = ULOGD_RETF_NONE,
 		.name = "oob.ifindex_in",
@@ -216,7 +217,7 @@ static struct ulogd_key output_keys[] = {
 			.field_id = IPFIX_ingressInterface,
 		},
 	},
-	{
+	[NFLOG_KEY_OOB_IFINDEX_OUT] = {
 		.type = ULOGD_RET_UINT32,
 		.flags = ULOGD_RETF_NONE,
 		.name = "oob.ifindex_out",
@@ -225,7 +226,7 @@ static struct ulogd_key output_keys[] = {
 			.field_id = IPFIX_egressInterface,
 		},
 	},
-	{
+	[NFLOG_KEY_OOB_HOOK] = {
 		.type = ULOGD_RET_UINT8,
 		.flags = ULOGD_RETF_NONE,
 		.name = "oob.hook",
@@ -234,12 +235,12 @@ static struct ulogd_key output_keys[] = {
 			.field_id = IPFIX_NF_hook,
 		},
 	},
-	{
+	[NFLOG_KEY_RAW_MAC_LEN] = {
 		.type = ULOGD_RET_UINT16,
 		.flags = ULOGD_RETF_NONE,
 		.name = "raw.mac_len",
 	},
-	{
+	[NFLOG_KEY_OOB_SEQ_LOCAL] = {
 		.type = ULOGD_RET_UINT32,
 		.flags = ULOGD_RETF_NONE,
 		.name = "oob.seq.local",
@@ -248,7 +249,7 @@ static struct ulogd_key output_keys[] = {
 			.field_id = IPFIX_NF_seq_local,
 		},
 	},
-	{
+	[NFLOG_KEY_OOB_SEQ_GLOBAL] = {
 		.type = ULOGD_RET_UINT32,
 		.flags = ULOGD_RETF_NONE,
 		.name = "oob.seq.global",
@@ -257,27 +258,27 @@ static struct ulogd_key output_keys[] = {
 			.field_id = IPFIX_NF_seq_global,
 		},
 	},
-	{
+	[NFLOG_KEY_OOB_FAMILY] = {
 		.type = ULOGD_RET_UINT8,
 		.flags = ULOGD_RETF_NONE,
 		.name = "oob.family",
 	},
-	{
+	[NFLOG_KEY_OOB_PROTOCOL] = {
 		.type = ULOGD_RET_UINT16,
 		.flags = ULOGD_RETF_NONE,
 		.name = "oob.protocol",
 	},
-	{
+	[NFLOG_KEY_OOB_UID] = {
 		.type = ULOGD_RET_UINT32,
 		.flags = ULOGD_RETF_NONE,
 		.name = "oob.uid",
 	},
-	{
+	[NFLOG_KEY_OOB_GID] = {
 		.type = ULOGD_RET_UINT32,
 		.flags = ULOGD_RETF_NONE,
 		.name = "oob.gid",
 	},
-	{
+	[NFLOG_KEY_RAW_LABEL] = {
 		.type = ULOGD_RET_UINT8,
 		.flags = ULOGD_RETF_NONE,
 		.name = "raw.label",
diff --git a/input/packet/ulogd_inppkt_ULOG.c b/input/packet/ulogd_inppkt_ULOG.c
index 2f65813..97b9972 100644
--- a/input/packet/ulogd_inppkt_ULOG.c
+++ b/input/packet/ulogd_inppkt_ULOG.c
@@ -83,7 +83,7 @@ enum ulog_keys {
 };
 
 static struct ulogd_key output_keys[] = {
-	{
+	[ULOG_KEY_RAW_MAC] = {
 		.type = ULOGD_RET_RAW,
 		.flags = ULOGD_RETF_NONE,
 		.name = "raw.mac",
@@ -92,7 +92,7 @@ static struct ulogd_key output_keys[] = {
 			.field_id = IPFIX_sourceMacAddress,
 		},
 	},
-	{
+	[ULOG_KEY_RAW_PCKT] = {
 		.type = ULOGD_RET_RAW,
 		.flags = ULOGD_RETF_NONE,
 		.name = "raw.pkt",
@@ -101,7 +101,7 @@ static struct ulogd_key output_keys[] = {
 			.field_id = 1,
 			},
 	},
-	{
+	[ULOG_KEY_RAW_PCKTLEN] = {
 		.type = ULOGD_RET_UINT32,
 		.flags = ULOGD_RETF_NONE,
 		.name = "raw.pktlen",
@@ -110,7 +110,7 @@ static struct ulogd_key output_keys[] = {
 			.field_id = 1
 		},
 	},
-	{
+	[ULOG_KEY_RAW_PCKTCOUNT] = {
 		.type = ULOGD_RET_UINT32,
 		.flags = ULOGD_RETF_NONE,
 		.name = "raw.pktcount",
@@ -119,12 +119,13 @@ static struct ulogd_key output_keys[] = {
 			.field_id = 2
 		},
 	},
-	{
+	[ULOG_KEY_OOB_PREFIX] = {
 		.type = ULOGD_RET_STRING,
 		.flags = ULOGD_RETF_NONE,
 		.name = "oob.prefix",
 	},
-	{ 	.type = ULOGD_RET_UINT32,
+	[ULOG_KEY_OOB_TIME_SEC] = {
+		.type = ULOGD_RET_UINT32,
 		.flags = ULOGD_RETF_NONE,
 		.name = "oob.time.sec",
 		.ipfix = {
@@ -132,27 +133,27 @@ static struct ulogd_key output_keys[] = {
 			.field_id = 22
 		},
 	},
-	{
+	[ULOG_KEY_OOB_TIME_USEC] = {
 		.type = ULOGD_RET_UINT32,
 		.flags = ULOGD_RETF_NONE,
 		.name = "oob.time.usec",
 	},
-	{
+	[ULOG_KEY_OOB_MARK] = {
 		.type = ULOGD_RET_UINT32,
 		.flags = ULOGD_RETF_NONE,
 		.name = "oob.mark",
 	},
-	{
+	[ULOG_KEY_OOB_IN] = {
 		.type = ULOGD_RET_STRING,
 		.flags = ULOGD_RETF_NONE,
 		.name = "oob.in",
 	},
-	{
+	[ULOG_KEY_OOB_OUT] = {
 		.type = ULOGD_RET_STRING,
 		.flags = ULOGD_RETF_NONE,
 		.name = "oob.out",
 	},
-	{
+	[ULOG_KEY_OOB_HOOK] = {
 		.type = ULOGD_RET_UINT8,
 		.flags = ULOGD_RETF_NONE,
 		.name = "oob.hook",
@@ -161,22 +162,22 @@ static struct ulogd_key output_keys[] = {
 			.field_id = IPFIX_NF_hook,
 		},
 	},
-	{
+	[ULOG_KEY_RAW_MAC_LEN] = {
 		.type = ULOGD_RET_UINT16,
 		.flags = ULOGD_RETF_NONE,
 		.name = "raw.mac_len",
 	},
-	{
+	[ULOG_KEY_OOB_FAMILY] = {
 		.type = ULOGD_RET_UINT8,
 		.flags = ULOGD_RETF_NONE,
 		.name = "oob.family",
 	},
-	{
+	[ULOG_KEY_OOB_PROTOCOL] = {
 		.type = ULOGD_RET_UINT16,
 		.flags = ULOGD_RETF_NONE,
 		.name = "oob.protocol",
 	},
-	{
+	[ULOG_KEY_RAW_LABEL] = {
 		.type = ULOGD_RET_UINT8,
 		.flags = ULOGD_RETF_NONE,
 		.name = "raw.label",
-- 
1.5.5.3

