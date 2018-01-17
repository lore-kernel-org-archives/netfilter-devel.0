From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH RFC] libnftables: Implement JSON output support
Date: Wed, 17 Jan 2018 13:44:06 +0100
Message-ID: <20180117124406.lil7vr2ypmpkhp5d@salvia>
References: <20180117115140.10751-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38150 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752775AbeAQMoR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Jan 2018 07:44:17 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C2DFB2519A1
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Jan 2018 13:44:15 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 44D1BCF82E
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Jan 2018 13:44:15 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20180117115140.10751-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Phil,

On Wed, Jan 17, 2018 at 12:51:40PM +0100, Phil Sutter wrote:
> Although technically there already is support for JSON output via 'nft
> export json' command, it is hardly useable since it exports all the gory
> details of nftables VM. Also, libnftables has no control over what is
> exported since the content comes directly from libnftnl.

I'm going to apply this:

        http://patchwork.ozlabs.org/patch/844762/

now that nft 0.8.1 is out. Basically, renaming 'nft export json' to
'nft export vm json' so this clearly shows this is the low-level
representation, and we leave room for your high level json
representation.

> Instead, implement JSON format support for regular 'nft list' commands.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
> Note that this is incomplete and merely meant as foundation for a
> discussion about the implementation. A few things I am not happy with:
> 
> * The amount of ifdef's introduced is certainly not optimal, though I
>   don't see how this could be avoided if JSON support is to be kept
>   optional.

Usual trick is to add a header file with function declaration like this:

#ifdef NFT_JSON
int nft_json_parse_blah(...);
#else
static inline int nft_json_parse_blah(...) { return -1; }
#endif

So all ifdef pollution remains only in that json header file. And
place all json code in a single .c file.

> * There is quite some code-duplication involved given that this
>   introduces an alternative function for almost any function in the
>   affected code path.

You mean, a new callback for each expr/datatype? We should not expose
bitwise/byteorder and such, it's too low level.

> * JSON output is completely numeric. While this is intentional as it
>   helps applications parsing e.g. port numbers, other things like e.g.
>   TCP header flags become a bit cryptic.

Can't we have list in json too?
