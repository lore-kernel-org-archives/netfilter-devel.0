From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nf_tables: fix loop checking with set element
 data
Date: Fri, 7 Feb 2014 17:20:14 +0100
Message-ID: <20140207162014.GA3849@localhost>
References: <1391786631-4070-1-git-send-email-pablo@netfilter.org>
 <20140207154720.GA23148@macbook.localnet>
 <20140207155104.GA23911@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57880 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752262AbaBGQUV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Feb 2014 11:20:21 -0500
Content-Disposition: inline
In-Reply-To: <20140207155104.GA23911@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Feb 07, 2014 at 03:51:05PM +0000, Patrick McHardy wrote:
> On Fri, Feb 07, 2014 at 03:47:34PM +0000, Patrick McHardy wrote:
> > On Fri, Feb 07, 2014 at 04:23:51PM +0100, Pablo Neira Ayuso wrote:
> > > This patch fixes two bugs:
> > > 
> > > * Restrict the validation to verdict maps only, since struct nft_data
> > >   is declared as a union, data[0] may contain the values -3 or -4 which
> > >   match with NFT_JUMP and NFT_GOTO. I think this will result in crash
> > >   while performing the chain loop validation.
> > > 
> > > * Access to uninitialized data for end interval elements. The element
> > >   data part is uninitialized in interval end elements.
> > > 
> > 
> > That's not necessary. The function is only invoked for NFT_DATA_VERDICT.
> > 
> > 
> > > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > > ---
> > >  net/netfilter/nf_tables_api.c |    5 +++++
> > >  1 file changed, 5 insertions(+)
> > > 
> > > diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> > > index d0c790e3e..522becb 100644
> > > --- a/net/netfilter/nf_tables_api.c
> > > +++ b/net/netfilter/nf_tables_api.c
> > > @@ -2998,6 +2998,11 @@ static int nf_tables_loop_check_setelem(const struct nft_ctx *ctx,
> > >  					const struct nft_set_iter *iter,
> > >  					const struct nft_set_elem *elem)
> > >  {
> > > +	if (!(set->flags & NFT_SET_MAP) ||
> > > +	    set->dtype != NFT_DATA_VERDICT ||
> > > +	    elem->flags & NFT_SET_ELEM_INTERVAL_END)
> > > +		return 0;
> > > +
> 
> Right, I get the intention now.
> 
> This function is only called for maps with dtype verdict, so just the check
> for SET_ELEM_INTERVAL_END is all we need.

Right, I overlook this:

        list_for_each_entry(set, &ctx->table->sets, list) {
                if (!(set->flags & NFT_SET_MAP) ||
                    set->dtype != NFT_DATA_VERDICT)
                        continue;

at the top of nf_tables_check_loops().
