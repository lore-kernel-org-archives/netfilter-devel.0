From: =?ISO-8859-1?Q?=C1lvaro_Neira_Ayuso?= <alvaroneay@gmail.com>
Subject: Re: [nft PATCH 3/4] evaluate: no check the network context in reject
 with tcp reset reason
Date: Tue, 21 Oct 2014 14:32:58 +0200
Message-ID: <5446527A.5020900@gmail.com>
References: <1413847780-10149-1-git-send-email-alvaroneay@gmail.com> <1413847780-10149-3-git-send-email-alvaroneay@gmail.com> <20141021075544.GA3220@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:38251 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755355AbaJUMcq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Oct 2014 08:32:46 -0400
Received: by mail-wi0-f182.google.com with SMTP id bs8so846101wib.3
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Oct 2014 05:32:41 -0700 (PDT)
In-Reply-To: <20141021075544.GA3220@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

El 21/10/14 09:55, Pablo Neira Ayuso escribi=F3:
> On Tue, Oct 21, 2014 at 01:29:39AM +0200, Alvaro Neira Ayuso wrote:
>> nft add rule -nnn bridge test-bridge input \
>> 			ip protocol tcp reject with tcp reset
>>
>> If we use in reject the type tcp reset. We don't need to check if th=
e network
>> context is compatible with the reason. This patch fix that.
>>
>> Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
>> ---
>>   src/evaluate.c |   80 +++++++++++++++++++++++++++++++++-----------=
------------
>>   1 file changed, 47 insertions(+), 33 deletions(-)
>>
>> diff --git a/src/evaluate.c b/src/evaluate.c
>> index 20235a8..8b19baf 100644
>> --- a/src/evaluate.c
>> +++ b/src/evaluate.c
>> @@ -1208,24 +1208,31 @@ static int stmt_evaluate_reject_inet(struct =
eval_ctx *ctx, struct stmt *stmt,
>>   	const struct proto_desc *desc, *base;
>>   	int protocol;
>>
>> -	base =3D ctx->pctx.protocol[PROTO_BASE_LL_HDR].desc;
>> -	desc =3D ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
>> -	if (desc !=3D NULL) {
>> -		protocol =3D proto_find_num(base, desc);
>> -		switch (protocol) {
>> -		case NFPROTO_IPV4:
>> -			if (stmt->reject.family =3D=3D NFPROTO_IPV4)
>> -				return 0;
>> -			return stmt_error(ctx, stmt,
>> -			  "conflicting protocols specified: ip vs ip6");
>> -		case NFPROTO_IPV6:
>> -			if (stmt->reject.family =3D=3D NFPROTO_IPV6)
>> -				return 0;
>> -			return stmt_error(ctx, stmt,
>> -			  "conflicting protocols specified: ip vs ip6");
>> -		default:
>> -			BUG("unsupported family");
>> +	switch (stmt->reject.type) {
>> +	case NFT_REJECT_TCP_RST:
>> +		break;
>> +	case NFT_REJECT_ICMPX_UNREACH:
>
> Do you really need to check layer 3 conflicts with icmpx?

Ups you're right. In Inet tables we don't need to check it. We only hav=
e=20
Ipv4 and Ipv6 traffic. I have been focus in bridge and I have followed=20
the same steps (check the network context) like bridge tables and in=20
Inet is not necessary.

I'm going to fix it. Thanks Pablo

>
>> +	case NFT_REJECT_ICMP_UNREACH:
>> +		base =3D ctx->pctx.protocol[PROTO_BASE_LL_HDR].desc;
>> +		desc =3D ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
>> +		if (desc !=3D NULL) {
>> +			protocol =3D proto_find_num(base, desc);
>> +			switch (protocol) {
>> +			case NFPROTO_IPV4:
>> +				if (stmt->reject.family =3D=3D NFPROTO_IPV4)
>> +					return 0;
>> +				return stmt_error(ctx, stmt,
>> +				  "conflicting protocols specified: ip vs ip6");
>> +			case NFPROTO_IPV6:
>> +				if (stmt->reject.family =3D=3D NFPROTO_IPV6)
>> +					return 0;
>> +				return stmt_error(ctx, stmt,
>> +				  "conflicting protocols specified: ip vs ip6");
>> +			default:
>> +				BUG("unsupported family");
>> +			}
>>   		}
>> +		break;
>>   	}
>>   	if (stmt->reject.type =3D=3D NFT_REJECT_ICMPX_UNREACH)
>>   		return 0;

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
