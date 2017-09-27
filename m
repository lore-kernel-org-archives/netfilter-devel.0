From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft 2/2] src: store expression as set key instead of data
 type
Date: Wed, 27 Sep 2017 15:02:16 +0200
Message-ID: <20170927130216.GC14971@breakpoint.cc>
References: <20170919124954.26852-1-fw@strlen.de>
 <20170919124954.26852-3-fw@strlen.de>
 <20170927125838.GA26528@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:36362 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752282AbdI0NFq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Sep 2017 09:05:46 -0400
Content-Disposition: inline
In-Reply-To: <20170927125838.GA26528@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Tue, Sep 19, 2017 at 02:49:54PM +0200, Florian Westphal wrote:
> > @@ -1023,7 +1036,8 @@ static int list_member_evaluate(struct eval_ctx *ctx, struct expr **expr)
> >  	return err;
> >  }
> >  
> > -static int expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
> > +static int expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr,
> > +				bool evaluate)
> 
> Hm, why this boolean as parameter?

> > -		if (list_member_evaluate(ctx, &i) < 0)
> > +		if (evaluate && list_member_evaluate(ctx, &i) < 0)
> >  			return -1;

We choke here because payload expressions don't have a base.

Hence this gets supressed in case we evaluate key.
