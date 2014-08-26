From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [nf_tables PATCH 5/5] netfilter: nf_tables: extend
 NFT_MSG_DELTABLE to support flushing the ruleset
Date: Tue, 26 Aug 2014 13:40:39 +0200
Message-ID: <CAOkSjBiCxnHFTvuNMSw0-P94WPPeYSJBjoWb6jnKqThFhBoVjQ@mail.gmail.com>
References: <20140826095238.3266.80742.stgit@nfdev.cica.es>
 <20140826095700.3266.48972.stgit@nfdev.cica.es> <20140826105322.GA5354@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:65521 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754436AbaHZLlB convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Aug 2014 07:41:01 -0400
Received: by mail-la0-f41.google.com with SMTP id s18so14988799lam.28
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Aug 2014 04:41:00 -0700 (PDT)
In-Reply-To: <20140826105322.GA5354@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 26 August 2014 12:53, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Tue, Aug 26, 2014 at 11:57:01AM +0200, Arturo Borrero Gonzalez wro=
te:
>> This patch extend the NFT_MSG_DELTABLE call to support flushing the =
entire
>> ruleset.
>>
>> The options now are:
>>  * No family speficied, no table specified: flush all the ruleset.
>>  * Family specified, no table specified: flush all tables in the AF.
>>  * Family specified, table specified: flush the given table.
>>
[...]
>> @@ -709,21 +775,31 @@ static int nf_tables_deltable(struct sock *nls=
k, struct sk_buff *skb,
>>       int family =3D nfmsg->nfgen_family;
>>       struct nft_ctx ctx;
>>
>> +     if (family =3D=3D NFPROTO_UNSPEC) {
>> +             if (nla[NFTA_TABLE_NAME] !=3D NULL)
>> +                     return -EINVAL;
>
> We should implement this too. I think you can replace
> nft_flush_ruleset and nft_flush_family by something more generic like=
:
>
> static int nf_tables_flush(struct net *net, ...)
> {
>         ...
>
>         list_for_each_entry(afi, &net->nft.af_info, list) {
>                  if (family !=3D AF_UNSPEC && afi->family !=3D family=
)
>                         continue;
>
>                  list_for_each_entry_safe(table, next, afi->tables, l=
ist) {
>                         if (nla[NFTA_TABLE_NAME] &&
>                             nla_strcmp(nla[NFTA_TABLE_NAME], table->n=
ame) !=3D 0)
>                                 continue;
>
>                         err =3D nft_flush_table(table);
>                         ...
>                  }
>         }
>         return err;
> }
>

Ok. I agree.

> You can also skip the nft_ctx_init with this since it's quite empty
> and I guess my proposed nf_tables_flush should take around three
> parameters.
>

All functions take that nft_ctx and fill the needed data for the inner
and later functions (trans allocation, trans commit/abort, event
notifications..). I didn't find a cleaner way to do it, and the
nft_ctx_init() doesn't hurt.

So, I think we still need to use the nft_ctx even with that small
data, don't you?
--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
