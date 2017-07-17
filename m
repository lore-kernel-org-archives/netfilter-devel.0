From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 0/7] some memory leak fixes
Date: Mon, 17 Jul 2017 17:24:15 +0200
Message-ID: <20170717152415.GA26229@salvia>
References: <20170710223255.29885-1-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60678 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751280AbdGQPYY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jul 2017 11:24:24 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 798B7249C2
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jul 2017 17:24:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 695B01B3D59
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jul 2017 17:24:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1C16B1B3D59
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jul 2017 17:24:09 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170710223255.29885-1-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jul 11, 2017 at 12:32:48AM +0200, Eric Leblond wrote:
> 
> Hi,
> 
> Here's a small patchset fixing some memory leaks in nftables. Most
> of them have been found using ASAN.

Series applied, thanks Eric.

> There is still a problem in memory handling due to the max_errors
> system that stack errors to avoid an exit on first error. The
> consequence is that the bison parser is loosing track of its
> internal stacks and can not call the destructors when there
> is an error in the command.

Probably we need explicit object tracking via list insertion, then
rewind and release them? Would that be possible? I would expect this
triggers a large patchset to do this right.

> If we do set max_errors to 1: 
> 
>  diff --git a/src/main.c b/src/main.c
>  index 7fbf00a..183bd0e 100644
>  --- a/src/main.c
>  +++ b/src/main.c
>  @@ -29,7 +29,7 @@
>   #include <cli.h>
>   
>   static struct nft_ctx nft;
>  -unsigned int max_errors = 10;
>  +unsigned int max_errors = 1;
>   #ifdef DEBUG
>   unsigned int debug_level;
>   #endif
> 
> Then there is no more memory leak in case of an invalid command
> but we loose the display of multiple errors.
> 
> A possibleway to fix that would be to be able to set max_errors
> via a configuration function. It would be set to 1 by default.
> So users of libnftables will not experiment memleak but we
> could keep the same behavior in nft by setting it to 10
> explicetely.

I would prefer we find a way to fix this without adding this
limitation.

Let me know, thanks!
