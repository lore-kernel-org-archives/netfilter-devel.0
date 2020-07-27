Return-Path: <SRS0=nQ4N=BG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F9A1C433DF
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Jul 2020 10:55:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54F462070B
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Jul 2020 10:55:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728364AbgG0KzY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 27 Jul 2020 06:55:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728362AbgG0KzX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Jul 2020 06:55:23 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73BEBC061794
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Jul 2020 03:55:23 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1k00mu-0006ok-7R; Mon, 27 Jul 2020 12:55:20 +0200
Date:   Mon, 27 Jul 2020 12:55:20 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 00/18] nft: Sorted chain listing et al.
Message-ID: <20200727105520.GF13697@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20200711101831.29506-1-phil@nwl.cc>
 <20200723122257.GA22824@salvia>
 <20200725115541.GA13697@orbyte.nwl.cc>
 <20200727102016.GA5823@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200727102016.GA5823@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Mon, Jul 27, 2020 at 12:20:16PM +0200, Pablo Neira Ayuso wrote:
> On Sat, Jul 25, 2020 at 01:55:41PM +0200, Phil Sutter wrote:
> > Hi Pablo,
> > 
> > On Thu, Jul 23, 2020 at 02:22:57PM +0200, Pablo Neira Ayuso wrote:
> > > On Sat, Jul 11, 2020 at 12:18:13PM +0200, Phil Sutter wrote:
> > > > Work in this series centered around Harald's complaint about seemingly
> > > > random custom chain ordering in iptables-nft-save output. nftables
> > > > returns chains in the order they were created which differs from
> > > > legacy iptables which sorts by name.
> > > > 
> > > > The intuitive approach of simply sorting chains in tables'
> > > > nftnl_chain_lists is problematic since base chains, which shall be
> > > > dumped first, are contained in there as well. Patch 15 solves this by
> > > > introducing a per-table array of nftnl_chain pointers to hold only base
> > > > chains (the hook values determine the array index). The old
> > > > nftnl_chain_list now contains merely non-base chains and is sorted upon
> > > > population by the new nftnl_chain_list_add_sorted() function.
> > > > 
> > > > Having dedicated slots for base chains allows for another neat trick,
> > > > namely to create only immediately required base chains. Apart from the
> > > > obvious case, where adding a rule to OUTPUT chain doesn't cause creation
> > > > of INPUT or FORWARD chains, this means ruleset modifications can be
> > > > avoided completely when listing, flushing or zeroing counters (unless
> > > > chains exist).
> > > 
> > > Patches from 1 to 7, they look good to me. Would it be possible to
> > > apply these patches independently from this batch or they are a strong
> > > dependency?
> > 
> > I just pushed them after making sure they don't break any of the
> > testsuites. Fingers crossed I didn't miss a detail which breaks without
> > the other patches. :)
> 
> Good.
> 
> > > I think it's better if we go slightly different direction?
> > > 
> > > https://patchwork.ozlabs.org/project/netfilter-devel/patch/20200723121553.7400-1-pablo@netfilter.org/
> > 
> > That's interesting. At least it would allow us to reorganize the
> > cache-related data structures, e.g. move the nft_cache->table array
> > items into nft_cache->table items.
> > 
> > > Instead of adding more functions into libnftnl for specific list
> > > handling, which are not used by nft, use linux list native handling.
> > 
> > OK.
> > 
> > > I think there is not need to cache the full nftnl_table object,
> > > probably it should be even possible to just use it to collect the
> > > attributes from the kernel to populate the nft_table object that I'm
> > > proposing.
> > 
> > Yes, for iptables-nft at least we should be completely fine with table
> > name alone.
> 
> Good.
> 
> > > IIRC embedded people complained on the size of libnftnl, going this
> > > direction I suggest, we can probably deprecated iterators for a number
> > > of objects and get it slimmer in the midrun.
> > 
> > OK. I'll keep that in mind.
> > 
> > So I'll rework my changes based on your nft_table idea and introduce an
> > nft_chain struct to be organized in a standard list_head list. This will
> > allow me to perform the sorting in iptables-nft itself.
> 
> Good.
> 
> > Should I base this onto your nft_table patch (and exploit it a bit
> > further) or keep them separate for now?
> 
> I'll push it out so you can rebase on top, OK?

Yes, that's fine with me!

Thanks, Phil
