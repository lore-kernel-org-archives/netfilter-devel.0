From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/2] netfilter: nft_rbtree: fix data handling of end
 interval elements
Date: Fri, 7 Feb 2014 13:20:14 +0000
Message-ID: <20140207132014.GA21147@macbook.localnet>
References: <1391778947-8957-1-git-send-email-pablo@netfilter.org>
 <1391778947-8957-2-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44399 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755689AbaBGNUS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Feb 2014 08:20:18 -0500
Content-Disposition: inline
In-Reply-To: <1391778947-8957-2-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Feb 07, 2014 at 02:15:47PM +0100, Pablo Neira Ayuso wrote:
> This patch fixes several things which related to the handling of
> end interval elements:
> 
> * Chain use underflow with intervals and map: If you add a rule
>   using intervals+map that introduces a loop, the error path of the
>   rbtree set decrements the chain refcount for each side of the
>   interval, leading to a chain use counter underflow.
> 
> * Don't copy the data part of the end interval element since, this
>   area is uninitialized and this confuses the loop detection code.
> 
> * Don't allocate room for the data part of end interval elements
>   since this is unused.
> 
> So, after this patch the idea is that end interval elements don't
> have a data part.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> This patch extends http://patchwork.ozlabs.org/patch/317485/.
> 
> @Patrick, you mentioned also that nft_hash needs to be adjusted, but
> after looking at this again I think there's no problem there since
> hash cannot currently be selected for interval sets. Thanks for your
> comments on the initial patch :)


Correct, just noticed that myself :)

Acked-by: Patrick McHardy <kaber@trash.net>

for both patches.
