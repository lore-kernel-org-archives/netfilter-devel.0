From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft v3] src: restore interface to index cache
Date: Sat, 11 Apr 2015 14:12:59 +0100
Message-ID: <20150411131259.GB15268@acer.localdomain>
References: <1428757908-8382-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:50511 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932759AbbDKNNE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 11 Apr 2015 09:13:04 -0400
Content-Disposition: inline
In-Reply-To: <1428757908-8382-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 11.04, Pablo Neira Ayuso wrote:
> From: Pablo Neira <pablo@netfilter.org>
> 
> nftables used to have a cache to speed up interface name <-> index lookup,
> restore it using libmnl.
> 
> This reduces netlink traffic since if_nametoindex() and if_indextoname() open,
> send a request, receive the list of interface and close a netlink socket for
> each call.  I think this is also good for consistency since nft -f will operate
> with the same index number when reloading the ruleset.
> 
> For the interactive mode, we fall back on if_nametoindex() and if_indextoname()
> to make sure that we always get fresh interface name to index mappings.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> v3: Fall back to if_nametoindex() and if_indextoname() in interactive mode.

That seems like a good way. One more suggestions - how about only doing
a cache fill on the first invocation? That way we can avoid it in many
cases, f.i. set listings, some times for rulesets as well, flushing, ...
