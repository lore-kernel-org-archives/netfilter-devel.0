From: =?windows-1252?Q?=C1lvaro_Neira_Ayuso?= <alvaroneay@gmail.com>
Subject: Re: [libnftnl PATCH 1/2] src: not create iterator with empty list
Date: Sat, 10 Jan 2015 19:26:38 +0100
Message-ID: <54B16EDE.7060207@gmail.com>
References: <1420807661-29751-1-git-send-email-alvaroneay@gmail.com> <20150110182022.GA5185@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:63170 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbbAJSeJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 10 Jan 2015 13:34:09 -0500
Received: by mail-wi0-f180.google.com with SMTP id n3so7947907wiv.1
        for <netfilter-devel@vger.kernel.org>; Sat, 10 Jan 2015 10:34:07 -0800 (PST)
In-Reply-To: <20150110182022.GA5185@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

El 10/01/15 a las 19:20, Pablo Neira Ayuso escribi=F3:
> On Fri, Jan 09, 2015 at 01:47:40PM +0100, Alvaro Neira Ayuso wrote:
>> Now, we create iterator without test if the list is empty. If the li=
st
>> is empty, we have a crash when we set up the current element.
>> With this patch, we test if the list is empty before to create the i=
terator. If
>> the list is empty the iterator return NULL.
>
> Please, handle this from the _next() function.
>
> The idea is to set iter->cur to NULL if the list is empty from
> iter_create, ie.
>
>          if (iter->r->expr_list.next =3D=3D &iter->r.expr_list)
>                  iter->cur =3D NULL;
>          else
>                  iter->cur =3D list_entry(...);
>
> Then, from _next() you check for:
>
>          if (expr =3D=3D NULL)
>                  return NULL;

Ok, nice idea.

>
>> Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
>> ---
>>   src/chain.c    |    3 +++
>>   src/rule.c     |    6 ++++++
>>   src/set.c      |    3 +++
>>   src/set_elem.c |    3 +++
>>   src/table.c    |    3 +++
>
> I can count up to six iterator interfaces, I only see 5 here, please
> make sure you adapt all spots. Thanks.
>

mmm yes and I have changed the code in the six iterator interfaces. I=20
have changed:

- nft_chain_list_iter_create
- nft_rule_expr_iter_create
- nft_rule_list_iter_create
- nft_set_list_iter_create
- nft_set_elems_iter_create
- nft_table_list_iter_create

Have I forgot any?
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
