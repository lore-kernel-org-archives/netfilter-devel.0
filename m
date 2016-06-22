From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nf_tables PATCH] netfilter: nf_tables: invert chain deletion
 abort path
Date: Wed, 22 Jun 2016 14:45:43 +0200
Message-ID: <20160622124543.GA1275@salvia>
References: <146011296985.3580.3314850969369156279.stgit@nfdev2.cica.es>
 <20160414102434.GA2905@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40809 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214AbcFVMq7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Jun 2016 08:46:59 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id C4CE416ACC6
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2016 14:45:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B24459EBA1
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2016 14:45:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 79E2E9EBAD
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2016 14:45:44 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160414102434.GA2905@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 14, 2016 at 12:24:34PM +0200, Pablo Neira Ayuso wrote:
> On Fri, Apr 08, 2016 at 12:56:10PM +0200, Arturo Borrero Gonzalez wrote:
> > Before this patch, chain deletetion abort path re-add chains in reverse
> > order of what was originally in the ruleset.
> > Invert the order, so the ruleset is exactly the same after abort.
> > 
> > Example, using 2 config files:
> > 
> > ruleset_good.nft:
> > ==== 8< ====
> > flush ruleset
> > table ip t {
> > 	chain c1 {
> > 	}
> > 	chain c2 {
> > 	}
> > 	chain c3 {
> > 	}
> > }
> > ==== 8< ====
> > 
> > ruleset_bad.nft:
> > ==== 8< ====
> > flush ruleset
> > table ip t {
> > 	chain c1 {
> > 	}
> > 	chain c2 {
> > 		jump c6
> > 	}
> > 	chain c3 {
> > 	}
> > }
> > ==== 8< ====
> > 
> > 
> > before this patch:
> > 
> > % nft -f ruleset_good.nft
> > % nft -f ruleset_bad.nft
> > % nft list ruleset
> > table ip t {
> > 	chain c3 {
> > 	}
> > 
> > 	chain c2 {
> > 	}
> > 
> > 	chain c1 {
> > 	}
> > }
> > 
> > [ note, inverse order of chain listing ]
> > 
> > after this patch:
> > 
> > % nft -f ruleset_good.nft
> > % nft -f ruleset_bad.nft
> > % nft list ruleset
> > table ip t {
> > 	chain c1 {
> > 	}
> > 
> > 	chain c2 {
> > 	}
> > 
> > 	chain c3 {
> > 	}
> > }
> > 
> > [ note, same order of chain listing ]
> > 
> > Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> > ---
> >  net/netfilter/nf_tables_api.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> > index 2011977..8578cc6 100644
> > --- a/net/netfilter/nf_tables_api.c
> > +++ b/net/netfilter/nf_tables_api.c
> > @@ -4060,8 +4060,8 @@ static int nf_tables_abort(struct net *net, struct sk_buff *skb)
> >  			break;
> >  		case NFT_MSG_DELCHAIN:
> >  			trans->ctx.table->use++;
> > -			list_add_tail_rcu(&trans->ctx.chain->list,
> > -					  &trans->ctx.table->chains);
> > +			list_add_rcu(&trans->ctx.chain->list,
> > +				     &trans->ctx.table->chains);
> 
> Thanks for coming up with this Arturo.
> 
> I have a better way to fix this by not adding/removing the objects to
> the lists.

Just for the record, this longer patch:

        http://patchwork.ozlabs.org/patch/639103/

fixes this, as it is described here:

        http://patchwork.ozlabs.org/patch/639102/

Thanks for your patience.
