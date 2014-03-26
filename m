From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH RFC 1/2] netfilter: nf_tables: move set netlink messages
 into the batch
Date: Wed, 26 Mar 2014 14:00:21 +0000
Message-ID: <20140326140003.GA7344@macbook.localnet>
References: <1395779982-3459-1-git-send-email-pablo@netfilter.org>
 <20140326112554.GC452@macbook.localnet>
 <20140326130338.GA31813@localhost>
 <20140326131856.GA7173@macbook.localnet>
 <20140326134022.GA31965@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34700 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbaCZOAZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Mar 2014 10:00:25 -0400
Content-Disposition: inline
In-Reply-To: <20140326134022.GA31965@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 26, 2014 at 02:40:22PM +0100, Pablo Neira Ayuso wrote:
> On Wed, Mar 26, 2014 at 01:18:57PM +0000, Patrick McHardy wrote:
> > On Wed, Mar 26, 2014 at 02:03:38PM +0100, Pablo Neira Ayuso wrote:
> > > On Wed, Mar 26, 2014 at 11:25:54AM +0000, Patrick McHardy wrote:
> > > > On Tue, Mar 25, 2014 at 09:39:41PM +0100, Pablo Neira Ayuso wrote:
> > > 
> > > > I think a U32 should be perfectly fine. These are not permanent IDs but just to
> > > > identify new sets contained within a batch, so we can always start at 0.
> > > 
> > > Yes, I was considering using this also to output the set identifier
> > > for anonymous sets, but the dynamically allocated name should be fine
> > > so I'll stick to u32.
> > 
> > I think these are two different things. The set identifier is so far actually
> > a transaction identifier, mixing these will most likely get messy.
> > 
> > > Going back to the idea of using u64 to allocate the set/map names, I
> > > think we have to extend the set name, currently IFNAMSIZ is limited
> > > when mapping the name to set%lld, assuming a large u64 number.
> > 
> > The problem is more that this ID is chosen by userspace, so it's not suitable
> > for anonymous sets.
> 
> I was not considering to use the ID allocated from userspace, but
> reusing the NFTA_SET_ID attribute given that it is only used for
> messages from userspace -> kernel, so we can reuse it when dumping the
> anonymous set to userspace, but that's two different things with
> different semantics, so better to have two different attributes for
> each, eg. NFTA_SET_ID_ANONYMOUS?

Actually that one would probably be fine. In both cases it would be used
in a very similar fashion, a temporary identifier or transaction ID.

> > I'd rather get rid of the names for anonymous sets completely. For
> > dumps we can just as well use a dynamic numeric identifier to
> > associate lookup expressions with sets. We don't really need a
> > permanent identifier.
> 
> How will that look like? I think we need some permanent way to
> identify sets even if they are anonymous. A permanent ID should be
> fine for that.

Well it depends. Right now we have anonymous sets, meaning an ID is allocated,
but they're only used in combination with constant sets, which means they
can not be changed so we don't need a permanent ID. If we were to use
anonymous in combination with non-const then yes, we need a permanent ID.

In either case the numeric ID is fine, the question is simply whether it
needs to be a permanent ID or whether a temoprary one is enough.

> > > > > @@ -2534,7 +2619,8 @@ void nf_tables_unbind_set(const struct nft_ctx *ctx, struct nft_set *set,
> > > > >  {
> > > > >  	list_del(&binding->list);
> > > > >  
> > > > > -	if (list_empty(&set->bindings) && set->flags & NFT_SET_ANONYMOUS)
> > > > > +	if (list_empty(&set->bindings) && set->flags & NFT_SET_ANONYMOUS &&
> > > > > +	    !(set->flags & __NFT_SET_INACTIVE))
> > > > 
> > > > Why are we not destroying anonymous inactive sets when unbinding? This means we're
> > > > either aborting or replaying the entire transaction, so it seems we should remove
> > > > them, no?
> > > 
> > > The set may be already bound to the rule, we skip this here, so the
> > > set is released from the transaction. This is just to avoid a double
> > > free case.
> > 
> > I have to read the patch again, I was under the impression that a bound set
> > has already been comitted and we therefore won't fail anymore. Probably
> > misunderstood something.
> 
> Think of the abort step. We already have some rules bound to the set
> (not yet committed), but we failed to load some rule, we need to
> release those rules and their set bindings. In that case, the rule
> destroy path skips releasing the set, so we just let the abort routine
> to iterate over the list of new sets to releasing.

So we do bind to uncommitted sets? That's the part I was missing.
