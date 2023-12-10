X-Greylist: delayed 1500 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 10 Dec 2023 12:42:08 PST
Received: from pepin.polanet.pl (pepin.polanet.pl [193.34.52.2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4AE6D7
	for <netfilter-devel@vger.kernel.org>; Sun, 10 Dec 2023 12:42:08 -0800 (PST)
Date: Sun, 10 Dec 2023 21:17:05 +0100
From: Tomasz Pala <gotar@polanet.pl>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH ulogd] log NAT events using IPFIX
Message-ID: <20231210201705.GA16025@polanet.pl>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="TB36FDmn/VVEgNH/"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline

Hello,

current IPFIX implementation has some deficiencies making it unsuitable
for NAT logging:

1. doesn't send postNAT addresses nor ports,
2. uses IPFIX_flowStartSeconds and IPFIX_flowEndSeconds [150 and 151],
which don't expose full resolution available and are apparently not
handled by nfdump.


Ad. 1 - I couldn't find more appropriate keys than reply.*, so I've used
them with reversed meaning (reply.ip.daddr should match our postNAT src).

Ad. 2 - IPFIX_flowStartMilliSeconds and IPFIX_flowEndMilliSeconds [152 and 153]
occupy 4*2 bytes more, but deliver ms precision and are logged by nfdump/nfcapd
compiled with --enable-nsel: "fmt: %nsa:%nsp [%nsap] => %nda:%ndp [%ndap]"

https://github.com/phaag/nfdump/issues/36

The patch should be self-explanatory, but please review it.


There is one workaround for external tools implemented:

	if (!end) end = start;  /* nfcapd doesn't record start time without end timestamp... this is a workaround for logging new connections */

- this should be resolved in nfdump, but such flawed logic could be
implemented in other analyzers as well.
In the simplest form NAT events are expected to be logged after the
connection terminates, with all the accounting data settled, but
existing connections are sometimes also logged during their existence
for accounting.

My use-case is logging both:
NF_NETLINK_CONNTRACK_NEW and
NF_NETLINK_CONNTRACK_DESTROY
events for auditing purposes (law enforced), so event (not: delivery) timing is a must.

While NEW connections are obviously not finished yet, there's no end
timestamp and nfdump ignores the start timestamp as well.

regards
-- 
Tomasz Pala <gotar@pld-linux.org>

--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: attachment; filename="ulogd2-NEL.patch"

diff --git a/README b/README
index 7e56149..41d70d0 100644
--- a/README
+++ b/README
@@ -1,7 +1,7 @@
 Userspace logging daemon for netfilter/iptables
 
-Project Homepage: http://www.gnumonks.org/projects/ulogd
-Mailinglist: http://lists.gnumonks.org/mailman/listinfo/ulogd/
+Project Homepage: https://www.netfilter.org/projects/ulogd/
+Mailinglist: https://marc.info/?l=netfilter
 
 This is just a short README, pleaes see the more extensive documentation
 in the doc/ subdirectory.
diff --git a/include/ulogd/ipfix_protocol.h b/include/ulogd/ipfix_protocol.h
index 01dd96a..941a67a 100644
--- a/include/ulogd/ipfix_protocol.h
+++ b/include/ulogd/ipfix_protocol.h
@@ -39,10 +39,11 @@ struct ipfix_vendor_field {
 };
 
 /* Information Element Identifiers as of draft-ietf-ipfix-info-11.txt */
+/* https://www.iana.org/assignments/ipfix/ipfix.xhtml */
 enum {
 	IPFIX_octetDeltaCount		= 1,
 	IPFIX_packetDeltaCount		= 2,
-	/* reserved */
+	/* deltaFlowCount */
 	IPFIX_protocolIdentifier	= 4,
 	IPFIX_classOfServiceIPv4	= 5,
 	IPFIX_tcpControlBits		= 6,
@@ -73,24 +74,24 @@ enum {
 	IPFIX_flowLabelIPv6		= 31,
 	IPFIX_icmpTypeCodeIPv4		= 32,
 	IPFIX_igmpType			= 33,
-	/* reserved */
-	/* reserved */
+	/* samplingInterval */
+	/* samplingAlgorithm */
 	IPFIX_flowActiveTimeOut		= 36,
 	IPFIX_flowInactiveTimeout	= 37,
-	/* reserved */
-	/* reserved */
+	/* engineType */
+	/* engineId */
 	IPFIX_exportedOctetTotalCount	= 40,
 	IPFIX_exportedMessageTotalCount	= 41,
 	IPFIX_exportedFlowTotalCount	= 42,
-	/* reserved */
+	/* ipv4RouterSc */
 	IPFIX_sourceIPv4Prefix		= 44,
 	IPFIX_destinationIPv4Prefix	= 45,
 	IPFIX_mplsTopLabelType		= 46,
 	IPFIX_mplsTopLabelIPv4Address	= 47,
-	/* reserved */
-	/* reserved */
-	/* reserved */
-	/* reserved */
+	/* samplerId */
+	/* samplerMode */
+	/* samplerRandomInterval */
+	/* classId */
 	IPFIX_minimumTtl		= 52,
 	IPFIX_maximumTtl		= 53,
 	IPFIX_identificationIPv4	= 54,
@@ -100,7 +101,7 @@ enum {
 	IPFIX_vlanId			= 58,
 	IPFIX_postVlanId		= 59,
 	IPFIX_ipVersion			= 60,
-	/* reserved */
+	/* flowDirection */
 	IPFIX_ipNextHopIPv6Address	= 62,
 	IPFIX_bgpNexthopIPv6Address	= 63,
 	IPFIX_ipv6ExtensionHeaders	= 64,
@@ -121,15 +122,30 @@ enum {
 	IPFIX_mplsLabelStackEntry10	= 79,
 	IPFIX_destinationMacAddress	= 80,
 	IPFIX_postSourceMacAddress	= 81,
-	/* reserved */
-	/* reserved */
-	/* reserved */
+	/* interfaceName */
+	/* interfaceDescription */
+	/* samplerName */
 	IPFIX_octetTotalCount		= 85,
 	IPFIX_packetTotalCount		= 86,
-	/* reserved */
+	/* flagsAndSamplerId */
 	IPFIX_fragmentOffsetIPv4	= 88,
-	/* reserved */
+	/* forwardingStatus */
+	/*	mplsVpnRouteDistinguisher
+		mplsTopLabelPrefixLength
+		srcTrafficIndex
+		dstTrafficIndex
+		applicationDescription	*/
 	IPFIX_applicationId		= 95,
+	/*	applicationName
+		Assigned for NetFlow v9 compatibility
+		postIpDiffServCodePoint
+		plicationFactor
+		className
+		classificationEngineId
+		layer2packetSectionOffset
+		layer2packetSectionSize
+		layer2packetSectionData
+	105-127	Assigned for NetFlow v9 compatibility	*/
 	IPFIX_bgpNextAdjacentAsNumber	= 128,
 	IPFIX_bgpPrevAdjacentAsNumber	= 129,
 	IPFIX_exporterIPv4Address	= 130,
@@ -213,10 +229,54 @@ enum {
 	IPFIX_ipv4Options		= 208,
 	IPFIX_tcpOptions		= 209,
 	IPFIX_paddingOctets		= 210,
-	/* reserved */
-	/* reserved */
+	/* collectorIPv4Address */
+	/* collectorIPv6Address */
 	IPFIX_headerLengthIPv4		= 213,
 	IPFIX_mplsPayloadLength		= 214,
+	/*	exportTransportProtocol
+		collectorTransportPort
+		exporterTransportPort
+		tcpSynTotalCount
+		tcpFinTotalCount
+		tcpRstTotalCount
+		tcpPshTotalCount
+		tcpAckTotalCount
+		tcpUrgTotalCount
+		ipTotalLength	*/
+	IPFIX_postNATSourceIPv4Address	= 225,
+	IPFIX_postNATDestinationIPv4Address	= 226,
+	IPFIX_postNAPTSourceTransportPort	= 227,
+	IPFIX_postNAPTDestinationTransportPort	= 228,
+	/*	natOriginatingAddressRealm
+		natEvent
+		initiatorOctets
+		responderOctets
+		firewallEvent
+		ingressVRFID
+		egressVRFID
+		VRFname
+		postMplsTopLabelExp
+		tcpWindowScale
+		biflowDirection
+		ethernetHeaderLength
+		ethernetPayloadLength
+		ethernetTotalLength
+		dot1qVlanId
+		dot1qPriority
+		dot1qCustomerVlanId
+		dot1qCustomerPriority
+		metroEvcId
+		metroEvcType
+		pseudoWireId
+		pseudoWireType
+		pseudoWireControlWord
+		ingressPhysicalInterface
+		egressPhysicalInterface
+		postDot1qVlanId
+		postDot1qCustomerVlanId
+		ethernetType
+		postIpPrecedence
+		collectionTimeMilliseconds	*/
 };
 
 /* Information elements of the netfilter vendor id */
diff --git a/input/flow/ulogd_inpflow_NFCT.c b/input/flow/ulogd_inpflow_NFCT.c
index 899b7e3..8ed2210 100644
--- a/input/flow/ulogd_inpflow_NFCT.c
+++ b/input/flow/ulogd_inpflow_NFCT.c
@@ -262,19 +262,19 @@ static struct ulogd_key nfct_okeys[] = {
 	{
 		.type 	= ULOGD_RET_IPADDR,
 		.flags 	= ULOGD_RETF_NONE,
-		.name	= "reply.ip.saddr",
+		.name	= "reply.ip.saddr",	/* reply source is supposed to be my after-DNAT destination */
 		.ipfix	= {
 			.vendor = IPFIX_VENDOR_IETF,
-			.field_id = IPFIX_sourceIPv4Address,
+			.field_id = IPFIX_postNATDestinationIPv4Address,
 		},
 	},
 	{
 		.type	= ULOGD_RET_IPADDR,
 		.flags	= ULOGD_RETF_NONE,
-		.name	= "reply.ip.daddr",
+		.name	= "reply.ip.daddr",	/* reply destination is my after-SNAT source */
 		.ipfix	= {
 			.vendor = IPFIX_VENDOR_IETF,
-			.field_id = IPFIX_destinationIPv4Address,
+			.field_id = IPFIX_postNATSourceIPv4Address,
 		},
 	},
 	{
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
@@ -379,10 +379,10 @@ static struct ulogd_key nfct_okeys[] = {
 		.type 	= ULOGD_RET_UINT32,
 		.flags 	= ULOGD_RETF_NONE,
 		.name	= "flow.start.usec",
-		.ipfix	= {
+	/*	.ipfix	= {
 			.vendor		= IPFIX_VENDOR_IETF,
-			.field_id	= IPFIX_flowStartMicroSeconds,
-		},
+			.field_id	= IPFIX_flowStartMicroSeconds,	-- this entry expects absolute total value, not the subsecond remainder
+		},	*/
 	},
 	{
 		.type	= ULOGD_RET_UINT32,
@@ -397,10 +397,10 @@ static struct ulogd_key nfct_okeys[] = {
 		.type	= ULOGD_RET_UINT32,
 		.flags	= ULOGD_RETF_NONE,
 		.name	= "flow.end.usec",
-		.ipfix	= {
+	/*	.ipfix	= {
 			.vendor		= IPFIX_VENDOR_IETF,
-			.field_id	= IPFIX_flowEndSeconds,
-		},
+			.field_id	= IPFIX_flowEndMicroSeconds,	-- this entry expects absolute total value, not the subsecond remainder
+		},	*/
 	},
 	{
 		.type	= ULOGD_RET_UINT8,
diff --git a/output/ipfix/ipfix.c b/output/ipfix/ipfix.c
index e0b3440..90f8b37 100644
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
@@ -37,22 +37,30 @@ static const struct ipfix_templ template = {
 			.len = sizeof(uint32_t)
 		},
 		{
-			.id = IPFIX_packetTotalCount,
+			.id = IPFIX_postNATSourceIPv4Address,
 			.len = sizeof(uint32_t)
 		},
 		{
-			.id = IPFIX_octetTotalCount,
+			.id = IPFIX_postNATDestinationIPv4Address,
 			.len = sizeof(uint32_t)
 		},
 		{
-			.id = IPFIX_flowStartSeconds,
+			.id = IPFIX_packetTotalCount,
 			.len = sizeof(uint32_t)
 		},
 		{
-			.id = IPFIX_flowEndSeconds,
+			.id = IPFIX_octetTotalCount,
 			.len = sizeof(uint32_t)
 		},
 		{
+			.id = IPFIX_flowStartMilliSeconds,
+			.len = sizeof(uint64_t)	/* better resolution, handled by nfdump */
+		},
+		{
+			.id = IPFIX_flowEndMilliSeconds,
+			.len = sizeof(uint64_t)	/* high || low */
+		},
+		{
 			.id = IPFIX_sourceTransportPort,
 			.len = sizeof(uint16_t)
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
index b0f3ae6..2de9572 100644
--- a/output/ipfix/ipfix.h
+++ b/output/ipfix/ipfix.h
@@ -59,12 +59,18 @@ struct ipfix_msg {
 struct vy_ipfix_data {
 	struct in_addr saddr;
 	struct in_addr daddr;
+	struct in_addr tsaddr;			/* translated source address, as read from the reply destination */
+	struct in_addr tdaddr;
 	uint32_t packets;
 	uint32_t bytes;
-	uint32_t start;				/* Unix time */
-	uint32_t end;				/* Unix time */
+	uint32_t start_high;			/* Unix time * 1000 */
+	uint32_t start_low;
+	uint32_t end_high;
+	uint32_t end_low;
 	uint16_t sport;
 	uint16_t dport;
+	uint16_t tsport;
+	uint16_t tdport;
 	uint8_t l4_proto;
 	uint32_t aid;				/* Application ID */
 } __attribute__((packed));
diff --git a/output/ipfix/ulogd_output_IPFIX.c b/output/ipfix/ulogd_output_IPFIX.c
index 1c0f730..8f1dde3 100644
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
@@ -419,7 +439,8 @@ static int ipfix_stop(struct ulogd_pluginstance *pi)
 static int ipfix_interp(struct ulogd_pluginstance *pi)
 {
 	struct ipfix_priv *priv = (struct ipfix_priv *) &pi->private;
-	char saddr[16], daddr[16], *send_template;
+	char saddr[16],tsaddr[16], daddr[16],tdaddr[16], *send_template;
+	uint64_t start, end;
 	struct vy_ipfix_data *data;
 	int oid, mtu, ret;
 
@@ -458,18 +479,27 @@ again:
 
 	data->saddr.s_addr = ikey_get_u32(&pi->input.keys[InIpSaddr]);
 	data->daddr.s_addr = ikey_get_u32(&pi->input.keys[InIpDaddr]);
+	data->tsaddr.s_addr = ikey_get_u32(&pi->input.keys[InTIpSaddr]);
+	data->tdaddr.s_addr = ikey_get_u32(&pi->input.keys[InTIpDaddr]);
 
 	data->packets = htonl((uint32_t) (ikey_get_u64(&pi->input.keys[InRawInPktCount])
 						+ ikey_get_u64(&pi->input.keys[InRawOutPktCount])));
 	data->bytes = htonl((uint32_t) (ikey_get_u64(&pi->input.keys[InRawInPktLen])
 						+ ikey_get_u64(&pi->input.keys[InRawOutPktLen])));
 
-	data->start = htonl(ikey_get_u32(&pi->input.keys[InFlowStartSec]));
-	data->end = htonl(ikey_get_u32(&pi->input.keys[InFlowEndSec]));
+	start = (uint64_t)ikey_get_u32(&pi->input.keys[InFlowStartSec]) *1000 + ikey_get_u32(&pi->input.keys[InFlowStartUsec])/1000;
+	end   = (uint64_t)ikey_get_u32(&pi->input.keys[InFlowEndSec])   *1000 + ikey_get_u32(&pi->input.keys[InFlowEndUsec])/1000;
+	data->start_low = htonl((uint32_t)(start & 0xFFFFFFFFUL));
+	data->start_high = htonl(start >> 32);
+	if (!end) end = start;	/* nfcapd doesn't record start time without end timestamp... this is a workaround for logging new connections */
+	data->end_low = htonl((uint32_t)(end & 0xFFFFFFFFUL));
+	data->end_high = htonl(end >> 32);
 
 	if (GET_FLAGS(pi->input.keys, InL4SPort) & ULOGD_RETF_VALID) {
 		data->sport = htons(ikey_get_u16(&pi->input.keys[InL4SPort]));
 		data->dport = htons(ikey_get_u16(&pi->input.keys[InL4DPort]));
+		data->tsport = htons(ikey_get_u16(&pi->input.keys[InL4TSPort]));
+		data->tdport = htons(ikey_get_u16(&pi->input.keys[InL4TDPort]));
 	}
 
 	data->aid = 0;
@@ -478,11 +508,13 @@ again:
 
 	data->l4_proto = ikey_get_u8(&pi->input.keys[InIpProto]);
 
-	ulogd_log(ULOGD_DEBUG, "Got new packet (packets = %u, bytes = %u, flow = (%u, %u), saddr = %s, daddr = %s, sport = %u, dport = %u)\n",
-		  ntohl(data->packets), ntohl(data->bytes), ntohl(data->start), ntohl(data->end),
+	ulogd_log(ULOGD_DEBUG, "Got new packet (packets = %u, bytes = %u, flow = (%u:%u, %u:%u), saddr = %s/%s, daddr = %s/%s, sport = %u/%u, dport = %u/%u)\n",
+		  ntohl(data->packets), ntohl(data->bytes), ntohl(data->start_high),ntohl(data->start_low), ntohl(data->end_high),ntohl(data->end_low),
 		  inet_ntop(AF_INET, &data->saddr.s_addr, saddr, sizeof(saddr)),
+		  inet_ntop(AF_INET, &data->tsaddr.s_addr, tsaddr, sizeof(tsaddr)),
 		  inet_ntop(AF_INET, &data->daddr.s_addr, daddr, sizeof(daddr)),
-		  ntohs(data->sport), ntohs(data->dport));
+		  inet_ntop(AF_INET, &data->tdaddr.s_addr, tdaddr, sizeof(tdaddr)),
+		  ntohs(data->sport),ntohs(data->tsport), ntohs(data->dport),ntohs(data->tdport));
 
 	if ((ret = send_msgs(pi)) < 0)
 		return ret;

--TB36FDmn/VVEgNH/--
