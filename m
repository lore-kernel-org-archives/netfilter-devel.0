From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables-nftables PATCH 6/6] xtables: add suport for DNAT rule
 translation to nft extensions
Date: Wed, 15 May 2013 14:51:55 +0200
Message-ID: <20130515125155.GB1349@localhost>
References: <519216B6.7060701@linux.intel.com>
 <1368528727-10127-1-git-send-email-tomasz.bursztyka@linux.intel.com>
 <1368528727-10127-7-git-send-email-tomasz.bursztyka@linux.intel.com>
 <20130514223035.GC10082@localhost>
 <51932FBC.1060904@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39015 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932490Ab3EOMwA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 May 2013 08:52:00 -0400
Content-Disposition: inline
In-Reply-To: <51932FBC.1060904@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Tomasz,

On Wed, May 15, 2013 at 09:48:28AM +0300, Tomasz Bursztyka wrote:
[...]
> >>+static struct nft_rule_expr_list *
> >>+create_nat_expr_list(const struct nf_nat_range *r)
> >>+{
> >>+	struct nft_rule_expr_list *expr_list;
> >>+	struct nft_rule_expr *nat_expr;
> >>+	int registers = 1;
> >>+
> >>+	expr_list = nft_rule_expr_list_alloc();
> >>+	if (expr_list == NULL)
> >>+		return NULL;
> >Better allocate this list in nft.c and pass it as parameter. All
> >extensions will require this, and after that change you can return -1
> >on error / 0 on success.
> >
> >Or simply pass the struct nft_rule object? Then, you can skip patch
> >[libnftables PATCH 6/7]?
> 
> Why not, it's a design preference. I liked the idea extension don't
> mess up with the rule and only provides its expression list.
> it's less code on libnftables on your idea at least.

We have to trust our iptables extensions.

What extra sanity checking are you going to make anyway if the
extension puzzles with this internal expr_list?

> >>+	.x6_options	  = DNAT_opts,
> >>+	.translate_to_nft = DNAT_to_nft,
> >nft_to_translate is missing, right? We need it to print the rule that
> >is expressed in native format.
> 
> Read the very first mail of this thread. It's actually an issue here.
> I had the idea of doing the reverse function indeed, but there is a problem:
> From iptables to nftables it's easy, since we get a target made by
> the right extension, so we directly get the right translation
> function. That's what I did.
>
> Now on the reverse way, we don't know at all to which extension the
> expression list belongs to, so which translation function to call.
> Currently the only way I see it is to loop on all extensions until
> one returns successfully.

You need some dispatcher code that interprets the nft_expr and routes
it to the right iptables extension. So you will need also one .c file
per expression in the kernel, e.g. nft_nat.c, that performs this
dispatching / routing to the right extension.

Probably checking netlink_delinearize.c in nft can provide your some
ideas.

> We should take care of the position in the expression list as well,
> and here I see we will need some more functions from libnftables.

You have the expression iterator already.
