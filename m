From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft v2 00/18] introducing libnftables
Date: Mon, 21 Aug 2017 10:55:11 +0200
Message-ID: <20170821085511.GA3615@salvia>
References: <20170819152420.22563-1-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:53452 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751895AbdHUIzk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Aug 2017 04:55:40 -0400
Content-Disposition: inline
In-Reply-To: <20170819152420.22563-1-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Eric,

First off, I appreciate the time you took to work on this.

On Sat, Aug 19, 2017 at 05:24:02PM +0200, Eric Leblond wrote:
> 
> Hello,
> 
> This patchset is the second version of libnftables introduction patchset.
> It addresses some remarks by Phil Sutter. Other remarks as said on the ML
> are in fact TODO points that can be adressed later.
> 
> This patchset also fixes issues with error handling and adds documentation
> in doxygen format. An output is available here if you wanna have a look:
>  http://home.regit.org/~regit/libnftables/html/group__libnftables.html

This is now a smaller patchset that the one that you posted in
previous NFWS for nftables-0.5, so I think we're giving the right
steps towards the library.

> The first two patches are a bugfix and a helper function that is needed
> for the library:
>  * [PATH nft v2 01/18] mnl: fix error handling in mnl_batch_talk
>  * [PATH nft v2 02/18] erec: add function to free list
> 
> As mentioned by Arturo, this is not meant to be added into nftables v0.8 but
> it is a good candidate for early introduction in the branch as soon as the
> v0.8 release is done. 
> 
> I did not managed to incorporate some suggestions done privately by Pablo. For
> instance there is an nf_sock in the struct nft_ctx. I did not change any
> existing internal so it is still possible to do it as incremental patches.

I'd rather do the other way around... Let's agree on what preparation
patches need to get in, then submit a final patch to expose the
library API and documentation.

Please, we shouldn't assume noone is going to consider this API
unstable once we push it upstream...

And I really don't know / I can't forecast what resources we will have
here to work / fix things before this go public... so worst case can
that we take X years to fix remaining issues...

Please, no need to rush.
