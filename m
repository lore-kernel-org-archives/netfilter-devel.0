From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC nftables kernel PATCH] netfilter: nf_tables: fix
  nft_meta_target module
Date: Wed, 4 Dec 2013 14:21:19 +0100
Message-ID: <20131204132119.GA13212@localhost>
References: <20131128111557.6154.40370.stgit@nfdev.cica.es>
 <5297382F.60707@linux.intel.com>
 <CAOkSjBj+XER8sn1eakaTDyDJPUn=t50WFYLE8zF4uP7Ef9TTOA@mail.gmail.com>
 <529745ED.5050201@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53259 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753680Ab3LDNVY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Dec 2013 08:21:24 -0500
Content-Disposition: inline
In-Reply-To: <529745ED.5050201@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Arturo,

Thanks for working on recovering the meta_target code.

On Thu, Nov 28, 2013 at 03:32:29PM +0200, Tomasz Bursztyka wrote:
> Hi Arturo,
>
> >>All expression have a short, one-word based name, which is nice.
> >Yes, any suggestion?
>
> Always the tricky part ^^ (complaining about is easy...).
> But we might avoid that:
>
> >>Anyway, doesn't it work already: if you create an immediate expression (to
> >>load the value you want, at default dreg 0 aka NFT_REG_VERDICT) and a meta
> >>expression without the NFTA_META_DREG set? (didn't try myself)
> >>
> >I commented the immediate load with Pablo. He suggested the value to
> >be fetched from the metatarget directly.
>
> Ok I see it optimize things, then below:
>
> >>If not maybe there is a shorter way to fix this, instead of creating a full
> >>new expression. Looks like it was the original plan.
> >>
> >You mean the original plan was to avoid creating a new expression?
> >In that case, I will have to revisit this, as I wasn't considering
> >this approach.
>
> Thus, why not adding an attribute to the meta expression. Like:
> NFTA_META_SVAL? (Of course NFTA_META_DREG and this new attribute are
> mutually exclusive)
>
> I guess then you only need to adapt struct nft_policy in
> nft_meta_target.c to handle it, and adding value element in its
> nft_meta struct, and there you are.
>
> Less code and API change.

I think we have to merge the meta_target into meta, so we provide one
single "meta" instruction that allows us to load and store data in
skbuff meta fields. We would also save having two kernel modules.

We have the select_ops API that allows us to have different "flavours"
of our instructions depending on the attributes that we get. At the
time the meta_target was written, there was no select_ops API.

static const struct nft_expr_ops *
nft_meta_select_ops(const struct nft_ctx *ctx,
                    const struct nlattr * const tb[])
{
        struct nft_xt *nft_match;
        struct xt_match *match;
        char *mt_name;
        __u32 rev, family;

        if (tb[NFTA_META_SREG] && tb[NFTA_META_VALUE])
                return ERR_PTR(-EINVAL);

        if (tb[NFTA_META_SREG])
                return &nft_meta_match_ops;

        if (tb[NFTA_META_VALUE])
                return &nft_meta_target_ops;

        return ERR_PTR(-EINVAL);
}

Then:

static struct nft_expr_type nft_meta_type;
static const struct nft_expr_ops nft_meta_match_ops = {
        .type           = &nft_meta_type,
        .size           = NFT_EXPR_SIZE(sizeof(struct nft_meta)),
        .eval           = nft_meta_match_eval,
        .init           = nft_meta_init,
        .dump           = nft_meta_dump,
};

static const struct nft_expr_ops nft_meta_target_ops = {
        .type           = &nft_meta_type,
        .size           = NFT_EXPR_SIZE(sizeof(struct nft_meta_target)),
        .eval           = nft_meta_target_eval,
        .init           = nft_meta_init,
        .dump           = nft_meta_dump,
};

_init and _dump can be the same I guess.

@Arturo: Please, check nft_payload.c on how to use the select_ops API
and let me know if you have any doubt. I can give you a hand on it.
