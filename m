Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADE60EB64D7
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Jun 2023 14:15:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232596AbjFTOPk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 20 Jun 2023 10:15:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232480AbjFTOPj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Jun 2023 10:15:39 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B163E60
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Jun 2023 07:15:38 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qBc8u-0000wV-Ka; Tue, 20 Jun 2023 16:15:36 +0200
Date:   Tue, 20 Jun 2023 16:15:36 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nf PATCH] netfilter: nf_tables: Fix for deleting base chains
 with payload
Message-ID: <ZJG0iM6VDhs+pkz0@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20230616155611.2468-1-phil@nwl.cc>
 <ZI8b1ySlPjUucbdH@calendula>
 <ZJAYHMk/HCUvnwIn@calendula>
 <ZJAYzHYDnqcbq05B@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZJAYzHYDnqcbq05B@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jun 19, 2023 at 10:58:52AM +0200, Pablo Neira Ayuso wrote:
> On Mon, Jun 19, 2023 at 10:55:59AM +0200, Pablo Neira Ayuso wrote:
> > On Sun, Jun 18, 2023 at 04:59:38PM +0200, Pablo Neira Ayuso wrote:
> > > Hi Phil,
> > > 
> > > On Fri, Jun 16, 2023 at 05:56:11PM +0200, Phil Sutter wrote:
> > > > When deleting a base chain, iptables-nft simply submits the whole chain
> > > > to the kernel, including the NFTA_CHAIN_HOOK attribute. The new code
> > > > added by fixed commit then turned this into a chain update, destroying
> > > > the hook but not the chain itself.
> > > > 
> > > > Detect the situation by checking if the chain's hook list becomes empty
> > > > after removing all submitted hooks from it. A base chain without hooks
> > > > is pointless, so revert back to deleting the chain.
> > > > 
> > > > Note the 'goto err_chain_del_hook', error path takes care of undoing the
> > > > hook_list modification and releasing the unused chain_hook.
> > > 
> > > Could you give a try to this alternative patch?

Ah, I guess my fix breaks temporary removal of a single interface from a
netdev chain?

> > This is the full patch.

Works fine, iptables testsuite is back to normal again. :)

> I forgot to mangle the patch description describing the new approach.

> From 3da13f15a02e065e12080f2d66f81289aa6ebd69 Mon Sep 17 00:00:00 2001
> From: Phil Sutter <phil@nwl.cc>
> Date: Fri, 16 Jun 2023 17:56:11 +0200
> Subject: [PATCH] netfilter: nf_tables: Fix for deleting base chains with
>  payload
> 
> When deleting a base chain, iptables-nft simply submits the whole chain
> to the kernel, including the NFTA_CHAIN_HOOK attribute. The new code
> added by fixed commit then turned this into a chain update, destroying
> the hook but not the chain itself. Detect the situation by checking if
> the chain is either the netdev or inet/ingress type.

I'd change the last sentence to "Avoid the situation by applying the new
logic to base chains in netdev family or inet family ingress hook." But
feel free to push as-is, I'm just nit-picking here. :)

Thanks, Phil
