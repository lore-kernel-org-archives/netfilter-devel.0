From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft] datatype: fix crash when using basetype instead of
 symbolic constants
Date: Thu, 27 Nov 2014 13:05:40 +0000
Message-ID: <20141127130539.GF17326@acer.localdomain>
References: <1417093196-19347-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, christophe.leroy@c-s.fr
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56569 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbaK0NLb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Nov 2014 08:11:31 -0500
Content-Disposition: inline
In-Reply-To: <1417093196-19347-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Nov 27, 2014 at 01:59:56PM +0100, Pablo Neira Ayuso wrote:
> The following example:
> 
>  # nft add rule filter input ct state 8 accept
>  Segmentation fault
> 
> leads to a crash because we have the following datatype relation:
> 
>  ct_state -> bitmask -> integer
> 
> The bitmask, which is an intermediate basetype, has no parse()
> function, this leads to a crash in symbolic_constant_parse().
> 
> So let's default to the leaf basetype parser when the intermediate
> one has no specific parser() function.
> 
> Add a bugtrap too to catch inconsistent datatype configurations.

I think we should just walk down the chain until we find something
with a parse function.
