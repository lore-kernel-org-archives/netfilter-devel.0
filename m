Return-Path: <SRS0=fGlf=DU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37E4EC433DF
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Oct 2020 09:29:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BAF720725
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Oct 2020 09:29:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404228AbgJMJ3I (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 13 Oct 2020 05:29:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404225AbgJMJ3I (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Oct 2020 05:29:08 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C80EC0613D0
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Oct 2020 02:29:07 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1kSGcC-000780-2Z; Tue, 13 Oct 2020 11:29:04 +0200
Date:   Tue, 13 Oct 2020 11:29:04 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH v2 01/10] nft: Fix selective chain compatibility
 checks
Message-ID: <20201013092904.GS13016@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20200923174849.5773-1-phil@nwl.cc>
 <20200923174849.5773-2-phil@nwl.cc>
 <20201012115424.GA26845@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201012115424.GA26845@salvia>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Mon, Oct 12, 2020 at 01:54:24PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Sep 23, 2020 at 07:48:40PM +0200, Phil Sutter wrote:
> > Since commit 80251bc2a56ed ("nft: remove cache build calls"), 'chain'
> > parameter passed to nft_chain_list_get() is no longer effective. To
> > still support running nft_is_chain_compatible() on specific chains only,
> > add a short path to nft_is_table_compatible().
> > 
> > Follow-up patches will kill nft_chain_list_get(), so don't bother
> > dropping the unused parameter from its signature.
> 
> This has a Fixes: tag.
> 
> What is precisely the problem? How does show from the iptables and
> iptables-restore interface?
> 
> Not sure I understand the problem.

Before the big caching rework, nft_chain_list_get() could cause a
cache-fetch to populate table's chain list. If a chain name was passed
to it, that cache-fetch would retrieve only the specified chain (if not
in cache already).

In the current code, nft_is_table_compatible() happens in the second
stage where cache is present already and nft_chain_list_get() really
just returns the table's chain list again. This means that the
compatibility check happens for all chains in cache which belong to that
table and the original optimization (to check only the interesting
chain) is not effective anymore.

The "short path" (actually: short-cut) introduced in this patch allows
to limit compat check to a specific chain again. The impact is not as
big anymore as nft_chain_list_get() does no longer populate the cache,
but still there's no point in checking unintereresting chains'
compatibility.

Above all else though, this is fallout from the preparations to drop
nft_chain_list_get() and given the above, I found it makes sense to push
it as a separate commit.

Cheers, Phil
