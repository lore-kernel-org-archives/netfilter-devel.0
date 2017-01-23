From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 0/3] Boolean comparison and exthdr existence match
 support
Date: Mon, 23 Jan 2017 13:57:47 +0100
Message-ID: <20170123125747.GA2017@salvia>
References: <20170117221007.14951-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40394 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750703AbdAWM54 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 23 Jan 2017 07:57:56 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 89E4815AEAB
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Jan 2017 13:57:54 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7B9ED1B30BC
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Jan 2017 13:57:54 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 551A41B306C
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Jan 2017 13:57:52 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170117221007.14951-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Phil,

On Tue, Jan 17, 2017 at 11:10:04PM +0100, Phil Sutter wrote:
> The following series adds two distinct features to nftables, though
> since the second one depends on presence of the first one this is
> submitted as a series.
> 
> Patch 1 adds support for a boolean variant of relational expression.
> It's OP is strictly implicit and determined by RHS being a boolean
> expression. It depends on a related kernel patch adding support for
> NFT_CMP_BOOL to nft_cmp.c.

If the problem is that we lack of context from the delinearize path,
then I would prefer if you scratch one bit from the fib flags to
indicate that we want a true (1)/false (0) return value. Just like we
plan to do with exthdr. This should require a small kernel patch for
nft_fib I think.

Thus, we can skip this ad hoc update for nft_cmp which seems to me
that it's only there to help us get the context that we lack from the
delinearize step.

Then, from the delinearize path, if this fib/exthdr flag is set, we
attach the corresponding datatype to the expression based on this new
flag.

Thanks.
