From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] src: restore interface to index cache
Date: Sat, 11 Apr 2015 18:15:47 +0100
Message-ID: <20150411171547.GB8539@acer.localdomain>
References: <1428770627-7963-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51999 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbbDKRPv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 11 Apr 2015 13:15:51 -0400
Content-Disposition: inline
In-Reply-To: <1428770627-7963-1-git-send-email-pablo@netfilter.org>
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
> The cache is populated by when nft_if_nametoindex() and nft_if_indextoname()
> are used for first time. Then, it it released in the output path. In the
> interactive mode, it is invalidated after each command.

Looks very good, thanks for your patience :)
