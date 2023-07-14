Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 152E7C001E0
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Jul 2023 09:59:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234627AbjGNJ7q (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 14 Jul 2023 05:59:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234131AbjGNJ7p (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 14 Jul 2023 05:59:45 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD79E1989
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Jul 2023 02:59:43 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qKFaP-00088l-HB; Fri, 14 Jul 2023 11:59:41 +0200
Date:   Fri, 14 Jul 2023 11:59:41 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft v2 PATCH 3/3] py: add input_{set,get}_flags() API to helpers
Message-ID: <ZLEcjSPnc3PoN57E@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Thomas Haller <thaller@redhat.com>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
References: <ZKxG23yJzlRRPpsO@calendula>
 <20230714084943.1080757-1-thaller@redhat.com>
 <20230714084943.1080757-3-thaller@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230714084943.1080757-3-thaller@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Thomas,

On Fri, Jul 14, 2023 at 10:48:53AM +0200, Thomas Haller wrote:
> Note that the corresponding API for output flags does not expose the
> plain numeric flags. Instead, it exposes the underlying, flag-based C
> API more directly.
> 
> Reasons:
> 
> - a flags property has the benefits that adding new flags is very light
>   weight. Otherwise, every addition of a flag requires new API. That new
>   API increases the documentation and what the user needs to understand.
>   With a flag API, we just need new documentation what the new flag is.
>   It's already clear how to use it.
> 
> - opinionated, also the usage of "many getter/setter API" is not have
>   better usability. Its convenient when we can do similar things (setting
>   a boolean flag) depending on an argument of a function, instead of
>   having different functions.
> 
>   Compare
> 
>      ctx.set_reversedns_output(True)
>      ctx.set_handle_output(True)
> 
>   with
> 
>      ctx.ouput_set_flags(NFT_CTX_OUTPUT_REVERSEDNS | NFT_CTX_OUTPUT_HANDLE)
> 
>   Note that the vast majority of users of this API will just create one
>   nft_ctx instance and set the flags once. Each user application
>   probably has only one place where they call the setter once. So
>   while I think flags have better usability, it doesn't matter much
>   either way.
> 
> - if individual properties are preferable over flags, then the C API
>   should also do that. In other words, the Python API should be similar
>   to the underlying C API.
> 
> - I don't understand how to do this best. Is Nftables.output_flags
>   public API? It appears to be, as it has no underscore. Why does this
>   additional mapping from function (get_reversedns_output()) to name
>   ("reversedns") to number (1<<0) exist?

I don't recall why I chose to add setters/getters for individual output
flags instead of expecting users to do bit-fiddling. Maybe the latter is
not as common among Python users. :)

On the other hand, things are a bit inconsistent already, see
set_debug() method. 

Maybe we could turn __{get,set}_output_flag() public and make them
accept an array of strings or numbers just like set_debug()? If you
then adjust your input flag API accordingly, things become consistent
(enough?), without breaking existing users.

FWIW, I find

| ctx.set_output_flags(["reversedns", "stateless"])

nicer than

| ctx.set_output_flags(REVERSEDNS | STATELESS)

at least with a Python hat on. WDYT?

Cheers, Phil
