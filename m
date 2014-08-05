From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nf_tables: don't update chain with unset
 counters
Date: Tue, 5 Aug 2014 18:32:46 +0200
Message-ID: <20140805163246.GA4372@salvia>
References: <1407252636-3459-1-git-send-email-pablo@netfilter.org>
 <1407254831.3178.90.camel@edumazet-glaptop2.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net,
	technoboy85@gmail.com
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33053 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753780AbaHEQcZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Aug 2014 12:32:25 -0400
Content-Disposition: inline
In-Reply-To: <1407254831.3178.90.camel@edumazet-glaptop2.roam.corp.google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 05, 2014 at 06:07:11PM +0200, Eric Dumazet wrote:
> On Tue, 2014-08-05 at 17:30 +0200, Pablo Neira Ayuso wrote:
> > Fix possible replacemen of the per-cpu chain counters by null
> > pointer when updating an existing chain in the commit path.
> > 
> > Reported-by: Matteo Croce <technoboy85@gmail.com>
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> >  net/netfilter/nf_tables_api.c |    3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> > index f95dc95..f7dce2b 100644
> > --- a/net/netfilter/nf_tables_api.c
> > +++ b/net/netfilter/nf_tables_api.c
> > @@ -899,6 +899,9 @@ static struct nft_stats __percpu *nft_stats_alloc(const struct nlattr *attr)
> >  static void nft_chain_stats_replace(struct nft_base_chain *chain,
> >  				    struct nft_stats __percpu *newstats)
> >  {
> > +	if (newstats == NULL)
> > +		return;
> > +
> >  	if (chain->stats) {
> >  		struct nft_stats __percpu *oldstats =
> >  				nft_dereference(chain->stats);
> 
> This looks strange. Real bug is that nft_dump_stats() should not try to
> fold percpu stats and output something if 'stats' is NULL ?
>
> Otherwise, why nft_chain_stats_replace() checks if previous pointer is
> NULL ?

Currently, we always allocate the per-cpu chain stats. The problem
occurs here:

static int nf_tables_newchain(struct sock *nlsk, ...
        ...
        if (chain != NULL) {
                struct nft_stats *stats = NULL;
                ...

                if (nla[NFTA_CHAIN_COUNTERS]) {
                        ...
                }
                ...
                nft_trans_chain_stats(trans) = stats;

Then, in the nf_tables_commit() path, this calls
nft_chain_commit_update() which sets the per-chain stats to NULL,
which is bad.

The idea is that, if no chain stats are passed when updating the
chain, this means: "please, leave the chain counter as is in this
update".

This bug slipped through with the transaction infrastructure.
