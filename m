Return-Path: <SRS0=fGlf=DU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43A92C433DF
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Oct 2020 09:40:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F077520714
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Oct 2020 09:40:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391308AbgJMJkL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 13 Oct 2020 05:40:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387597AbgJMJkL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Oct 2020 05:40:11 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69A76C0613D0
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Oct 2020 02:40:11 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1kSGmv-0007H1-Sn; Tue, 13 Oct 2020 11:40:09 +0200
Date:   Tue, 13 Oct 2020 11:40:09 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH v2 02/10] nft: Implement nft_chain_foreach()
Message-ID: <20201013094009.GT13016@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20200923174849.5773-1-phil@nwl.cc>
 <20200923174849.5773-3-phil@nwl.cc>
 <20201012120118.GB26845@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201012120118.GB26845@salvia>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Mon, Oct 12, 2020 at 02:01:18PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Sep 23, 2020 at 07:48:41PM +0200, Phil Sutter wrote:
> > This is just a fancy wrapper around nftnl_chain_list_foreach() with the
> > added benefit of detecting invalid table names or uninitialized chain
> > lists. This in turn allows to drop the checks in flush_rule_cache() and
> > ignore the return code of nft_chain_foreach() as it fails only if the
> > dropped checks had failed, too.
> 
> At quick glance, this is reducing the LoC.
> 
> However, I'm not sure this is better, before this code:
> 
> 1) You fetch the list
> 2) You use it from several spots in the function
> 
> with this patch you might look up for the chain list several times in
> the same function.

Hmm. There might be exceptions, but typically we should have a function
that takes an optional chain name and the body roughly looks like this:

| if (chain) {
| 	return do_something(nft_chain_find(..., chain));
| }
| return nft_chain_foreach(..., do_something);

[...]
> I can also see calls to:
> 
> nft_chain_find(h, table, chain);
> 
> and
> 
> nft_chain_foreach(...)
> 
> from the same function.
> 
> This patch also updates paths in very different ways, there is no
> common idiom being replaced.

Which in particular are those?

The overall agenda is that looking up a chain won't be a trivial
nftnl_chain_list lookup anymore. And iterating over a table's chains
won't be a matter of iterating over a list, because I split base-chains
from user-defined ones:

* Base-chains sit in an array of size NF_INET_NUMHOOKS.
* User-defined chains sit in an (open-coded) list ordered by name.

So the old nft_chain_list_get() is not possible anymore, therefore I
replace everything by either nft_chain_find() or nft_chain_foreach().
Functions should not use both in the same code-path, so if you spot that
I should have a close look again.

Cheers, Phil
