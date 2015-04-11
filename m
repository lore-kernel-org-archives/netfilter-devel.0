From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft v4] src: restore interface to index cache
Date: Sat, 11 Apr 2015 17:16:08 +0100
Message-ID: <20150411161607.GA8539@acer.localdomain>
References: <1428768259-5810-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51626 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231AbbDKQQM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 11 Apr 2015 12:16:12 -0400
Content-Disposition: inline
In-Reply-To: <1428768259-5810-1-git-send-email-pablo@netfilter.org>
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
> In the interactive mode, the first call to nft_if_nametoindex() and
> nft_if_indextoname() updates the cache, then follow up calls will use what they
> find in the cache. By when the command is complete, the cache is invalidated.

Not sure if this is based on my suggestion. It makes sense of course, but
what I meant was:

> +unsigned int nft_if_nametoindex(const char *name)
> +{
> +	struct iface *iface;
> +
> +	if (interactive && !iface_cache_init)
> +		iface_cache_update();

To only update the cache if it is actually needed, so update here always
if !iface_cache_init (independant of interactive) and remove the unconditional
update from main(). Basically the only difference would be that non-interactive
mode does no invalidation.

There are many cases where interfaces are not used, like listing rules
without ifindex use, anything related to sets, chains, ..., so we can
avoid filling the cache if it is not needed.

Besides that looks very good.
