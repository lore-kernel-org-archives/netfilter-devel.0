From: Eric Leblond <eric@regit.org>
Subject: Re: [PATCH] ulogd2: raw2packet_BASE changes
Date: Thu, 07 Mar 2013 08:58:15 +0100
Message-ID: <1362643095.6485.24.camel@tiger2>
References: <5135E98B.20409@googlemail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-vaLiGzfTI7I36bISe1SS"
Cc: Netfilter Core Team <netfilter-devel@vger.kernel.org>
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:36705 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138Ab3CGH6z (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Mar 2013 02:58:55 -0500
In-Reply-To: <5135E98B.20409@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-vaLiGzfTI7I36bISe1SS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

Thanks a lot for this patch.

On Tue, 2013-03-05 at 12:48 +0000, Mr Dash Four wrote:
> This patch makes it possible in the event of icmp destination-unreachable
> type messages, all "related" connection properties to be made available
> to the BASE raw2packet ulogd2 module for use as ulogd2 keys to registered
> plugins.
>=20
> Such keys are named as "o.X.Y", where "X" is the protocol used (tcp, udp
> and so on), and "Y" is the property name in question.
>=20
> All such properties vary depending on the protocol used for the "related"
> connection.

It is an interesting work. The information contained in these messages
are really meaningful and they need to be contained somewhere. I'm
wondering if it is not more convenient to simply pass a field with raw
data to the stack and have it used as binary in output plugins.
This way, we will treat all cases (I mean all protocols, ipsec or gre
are not supported in your patch) and the impact on the rest of the
plugins will be smaller.
I really fear changes on all output plugins will be huge without
handling all cases.

This will put work on interface and maybe it is a bit too much for them.
If we consider the problem from an admin point of view the most
meaningful information is the tuple (IP src and dest, proto, src and dst
port) the rest is a bit too much.

Considering this, I will not accept this patch but I will be happy with
a version exporting the binary information and some selected fields.

BR,

>=20
> Signed-off-by: Mr Dash Four <mr.dash.four@googlemail.com>
> ---
>   filter/raw2packet/ulogd_raw2packet_BASE.c |  457 ++++++++++++++++++++++=
+++----
>   1 file changed, 396 insertions(+), 61 deletions(-)
>=20
> diff --git a/filter/raw2packet/ulogd_raw2packet_BASE.c b/filter/raw2packe=
t/ulogd_raw2packet_BASE.c
> index 8dfe38e..071fd5a 100644
> --- a/filter/raw2packet/ulogd_raw2packet_BASE.c
> +++ b/filter/raw2packet/ulogd_raw2packet_BASE.c
> @@ -114,6 +114,47 @@ enum output_keys {
>   	KEY_SCTP_SPORT,
>   	KEY_SCTP_DPORT,
>   	KEY_SCTP_CSUM,
> +	KEY_O_IP_SADDR,
> +	KEY_O_IP_DADDR,
> +	KEY_O_IP_PROTOCOL,
> +	KEY_O_IP_TOS,
> +	KEY_O_IP_TTL,
> +	KEY_O_IP_TOTLEN,
> +	KEY_O_IP_IHL,
> +	KEY_O_IP_CSUM,
> +	KEY_O_IP_ID,
> +	KEY_O_IP_FRAGOFF,
> +	KEY_O_TCP_SPORT,
> +	KEY_O_TCP_DPORT,
> +	KEY_O_TCP_SEQ,
> +	KEY_O_TCP_ACKSEQ,
> +	KEY_O_TCP_WINDOW,
> +	KEY_O_TCP_OFFSET,
> +	KEY_O_TCP_RESERVED,
> +	KEY_O_TCP_URG,
> +	KEY_O_TCP_URGP,
> +	KEY_O_TCP_ACK,
> +	KEY_O_TCP_PSH,
> +	KEY_O_TCP_RST,
> +	KEY_O_TCP_SYN,
> +	KEY_O_TCP_FIN,
> +	KEY_O_TCP_RES1,
> +	KEY_O_TCP_RES2,
> +	KEY_O_TCP_CSUM,
> +	KEY_O_UDP_SPORT,
> +	KEY_O_UDP_DPORT,
> +	KEY_O_UDP_LEN,
> +	KEY_O_UDP_CSUM,
> +	KEY_O_ICMP_TYPE,
> +	KEY_O_ICMP_CODE,
> +	KEY_O_ICMP_ECHOID,
> +	KEY_O_ICMP_ECHOSEQ,
> +	KEY_O_ICMP_GATEWAY,
> +	KEY_O_ICMP_FRAGMTU,
> +	KEY_O_ICMP_CSUM,
> +	KEY_O_SCTP_SPORT,
> +	KEY_O_SCTP_DPORT,
> +	KEY_O_SCTP_CSUM,
>=20
>   };
>=20
> @@ -524,39 +565,322 @@ static struct ulogd_key iphdr_rets[] =3D {
>   		.flags =3D ULOGD_RETF_NONE,
>   		.name =3D "sctp.csum",
>   	},
> +	[KEY_O_IP_SADDR] =3D {
> +		.type =3D ULOGD_RET_IPADDR,
> +		.flags =3D ULOGD_RETF_NONE,
> +		.name =3D "o.ip.saddr",
> +		.ipfix =3D {
> +			.vendor =3D IPFIX_VENDOR_IETF,
> +			.field_id =3D IPFIX_sourceIPv4Address,
> +		},
> +	},
> +	[KEY_O_IP_DADDR] =3D {
> +		.type =3D ULOGD_RET_IPADDR,
> +		.flags =3D ULOGD_RETF_NONE,
> +		.name =3D "o.ip.daddr",
> +		.ipfix =3D {
> +			.vendor =3D IPFIX_VENDOR_IETF,
> +			.field_id =3D IPFIX_destinationIPv4Address,
> +		},
> +	},
> +	[KEY_O_IP_PROTOCOL] =3D {
> +		.type =3D ULOGD_RET_UINT8,
> +		.flags =3D ULOGD_RETF_NONE,
> +		.name =3D "o.ip.protocol",
> +		.ipfix =3D {
> +			.vendor =3D IPFIX_VENDOR_IETF,
> +			.field_id =3D IPFIX_protocolIdentifier,
> +		},
> +	},
> +	[KEY_O_IP_TOS] =3D {
> +		.type =3D ULOGD_RET_UINT8,
> +		.flags =3D ULOGD_RETF_NONE,
> +		.name =3D "o.ip.tos",
> +		.ipfix =3D {
> +			.vendor =3D IPFIX_VENDOR_IETF,
> +			.field_id =3D IPFIX_classOfServiceIPv4,
> +		},
> +	},
> +	[KEY_O_IP_TTL] =3D {
> +		.type =3D ULOGD_RET_UINT8,
> +		.flags =3D ULOGD_RETF_NONE,
> +		.name =3D "o.ip.ttl",
> +		.ipfix =3D {
> +			.vendor =3D IPFIX_VENDOR_IETF,
> +			.field_id =3D IPFIX_ipTimeToLive,
> +		},
> +	},
> +	[KEY_O_IP_TOTLEN] =3D {
> +		.type =3D ULOGD_RET_UINT16,
> +		.flags =3D ULOGD_RETF_NONE,
> +		.name =3D "o.ip.totlen",
> +		.ipfix =3D {
> +			.vendor =3D IPFIX_VENDOR_IETF,
> +			.field_id =3D IPFIX_totalLengthIPv4,
> +		},
> +	},
> +	[KEY_O_IP_IHL] =3D {
> +		.type =3D ULOGD_RET_UINT8,
> +		.flags =3D ULOGD_RETF_NONE,
> +		.name =3D "o.ip.ihl",
> +		.ipfix =3D {
> +			.vendor =3D IPFIX_VENDOR_IETF,
> +			.field_id =3D IPFIX_internetHeaderLengthIPv4,
> +		},
> +	},
> +	[KEY_O_IP_CSUM] =3D {
> +		.type =3D ULOGD_RET_UINT16,
> +		.flags =3D ULOGD_RETF_NONE,
> +		.name =3D "o.ip.csum",
> +	},
> +	[KEY_O_IP_ID] =3D {
> +		.type =3D ULOGD_RET_UINT16,
> +		.flags =3D ULOGD_RETF_NONE,
> +		.name =3D "o.ip.id",
> +		.ipfix =3D {
> +			.vendor =3D IPFIX_VENDOR_IETF,
> +			.field_id =3D IPFIX_identificationIPv4,
> +		},
> +	},
> +	[KEY_O_IP_FRAGOFF] =3D {
> +		.type =3D ULOGD_RET_UINT16,
> +		.flags =3D ULOGD_RETF_NONE,
> +		.name =3D "o.ip.fragoff",
> +		.ipfix =3D {
> +			.vendor =3D IPFIX_VENDOR_IETF,
> +			.field_id =3D IPFIX_fragmentOffsetIPv4,
> +		},
> +	},
> +	[KEY_O_TCP_SPORT] =3D {
> +		.type =3D ULOGD_RET_UINT16,
> +		.flags =3D ULOGD_RETF_NONE,
> +		.name =3D "o.tcp.sport",
> +		.ipfix =3D {
> +			.vendor =3D IPFIX_VENDOR_IETF,
> +			.field_id =3D IPFIX_tcpSourcePort,
> +		},
> +	},
> +	[KEY_O_TCP_DPORT] =3D {
> +		.type =3D ULOGD_RET_UINT16,
> +		.flags =3D ULOGD_RETF_NONE,
> +		.name =3D "o.tcp.dport",
> +		.ipfix =3D {
> +			.vendor =3D IPFIX_VENDOR_IETF,
> +			.field_id =3D IPFIX_tcpDestinationPort,
> +		},
> +	},
> +	[KEY_O_TCP_SEQ] =3D {
> +		.type =3D ULOGD_RET_UINT32,
> +		.flags =3D ULOGD_RETF_NONE,
> +		.name =3D "o.tcp.seq",
> +		.ipfix =3D {
> +			.vendor =3D IPFIX_VENDOR_IETF,
> +			.field_id =3D IPFIX_tcpSequenceNumber,
> +		},
> +	},
> +	[KEY_O_TCP_ACKSEQ] =3D {
> +		.type =3D ULOGD_RET_UINT32,
> +		.flags =3D ULOGD_RETF_NONE,
> +		.name =3D "o.tcp.ackseq",
> +		.ipfix =3D {
> +			.vendor =3D IPFIX_VENDOR_IETF,
> +			.field_id =3D IPFIX_tcpAcknowledgementNumber,
> +		},
> +	},
> +	[KEY_O_TCP_OFFSET] =3D {
> +		.type =3D ULOGD_RET_UINT8,
> +		.flags =3D ULOGD_RETF_NONE,
> +		.name =3D "o.tcp.offset",
> +	},
> +	[KEY_O_TCP_RESERVED] =3D {
> +		.type =3D ULOGD_RET_UINT8,
> +		.flags =3D ULOGD_RETF_NONE,
> +		.name =3D "o.tcp.reserved",
> +	},
> +	[KEY_O_TCP_WINDOW] =3D {
> +		.type =3D ULOGD_RET_UINT16,
> +		.flags =3D ULOGD_RETF_NONE,
> +		.name =3D "o.tcp.window",
> +		.ipfix =3D {
> +			.vendor =3D IPFIX_VENDOR_IETF,
> +			.field_id =3D IPFIX_tcpWindowSize,
> +		},
> +	},
> +	[KEY_O_TCP_URG] =3D {
> +		.type =3D ULOGD_RET_BOOL,
> +		.flags =3D ULOGD_RETF_NONE,
> +		.name =3D "o.tcp.urg",
> +	},
> +	[KEY_O_TCP_URGP] =3D {
> +		.type =3D ULOGD_RET_UINT16,
> +		.flags =3D ULOGD_RETF_NONE,
> +		.name =3D "o.tcp.urgp",
> +		.ipfix =3D {
> +			.vendor =3D IPFIX_VENDOR_IETF,
> +			.field_id =3D IPFIX_tcpUrgentPointer,
> +		},
> +	},
> +	[KEY_O_TCP_ACK] =3D {
> +		.type =3D ULOGD_RET_BOOL,
> +		.flags =3D ULOGD_RETF_NONE,
> +		.name =3D "o.tcp.ack",
> +	},
> +	[KEY_O_TCP_PSH] =3D {
> +		.type =3D ULOGD_RET_BOOL,
> +		.flags =3D ULOGD_RETF_NONE,
> +		.name =3D "o.tcp.psh",
> +	},
> +	[KEY_O_TCP_RST] =3D {
> +		.type =3D ULOGD_RET_BOOL,
> +		.flags =3D ULOGD_RETF_NONE,
> +		.name =3D "o.tcp.rst",
> +	},
> +	[KEY_O_TCP_SYN] =3D {
> +		.type =3D ULOGD_RET_BOOL,
> +		.flags =3D ULOGD_RETF_NONE,
> +		.name =3D "o.tcp.syn",
> +	},
> +	[KEY_O_TCP_FIN] =3D {
> +		.type =3D ULOGD_RET_BOOL,
> +		.flags =3D ULOGD_RETF_NONE,
> +		.name =3D "o.tcp.fin",
> +	},
> +	[KEY_O_TCP_RES1] =3D {
> +		.type =3D ULOGD_RET_BOOL,
> +		.flags =3D ULOGD_RETF_NONE,
> +		.name =3D "o.tcp.res1",
> +	},
> +	[KEY_O_TCP_RES2] =3D {
> +		.type =3D ULOGD_RET_BOOL,
> +		.flags =3D ULOGD_RETF_NONE,
> +		.name =3D "o.tcp.res2",
> +	},
> +	[KEY_O_TCP_CSUM] =3D {
> +		.type =3D ULOGD_RET_UINT16,
> +		.flags =3D ULOGD_RETF_NONE,
> +		.name =3D "o.tcp.csum",
> +	},
> +	[KEY_O_UDP_SPORT] =3D {
> +		.type =3D ULOGD_RET_UINT16,
> +		.flags =3D ULOGD_RETF_NONE,
> +		.name =3D "o.udp.sport",
> +		.ipfix =3D {
> +			.vendor =3D IPFIX_VENDOR_IETF,
> +			.field_id =3D IPFIX_udpSourcePort,
> +		},
> +	},
> +	[KEY_O_UDP_DPORT] =3D {
> +		.type =3D ULOGD_RET_UINT16,
> +		.flags =3D ULOGD_RETF_NONE,
> +		.name =3D "o.udp.dport",
> +		.ipfix =3D {
> +			.vendor =3D IPFIX_VENDOR_IETF,
> +			.field_id =3D IPFIX_udpDestinationPort,
> +		},
> +	},
> +	[KEY_O_UDP_LEN] =3D {
> +		.type =3D ULOGD_RET_UINT16,
> +		.flags =3D ULOGD_RETF_NONE,
> +		.name =3D "o.udp.len",
> +	},
> +	[KEY_O_UDP_CSUM] =3D {
> +		.type =3D ULOGD_RET_UINT16,
> +		.flags =3D ULOGD_RETF_NONE,
> +		.name =3D "o.udp.csum",
> +	},
> +	[KEY_O_ICMP_TYPE] =3D {
> +		.type =3D ULOGD_RET_UINT8,
> +		.flags =3D ULOGD_RETF_NONE,
> +		.name =3D "o.icmp.type",
> +		.ipfix =3D {
> +			.vendor =3D IPFIX_VENDOR_IETF,
> +			.field_id =3D IPFIX_icmpTypeIPv4,
> +		},
> +	},
> +	[KEY_O_ICMP_CODE] =3D {
> +		.type =3D ULOGD_RET_UINT8,
> +		.flags =3D ULOGD_RETF_NONE,
> +		.name =3D "o.icmp.code",
> +		.ipfix =3D {
> +			.vendor =3D IPFIX_VENDOR_IETF,
> +			.field_id =3D IPFIX_icmpCodeIPv4,
> +		},
> +	},
> +	[KEY_O_ICMP_ECHOID] =3D {
> +		.type =3D ULOGD_RET_UINT16,
> +		.flags =3D ULOGD_RETF_NONE,
> +		.name =3D "o.icmp.echoid",
> +	},
> +	[KEY_O_ICMP_ECHOSEQ] =3D {
> +		.type =3D ULOGD_RET_UINT16,
> +		.flags =3D ULOGD_RETF_NONE,
> +		.name =3D "o.icmp.echoseq",
> +	},
> +	[KEY_O_ICMP_GATEWAY] =3D {
> +		.type =3D ULOGD_RET_IPADDR,
> +		.flags =3D ULOGD_RETF_NONE,
> +		.name =3D "o.icmp.gateway",
> +	},
> +	[KEY_O_ICMP_FRAGMTU] =3D {
> +		.type =3D ULOGD_RET_UINT16,
> +		.flags =3D ULOGD_RETF_NONE,
> +		.name =3D "o.icmp.fragmtu",
> +	},
> +	[KEY_O_ICMP_CSUM] =3D {
> +		.type =3D ULOGD_RET_UINT16,
> +		.flags =3D ULOGD_RETF_NONE,
> +		.name =3D "o.icmp.csum",
> +	},
> +	[KEY_O_SCTP_SPORT] =3D {
> +		.type =3D ULOGD_RET_UINT16,
> +		.flags =3D ULOGD_RETF_NONE,
> +		.name =3D "o.sctp.sport",
> +	},
> +	[KEY_O_SCTP_DPORT] =3D {
> +		.type =3D ULOGD_RET_UINT16,
> +		.flags =3D ULOGD_RETF_NONE,
> +		.name =3D "o.sctp.dport",
> +	},
> +	[KEY_O_SCTP_CSUM] =3D {
> +		.type =3D ULOGD_RET_UINT32,
> +		.flags =3D ULOGD_RETF_NONE,
> +		.name =3D "o.sctp.csum",
> +	},
>   };
>=20
> +#define recurse_key(key) recurse ? KEY_##key : KEY_O_##key
> +
>   /**********************************************************************=
*
>    * 			TCP HEADER
>    **********************************************************************=
*/
>=20
>   static int _interp_tcp(struct ulogd_pluginstance *pi, struct tcphdr *tc=
ph,
> -		       u_int32_t len)
> +		       u_int32_t len, u_int32_t recurse)
>   {
>   	struct ulogd_key *ret =3D pi->output.keys;
>=20
>   	if (len < sizeof(struct tcphdr))
>   		return ULOGD_IRET_OK;
>   =09
> -	okey_set_u16(&ret[KEY_TCP_SPORT], ntohs(tcph->source));
> -	okey_set_u16(&ret[KEY_TCP_DPORT], ntohs(tcph->dest));
> -	okey_set_u32(&ret[KEY_TCP_SEQ], ntohl(tcph->seq));
> -	okey_set_u32(&ret[KEY_TCP_ACKSEQ], ntohl(tcph->ack_seq));
> -	okey_set_u8(&ret[KEY_TCP_OFFSET], ntohs(tcph->doff));
> -	okey_set_u8(&ret[KEY_TCP_RESERVED], ntohs(tcph->res1));
> -	okey_set_u16(&ret[KEY_TCP_WINDOW], ntohs(tcph->window));
> -
> -	okey_set_b(&ret[KEY_TCP_URG], tcph->urg);
> +	okey_set_u16(&ret[recurse_key(TCP_SPORT)], ntohs(tcph->source));
> +	okey_set_u16(&ret[recurse_key(TCP_DPORT)], ntohs(tcph->dest));
> +	okey_set_u32(&ret[recurse_key(TCP_SEQ)], ntohl(tcph->seq));
> +	okey_set_u32(&ret[recurse_key(TCP_ACKSEQ)], ntohl(tcph->ack_seq));
> +	okey_set_u8(&ret[recurse_key(TCP_OFFSET)], ntohs(tcph->doff));
> +	okey_set_u8(&ret[recurse_key(TCP_RESERVED)], ntohs(tcph->res1));
> +	okey_set_u16(&ret[recurse_key(TCP_WINDOW)], ntohs(tcph->window));
> +
> +	okey_set_b(&ret[recurse_key(TCP_URG)], tcph->urg);
>   	if (tcph->urg)
> -		okey_set_u16(&ret[KEY_TCP_URGP], ntohs(tcph->urg_ptr));
> -	okey_set_b(&ret[KEY_TCP_ACK], tcph->ack);
> -	okey_set_b(&ret[KEY_TCP_PSH], tcph->psh);
> -	okey_set_b(&ret[KEY_TCP_RST], tcph->rst);
> -	okey_set_b(&ret[KEY_TCP_SYN], tcph->syn);
> -	okey_set_b(&ret[KEY_TCP_FIN], tcph->fin);
> -	okey_set_b(&ret[KEY_TCP_RES1], tcph->res1);
> -	okey_set_b(&ret[KEY_TCP_RES2], tcph->res2);
> -	okey_set_u16(&ret[KEY_TCP_CSUM], ntohs(tcph->check));
> +		okey_set_u16(&ret[recurse_key(TCP_URGP)], ntohs(tcph->urg_ptr));
> +	okey_set_b(&ret[recurse_key(TCP_ACK)], tcph->ack);
> +	okey_set_b(&ret[recurse_key(TCP_PSH)], tcph->psh);
> +	okey_set_b(&ret[recurse_key(TCP_RST)], tcph->rst);
> +	okey_set_b(&ret[recurse_key(TCP_SYN)], tcph->syn);
> +	okey_set_b(&ret[recurse_key(TCP_FIN)], tcph->fin);
> +	okey_set_b(&ret[recurse_key(TCP_RES1)], tcph->res1);
> +	okey_set_b(&ret[recurse_key(TCP_RES2)], tcph->res2);
> +	okey_set_u16(&ret[recurse_key(TCP_CSUM)], ntohs(tcph->check));
>   =09
>   	return ULOGD_IRET_OK;
>   }
> @@ -566,7 +890,7 @@ static int _interp_tcp(struct ulogd_pluginstance *pi,=
 struct tcphdr *tcph,
>    **********************************************************************=
*/
>=20
>   static int _interp_udp(struct ulogd_pluginstance *pi, struct udphdr *ud=
ph,
> -		       u_int32_t len)
> +		       u_int32_t len, u_int32_t recurse)
>   	=09
>   {
>   	struct ulogd_key *ret =3D pi->output.keys;
> @@ -574,10 +898,10 @@ static int _interp_udp(struct ulogd_pluginstance *p=
i, struct udphdr *udph,
>   	if (len < sizeof(struct udphdr))
>   		return ULOGD_IRET_OK;
>=20
> -	okey_set_u16(&ret[KEY_UDP_SPORT], ntohs(udph->source));
> -	okey_set_u16(&ret[KEY_UDP_DPORT], ntohs(udph->dest));
> -	okey_set_u16(&ret[KEY_UDP_LEN], ntohs(udph->len));
> -	okey_set_u16(&ret[KEY_UDP_CSUM], ntohs(udph->check));
> +	okey_set_u16(&ret[recurse_key(UDP_SPORT)], ntohs(udph->source));
> +	okey_set_u16(&ret[recurse_key(UDP_DPORT)], ntohs(udph->dest));
> +	okey_set_u16(&ret[recurse_key(UDP_LEN)], ntohs(udph->len));
> +	okey_set_u16(&ret[recurse_key(UDP_CSUM)], ntohs(udph->check));
>   =09
>   	return ULOGD_IRET_OK;
>   }
> @@ -595,7 +919,7 @@ typedef struct sctphdr {
>   } __attribute__((packed)) sctp_sctphdr_t;
>=20
>   static int _interp_sctp(struct ulogd_pluginstance *pi, struct sctphdr *=
sctph,
> -		       u_int32_t len)
> +		       u_int32_t len, u_int32_t recurse)
>   	=09
>   {
>   	struct ulogd_key *ret =3D pi->output.keys;
> @@ -603,50 +927,60 @@ static int _interp_sctp(struct ulogd_pluginstance *=
pi, struct sctphdr *sctph,
>   	if (len < sizeof(struct sctphdr))
>   		return ULOGD_IRET_OK;
>=20
> -	ret[KEY_SCTP_SPORT].u.value.ui16 =3D ntohs(sctph->source);
> -	ret[KEY_SCTP_SPORT].flags |=3D ULOGD_RETF_VALID;
> -	ret[KEY_SCTP_DPORT].u.value.ui16 =3D ntohs(sctph->dest);
> -	ret[KEY_SCTP_DPORT].flags |=3D ULOGD_RETF_VALID;
> -	ret[KEY_SCTP_CSUM].u.value.ui32 =3D ntohl(sctph->checksum);
> -	ret[KEY_SCTP_CSUM].flags |=3D ULOGD_RETF_VALID;
> +	ret[recurse_key(SCTP_SPORT)].u.value.ui16 =3D ntohs(sctph->source);
> +	ret[recurse_key(SCTP_SPORT)].flags |=3D ULOGD_RETF_VALID;
> +	ret[recurse_key(SCTP_DPORT)].u.value.ui16 =3D ntohs(sctph->dest);
> +	ret[recurse_key(SCTP_DPORT)].flags |=3D ULOGD_RETF_VALID;
> +	ret[recurse_key(SCTP_CSUM)].u.value.ui32 =3D ntohl(sctph->checksum);
> +	ret[recurse_key(SCTP_CSUM)].flags |=3D ULOGD_RETF_VALID;
>   =09
>   	return ULOGD_IRET_OK;
>   }
>=20
> +static int _interp_iphdr(struct ulogd_pluginstance *pi, struct iphdr *ip=
h, u_int32_t len,
> +			 u_int32_t recurse);
> +
>   /**********************************************************************=
*
>    * 			ICMP HEADER
>    **********************************************************************=
*/
>=20
>   static int _interp_icmp(struct ulogd_pluginstance *pi, struct icmphdr *=
icmph,
> -			u_int32_t len)
> +			u_int32_t len, u_int32_t recurse)
>   {
>   	struct ulogd_key *ret =3D pi->output.keys;
>=20
>   	if (len < sizeof(struct icmphdr))
>   		return ULOGD_IRET_OK;
>=20
> -	okey_set_u8(&ret[KEY_ICMP_TYPE], icmph->type);
> -	okey_set_u8(&ret[KEY_ICMP_CODE], icmph->code);
> +	okey_set_u8(&ret[recurse_key(ICMP_TYPE)], icmph->type);
> +	okey_set_u8(&ret[recurse_key(ICMP_CODE)], icmph->code);
>=20
>   	switch (icmph->type) {
>   	case ICMP_ECHO:
>   	case ICMP_ECHOREPLY:
> -		okey_set_u16(&ret[KEY_ICMP_ECHOID], ntohs(icmph->un.echo.id));
> -		okey_set_u16(&ret[KEY_ICMP_ECHOSEQ],
> +			okey_set_u16(&ret[recurse_key(ICMP_ECHOID)], ntohs(icmph->un.echo.id)=
);
> +			okey_set_u16(&ret[recurse_key(ICMP_ECHOSEQ)],
>   			     ntohs(icmph->un.echo.sequence));
>   		break;
>   	case ICMP_REDIRECT:
>   	case ICMP_PARAMETERPROB:
> -		okey_set_u32(&ret[KEY_ICMP_GATEWAY], ntohl(icmph->un.gateway));
> +			okey_set_u32(&ret[recurse_key(ICMP_GATEWAY)], ntohl(icmph->un.gateway=
));
>   		break;
>   	case ICMP_DEST_UNREACH:
> -		if (icmph->code =3D=3D ICMP_FRAG_NEEDED) {
> -			okey_set_u16(&ret[KEY_ICMP_FRAGMTU],
> +		case ICMP_SOURCE_QUENCH:
> +		case ICMP_TIME_EXCEEDED: {
> +			void *nexthdr =3D (u_int32_t *)icmph + 2;
> +			len -=3D sizeof(struct icmphdr);
> +			_interp_iphdr(pi, nexthdr, len, 0);
> +			if (icmph->type =3D=3D ICMP_DEST_UNREACH &&
> +			    icmph->code =3D=3D ICMP_FRAG_NEEDED) {
> +				okey_set_u16(&ret[recurse_key(ICMP_FRAGMTU)],
>   				     ntohs(icmph->un.frag.mtu));
>   		}
>   		break;
>   	}
> -	okey_set_u16(&ret[KEY_ICMP_CSUM], icmph->checksum);
> +	}
> +	okey_set_u16(&ret[recurse_key(ICMP_CSUM)], icmph->checksum);
>=20
>   	return ULOGD_IRET_OK;
>   }
> @@ -704,40 +1038,39 @@ static int _interp_ahesp(struct ulogd_pluginstance=
 *pi, void *protoh,
>    * 			IP HEADER
>    **********************************************************************=
*/
>=20
> -static int _interp_iphdr(struct ulogd_pluginstance *pi, u_int32_t len)
> +static int _interp_iphdr(struct ulogd_pluginstance *pi, struct iphdr *ip=
h, u_int32_t len,
> +			 u_int32_t recurse)
>   {
>   	struct ulogd_key *ret =3D pi->output.keys;
> -	struct iphdr *iph =3D
> -		ikey_get_ptr(&pi->input.keys[INKEY_RAW_PCKT]);
>   	void *nexthdr =3D (u_int32_t *)iph + iph->ihl;
>=20
>   	if (len < sizeof(struct iphdr) || len <=3D (u_int32_t)(iph->ihl * 4))
>   		return ULOGD_IRET_OK;
>   	len -=3D iph->ihl * 4;
>=20
> -	okey_set_u32(&ret[KEY_IP_SADDR], iph->saddr);
> -	okey_set_u32(&ret[KEY_IP_DADDR], iph->daddr);
> -	okey_set_u8(&ret[KEY_IP_PROTOCOL], iph->protocol);
> -	okey_set_u8(&ret[KEY_IP_TOS], iph->tos);
> -	okey_set_u8(&ret[KEY_IP_TTL], iph->ttl);
> -	okey_set_u16(&ret[KEY_IP_TOTLEN], ntohs(iph->tot_len));
> -	okey_set_u8(&ret[KEY_IP_IHL], iph->ihl);
> -	okey_set_u16(&ret[KEY_IP_CSUM], ntohs(iph->check));
> -	okey_set_u16(&ret[KEY_IP_ID], ntohs(iph->id));
> -	okey_set_u16(&ret[KEY_IP_FRAGOFF], ntohs(iph->frag_off));
> +	okey_set_u32(&ret[recurse_key(IP_SADDR)], iph->saddr);
> +	okey_set_u32(&ret[recurse_key(IP_DADDR)], iph->daddr);
> +	okey_set_u8(&ret[recurse_key(IP_PROTOCOL)], iph->protocol);
> +	okey_set_u8(&ret[recurse_key(IP_TOS)], iph->tos);
> +	okey_set_u8(&ret[recurse_key(IP_TTL)], iph->ttl);
> +	okey_set_u16(&ret[recurse_key(IP_TOTLEN)], ntohs(iph->tot_len));
> +	okey_set_u8(&ret[recurse_key(IP_IHL)], iph->ihl);
> +	okey_set_u16(&ret[recurse_key(IP_CSUM)], ntohs(iph->check));
> +	okey_set_u16(&ret[recurse_key(IP_ID)], ntohs(iph->id));
> +	okey_set_u16(&ret[recurse_key(IP_FRAGOFF)], ntohs(iph->frag_off));
>=20
>   	switch (iph->protocol) {
>   	case IPPROTO_TCP:
> -		_interp_tcp(pi, nexthdr, len);
> +		_interp_tcp(pi, nexthdr, len, recurse);
>   		break;
>   	case IPPROTO_UDP:
> -		_interp_udp(pi, nexthdr, len);
> +		_interp_udp(pi, nexthdr, len, recurse);
>   		break;
>   	case IPPROTO_ICMP:
> -		_interp_icmp(pi, nexthdr, len);
> +		_interp_icmp(pi, nexthdr, len, recurse);
>   		break;
>   	case IPPROTO_SCTP:
> -		_interp_sctp(pi, nexthdr, len);
> +		_interp_sctp(pi, nexthdr, len, recurse);
>   		break;
>   	case IPPROTO_AH:
>   	case IPPROTO_ESP:
> @@ -864,10 +1197,10 @@ static int _interp_ipv6hdr(struct ulogd_pluginstan=
ce *pi, u_int32_t len)
>=20
>   	switch (curhdr) {
>   	case IPPROTO_TCP:
> -		_interp_tcp(pi, (void *)ipv6h + ptr, len);
> +		_interp_tcp(pi, (void *)ipv6h + ptr, len, 0);
>   		break;
>   	case IPPROTO_UDP:
> -		_interp_udp(pi, (void *)ipv6h + ptr, len);
> +		_interp_udp(pi, (void *)ipv6h + ptr, len, 0);
>   		break;
>   	case IPPROTO_ICMPV6:
>   		_interp_icmpv6(pi, (void *)ipv6h + ptr, len);
> @@ -914,7 +1247,8 @@ static int _interp_bridge(struct ulogd_pluginstance =
*pi, u_int32_t len)
>=20
>   	switch (proto) {
>   	case ETH_P_IP:
> -		_interp_iphdr(pi, len);
> +		_interp_iphdr(pi, ikey_get_ptr(&pi->input.keys[INKEY_RAW_PCKT]),
> +			      len, 1);
>   		break;
>   	case ETH_P_IPV6:
>   		_interp_ipv6hdr(pi, len);
> @@ -940,7 +1274,8 @@ static int _interp_pkt(struct ulogd_pluginstance *pi=
)
>=20
>   	switch (family) {
>   	case AF_INET:
> -		return _interp_iphdr(pi, len);
> +		return _interp_iphdr(pi, ikey_get_ptr(&pi->input.keys[INKEY_RAW_PCKT])=
,
> +				     len, 1);
>   	case AF_INET6:
>   		return _interp_ipv6hdr(pi, len);
>   	case AF_BRIDGE:
>=20
>=20
>=20

--=20
Eric Leblond <eric@regit.org>
Blog: https://home.regit.org/


--=-vaLiGzfTI7I36bISe1SS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAlE4SJcACgkQnxA7CdMWjzL5KwCdH5xO7pWxZk3UY0pLYlUvbttq
UvQAnRqNZ9k8Oejbdi6bPWG6sGuItJnQ
=UP00
-----END PGP SIGNATURE-----

--=-vaLiGzfTI7I36bISe1SS--

