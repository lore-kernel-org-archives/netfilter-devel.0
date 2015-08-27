From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nftables batch abi broken ...
Date: Thu, 27 Aug 2015 18:46:13 +0200
Message-ID: <20150827164613.GD3431@salvia>
References: <20150827153151.GA17804@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44872 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002AbbH0Qj5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Aug 2015 12:39:57 -0400
Content-Disposition: inline
In-Reply-To: <20150827153151.GA17804@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Aug 27, 2015 at 05:31:51PM +0200, Florian Westphal wrote:
> Hi.
> 
> batch handling in libnftnl uses this:
> libnftnl/src/common.c:  nfg->res_id = NFNL_SUBSYS_NFTABLES;
> 
> It SHOULD be:
> libnftnl/src/common.c:  nfg->res_id = htons(NFNL_SUBSYS_NFTABLES)
> 
> since res_id is a __be16.
> 
> The kernel contains the same error when decoding batch messages
> which is why this works :-/
> 
> I found this problem when looking at sparse error reports on the kernel
> where sparse complains about the following line in nfnetlink_rcv():
> 
>     nfnetlink_rcv_batch(skb, nlh, nfgenmsg->res_id);
> 
> and sparse complaint is correct, __be16 is treated as u16 without
> conversion.
> 
> How to fix this?
> If we want to maintain ABI on Little Endian only solution is to "fix"
> it in kernel by annotating this with explicit cast to u16.
> 
> But it sucks since ->res_id is used via htons/ntohs in all other places
> :-/
> 
> Any ideas?

We only have one subsystem that supports batching at this moment, ie.
nft, so we can add a workaround now, fix userspace and then drop the
workaround from the kernel at some point.
