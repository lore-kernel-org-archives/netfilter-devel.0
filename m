From: Eric Leblond <eric@regit.org>
Subject: Re: [nft PATH 10/16] libnftables: get rid of printf
Date: Sat, 19 Aug 2017 10:59:15 +0200
Message-ID: <1503133155.31564.20.camel@regit.org>
References: <20170816204310.3371-1-eric@regit.org>
         <20170816204310.3371-11-eric@regit.org>
         <20170817100111.GX16375@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:57844 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751008AbdHSI7S (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Aug 2017 04:59:18 -0400
In-Reply-To: <20170817100111.GX16375@orbyte.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Thu, 2017-08-17 at 12:01 +0200, Phil Sutter wrote:
> On Wed, Aug 16, 2017 at 10:43:04PM +0200, Eric Leblond wrote:
> [...]
> > diff --git a/include/nftables.h b/include/nftables.h
> > index 348fbb0..ddff5d8 100644
> > --- a/include/nftables.h
> > +++ b/include/nftables.h
> > @@ -30,6 +30,8 @@ struct output_ctx {
> >  	unsigned int ip2name;
> >  	unsigned int handle;
> >  	unsigned int echo;
> > +	void *ctx;
> > +	int (*print)(void *ctx, const char *format, ...);
> >  };
> 
> My compiler says:
> 
> > libnftables.c: In function 'nft_context_new':
> > libnftables.c:113:20: warning: assignment left-hand side might be a
> > candidate for a format attribute [-Wsuggest-attribute=format]
> >   ctx->output.print = nft_print;
> >                     ^
> 
> Not really a warning IMO, though.
> 
> Abstracting the topic a bit, maybe all these foo_print() callbacks
> should die eventually and be replaced by formatters for different
> output
> types, similar to nftnl_foo_snprintf() functions. Maybe the whole
> output
> formatting actually even belongs to the application and libnftables
> has
> to provide a way to extract object information. Not sure how much
> knowlege the application should (need to) have about internal data
> structures like e.g., struct table or struct expr.

Agree, this was a first approach. Not sending structured data is
problem in a modern library.

We have already dumping of object in JSON or XML. It maybe could be
used as communication method to send structured data to the user
applications. Don't know if it is a lazy way but maybe it could be
enough.

++
-- 
Eric Leblond <eric@regit.org>
Blog: https://home.regit.org/
