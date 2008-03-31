From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 3/4] IPv6 compliance of NACCT output plugin.
Date: Tue,  1 Apr 2008 01:09:49 +0200
Message-ID: <12070049902856-git-send-email-eric@inl.fr>
References: <1207004990315-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:41725 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751293AbYCaXJw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 31 Mar 2008 19:09:52 -0400
In-Reply-To: <1207004990315-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

NACCT was IPv4 only and was heavily dependant of the order of NFCT keys.
This patch introduces a explicit list of input keys and obtains IPv6
compliance by using IP2STR output as input for IP address.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 output/ulogd_output_NACCT.c |  137 ++++++++++++++++++++++++++++++-------------
 1 files changed, 96 insertions(+), 41 deletions(-)

diff --git a/output/ulogd_output_NACCT.c b/output/ulogd_output_NACCT.c
index 2da73e7..278df36 100644
--- a/output/ulogd_output_NACCT.c
+++ b/output/ulogd_output_NACCT.c
@@ -31,30 +31,85 @@
 
 #define NACCT_FILE_DEFAULT	"/var/log/nacctdata.log"
 
-#define HIPQUAD(addr) \
-        ((unsigned char *)&addr)[3], \
-        ((unsigned char *)&addr)[2], \
-        ((unsigned char *)&addr)[1], \
-        ((unsigned char *)&addr)[0]
-
 /* config accessors (lazy me...) */
 #define NACCT_CFG_FILE(pi)	((pi)->config_kset->ces[0].u.string)
 #define NACCT_CFG_SYNC(pi)	((pi)->config_kset->ces[1].u.value)
 
-#define KEY(pi,idx)		((pi)->input.keys[(idx)].u.source)
+enum input_keys {
+	KEY_IP_SADDR,
+	KEY_IP_DADDR,
+	KEY_IP_PROTO,
+	KEY_L4_SPORT,
+	KEY_L4_DPORT,
+	KEY_RAW_PKTLEN,
+	KEY_RAW_PKTCNT,
+	KEY_ICMP_CODE,
+	KEY_ICMP_TYPE,
+	KEY_FLOW_START,
+	KEY_FLOW_END,
+};
 
 /* input keys */
-#define KEY_IP_SADDR(pi)		KEY(pi, 0)
-#define KEY_IP_DADDR(pi)		KEY(pi, 1)
-#define KEY_IP_PROTO(pi)		KEY(pi, 2)
-#define KEY_L4_SPORT(pi)		KEY(pi, 3)
-#define KEY_L4_DPORT(pi)		KEY(pi, 4)
-#define KEY_RAW_PKTLEN(pi)		KEY(pi, 5)
-#define KEY_RAW_PKTCNT(pi)		KEY(pi, 6)
-#define KEY_ICMP_CODE(pi)		KEY(pi, 7)
-#define KEY_ICMP_TYPE(pi)		KEY(pi, 8)
-#define KEY_FLOW_START(pi)		KEY(pi, 11)
-#define KEY_FLOW_END(pi)		KEY(pi, 13)
+static struct ulogd_key nacct_inp[] = {
+	[KEY_IP_SADDR] = {
+		.type = ULOGD_RET_STRING,
+		.flags = ULOGD_RETF_NONE,
+		.name = "orig.ip.saddr.str",
+	},
+	[KEY_IP_DADDR] = {
+		.type = ULOGD_RET_STRING,
+		.flags = ULOGD_RETF_NONE,
+		.name = "orig.ip.daddr.str",
+	},
+	[KEY_IP_PROTO] = {
+			.type	= ULOGD_RET_UINT8,
+		.flags	= ULOGD_RETF_NONE,
+		.name	= "orig.ip.protocol",
+
+	},
+	[KEY_L4_SPORT] = {
+	.type	= ULOGD_RET_UINT16,
+		.flags 	= ULOGD_RETF_NONE,
+		.name	= "orig.l4.sport",
+
+	},
+	[KEY_L4_DPORT] = {
+		.type	= ULOGD_RET_UINT16,
+		.flags 	= ULOGD_RETF_NONE,
+		.name	= "orig.l4.dport",
+	},
+	/* Assume we're interested more in download than upload */
+	[KEY_RAW_PKTLEN] = {
+		.type	= ULOGD_RET_UINT32,
+		.flags	= ULOGD_RETF_NONE,
+		.name	= "reply.raw.pktlen",
+	},
+	[KEY_RAW_PKTCNT] = {
+		.type	= ULOGD_RET_UINT32,
+		.flags	= ULOGD_RETF_NONE,
+		.name	= "reply.raw.pktcount",
+	},
+	[KEY_ICMP_CODE] = {
+		.type	= ULOGD_RET_UINT8,
+		.flags	= ULOGD_RETF_NONE,
+		.name	= "icmp.code",
+	},
+	[KEY_ICMP_TYPE] = { 
+		.type	= ULOGD_RET_UINT8,
+		.flags	= ULOGD_RETF_NONE,
+		.name	= "icmp.type",
+	},
+	[KEY_FLOW_START] = {
+		.type 	= ULOGD_RET_UINT32,
+		.flags 	= ULOGD_RETF_NONE,
+		.name	= "flow.start.sec",
+	},
+	[KEY_FLOW_END] = {
+		.type	= ULOGD_RET_UINT32,
+		.flags	= ULOGD_RETF_NONE,
+		.name	= "flow.end.sec",
+	},
+};
 
 struct nacct_priv {
 	FILE *of;
@@ -65,32 +120,33 @@ static int
 nacct_interp(struct ulogd_pluginstance *pi)
 {
 	struct nacct_priv *priv = (struct nacct_priv *)&pi->private;
-	static char buf[80];
+	struct ulogd_key *inp = pi->input.keys;
+	static char buf[256];
 
 	/* try to be as close to nacct as possible.  Instead of nacct's
 	   'timestamp' value use 'flow.end.sec' */
-	if (KEY_IP_PROTO(pi)->u.value.ui8 == IPPROTO_ICMP) {
+	if (GET_VALUE(inp, KEY_IP_PROTO).ui8 == IPPROTO_ICMP) {
 		snprintf(buf, sizeof(buf),
-				 "%u\t%u\t%u.%u.%u.%u\t%u\t%u.%u.%u.%u\t%u\t%u\t%u",
-				 KEY_FLOW_END(pi)->u.value.ui32,
-				 KEY_IP_PROTO(pi)->u.value.ui8,
-				 HIPQUAD(KEY_IP_SADDR(pi)->u.value.ui32),
-				 KEY_ICMP_TYPE(pi)->u.value.ui8,
-				 HIPQUAD(KEY_IP_DADDR(pi)->u.value.ui32),
-				 KEY_ICMP_CODE(pi)->u.value.ui8,
-				 KEY_RAW_PKTCNT(pi)->u.value.ui32,
-				 KEY_RAW_PKTLEN(pi)->u.value.ui32);
+				 "%u\t%u\t%s\t%u\t%s\t%u\t%u\t%u",
+				 GET_VALUE(inp, KEY_FLOW_END).ui32,
+				 GET_VALUE(inp, KEY_IP_PROTO).ui8,
+				 GET_VALUE(inp, KEY_IP_SADDR).ptr,
+				 GET_VALUE(inp, KEY_ICMP_TYPE).ui8,
+				 GET_VALUE(inp, KEY_IP_DADDR).ptr,
+				 GET_VALUE(inp, KEY_ICMP_CODE).ui8,
+				 GET_VALUE(inp, KEY_RAW_PKTCNT).ui32,
+				 GET_VALUE(inp, KEY_RAW_PKTLEN).ui32);
 	} else {
 		snprintf(buf, sizeof(buf),
-				 "%u\t%u\t%u.%u.%u.%u\t%u\t%u.%u.%u.%u\t%u\t%u\t%u",
-				 KEY_FLOW_END(pi)->u.value.ui32,
-				 KEY_IP_PROTO(pi)->u.value.ui8,
-				 HIPQUAD(KEY_IP_SADDR(pi)->u.value.ui32),
-				 KEY_L4_SPORT(pi)->u.value.ui8,
-				 HIPQUAD(KEY_IP_DADDR(pi)->u.value.ui32),
-				 KEY_L4_DPORT(pi)->u.value.ui8,
-				 KEY_RAW_PKTCNT(pi)->u.value.ui32,
-				 KEY_RAW_PKTLEN(pi)->u.value.ui32);
+				 "%u\t%u\t%s\t%u\t%s\t%u\t%u\t%u",
+				 GET_VALUE(inp, KEY_FLOW_END).ui32,
+				 GET_VALUE(inp, KEY_IP_PROTO).ui8,
+				 GET_VALUE(inp, KEY_IP_SADDR).ptr,
+				 GET_VALUE(inp, KEY_L4_SPORT).ui16,
+				 GET_VALUE(inp, KEY_IP_DADDR).ptr,
+				 GET_VALUE(inp, KEY_L4_DPORT).ui16,
+				 GET_VALUE(inp, KEY_RAW_PKTCNT).ui32,
+				 GET_VALUE(inp, KEY_RAW_PKTLEN).ui32);
 	}
 
 	fprintf(priv->of, "%s\n", buf);
@@ -147,9 +203,6 @@ nacct_conf(struct ulogd_pluginstance *pi,
 {
 	int ret;
 
-	if ((ret = ulogd_wildcard_inputkeys(pi)) < 0)
-		return ret;
-
 	if ((ret = config_parse_file(pi->id, pi->config_kset)) < 0)
 		return ret;
 
@@ -183,6 +236,8 @@ nacct_fini(struct ulogd_pluginstance *pi)
 static struct ulogd_plugin nacct_plugin = {
 	.name = "NACCT", 
 	.input = {
+		.keys = nacct_inp,
+		.num_keys = ARRAY_SIZE(nacct_inp),
 		.type = ULOGD_DTYPE_PACKET | ULOGD_DTYPE_FLOW,
 	},
 	.output = {
-- 
1.5.2.5

