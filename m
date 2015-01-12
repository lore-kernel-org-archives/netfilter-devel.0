From: Patrick McHardy <kaber@trash.net>
Subject: Re: Accounting objects support in nft
Date: Mon, 12 Jan 2015 11:39:27 +0000
Message-ID: <20150112113926.GA3491@acer.localdomain>
References: <cover.1421059192.git.ana@soleta.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: ana@soleta.eu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34526 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbbALLjc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Jan 2015 06:39:32 -0500
Content-Disposition: inline
In-Reply-To: <cover.1421059192.git.ana@soleta.eu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 12.01, ana@soleta.eu wrote:
> From: Ana Rey Botello <ana@soleta.eu>
> 
> Hi,
> 
> With this patchset, we add accounting objects support to let us
> manipulate extended accounting objects.
> 
> Example of use in nft:
> 
>  # nft add acct ip filter http-traffic
>  # nft add acct ip filter https-traffic
> 
>  # nft add rule ip filter output tcp dport 80 acct http-traffic
>  # nft add rule ip filter output tcp dport 443 acct https-traffic

I'm wondering whether we really should use a new keyword for this
or do something similar to sets where we have named and anonymous
variants.

An alternative would be:

nft add counter ip filter http-traffic
nft filter output tcp dport 80 counter http-traffic

It is after all just a named counter, so it seems clearer to me to
reuse the keyword.
