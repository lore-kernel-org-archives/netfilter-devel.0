Return-Path: <SRS0=6wcg=YD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3396FC4360C
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Oct 2019 22:09:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 094C220B7C
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Oct 2019 22:09:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726065AbfJJWJN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Oct 2019 18:09:13 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:53940 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725978AbfJJWJN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Oct 2019 18:09:13 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1iIgcR-0004pF-Uz; Fri, 11 Oct 2019 00:09:11 +0200
Date:   Fri, 11 Oct 2019 00:09:11 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH v3 04/11] nft-cache: Introduce cache levels
Message-ID: <20191010220911.GM12661@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20191008161447.6595-1-phil@nwl.cc>
 <20191008161447.6595-5-phil@nwl.cc>
 <20191009093723.snbyd6xvtd5gpnto@salvia>
 <20191009102901.6kel2u36u3yv4myu@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191009102901.6kel2u36u3yv4myu@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Wed, Oct 09, 2019 at 12:29:01PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Oct 09, 2019 at 11:37:23AM +0200, Pablo Neira Ayuso wrote:
> > Hi Phil,
> > 
> > On Tue, Oct 08, 2019 at 06:14:40PM +0200, Phil Sutter wrote:
> > > Replace the simple have_cache boolean by a cache level indicator
> > > defining how complete the cache is. Since have_cache indicated full
> > > cache (including rules), make code depending on it check for cache level
> > > NFT_CL_RULES.
> > > 
> > > Core cache fetching routine __nft_build_cache() accepts a new level via
> > > parameter and raises cache completeness to that level.
> > > 
> > > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > > ---
> > >  iptables/nft-cache.c | 51 +++++++++++++++++++++++++++++++-------------
> > >  iptables/nft.h       |  9 +++++++-
> > >  2 files changed, 44 insertions(+), 16 deletions(-)
> > > 
> > > diff --git a/iptables/nft-cache.c b/iptables/nft-cache.c
> > > index 5444419a5cc3b..22a87e94efd76 100644
> > > --- a/iptables/nft-cache.c
> > > +++ b/iptables/nft-cache.c
> > > @@ -224,30 +224,49 @@ static int fetch_rule_cache(struct nft_handle *h)
> > >  	return 0;
> > >  }
> > >  
> > > -static void __nft_build_cache(struct nft_handle *h)
> > > +static void __nft_build_cache(struct nft_handle *h, enum nft_cache_level level)
> > >  {
> > >  	uint32_t genid_start, genid_stop;
> > >  
> > > +	if (level <= h->cache_level)
> > > +		return;
> > >  retry:
> > >  	mnl_genid_get(h, &genid_start);
> > > -	fetch_table_cache(h);
> > > -	fetch_chain_cache(h);
> > > -	fetch_rule_cache(h);
> > > -	h->have_cache = true;
> > > -	mnl_genid_get(h, &genid_stop);
> > >  
> > > +	switch (h->cache_level) {
> > > +	case NFT_CL_NONE:
> > > +		fetch_table_cache(h);
> > > +		if (level == NFT_CL_TABLES)
> > > +			break;
> > > +		/* fall through */
> > > +	case NFT_CL_TABLES:
> > 
> > If the existing level is TABLES and use wants chains, then you have to
> > invalidate the existing table cache, then fetch the tables and chains
> > to make sure cache is consistent. I mean, extending an existing cache
> > might lead to inconsistencies.
> > 
> > Am I missing anything?

Hmm, this is a valid point indeed. At least one can't depend on stored
genid to match the local cache's state which defeats its purpose.

> If I'm correct, I wonder if we should go for splitting the parsing
> from the evaluation phase here. Probably generate the rule by pointing
> to the table and chain as string, then evaluate the ruleset update
> batch to obtain the cache level in one go. This is the approach that
> I had in mind with nftables, so you might avoid dumping the ruleset
> over and over in an environment where dynamic updates are frequent.
> 
> The idea is to avoid fetching a cache, then canceling it by the rule
> coming afterwards just because the cache is incomplete. So the cache
> that is required is calculated once, then you go to the kernel and
> fetch it (making sure generation number tells you that your cache is
> consistent).
> 
> Makes sense to you?

Well, I understand your approach and it's a proper way to deal with the
situation, but I fear this means quite some effort. I imagine we either
extend the xtables-restore table delete logic to add and disable more
dependency commands based on kernel ruleset contents or add these
dependency commands when iterating over the command set and populating
the cache.

The thing is, we do this mostly just for xtables-restore --noflush
logic, which in turn is probably not used often but popular among "power
users" trying to speed up the bunch of iptables commands they have to
enter at once.

Maybe we could go with a simpler solution for now, which is to check
kernel genid again and drop the local cache if it differs from what's
stored. If it doesn't, the current cache is still up to date and we may
just fetch what's missing. Or does that leave room for a race condition?

Thanks, Phil
