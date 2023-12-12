Received: from pepin.polanet.pl (pepin.polanet.pl [193.34.52.2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A30509A
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Dec 2023 11:45:38 -0800 (PST)
Date: Tue, 12 Dec 2023 20:45:36 +0100
From: Tomasz Pala <gotar@polanet.pl>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH ulogd] log NAT events using IPFIX
Message-ID: <20231212194536.GA8196@polanet.pl>
References: <20231210201705.GA16025@polanet.pl>
 <ZXhkbfE9ju7uiFNN@calendula>
 <20231212184413.GA2168@polanet.pl>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ZGiS0Q5IWpPtfppv"
Content-Disposition: inline
In-Reply-To: <20231212184413.GA2168@polanet.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline

This patch makes IPFIX output plugin to export translated (post-NAT)
IPv4 addresses and ports.

-- 
Tomasz Pala <gotar@pld-linux.org>

--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: attachment; filename="ulogd2-NAT_events.patch"

diff --git a/include/ulogd/ipfix_protocol.h b/include/ulogd/ipfix_protocol.h
index 01dd96a..a34ee92 100644
--- a/include/ulogd/ipfix_protocol.h
+++ b/include/ulogd/ipfix_protocol.h
@@ -39,6 +39,7 @@ struct ipfix_vendor_field {
 };
 
 /* Information Element Identifiers as of draft-ietf-ipfix-info-11.txt */
+/* Updated list available at https://www.iana.org/assignments/ipfix/ipfix.xhtml */
 enum {
 	IPFIX_octetDeltaCount		= 1,
 	IPFIX_packetDeltaCount		= 2,
@@ -217,6 +218,10 @@ enum {
 	/* reserved */
 	IPFIX_headerLengthIPv4		= 213,
 	IPFIX_mplsPayloadLength		= 214,
+	IPFIX_postNATSourceIPv4Address	= 225,
+	IPFIX_postNATDestinationIPv4Address	= 226,
+	IPFIX_postNAPTSourceTransportPort	= 227,
+	IPFIX_postNAPTDestinationTransportPort	= 228,
 };
 
 /* Information elements of the netfilter vendor id */
diff --git a/input/flow/ulogd_inpflow_NFCT.c b/input/flow/ulogd_inpflow_NFCT.c
index 899b7e3..93c8844 100644
--- a/input/flow/ulogd_inpflow_NFCT.c
+++ b/input/flow/ulogd_inpflow_NFCT.c
@@ -265,8 +265,8 @@ static struct ulogd_key nfct_okeys[] = {
 		.name	= "reply.ip.saddr",
 		.ipfix	= {
 			.vendor = IPFIX_VENDOR_IETF,
-			.field_id = IPFIX_sourceIPv4Address,
-		},
+			.field_id = IPFIX_postNATDestinationIPv4Address,
+		},	/* reply source is after-DNAT destination */
 	},
 	{
 		.type	= ULOGD_RET_IPADDR,
@@ -274,8 +274,8 @@ static struct ulogd_key nfct_okeys[] = {
 		.name	= "reply.ip.daddr",
 		.ipfix	= {
 			.vendor = IPFIX_VENDOR_IETF,
-			.field_id = IPFIX_destinationIPv4Address,
-		},
+			.field_id = IPFIX_postNATSourceIPv4Address,
+		},	/* reply destination is after-SNAT source */
 	},
 	{
 		.type	= ULOGD_RET_UINT8,
@@ -292,7 +292,7 @@ static struct ulogd_key nfct_okeys[] = {
 		.name	= "reply.l4.sport",
 		.ipfix	= {
 			.vendor 	= IPFIX_VENDOR_IETF,
-			.field_id 	= IPFIX_sourceTransportPort,
+			.field_id 	= IPFIX_postNAPTDestinationTransportPort,
 		},
 	},
 	{
@@ -301,7 +301,7 @@ static struct ulogd_key nfct_okeys[] = {
 		.name	= "reply.l4.dport",
 		.ipfix	= {
 			.vendor 	= IPFIX_VENDOR_IETF,
-			.field_id 	= IPFIX_destinationTransportPort,
+			.field_id 	= IPFIX_postNAPTSourceTransportPort,
 		},
 	},
 	{
diff --git a/output/ipfix/ipfix.c b/output/ipfix/ipfix.c
index e0b3440..0ad34ec 100644
--- a/output/ipfix/ipfix.c
+++ b/output/ipfix/ipfix.c
@@ -26,7 +26,7 @@ struct ipfix_templ {
 
 /* Template fields modeled after vy_ipfix_data */
 static const struct ipfix_templ template = {
-	.num_templ_elements = 10,
+	.num_templ_elements = 14,
 	.templ_elements = {
 		{
 			.id = IPFIX_sourceIPv4Address,
@@ -37,6 +37,14 @@ static const struct ipfix_templ template = {
 			.len = sizeof(uint32_t)
 		},
 		{
+			.id = IPFIX_postNATSourceIPv4Address,
+			.len = sizeof(uint32_t)
+		},
+		{
+			.id = IPFIX_postNATDestinationIPv4Address,
+			.len = sizeof(uint32_t)
+		},
+		{
 			.id = IPFIX_packetTotalCount,
 			.len = sizeof(uint32_t)
 		},
@@ -61,13 +69,21 @@ static const struct ipfix_templ template = {
 			.len = sizeof(uint16_t)
 		},
 		{
+			.id = IPFIX_postNAPTSourceTransportPort,
+			.len = sizeof(uint16_t)
+		},
+		{
+			.id = IPFIX_postNAPTDestinationTransportPort,
+			.len = sizeof(uint16_t)
+		},
+		{
 			.id = IPFIX_protocolIdentifier,
 			.len = sizeof(uint8_t)
 		},
 		{
 			.id = IPFIX_applicationId,
 			.len = sizeof(uint32_t)
-		}
+		},
 	}
 };
 
diff --git a/output/ipfix/ipfix.h b/output/ipfix/ipfix.h
index b0f3ae6..f671ea6 100644
--- a/output/ipfix/ipfix.h
+++ b/output/ipfix/ipfix.h
@@ -59,12 +59,16 @@ struct ipfix_msg {
 struct vy_ipfix_data {
 	struct in_addr saddr;
 	struct in_addr daddr;
+	struct in_addr tsaddr;			/* translated source address, as read from the reply destination */
+	struct in_addr tdaddr;
 	uint32_t packets;
 	uint32_t bytes;
 	uint32_t start;				/* Unix time */
 	uint32_t end;				/* Unix time */
 	uint16_t sport;
 	uint16_t dport;
+	uint16_t tsport;
+	uint16_t tdport;
 	uint8_t l4_proto;
 	uint32_t aid;				/* Application ID */
 } __attribute__((packed));
diff --git a/output/ipfix/ulogd_output_IPFIX.c b/output/ipfix/ulogd_output_IPFIX.c
index 1c0f730..167ee9a 100644
--- a/output/ipfix/ulogd_output_IPFIX.c
+++ b/output/ipfix/ulogd_output_IPFIX.c
@@ -97,6 +97,8 @@ struct ipfix_priv {
 enum {
 	InIpSaddr = 0,
 	InIpDaddr,
+	InTIpSaddr,
+	InTIpDaddr,
 	InRawInPktCount,
 	InRawInPktLen,
 	InRawOutPktCount,
@@ -107,6 +109,8 @@ enum {
 	InFlowEndUsec,
 	InL4SPort,
 	InL4DPort,
+	InL4TSPort,
+	InL4TDPort,
 	InIpProto,
 	InCtMark
 };
@@ -120,6 +124,14 @@ static struct ulogd_key ipfix_in_keys[] = {
 			.type = ULOGD_RET_IPADDR,
 			.name = "orig.ip.daddr"
 		},
+		[InTIpSaddr] = {
+			.type = ULOGD_RET_IPADDR,
+			.name = "reply.ip.daddr"
+		},
+		[InTIpDaddr] = {
+			.type = ULOGD_RET_IPADDR,
+			.name = "reply.ip.saddr"
+		},
 		[InRawInPktCount] = {
 			.type = ULOGD_RET_UINT64,
 			.name = "orig.raw.pktcount"
@@ -160,6 +172,14 @@ static struct ulogd_key ipfix_in_keys[] = {
 			.type = ULOGD_RET_UINT16,
 			.name = "orig.l4.dport"
 		},
+		[InL4TSPort] = {
+			.type = ULOGD_RET_UINT16,
+			.name = "reply.l4.dport"
+		},
+		[InL4TDPort] = {
+			.type = ULOGD_RET_UINT16,
+			.name = "reply.l4.sport"
+		},
 		[InIpProto] = {
 			.type = ULOGD_RET_UINT8,
 			.name = "orig.ip.protocol"
@@ -419,7 +439,7 @@ static int ipfix_stop(struct ulogd_pluginstance *pi)
 static int ipfix_interp(struct ulogd_pluginstance *pi)
 {
 	struct ipfix_priv *priv = (struct ipfix_priv *) &pi->private;
-	char saddr[16], daddr[16], *send_template;
+	char saddr[16],tsaddr[16], daddr[16],tdaddr[16], *send_template;
 	struct vy_ipfix_data *data;
 	int oid, mtu, ret;
 
@@ -458,6 +478,8 @@ again:
 
 	data->saddr.s_addr = ikey_get_u32(&pi->input.keys[InIpSaddr]);
 	data->daddr.s_addr = ikey_get_u32(&pi->input.keys[InIpDaddr]);
+	data->tsaddr.s_addr = ikey_get_u32(&pi->input.keys[InTIpSaddr]);
+	data->tdaddr.s_addr = ikey_get_u32(&pi->input.keys[InTIpDaddr]);
 
 	data->packets = htonl((uint32_t) (ikey_get_u64(&pi->input.keys[InRawInPktCount])
 						+ ikey_get_u64(&pi->input.keys[InRawOutPktCount])));
@@ -470,6 +492,8 @@ again:
 	if (GET_FLAGS(pi->input.keys, InL4SPort) & ULOGD_RETF_VALID) {
 		data->sport = htons(ikey_get_u16(&pi->input.keys[InL4SPort]));
 		data->dport = htons(ikey_get_u16(&pi->input.keys[InL4DPort]));
+		data->tsport = htons(ikey_get_u16(&pi->input.keys[InL4TSPort]));
+		data->tdport = htons(ikey_get_u16(&pi->input.keys[InL4TDPort]));
 	}
 
 	data->aid = 0;

--ZGiS0Q5IWpPtfppv--
