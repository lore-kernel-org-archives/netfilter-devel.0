From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: Re: [nft PATCH 1/2] proto: add protocol key in some proto_desc for
 identifying it
Date: Fri, 11 Jul 2014 11:21:00 +0200
Message-ID: <CADjjUBO_WRF6NsimrnG+g8DHuaO28RiF2jVG4ir7Q16JrAvGeQ@mail.gmail.com>
References: <1405068166-7174-1-git-send-email-alvaroneay@gmail.com>
	<20140711091430.GA4268@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:49936 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638AbaGKJVD convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Jul 2014 05:21:03 -0400
Received: by mail-la0-f51.google.com with SMTP id mc6so639189lab.38
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Jul 2014 02:21:00 -0700 (PDT)
In-Reply-To: <20140711091430.GA4268@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2014-07-11 11:14 GMT+02:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> On Fri, Jul 11, 2014 at 10:42:45AM +0200, Alvaro Neira Ayuso wrote:
>> From: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>
>>
>> I have added this protocol_key for having more information
>> for making more easy identify it
>
> You cannot add something which is left unused.
>
> IOW, the policy is to add something that you start using from the sam=
e
> patch.

Catched, I'm going to use that in a future patch for the reject. I'm
going to send this patch when I finish the other. Sorry and thanks.

>
>> Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
>> ---
>>  src/proto.c |    8 ++++++++
>>  1 file changed, 8 insertions(+)
>>
>> diff --git a/src/proto.c b/src/proto.c
>> index 546ef10..4192108 100644
>> --- a/src/proto.c
>> +++ b/src/proto.c
>> @@ -249,6 +249,7 @@ const struct proto_desc proto_ah =3D {
>>  const struct proto_desc proto_esp =3D {
>>       .name           =3D "esp",
>>       .base           =3D PROTO_BASE_TRANSPORT_HDR,
>> +     .protocol_key   =3D IPPROTO_ESP,
>>       .templates      =3D {
>>               [ESPHDR_SPI]            =3D ESPHDR_FIELD("spi", spi),
>>               [ESPHDR_SEQUENCE]       =3D ESPHDR_FIELD("sequence", s=
eq_no),
>> @@ -326,6 +327,7 @@ static const struct datatype icmp_type_type =3D =
{
>>  const struct proto_desc proto_icmp =3D {
>>       .name           =3D "icmp",
>>       .base           =3D PROTO_BASE_TRANSPORT_HDR,
>> +     .protocol_key   =3D IPPROTO_ICMP,
>>       .templates      =3D {
>>               [ICMPHDR_TYPE]          =3D ICMPHDR_TYPE("type", &icmp=
_type_type, type),
>>               [ICMPHDR_CODE]          =3D ICMPHDR_FIELD("code", code=
),
>> @@ -348,6 +350,7 @@ const struct proto_desc proto_icmp =3D {
>>  const struct proto_desc proto_udp =3D {
>>       .name           =3D "udp",
>>       .base           =3D PROTO_BASE_TRANSPORT_HDR,
>> +     .protocol_key   =3D IPPROTO_UDP,
>>       .templates      =3D {
>>               [UDPHDR_SPORT]          =3D INET_SERVICE("sport", stru=
ct udphdr, source),
>>               [UDPHDR_DPORT]          =3D INET_SERVICE("dport", stru=
ct udphdr, dest),
>> @@ -359,6 +362,7 @@ const struct proto_desc proto_udp =3D {
>>  const struct proto_desc proto_udplite =3D {
>>       .name           =3D "udplite",
>>       .base           =3D PROTO_BASE_TRANSPORT_HDR,
>> +     .protocol_key   =3D IPPROTO_UDPLITE,
>>       .templates      =3D {
>>               [UDPHDR_SPORT]          =3D INET_SERVICE("sport", stru=
ct udphdr, source),
>>               [UDPHDR_DPORT]          =3D INET_SERVICE("dport", stru=
ct udphdr, dest),
>> @@ -403,6 +407,7 @@ static const struct datatype tcp_flag_type =3D {
>>  const struct proto_desc proto_tcp =3D {
>>       .name           =3D "tcp",
>>       .base           =3D PROTO_BASE_TRANSPORT_HDR,
>> +     .protocol_key   =3D IPPROTO_TCP,
>>       .templates      =3D {
>>               [TCPHDR_SPORT]          =3D INET_SERVICE("sport", stru=
ct tcphdr, source),
>>               [TCPHDR_DPORT]          =3D INET_SERVICE("dport", stru=
ct tcphdr, dest),
>> @@ -456,6 +461,7 @@ static const struct datatype dccp_pkttype_type =3D=
 {
>>  const struct proto_desc proto_dccp =3D {
>>       .name           =3D "dccp",
>>       .base           =3D PROTO_BASE_TRANSPORT_HDR,
>> +     .protocol_key   =3D IPPROTO_DCCP,
>>       .templates      =3D {
>>               [DCCPHDR_SPORT]         =3D INET_SERVICE("sport", stru=
ct dccp_hdr, dccph_sport),
>>               [DCCPHDR_DPORT]         =3D INET_SERVICE("dport", stru=
ct dccp_hdr, dccph_dport),
>> @@ -473,6 +479,7 @@ const struct proto_desc proto_dccp =3D {
>>  const struct proto_desc proto_sctp =3D {
>>       .name           =3D "sctp",
>>       .base           =3D PROTO_BASE_TRANSPORT_HDR,
>> +     .protocol_key   =3D IPPROTO_SCTP,
>>       .templates      =3D {
>>               [SCTPHDR_SPORT]         =3D INET_SERVICE("sport", stru=
ct sctphdr, source),
>>               [SCTPHDR_DPORT]         =3D INET_SERVICE("dport", stru=
ct sctphdr, dest),
>> @@ -566,6 +573,7 @@ static const struct datatype icmp6_type_type =3D=
 {
>>  const struct proto_desc proto_icmp6 =3D {
>>       .name           =3D "icmpv6",
>>       .base           =3D PROTO_BASE_TRANSPORT_HDR,
>> +     .protocol_key   =3D IPPROTO_ICMPV6,
>>       .templates      =3D {
>>               [ICMP6HDR_TYPE]         =3D ICMP6HDR_TYPE("type", &icm=
p6_type_type, icmp6_type),
>>               [ICMP6HDR_CODE]         =3D ICMP6HDR_FIELD("code", icm=
p6_code),
>> --
>> 1.7.10.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe netfilter-=
devel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--=20
=C3=81lvaro Neira Ayuso
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
