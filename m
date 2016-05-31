From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [nf-next PATCH] netfilter: nf_tables: add support for inverted
 login in nft_lookup
Date: Tue, 31 May 2016 18:42:49 +0200
Message-ID: <CAOkSjBggF4118vD=o4S-fw0y+jnaepTTKpqrnCbWDEiLj3JNBA@mail.gmail.com>
References: <146469443294.16092.10350972377628813816.stgit@nfdev2.cica.es>
 <20160531144401.GB11135@breakpoint.cc> <CAOkSjBgdNOzgbK_v=2_xE2=HUjN508nZNa5knU-BM9zEt-dAzg@mail.gmail.com>
 <CAOkSjBjGVAzVPz8H3NnF_ZBE934nM4ibQ57dk_Eo9gEiG2aX8A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34924 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbcEaQnL convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 31 May 2016 12:43:11 -0400
Received: by mail-wm0-f68.google.com with SMTP id e3so34360757wme.2
        for <netfilter-devel@vger.kernel.org>; Tue, 31 May 2016 09:43:10 -0700 (PDT)
In-Reply-To: <CAOkSjBjGVAzVPz8H3NnF_ZBE934nM4ibQ57dk_Eo9gEiG2aX8A@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 31 May 2016 at 18:18, Arturo Borrero Gonzalez
<arturo.borrero.glez@gmail.com> wrote:
> On 31 May 2016 at 17:50, Arturo Borrero Gonzalez
> <arturo.borrero.glez@gmail.com> wrote:
>> On 31 May 2016 at 16:44, Florian Westphal <fw@strlen.de> wrote:
>>> Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com> wrote:
>>>> -     if (set->ops->lookup(set, &regs->data[priv->sreg], &ext)) {
>>>> +     if (set->ops->lookup(set, &regs->data[priv->sreg], &ext) ^
>>>> +         priv->invert) {
>>>>               if (set->flags & NFT_SET_MAP)
>>>>                       nft_data_copy(&regs->data[priv->dreg],
>>>>                                     nft_set_ext_data(ext), set->dl=
en);
>>>
>>> Whats the plan for SET_MAP here?
>>> You enter 'lookup found a result' branch here in case we did not fi=
nd
>>> anything and invert is set.
>>>
>>> I think its better to use a
>>>
>>> } else if (priv->invert) {
>>>         return;
>>> }
>>>
>
> Not that easy, we should consider 4 cases:
>  * lookup false, invert false -> NFT_BREAK
>  * lookup false, invert true -> return w/o NFT_BREAK
>  * lookup true, invert false -> return w/o NFT_BREAK
>  * lookup true, invert true -> NFT_BREAK
>
> The XOR approach in my original patch seems to over these cases, ie,
> we enter the return branch only if lookup&invert are different.
> I think the nft_data_copy() should not worry us if we prevent the
> combination from happening in _init()
> The only penalty seems the additional boolean check for NFT_SET_MAP
> (which must always fail if priv->invert is true)
>
> So, I'm updating the _init() function with the additional restriction=
s.
>
> Am I missing something else?

We could be also extra defensive a do something like this:

static void nft_lookup_eval(const struct nft_expr *expr,
                            struct nft_regs *regs,
                            const struct nft_pktinfo *pkt)
{
        const struct nft_lookup *priv =3D nft_expr_priv(expr);
        const struct nft_set *set =3D priv->set;
        const struct nft_set_ext *ext;
        bool found;

        found =3D set->ops->lookup(set, &regs->data[priv->sreg], &ext);

        if (!(found ^ priv->invert)) {
                regs->verdict.code =3D NFT_BREAK;
                return;
        }

        if (set->flags & NFT_SET_MAP && found && !priv->invert)
                nft_data_copy(&regs->data[priv->dreg],
                              nft_set_ext_data(ext), set->dlen);

}

( web version http://paste.debian.net/713014 )

But, once _init() has been updated to prevent the combination of flags
and dreg/map, I don't know if it worth these extra checks in _eval().

please let me know your thoughts

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
