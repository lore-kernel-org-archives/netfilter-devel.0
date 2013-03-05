From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: [PATCH] ulogd2: raw2packet_BASE changes
Date: Tue, 05 Mar 2013 12:48:11 +0000
Message-ID: <5135E98B.20409@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Core Team <netfilter-devel@vger.kernel.org>
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:59006 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab3CEMs1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Mar 2013 07:48:27 -0500
Received: by mail-wg0-f46.google.com with SMTP id fg15so5492756wgb.25
        for <netfilter-devel@vger.kernel.org>; Tue, 05 Mar 2013 04:48:26 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch makes it possible in the event of icmp destination-unreachable
type messages, all "related" connection properties to be made available
to the BASE raw2packet ulogd2 module for use as ulogd2 keys to registered
plugins.

Such keys are named as "o.X.Y", where "X" is the protocol used (tcp, udp
and so on), and "Y" is the property name in question.

All such properties vary depending on the protocol used for the "related"
connection.

Signed-off-by: Mr Dash Four <mr.dash.four@googlemail.com>
---
  filter/raw2packet/ulogd_raw2packet_BASE.c |  457 +++++++++++++++++++++++++----
  1 file changed, 396 insertions(+), 61 deletions(-)

diff --git a/filter/raw2packet/ulogd_raw2packet_BASE.c b/filter/raw2packet/ulogd_raw2packet_BASE.c
index 8dfe38e..071fd5a 100644
--- a/filter/raw2packet/ulogd_raw2packet_BASE.c
+++ b/filter/raw2packet/ulogd_raw2packet_BASE.c
@@ -114,6 +114,47 @@ enum output_keys {
  	KEY_SCTP_SPORT,
  	KEY_SCTP_DPORT,
  	KEY_SCTP_CSUM,
+	KEY_O_IP_SADDR,
+	KEY_O_IP_DADDR,
+	KEY_O_IP_PROTOCOL,
+	KEY_O_IP_TOS,
+	KEY_O_IP_TTL,
+	KEY_O_IP_TOTLEN,
+	KEY_O_IP_IHL,
+	KEY_O_IP_CSUM,
+	KEY_O_IP_ID,
+	KEY_O_IP_FRAGOFF,
+	KEY_O_TCP_SPORT,
+	KEY_O_TCP_DPORT,
+	KEY_O_TCP_SEQ,
+	KEY_O_TCP_ACKSEQ,
+	KEY_O_TCP_WINDOW,
+	KEY_O_TCP_OFFSET,
+	KEY_O_TCP_RESERVED,
+	KEY_O_TCP_URG,
+	KEY_O_TCP_URGP,
+	KEY_O_TCP_ACK,
+	KEY_O_TCP_PSH,
+	KEY_O_TCP_RST,
+	KEY_O_TCP_SYN,
+	KEY_O_TCP_FIN,
+	KEY_O_TCP_RES1,
+	KEY_O_TCP_RES2,
+	KEY_O_TCP_CSUM,
+	KEY_O_UDP_SPORT,
+	KEY_O_UDP_DPORT,
+	KEY_O_UDP_LEN,
+	KEY_O_UDP_CSUM,
+	KEY_O_ICMP_TYPE,
+	KEY_O_ICMP_CODE,
+	KEY_O_ICMP_ECHOID,
+	KEY_O_ICMP_ECHOSEQ,
+	KEY_O_ICMP_GATEWAY,
+	KEY_O_ICMP_FRAGMTU,
+	KEY_O_ICMP_CSUM,
+	KEY_O_SCTP_SPORT,
+	KEY_O_SCTP_DPORT,
+	KEY_O_SCTP_CSUM,

  };

@@ -524,39 +565,322 @@ static struct ulogd_key iphdr_rets[] = {
  		.flags = ULOGD_RETF_NONE,
  		.name = "sctp.csum",
  	},
+	[KEY_O_IP_SADDR] = {
+		.type = ULOGD_RET_IPADDR,
+		.flags = ULOGD_RETF_NONE,
+		.name = "o.ip.saddr",
+		.ipfix = {
+			.vendor = IPFIX_VENDOR_IETF,
+			.field_id = IPFIX_sourceIPv4Address,
+		},
+	},
+	[KEY_O_IP_DADDR] = {
+		.type = ULOGD_RET_IPADDR,
+		.flags = ULOGD_RETF_NONE,
+		.name = "o.ip.daddr",
+		.ipfix = {
+			.vendor = IPFIX_VENDOR_IETF,
+			.field_id = IPFIX_destinationIPv4Address,
+		},
+	},
+	[KEY_O_IP_PROTOCOL] = {
+		.type = ULOGD_RET_UINT8,
+		.flags = ULOGD_RETF_NONE,
+		.name = "o.ip.protocol",
+		.ipfix = {
+			.vendor = IPFIX_VENDOR_IETF,
+			.field_id = IPFIX_protocolIdentifier,
+		},
+	},
+	[KEY_O_IP_TOS] = {
+		.type = ULOGD_RET_UINT8,
+		.flags = ULOGD_RETF_NONE,
+		.name = "o.ip.tos",
+		.ipfix = {
+			.vendor = IPFIX_VENDOR_IETF,
+			.field_id = IPFIX_classOfServiceIPv4,
+		},
+	},
+	[KEY_O_IP_TTL] = {
+		.type = ULOGD_RET_UINT8,
+		.flags = ULOGD_RETF_NONE,
+		.name = "o.ip.ttl",
+		.ipfix = {
+			.vendor = IPFIX_VENDOR_IETF,
+			.field_id = IPFIX_ipTimeToLive,
+		},
+	},
+	[KEY_O_IP_TOTLEN] = {
+		.type = ULOGD_RET_UINT16,
+		.flags = ULOGD_RETF_NONE,
+		.name = "o.ip.totlen",
+		.ipfix = {
+			.vendor = IPFIX_VENDOR_IETF,
+			.field_id = IPFIX_totalLengthIPv4,
+		},
+	},
+	[KEY_O_IP_IHL] = {
+		.type = ULOGD_RET_UINT8,
+		.flags = ULOGD_RETF_NONE,
+		.name = "o.ip.ihl",
+		.ipfix = {
+			.vendor = IPFIX_VENDOR_IETF,
+			.field_id = IPFIX_internetHeaderLengthIPv4,
+		},
+	},
+	[KEY_O_IP_CSUM] = {
+		.type = ULOGD_RET_UINT16,
+		.flags = ULOGD_RETF_NONE,
+		.name = "o.ip.csum",
+	},
+	[KEY_O_IP_ID] = {
+		.type = ULOGD_RET_UINT16,
+		.flags = ULOGD_RETF_NONE,
+		.name = "o.ip.id",
+		.ipfix = {
+			.vendor = IPFIX_VENDOR_IETF,
+			.field_id = IPFIX_identificationIPv4,
+		},
+	},
+	[KEY_O_IP_FRAGOFF] = {
+		.type = ULOGD_RET_UINT16,
+		.flags = ULOGD_RETF_NONE,
+		.name = "o.ip.fragoff",
+		.ipfix = {
+			.vendor = IPFIX_VENDOR_IETF,
+			.field_id = IPFIX_fragmentOffsetIPv4,
+		},
+	},
+	[KEY_O_TCP_SPORT] = {
+		.type = ULOGD_RET_UINT16,
+		.flags = ULOGD_RETF_NONE,
+		.name = "o.tcp.sport",
+		.ipfix = {
+			.vendor = IPFIX_VENDOR_IETF,
+			.field_id = IPFIX_tcpSourcePort,
+		},
+	},
+	[KEY_O_TCP_DPORT] = {
+		.type = ULOGD_RET_UINT16,
+		.flags = ULOGD_RETF_NONE,
+		.name = "o.tcp.dport",
+		.ipfix = {
+			.vendor = IPFIX_VENDOR_IETF,
+			.field_id = IPFIX_tcpDestinationPort,
+		},
+	},
+	[KEY_O_TCP_SEQ] = {
+		.type = ULOGD_RET_UINT32,
+		.flags = ULOGD_RETF_NONE,
+		.name = "o.tcp.seq",
+		.ipfix = {
+			.vendor = IPFIX_VENDOR_IETF,
+			.field_id = IPFIX_tcpSequenceNumber,
+		},
+	},
+	[KEY_O_TCP_ACKSEQ] = {
+		.type = ULOGD_RET_UINT32,
+		.flags = ULOGD_RETF_NONE,
+		.name = "o.tcp.ackseq",
+		.ipfix = {
+			.vendor = IPFIX_VENDOR_IETF,
+			.field_id = IPFIX_tcpAcknowledgementNumber,
+		},
+	},
+	[KEY_O_TCP_OFFSET] = {
+		.type = ULOGD_RET_UINT8,
+		.flags = ULOGD_RETF_NONE,
+		.name = "o.tcp.offset",
+	},
+	[KEY_O_TCP_RESERVED] = {
+		.type = ULOGD_RET_UINT8,
+		.flags = ULOGD_RETF_NONE,
+		.name = "o.tcp.reserved",
+	},
+	[KEY_O_TCP_WINDOW] = {
+		.type = ULOGD_RET_UINT16,
+		.flags = ULOGD_RETF_NONE,
+		.name = "o.tcp.window",
+		.ipfix = {
+			.vendor = IPFIX_VENDOR_IETF,
+			.field_id = IPFIX_tcpWindowSize,
+		},
+	},
+	[KEY_O_TCP_URG] = {
+		.type = ULOGD_RET_BOOL,
+		.flags = ULOGD_RETF_NONE,
+		.name = "o.tcp.urg",
+	},
+	[KEY_O_TCP_URGP] = {
+		.type = ULOGD_RET_UINT16,
+		.flags = ULOGD_RETF_NONE,
+		.name = "o.tcp.urgp",
+		.ipfix = {
+			.vendor = IPFIX_VENDOR_IETF,
+			.field_id = IPFIX_tcpUrgentPointer,
+		},
+	},
+	[KEY_O_TCP_ACK] = {
+		.type = ULOGD_RET_BOOL,
+		.flags = ULOGD_RETF_NONE,
+		.name = "o.tcp.ack",
+	},
+	[KEY_O_TCP_PSH] = {
+		.type = ULOGD_RET_BOOL,
+		.flags = ULOGD_RETF_NONE,
+		.name = "o.tcp.psh",
+	},
+	[KEY_O_TCP_RST] = {
+		.type = ULOGD_RET_BOOL,
+		.flags = ULOGD_RETF_NONE,
+		.name = "o.tcp.rst",
+	},
+	[KEY_O_TCP_SYN] = {
+		.type = ULOGD_RET_BOOL,
+		.flags = ULOGD_RETF_NONE,
+		.name = "o.tcp.syn",
+	},
+	[KEY_O_TCP_FIN] = {
+		.type = ULOGD_RET_BOOL,
+		.flags = ULOGD_RETF_NONE,
+		.name = "o.tcp.fin",
+	},
+	[KEY_O_TCP_RES1] = {
+		.type = ULOGD_RET_BOOL,
+		.flags = ULOGD_RETF_NONE,
+		.name = "o.tcp.res1",
+	},
+	[KEY_O_TCP_RES2] = {
+		.type = ULOGD_RET_BOOL,
+		.flags = ULOGD_RETF_NONE,
+		.name = "o.tcp.res2",
+	},
+	[KEY_O_TCP_CSUM] = {
+		.type = ULOGD_RET_UINT16,
+		.flags = ULOGD_RETF_NONE,
+		.name = "o.tcp.csum",
+	},
+	[KEY_O_UDP_SPORT] = {
+		.type = ULOGD_RET_UINT16,
+		.flags = ULOGD_RETF_NONE,
+		.name = "o.udp.sport",
+		.ipfix = {
+			.vendor = IPFIX_VENDOR_IETF,
+			.field_id = IPFIX_udpSourcePort,
+		},
+	},
+	[KEY_O_UDP_DPORT] = {
+		.type = ULOGD_RET_UINT16,
+		.flags = ULOGD_RETF_NONE,
+		.name = "o.udp.dport",
+		.ipfix = {
+			.vendor = IPFIX_VENDOR_IETF,
+			.field_id = IPFIX_udpDestinationPort,
+		},
+	},
+	[KEY_O_UDP_LEN] = {
+		.type = ULOGD_RET_UINT16,
+		.flags = ULOGD_RETF_NONE,
+		.name = "o.udp.len",
+	},
+	[KEY_O_UDP_CSUM] = {
+		.type = ULOGD_RET_UINT16,
+		.flags = ULOGD_RETF_NONE,
+		.name = "o.udp.csum",
+	},
+	[KEY_O_ICMP_TYPE] = {
+		.type = ULOGD_RET_UINT8,
+		.flags = ULOGD_RETF_NONE,
+		.name = "o.icmp.type",
+		.ipfix = {
+			.vendor = IPFIX_VENDOR_IETF,
+			.field_id = IPFIX_icmpTypeIPv4,
+		},
+	},
+	[KEY_O_ICMP_CODE] = {
+		.type = ULOGD_RET_UINT8,
+		.flags = ULOGD_RETF_NONE,
+		.name = "o.icmp.code",
+		.ipfix = {
+			.vendor = IPFIX_VENDOR_IETF,
+			.field_id = IPFIX_icmpCodeIPv4,
+		},
+	},
+	[KEY_O_ICMP_ECHOID] = {
+		.type = ULOGD_RET_UINT16,
+		.flags = ULOGD_RETF_NONE,
+		.name = "o.icmp.echoid",
+	},
+	[KEY_O_ICMP_ECHOSEQ] = {
+		.type = ULOGD_RET_UINT16,
+		.flags = ULOGD_RETF_NONE,
+		.name = "o.icmp.echoseq",
+	},
+	[KEY_O_ICMP_GATEWAY] = {
+		.type = ULOGD_RET_IPADDR,
+		.flags = ULOGD_RETF_NONE,
+		.name = "o.icmp.gateway",
+	},
+	[KEY_O_ICMP_FRAGMTU] = {
+		.type = ULOGD_RET_UINT16,
+		.flags = ULOGD_RETF_NONE,
+		.name = "o.icmp.fragmtu",
+	},
+	[KEY_O_ICMP_CSUM] = {
+		.type = ULOGD_RET_UINT16,
+		.flags = ULOGD_RETF_NONE,
+		.name = "o.icmp.csum",
+	},
+	[KEY_O_SCTP_SPORT] = {
+		.type = ULOGD_RET_UINT16,
+		.flags = ULOGD_RETF_NONE,
+		.name = "o.sctp.sport",
+	},
+	[KEY_O_SCTP_DPORT] = {
+		.type = ULOGD_RET_UINT16,
+		.flags = ULOGD_RETF_NONE,
+		.name = "o.sctp.dport",
+	},
+	[KEY_O_SCTP_CSUM] = {
+		.type = ULOGD_RET_UINT32,
+		.flags = ULOGD_RETF_NONE,
+		.name = "o.sctp.csum",
+	},
  };

+#define recurse_key(key) recurse ? KEY_##key : KEY_O_##key
+
  /***********************************************************************
   * 			TCP HEADER
   ***********************************************************************/

  static int _interp_tcp(struct ulogd_pluginstance *pi, struct tcphdr *tcph,
-		       u_int32_t len)
+		       u_int32_t len, u_int32_t recurse)
  {
  	struct ulogd_key *ret = pi->output.keys;

  	if (len < sizeof(struct tcphdr))
  		return ULOGD_IRET_OK;
  	
-	okey_set_u16(&ret[KEY_TCP_SPORT], ntohs(tcph->source));
-	okey_set_u16(&ret[KEY_TCP_DPORT], ntohs(tcph->dest));
-	okey_set_u32(&ret[KEY_TCP_SEQ], ntohl(tcph->seq));
-	okey_set_u32(&ret[KEY_TCP_ACKSEQ], ntohl(tcph->ack_seq));
-	okey_set_u8(&ret[KEY_TCP_OFFSET], ntohs(tcph->doff));
-	okey_set_u8(&ret[KEY_TCP_RESERVED], ntohs(tcph->res1));
-	okey_set_u16(&ret[KEY_TCP_WINDOW], ntohs(tcph->window));
-
-	okey_set_b(&ret[KEY_TCP_URG], tcph->urg);
+	okey_set_u16(&ret[recurse_key(TCP_SPORT)], ntohs(tcph->source));
+	okey_set_u16(&ret[recurse_key(TCP_DPORT)], ntohs(tcph->dest));
+	okey_set_u32(&ret[recurse_key(TCP_SEQ)], ntohl(tcph->seq));
+	okey_set_u32(&ret[recurse_key(TCP_ACKSEQ)], ntohl(tcph->ack_seq));
+	okey_set_u8(&ret[recurse_key(TCP_OFFSET)], ntohs(tcph->doff));
+	okey_set_u8(&ret[recurse_key(TCP_RESERVED)], ntohs(tcph->res1));
+	okey_set_u16(&ret[recurse_key(TCP_WINDOW)], ntohs(tcph->window));
+
+	okey_set_b(&ret[recurse_key(TCP_URG)], tcph->urg);
  	if (tcph->urg)
-		okey_set_u16(&ret[KEY_TCP_URGP], ntohs(tcph->urg_ptr));
-	okey_set_b(&ret[KEY_TCP_ACK], tcph->ack);
-	okey_set_b(&ret[KEY_TCP_PSH], tcph->psh);
-	okey_set_b(&ret[KEY_TCP_RST], tcph->rst);
-	okey_set_b(&ret[KEY_TCP_SYN], tcph->syn);
-	okey_set_b(&ret[KEY_TCP_FIN], tcph->fin);
-	okey_set_b(&ret[KEY_TCP_RES1], tcph->res1);
-	okey_set_b(&ret[KEY_TCP_RES2], tcph->res2);
-	okey_set_u16(&ret[KEY_TCP_CSUM], ntohs(tcph->check));
+		okey_set_u16(&ret[recurse_key(TCP_URGP)], ntohs(tcph->urg_ptr));
+	okey_set_b(&ret[recurse_key(TCP_ACK)], tcph->ack);
+	okey_set_b(&ret[recurse_key(TCP_PSH)], tcph->psh);
+	okey_set_b(&ret[recurse_key(TCP_RST)], tcph->rst);
+	okey_set_b(&ret[recurse_key(TCP_SYN)], tcph->syn);
+	okey_set_b(&ret[recurse_key(TCP_FIN)], tcph->fin);
+	okey_set_b(&ret[recurse_key(TCP_RES1)], tcph->res1);
+	okey_set_b(&ret[recurse_key(TCP_RES2)], tcph->res2);
+	okey_set_u16(&ret[recurse_key(TCP_CSUM)], ntohs(tcph->check));
  	
  	return ULOGD_IRET_OK;
  }
@@ -566,7 +890,7 @@ static int _interp_tcp(struct ulogd_pluginstance *pi, struct tcphdr *tcph,
   ***********************************************************************/

  static int _interp_udp(struct ulogd_pluginstance *pi, struct udphdr *udph,
-		       u_int32_t len)
+		       u_int32_t len, u_int32_t recurse)
  		
  {
  	struct ulogd_key *ret = pi->output.keys;
@@ -574,10 +898,10 @@ static int _interp_udp(struct ulogd_pluginstance *pi, struct udphdr *udph,
  	if (len < sizeof(struct udphdr))
  		return ULOGD_IRET_OK;

-	okey_set_u16(&ret[KEY_UDP_SPORT], ntohs(udph->source));
-	okey_set_u16(&ret[KEY_UDP_DPORT], ntohs(udph->dest));
-	okey_set_u16(&ret[KEY_UDP_LEN], ntohs(udph->len));
-	okey_set_u16(&ret[KEY_UDP_CSUM], ntohs(udph->check));
+	okey_set_u16(&ret[recurse_key(UDP_SPORT)], ntohs(udph->source));
+	okey_set_u16(&ret[recurse_key(UDP_DPORT)], ntohs(udph->dest));
+	okey_set_u16(&ret[recurse_key(UDP_LEN)], ntohs(udph->len));
+	okey_set_u16(&ret[recurse_key(UDP_CSUM)], ntohs(udph->check));
  	
  	return ULOGD_IRET_OK;
  }
@@ -595,7 +919,7 @@ typedef struct sctphdr {
  } __attribute__((packed)) sctp_sctphdr_t;

  static int _interp_sctp(struct ulogd_pluginstance *pi, struct sctphdr *sctph,
-		       u_int32_t len)
+		       u_int32_t len, u_int32_t recurse)
  		
  {
  	struct ulogd_key *ret = pi->output.keys;
@@ -603,50 +927,60 @@ static int _interp_sctp(struct ulogd_pluginstance *pi, struct sctphdr *sctph,
  	if (len < sizeof(struct sctphdr))
  		return ULOGD_IRET_OK;

-	ret[KEY_SCTP_SPORT].u.value.ui16 = ntohs(sctph->source);
-	ret[KEY_SCTP_SPORT].flags |= ULOGD_RETF_VALID;
-	ret[KEY_SCTP_DPORT].u.value.ui16 = ntohs(sctph->dest);
-	ret[KEY_SCTP_DPORT].flags |= ULOGD_RETF_VALID;
-	ret[KEY_SCTP_CSUM].u.value.ui32 = ntohl(sctph->checksum);
-	ret[KEY_SCTP_CSUM].flags |= ULOGD_RETF_VALID;
+	ret[recurse_key(SCTP_SPORT)].u.value.ui16 = ntohs(sctph->source);
+	ret[recurse_key(SCTP_SPORT)].flags |= ULOGD_RETF_VALID;
+	ret[recurse_key(SCTP_DPORT)].u.value.ui16 = ntohs(sctph->dest);
+	ret[recurse_key(SCTP_DPORT)].flags |= ULOGD_RETF_VALID;
+	ret[recurse_key(SCTP_CSUM)].u.value.ui32 = ntohl(sctph->checksum);
+	ret[recurse_key(SCTP_CSUM)].flags |= ULOGD_RETF_VALID;
  	
  	return ULOGD_IRET_OK;
  }

+static int _interp_iphdr(struct ulogd_pluginstance *pi, struct iphdr *iph, u_int32_t len,
+			 u_int32_t recurse);
+
  /***********************************************************************
   * 			ICMP HEADER
   ***********************************************************************/

  static int _interp_icmp(struct ulogd_pluginstance *pi, struct icmphdr *icmph,
-			u_int32_t len)
+			u_int32_t len, u_int32_t recurse)
  {
  	struct ulogd_key *ret = pi->output.keys;

  	if (len < sizeof(struct icmphdr))
  		return ULOGD_IRET_OK;

-	okey_set_u8(&ret[KEY_ICMP_TYPE], icmph->type);
-	okey_set_u8(&ret[KEY_ICMP_CODE], icmph->code);
+	okey_set_u8(&ret[recurse_key(ICMP_TYPE)], icmph->type);
+	okey_set_u8(&ret[recurse_key(ICMP_CODE)], icmph->code);

  	switch (icmph->type) {
  	case ICMP_ECHO:
  	case ICMP_ECHOREPLY:
-		okey_set_u16(&ret[KEY_ICMP_ECHOID], ntohs(icmph->un.echo.id));
-		okey_set_u16(&ret[KEY_ICMP_ECHOSEQ],
+			okey_set_u16(&ret[recurse_key(ICMP_ECHOID)], ntohs(icmph->un.echo.id));
+			okey_set_u16(&ret[recurse_key(ICMP_ECHOSEQ)],
  			     ntohs(icmph->un.echo.sequence));
  		break;
  	case ICMP_REDIRECT:
  	case ICMP_PARAMETERPROB:
-		okey_set_u32(&ret[KEY_ICMP_GATEWAY], ntohl(icmph->un.gateway));
+			okey_set_u32(&ret[recurse_key(ICMP_GATEWAY)], ntohl(icmph->un.gateway));
  		break;
  	case ICMP_DEST_UNREACH:
-		if (icmph->code == ICMP_FRAG_NEEDED) {
-			okey_set_u16(&ret[KEY_ICMP_FRAGMTU],
+		case ICMP_SOURCE_QUENCH:
+		case ICMP_TIME_EXCEEDED: {
+			void *nexthdr = (u_int32_t *)icmph + 2;
+			len -= sizeof(struct icmphdr);
+			_interp_iphdr(pi, nexthdr, len, 0);
+			if (icmph->type == ICMP_DEST_UNREACH &&
+			    icmph->code == ICMP_FRAG_NEEDED) {
+				okey_set_u16(&ret[recurse_key(ICMP_FRAGMTU)],
  				     ntohs(icmph->un.frag.mtu));
  		}
  		break;
  	}
-	okey_set_u16(&ret[KEY_ICMP_CSUM], icmph->checksum);
+	}
+	okey_set_u16(&ret[recurse_key(ICMP_CSUM)], icmph->checksum);

  	return ULOGD_IRET_OK;
  }
@@ -704,40 +1038,39 @@ static int _interp_ahesp(struct ulogd_pluginstance *pi, void *protoh,
   * 			IP HEADER
   ***********************************************************************/

-static int _interp_iphdr(struct ulogd_pluginstance *pi, u_int32_t len)
+static int _interp_iphdr(struct ulogd_pluginstance *pi, struct iphdr *iph, u_int32_t len,
+			 u_int32_t recurse)
  {
  	struct ulogd_key *ret = pi->output.keys;
-	struct iphdr *iph =
-		ikey_get_ptr(&pi->input.keys[INKEY_RAW_PCKT]);
  	void *nexthdr = (u_int32_t *)iph + iph->ihl;

  	if (len < sizeof(struct iphdr) || len <= (u_int32_t)(iph->ihl * 4))
  		return ULOGD_IRET_OK;
  	len -= iph->ihl * 4;

-	okey_set_u32(&ret[KEY_IP_SADDR], iph->saddr);
-	okey_set_u32(&ret[KEY_IP_DADDR], iph->daddr);
-	okey_set_u8(&ret[KEY_IP_PROTOCOL], iph->protocol);
-	okey_set_u8(&ret[KEY_IP_TOS], iph->tos);
-	okey_set_u8(&ret[KEY_IP_TTL], iph->ttl);
-	okey_set_u16(&ret[KEY_IP_TOTLEN], ntohs(iph->tot_len));
-	okey_set_u8(&ret[KEY_IP_IHL], iph->ihl);
-	okey_set_u16(&ret[KEY_IP_CSUM], ntohs(iph->check));
-	okey_set_u16(&ret[KEY_IP_ID], ntohs(iph->id));
-	okey_set_u16(&ret[KEY_IP_FRAGOFF], ntohs(iph->frag_off));
+	okey_set_u32(&ret[recurse_key(IP_SADDR)], iph->saddr);
+	okey_set_u32(&ret[recurse_key(IP_DADDR)], iph->daddr);
+	okey_set_u8(&ret[recurse_key(IP_PROTOCOL)], iph->protocol);
+	okey_set_u8(&ret[recurse_key(IP_TOS)], iph->tos);
+	okey_set_u8(&ret[recurse_key(IP_TTL)], iph->ttl);
+	okey_set_u16(&ret[recurse_key(IP_TOTLEN)], ntohs(iph->tot_len));
+	okey_set_u8(&ret[recurse_key(IP_IHL)], iph->ihl);
+	okey_set_u16(&ret[recurse_key(IP_CSUM)], ntohs(iph->check));
+	okey_set_u16(&ret[recurse_key(IP_ID)], ntohs(iph->id));
+	okey_set_u16(&ret[recurse_key(IP_FRAGOFF)], ntohs(iph->frag_off));

  	switch (iph->protocol) {
  	case IPPROTO_TCP:
-		_interp_tcp(pi, nexthdr, len);
+		_interp_tcp(pi, nexthdr, len, recurse);
  		break;
  	case IPPROTO_UDP:
-		_interp_udp(pi, nexthdr, len);
+		_interp_udp(pi, nexthdr, len, recurse);
  		break;
  	case IPPROTO_ICMP:
-		_interp_icmp(pi, nexthdr, len);
+		_interp_icmp(pi, nexthdr, len, recurse);
  		break;
  	case IPPROTO_SCTP:
-		_interp_sctp(pi, nexthdr, len);
+		_interp_sctp(pi, nexthdr, len, recurse);
  		break;
  	case IPPROTO_AH:
  	case IPPROTO_ESP:
@@ -864,10 +1197,10 @@ static int _interp_ipv6hdr(struct ulogd_pluginstance *pi, u_int32_t len)

  	switch (curhdr) {
  	case IPPROTO_TCP:
-		_interp_tcp(pi, (void *)ipv6h + ptr, len);
+		_interp_tcp(pi, (void *)ipv6h + ptr, len, 0);
  		break;
  	case IPPROTO_UDP:
-		_interp_udp(pi, (void *)ipv6h + ptr, len);
+		_interp_udp(pi, (void *)ipv6h + ptr, len, 0);
  		break;
  	case IPPROTO_ICMPV6:
  		_interp_icmpv6(pi, (void *)ipv6h + ptr, len);
@@ -914,7 +1247,8 @@ static int _interp_bridge(struct ulogd_pluginstance *pi, u_int32_t len)

  	switch (proto) {
  	case ETH_P_IP:
-		_interp_iphdr(pi, len);
+		_interp_iphdr(pi, ikey_get_ptr(&pi->input.keys[INKEY_RAW_PCKT]),
+			      len, 1);
  		break;
  	case ETH_P_IPV6:
  		_interp_ipv6hdr(pi, len);
@@ -940,7 +1274,8 @@ static int _interp_pkt(struct ulogd_pluginstance *pi)

  	switch (family) {
  	case AF_INET:
-		return _interp_iphdr(pi, len);
+		return _interp_iphdr(pi, ikey_get_ptr(&pi->input.keys[INKEY_RAW_PCKT]),
+				     len, 1);
  	case AF_INET6:
  		return _interp_ipv6hdr(pi, len);
  	case AF_BRIDGE:



