From: =?ISO-8859-1?Q?=C1lvaro_Neira_Ayuso?= <alvaroneay@gmail.com>
Subject: Re: [nft PATCH 1/4 v2] evaluate: fix a crash if we specify ether
 type or meta nfproto in reject
Date: Fri, 17 Oct 2014 15:44:18 +0200
Message-ID: <54411D32.3050803@gmail.com>
References: <1413548677-10287-1-git-send-email-alvaroneay@gmail.com> <20141017125538.GC3644@salvia> <5441134F.6020104@gmail.com> <20141017133817.GA4163@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:56263 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbaJQNoC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Oct 2014 09:44:02 -0400
Received: by mail-wi0-f173.google.com with SMTP id fb4so2151165wid.0
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Oct 2014 06:44:00 -0700 (PDT)
In-Reply-To: <20141017133817.GA4163@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

El 17/10/14 15:38, Pablo Neira Ayuso escribi=F3:
> On Fri, Oct 17, 2014 at 03:02:07PM +0200, =C1lvaro Neira Ayuso wrote:
>> El 17/10/14 14:55, Pablo Neira Ayuso escribi=F3:
>>> On Fri, Oct 17, 2014 at 02:24:34PM +0200, Alvaro Neira Ayuso wrote:
>>>> If we use a rule:
>>>> nft add rule bridge filter input \
>>>> 	ether type ip reject with icmp type host-unreachable
>>>>
>>>> or this:
>>>>
>>>> nft add rule inet filter input \
>>>> 	meta nfproto ipv4 reject with icmp type host-unreachable
>>>>
>>>> we have a segfault because we add a network dependency when we alr=
eady have
>>>> network context.
>>>>
>>>> Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
>>>> ---
>>>> [changes in v2]
>>>> * Fixed a incorrect refactor when we check the family in bridge
>>>>
>>>>   src/evaluate.c |   57 ++++++++++++++++++++++++++++++++++++++++++=
+++++++++++++-
>>>>   1 file changed, 56 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/src/evaluate.c b/src/evaluate.c
>>>> index 83ef749..4b7bda9 100644
>>>> --- a/src/evaluate.c
>>>> +++ b/src/evaluate.c
>>>> @@ -19,6 +19,7 @@
>>>>   #include <linux/netfilter/nf_tables.h>
>>>>   #include <netinet/ip_icmp.h>
>>>>   #include <netinet/icmp6.h>
>>>> +#include <net/ethernet.h>
>>>>
>>>>   #include <expression.h>
>>>>   #include <statement.h>
>>>> @@ -1193,6 +1194,8 @@ static int stmt_reject_gen_dependency(struct=
 eval_ctx *ctx, struct stmt *stmt,
>>>>   		BUG("cannot generate reject dependency for type %d",
>>>>   		    stmt->reject.type);
>>>>   	}
>>>> +	if (payload =3D=3D NULL)
>>>> +		return 0;
>>>
>>> Why this check?
>>
>> If we already have context, the previously functions return a NULL
>> payload. Therefore, if we try to create a dependency with this NULL
>> payload, we have a crash.
>
> I prefer if you can change the return value logic in
> reject_payload_gen_dependency*() to:
>
>    1: payload dependency was created
>    0: no payload dependency needed
>   -1: error
>
> See patch attached.
>

Nice idea. Looks good to me.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
