From: =?ISO-8859-1?Q?=C1lvaro_Neira_Ayuso?= <alvaroneay@gmail.com>
Subject: Re: [nft PATCH 1/4] payload: generate dependency in the appropriate
 byteorder
Date: Mon, 22 Sep 2014 11:01:48 +0200
Message-ID: <541FE57C.2090806@gmail.com>
References: <1411327957-19379-1-git-send-email-alvaroneay@gmail.com> <20140922075413.GI4971@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:51807 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594AbaIVJBf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Sep 2014 05:01:35 -0400
Received: by mail-we0-f171.google.com with SMTP id k48so2514393wev.30
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Sep 2014 02:01:33 -0700 (PDT)
In-Reply-To: <20140922075413.GI4971@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

El 22/09/14 09:54, Patrick McHardy escribi=F3:
> On Sun, Sep 21, 2014 at 09:32:34PM +0200, Alvaro Neira Ayuso wrote:
>> If we add a dependency, the constant expression on the right
>> hand side must be represented in the appropriate order.
>
> What problem does this actually fix? Please include an example what i=
s
> broken if you want to fix something.

Sure. For example, with the new complete reject support. If we want to=20
add a reject rule for bridge, I add a ether type dependency to delimit=20
the traffic that we want to filter.

Example without this patch:

nft add rule bridge filter input reject with icmp-host-unreach --debug=20
netlink

[ payload load 2b @ link header + 12 =3D> reg 1 ]
[ cmp eq reg 1 0x00000800 ]
[ reject type 0 code 1 ]

When we create the payload expression we have the right value in host=20
endian but this has to be in big endian.

With this patch, if we add the same rule:

nft add rule bridge filter input reject with icmp-host-unreach --debug=20
netlink

[ payload load 2b @ link header + 12 =3D> reg 1 ]
[ cmp eq reg 1 0x00000008 ]
[ reject type 0 code 1 ]

The new dependency is converted to big endian.

>
>> Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
>> ---
>>   src/payload.c |    3 +--
>>   1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/src/payload.c b/src/payload.c
>> index 1eee4e0..a3bbe51 100644
>> --- a/src/payload.c
>> +++ b/src/payload.c
>> @@ -216,8 +216,7 @@ int payload_gen_dependency(struct eval_ctx *ctx,=
 const struct expr *expr,
>>   		left =3D payload_expr_alloc(&expr->location, desc, desc->protoco=
l_key);
>>
>>   	right =3D constant_expr_alloc(&expr->location, tmpl->dtype,
>> -				    BYTEORDER_HOST_ENDIAN,
>> -				    tmpl->len,
>> +				    tmpl->dtype->byteorder, tmpl->len,
>>   				    constant_data_ptr(protocol, tmpl->len));
>>
>>   	dep =3D relational_expr_alloc(&expr->location, OP_EQ, left, right=
);
>> --
>> 1.7.10.4
>>

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
