From: Patrick McHardy <kaber@trash.net>
Subject: Re: GIT: [PATCH v3 0/3] netfilter trace infrastructure support
Date: Fri, 27 Nov 2015 18:55:16 +0000
Message-ID: <20151127185516.GA18898@macbook.localdomain>
References: <1448649800-26153-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49395 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755017AbbK0SzU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Nov 2015 13:55:20 -0500
Content-Disposition: inline
In-Reply-To: <1448649800-26153-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 27.11, Florian Westphal wrote:
> 3rd round.
> 
> See the individual patches for changelog vs. V 2.
> 
> Patrick: Nothing fancy from libnftnl side, just the 3 new attributes
> (oiftype, nfproto, policy).
> 
> On kernel side I addressed all of the comments.
> 
> In case of NFPROTO_INET, the new NFTA_TRACE_NFPROTO will be 'NFPROTO_IPV4'
> (or IPV6), the netlink header family is set to NFPROTO_INET.

That's sounds good.

> I tried to reduce nft_do_chain bloat, +80 on my system.

That's even better than I expected, thanks!

> We have one unconditional foo = false assignment, all nftrace calls
> are avoided in 'no trace rules set' case via static key.
> 
> Let me know if you spot more problems.

I'll review it tommorrow if you don't mind, currently trying to wrap my
head around the sub-byte and offset expressions. We have some limitations
which I'd like to address if I'm already working in that area before I
continue on the tracing part.
