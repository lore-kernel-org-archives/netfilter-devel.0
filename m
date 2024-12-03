Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07DF3207A0F;
	Tue,  3 Dec 2024 20:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733257343; cv=none; b=aZfuHN/2+h3/2tei00TvVAEviH7vz2C2edGL8pFSYdDAxQ/koS4XFRcMHFjYhLIQ6ZZgBwcrpI8Q0giUFaj9R9Hi6Mf96zNn822W8MfpZJ+wblrZHDCaMXcgPpLPJBVjpLaEkG1XHCiO4UKreB405V6hbtNxKfC4Sqyy2ema9Js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733257343; c=relaxed/simple;
	bh=OQbopC9Iq+3uWsPRdL7oJwpiwHgMnnBK9gRn5Vrzj/M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gfllqvM1E4VaMNCRg2IYt3Jt5Zpgtl5OuNgGad0mR1U7YmhDD43eyRdYmZU+9BntqIiV+f2cifeboEumPmyB1a4Ova8rVtqvbyRBcpR8bXviBQsVxt6vZZJeF+B9oY5Y8T7WVEWa7AimG7jD8gAP78Cv9PoMISe4xoBcX7Y710s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.39.247] (port=55290 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1tIZPK-003CIU-Ht; Tue, 03 Dec 2024 21:22:08 +0100
Date: Tue, 3 Dec 2024 21:22:05 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Eric Dumazet <edumazet@google.com>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	fw@strlen.de
Subject: Re: [PATCH net 4/4] netfilter: nft_inner: incorrect percpu area
 handling under softirq
Message-ID: <Z09obUXveguG2nOy@calendula>
References: <20241128123840.49034-1-pablo@netfilter.org>
 <20241128123840.49034-5-pablo@netfilter.org>
 <CANn89iKGUKxLGY4UG9JrAVQR5bahHrUurf7TVwPcE4rf4g3cAQ@mail.gmail.com>
 <Z00MOYmYgmlrrpWN@calendula>
 <CANn89i+G3_0QzdOsoCMOk-Qgd+Vv7hKEtogMNJ00pUGC1wX=ow@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANn89i+G3_0QzdOsoCMOk-Qgd+Vv7hKEtogMNJ00pUGC1wX=ow@mail.gmail.com>
X-Spam-Score: -1.9 (-)

Hi Eric,

On Mon, Dec 02, 2024 at 10:17:10AM +0100, Eric Dumazet wrote:
> On Mon, Dec 2, 2024 at 2:24 AM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >
> > Hi Eric,
> >
> > On Fri, Nov 29, 2024 at 10:14:34AM +0100, Eric Dumazet wrote:
> > > On Thu, Nov 28, 2024 at 1:38 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > >
> > > > Softirq can interrupt packet from process context which walks over the
> > > > percpu area.
> > > >
> > > > Add routines to disable bh while restoring and saving the tunnel parser
> > > > context from percpu area to stack. Add a skbuff owner for this percpu
> > > > area to catch softirq interference to exercise the packet tunnel parser
> > > > again in such case.
> > > >
> > > > Reported-by: syzbot+84d0441b9860f0d63285@syzkaller.appspotmail.com
> > > > Fixes: 3a07327d10a0 ("netfilter: nft_inner: support for inner tunnel header matching")
> > > > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > > > ---
> > > >  include/net/netfilter/nf_tables_core.h |  1 +
> > > >  net/netfilter/nft_inner.c              | 56 ++++++++++++++++++++------
> > > >  2 files changed, 45 insertions(+), 12 deletions(-)
> > > >
> > > > diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
> > > > index ff27cb2e1662..dae0e7592934 100644
> > > > --- a/include/net/netfilter/nf_tables_core.h
> > > > +++ b/include/net/netfilter/nf_tables_core.h
> > > > @@ -161,6 +161,7 @@ enum {
> > > >  };
> > > >
> > > >  struct nft_inner_tun_ctx {
> > > > +       struct sk_buff *skb;    /* percpu area owner */
> > > >         u16     type;
> > > >         u16     inner_tunoff;
> > > >         u16     inner_lloff;
> > > > diff --git a/net/netfilter/nft_inner.c b/net/netfilter/nft_inner.c
> > > > index 928312d01eb1..fcaa126ac8da 100644
> > > > --- a/net/netfilter/nft_inner.c
> > > > +++ b/net/netfilter/nft_inner.c
> > > > @@ -210,35 +210,65 @@ static int nft_inner_parse(const struct nft_inner *priv,
> > > >                            struct nft_pktinfo *pkt,
> > > >                            struct nft_inner_tun_ctx *tun_ctx)
> > > >  {
> > > > -       struct nft_inner_tun_ctx ctx = {};
> > > >         u32 off = pkt->inneroff;
> > > >
> > > >         if (priv->flags & NFT_INNER_HDRSIZE &&
> > > > -           nft_inner_parse_tunhdr(priv, pkt, &ctx, &off) < 0)
> > > > +           nft_inner_parse_tunhdr(priv, pkt, tun_ctx, &off) < 0)
> > > >                 return -1;
> > > >
> > > >         if (priv->flags & (NFT_INNER_LL | NFT_INNER_NH)) {
> > > > -               if (nft_inner_parse_l2l3(priv, pkt, &ctx, off) < 0)
> > > > +               if (nft_inner_parse_l2l3(priv, pkt, tun_ctx, off) < 0)
> > > >                         return -1;
> > > >         } else if (priv->flags & NFT_INNER_TH) {
> > > > -               ctx.inner_thoff = off;
> > > > -               ctx.flags |= NFT_PAYLOAD_CTX_INNER_TH;
> > > > +               tun_ctx->inner_thoff = off;
> > > > +               tun_ctx->flags |= NFT_PAYLOAD_CTX_INNER_TH;
> > > >         }
> > > >
> > > > -       *tun_ctx = ctx;
> > > >         tun_ctx->type = priv->type;
> > > > +       tun_ctx->skb = pkt->skb;
> > > >         pkt->flags |= NFT_PKTINFO_INNER_FULL;
> > > >
> > > >         return 0;
> > > >  }
> > > >
> > > > +static bool nft_inner_restore_tun_ctx(const struct nft_pktinfo *pkt,
> > > > +                                     struct nft_inner_tun_ctx *tun_ctx)
> > > > +{
> > > > +       struct nft_inner_tun_ctx *this_cpu_tun_ctx;
> > > > +
> > > > +       local_bh_disable();
> > > > +       this_cpu_tun_ctx = this_cpu_ptr(&nft_pcpu_tun_ctx);
> > > > +       if (this_cpu_tun_ctx->skb != pkt->skb) {
> > >
> > > I must say I do not understand this patch.
> > >
> > > If a context is used by a save/restore more than one time per packet
> > > traversal, then this means we can not use per-cpu storage,
> > > or risk flakes.
> > >
> > > Also, skb could be freed and re-allocated ?
> > >
> > > Perhaps describe a bit more what is going on in the changelog.
> >
> > There is an on-stack nft_pktinfo structure with a flags field. This
> > nft_pktinfo is a wrapper for the sk_buff, containing header offsets
> > and metainformation. This is initialize when entering this chain.
> >
> > If the NFT_PKTINFO_INNER_FULL flag is set on, then the percpu area
> > could contain information on the inner header offsets (ie. packet was
> > already parsed in this chain).
> >
> > There is a check to validate that the percpu area refers to this
> > skbuff. If there is a mismatch, then this needs to parse the inner
> > headers because the data in the percpu area is stale. Otherwise, if
> > there is a match, the percpu area is copied on-stack.
> >
> > After processing (payload/meta fetching), the on-stack copy is stored
> > back to the percpu area. I can make an improvement on this patch to
> > check if this skbuff still owns the percpu area in the store/exit
> > section of this inner evaluation routine, to avoid a unnecessary update.
> >
> > So, it is basically the NFT_PKTINFO_INNER_FULL flag that handles the
> > skbuff reallocation scenario. This is not blindly trusting this percpu
> > area per-se.
> >
> > One comestic change I can apply to this: I can also turn the struct
> > sk_buff into unsigned long so it clear to the reader this pointer to
> > skbuff is not meant to be used for being dereferenced.
> >
> > If the explaination above is sufficient, I can revamp to extend the
> > changelog as you suggest and post a new version of this patch.
> >
> > Thanks.
> 
> The part I do not understand is that tun_ctx->skb is not cleared at
> the end of processing (or at some point)
> 
> That would make clear that a future (tun_ctx->skb == skb) test is not
> confused by skb reuse (free/alloc).
>
> If you use it as a cookie, then we need something else than a pointer.

Revisiting this...

This is performing _three checks_ to validate that the percpu area is
valid for this skbuff:

static bool nft_inner_parse_needed(const struct nft_inner *priv,
                                   const struct nft_pktinfo *pkt,
                                   struct nft_inner_tun_ctx *tun_ctx)
{
        if (!(pkt->flags & NFT_PKTINFO_INNER_FULL))
                return true;

1) pkt->flags & NFT_PKTINFO_INNER_FULL tells us this percpu area could
   contain information for this skbuff already _in this chain_.

        if (!nft_inner_restore_tun_ctx(pkt, tun_ctx))
                return true;

2) this above checks if (tun_ctx->skb == skb)

        if (priv->type != tun_ctx->type)
                return true;

3) this also checks if inner header type in percpu area is the same
   as the type of this match.

But NFT_PKTINFO_INNER_FULL is only set for this packet in the context
of the chain.

I don't have a way to clear the percpu area, because I don't know what
would be the last rule that will try to match on inner headers.

As far as I understand, the problematic scenario is this:

   (process context)
        skb A Rule 1, no NFT_PKTINFO_INNER_FULL flag, initialize percpu area
        skb A Rule 2, NFT_PKTINFO_INNER_FULL is set, use percpu area ... but softirq comes while evaluating
        (softirq)
             skb B Rule 1, no NFT_PKTINFO_INNER_FULL flag, initialize percpu area
             (this is overriding the percpu and updating the cookie).
             skb B Rule 2, NFT_PKTINFO_INNER_FULL flag is set, use percpu area
             skb B Rule 3, NFT_PKTINFO_INNER_FULL flag is set, use percpu area
             skb B end of processing
   (resume to process context)
        skb A Rule 2, override percpu area
        skb A Rule 3, NFT_PKTINFO_INNER_FULL is set, use percpu area

I think this approach in this patch is sufficient to deal with this.

I can expand commit description and rename variable to _cookie_ to
make it more obvious to the reader.

Thanks.
