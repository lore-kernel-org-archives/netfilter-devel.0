From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables-nftables PATCH 6/6] xtables: add suport for DNAT rule
 translation to nft extensions
Date: Wed, 15 May 2013 15:49:31 +0200
Message-ID: <20130515134931.GB1577@localhost>
References: <519216B6.7060701@linux.intel.com>
 <1368528727-10127-1-git-send-email-tomasz.bursztyka@linux.intel.com>
 <1368528727-10127-7-git-send-email-tomasz.bursztyka@linux.intel.com>
 <20130514223035.GC10082@localhost>
 <51932FBC.1060904@linux.intel.com>
 <20130515125155.GB1349@localhost>
 <51938C74.3090905@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48961 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757178Ab3EONtg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 May 2013 09:49:36 -0400
Content-Disposition: inline
In-Reply-To: <51938C74.3090905@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, May 15, 2013 at 04:24:04PM +0300, Tomasz Bursztyka wrote:
[...]
> >>Now on the reverse way, we don't know at all to which extension the
> >>expression list belongs to, so which translation function to call.
> >>Currently the only way I see it is to loop on all extensions until
> >>one returns successfully.
>
> >You need some dispatcher code that interprets the nft_expr and routes
> >it to the right iptables extension. So you will need also one .c file
> >per expression in the kernel, e.g. nft_nat.c, that performs this
> >dispatching / routing to the right extension.
> 
> You lost me. Why kernel is involved here?

I didn't mention the kernel is involved this.

You can have a dispatcher like:

static const struct {
        const char      *name;
        void            (*parse)(struct nft_rule_expr_iter *iter)
} netlink_parsers[] = {
        [...]
        { .name = "nat",        .parse = netlink_parse_nat },
};

the .parse callback gets an iterator to obtain the current expression
and munch more of them if required (will be useful for the payload
case).

Then, the netlink_parse_nat will route the nft_rule_expr object to the
corresponding libxt extension.

> >Probably checking netlink_delinearize.c in nft can provide your some
> >ideas.
> 
> Yes, and I actually use netlink_linearize.c to help for translation.
> 
> >>We should take care of the position in the expression list as well,
> >>and here I see we will need some more functions from libnftables.
> >You have the expression iterator already.
> 
> I believe it won't be sufficient. Let's see.

OK, let's revisit this once you hit limitations.
