From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 1/2] proto: add protocol key in some proto_desc for
 identifying it
Date: Fri, 11 Jul 2014 11:14:30 +0200
Message-ID: <20140711091430.GA4268@localhost>
References: <1405068166-7174-1-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35492 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752371AbaGKJOg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Jul 2014 05:14:36 -0400
Content-Disposition: inline
In-Reply-To: <1405068166-7174-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jul 11, 2014 at 10:42:45AM +0200, Alvaro Neira Ayuso wrote:
> From: =C1lvaro Neira Ayuso <alvaroneay@gmail.com>
>=20
> I have added this protocol_key for having more information
> for making more easy identify it

You cannot add something which is left unused.

IOW, the policy is to add something that you start using from the same
patch.

> Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
> ---
>  src/proto.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
>=20
> diff --git a/src/proto.c b/src/proto.c
> index 546ef10..4192108 100644
> --- a/src/proto.c
> +++ b/src/proto.c
> @@ -249,6 +249,7 @@ const struct proto_desc proto_ah =3D {
>  const struct proto_desc proto_esp =3D {
>  	.name		=3D "esp",
>  	.base		=3D PROTO_BASE_TRANSPORT_HDR,
> +	.protocol_key	=3D IPPROTO_ESP,
>  	.templates	=3D {
>  		[ESPHDR_SPI]		=3D ESPHDR_FIELD("spi", spi),
>  		[ESPHDR_SEQUENCE]	=3D ESPHDR_FIELD("sequence", seq_no),
> @@ -326,6 +327,7 @@ static const struct datatype icmp_type_type =3D {
>  const struct proto_desc proto_icmp =3D {
>  	.name		=3D "icmp",
>  	.base		=3D PROTO_BASE_TRANSPORT_HDR,
> +	.protocol_key	=3D IPPROTO_ICMP,
>  	.templates	=3D {
>  		[ICMPHDR_TYPE]		=3D ICMPHDR_TYPE("type", &icmp_type_type, type),
>  		[ICMPHDR_CODE]		=3D ICMPHDR_FIELD("code", code),
> @@ -348,6 +350,7 @@ const struct proto_desc proto_icmp =3D {
>  const struct proto_desc proto_udp =3D {
>  	.name		=3D "udp",
>  	.base		=3D PROTO_BASE_TRANSPORT_HDR,
> +	.protocol_key	=3D IPPROTO_UDP,
>  	.templates	=3D {
>  		[UDPHDR_SPORT]		=3D INET_SERVICE("sport", struct udphdr, source),
>  		[UDPHDR_DPORT]		=3D INET_SERVICE("dport", struct udphdr, dest),
> @@ -359,6 +362,7 @@ const struct proto_desc proto_udp =3D {
>  const struct proto_desc proto_udplite =3D {
>  	.name		=3D "udplite",
>  	.base		=3D PROTO_BASE_TRANSPORT_HDR,
> +	.protocol_key	=3D IPPROTO_UDPLITE,
>  	.templates	=3D {
>  		[UDPHDR_SPORT]		=3D INET_SERVICE("sport", struct udphdr, source),
>  		[UDPHDR_DPORT]		=3D INET_SERVICE("dport", struct udphdr, dest),
> @@ -403,6 +407,7 @@ static const struct datatype tcp_flag_type =3D {
>  const struct proto_desc proto_tcp =3D {
>  	.name		=3D "tcp",
>  	.base		=3D PROTO_BASE_TRANSPORT_HDR,
> +	.protocol_key	=3D IPPROTO_TCP,
>  	.templates	=3D {
>  		[TCPHDR_SPORT]		=3D INET_SERVICE("sport", struct tcphdr, source),
>  		[TCPHDR_DPORT]		=3D INET_SERVICE("dport", struct tcphdr, dest),
> @@ -456,6 +461,7 @@ static const struct datatype dccp_pkttype_type =3D=
 {
>  const struct proto_desc proto_dccp =3D {
>  	.name		=3D "dccp",
>  	.base		=3D PROTO_BASE_TRANSPORT_HDR,
> +	.protocol_key	=3D IPPROTO_DCCP,
>  	.templates	=3D {
>  		[DCCPHDR_SPORT]		=3D INET_SERVICE("sport", struct dccp_hdr, dccph_=
sport),
>  		[DCCPHDR_DPORT]		=3D INET_SERVICE("dport", struct dccp_hdr, dccph_=
dport),
> @@ -473,6 +479,7 @@ const struct proto_desc proto_dccp =3D {
>  const struct proto_desc proto_sctp =3D {
>  	.name		=3D "sctp",
>  	.base		=3D PROTO_BASE_TRANSPORT_HDR,
> +	.protocol_key	=3D IPPROTO_SCTP,
>  	.templates	=3D {
>  		[SCTPHDR_SPORT]		=3D INET_SERVICE("sport", struct sctphdr, source)=
,
>  		[SCTPHDR_DPORT]		=3D INET_SERVICE("dport", struct sctphdr, dest),
> @@ -566,6 +573,7 @@ static const struct datatype icmp6_type_type =3D =
{
>  const struct proto_desc proto_icmp6 =3D {
>  	.name		=3D "icmpv6",
>  	.base		=3D PROTO_BASE_TRANSPORT_HDR,
> +	.protocol_key	=3D IPPROTO_ICMPV6,
>  	.templates	=3D {
>  		[ICMP6HDR_TYPE]		=3D ICMP6HDR_TYPE("type", &icmp6_type_type, icmp6=
_type),
>  		[ICMP6HDR_CODE]		=3D ICMP6HDR_FIELD("code", icmp6_code),
> --=20
> 1.7.10.4
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-d=
evel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
