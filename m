From: Eric Leblond <eric@regit.org>
Subject: Re: [nft PATH 15/16] libnftables: add error handling
Date: Sat, 19 Aug 2017 11:04:58 +0200
Message-ID: <1503133498.31564.22.camel@regit.org>
References: <20170816204310.3371-1-eric@regit.org>
         <20170816204310.3371-16-eric@regit.org>
         <20170817103252.GZ16375@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:57920 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751671AbdHSJFC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Aug 2017 05:05:02 -0400
In-Reply-To: <20170817103252.GZ16375@orbyte.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Thu, 2017-08-17 at 12:32 +0200, Phil Sutter wrote:
> On Wed, Aug 16, 2017 at 10:43:09PM +0200, Eric Leblond wrote:
> [...]
> > diff --git a/src/libnftables.c b/src/libnftables.c
> > index c50c068..a42e8f1 100644
> > --- a/src/libnftables.c
> > +++ b/src/libnftables.c
> > @@ -86,6 +86,7 @@ struct nft_ctx *nft_context_new(void)
> >  	ctx->nf_sock = netlink_open_sock();
> >  
> >  	init_list_head(&ctx->cache.list);
> > +	init_list_head(&ctx->output.msgs);
> >  
> >  	ctx->output.ctx = ctx;
> >  	ctx->output.print = nft_print;
> > @@ -108,6 +109,7 @@ void nft_context_free(struct nft_ctx *nft)
..
> >  	struct parser_state state;
> > -	LIST_HEAD(msgs);
> >  	void *scanner;
> >  
> > -	parser_init(nft->nf_sock, &nft->cache, &state, &msgs);
> > +	parser_init(nft->nf_sock, &nft->cache, &state, &nft-
> > >output.msgs);
> 
> Change signature to take struct nft_ctx as first parameter and get
> rid
> of everything but struct parser_state?

Fully agree with proposal.

> 
> >  	scanner = scanner_init(&state);
> >  	scanner_push_buffer(scanner, &indesc_cmdline, buf);
> >  		
> > -	if (nft_run(nft, nft->nf_sock, &nft->cache, scanner,
> > &state, &msgs) != 0)
> > +	if (nft_run(nft, nft->nf_sock, &nft->cache, scanner,
> > +		    &state, &nft->output.msgs) != 0)
> 
> Just use nft->output.msg directly in nft_run() and drop the
> parameter?

Yes, I think we can go and simplify a few functions prototype. I did
not do it cause of lack of time but also because I wanted to have
everybody agree on the data model before doing this changes.

++
-- 
Eric Leblond <eric@regit.org>
Blog: https://home.regit.org/
