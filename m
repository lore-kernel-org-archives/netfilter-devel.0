From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nft PATCH v2] payload: generate dependency with wrong byteorder value format
Date: Sat, 12 Jul 2014 20:16:42 +0100
Message-ID: <641946b9-efc1-41b0-b1c2-2afd40b2051b@email.android.com>
References: <1405076974-20899-1-git-send-email-alvaroneay@gmail.com> <20140712131012.GA5456@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33591 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbaGLTWG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 12 Jul 2014 15:22:06 -0400
In-Reply-To: <20140712131012.GA5456@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 12. Juli 2014 14:10:12 GMT+01:00, Pablo Neira Ayuso <pablo@netfilter=
=2Eorg> wrote:
>Hi Alvaro,
>
>On Fri, Jul 11, 2014 at 01:09:34PM +0200, Alvaro Neira Ayuso wrote:
>> From: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>
>>
>> In all case that we have added a payload dependency, we have suppose=
d
>> that the byteorder must to be BYTEORDER_HOST_ENDIAN, the problem is
>> when we want to add a dependency that the value has another
>byteorder.
>> For example, if we try to add a new payload dependency in a bridge
>table
>> and we use ether type, the byteorder is BYTEORDER_BIG_ENDIAN. The
>value
>> of the type ip is 0x0800 in ether but when we add the payload
>dependency
>> for this specific protocol, we will have a payload like this:
>>
>> [ payload load 2b @ link header + 12 =3D> reg 1 ]
>>   [ cmp eq reg 1 0x00000008 ]
>>
>> This patch allows to create payload dependency with the byteorder of
>the
>> template. For that I have updated the function for updating the
>context for
>> using the byteorder of the template too. With this changes we have a
>payload
>> with the correct format:
>>
>> [ payload load 2b @ link header + 12 =3D> reg 1 ]
>>   [ cmp eq reg 1 0x00000800 ]
>>
>> Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
>> ---
>> [tested with the rules]
>> nft add rule filter input ip protocol tcp counter
>> nft add rule filter input ip protocol udp counter
>> nft add rule filter input tcp dport 22 counter
>>
>>  src/payload.c |    9 +++++++--
>>  src/proto.c   |    8 ++++++++
>>  2 files changed, 15 insertions(+), 2 deletions(-)
>>
>> diff --git a/src/payload.c b/src/payload.c
>> index a1785a5..fb78ba5 100644
>> --- a/src/payload.c
>> +++ b/src/payload.c
>> @@ -69,13 +69,18 @@ static void payload_expr_pctx_update(struct
>proto_ctx *ctx,
>>  {
>>  	const struct expr *left =3D expr->left, *right =3D expr->right;
>>  	const struct proto_desc *base, *desc;
>> +	const struct proto_hdr_template *tmpl;
>> +	uint32_t value =3D 0;
>>
>>  	if (!(left->flags & EXPR_F_PROTOCOL))
>>  		return;
>>
>>  	assert(expr->op =3D=3D OP_EQ);
>>  	base =3D ctx->protocol[left->payload.base].desc;
>> -	desc =3D proto_find_upper(base, mpz_get_uint32(right->value));
>> +	tmpl =3D &base->templates[base->protocol_key];
>
>Note here, you are fetching the template based on the protocol key:
>
>struct proto_desc {
>        const char                      *name;
>        enum proto_bases                base;
>        unsigned int                    protocol_key;
>        struct {
>                unsigned int                    num;
>                const struct proto_desc         *desc;
>        }                               protocols[PROTO_UPPER_MAX];
>        struct proto_hdr_template       templates[PROTO_HDRS_MAX]; <--=
-
>};
>
>However, the length of the templates array is:
>
>#define PROTO_HDRS_MAX          20
>
>and now see below:
>
>> +	mpz_export_data(&value, right->value, tmpl->dtype->byteorder,
>> +			div_round_up(tmpl->len, BITS_PER_BYTE));
>> +	desc =3D proto_find_upper(base, value);
>>
>>  	proto_ctx_update(ctx, left->payload.base + 1, &expr->location,
>desc);
>>  }
>> @@ -208,7 +213,7 @@ int payload_gen_dependency(struct eval_ctx *ctx,
>const struct expr *expr,
>>  		left =3D payload_expr_alloc(&expr->location, desc,
>desc->protocol_key);
>>
>>  	right =3D constant_expr_alloc(&expr->location, tmpl->dtype,
>> -				    BYTEORDER_HOST_ENDIAN,
>> +				    tmpl->dtype->byteorder,
>>  				    tmpl->len,
>>  				    constant_data_ptr(protocol, tmpl->len));
>>
>> diff --git a/src/proto.c b/src/proto.c
>> index 546ef10..4192108 100644
>> --- a/src/proto.c
>> +++ b/src/proto.c
>> @@ -249,6 +249,7 @@ const struct proto_desc proto_ah =3D {
>>  const struct proto_desc proto_esp =3D {
>>  	.name		=3D "esp",
>>  	.base		=3D PROTO_BASE_TRANSPORT_HDR,
>> +	.protocol_key	=3D IPPROTO_ESP,
>
>IPPROTO_ESP is 50, this won't fly since it's over the array boundary,
>so you will be accessing out of boundary memory area.
>
>I think the protocol_key needs to be an internal value defined in
>include/proto.h, for example:

The protocol *key* specifies the header field contaibing the next layer=
 protocol value, not the protocol number, so using it this way is not c=
orrect.

The easy fix would be to always use big endian byteorder, as all other =
cases have 1 byte keys. I'm actually wondering though, the ethertype fi=
eld is defined using big endian, so the constant should be converted to=
 the correct byte order during evaluation. Unfortunately my notebook br=
oke so I can't check the code right now, but my feeling is that this is=
 where the bug is actually located.

>
>enum transport_protocol {
>        L4PROTO_INVALID,
>        L4PROTO_TCP,
>        L4PROTO_UDP,
>        ...
>};
>
>that you should use instead.


--=20
Diese Nachricht wurde von meinem Android-Mobiltelefon mit K-9 Mail gese=
ndet.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
