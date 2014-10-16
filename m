From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nf_tables PATCH 3/3] netfilter: nf_tables: add new expression
 nft_redir
Date: Thu, 16 Oct 2014 10:41:50 +0200
Message-ID: <20141016084150.GB8862@salvia>
References: <20141014172231.5983.37941.stgit@nfdev.cica.es>
 <20141014172242.5983.11604.stgit@nfdev.cica.es>
 <20141015100619.GC4885@salvia>
 <CAOkSjBh4TJ5kqX_hCf+AnnB8HQfbv=crywwxdQ4x4+K5M1NVmA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50092 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765AbaJPIk1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Oct 2014 04:40:27 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBh4TJ5kqX_hCf+AnnB8HQfbv=crywwxdQ4x4+K5M1NVmA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Oct 15, 2014 at 01:14:12PM +0200, Arturo Borrero Gonzalez wrote:
> On 15 October 2014 12:06, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >> +int nft_redir_init(const struct nft_ctx *ctx,
> >> +                const struct nft_expr *expr,
> >> +                const struct nlattr * const tb[])
> >> +{
> >> +     struct nft_redir *priv = nft_expr_priv(expr);
> >> +     int err;
> >> +
> >> +     if (tb[NFTA_REDIR_REG_PROTO_MIN]) {
> >> +             priv->sreg_proto_min = ntohl(nla_get_be32(
> >> +                                             tb[NFTA_REDIR_REG_PROTO_MIN]));
> >
> > I prefer this:
> >
> >                 priv->sreg_proto_min =
> >                         ntohl(nla_get_be32(tb[NFTA_REDIR_REG_PROTO_MIN]));
> >
> >
> >> +             err = nft_validate_input_register(priv->sreg_proto_min);
> >> +             if (err < 0)
> >> +                     return err;
> >> +     }
> >
> > No else here? ->sreg_proto_min is left uninitialized.
> >
> 
> Such behaviour is copied from nft_nat.
> I'm not sure to which value I should initialize sreg_proto_min.

This seems fine for redirect as ->sreg_proto_min will be zero. Keep in
mind that we have to support redirect with no port range specified. I
mean, iptables supports -j REDIRECT without arguments.

Regarding nft_nat, not good. I'm going to send a patch to reject
invalid configurations. At least one of the NFTA_NAT_REG_*_MIN needs to
be specified.
