From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] src: add redirect support
Date: Thu, 16 Oct 2014 10:36:42 +0200
Message-ID: <20141016083642.GA8862@salvia>
References: <20141015074756.30515.90161.stgit@nfdev.cica.es>
 <20141015100829.GD4885@salvia>
 <CAOkSjBiU-65GEOiWnjqsMJ7VxDt5uHGhhu-caaNGLiZarkNCbg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48466 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765AbaJPIfO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Oct 2014 04:35:14 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBiU-65GEOiWnjqsMJ7VxDt5uHGhhu-caaNGLiZarkNCbg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Oct 15, 2014 at 12:13:16PM +0200, Arturo Borrero Gonzalez wrote:
> On 15 October 2014 12:08, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >> +     if (stmt->redir.proto != NULL) {
> >> +             if (pctx->protocol[PROTO_BASE_TRANSPORT_HDR].desc == NULL)
> >> +                     return stmt_binary_error(ctx, stmt->redir.proto, stmt,
> >> +                                              "transport protocol mapping "
> >> +                                              "is only valid after "
> >> +                                              "transport protocol match");
> >
> > Errors have to fit in one line, preferably.
> >
> 
> Could you please give some suggestion?

missing transport protocol match
