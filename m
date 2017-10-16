From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: libnftables, next steps
Date: Mon, 16 Oct 2017 12:19:51 +0200
Message-ID: <20171016101904.GA32102@salvia>
References: <20171004225152.GD32278@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        Eric Leblond <eric@regit.org>, Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57064 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751814AbdJPKUB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Oct 2017 06:20:01 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5B270EDB01
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Oct 2017 12:19:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4A9A1DA385
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Oct 2017 12:19:58 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20171004225152.GD32278@orbyte.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Phil,

Sorry it took a while to get back to you.

On Thu, Oct 05, 2017 at 12:51:52AM +0200, Phil Sutter wrote:
> Hi!
> 
> I rebased Eric's libnftables patch series onto current master to get an
> overview of what's still missing (and what I could work on :). Here's
> what I collected:
> 
> * Implement application accessible batch support.
>   -> This basically splits nft_run() into stages.
>   -> I would change nft_run_cmd_from_*() to use this internally.
>   -> Do we want this in the early library version or is this going to be
>      part of the 'advanced API' to add later?

I would leave this behind. Let's just start with the most simple API,
then we move on.

> * Add erec_free_list().
>   -> This becomes handy if the application wants to drop erec list
>      without printing it (erec_print_list() clears the list while
>      traversing it).
>
>   -> No use for this if we only export nft_run_cmd_from_*() functions.

OK, so this is part of the advanced API then.

> * Create src/nftables_common.c and include/nftables_common.h to hold
>   nft_run() and nft_netlink().

Why not just place this in src/libnftables.c?

>   -> Is this meant as the (not exported) high-level library backend?
>   -> If batch support is implemented, these could be removed after
>      changing nft_run_cmd_from_*() and cli_complete() to use it.
> 
> * Move library routines from src/main.c into src/libnftables.c and
>   create include/nftables/nftables.h to hold the signatures.
> 
> * Introduce the library (i.e., generate libnftables.so).
> 
> Some additional thoughts:
> 
> * Should we support different output streams for debug and/or error
>   messages?

What usecase you have in mind for this?

> * Should we reuse src/erec.c for regular output as well? (This probably
>   needs a 'print immediately' switch for monitor mode, though.)

Again, same question.

> Feedback highly appreciated, of course! Should I start with moving the
> library stuff into libnftables.{c,h} so we get an impression of what the
> API will look like?

I think Eric doesn't have time at this stage, so if you can take his
patches, revamp and resubmit, that would be great.

Thanks!
