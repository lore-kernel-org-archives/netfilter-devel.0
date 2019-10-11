Return-Path: <SRS0=pLNN=YE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE53AECE58C
	for <netfilter-devel@archiver.kernel.org>; Fri, 11 Oct 2019 09:28:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA02821D6C
	for <netfilter-devel@archiver.kernel.org>; Fri, 11 Oct 2019 09:28:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727649AbfJKJ2c (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 11 Oct 2019 05:28:32 -0400
Received: from correo.us.es ([193.147.175.20]:36226 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727314AbfJKJ2c (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 11 Oct 2019 05:28:32 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E9B83E4434C
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Oct 2019 11:28:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D7B8FBAACC
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Oct 2019 11:28:27 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CD3128E524; Fri, 11 Oct 2019 11:28:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7483CB7FFB;
        Fri, 11 Oct 2019 11:28:21 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 11 Oct 2019 11:28:21 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 5418642EE38E;
        Fri, 11 Oct 2019 11:28:21 +0200 (CEST)
Date:   Fri, 11 Oct 2019 11:28:23 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH v3 04/11] nft-cache: Introduce cache levels
Message-ID: <20191011092823.dfzjjxmmgqx63eae@salvia>
References: <20191008161447.6595-1-phil@nwl.cc>
 <20191008161447.6595-5-phil@nwl.cc>
 <20191009093723.snbyd6xvtd5gpnto@salvia>
 <20191009102901.6kel2u36u3yv4myu@salvia>
 <20191010220911.GM12661@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191010220911.GM12661@orbyte.nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Oct 11, 2019 at 12:09:11AM +0200, Phil Sutter wrote:
> Hi Pablo,
> 
> On Wed, Oct 09, 2019 at 12:29:01PM +0200, Pablo Neira Ayuso wrote:
> > On Wed, Oct 09, 2019 at 11:37:23AM +0200, Pablo Neira Ayuso wrote:
> > > Hi Phil,
> > > 
> > > On Tue, Oct 08, 2019 at 06:14:40PM +0200, Phil Sutter wrote:
> > > > Replace the simple have_cache boolean by a cache level indicator
> > > > defining how complete the cache is. Since have_cache indicated full
> > > > cache (including rules), make code depending on it check for cache level
> > > > NFT_CL_RULES.
> > > > 
> > > > Core cache fetching routine __nft_build_cache() accepts a new level via
> > > > parameter and raises cache completeness to that level.
> > > > 
> > > > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > > > ---
> > > >  iptables/nft-cache.c | 51 +++++++++++++++++++++++++++++++-------------
> > > >  iptables/nft.h       |  9 +++++++-
> > > >  2 files changed, 44 insertions(+), 16 deletions(-)
> > > > 
> > > > diff --git a/iptables/nft-cache.c b/iptables/nft-cache.c
> > > > index 5444419a5cc3b..22a87e94efd76 100644
> > > > --- a/iptables/nft-cache.c
> > > > +++ b/iptables/nft-cache.c
> > > > @@ -224,30 +224,49 @@ static int fetch_rule_cache(struct nft_handle *h)
> > > >  	return 0;
> > > >  }
> > > >  
> > > > -static void __nft_build_cache(struct nft_handle *h)
> > > > +static void __nft_build_cache(struct nft_handle *h, enum nft_cache_level level)
> > > >  {
> > > >  	uint32_t genid_start, genid_stop;
> > > >  
> > > > +	if (level <= h->cache_level)
> > > > +		return;
> > > >  retry:
> > > >  	mnl_genid_get(h, &genid_start);
> > > > -	fetch_table_cache(h);
> > > > -	fetch_chain_cache(h);
> > > > -	fetch_rule_cache(h);
> > > > -	h->have_cache = true;
> > > > -	mnl_genid_get(h, &genid_stop);
> > > >  
> > > > +	switch (h->cache_level) {
> > > > +	case NFT_CL_NONE:
> > > > +		fetch_table_cache(h);
> > > > +		if (level == NFT_CL_TABLES)
> > > > +			break;
> > > > +		/* fall through */
> > > > +	case NFT_CL_TABLES:
> > > 
> > > If the existing level is TABLES and use wants chains, then you have to
> > > invalidate the existing table cache, then fetch the tables and chains
> > > to make sure cache is consistent. I mean, extending an existing cache
> > > might lead to inconsistencies.
> > > 
> > > Am I missing anything?
> 
> Hmm, this is a valid point indeed. At least one can't depend on stored
> genid to match the local cache's state which defeats its purpose.

Exactly.

> > If I'm correct, I wonder if we should go for splitting the parsing
> > from the evaluation phase here. Probably generate the rule by pointing
> > to the table and chain as string, then evaluate the ruleset update
> > batch to obtain the cache level in one go. This is the approach that
> > I had in mind with nftables, so you might avoid dumping the ruleset
> > over and over in an environment where dynamic updates are frequent.
> > 
> > The idea is to avoid fetching a cache, then canceling it by the rule
> > coming afterwards just because the cache is incomplete. So the cache
> > that is required is calculated once, then you go to the kernel and
> > fetch it (making sure generation number tells you that your cache is
> > consistent).
> > 
> > Makes sense to you?
> 
> Well, I understand your approach and it's a proper way to deal with the
> situation, but I fear this means quite some effort. I imagine we either
> extend the xtables-restore table delete logic to add and disable more
> dependency commands based on kernel ruleset contents or add these
> dependency commands when iterating over the command set and populating
> the cache.

It's always more work to make a bit of architectural changes, yes.

> The thing is, we do this mostly just for xtables-restore --noflush
> logic, which in turn is probably not used often but popular among "power
> users" trying to speed up the bunch of iptables commands they have to
> enter at once.

Yes, this is the kind of user that deals with frequent dynamic
updates.

> Maybe we could go with a simpler solution for now, which is to check
> kernel genid again and drop the local cache if it differs from what's
> stored. If it doesn't, the current cache is still up to date and we may
> just fetch what's missing. Or does that leave room for a race condition?

You could also just parse the ruleset twice in userspace, once to
calculate the cache you need and another to actually create the
transaction batch and push it into the kernel. That's a bit poor man
approach, but it might work. You would need to invoke
xtables_restore_parse() twice.

This more simpler approach probably requires less changes to the
existing codebase, that can be "reverted" later on if someone needs to
speed up this by removing this parsing happening twice.
