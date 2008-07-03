From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/2] Fix scalability performance issue during initial
 ruleset parsing.
Date: Thu, 03 Jul 2008 20:33:03 +0200
Message-ID: <486D1B5F.1030900@trash.net>
References: <1215028647.9467.6.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developers <netfilter-devel@vger.kernel.org>
To: jdb@comx.dk
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45088 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbYGCSdE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Jul 2008 14:33:04 -0400
In-Reply-To: <1215028647.9467.6.camel@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jesper Dangaard Brouer wrote:
>  Finding jump chains is slow O(Chain*Rules).
> 
> The problem:
>  is that the chain list is searched lineary for each rule with a jump
>  target. The problem lies in the "second pass" (of function
>  parse_table) where the userchain jump targets are found. For each
>  rule "R" with a IPTCC_R_JUMP target, function
>  iptcc_find_chain_by_offset() searches through the chains "C" in the
>  chain list (worst-case hitting the last one).
> 
> The solution:
>  in this patch is to speed up iptcc_find_chain_by_offset() by using
>  binary search. Reducing complexity from O(C) to O(log C).
> 
> Implementation:
>  Its possible to use the same bsearch algorithm and data structure
>  (chain_index), as used for chain name searching.
> 
> How is that possible:
>  One has to realize that the chains are both sorted by name and
>  offsets, this is because the chains are already sorted in the ruleset
>  from the kernel.

Nice work, and clever :) Applied, thanks.
