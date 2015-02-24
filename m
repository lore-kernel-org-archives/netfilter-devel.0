From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft 1/2] src: complete meta priority support
Date: Tue, 24 Feb 2015 18:15:19 +0000
Message-ID: <20150224181519.GM3713@acer.localdomain>
References: <1424801130-29052-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46553 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153AbbBXSPX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Feb 2015 13:15:23 -0500
Content-Disposition: inline
In-Reply-To: <1424801130-29052-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 24.02, Pablo Neira Ayuso wrote:
> This patch adds the missing bits to scan and parse the meta priority
> string. The output code to list it has been also reworked.
> 
> To match the skbuff priority you can use:
> 
>  nft add rule filter forward meta priority :ffff
>  nft add rule filter forward meta priority ffff:
>  nft add rule filter forward meta priority abcd:1234
> 
> and to set it, you can use:
> 
>  nft add rule filter forward meta priority set abcd:1234
> 
> flex performs longest prefix matching when scanning patterns so there is
> not conflict with IPv6 addresses.
> 
> There's still a possible clash with:
> 
> 	nft add rule filter input tcp dport vmap { 25:accept, 28:drop }
> 
> where "25:acce" and "28:d" are interpreted as a meta priority.
> 
> I think it's reasonable to tell people that they have to separate the
> key and the data that represent the element tuple with a whitespace
> separator between the colon, at least until we find a better way to
> handle this.

I agree that it's not too bad, but still would be preferable to avoid
this.

> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> @Patrick: You proposed an alternative to this time ago:
> 
> http://patchwork.ozlabs.org/patch/320066/
> 
> but after applying a similar patch here, that seem to break many other
> stuff according to the nft-test.py regression tests.

Out of interest, what does it break?
