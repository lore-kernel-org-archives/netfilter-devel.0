From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nf_tables: set names cannot be larger than 15
 bytes
Date: Tue, 25 Mar 2014 21:45:37 +0100
Message-ID: <20140325204537.GA3501@localhost>
References: <1395670237-3841-1-git-send-email-pablo@netfilter.org>
 <20140324224105.GA21741@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, giuseppelng@gmail.com,
	kaber@trash.net
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51133 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754473AbaCYUpr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2014 16:45:47 -0400
Content-Disposition: inline
In-Reply-To: <20140324224105.GA21741@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 24, 2014 at 11:41:05PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> > index 33045a5..43ae487 100644
> > --- a/net/netfilter/nf_tables_api.c
> > +++ b/net/netfilter/nf_tables_api.c
> > @@ -1946,7 +1946,8 @@ static const struct nft_set_ops *nft_select_set_ops(const struct nlattr * const
> >  
> >  static const struct nla_policy nft_set_policy[NFTA_SET_MAX + 1] = {
> >  	[NFTA_SET_TABLE]		= { .type = NLA_STRING },
> > -	[NFTA_SET_NAME]			= { .type = NLA_STRING },
> > +	[NFTA_SET_NAME]			= { .type = NLA_STRING,
> > +					    .len = IFNAMSIZ - 1 },
> 
> Not related to your patch, but it looks to me as if all of these
> should be NLA_NUL_STRING, no?

This is what I originally thought. But all of the nla_* functions use
the nla_len to know length of the string coming from userspace, so
they don't rely on the trailing nul-termination.

Anyway, I'd appreciate if you can do a second look at this to make
sure I'm not overlooking anything. Thanks.
