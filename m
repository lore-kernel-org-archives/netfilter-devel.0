From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [nf-next PATCH] netfilter: nf_tables: add support for inverted
 login in nft_lookup
Date: Tue, 31 May 2016 17:50:55 +0200
Message-ID: <CAOkSjBgdNOzgbK_v=2_xE2=HUjN508nZNa5knU-BM9zEt-dAzg@mail.gmail.com>
References: <146469443294.16092.10350972377628813816.stgit@nfdev2.cica.es> <20160531144401.GB11135@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:37271 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbcEaPvQ convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 31 May 2016 11:51:16 -0400
Received: by mail-wm0-f47.google.com with SMTP id z87so113924749wmh.0
        for <netfilter-devel@vger.kernel.org>; Tue, 31 May 2016 08:51:15 -0700 (PDT)
In-Reply-To: <20160531144401.GB11135@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 31 May 2016 at 16:44, Florian Westphal <fw@strlen.de> wrote:
> Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com> wrote:
>> -     if (set->ops->lookup(set, &regs->data[priv->sreg], &ext)) {
>> +     if (set->ops->lookup(set, &regs->data[priv->sreg], &ext) ^
>> +         priv->invert) {
>>               if (set->flags & NFT_SET_MAP)
>>                       nft_data_copy(&regs->data[priv->dreg],
>>                                     nft_set_ext_data(ext), set->dlen=
);
>
> Whats the plan for SET_MAP here?
> You enter 'lookup found a result' branch here in case we did not find
> anything and invert is set.
>
> I think its better to use a
>
> } else if (priv->invert) {
>         return;
> }
>
> here.
>

Totally right, thanks.

>> @@ -47,6 +49,7 @@ static const struct nla_policy nft_lookup_policy[N=
=46TA_LOOKUP_MAX + 1] =3D {
>>       [NFTA_LOOKUP_SET_ID]    =3D { .type =3D NLA_U32 },
>>       [NFTA_LOOKUP_SREG]      =3D { .type =3D NLA_U32 },
>>       [NFTA_LOOKUP_DREG]      =3D { .type =3D NLA_U32 },
>> +     [NFTA_LOOKUP_FLAGS]     =3D { .type =3D NLA_U32 },
>>  };
>>
>>  static int nft_lookup_init(const struct nft_ctx *ctx,
>> @@ -55,6 +58,7 @@ static int nft_lookup_init(const struct nft_ctx *c=
tx,
>>  {
>>       struct nft_lookup *priv =3D nft_expr_priv(expr);
>>       struct nft_set *set;
>> +     u32 flags;
>>       int err;
>>
>>       if (tb[NFTA_LOOKUP_SET] =3D=3D NULL ||
>> @@ -91,6 +95,12 @@ static int nft_lookup_init(const struct nft_ctx *=
ctx,
>>       } else if (set->flags & NFT_SET_MAP)
>>               return -EINVAL;
>>
>> +     if (tb[NFTA_LOOKUP_FLAGS]) {
>> +             flags =3D ntohl(nla_get_be32(tb[NFTA_LOOKUP_FLAGS]));
>> +             if (flags & NFT_LOOKUP_F_INV)
>> +                     priv->invert =3D true;
>> +     }
>> +
>
> I think we should EINVAL if NFT_LOOKUP_F_INV is given with dreg/map.

ok

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
