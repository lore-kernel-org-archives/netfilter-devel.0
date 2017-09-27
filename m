From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 2/2] src: store expression as set key instead of data
 type
Date: Wed, 27 Sep 2017 15:59:33 +0200
Message-ID: <20170927135933.GA27814@salvia>
References: <20170919124954.26852-1-fw@strlen.de>
 <20170919124954.26852-3-fw@strlen.de>
 <20170927125838.GA26528@salvia>
 <20170927130216.GC14971@breakpoint.cc>
 <20170927131247.GD14971@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:36504 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752864AbdI0N7h (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Sep 2017 09:59:37 -0400
Content-Disposition: inline
In-Reply-To: <20170927131247.GD14971@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Sep 27, 2017 at 03:12:47PM +0200, Florian Westphal wrote:
> Florian Westphal <fw@strlen.de> wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > On Tue, Sep 19, 2017 at 02:49:54PM +0200, Florian Westphal wrote:
> > > > @@ -1023,7 +1036,8 @@ static int list_member_evaluate(struct eval_ctx *ctx, struct expr **expr)
> > > >  	return err;
> > > >  }
> > > >  
> > > > -static int expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
> > > > +static int expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr,
> > > > +				bool evaluate)
> > > 
> > > Hm, why this boolean as parameter?
> > 
> > > > -		if (list_member_evaluate(ctx, &i) < 0)
> > > > +		if (evaluate && list_member_evaluate(ctx, &i) < 0)
> > > >  			return -1;
> > 
> > We choke here because payload expressions don't have a base.
> > 
> > Hence this gets supressed in case we evaluate key.
> 
> Ah wait, you are right, its not needed at the moment because we don't have
> 'typeof' keyword yet.
> 
> I'll push the patch without this.

Ah, that explains why, thanks.

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
