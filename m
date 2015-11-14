From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH RFC] netfilter: nf_tables: extend tracing infrastructure
Date: Sat, 14 Nov 2015 18:50:20 +0000
Message-ID: <20151114185020.GA7448@macbook.localdomain>
References: <20151109133608.GD8098@macbook.localdomain>
 <1447343209-28029-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:45053 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751533AbbKNSu0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 14 Nov 2015 13:50:26 -0500
Content-Disposition: inline
In-Reply-To: <1447343209-28029-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 12.11, Florian Westphal wrote:
> RFC for the kernel-side of the tracing changes.
> 
>  The first 128 bytes of the packet data is also dumped to userspace, currently
>  limited to when we do the initial 'skb->nf_trace=1' assignment in nft_meta.c
> 
>  Patrick, I saw your idea wrt. dumping register contents instead, but it
>  seems both complex and 'backwards' to me -- isn't the 'meta set nftrace'
>  rule already a selector, i.e. user would say something like
> 
>  'tcp port 22 limit rate 1/second meta nftrace set 1'
> 
>  So I'm not sure its right to extend nftrace with additional selectors (its
>  also possible that I failed to understand what you were suggesting 8-} )

Yeah, it was about the data that we dump, to make that explicitly selectable.
The idea was that you could explicitly specify to dump lets say tcp dport, skuid
and cpu number. But it might not work since we'd have to propagate that
selection along with the packet, so I guess, please forget about it :)
