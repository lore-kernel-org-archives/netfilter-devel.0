From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: RFC: nft.8 review
Date: Tue, 20 Dec 2016 00:53:30 +0100
Message-ID: <20161219235330.GA7565@salvia>
References: <20161210102715.GA2955@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39440 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753093AbcLSXxw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Dec 2016 18:53:52 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 53310764A
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Dec 2016 00:53:48 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 452CEDA843
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Dec 2016 00:53:48 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 020F5DA843
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Dec 2016 00:53:46 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20161210102715.GA2955@orbyte.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Phil,

On Sat, Dec 10, 2016 at 11:27:16AM +0100, Phil Sutter wrote:
> Hi,
> 
> I skimmed through nft man page and noted down problems I discovered.
> While doing so, I got the idea to restructure the whole document for
> better organization and comprehensibility but wanted to hear your
> thoughts first before creating a ticket in netfilter BZ:
> 
> 
> * Use BNF in synopses
> 
> This is rudimentally used in the SYNOPSIS section already, but just
> lists _cmd_ without explanation - although the fun is only about to
> start at this point. :)
> 
> What I really don't like is the syntax used in e.g. CHAINS section: it
> is not only imprecise (nothing says you have to use 'priority <prio>'
> but may not use 'table <table>', but also plain wrong when it comes to
> the mandatory braces around the chain_block.

Right, that needs a fix.

> * Organize entity descriptions BNF-style
> 
> In my opinion the order of (sub-)sections is a bit chaotic at times.
> E.g. RULES section synopsis tries to explain how a rule is made up from
> statements, but these are not explained before five sections later (not
> counting the bogus BLA section ;).
> 
> The idea here is to go from most generic to most specific, like things
> are defined in yacc - just not as explicit, since if I want to know the
> relation between concat_rhs_expr and shift_rhs_expr, I can just as well
> read the code itself.
>
> * What about sub-pages?
> 
> Looking at some expressions' descriptions, it seems like these might
> grow exponentially with the documentation improving. So maybe it makes
> sense to follow iptables' advice and have 'nft-extensions.8'? I would
> have called it 'nft-statements.8' or 'nft-expressions.8' but the two are
> too much intertwined to keep them separate.
> 
> OK, maybe this can wait until nft.8 really has become awfully long.

Yes, let's wait a bit for the split.

> Comments, flame, donations highly appreciated, of course!

Patches are very welcome!
