From: Yanchuan Nian <ycnian@gmail.com>
Subject: Re: [nft PATCH] Kill the correct protocol expression during payload
 parsing
Date: Mon, 1 Sep 2014 09:49:53 +0800
Message-ID: <20140901014953.GA25997@localhost.localdomain>
References: <1409375835-28041-1-git-send-email-ycnian@gmail.com>
 <20140830105249.GB25373@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:52807 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbaIABrD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 31 Aug 2014 21:47:03 -0400
Received: by mail-pa0-f44.google.com with SMTP id rd3so10939975pab.17
        for <netfilter-devel@vger.kernel.org>; Sun, 31 Aug 2014 18:47:02 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20140830105249.GB25373@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Aug 30, 2014 at 11:52:49AM +0100, Patrick McHardy wrote:
> On Sat, Aug 30, 2014 at 01:17:15PM +0800, Yanchuan Nian wrote:
> > The protocol expression that should be killed when payload parsing
> > isn't the first one but the last one. Look at the result of this command:
> 
> That patch is competely wrong. Have you actually tested any other case?
> You're simply not killing any payload dependency anymore.
> 
> The correct fix is to check for OP_NEQ and deciding not to kill it based
> on that.
> 
Hi Patrick, Thanks to your replay. Yes, this patch is wrong. It was
careless of me forgetting to test it. I am sorry and I will try to fix
it. Thank you again.
> > 
> > nft> add rule ip filter input ip protocol != tcp tcp sport 80 drop
> > nft> list table ip filter
> > table ip filter {
> > 	chain input {
> > 		 type filter hook input priority 0;
> > 		 ip protocol tcp tcp sport http drop
> > 	}
> > }
> > nft>
> > 
> > With this patch, the result is:
> > nft> add rule ip filter input ip protocol != tcp tcp sport 80 drop
> > nft> list table ip filter
> > table ip filter {
> > 	chain input {
> > 		 type filter hook input priority 0;
> > 		 ip protocol != tcp tcp sport http drop
> > 	}
> > }
> > nft>
> > 
> > Signed-off-by: Yanchuan Nian <ycnian@gmail.com>
> > ---
> >  src/netlink_delinearize.c | 5 ++---
> >  1 file changed, 2 insertions(+), 3 deletions(-)
> > 
> > diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
> > index 195d432..322c7cc 100644
> > --- a/src/netlink_delinearize.c
> > +++ b/src/netlink_delinearize.c
> > @@ -671,12 +671,11 @@ static void payload_match_postprocess(struct rule_pp_ctx *ctx,
> >  			nstmt = expr_stmt_alloc(&stmt->location, nexpr);
> >  			list_add_tail(&nstmt->list, &stmt->list);
> >  
> > -			/* Remember the first payload protocol expression to
> > +			/* Remember the last payload protocol expression to
> >  			 * kill it later on if made redundant by a higher layer
> >  			 * payload expression.
> >  			 */
> > -			if (ctx->pbase == PROTO_BASE_INVALID &&
> > -			    left->flags & EXPR_F_PROTOCOL)
> > +			if (left->flags & EXPR_F_PROTOCOL)
> >  				payload_dependency_store(ctx, nstmt,
> >  							 left->payload.base);
> >  			else
> > -- 
> > 1.9.3
> > 
> 
