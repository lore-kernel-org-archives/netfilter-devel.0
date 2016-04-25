From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft 0/4] Interval overlap detection for named sets
Date: Mon, 25 Apr 2016 11:38:32 +0100
Message-ID: <20160425103832.GC29560@macbook.localdomain>
References: <1461427720-4939-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54992 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400AbcDYKig (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Apr 2016 06:38:36 -0400
Content-Disposition: inline
In-Reply-To: <1461427720-4939-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 23.04, Pablo Neira Ayuso wrote:
> Hi,
> 
> This patchset adds the missing code to reject overlapping intervals.
> 
>  # nft add table ip filter
>  # nft add set ip filter myset { type ipv4_addr\; flags interval\; }
>  # nft add chain ip filter output { type filter hook output priority 0\; }
>  # nft add rule ip daddr @myset counter packets 0 bytes 0
>  # nft add element ip filter myset { 127.0.0.0/16 }
> 
> Then, if you add an overlapping element:
> 
>  # nft add element ip filter myset { 127.0.0.0/24 }
>  <cmdline>:1:31-42: Error: interval overlaps with an existing one
>  add element ip filter myset { 127.0.0.0/24 }
>                                ^^^^^^^^^^^^
> 
> The new validation code from userspace rejects this to avoid shadowing
> issues.

This is actually intended. There is no issue with shadowing since sets only
contain one statement, present or not present. For maps something like this
does make sense, but for sets it only makes it harder to use.

Generally, we have a conflict resolution based on size, the more specific
element wins. The assumption being that if you add something generic and
something more specific, the more specific item is an exception to the
more generic one. 

> Pablo Neira Ayuso (4):
>   segtree: set expr->len for prefix expression from interval_map_decompose()
>   segtree: add expr_to_intervals()
>   segtree: rename set expression set_to_segtree()
>   segtree: add interval overlap detection for dynamic updates
> 
>  src/segtree.c | 92 +++++++++++++++++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 80 insertions(+), 12 deletions(-)
> 
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
