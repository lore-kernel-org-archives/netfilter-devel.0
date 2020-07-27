Return-Path: <SRS0=nQ4N=BG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14EBAC433E1
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Jul 2020 10:20:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED9852074F
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Jul 2020 10:20:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727789AbgG0KUu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 27 Jul 2020 06:20:50 -0400
Received: from correo.us.es ([193.147.175.20]:51696 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbgG0KUu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Jul 2020 06:20:50 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 66794F259A
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Jul 2020 12:20:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2AF0ADA54D
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Jul 2020 12:20:48 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0796DDA91D; Mon, 27 Jul 2020 12:20:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9F69CBAAC7;
        Mon, 27 Jul 2020 12:20:16 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 27 Jul 2020 12:20:16 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 6963E42EF4E1;
        Mon, 27 Jul 2020 12:20:16 +0200 (CEST)
Date:   Mon, 27 Jul 2020 12:20:16 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 00/18] nft: Sorted chain listing et al.
Message-ID: <20200727102016.GA5823@salvia>
References: <20200711101831.29506-1-phil@nwl.cc>
 <20200723122257.GA22824@salvia>
 <20200725115541.GA13697@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200725115541.GA13697@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Phil,

On Sat, Jul 25, 2020 at 01:55:41PM +0200, Phil Sutter wrote:
> Hi Pablo,
> 
> On Thu, Jul 23, 2020 at 02:22:57PM +0200, Pablo Neira Ayuso wrote:
> > On Sat, Jul 11, 2020 at 12:18:13PM +0200, Phil Sutter wrote:
> > > Work in this series centered around Harald's complaint about seemingly
> > > random custom chain ordering in iptables-nft-save output. nftables
> > > returns chains in the order they were created which differs from
> > > legacy iptables which sorts by name.
> > > 
> > > The intuitive approach of simply sorting chains in tables'
> > > nftnl_chain_lists is problematic since base chains, which shall be
> > > dumped first, are contained in there as well. Patch 15 solves this by
> > > introducing a per-table array of nftnl_chain pointers to hold only base
> > > chains (the hook values determine the array index). The old
> > > nftnl_chain_list now contains merely non-base chains and is sorted upon
> > > population by the new nftnl_chain_list_add_sorted() function.
> > > 
> > > Having dedicated slots for base chains allows for another neat trick,
> > > namely to create only immediately required base chains. Apart from the
> > > obvious case, where adding a rule to OUTPUT chain doesn't cause creation
> > > of INPUT or FORWARD chains, this means ruleset modifications can be
> > > avoided completely when listing, flushing or zeroing counters (unless
> > > chains exist).
> > 
> > Patches from 1 to 7, they look good to me. Would it be possible to
> > apply these patches independently from this batch or they are a strong
> > dependency?
> 
> I just pushed them after making sure they don't break any of the
> testsuites. Fingers crossed I didn't miss a detail which breaks without
> the other patches. :)

Good.

> > I think it's better if we go slightly different direction?
> > 
> > https://patchwork.ozlabs.org/project/netfilter-devel/patch/20200723121553.7400-1-pablo@netfilter.org/
> 
> That's interesting. At least it would allow us to reorganize the
> cache-related data structures, e.g. move the nft_cache->table array
> items into nft_cache->table items.
> 
> > Instead of adding more functions into libnftnl for specific list
> > handling, which are not used by nft, use linux list native handling.
> 
> OK.
> 
> > I think there is not need to cache the full nftnl_table object,
> > probably it should be even possible to just use it to collect the
> > attributes from the kernel to populate the nft_table object that I'm
> > proposing.
> 
> Yes, for iptables-nft at least we should be completely fine with table
> name alone.

Good.

> > IIRC embedded people complained on the size of libnftnl, going this
> > direction I suggest, we can probably deprecated iterators for a number
> > of objects and get it slimmer in the midrun.
> 
> OK. I'll keep that in mind.
> 
> So I'll rework my changes based on your nft_table idea and introduce an
> nft_chain struct to be organized in a standard list_head list. This will
> allow me to perform the sorting in iptables-nft itself.

Good.

> Should I base this onto your nft_table patch (and exploit it a bit
> further) or keep them separate for now?

I'll push it out so you can rebase on top, OK?

Thanks.
