From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nf_tables PATCH 5/6 v5] netfilter: nf_tables: extend
 NFT_MSG_DELTABLE to support flushing the ruleset
Date: Tue, 2 Sep 2014 17:28:26 +0200
Message-ID: <20140902152826.GA10181@salvia>
References: <1409668946-8168-1-git-send-email-arturo.borrero.glez@gmail.com>
 <1409668946-8168-6-git-send-email-arturo.borrero.glez@gmail.com>
 <20140902151241.GA29716@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58628 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753880AbaIBP1h (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Sep 2014 11:27:37 -0400
Content-Disposition: inline
In-Reply-To: <20140902151241.GA29716@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Sep 02, 2014 at 04:12:41PM +0100, Patrick McHardy wrote:
> On Tue, Sep 02, 2014 at 04:42:26PM +0200, Arturo Borrero Gonzalez wrote:
> > This patch extend the NFT_MSG_DELTABLE call to support flushing the entire
> > ruleset.
> > 
> > The options now are:
> >  * No family speficied, no table specified: flush all the ruleset.
> >  * Family specified, no table specified: flush all tables in the AF.
> >  * Family specified, table specified: flush the given table.
> > 
> > Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> > ---
> > v2: address comments by Pablo:
> >     * don't return EINVAL if called with AF_UNSPEC and a concrete table.
> >     * A more generic function, nft_flush()
> > 
> > v3: no changes, resending the series.
> > v4: no changes, resending the series because v3 series was invalid.
> > v5: address comment by Pablo: delete set if the list of bindings is empty.
> 
> > +static int nft_flush_table(struct nft_ctx *ctx)
> > +{
> > +	int err;
> > +	struct nft_chain *chain, *nc;
> > +	struct nft_set *set, *ns;
> > +
> > +	list_for_each_entry_safe(chain, nc, &ctx->table->chains, list) {
> > +		ctx->chain = chain;
> > +
> > +		err = nft_delrule_by_chain(ctx);
> > +		if (err < 0)
> > +			goto out;
> > +
> > +		err = nft_delchain(ctx);
> > +		if (err < 0)
> > +			goto out;
> > +	}
> > +
> > +	list_for_each_entry_safe(set, ns, &ctx->table->sets, list) {
> > +		if (set->flags & NFT_SET_ANONYMOUS &&
> > +		    !list_empty(&set->bindings))
> > +			continue;
> 
> So we're removing anonymous sets iff the bindings are empty. I feel I'm
> missing something:
> 
> - how could we possibly still have bindings after the table has been flushed?

We remove break the binding until we reach the commit path. The table
is not actually flushed from nft_flush_table, instead the objects are
marked to be removed from the commit path.

The rule <-> set binding remains there until we reach the commit path.

> - if that were possible, why wouldn't it also apply to non-anonymous sets?

Non-anonymous sets need to be explicitly destroyed after the rule is
removed.

> If I'm not mistaken we should be able to unconditionally delete all sets
> once the ruleset has been flushed.

We have to keep bound-to-rule anonymous set until we reach the commit
path, packets may still be walking on it.

If we don't skip the removal of bound-to-rule anonymous sets, we'll
crash since we'll try to delete them twice in the commit path, once
from _DELRULE and again from _DELSET.
